import 'package:flutter/material.dart';
import 'package:flutter_login/consts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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
      backgroundColor: kPrimaryColor,
      body: _buildUI(),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
          _dateTimeInfo(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
          _weatherIcon(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: TextStyle(
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
        color: kSecondaryColor,
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("hh:mm a").format(now),
          style: TextStyle(
            fontSize: 35.0,
            color: textColor,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            Text(
              " ${DateFormat("M/d/y").format(now)} ",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
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
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
              ),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            fontSize: 20.0,
            color: textColor,
          ),
        ),
        Text(
          "Feels like ${_weather?.tempFeelsLike!.celsius!.round().toString()}°C" ?? "",
          style: const TextStyle(
            color: textColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
