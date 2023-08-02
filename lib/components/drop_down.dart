import 'package:flutter/material.dart';

class AppDropDown extends StatelessWidget {
  const AppDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          items: ['Install', 'Remove'].map(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
          onChanged: (value) {
            //setState(() => widget.defaultCommand = value!);
          },
          hint: const Text('Select Command'),
          //value: widget.defaultCommand,
          isDense: false,
        ),
      ),
    );
  }
}
