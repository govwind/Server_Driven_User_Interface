import 'package:flutter/material.dart';
import 'dart:math' as math;

class PartySeats {
  final String name;
  final String shortName;
  final int seats;
  final Color color;
  final String alliance;

  PartySeats({
    required this.name,
    required this.shortName,
    required this.seats,
    required this.color,
    required this.alliance,
  });
}

class ElectionSpeedometer extends StatefulWidget {
  final List<PartySeats> partyData;
  final int totalSeats;
  final String title;

  const ElectionSpeedometer({
    super.key,
    required this.partyData,
    this.totalSeats = 543,
    required this.title,
  });

  @override
  State<ElectionSpeedometer> createState() => _ElectionSpeedometerState();
}

class _ElectionSpeedometerState extends State<ElectionSpeedometer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _seatAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _seatAnimations = widget.partyData.map((party) {
      return Tween<double>(
        begin: 0,
        end: party.seats.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
    }).toList();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return Card(
    margin: EdgeInsets.zero,  // Remove margin around card
    elevation: 0,  // Remove shadow
    child: SizedBox(  // Make card take full width
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,  // Stretch content horizontally
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,  // Center title
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildGaugeBackground(),
                  ...widget.partyData.map((party) {
                    final index = widget.partyData.indexOf(party);
                    return _buildPartyGauge(party, _seatAnimations[index]);
                  }),
                  _buildCenterInfo(),
                ],
              ),
            ),
            _buildLegend(),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildGaugeBackground() {
    return CustomPaint(
      size: const Size(200, 200),
      painter: GaugeBackgroundPainter(
        totalSeats: widget.totalSeats,
      ),
    );
  }

  Widget _buildPartyGauge(PartySeats party, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(300, 300),
          painter: GaugeNeedlePainter(
            seats: animation.value,
            totalSeats: widget.totalSeats,
            color: party.color,
          ),
        );
      },
    );
  }

  Widget _buildCenterInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Total Seats',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            '${widget.totalSeats}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: widget.partyData.map((party) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: party.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: party.color),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: party.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    party.shortName,
                    style: TextStyle(
                      color: party.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${party.seats} seats',
                    style: TextStyle(
                      color: party.color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class GaugeBackgroundPainter extends CustomPainter {
  final int totalSeats;


  GaugeBackgroundPainter({
    required this.totalSeats,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    final paint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.8,
      math.pi * 1.4,
      false,
      paint,
    );

    // Draw scale marks
    final scalePaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i <= 10; i++) {
      final angle = math.pi * 0.8 + (math.pi * 1.4 * i / 10);
      
      // Adjust the outer point to be further out
      final outerPoint = Offset(
        center.dx + (radius + 15) * math.cos(angle),
        center.dy + (radius + 15) * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 20) * math.cos(angle),
        center.dy + (radius - 20) * math.sin(angle),
      );
      canvas.drawLine(innerPoint, outerPoint, scalePaint);

      // Draw scale numbers with increased gap
      final seats = (totalSeats * i / 10).round();
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$seats',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      // Calculate text position with increased gap
      final textPoint = Offset(
        center.dx + (radius + 35) * math.cos(angle),  // Increased from +20 to +35
        center.dy + (radius + 35) * math.sin(angle),  // Increased from +20 to +35
      );
      
      textPainter.paint(
        canvas,
        Offset(
          textPoint.dx - textPainter.width / 2,
          textPoint.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GaugeNeedlePainter extends CustomPainter {
  final double seats;
  final int totalSeats;
  final Color color;

  GaugeNeedlePainter({
    required this.seats,
    required this.totalSeats,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.25;
    
    final angle = math.pi * 0.8 + (math.pi * 1.4 * seats / totalSeats);
    
    final needlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final needlePoint = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    canvas.drawLine(center, needlePoint, needlePaint);

    // Draw needle head
    final needleHeadPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(needlePoint, 6, needleHeadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

