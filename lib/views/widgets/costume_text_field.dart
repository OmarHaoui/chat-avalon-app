import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:test_avalon2/controllers/chat_controller.dart';
import 'package:test_avalon2/utils/constants/sizes.dart';

import '../../utils/constants/colors.dart';

class CostumeTextFormField extends StatefulWidget {
  CostumeTextFormField({
    required this.hintText,
    required this.lableText,
    required this.controller,
    required this.isPassword,
    this.obscureText = false,
    this.isConfirmePassword = false,
  });
  String hintText;
  String lableText;
  bool isPassword;
  bool obscureText;
  bool isConfirmePassword;
  TextEditingController controller;

  @override
  State<CostumeTextFormField> createState() => _CostumeTextFormFieldState();
}

class _CostumeTextFormFieldState extends State<CostumeTextFormField> {
  final ChatController chatController = Get.find<ChatController>();
  Widget build(BuildContext context) {
    return TextFormField(
        // onChanged: (value) {
        //   if (widget.isPassword && !widget.isConfirmePassword) {
        //     chatController.passwordController.value.text = value;
        //   }
        // },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 15),
          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 15),
          //label: Text(widget.lableText, style: TextStyle(fontSize: 20)),
          alignLabelWithHint: true,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                    size: 18,
                  ),
                )
              : null,

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: TColors.primary),
            borderRadius: BorderRadius.circular(TSizes.buttonRadiusM),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: TColors.softGrey),
            borderRadius: BorderRadius.circular(TSizes.buttonRadiusM),
          ),
        ),
        controller: widget.controller,
        obscureText: widget.obscureText,
        style: TextStyle(fontSize: 15),
        validator: (value) {
          if (widget.isPassword) {
            if (widget.isConfirmePassword) {
              return validateConfirmePassword(
                value,
                chatController.passwordController.value.text,
              );
            } else {
              return validatePassword(value);
            }
          } else {
            return validateEmail(value);
          }
        });
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required.';
    }

    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email format.';
    }

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required.';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    return null;
  }

  String? validateConfirmePassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password again.';
    }
    if (value != originalPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }
}
