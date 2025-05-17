import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

class SplashScreen extends StatefulWidget {
  final String splashImage;
  final String tagline;
  final Color taglineColor;
  final Color backgroundColor;
  final String animation;
  final int duration;
  final VoidCallback onFinished;

  const SplashScreen({
    Key? key,
    required this.splashImage,
    required this.tagline,
    required this.taglineColor,
    required this.backgroundColor,
    required this.animation,
    required this.duration,
    required this.onFinished,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    switch (widget.animation.toLowerCase()) {
      case 'fade':
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
        break;
      case 'scale':
        _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
        break;
      case 'rotate':
        _animation = Tween<double>(
          begin: 0.0,
          end: 2 * 3.14159,
        ).animate(_controller);
        break;
      case 'slide':
        _animation = Tween<double>(
          begin: -200.0,
          end: 0.0,
        ).animate(_controller);
        break;
      default:
        _animation = Tween<double>(begin: 1.0, end: 1.0).animate(_controller);
    }

    _controller.forward();
    Timer(Duration(seconds: widget.duration), widget.onFinished);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                Widget animatedWidget;
                switch (widget.animation.toLowerCase()) {
                  case 'fade':
                    animatedWidget = Opacity(
                      opacity: _animation.value,
                      child: child,
                    );
                    break;
                  case 'scale':
                    animatedWidget = Transform.scale(
                      scale: _animation.value,
                      child: child,
                    );
                    break;
                  case 'rotate':
                    animatedWidget = Transform.rotate(
                      angle: _animation.value,
                      child: child,
                    );
                    break;
                  case 'slide':
                    animatedWidget = Transform.translate(
                      offset: Offset(_animation.value, 0),
                      child: child,
                    );
                    break;
                  default:
                    animatedWidget = child!;
                }
                return animatedWidget;
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.splashImage,
                    height: 150,
                    width: 150,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.tagline,
                    style: TextStyle(
                      color: widget.taglineColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
