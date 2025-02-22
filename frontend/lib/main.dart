import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:gogogame_frontend/core/extensions/color_extension.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/core/themes/app_theme.dart';
import 'package:gogogame_frontend/pages/auth/login_page/login_page.dart';
import 'package:gogogame_frontend/pages/home_page.dart';
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
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
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

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   // oauth
//   final FlutterAppAuth _appAuth = FlutterAppAuth();
//   Future<void> _loginWithOAuth() async {
//     try {
//       final AuthorizationTokenResponse? result = await _appAuth
//           .authorizeAndExchangeCode(
//             AuthorizationTokenRequest(
//               'your_client_id',
//               'your_redirect_url',
//               issuer: 'https://your_oauth_provider.com',
//               scopes: ['openid', 'profile', 'email'],
//             ),
//           );

//       if (result != null) {
//         // Login successful plz change this <-----------------
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Login Successful')));
//         // Handle the result, e.g., save tokens, navigate to another page, etc.
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Login Failed: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   return null;
//                 },
//               ),

//               SizedBox(height: 20),

//               ElevatedButton(
//                 // Login button plz change this <-----------------
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // Process data
//                     ScaffoldMessenger.of(
//                       context,
//                     ).showSnackBar(SnackBar(content: Text('Processing Data')));
//                   }
//                 },
//                 child: Text('Login'),
//               ),

//               SizedBox(height: 20),

//               ElevatedButton(
//                 onPressed: _loginWithOAuth,
//                 child: Text('Login with OAuth'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
