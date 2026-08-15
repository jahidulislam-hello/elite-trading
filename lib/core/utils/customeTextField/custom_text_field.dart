import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscure;
  final Color? filColor;
  final Color? hinTextColor;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final int? maxLine;
  final double? hinTextSize;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;
  final Color? borderColor;
  final double? borderHeight;
  final double? borderRadius;
  final VoidCallback? onTap;
  final ValueChanged? onChanged;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool isvalidation;
  final FocusNode? focusNode;
  final Color? iconColor;
  final double? levelTextSize;
  final Color? levelTextColor;

  const CustomTextField(
      {super.key,
        this.contentPaddingHorizontal,
        this.contentPaddingVertical,
        this.hintText,
        this.prefixIcon,
        this.suffixIcon,
        this.maxLine,
        this.validator,
        this.hinTextColor,
        this.borderColor,
        this.isEmail = false,
        required this.controller,
        this.keyboardType = TextInputType.text,
        this.isObscureText = false,
        this.obscure = '*',
        this.filColor,
        this.hinTextSize,
        this.labelText,
        this.isPassword = false,
        this.readOnly = false,
        this.borderRadius,
        this.borderHeight,
        this.onTap,
        this.onChanged,
        this.maxLength,
        this.inputFormatters,
        this.isvalidation = true,
        this.focusNode,
        this.iconColor,
        this.levelTextSize,
        this.levelTextColor
      });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  OutlineInputBorder customBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
        borderSide: BorderSide(
            color: widget.borderColor ?? Colors.white,
            width: widget.borderHeight ?? 1));
  }

  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null)
            Text(widget.labelText ?? '',
              style: GoogleFonts.montserrat(
                  fontSize:widget.levelTextSize ?? 14.h,
                  color:widget.levelTextColor?? Colors.black,
                  fontWeight: FontWeight.w600
              ),
            ),
          SizedBox(height: 8.h,),
          TextFormField(
            onChanged: widget.onChanged,
            focusNode: widget.focusNode,
            autofocus: false,
            onTap: widget.onTap,
            readOnly: widget.readOnly!,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscuringCharacter: widget.obscure!,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: widget.maxLine != null ? widget.maxLine : 1,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            validator: widget.isvalidation == false
                ? null
                : widget.validator ??
                    (value) {
                  if (widget.isEmail == false) {
                    if (value!.isEmpty) {
                      return "Please ${widget.hintText?.toLowerCase()}";
                    } else if (widget.isPassword) {
                      if (value.isEmpty) {
                        return "Please ${widget.hintText?.toLowerCase()}";
                      }
                    }
                  } else {
                    bool data =
                    AppConstants.emailValidate.hasMatch(value!);
                    if (value.isEmpty) {
                      return "Please ${widget.hintText!.toLowerCase()}";
                    } else if (!data) {
                      return "Please check your email!";
                    }
                  }
                  return null;
                },
            obscureText: widget.isPassword ? obscureText : false,
            style: GoogleFonts.montserrat(
                color: widget.hinTextColor ?? Colors.black,
                fontSize: widget.hinTextSize ?? 12
            ),
            decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.contentPaddingHorizontal ?? 20,
                    vertical: widget.contentPaddingVertical ?? 10),
                fillColor:
                widget.filColor != null ? widget.filColor : Colors.white,
                filled: true,
                prefixIcon: widget.prefixIcon != null
                    ? Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12),
                  child: IconTheme(
                    data: IconThemeData(
                      color: widget.iconColor ?? Colors.grey,
                    ),
                    child: widget.prefixIcon!,
                  ),
                )
                    : null,
                suffixIcon: widget.isPassword
                    ? GestureDetector(
                    onTap: toggle,
                    child: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: widget.iconColor ?? Colors.grey,
                    ))
                    : widget.suffixIcon,
                prefixIconConstraints:
                const BoxConstraints(minHeight: 24, minWidth: 24),
                hintText: widget.hintText,
                hintStyle: GoogleFonts.montserrat(
                   color: widget.hinTextColor ?? Colors.grey,
                   fontSize: widget.hinTextSize ?? 16,
                    fontWeight: FontWeight.w400
                ),
                focusedBorder: customBorder(),
                enabledBorder: customBorder(),
                border: customBorder(),
                errorStyle: GoogleFonts.montserrat(
                 fontSize: 12, fontWeight: FontWeight.w400
              ),
            ),
          ),
        ],
      ),
    );
  }
}