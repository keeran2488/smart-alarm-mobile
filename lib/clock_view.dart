import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  /// since canvas starts drawing from horizon and clock starts vertically
  /// that's why the whole canvas is rotated -90 degree
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 300,
        child: Transform.rotate(
            angle: -pi / 2,
            child: CustomPaint(
              painter: ClockPainter(),
            )));
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

    /// canvas gets drawn in stack; it means first thing to get drawn sits on last
    /// and last thing to get drawn sits on first

    //brush style to fill Clock circle
    var fillBrush = Paint()..color = Color(0xFF444974);

    //brush style for outline of Clock
    var outlineBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    //brush style for center dot
    var centerFillBrush = Paint()..color = Color(0xFFEAECFF);

    //brush style for second hand
    var secHandBrush = Paint()
      ..color = Color(0xFFFFB74D)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    //brush style for minute hand
    var minHandBrush = Paint()
      ..shader = RadialGradient(colors: [Color(0xFF748EF6), Color(0xFF77DDFF)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    //brush style for hour hand
    var hourHandBrush = Paint()
      ..shader = RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;

    //draw Circle with fill color and outline
    canvas.drawCircle(center, radius - 30, fillBrush);
    canvas.drawCircle(center, radius - 30, outlineBrush);

    //calcualte x and y cords. of another end of hour hand
    var hourHandX = centerX +
        60 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerX +
        60 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);

    //draw hour hand
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    //calcualte x and y cords. of another end of minute hand
    var minHandX = centerX + 80 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerY + 80 * sin(dateTime.minute * 6 * pi / 180);

    //draw minute hand
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    //calcualte x and y cords. of another end of second hand
    var secHandX = centerX + 100 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + 100 * sin(dateTime.second * 6 * pi / 180);

    //draw second hand
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    //draw center dot of Clock
    canvas.drawCircle(center, 8, centerFillBrush);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
