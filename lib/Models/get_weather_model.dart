// To parse this JSON data, do
//
//     final getWeatherModel = getWeatherModelFromJson(jsonString);

import 'dart:convert';

GetWeatherModel getWeatherModelFromJson(String str) =>
    GetWeatherModel.fromJson(json.decode(str));

String getWeatherModelToJson(GetWeatherModel data) =>
    json.encode(data.toJson());

class GetWeatherModel {
  String responseMessage;
  ResponseData responseData;

  GetWeatherModel({
    this.responseMessage,
    this.responseData,
  });

  factory GetWeatherModel.fromJson(Map<String, dynamic> json) =>
      GetWeatherModel(
        responseMessage: json["responseMessage"],
        responseData: ResponseData.fromJson(json["responseData"]),
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "responseData": responseData.toJson(),
      };
}

class ResponseData {
  Location location;
  CurrentObservation currentObservation;
  List<Forecast> forecasts;

  ResponseData({
    this.location,
    this.currentObservation,
    this.forecasts,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        location: Location.fromJson(json["location"]),
        currentObservation:
            CurrentObservation.fromJson(json["current_observation"]),
        forecasts: List<Forecast>.from(
            json["forecasts"].map((x) => Forecast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "current_observation": currentObservation.toJson(),
        "forecasts": List<dynamic>.from(forecasts.map((x) => x.toJson())),
      };
}

class CurrentObservation {
  Wind wind;
  Atmosphere atmosphere;
  Astronomy astronomy;
  Condition condition;
  int pubDate;

  CurrentObservation({
    this.wind,
    this.atmosphere,
    this.astronomy,
    this.condition,
    this.pubDate,
  });

  factory CurrentObservation.fromJson(Map<String, dynamic> json) =>
      new CurrentObservation(
        wind: Wind.fromJson(json["wind"]),
        atmosphere: Atmosphere.fromJson(json["atmosphere"]),
        astronomy: Astronomy.fromJson(json["astronomy"]),
        condition: Condition.fromJson(json["condition"]),
        pubDate: json["pubDate"],
      );

  Map<String, dynamic> toJson() => {
        "wind": wind.toJson(),
        "atmosphere": atmosphere.toJson(),
        "astronomy": astronomy.toJson(),
        "condition": condition.toJson(),
        "pubDate": pubDate,
      };
}

class Astronomy {
  String sunrise;
  String sunset;

  Astronomy({
    this.sunrise,
    this.sunset,
  });

  factory Astronomy.fromJson(Map<String, dynamic> json) => new Astronomy(
        sunrise: json["sunrise"],
        sunset: json["sunset"],
      );

  Map<String, dynamic> toJson() => {
        "sunrise": sunrise,
        "sunset": sunset,
      };
}

class Atmosphere {
  int humidity;
  double visibility;
  double pressure;
  int rising;

  Atmosphere({
    this.humidity,
    this.visibility,
    this.pressure,
    this.rising,
  });

  factory Atmosphere.fromJson(Map<String, dynamic> json) => new Atmosphere(
        humidity: json["humidity"],
        visibility: json["visibility"],
        pressure: json["pressure"].toDouble(),
        rising: json["rising"],
      );

  Map<String, dynamic> toJson() => {
        "humidity": humidity,
        "visibility": visibility,
        "pressure": pressure,
        "rising": rising,
      };
}

class Condition {
  String text;
  int code;
  int temperature;

  Condition({
    this.text,
    this.code,
    this.temperature,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => new Condition(
        text: json["text"],
        code: json["code"],
        temperature: json["temperature"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "code": code,
        "temperature": temperature,
      };
}

class Wind {
  int chill;
  int direction;
  double speed;

  Wind({
    this.chill,
    this.direction,
    this.speed,
  });

  factory Wind.fromJson(Map<String, dynamic> json) => new Wind(
        chill: json["chill"],
        direction: json["direction"],
        speed: json["speed"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "chill": chill,
        "direction": direction,
        "speed": speed,
      };
}

class Forecast {
  String day;
  int date;
  int low;
  int high;
  String text;
  int code;

  Forecast({
    this.day,
    this.date,
    this.low,
    this.high,
    this.text,
    this.code,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) => new Forecast(
        day: json["day"],
        date: json["date"],
        low: json["low"],
        high: json["high"],
        text: "text",
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "date": date,
        "low": low,
        "high": high,
        "text": text,
        "code": code,
      };
}

class Location {
  int woeid;
  String city;
  String region;
  String country;
  double lat;
  double long;
  String timezoneId;

  Location({
    this.woeid,
    this.city,
    this.region,
    this.country,
    this.lat,
    this.long,
    this.timezoneId,
  });

  factory Location.fromJson(Map<String, dynamic> json) => new Location(
        woeid: json["woeid"],
        city: json["city"],
        region: json["region"],
        country: json["country"],
        lat: json["lat"].toDouble(),
        long: json["long"].toDouble(),
        timezoneId: json["timezone_id"],
      );

  Map<String, dynamic> toJson() => {
        "woeid": woeid,
        "city": city,
        "region": region,
        "country": country,
        "lat": lat,
        "long": long,
        "timezone_id": timezoneId,
      };
}
