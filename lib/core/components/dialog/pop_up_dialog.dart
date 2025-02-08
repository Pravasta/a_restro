import 'package:flutter/material.dart';

import '../../common/routes/navigation.dart';
import '../../constant/style/app_colors.dart';
import '../../constant/style/app_text.dart';
import '../button/default_button.dart';

class PopUpDialog extends StatelessWidget {
  const PopUpDialog({
    super.key,
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.blackColor,
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(error,
                style: AppText.text14.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DefaultButton(
              title: 'Back',
              onTap: () => Navigation.pop(),
              backgroundColor: AppColors.greyColor,
              borderRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
