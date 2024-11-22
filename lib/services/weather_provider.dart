import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather/services/weather_service.dart';

import '../models/weather_model.dart';

class WeatherProvider with ChangeNotifier {
  final _weatherService = WeatherService();
  Weather? weather;
  Color searchBarCheckIcon=Colors.grey;

  fetchWeather() async {
    String? cityName = await _weatherService.getCurrentCity();
    try {
      weather = await _weatherService.getWeather(cityName!);
      notifyListeners();
      if (kDebugMode) {
        print("state updated");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool> fetchWeatherSearch(String city) async{
    bool flag=true;
    _weatherService.providedCity=city;
    try {
      weather = await _weatherService.getWeatherSearchBar();
        searchBarCheckIcon = Colors.green;
      notifyListeners();
      if (kDebugMode) {
        print("state updated");
      }
    } catch (e) {
        searchBarCheckIcon = Colors.red;
        notifyListeners();
        if (kDebugMode) {
        print(e);
      }
      flag=false;
    }
    return flag;
  }

  Color getBackgroundColor(){
    try{
      if(weather!.dayNight.contains("n",0)){
        return Colors.blueGrey;
      }
      else if(weather!.dayNight.contains("d",0)){
        return Colors.cyan;
      }
    }
    catch(e){
      return Colors.cyan;
    }
    return Colors.cyan;
  }

  String getWeatherAnimation(String? mainCondition){
    try{
      switch(mainCondition){
        case "Clouds" :
        case "Mist" :
        case "Smoke" :
        case "Haze" :
        case "Dust" :
        case "Fog" :
          if(weather!.dayNight.contains("n",0)){
            return "assets/Ncloudy.png";
          }
          else if(weather!.dayNight.contains("d",0)){
            return "assets/cloudy.png";
          }
        case "Rain" :
        case "Drizzle" :
        case "Shower Rain" :
          if(weather!.dayNight.contains("n",0)){
            return "assets/Nrainy.png";
          }
          else if(weather!.dayNight.contains("d",0)) {
            return "assets/rainy.png";
          }
        case "Thunderstorm" :
          if(weather!.dayNight.contains("n",0)){
            return "assets/Nthunder.png";
          }
          else if(weather!.dayNight.contains("d",0)) {
            return "assets/thunder.png";
          }
        case "clear" :
          if(weather!.dayNight.contains("n",0)){
            return "assets/Nclear.png";
          }
          else if (weather!.dayNight.contains("d",0)){
            return "assets/sunny.png";
          }
        default :
          if(weather!.dayNight.contains("n",0)) {
            return "assets/Nclear.png";
          }
          else if(weather!.dayNight.contains("d",0)){
            return "assets/sunny.png";
          }
      }
    }
    catch(e){
      return "assets/sunny.png";
    }

    return "assets/sunny.png";
  }

}