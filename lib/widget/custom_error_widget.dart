
import 'package:flutter/material.dart';
import 'package:marathon/config/theme/filled_button_theme_style.dart';
import 'package:marathon/utils/app_constant.dart';
import 'package:marathon/utils/app_styles.dart';
import 'package:marathon/widget/primary_filled_button.dart';
import 'package:marathon/widget/space_widget.dart';

class CustomErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const CustomErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            AppConstant.ERROR_SOMETHING_WENT_WRONG,
            style: AppStyles.titleMedium,
          ),
        ),
        const SpaceWidget(
          height: 15,
        ),
        Center(
          child: PrimaryFilledButton(
            buttonTitle: AppConstant.RETRY_BUTTON_NEXT,
            onPressed: onRetry,
            buttonThemeStyle: const FilledButtonThemeStyle(
              buttonPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 10)
            ),
          ),
        )
      ],
    );
  }
}
