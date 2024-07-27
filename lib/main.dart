import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:weather/services/weather_service.dart';
import '../models/weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  final searchBarController = TextEditingController();
  Weather? _weather;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchBarController.dispose();
    super.dispose();
  }

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
      if (kDebugMode) {
        print("state updated");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  Future<bool> _fetchWeatherSearch(String city) async{
    bool flag=true;
    _weatherService.providedCity=city;
    try {
      final weather = await _weatherService.getWeatherSearchBar();
      setState(() {
        _weather = weather;
      });
      if (kDebugMode) {
        print("state updated");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      flag=false;
    }
    return flag;
  }
  Color getBackgroundColor(){
    if(_weather?.dayNight=="01n"){
      return Colors.blueGrey;
    }
    else if(_weather?.dayNight=="01d"){
      return Colors.cyan;
    }
    else{
      return Colors.cyan;
    }
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
          if(_weather!.dayNight.contains("n",0)){
            return "assets/Ncloudy.png";
          }
          else if(_weather!.dayNight.contains("d",0)){
            return "assets/cloudy.png";
          }
        case "Rain" :
        case "Drizzle" :
        case "Shower Rain" :
          if(_weather!.dayNight.contains("n",0)){
            return "assets/Nrainy.png";
          }
          else if(_weather!.dayNight.contains("d",0)) {
            return "assets/rainy.png";
          }
        case "Thunderstorm" :
          if(_weather!.dayNight.contains("n",0)){
            return "assets/Nthunder.png";
          }
          else if(_weather!.dayNight.contains("d",0)) {
            return "assets/thunder.png";
          }
        case "clear" :
          if(_weather!.dayNight.contains("n",0)){
            return "assets/Nclear.png";
          }
          else if (_weather!.dayNight.contains("d",0)){
            return "assets/sunny.png";
          }
        default :
          if(_weather!.dayNight.contains("n",0)) {
            return "assets/Nclear.png";
          }
          else if(_weather!.dayNight.contains("d",0)){
            return "assets/sunny.png";
          }
      }
    }
    catch(e){
      return "assets/sunny.png";
    }

    return "assets/sunny.png";
  }

  @override
  void initState() {
    _fetchWeather();
    super.initState();
  }
//_weather?.cityName ?? "loading city"
  @override
  Widget build(BuildContext context) {
    debugInvertOversizedImages = true;
    return Scaffold(
        backgroundColor: getBackgroundColor(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.values[5],
            children: [
              SearchBar(trailing: [
                IconButton(onPressed: (){
                  _fetchWeatherSearch(searchBarController.text);
                }, icon: const Icon(Icons.search_sharp))
              ],controller: searchBarController,),
              Text(_weather?.cityName ?? "loading city",style: const TextStyle(fontSize: 48,color: Colors.white),),
              Image.asset(getWeatherAnimation(_weather?.mainCondition),cacheHeight: 170,cacheWidth: 170,),
              Text("${_weather?.temp.round()}°C",style: const TextStyle(fontSize: 48,color: Colors.white),),
              Text(_weather?.mainCondition??"",style: const TextStyle(fontSize: 48,color: Colors.white),),
              IconButton(onPressed:(){
                _fetchWeather();
              }, icon: const Icon(Icons.my_location_sharp))
            ],
          ),)

    );
  }
}
