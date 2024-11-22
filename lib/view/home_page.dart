import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<HomePage> {
  final _weatherService = WeatherService();
  final searchBarController = TextEditingController();
  Weather? _weather;
  Color? searchBarCheckIcon;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchBarController.dispose();
    super.dispose();
  }

  _fetchWeather() async {
    String? cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName!);
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
        searchBarCheckIcon = Colors.green;
      });
      if (kDebugMode) {
        print("state updated");
      }
    } catch (e) {
      setState(() {
        searchBarCheckIcon = Colors.red;
      });
      if (kDebugMode) {
        print(e);
      }
      flag=false;
    }
    return flag;
  }
  Color getBackgroundColor(){

    try{
      if(_weather!.dayNight.contains("n",0)){
        return Colors.blueGrey;
      }
      else if(_weather!.dayNight.contains("d",0)){
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
    searchBarCheckIcon = Colors.grey;
    super.initState();
  }
//_weather?.cityName ?? "loading city"
  @override
  Widget build(BuildContext context) {
    debugInvertOversizedImages = true;
    return Scaffold(
        backgroundColor: getBackgroundColor(),
        body:
        MediaQuery.of(context).orientation==Orientation.portrait? Column(
          children: [
            Spacer(flex: 4,),
            SearchBar(trailing: [
              Icon(Icons.check_circle_outline_sharp,
                color: searchBarCheckIcon,),
              IconButton(onPressed: (){
                _fetchWeatherSearch(searchBarController.text);
                FocusManager.instance.primaryFocus?.unfocus();
              }, icon: const Icon(Icons.search_sharp)),
            ],controller: searchBarController,
              onSubmitted: (String a){
                _fetchWeatherSearch(searchBarController.text);
              },
              onTapOutside: (PointerDownEvent e){
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            Spacer(flex: 2,),
            Text(_weather?.cityName ?? "loading city",style: const TextStyle(fontSize: 48,color: Colors.white),),
            Spacer(flex: 2,),
            Image.asset(getWeatherAnimation(_weather?.mainCondition),cacheHeight: 170,cacheWidth: 170,),
            Spacer(flex: 3,),
            Text("${_weather?.temp.round()}°C",style: const TextStyle(fontSize: 48,color: Colors.white),),
            Spacer(flex: 3,),
            Text(_weather?.mainCondition??"",style: const TextStyle(fontSize: 48,color: Colors.white),),
            Spacer(flex: 3,),
            IconButton(onPressed:(){
              _fetchWeather();
            }, icon: const Icon(Icons.my_location_sharp),),
            Spacer(flex: 3,),
          ],
        ):
        Column(
          children: [
            Spacer(flex: 1,),
            SearchBar(trailing: [
              Icon(Icons.check_circle_outline_sharp,
                color: searchBarCheckIcon,),
              IconButton(onPressed: (){
                _fetchWeatherSearch(searchBarController.text);
                FocusManager.instance.primaryFocus?.unfocus();
              }, icon: const Icon(Icons.search_sharp)),
            ],controller: searchBarController,
              onSubmitted: (String a){
                _fetchWeatherSearch(searchBarController.text);
              },
              onTapOutside: (PointerDownEvent e){
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            Spacer(flex: 1,),
            Row(
              children: [
                Spacer(flex: 1,),
                Text(_weather?.cityName ?? "loading city",style: const TextStyle(fontSize: 48,color: Colors.white),),
                Spacer(flex: 1,),
                Image.asset(getWeatherAnimation(_weather?.mainCondition),cacheHeight: 170,cacheWidth: 170,),
                Spacer(flex: 1,),
                Text("${_weather?.temp.round()}°C",style: const TextStyle(fontSize: 48,color: Colors.white),),
                Spacer(flex: 1,),
                Text(_weather?.mainCondition??"",style: const TextStyle(fontSize: 48,color: Colors.white),),
                Spacer(flex: 1,),
              ],
            ),
            Spacer(flex: 1,),
          ],
        )

    );
  }
}