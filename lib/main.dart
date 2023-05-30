import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/auth/view/login.dart';
import 'package:twitter_clone/features/home/view/home.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:twitter_clone/widgets/error_page.dart';
import 'package:twitter_clone/widgets/loading_page.dart';

void main() {
  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Twitter Clone',
      theme: AppTheme.theme,
      home: ref.watch(currentUserProvider).when(
            // data: (user) => user != null ? const Home() : const Login(),
            data: (user) {
              return user != null ? const Home() : const Login();
            },
            error: (error, stackTrace) => ErrorPage(error: error.toString()),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
