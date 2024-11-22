import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/weather_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<HomePage> {
  final searchBarController = TextEditingController();

  @override
  void initState() {
    Provider.of<WeatherProvider>(context, listen: false).fetchWeather();
    super.initState();
  }
//_weather?.cityName ?? "loading city"
  @override
  Widget build(BuildContext context) {
    debugInvertOversizedImages = true;
    return Consumer<WeatherProvider>(
      builder: (context, weather, child) {
        return Scaffold(
            backgroundColor: weather.getBackgroundColor(),
            body:
            MediaQuery.of(context).orientation==Orientation.portrait? Column(
              children: [
                Spacer(flex: 4,),
                SearchBar(trailing: [
                  Icon(Icons.check_circle_outline_sharp,
                    color: weather.searchBarCheckIcon,),
                  IconButton(onPressed: (){
                    weather.fetchWeatherSearch(searchBarController.text);
                    FocusManager.instance.primaryFocus?.unfocus();
                  }, icon: const Icon(Icons.search_sharp)),
                ],controller: searchBarController,
                  onSubmitted: (String a){
                    weather.fetchWeatherSearch(searchBarController.text);
                  },
                  onTapOutside: (PointerDownEvent e){
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
                Spacer(flex: 2,),
                Text(weather.weather?.cityName ?? "loading city",style: const TextStyle(fontSize: 48,color: Colors.white),),
                Spacer(flex: 2,),
                Image.asset(weather.getWeatherAnimation(weather.weather?.mainCondition),cacheHeight: 170,cacheWidth: 170,),
                Spacer(flex: 3,),
                Text("${weather.weather?.temp.round()}°C",style: const TextStyle(fontSize: 48,color: Colors.white),),
                Spacer(flex: 3,),
                Text(weather.weather?.mainCondition??"",style: const TextStyle(fontSize: 48,color: Colors.white),),
                Spacer(flex: 3,),
                IconButton(onPressed:(){
                  weather.fetchWeather();
                }, icon: const Icon(Icons.my_location_sharp),),
                Spacer(flex: 3,),
              ],
            ):
            Column(
              children: [
                Spacer(flex: 1,),
                SearchBar(trailing: [
                  Icon(Icons.check_circle_outline_sharp,
                    color: weather.searchBarCheckIcon,),
                  IconButton(onPressed: (){
                    weather.fetchWeatherSearch(searchBarController.text);
                    FocusManager.instance.primaryFocus?.unfocus();
                  }, icon: const Icon(Icons.search_sharp)),
                ],controller: searchBarController,
                  onSubmitted: (String a){
                    weather.fetchWeatherSearch(searchBarController.text);
                  },
                  onTapOutside: (PointerDownEvent e){
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
                Spacer(flex: 1,),
                Row(
                  children: [
                    Spacer(flex: 1,),
                    Text(weather.weather?.cityName ?? "loading city",style: const TextStyle(fontSize: 48,color: Colors.white),),
                    Spacer(flex: 1,),
                    Image.asset(weather.getWeatherAnimation(weather.weather?.mainCondition),cacheHeight: 170,cacheWidth: 170,),
                    Spacer(flex: 1,),
                    Text("${weather.weather?.temp.round()}°C",style: const TextStyle(fontSize: 48,color: Colors.white),),
                    Spacer(flex: 1,),
                    Text(weather.weather?.mainCondition??"",style: const TextStyle(fontSize: 48,color: Colors.white),),
                    Spacer(flex: 1,),
                  ],
                ),
                Spacer(flex: 1,),
              ],
            )

        );
      },
    );
  }
}