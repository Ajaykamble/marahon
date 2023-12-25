import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:marathon/utils/app_color_scheme.dart';
import 'package:marathon/utils/app_constant.dart';
import 'package:marathon/utils/app_styles.dart';
import 'package:marathon/utils/enums.dart';
import 'package:marathon/widget/primary_filled_button.dart';
import 'package:marathon/widget/space_widget.dart';

@immutable
class CustomDropdown<T> extends StatelessWidget {
  /// [hintText] hint Text for dropdown field
  /// [searchFieldHintText] hint text for search field
  final String? hintText, searchFieldHintText;

  /// Items for dropdown
  final List<T> items;

  /// callback for on changed
  final void Function(T?)? onChanged;

  /// selected item for dropdown
  final T? selectedItem;

  /// validator for dropdown
  final String? Function(T?)? validator;

  /// filter function for dropdown search items
  final bool Function(T, String)? filterFn;
  final bool Function(T, T)? compareFn;

  /// [showSearchBox] enable or disable search field for dropdown items. default value is `true`
  final bool showSearchBox;

  /// [heading] is label text for the Dropdown
  /// if you don't pass heading it wont be visible
  final String? heading;

  final ApiStatus apiStatus;
  final VoidCallback? onRetry;
  final String apiErrorText;
  final TextStyle? dropdownStyle;

  CustomDropdown({
    super.key,
    this.hintText,
    this.heading,
    this.searchFieldHintText,
    this.selectedItem,
    this.validator,
    this.filterFn,
    this.compareFn,
    this.onRetry,
    this.dropdownStyle,
    required this.items,
    required this.onChanged,
    this.apiErrorText = AppConstant.ERROR_SOMETHING_WENT_WRONG,
    this.showSearchBox = true,
    this.apiStatus = ApiStatus.SUCCESS,
  });

  final GlobalKey<FormFieldState> _FormFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return FormField(
      key: _FormFieldKey,
      initialValue: selectedItem,
      validator: validator,
      builder: (field) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading != null) ...[
            Text(heading!, style: AppStyles.titleSmall),
            const SpaceWidget(),
          ],
          if (apiStatus == ApiStatus.LOADING) const Center(child: CircularProgressIndicator()),
          if (apiStatus == ApiStatus.SUCCESS)
            DropdownSearch<T>(
              items: items,
              onChanged: (value) {
                _FormFieldKey.currentState!.didChange(value);
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
              dropdownButtonProps: const DropdownButtonProps(
                padding: EdgeInsets.symmetric(vertical: 10),
                icon: Icon(
                  Icons.expand_more,
                ),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                baseStyle: dropdownStyle ?? AppStyles.titleSmall.copyWith(fontWeight: FontWeight.w500, color: AppColorScheme.kGrayColor.shade700),
                dropdownSearchDecoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppStyles.hintStyle,
                  errorStyle: AppStyles.errorStyle,
                ),
              ),
              selectedItem: selectedItem,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              filterFn: filterFn,
              compareFn: compareFn,
              popupProps: PopupProps.menu(
                showSearchBox: showSearchBox,
                fit: FlexFit.loose,
                showSelectedItems: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: searchFieldHintText,
                    hintStyle: AppStyles.hintStyle,
                    errorStyle: AppStyles.errorStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                    fillColor: AppColorScheme.kLightBlueColor,
                    filled: true,
                  ),
                ),
                itemBuilder: (context, item, isSelected) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(item.toString(),
                        style: AppStyles.titleSmall
                            .copyWith(color: isSelected ? AppColorScheme.kPrimaryColor : AppColorScheme.kGrayColor.shade700, fontWeight: isSelected ? FontWeight.bold : FontWeight.w400)),
                  );
                },
              ),
            ),
          if (apiStatus == ApiStatus.ERROR)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColorScheme.errorTextColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      apiErrorText,
                      style: AppStyles.errorStyle,
                    ),
                  ),
                  const SpaceWidget(),
                  PrimaryFilledButton(
                    buttonTitle: "Retry",
                    onPressed: onRetry,
                  ),
                ],
              ),
            ),
          if (field.hasError) ...[
            const SpaceWidget(),
            Text(
              field.errorText ?? "",
              style: AppStyles.errorStyle,
            ),
          ],
        ],
      ),
    );
  }
}
