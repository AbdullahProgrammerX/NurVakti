class PrayerTimeModel {
  final String city;
  final String district;
  final DateTime date;
  final PrayerTimesModel times;

  const PrayerTimeModel({
    required this.city,
    required this.district,
    required this.date,
    required this.times,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      city: json['city'] as String,
      district: json['district'] as String,
      date: DateTime.parse(json['date'] as String),
      times: PrayerTimesModel.fromJson(json['times'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'district': district,
      'date': date.toIso8601String(),
      'times': times.toJson(),
    };
  }
}

class PrayerTimesModel {
  final String imsak;
  final String gunes;
  final String ogle;
  final String ikindi;
  final String aksam;
  final String yatsi;

  const PrayerTimesModel({
    required this.imsak,
    required this.gunes,
    required this.ogle,
    required this.ikindi,
    required this.aksam,
    required this.yatsi,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimesModel(
      imsak: json['imsak'] as String,
      gunes: json['gunes'] as String,
      ogle: json['ogle'] as String,
      ikindi: json['ikindi'] as String,
      aksam: json['aksam'] as String,
      yatsi: json['yatsi'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imsak': imsak,
      'gunes': gunes,
      'ogle': ogle,
      'ikindi': ikindi,
      'aksam': aksam,
      'yatsi': yatsi,
    };
  }

  String getTime(PrayerType type) {
    switch (type) {
      case PrayerType.imsak:
        return imsak;
      case PrayerType.gunes:
        return gunes;
      case PrayerType.ogle:
        return ogle;
      case PrayerType.ikindi:
        return ikindi;
      case PrayerType.aksam:
        return aksam;
      case PrayerType.yatsi:
        return yatsi;
    }
  }
}

enum PrayerType {
  imsak,
  gunes,
  ogle,
  ikindi,
  aksam,
  yatsi;

  String get displayName {
    switch (this) {
      case PrayerType.imsak:
        return 'İmsak';
      case PrayerType.gunes:
        return 'Güneş';
      case PrayerType.ogle:
        return 'Öğle';
      case PrayerType.ikindi:
        return 'İkindi';
      case PrayerType.aksam:
        return 'Akşam';
      case PrayerType.yatsi:
        return 'Yatsı';
    }
  }

  String get emoji {
    switch (this) {
      case PrayerType.imsak:
        return '🌙';
      case PrayerType.gunes:
        return '🌅';
      case PrayerType.ogle:
        return '☀️';
      case PrayerType.ikindi:
        return '🌤';
      case PrayerType.aksam:
        return '🌇';
      case PrayerType.yatsi:
        return '🌃';
    }
  }
}
