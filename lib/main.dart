import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlassWeatherDashboard extends StatefulWidget {
  const GlassWeatherDashboard({super.key});

  @override
  State<GlassWeatherDashboard> createState() =3D>
_GlassWeatherDashboardState();
}

class _GlassWeatherDashboardState extends State<GlassWeatherDashboard> {
  // =E6=A8=A1=E6=93=AC=E7=95=B6=E5=89=8D=E5=A4=A9=E6=B0=A3=E7=8B=80=E6=85=
=8B=EF=BC=9A'sunny'=EF=BC=88=E6=99=B4=E6=9C=97=E6=A5=B5=E5=85=89=EF=BC=89, =
'rainy'=EF=BC=88=E9=9B=A8=E5=A4=A9=E6=B7=B1=E9=82=83=EF=BC=89, 'cloudy'=EF=
=BC=88=E9=99=B0=E5=A4=A9=E8=BF=B7=E9=9C=A7=EF=BC=89
  String _currentWeather =3D 'sunny';
  bool _isCardPressed =3D false;

  void _triggerFeedback() {
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize =3D MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF030307),
      body: Stack(
        children: [
          // 1. =E7=92=B0=E5=A2=83=E5=85=89=E8=83=8C=E6=99=AF=E5=B1=A4=EF=
=BC=9A=E6=A0=B9=E6=93=9A=E4=B8=8D=E5=90=8C=E5=A4=A9=E6=B0=A3=E5=88=87=E6=8F=
=9B=E6=B6=B2=E6=85=8B=E6=B0=A3=E6=B0=9B=E5=85=89=E6=9A=88
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

          // 2. =E5=85=A7=E5=AE=B9=E4=B8=BB=E5=B1=A4
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), // iOS =E5=BD=88=E6=
=80=A7=E6=BB=BE=E5=8B=95
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // =E9=A0=82=E9=83=A8=E4=BD=8D=E7=BD=AE=E8=88=87=E5=A4=A9=
=E6=B0=A3=E5=88=87=E6=8F=9B=EF=BC=88=E6=B5=81=E9=AB=94=E8=86=A0=E5=9B=8A=E5=
=88=97=EF=BC=89
                  _buildLocationHeader(),

                  const SizedBox(height: 30),
                  // =E4=B8=AD=E5=A4=AE=E6=A0=B8=E5=BF=83=EF=BC=9A=E5=B7=A8=
=E5=B9=95=E7=84=A1=E9=82=8A=E6=A1=86=E6=BA=AB=E5=BA=A6=E8=88=87=E4=B8=BB=E5=
=A4=A9=E6=B0=A3=E5=8D=A1
                  _buildMainWeatherCard(),

                  const SizedBox(height: 24),
                  // =E6=A9=AB=E5=90=91=E6=B0=A3=E8=B1=A1=E8=A7=80=E6=B8=AC=
=E6=8C=87=E6=A8=99=EF=BC=88=E6=BF=95=E5=BA=A6=E3=80=81=E9=A2=A8=E9=80=9F=E3=
=80=81=E7=B4=AB=E5=A4=96=E7=B7=9A=EF=BC=8C=E6=8E=A1=E7=94=A8=E6=B5=81=E9=AB=
=94=E7=8E=BB=E7=92=83=E6=A0=BC=EF=BC=89
                  _buildWeatherMetricsGrid(),

                  const SizedBox(height: 24),
                  // 24=E5=B0=8F=E6=99=82=E9=A0=90=E5=A0=B1=EF=BC=88=E6=BB=
=91=E5=8B=95=E5=BC=8F=E6=B6=B2=E6=85=8B=E6=99=82=E9=96=93=E8=BB=B8=EF=BC=89
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

  // =E4=BE=9D=E6=93=9A=E5=A4=A9=E6=B0=A3=E5=8B=95=E6=85=8B=E8=AE=8A=E6=9B=
=B4=E8=83=8C=E6=99=AF=E6=A5=B5=E5=85=89=E9=85=8D=E8=89=B2
  List<Color> _getWeatherAura() {
    switch (_currentWeather) {
      case 'rainy':
        return [Colors.blueGrey.withAlpha(50), Colors.indigo.withAlpha(20),
const Color(0xFF030307)];
      case 'cloudy':
        return [Colors.purpleAccent.withAlpha(35),
Colors.blueAccent.withAlpha(15), const Color(0xFF030307)];
      case 'sunny':
      default:
        return [Colors.amberAccent.withAlpha(40),
Colors.orangeAccent.withAlpha(15), const Color(0xFF030307)];
    }
  }

  // =E9=A0=82=E9=83=A8=E4=BD=8D=E7=BD=AE=E8=88=87=E6=A8=A1=E6=93=AC=E5=88=
=87=E6=8F=9B=E5=88=97
  Widget _buildLocationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TAIPEI CITY', style: TextStyle(color: Colors.white,
fontSize: 26, fontWeight: FontWeight.w300, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            Text('Sunday, July 19', style: TextStyle(color:
Colors.white.withAlpha(120), fontSize: 13)),
          ],
        ),
        // =E5=8F=B3=E5=81=B4=E5=A4=A9=E6=B0=A3=E7=8B=80=E6=85=8B=E5=88=87=
=E6=8F=9B=E5=99=A8=EF=BC=88=E9=BB=9E=E6=93=8A=E5=8F=AF=E5=8D=B3=E6=99=82=E5=
=88=87=E6=8F=9B UI =E8=A6=96=E8=A6=BA=E4=B8=BB=E9=A1=8C=EF=BC=89
        PopupMenuButton<String>(
          onSelected: (String value) {
            _triggerFeedback();
            setState(() =3D> _currentWeather =3D value);
          },
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white.withAlpha(20),
                child: const Icon(Icons.wb_sunny_outlined, color:
Colors.white, size: 20),
              ),
            ),
          ),
          itemBuilder: (BuildContext context) =3D> <PopupMenuEntry<String>>=
[
            const PopupMenuItem<String>(value: 'sunny', child:
Text('=E6=99=B4=E5=A4=A9=E6=A8=A1=E5=BC=8F')),
            const PopupMenuItem<String>(value: 'cloudy', child:
Text('=E5=A4=9A=E9=9B=B2=E6=A8=A1=E5=BC=8F')),
            const PopupMenuItem<String>(value: 'rainy', child:
Text('=E9=9B=A8=E5=A4=A9=E6=A8=A1=E5=BC=8F')),
          ],
        ),
      ],
    );
  }

  // =E4=B8=BB=E5=A4=A9=E6=B0=A3=E5=B7=A8=E5=B9=95=E5=8D=A1=E7=89=87
  Widget _buildMainWeatherCard() {
    return GestureDetector(
      onTapDown: (_) =3D> setState(() =3D> _isCardPressed =3D true),
      onTapUp: (_) =3D> setState(() =3D> _isCardPressed =3D false),
      onTapCancel: () =3D> setState(() =3D> _isCardPressed =3D false),
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
                border: Border.all(color: Colors.white.withAlpha(20),
width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('28=C2=B0', style: TextStyle(color:
Colors.white, fontSize: 86, fontWeight: FontWeight.w100, fontFamily: 'SF
Pro Display')),
                      // =E9=9A=A8=E7=8B=80=E6=85=8B=E6=9B=B4=E6=8F=9B=E5=
=A4=A7=E5=9C=96=E7=A4=BA
                      Icon(
                        _currentWeather =3D=3D 'sunny' ? Icons.wb_sunny :
(_currentWeather =3D=3D 'cloudy' ? Icons.cloud : Icons.thunderstorm),
                        color: _currentWeather =3D=3D 'sunny' ?
Colors.amberAccent : Colors.white.withAlpha(200),
                        size: 72,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _currentWeather =3D=3D 'sunny' ? 'SUNNY' : (_currentWea=
ther
=3D=3D 'cloudy' ? 'PARTLY CLOUDY' : 'HEAVY RAIN'),
                    style: const TextStyle(color: Colors.white, fontSize:
16, fontWeight: FontWeight.w600, letterSpacing: 3.0),
                  ),
                  const SizedBox(height: 4),
                  Text('H: 31=C2=B0 L: 24=C2=B0 =C2=B7 =E4=BD=93=E6=84=9F=
=E6=B8=A9=E5=BA=A6 30=C2=B0', style: TextStyle(color:
Colors.white.withAlpha(140), fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =E6=A9=AB=E5=90=91=E8=A7=80=E6=B8=AC=E6=8C=87=E6=A8=99=E8=B3=87=E8=A8=
=8A
  Widget _buildWeatherMetricsGrid() {
    return Row(
      children: [
        _buildMetricItem(Icons.water_drop_outlined, 'HUMIDITY', '64%',
Colors.blueAccent),
        const SizedBox(width: 14),
        _buildMetricItem(Icons.air_rounded, 'WIND', '12 km/h',
Colors.tealAccent),
        const SizedBox(width: 14),
        _buildMetricItem(Icons.wb_sunny_rounded, 'UV INDEX', '4 Low',
Colors.amberAccent),
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal:
16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: Colors.white.withAlpha(15), width:
1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: accentColor.withAlpha(200), size: 20),
                const SizedBox(height: 16),
                Text(title, style: TextStyle(color:
Colors.white.withAlpha(100), fontSize: 9, fontWeight: FontWeight.w700,
letterSpacing: 1.0)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white,
fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =E6=AF=8F=E5=B0=8F=E6=99=82=E9=A0=90=E5=A0=B1=EF=BC=88iOS =E6=B5=81=E9=
=AB=94=E6=99=82=E9=96=93=E8=BB=B8=EF=BC=89
  Widget _buildHourlyForecast() {
    final List<Map<String, dynamic>> hourlyData =3D [
      {'time': 'Now', 'temp': '28=C2=B0', 'icon': Icons.wb_sunny, 'active':
true},
      {'time': '13:00', 'temp': '29=C2=B0', 'icon': Icons.wb_sunny, 'active=
':
false},
      {'time': '14:00', 'temp': '30=C2=B0', 'icon': Icons.cloud, 'active':
false},
      {'time': '15:00', 'temp': '27=C2=B0', 'icon': Icons.thunderstorm,
'active': false},
      {'time': '16:00', 'temp': '26=C2=B0', 'icon': Icons.thunderstorm,
'active': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12),
          child: Text('HOURLY FORECAST', style: TextStyle(color:
Colors.white.withAlpha(120), fontSize: 11, fontWeight: FontWeight.w700,
letterSpacing: 2.0)),
        ),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: hourlyData.length,
            itemBuilder: (context, index) {
              final item =3D hourlyData[index];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                width: 75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
