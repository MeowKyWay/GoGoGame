import 'package:flutter/cupertino.dart';

class PaddingModal extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const PaddingModal({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(padding: padding, child: child),
    );
  }
}
