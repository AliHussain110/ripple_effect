import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Ripple Effect', home: RippleEffect());
  }
}

class RippleEffect extends StatefulWidget {
  const RippleEffect({super.key});

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _position = Offset.zero;
  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void _onTapUpdate(PointerEvent details) {
    // print(details.localPosition);
    _controller.reset();
    _controller.forward();
    setState(() {
      _position = details.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderBuilder((context, shader, _) {
            return AnimatedSampler(
              (image, size, canvas) {
                shader
                  ..setFloat(0, _position.dx)
                  ..setFloat(1, _position.dy)
                  ..setFloat(2, _controller.value * 8)
                  ..setFloat(3, size.width)
                  ..setFloat(4, size.height)
                  ..setImageSampler(0, image);
                canvas.drawRect(
                  Rect.fromLTWH(0, 0, size.width, size.height),
                  Paint()..shader = shader,
                );
              },
              child: Listener(
                onPointerMove: _onTapUpdate,
                onPointerDown: _onTapUpdate,
                child: rippleImage(),
              ),
            );
          }, assetKey: 'shaders/ripple.frag');
        },
      ),
    );
  }

  Widget rippleImage() {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/image.jpg', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
