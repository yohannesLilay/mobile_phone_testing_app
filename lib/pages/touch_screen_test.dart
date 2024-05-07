import 'dart:math';
import 'package:flutter/material.dart';

class TouchTestScreen extends StatefulWidget {
  const TouchTestScreen({super.key});

  @override
  TouchTestScreenState createState() => TouchTestScreenState();
}

class TouchTestScreenState extends State<TouchTestScreen> {
  final List<Offset> _points = <Offset>[];
  final Set<Rect> _squares = {};

  void onConditionMet() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context, 'Passed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset globalPosition =
                renderBox.globalToLocal(details.globalPosition);
            _points.add(globalPosition);
            _detectTappedSquare(globalPosition);
          });
        },
        // onPanEnd: (details) => _points.clear(),
        child: SafeArea(
          child: CustomPaint(
            painter: TouchPainter(
              points: _points,
              squares: _squares,
              onConditionMet: onConditionMet,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }

  void _detectTappedSquare(Offset globalPosition) {
    setState(() {
      for (Rect square in _squares) {
        if (square.contains(globalPosition)) {
          _squares.remove(square);
          break; // Stop searching if a square is found
        }
      }
    });
  }
}

class TouchPainter extends CustomPainter {
  final List<Offset> points;
  final Set<Rect> squares;
  final VoidCallback onConditionMet;

  TouchPainter({
    required this.points,
    required this.squares,
    required this.onConditionMet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.5;

    Paint touchPaint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    Paint greenPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // Calculate the maximum number of squares that can fit on each side
    const double padding = 4.0;
    const double squareSize = 20.0;
    final int maxSquaresOnSide =
        ((size.width - 2 * padding) / squareSize).floor();
    final int maxSquaresOnTopBottom =
        ((size.height - padding) / squareSize).floor();

    // Set to store drawn square positions
    Set<Offset> drawnPositions = {};

    // Draw squares along the sides
    for (int i = 0; i < maxSquaresOnSide; i++) {
      final double x = padding + i * squareSize;
      const double y = padding;
      Offset position = Offset(x, y);
      Rect square = Rect.fromLTWH(x, y, squareSize, squareSize);
      if (!drawnPositions.contains(position)) {
        canvas.drawRect(square, borderPaint);
        drawnPositions.add(position);
        squares.add(square);
      }

      final double bottomY = size.height - padding - squareSize;
      Offset bottomPosition = Offset(x, bottomY);
      Rect bottomSquare = Rect.fromLTWH(x, bottomY, squareSize, squareSize);
      if (!drawnPositions.contains(bottomPosition)) {
        canvas.drawRect(bottomSquare, borderPaint);
        drawnPositions.add(bottomPosition);
        squares.add(bottomSquare);
      }
    }

    // Draw squares along the top and bottom
    for (int i = 0; i < maxSquaresOnTopBottom; i++) {
      final double y = padding + i * squareSize;
      const double x = padding;
      Offset position = Offset(x, y);
      Rect square = Rect.fromLTWH(x, y, squareSize, squareSize);
      if (!drawnPositions.contains(position)) {
        canvas.drawRect(square, borderPaint);
        drawnPositions.add(position);
        squares.add(square);
      }

      final double rightX = size.width - padding - squareSize;
      Offset rightPosition = Offset(rightX, y);
      Rect rightSquare = Rect.fromLTWH(rightX, y, squareSize, squareSize);
      if (!drawnPositions.contains(rightPosition)) {
        canvas.drawRect(rightSquare, borderPaint);
        drawnPositions.add(rightPosition);
        squares.add(rightSquare);
      }
    }

    // Calculate the position of the center cross squares
    final double centerCrossX = (size.width - squareSize) / 2;
    final double centerCrossY = (size.height - squareSize) / 2;

    // Draw squares for the center cross
    for (int i = 0; i < maxSquaresOnSide; i++) {
      final double x = padding + i * squareSize;
      final double y = centerCrossY;
      Offset position = Offset(x, y);
      Rect square = Rect.fromLTWH(x, y, squareSize, squareSize);
      if (!drawnPositions.contains(position)) {
        canvas.drawRect(square, borderPaint);
        drawnPositions.add(position);
        squares.add(square);
      }
    }

    for (int i = 0; i < maxSquaresOnTopBottom; i++) {
      final double x = centerCrossX;
      final double y = padding + i * squareSize;
      Offset position = Offset(x, y);
      Rect square = Rect.fromLTWH(x, y, squareSize, squareSize);
      if (!drawnPositions.contains(position)) {
        canvas.drawRect(square, borderPaint);
        drawnPositions.add(position);
        squares.add(square);
      }
    }

    // Draw lines based on touch points
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], touchPaint);
    }

    // Diagonal from top-left to bottom-right
    const double startX1 = padding;
    const double startY1 = padding;
    final double endX1 = size.width - padding - squareSize;
    final double endY1 = size.height - padding - squareSize;
    drawDiagonalSquares(
        canvas, startX1, startY1, endX1, endY1, squareSize, borderPaint);

    // Diagonal from top-right to bottom-left
    final double startX2 = size.width - padding - squareSize;
    const double startY2 = padding;
    const double endX2 = padding;
    final double endY2 = size.height - padding - squareSize;
    drawDiagonalSquares(
        canvas, startX2, startY2, endX2, endY2, squareSize, borderPaint);

    // Fill squares that are touched with green color
    int touchedSquares = 0;
    for (Rect square in squares) {
      if (_isTouchedSquare(square)) {
        canvas.drawRect(square, greenPaint);
        touchedSquares++;
      }
    }

    if (squares.length == touchedSquares) {
      onConditionMet();
    }
  }

  bool _isTouchedSquare(Rect square) {
    for (Offset point in points) {
      if (square.contains(point)) {
        return true;
      }
    }
    return false;
  }

  void drawDiagonalSquares(Canvas canvas, double startX, double startY,
      double endX, double endY, double squareSize, Paint paint) {
    final double dx = endX - startX;
    final double dy = endY - startY;
    final int maxSquaresOnDiagonal =
        ((sqrt(dx * dx + dy * dy)) / squareSize).ceil();

    for (int j = 0; j < maxSquaresOnDiagonal; j++) {
      final double x = startX + (dx / maxSquaresOnDiagonal) * j;
      final double y = startY + (dy / maxSquaresOnDiagonal) * j;
      Rect square = Rect.fromLTWH(x, y, squareSize, squareSize);
      canvas.drawRect(square, paint);
      squares.add(square);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
