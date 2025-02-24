import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';

class SelectButton<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final void Function(T?) onChanged;
  final Icon? prefixIcon;

  const SelectButton({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(prefixIcon: prefixIcon),
        isExpanded: true,
        items:
            items
                .map(
                  (e) =>
                      DropdownMenuItem<T>(value: e, child: Text(e.toString())),
                )
                .toList(),
        onChanged: onChanged,
        value: value,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
