import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_restro/core/components/button/default_button.dart';
import 'package:a_restro/core/components/dialog/pop_up_dialog.dart';
import 'package:a_restro/core/components/field/default_field.dart';
import 'package:a_restro/core/components/message/message_bar.dart';
import 'package:a_restro/core/constant/style/app_text.dart';
import 'package:a_restro/core/extensions/build_context_ext.dart';
import 'package:a_restro/data/model/request/add_review_request_model.dart';
import 'package:a_restro/feature/auth/provider/firebase_auth_provider.dart';
import 'package:a_restro/feature/detail_restaurant/provider/add_review/add_review_restaurant_provider.dart';
import 'package:a_restro/feature/detail_restaurant/provider/add_review/add_review_restaurant_state.dart';
import 'package:a_restro/feature/profile/provider/change_theme_provider.dart';

import '../../../core/common/routes/navigation.dart';
import '../../../core/constant/style/app_colors.dart';
import '../../../core/constant/url_assets/url_assets.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key, required this.restoId});

  final String restoId;

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  late TextEditingController _reviewC;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _reviewC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _reviewC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ChangeThemeProvider>();

    AppBar appBar() {
      return AppBar(
        centerTitle: true,
        title: Image.asset(
          UrlAssets.iconLogoWithName,
          scale: 3.5,
        ),
        leading: BackButton(
          color:
              theme.isDarkTheme ? AppColors.whiteColor : AppColors.blackColor,
        ),
      );
    }

    Widget fieldSection() {
      return SizedBox(
        width: context.deviceWidth,
        height: context.deviceHeight * 1 / 4,
        child: DefaultField(
          inputType: TextInputType.multiline,
          maxLines: null,
          expands: true,
          minLines: null,
          hintText: 'Add your review..',
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please Input our Review';
            }
            return null;
          },
          controller: _reviewC,
        ),
      );
    }

    Widget buttonSubmitSection() {
      return Consumer<AddReviewRestaurantProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            AddReviewRestaurantLoadingState() => Center(
                child: CircularProgressIndicator(),
              ),
            AddReviewRestaurantErrorState(error: var error) => PopUpDialog(
                error: error,
              ),
            AddReviewRestaurantIntialState() => DefaultButton(
                title: 'Add Review',
                onTap: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  } else {
                    if (_reviewC.text.isNotEmpty) {
                      final data = AddReviewRequestModel(
                        id: widget.restoId,
                        review: _reviewC.text,
                        name: context.read<FirebaseAuthProvider>().user?.name ??
                            '',
                      );

                      context
                          .read<AddReviewRestaurantProvider>()
                          .addReviewRestaurant(data);

                      await Future.delayed(
                        const Duration(seconds: 3),
                        () {
                          _reviewC.clear();
                          Navigation.pop();
                          MessageBar.messageBar(context, 'Success add Review');
                        },
                      );
                    }
                  }
                },
              ),
          };
        },
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Add reviews to make the restaurant more developed',
                textAlign: TextAlign.center,
                style: AppText.text16.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.isDarkTheme
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
              ),
              SizedBox(height: 20),
              fieldSection(),
              SizedBox(height: 20),
              buttonSubmitSection(),
            ],
          ),
        ),
      ),
    );
  }
}
