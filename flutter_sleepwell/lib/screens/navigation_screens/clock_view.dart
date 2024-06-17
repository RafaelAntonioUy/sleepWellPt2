import 'dart:async';
import 'dart:math';
import 'package:flutter_login/consts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  //const ClockView({super.key});
  final double size;

  const ClockView({super.key, required this.size});

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Update the state
        });
      }
    });
  }
  //modified
  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }
  //end
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        
        ),
      ),


    );
  }
}

class ClockPainter extends CustomPainter {  
  var dateTime = DateTime.now();


  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()
    ..color = kPrimaryColorDarker;

    var outlineBrush = Paint()
    ..color = Color(0xFFEAECFF)
    ..style = PaintingStyle.stroke
    ..strokeWidth = size.width / 20;

    var centerFillBrush = Paint()
    ..color = Color(0xFFEAECFF);

    var secHandBrush = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = size.width / 75;

    var minHandBrush = Paint()
    ..color = Colors.white
    // ..color = Color.fromARGB(255, 1, 8, 105)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = size.width / 30;

    var hourHandBrush = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = size.width / 24;
    

    canvas.drawCircle(center, radius * 0.85, fillBrush);
    canvas.drawCircle(center, radius * 0.85, outlineBrush);

    var hourHandX = centerX + radius * 0.3 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerX + radius * 0.3 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), minHandBrush);
    var minHandX = centerX + radius * 0.50 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerX + radius * 0.50 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), hourHandBrush);
    var secHandX = centerX + radius * 0.65 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + radius * 0.65 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);
    
    canvas.drawCircle(center, radius * 0.12, centerFillBrush);
/*
    var outerRadius = radius;
    var innerRadius = radius * 0.9;
    for(var i = 0; i < 360; i += 12){
      var x1 = centerX + outerRadius * cos(i * pi / 180);
      var y1 = centerY + outerRadius * sin(i * pi / 180);

      var x2 = centerX + innerRadius * cos(i * pi / 180);
      var y2 = centerY + innerRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }*/
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
