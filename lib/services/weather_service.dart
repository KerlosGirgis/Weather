import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;
class WeatherService{
  late String _providedCity;

  String get providedCity => _providedCity;

  set providedCity(String value) {
    _providedCity = value;
  }

  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  Future<Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('$baseUrl?q=$cityName&units=metric&appid=f5985bd2454d138585b9dcc7d3eaf432'));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode==200){
      return Weather.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Failed to load weather data");
    }
  }
  Future<Weather> getWeatherSearchBar() async{
    final response = await http.get(Uri.parse('$baseUrl?q=$_providedCity&units=metric&appid=f5985bd2454d138585b9dcc7d3eaf432'));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode==200){
      return Weather.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Failed to load weather data");
    }
  }
  Future<String> getCurrentCity() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
    //var address = await GeoCode().reverseGeocoding(latitude: position.latitude, longitude: position.longitude);
    List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placeMarks[0].administrativeArea;
    if(city?.contains(" Governorate",0)==true){
      int? a = placeMarks[0].administrativeArea?.lastIndexOf(" ",city?.length);
      city=placeMarks[0].administrativeArea?.substring(0,a);
    }
    if (kDebugMode) {
      //int? a = placeMarks[0].administrativeArea?.lastIndexOf(" ",0);
      //print(a);
      int? a = placeMarks[0].administrativeArea?.lastIndexOf(" ",city?.length);
      print(placeMarks[0].administrativeArea?.substring(0,a));
    }
    return city?? "";
}

}