import 'package:flutter/material.dart';

abstract class AppModal {
  OverlayEntry? _entry;
  final BuildContext _context;
  final Function()? onDismiss;

  Widget build(BuildContext context, AppModal modal);

  AppModal(this._context, {this.onDismiss});

  void show() {
    _entry = OverlayEntry(builder: (_) => build(_context, this));
    Overlay.of(_context).insert(_entry!);
  }

  void hide() {
    _entry?.remove();
    onDismiss?.call();
  }
}
