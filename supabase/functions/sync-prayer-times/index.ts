import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'jsr:@supabase/supabase-js@2';

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

interface DiyanetAuthResponse {
  token: string;
  success: boolean;
}

interface DiyanetPrayerTimeResponse {
  success: boolean;
  data: {
    Imsak: string;
    Gunes: string;
    Ogle: string;
    Ikindi: string;
    Aksam: string;
    Yatsi: string;
    MiladiTarih: string;
    HicriTarih: string;
  };
}

interface CityResponse {
  success: boolean;
  data: Array<{
    SehirID: number;
    SehirAdi: string;
    SehirAdiEn: string;
  }>;
}

interface DistrictResponse {
  success: boolean;
  data: Array<{
    IlceID: number;
    IlceAdi: string;
    IlceAdiEn: string;
  }>;
}

async function getDiyanetToken(): Promise<string> {
  const authResponse = await fetch('https://api.diyanet.gov.tr/api/Auth/Login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      username: Deno.env.get('DIYANET_API_USERNAME'),
      password: Deno.env.get('DIYANET_API_PASSWORD'),
    }),
  });

  const authData: DiyanetAuthResponse = await authResponse.json();

  if (!authData.success || !authData.token) {
    throw new Error('Diyanet API authentication failed');
  }

  return authData.token;
}

async function getCities(token: string) {
  const response = await fetch('https://api.diyanet.gov.tr/api/PrayerTime/Cities', {
    headers: { 'Authorization': `Bearer ${token}` },
  });

  const data: CityResponse = await response.json();
  return data.success ? data.data : [];
}

async function getDistricts(token: string, cityId: number) {
  const response = await fetch(`https://api.diyanet.gov.tr/api/PrayerTime/Districts/${cityId}`, {
    headers: { 'Authorization': `Bearer ${token}` },
  });

  const data: DistrictResponse = await response.json();
  return data.success ? data.data : [];
}

async function getPrayerTimesForDistrict(
  token: string,
  districtId: number,
  districtName: string,
  cityName: string,
  days: number = 30
) {
  const prayerTimesData = [];
  const startDate = new Date();
  const endDate = new Date();
  endDate.setDate(endDate.getDate() + days);

  for (let d = new Date(startDate); d <= endDate; d.setDate(d.getDate() + 1)) {
    const dateStr = d.toISOString().split('T')[0];

    try {
      const response = await fetch(
        `https://api.diyanet.gov.tr/api/PrayerTime/Daily/${districtId}?date=${dateStr}`,
        {
          headers: { 'Authorization': `Bearer ${token}` },
        }
      );

      const data: DiyanetPrayerTimeResponse = await response.json();

      if (data.success) {
        prayerTimesData.push({
          city: cityName,
          district: districtName,
          date: dateStr,
          times: {
            imsak: data.data.Imsak,
            gunes: data.data.Gunes,
            ogle: data.data.Ogle,
            ikindi: data.data.Ikindi,
            aksam: data.data.Aksam,
            yatsi: data.data.Yatsi,
          },
        });
      }

      await new Promise(resolve => setTimeout(resolve, 500));
    } catch (error) {
      console.error(`Error fetching prayer times for ${cityName}/${districtName} on ${dateStr}:`, error);
    }
  }

  return prayerTimesData;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    const token = await getDiyanetToken();

    const url = new URL(req.url);
    const limitCities = url.searchParams.get('limit_cities');
    const specificCity = url.searchParams.get('city');

    let citiesToSync;

    if (specificCity) {
      const allCities = await getCities(token);
      citiesToSync = allCities.filter(city =>
        city.SehirAdi.toLowerCase().includes(specificCity.toLowerCase())
      );
    } else if (limitCities) {
      const majorCities = ['İstanbul', 'Ankara', 'İzmir', 'Bursa', 'Antalya', 'Adana', 'Konya'];
      const allCities = await getCities(token);
      citiesToSync = allCities.filter(city => majorCities.includes(city.SehirAdi));
    } else {
      citiesToSync = await getCities(token);
    }

    let totalSynced = 0;
    const errors = [];

    for (const city of citiesToSync) {
      try {
        const districts = await getDistricts(token, city.SehirID);

        for (const district of districts) {
          try {
            const prayerTimes = await getPrayerTimesForDistrict(
              token,
              district.IlceID,
              district.IlceAdi,
              city.SehirAdi,
              30
            );

            if (prayerTimes.length > 0) {
              const { error } = await supabase
                .from('prayer_times')
                .upsert(prayerTimes, {
                  onConflict: 'city,district,date',
                });

              if (error) {
                errors.push({ city: city.SehirAdi, district: district.IlceAdi, error: error.message });
              } else {
                totalSynced += prayerTimes.length;
              }
            }

            await new Promise(resolve => setTimeout(resolve, 100));
          } catch (districtError) {
            errors.push({
              city: city.SehirAdi,
              district: district.IlceAdi,
              error: (districtError as Error).message
            });
          }
        }

        await new Promise(resolve => setTimeout(resolve, 500));
      } catch (cityError) {
        errors.push({ city: city.SehirAdi, error: (cityError as Error).message });
      }
    }

    await supabase.from('api_cache_status').upsert({
      cache_type: 'prayer_times',
      last_fetch: new Date().toISOString(),
      status: errors.length > 0 ? 'partial_success' : 'success',
      error_message: errors.length > 0 ? JSON.stringify(errors.slice(0, 10)) : '',
    }, {
      onConflict: 'cache_type',
    });

    return new Response(
      JSON.stringify({
        success: true,
        message: `${totalSynced} prayer times synced for ${citiesToSync.length} cities`,
        errors: errors.length > 0 ? errors.slice(0, 10) : undefined,
      }),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
      }
    );
  } catch (error) {
    console.error('Sync prayer times error:', error);

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    await supabase.from('api_cache_status').upsert({
      cache_type: 'prayer_times',
      last_fetch: new Date().toISOString(),
      status: 'failed',
      error_message: (error as Error).message,
    }, {
      onConflict: 'cache_type',
    });

    return new Response(
      JSON.stringify({ success: false, error: (error as Error).message }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
      }
    );
  }
});
