import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/color_extension.dart';
import 'package:gogogame_frontend/widget/icons/rotated_icon.dart';
import 'package:gogogame_frontend/widget/modals/center_modal.dart';
import 'package:gogogame_frontend/widget/modals/modal_background.dart';

class QueueModal {
  OverlayEntry? _entry;
  final BuildContext _context;

  QueueModal._(this._context);

  static QueueModal show(BuildContext context) {
    final modal = QueueModal._(context);
    modal._entry = OverlayEntry(
      builder:
          (overlayContext) =>
              _QueueModal(context: modal._context, modal: modal),
    );
    Overlay.of(context).insert(modal._entry!);
    return modal;
  }

  void hide() {
    _entry?.remove();
  }
}

class _QueueModal extends StatefulWidget {
  final BuildContext context;
  final QueueModal modal;

  const _QueueModal({required this.context, required this.modal});

  @override
  State<_QueueModal> createState() => _QueueModalState();
}

class _QueueModalState extends State<_QueueModal> {
  @override
  Widget build(BuildContext _) {
    return Theme(
      data: Theme.of(widget.context), // Inheriting theme from parent context
      child: ModalBackground(
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
                  Flexible(
                    flex: 1,
                    child: Container(color: Colors.transparent),
                  ),
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
      ),
    );
  }
}
