import 'package:flutter/cupertino.dart';

class CenterModal extends StatelessWidget {
  final Widget child;

  const CenterModal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Center(child: child),
    );
  }
}
