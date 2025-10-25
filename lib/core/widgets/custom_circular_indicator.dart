import 'package:flutter/material.dart';



class CustomCircularIndicator extends StatefulWidget {
  const CustomCircularIndicator({
    super.key,
    this.colors = const [Color(0xFF5F6AC4), Color(0xFF123763)],
    this.strokeWidth = 3.0,
    this.duration = const Duration(milliseconds: 900),
    this.value,
  });

  final List<Color> colors;
  final double strokeWidth;
  final Duration duration;
  final double? value;

  @override
  State<CustomCircularIndicator> createState() => _CustomCircularIndicatorState();
}

class _CustomCircularIndicatorState extends State<CustomCircularIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: widget.value == null || widget.value == 1
            ? AnimatedBuilder(
          animation: _c!,
          builder: (context, _) {
            return CustomPaint(
              painter: _ArcPainter(
                progress: _c!.value,
                colors: widget.colors,
                strokeWidth: widget.strokeWidth,
                indeterminate: true,
              ),
            );
          },
        )
            : CustomPaint(
          painter: _ArcPainter(
            progress: widget.value!.clamp(0.0, 1.0),
            colors: widget.colors,
            strokeWidth: widget.strokeWidth,
            indeterminate: false,
          ),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double strokeWidth;
  final bool indeterminate;

  _ArcPainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
    required this.indeterminate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final startAngle = -90.0 * 3.14159 / 180.0;

    final sweepAngle = indeterminate
        ? 2 * 3.14159 * 0.25 // quarter arc for spinner
        : 2 * 3.14159 * progress;

    final actualStart = indeterminate
        ? startAngle + (2 * 3.14159 * progress)
        : startAngle;

    final paint = Paint()
      ..shader = SweepGradient(colors: colors).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      actualStart,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.colors != colors ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.indeterminate != indeterminate;
  }
}


