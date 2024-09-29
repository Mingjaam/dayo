import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'dart:async';
import 'dart:math' as math;
import 'styles.dart';
class CalendarCell extends StatefulWidget {
  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool isFocused;
  final List<Map<String, dynamic>> memos;
  final double cellWidth;
  final double cellHeight;

  const CalendarCell({
    Key? key,
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isFocused,
    required this.memos,
    required this.cellWidth,
    required this.cellHeight,
  }) : super(key: key);

  @override
  _CalendarCellState createState() => _CalendarCellState();
}

class _CalendarCellState extends State<CalendarCell> with SingleTickerProviderStateMixin {
  late World world;
  List<Body> balls = [];
  static const double BALL_RADIUS = 8.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initPhysics();
    _initAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _animationController.addListener(_updatePhysics);
  }

  void _updatePhysics() {
    const timeStep = 1.0 / 60.0;
    world.stepDt(timeStep);
    setState(() {});
  }

  void _initPhysics() {
    world = World();
    world.setGravity(Vector2(0, 45));
    _createBoundaries();
    _createBalls();
  }

  void _createBoundaries() {
    final physicalWidth = widget.cellWidth * 0.9;  // 10% 더 넓게
    final physicalHeight = widget.cellHeight * 0.97;  // 20% 더 높게

    // 바닥
    world.createBody(BodyDef())
      ..createFixture(FixtureDef(EdgeShape()
        ..set(Vector2(0, physicalHeight), Vector2(physicalWidth, physicalHeight))));

    // 왼쪽 벽
    world.createBody(BodyDef())
      ..createFixture(FixtureDef(EdgeShape()
        ..set(Vector2(0, 0), Vector2(0, physicalHeight))));

    // 오른쪽 벽
    world.createBody(BodyDef())
      ..createFixture(FixtureDef(EdgeShape()
        ..set(Vector2(physicalWidth, 0), Vector2(physicalWidth, physicalHeight))));
  }

  void _createBalls() {
    final random = math.Random();
    for (var _ in widget.memos) {
      final ball = world.createBody(BodyDef(
        type: BodyType.dynamic,
        position: Vector2(
          BALL_RADIUS + (widget.cellWidth - 2 * BALL_RADIUS) * random.nextDouble(),
          BALL_RADIUS + (widget.cellHeight / 2) * random.nextDouble(),
        ),
      ));

      final shape = CircleShape()..radius = BALL_RADIUS;
      ball.createFixture(FixtureDef(
        shape,
        density: 0.5,
        friction: 0.3,
        restitution: 0.7,
      ));

      balls.add(ball);
    }
  }

  Color _getColorFromEmoji(String emoji) {
    switch (emoji) {
      case '😠': return Colors.red;
      case '😩': return Colors.red;
      case '😊': return const Color(0xFFFFD700);
      case '😎': return const Color(0xFFFFD700);
      case '😢': return Colors.blue;
      case '😴': return Colors.green;
      case '😐': return Colors.green;
      case '🥰': return const Color.fromARGB(255, 255, 134, 231);
      case '🤔': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: widget.cellWidth,
          height: widget.cellHeight,
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: widget.isSelected ? AppStyles.lightPink : (widget.isToday ? AppStyles.lightPink : null),
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    '${widget.day.day}',
                    style: TextStyle(
                      color: widget.isFocused ? Colors.black87 : AppStyles.lightPink,
                      fontWeight: widget.isSelected || widget.isToday ? FontWeight.bold : null,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              ...balls.asMap().entries.map((entry) {
                final index = entry.key;
                final ball = entry.value;
                final position = ball.position;
                return Positioned(
                  left: position.x - BALL_RADIUS,
                  top: position.y - BALL_RADIUS,
                  child: Container(
                    width: BALL_RADIUS * 2,
                    height: BALL_RADIUS * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getColorFromEmoji(widget.memos[index]['emoji']),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}