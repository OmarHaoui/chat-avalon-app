// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_avalon2/controllers/chat_controller.dart';
import 'package:test_avalon2/utils/constants/colors.dart';
import 'package:test_avalon2/utils/constants/text_strings.dart';
import 'package:test_avalon2/utils/helpers/helper_functions.dart';
import 'package:test_avalon2/views/chat_page.dart';
import 'package:test_avalon2/views/widgets/costume_text_field.dart';
import 'package:test_avalon2/views/widgets/default_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../utils/constants/sizes.dart';

class LoginScreen extends StatelessWidget {
  GlobalKey<FormState> _formkey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

    return GetX<ChatController>(builder: (controller) {
      return ModalProgressHUD(
        inAsyncCall: controller.isLoading.value,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Chatty.',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: 80),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Text(
                      "Sign in to continue ...",
                      style: TextStyle(
                          color: TColors.textPrimary,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 60),
                    CostumeTextFormField(
                      hintText: TTexts.email,
                      lableText: TTexts.email,
                      controller: chatController.emailController,
                      isPassword: false,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    CostumeTextFormField(
                      hintText: TTexts.password,
                      lableText: TTexts.password,
                      controller: chatController.passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 60),
                    defaultButtton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          controller.changeLoading();
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: chatController.emailController.value.text,
                              password:
                                  chatController.passwordController.value.text,
                            );
                            THelperFunctions.showSnackBar(
                                'Successfully signed in');
                            Get.off(() => ChatScreen());
                          } on FirebaseAuthException catch (e) {
                            print(e.message);
                            if (e.code == 'user-not-found') {
                              THelperFunctions.showErrorSnackBar(
                                  context, 'No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              THelperFunctions.showErrorSnackBar(context,
                                  'Wrong password provided for that user.');
                            }
                          } catch (e) {
                            THelperFunctions.showErrorSnackBar(
                              context,
                              e.toString(),
                            );
                          } finally {
                            controller.changeLoading();
                          }
                        }
                      },
                      childText: TTexts.signIn,
                      halfWidth: 80,
                      halfHeight: 15,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    Text(
                      TTexts.orSignUpWith,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    defaultButtton(
                      transparent: true,
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          controller.changeLoading();
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: chatController.emailController.value.text,
                              password:
                                  chatController.passwordController.value.text,
                            );
                            THelperFunctions.showSnackBar(
                                'Successfully signed in');
                            Get.off(() => ChatScreen());
                          } on FirebaseAuthException catch (e) {
                            print(e.message);
                            THelperFunctions.showErrorSnackBar(
                                context, e.message.toString());
                            if (e.code == 'user-not-found') {
                              THelperFunctions.showErrorSnackBar(
                                  context, 'No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              THelperFunctions.showErrorSnackBar(context,
                                  'Wrong password provided for that user.');
                            }
                          } catch (e) {
                            THelperFunctions.showErrorSnackBar(
                              context,
                              e.toString(),
                            );
                          } finally {
                            controller.changeLoading();
                          }
                        }
                      },
                      childText: TTexts.registerNow,
                      halfWidth: 45,
                      halfHeight: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
