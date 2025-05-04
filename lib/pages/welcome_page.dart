import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatsetgo/config/my_images.dart';
import 'package:chatsetgo/config/my_strings.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 30),
              const WelcomeHeading(),
              const SizedBox(height: 60),
              const WelcomeBody(),
              const SizedBox(height: 80),
              const WelcomeSlide(),
              // const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}


// ─── Top Heading Widget ────────────────────────────────────────────────
class WelcomeHeading extends StatelessWidget {
  const WelcomeHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SvgPicture.asset(
            MyImages.appIconSVG,
            height: 60,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppString.appName,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}

// ─── Body Content Widget ───────────────────────────────────────────────
class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(MyImages.boyPic),
            const SizedBox(width: 12),
            SvgPicture.asset(MyImages.connectIconSVG),
            const SizedBox(width: 12),
            Image.asset(MyImages.girlPic),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          WelcomePageStrings.nowYouAre,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          WelcomePageStrings.connected,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        Text(
          WelcomePageStrings.decription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}


// ─── Slide Widget ───────────────────────────────────────────────
class WelcomeSlide extends StatefulWidget {
  const WelcomeSlide({super.key});

  @override
  State<WelcomeSlide> createState() => _WelcomeSlideState();
}

class _WelcomeSlideState extends State<WelcomeSlide> {
  double _dragPosition = 0.0;
  bool _submitted = false;

  final double _maxDragDistance = 280;

  void _onDragUpdate(DragUpdateDetails details) {
    if (_submitted) return;
    setState(() {
      _dragPosition += details.delta.dx;
      if (_dragPosition < 0) _dragPosition = 0;
      if (_dragPosition > _maxDragDistance) _dragPosition = _maxDragDistance;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_submitted) return;

    if (_dragPosition >= _maxDragDistance * 0.9) {
      setState(() {
        _submitted = true;
      });

      // Simulate delay before navigating
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.offAllNamed("/authPage");
      });
    } else {
      // Slide back
      setState(() {
        _dragPosition = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = Theme.of(context).colorScheme.primaryContainer;
    final Color fg = Theme.of(context).colorScheme.primary;
    final textStyle = Theme.of(context).textTheme.labelLarge;

    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background track
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(40),
            ),
            alignment: Alignment.center,
            child: Text(
              _submitted ? "Connecting..." : "Slide to start",
              style: textStyle,
            ),
          ),

          // Draggable button
          AnimatedPositioned(
            duration: const Duration(milliseconds: 0),
            left: _dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: fg,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    MyImages.plugIconSVG,
                    width: 25,
                    height: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

