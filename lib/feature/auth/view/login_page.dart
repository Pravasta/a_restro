import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/core/common/routes/navigation.dart';
import 'package:a_restro/core/common/routes/routes_name.dart';
import 'package:a_restro/core/components/button/default_button.dart';
import 'package:a_restro/core/components/field/default_field.dart';
import 'package:a_restro/core/components/message/message_bar.dart';
import 'package:a_restro/core/constant/style/app_colors.dart';
import 'package:a_restro/core/extensions/build_context_ext.dart';
import 'package:a_restro/data/model/request/login_request_model.dart';
import 'package:a_restro/data/static/firebase_auth_status_static.dart';
import 'package:a_restro/feature/auth/provider/firebase_auth_provider.dart';
import 'package:a_restro/feature/profile/provider/change_theme_provider.dart';

import '../../../core/constant/style/app_text.dart';
import '../../../core/constant/url_assets/url_assets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailC;
  late TextEditingController _passC;

  @override
  void initState() {
    super.initState();
    _emailC = TextEditingController();
    _passC = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailC.dispose();
    _passC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ChangeThemeProvider>();

    Widget headerSection() {
      return Column(
        spacing: 10,
        children: [
          Image.asset(UrlAssets.iconLogo, scale: 6),
          Text(
            'Login',
            style: AppText.text24.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.isDarkTheme
                  ? AppColors.whiteColor
                  : AppColors.blackColor,
            ),
          ),
          Text(
            'with login you can order a food and drink',
            style: AppText.text16.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.isDarkTheme
                  ? AppColors.greyLightColor
                  : AppColors.greyColor,
            ),
          ),
        ],
      );
    }

    Widget fieldSection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: AppText.text16.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.isDarkTheme
                  ? AppColors.whiteColor
                  : AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 10),
          DefaultField(
            inputType: TextInputType.emailAddress,
            controller: _emailC,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please Input our Email';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Password',
            style: AppText.text16.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.isDarkTheme
                  ? AppColors.whiteColor
                  : AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 10),
          Consumer<FirebaseAuthProvider>(
            builder: (context, value, child) {
              return DefaultField(
                inputType: TextInputType.text,
                controller: _passC,
                isObscure: value.isObsecure,
                suffixIcon: IconButton(
                  onPressed: () {
                    value.changeVisibilityPassword();
                  },
                  icon: Icon(
                    value.isObsecure ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Input our Password';
                  }
                  return null;
                },
              );
            },
          ),
        ],
      );
    }

    Widget buttonSubmitSection() {
      return Consumer<FirebaseAuthProvider>(
        builder: (context, value, child) {
          return switch (value.authStatus) {
            FirebaseAuthStatusStatic.authenticating =>
              Center(child: CircularProgressIndicator()),
            _ => DefaultButton(
                title: 'Login',
                onTap: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  } else {
                    if (_emailC.text.isNotEmpty && _passC.text.isNotEmpty) {
                      await value.signInUser(
                        LoginRequestModel(
                          email: _emailC.text,
                          password: _passC.text,
                        ),
                      );

                      switch (value.authStatus) {
                        case FirebaseAuthStatusStatic.authenticated:
                          Navigation.pushReplacement(RoutesName.mainPage);

                        case _:
                          MessageBar.messageBar(context, value.message);
                      }
                    }
                  }
                },
              ),
          };
        },
      );
    }

    Widget buttonToRegister() {
      return Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigation.pushName(RoutesName.register);
          },
          child: Text(
            'Don\'t have an account? Register',
            style: AppText.text12.copyWith(
              color: theme.isDarkTheme
                  ? AppColors.greyLightColor
                  : AppColors.greyColor,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: context.deviceHeight * 1 / 6),
                headerSection(),
                SizedBox(height: 20),
                fieldSection(),
                buttonToRegister(),
                SizedBox(height: 20),
                buttonSubmitSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
