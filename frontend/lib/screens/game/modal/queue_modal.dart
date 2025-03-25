import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/color_extension.dart';
import 'package:gogogame_frontend/widget/icon/rotated_icon.dart';
import 'package:gogogame_frontend/widget/modal/app_modal.dart';
import 'package:gogogame_frontend/widget/modal/center_modal.dart';

class QueueModal extends AppModal {
  final Function()? onClose;

  QueueModal(super.context, {this.onClose, super.isDissmissable = false});

  @override
  Widget build(BuildContext context, AppModal modal) {
    return _QueueModal(context: context, modal: this, onClose: onClose);
  }
}

class _QueueModal extends StatefulWidget {
  final BuildContext context;
  final QueueModal modal;
  final Function()? onClose;

  const _QueueModal({required this.context, required this.modal, this.onClose});

  @override
  State<_QueueModal> createState() => _QueueModalState();
}

class _QueueModalState extends State<_QueueModal> {
  @override
  Widget build(BuildContext _) {
    return Theme(
      data: Theme.of(widget.context), // Inheriting theme from parent context
      child: CenterModal(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorScheme.of(widget.context).surface.withOpa(0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox.square(
            dimension: 200,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: Container(color: Colors.transparent)),
                RotatedIcon(
                  isRunning: true,
                  icon: const Icon(Icons.hourglass_empty_rounded, size: 48),
                ),
                const Gap(16),
                Text(
                  'Finding opponent...',
                  style:
                      Theme.of(
                        widget.context,
                      ).textTheme.bodyLarge, // Using inherited theme
                ),
                Flexible(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          ColorScheme.of(widget.context).error,
                        ),
                      ),
                      onPressed: () {
                        widget.modal.hide();
                        widget.onClose?.call();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
