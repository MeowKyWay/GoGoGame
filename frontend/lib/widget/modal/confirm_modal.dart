import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';
import 'package:gogogame_frontend/widget/modal/app_modal.dart';
import 'package:gogogame_frontend/widget/modal/center_modal.dart';

/// usage: await ConfirmModal(context).show();
/// returns: true if right button is clicked, false if left button is clicked
/// returns: null if modal is dismissed
class ConfirmModal extends AppModal<bool> {
  final Function()? onLeftButton;
  final Function()? onRightButton;
  final String title;
  final String message;
  final String leftButtonText;
  final String rightButtonText;

  ConfirmModal(
    super.context, {
    required super.vsync,
    this.title = 'Confirm',
    this.onLeftButton,
    this.onRightButton,
    this.message = 'Are you sure?',
    this.leftButtonText = 'Cancle',
    this.rightButtonText = 'Yes',
  });

  @override
  Widget build(BuildContext context, AppModal modal) {
    return _ConfirmModal(
      context: context,
      modal: this,
      title: title,
      message: message,
      onLeftButton: onLeftButton,
      onRightButton: onRightButton,
      leftButtonText: leftButtonText,
      rightButtonText: rightButtonText,
    );
  }
}

class _ConfirmModal extends StatelessWidget {
  final BuildContext context;
  final ConfirmModal modal;
  final String title;
  final String message;
  final Function()? onLeftButton;
  final Function()? onRightButton;
  final String leftButtonText;
  final String rightButtonText;

  const _ConfirmModal({
    required this.context,
    required this.modal,
    required this.title,
    required this.message,
    required this.onLeftButton,
    required this.onRightButton,
    required this.leftButtonText,
    required this.rightButtonText,
  });

  @override
  Widget build(BuildContext _) {
    return Theme(
      data: context.theme,
      child: CenterModal(
        child: CenterModal(
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: ColorScheme.of(context).surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: context.textTheme.titleMedium?.withFontWeight(
                          FontWeight.bold,
                        ),
                      ),
                      Gap(8),
                      Text(
                        message,
                        style: context.textTheme.bodyLarge,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: context.colorScheme.outlineVariant,
                            ),
                            top: BorderSide(
                              color: context.colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        child: CupertinoButton(
                          onPressed: () {
                            onLeftButton?.call();
                            modal.hide(false);
                          },
                          child: Text(
                            leftButtonText,
                            style: TextStyle(
                              color: context.colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: context.colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        child: CupertinoButton(
                          onPressed: () {
                            onRightButton?.call();
                            modal.hide(true);
                          },
                          child: Text(
                            rightButtonText,
                            style: TextStyle(
                              color: context.colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
