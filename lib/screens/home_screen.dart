import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Trace App', style: theme.textTheme.headlineLarge),
            const SizedBox(height: 4.0),
            Text(
              'Welcome to Trace app',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Log in'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _register(context, 'client'),
              child: const Text('Register as client'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _register(context, 'establishment'),
              child: const Text('Register as establishment'),
            ),
          ],
        ),
      ),
    );
  }

  void _register(BuildContext context, String type) {
    context.go(
      Uri(
        path: '/register/$type',
        queryParameters: {'type': type},
      ).toString(),
    );
  }
}
