import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlassWeather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const GlassWeatherDashboard(),
    );
  }
}

class GlassWeatherDashboard extends StatefulWidget {
  const GlassWeatherDashboard({super.key});

  @override
  State<GlassWeatherDashboard> createState() {
    return const _GlassWeatherDashboardState();
  }
}

class HourlyData {
  final String time;
  final String temp;
  final IconData icon;
  final bool active;
  const HourlyData(this.time, this.temp, this.icon, this.active);
}

class _GlassWeatherDashboardState extends State<GlassWeatherDashboard> {
  late String _currentWeather;
  late bool _isCardPressed;

  @override
  void initState() {
    super.initState();
    _currentWeather = 'sunny';
    _isCardPressed = false;
  }

  void _triggerFeedback() {
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF030307),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
            width: screenSize.width,
            height: screenSize.height,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.4, -0.4),
                radius: 1.5,
                colors: _getWeatherAura(),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildLocationHeader(),
                  const SizedBox(height: 30),
                  _buildMainWeatherCard(),
                  const SizedBox(height: 24),
                  _buildWeatherMetricsGrid(),
                  const SizedBox(height: 24),
                  _buildHourlyForecast(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getWeatherAura() {
    if (_currentWeather.contains('rainy')) {
      return [Colors.blueGrey.withAlpha(50), Colors.indigo.withAlpha(20),const Color(0xFF030307)];
    }
    if (_currentWeather.contains('cloudy')) {
      return [Colors.purpleAccent.withAlpha(35),Colors.blueAccent.withAlpha(15), const Color(0xFF030307)];
    }
    return [Colors.amberAccent.withAlpha(40),Colors.orangeAccent.withAlpha(15), const Color(0xFF030307)];
  }

  Widget _buildLocationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TAIPEI',
              style: TextStyle(color: Colors.white, fontSize: 26,fontWeight: FontWeight.w300, letterSpacing: 1.5)
            ),
            const SizedBox(height: 4),
            Text(
              'Sunday',
              style: TextStyle(color: Colors.white.withAlpha(120),fontSize: 13)
            ),
          ],
        ),
        PopupMenuButton<String>(
          onSelected: (String value) {
            _triggerFeedback();
            setState(() {
              _currentWeather = value;
            });
          },
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white.withAlpha(20),
                child: const Icon(Icons.wb_sunny_outlined, color:Colors.white, size: 20),
              ),
            ),
          ),
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(value: 'sunny', child:Text('Sunny')),
              const PopupMenuItem<String>(value: 'cloudy', child:Text('Cloudy')),
              const PopupMenuItem<String>(value: 'rainy', child:Text('Rainy')),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildMainWeatherCard() {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          _isCardPressed = true;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          _isCardPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isCardPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isCardPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(12),
                borderRadius: BorderRadius.circular(36.0),
                border: Border.all(color: Colors.white.withAlpha(20),width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '28C',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 86,
                          fontWeight: FontWeight.w100
                        )
                      ),
                      Icon(
                        _currentWeather.contains('sunny')
                            ? Icons.wb_sunny
                            : (_currentWeather.contains('cloudy') ? Icons.cloud : Icons.thunderstorm),
                        color: _currentWeather.contains('sunny')
                            ? Colors.amberAccent
                            : Colors.white.withAlpha(200),
                        size: 72,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _currentWeather.contains('sunny')
                        ? 'SUNNY'
                        : (_currentWeather.contains('cloudy') ? 'CLOUDY' :'RAIN'),
                    style: const TextStyle(color: Colors.white, fontSize:16, fontWeight: FontWeight.w600, letterSpacing: 3.0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'H31C_L24C',
                    style: TextStyle(color: Colors.white.withAlpha(140),fontSize: 13)
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherMetricsGrid() {
    return Row(
      children: [
        _buildMetricItem(Icons.water_drop_outlined, 'HUMIDITY', '64%',Colors.blueAccent),
        const SizedBox(width: 14),
        _buildMetricItem(Icons.air_rounded, 'WIND', '12kmh',Colors.tealAccent),
        const SizedBox(width: 14),
        _buildMetricItem(Icons.wb_sunny_rounded, 'UV_INDEX', 'Low',Colors.amberAccent),
      ],
    );
  }

  Widget _buildMetricItem(IconData icon, String title, String value, Color
accentColor) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal:16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: Colors.white.withAlpha(15), width:1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: accentColor.withAlpha(200), size: 20),
                const SizedBox(height: 16),
                Text(title, style: TextStyle(color:Colors.white.withAlpha(100), fontSize: 9, fontWeight: FontWeight.w700,letterSpacing: 1.0)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12),
          child: Text(
            'HOURLY_FORECAST',
            style: TextStyle(
              color: Colors.white.withAlpha(120),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
