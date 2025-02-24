import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:gogogame_frontend/core/extensions/color_extension.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/core/themes/app_theme.dart';
import 'package:gogogame_frontend/screens/auth/login_screen/login_screen.dart';
import 'package:gogogame_frontend/screens/home/home_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAuthenticated = ref.watch(authStateProvider);

    final router = GoRouter(
      refreshListenable: ListenableAuth(ref),
      redirect: (context, state) {
        if (!isAuthenticated) return '/login';
        return '/';
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScaffold()),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      ],
    );
    return GlobalLoaderOverlay(
      overlayWidgetBuilder: (progress) {
        return Center(
          child: SpinKitFoldingCube(color: Colors.white, size: 50.0),
        );
      },
      overlayColor: Colors.white.withOpa(0.1),
      child: MaterialApp.router(
        theme: AppTheme.darkTheme,
        routerConfig: router,
      ),
    );
  }
}

class ListenableAuth extends ChangeNotifier {
  final WidgetRef ref;
  ListenableAuth(this.ref) {
    ref.listen(authStateProvider, (previous, next) => notifyListeners());
  }
}
