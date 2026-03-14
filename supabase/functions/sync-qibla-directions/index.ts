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

interface QiblaInfoResponse {
  success: boolean;
  data: {
    Derece: number;
    Enlem: number;
    Boylam: number;
  };
}

interface CityResponse {
  success: boolean;
  data: Array<{
    SehirID: number;
    SehirAdi: string;
  }>;
}

interface DistrictResponse {
  success: boolean;
  data: Array<{
    IlceID: number;
    IlceAdi: string;
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

    const citiesResponse = await fetch('https://api.diyanet.gov.tr/api/PrayerTime/Cities', {
      headers: { 'Authorization': `Bearer ${token}` },
    });
    const citiesData: CityResponse = await citiesResponse.json();
    const cities = citiesData.success ? citiesData.data : [];

    let totalSynced = 0;
    const errors = [];

    for (const city of cities) {
      try {
        const districtsResponse = await fetch(
          `https://api.diyanet.gov.tr/api/PrayerTime/Districts/${city.SehirID}`,
          {
            headers: { 'Authorization': `Bearer ${token}` },
          }
        );
        const districtsData: DistrictResponse = await districtsResponse.json();
        const districts = districtsData.success ? districtsData.data : [];

        for (const district of districts) {
          try {
            const qiblaResponse = await fetch(
              `https://api.diyanet.gov.tr/api/Qibla/QiblaInfo/${district.IlceID}`,
              {
                headers: { 'Authorization': `Bearer ${token}` },
              }
            );

            const qiblaData: QiblaInfoResponse = await qiblaResponse.json();

            if (qiblaData.success) {
              const { error } = await supabase
                .from('qibla_directions')
                .upsert({
                  city: city.SehirAdi,
                  district: district.IlceAdi,
                  latitude: qiblaData.data.Enlem,
                  longitude: qiblaData.data.Boylam,
                  qibla_degree: qiblaData.data.Derece,
                }, {
                  onConflict: 'city,district',
                });

              if (error) {
                errors.push({
                  city: city.SehirAdi,
                  district: district.IlceAdi,
                  error: error.message
                });
              } else {
                totalSynced++;
              }
            }

            await new Promise(resolve => setTimeout(resolve, 300));
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
      cache_type: 'qibla',
      last_fetch: new Date().toISOString(),
      status: errors.length > 0 ? 'partial_success' : 'success',
      error_message: errors.length > 0 ? JSON.stringify(errors.slice(0, 10)) : '',
    }, {
      onConflict: 'cache_type',
    });

    return new Response(
      JSON.stringify({
        success: true,
        message: `${totalSynced} qibla directions synced`,
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
    console.error('Sync qibla directions error:', error);

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    await supabase.from('api_cache_status').upsert({
      cache_type: 'qibla',
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
