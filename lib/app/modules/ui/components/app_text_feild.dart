import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppTextField extends StatefulWidget {
  AppTextField({
    super.key,
    this.label,
    this.validator,
    this.onChanged,
    this.suffix,
    required this.controller,
    this.isSearch = false,
  });

  String? label;
  Widget? suffix;
  TextEditingController controller;
  Function(String? input)? validator;
  Function(String? input)? onChanged;
  bool isSearch;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  RxBool isFocused = false.obs;

  // FocusNode focusNode = FocusNode();

  @override
  void initState() {
    /* focusNode.addListener(() {
      isFocused(focusNode.hasFocus);
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isSearch ? 45.h : 80.h,
      child: TextFormField(
        // focusNode: focusNode,
        decoration: InputDecoration(
          label: widget.label != null ? Text(widget.label.toString()) : null,
          suffix: widget.suffix,
          isDense: true,
          constraints: BoxConstraints(
            maxHeight: 45.h,
            minHeight: 45.h,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.r),
            ),
            borderSide: BorderSide(
              width: 0.6.w,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.r),
            ),
            borderSide: BorderSide(
              width: 0.6.w,
            ),
          ),
          /* enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.r),
            ),
            borderSide: BorderSide(
              width: 0.6.w,
            ),
          ),*/
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.r),
            ),
            borderSide: BorderSide(
              width: 0.6.w,
            ),
          ),
          // filled: true, //isFocused(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.w,
            ),
          ),
        ),
        controller: widget.controller,
        validator: (value) => widget.validator?.call(value),
        onChanged: (value) => widget.onChanged?.call(value),
      ),
    );
  }
}
