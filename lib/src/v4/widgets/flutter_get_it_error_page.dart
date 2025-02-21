import 'package:flutter/material.dart';

class FlutterGetItErrorPage extends StatelessWidget {
  final Exception? exception;
  final StackTrace? stackTrace;
  final String? tip;
  final String? description;

  const FlutterGetItErrorPage({
    super.key,
    this.exception,
    this.stackTrace,
    this.tip,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('FGetIt Error Information'),
      ),
      body: Center(
        child: SizedBox(
          width: 420,
          child: ListView(
            children: [
              const Center(
                child: Text(
                  'We detected an error! Be sure to check the following information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Description',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Card(
                  color: Colors.yellow.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Tip',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tip ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
