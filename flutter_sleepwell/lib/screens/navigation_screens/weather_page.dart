import 'package:flutter/material.dart';
import 'package:flutter_login/consts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/weather.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  Widget getWeatherIcon(int code) {
		switch (code) {
		  case >= 200 && < 300 :
		    return Image.asset(
					'assets/1.png',
          height: 250,
				);
			case >= 300 && < 400 :
		    return Image.asset(
					'assets/2.png',
          height: 250,
				);
			case >= 500 && < 600 :
		    return Image.asset(
					'assets/3.png',
          height: 250,
				);
			case >= 600 && < 700 :
		    return Image.asset(
					'assets/4.png',
          height: 250,
				);
			case >= 700 && < 800 :
		    return Image.asset(
					'assets/5.png',
          height: 250,
				);
			case == 800 :
		    return Image.asset(
					'assets/6.png',
          height: 250,
				);
			case > 800 && <= 804 :
		    return Image.asset(
					'assets/7.png',
          height: 250,
				);
		  default:
			return Image.asset(
				'assets/7.png',
        height: 250,
			);
		}
	}

  Future<void> _getLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      // Handle permission denied scenario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission is required to get the weather information.')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _getWeather(position.latitude, position.longitude);
    } catch (e) {
      // Handle location retrieval error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving location: $e')),
      );
    }
  }

  Future<void> _getWeather(double latitude, double longitude) async {
    try {
      Weather weather = await _wf.currentWeatherByLocation(latitude, longitude);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      // Handle weather retrieval error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving weather: $e')),
      );
    }
  }

  Future<void> _refreshWeather() async {
    setState(() {
      _weather = null;
    });
    _getLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColorDarker,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimaryColor,
              kPrimaryColorDarker,
            ],
            stops: [0.1, 0.7],
          ),
        ),
        child: _buildUI(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshWeather,
        child: Icon(Icons.refresh, color: kPrimaryColorDarker),
        backgroundColor: kSecondaryColor,
      ),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(color: textColor),
      );
    }

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(width: 10.0),
              Lottie.asset('lib/assets/jumping_location.json', width: 60),
              _locationHeader(),
            ],
          ),
          // SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
          
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          _weatherIcon(),
          _dateTimeInfo(),

          const SizedBox(height: 35),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/11.png',
                    scale: 8,
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sunrise',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        DateFormat().add_jm().format(_weather!.sunrise!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/12.png',
                    scale: 8,
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sunset',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        DateFormat().add_jm().format(_weather!.sunset!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Divider(
              color: Colors.grey,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Row(
                children: [
                  Image.asset(
                    'assets/13.png',
                    scale: 8,
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Temp Max',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${_weather!.tempMax!}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  )
                ]
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/14.png',
                    scale: 8,
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Temp Min',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${_weather!.tempMin!}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  )
                ]
              )
            ],
          ),

        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Row (
      mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Text(
              DateFormat("EEEE d • hh:mm a").format(now),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
                color: textColor,
              ),
        ),    
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getWeatherIcon(_weather!.weatherConditionCode!),

        Text(
          "${_weather?.tempFeelsLike!.celsius!.round().toString()}°C" ?? "",
          style: const TextStyle(
            color: textColor,
            fontSize: 35.0,
            fontWeight: FontWeight.w600,
          ),
        ),

        Text(
          _weather?.weatherDescription?.toUpperCase() ?? "",
          style: const TextStyle(
            fontSize: 20.0,
            color: textColor,
            fontWeight: FontWeight.w400
          ),
        ),
        
      ],
    );
  }
}
