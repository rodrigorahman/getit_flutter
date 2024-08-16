import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double width = 0.0;
  double height = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        width = 200;
        height = 200;
      });
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/Landing/Initialize');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashPage'),
      ),
      body: Center(
        child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            width: width,
            height: height,
            child: const FlutterLogo(
              size: 200,
            )),
      ),
    );
  }
}
