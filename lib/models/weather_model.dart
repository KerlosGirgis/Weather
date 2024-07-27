class Weather{
  final String cityName;
  final double temp;
  final String mainCondition;
  final String dayNight;
  Weather({
    required this.cityName,
    required this.temp,
    required this.mainCondition,
    required this.dayNight
  });
  factory Weather.fromJson(Map<String,dynamic>json){
    return Weather(
        cityName: json['name'],
        temp: json['main']['temp'].toDouble(),
        mainCondition : json['weather'][0]['main'],
        dayNight : json['weather'][0]['icon']

    );
  }
}