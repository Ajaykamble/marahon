import 'package:marathon/config/theme/filled_button_theme_style.dart';
import 'package:marathon/utils/app_color_scheme.dart';
import 'package:marathon/widget/primary_filled_button.dart';

class SecondaryFilledButton extends PrimaryFilledButton {
  const SecondaryFilledButton({
    required super.buttonTitle,
    super.key,
    super.onPressed,
    super.buttonThemeStyle = const FilledButtonThemeStyle(
      enabledButtonColor: AppColorScheme.kSecondaryColor,
    ),
    super.isLoading = false,
  });
}
