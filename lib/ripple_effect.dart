import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class RippleEffect extends StatefulWidget {
  const RippleEffect({super.key});

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _position = Offset.zero;
  final String shaderAsset = 'shaders/ripple.frag';
  final String imageAsset = 'assets/image.jpg';
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
    // .reset to start from the beginning e.g if controller value is 0.5
    // reset will make it 0.0
    _controller.reset();
    // .forward to play the animation
    _controller.forward();
    // update the position where user has tapped
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
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, _position.dx)
                  ..setFloat(3, _position.dy)
                  ..setFloat(4, _controller.value * 8)
                  ..setImageSampler(0, image);
                canvas.drawRect(
                  Rect.fromLTWH(0, 0, size.width, size.height),
                  Paint()..shader = shader,
                );
              },
              // child: GestureDetector(
              //   onPanUpdate: _onTapUpdate,
              //   // onPanDown: _onTapUpdate,
              //   onPanCancel: ,
              child: _rippleImage(),
            );
          }, assetKey: shaderAsset);
        },
      ),
    );
  }

  Widget _rippleImage() {
    return Listener(
      onPointerMove: _onTapUpdate,
      onPointerDown: _onTapUpdate,
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(imageAsset, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
