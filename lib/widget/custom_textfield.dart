import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marathon/utils/app_styles.dart';
import 'package:marathon/utils/app_values.dart';
import '../utils/enums.dart' show TextFieldPrefixSuffixType;

import '../utils/custom_input_formatter.dart';
import 'space_widget.dart';

@immutable
class CustomTextField extends StatelessWidget {
  /// [heading] is label text for the TextFormField
  /// if you don't pass heading it wont be visible
  final String? heading;

  /// [hintText] is hintText for the TextFormField
  final String? hintText;

  /// [hasPrefix] if TextFormField has a Prefix Text set this variable as `true` default values is `false`
  /// if you set [hasPrefix] as `true` then you have to pass [prefixType] and [prefixData] compulsory
  final bool hasPrefix;

  /// color for prefix background.
  /// default is set to transparent
  final Color prefixBackgroundColor;

  /// we are supporting 3 types of prefix declared in this enum [TextFieldPrefixSuffixType]
  /// 1. if you want to set Text as prefix then pass [prefixType] as [TextFieldPrefixSuffixType.TEXT]
  /// 2. if you want to set SvgAsset as prefix then pass [prefixType] as [TextFieldPrefixSuffixType.SVG_ASSET]
  /// 3. if you want to set Image Asset as prefix then pass [prefixType] as [TextFieldPrefixSuffixType.IMAGE_ASSET]
  final TextFieldPrefixSuffixType? prefixType;

  /// if [prefixType] is set as [TextFieldPrefixSuffixType.TEXT] then pass text of prefix
  /// if [prefixType] is set as [TextFieldPrefixSuffixType.SVG_ASSET] or [TextFieldPrefixSuffixType.IMAGE_ASSET] then pass asset path of icon
  final String? prefixData;
  final Widget? prefixWidget;

  /// if prefix has click action then pass this function to [onPrefixClick] default is set to null
  final VoidCallback? onPrefixClick;

  /// [hasSuffix] if TextFormField has a Suffix then set this variable as `true` default values is `false`
  /// if you set [hasSuffix] as `true` then you have to pass [suffixType] and [suffixData] compulsory
  final bool hasSuffix;

  /// we are supporting 3 types of suffix declared in this enum [TextFieldPrefixSuffixType]
  /// 1. if you want to set Text as suffix then pass [suffixType] as [TextFieldPrefixSuffixType.TEXT]
  /// 2. if you want to set SvgAsset as suffix then pass [suffixType] as [TextFieldPrefixSuffixType.SVG_ASSET]
  /// 3. if you want to set Image Asset as suffix then pass [suffixType] as [TextFieldPrefixSuffixType.IMAGE_ASSET]
  final TextFieldPrefixSuffixType? suffixType;

  /// if [suffixType] is set as [TextFieldPrefixSuffixType.TEXT] then pass text of Suffix
  /// if [suffixType] is set as [TextFieldPrefixSuffixType.SVG_ASSET] or [TextFieldPrefixSuffixType.IMAGE_ASSET] then pass asset path of icon
  final String? suffixData;

  /// if suffix has click action then pass this function to [onSuffixClick] default is set to null
  final VoidCallback? onSuffixClick;

  /// to set keyboard type to TextFormField default is set to [TextInputType.text]
  final TextInputType? keyboardType;

  final TextEditingController? controller;

  /// Validator for TextFormField
  final String? Function(String?)? validator;

  /// inputFormatters allow you restrict characters in the characters by default it allow to enter a to z, A to Z, 0 to 9 and space.
  final List<TextInputFormatter>? inputFormatterList;

  /// set this variable to enable disable textFormField
  final bool? enabled;

  /// set this variable to make TextFormField readonly
  final bool readOnly;

  /// [fieldMinLines] can be used when [keyboardType] set to [TextInputType.multiline]. default values is 3.
  /// [fieldMinLines] must be always > 0
  final int? fieldMinLines;

  /// [fieldMaxLines] can be used when [keyboardType] set to [TextInputType.multiline]. default values is 6.
  /// [fieldMaxLines] must be always > [fieldMinLines]
  final int? fieldMaxLines;

  /// [obscureText] can be used when you want to hide the text. default values is false.
  final bool obscureText;

  /// onChanged Callback for TextFormField
  final void Function(String)? onChanged;

  /// onTap callback for TextFormField
  final VoidCallback? onTap;

  final FocusNode? focusNode;
  final TextAlign textAlign;
  final double prefixSize;

  static _getPrefixAssert(bool hasPrefix, TextFieldPrefixSuffixType? prefixType, String? prefixData, VoidCallback? onButtonClick) {
    if (hasPrefix) {
      if (prefixType == null) {
        throw Exception("hasPrefix has set to true prefixType should not be null");
      }
      if (prefixData == null) {
        throw Exception("hasPrefix has set to true prefixData should not be null");
      }
    } else {
      if (prefixType != null) {
        throw Exception("hasPrefix has set to false you cannot add prefixType");
      }
      if (prefixData != null) {
        throw Exception("hasPrefix has set to false you cannot add prefixData");
      }
    }

    return true;
  }

  static _getSuffixAssert(bool hasSuffix, TextFieldPrefixSuffixType? suffixType, String? suffixData, VoidCallback? onButtonClick) {
    if (hasSuffix) {
      if (suffixType == null) {
        throw Exception("hasSuffix has set to true suffixType should not be null");
      }
      if (suffixData == null) {
        throw Exception("hasSuffix has set to true suffixData should not be null");
      }
    } else {
      if (suffixType != null) {
        throw Exception("hasSuffix has set to false you cannot add suffixType");
      }
      if (suffixData != null) {
        throw Exception("hasSuffix has set to false you cannot add suffixData");
      }
    }

    return true;
  }

  static _getMultilineAssert(TextInputType? keyboardType, int? minLines) {
    if (keyboardType != TextInputType.multiline) {
      if (minLines != null) {
        throw Exception("You cannot set minLines if keyboard Type is ${keyboardType?.toJson()["name"]}.\nSet Keyboard type TextInputType.multiline");
      }
    }

    return true;
  }

  static List<TextInputFormatter>? getInputFormatter(keyboardType) {
    if (keyboardType == TextInputType.multiline) {
      return [CustomInputFormatter(regx: r'^[a-zA-Z0-9 \n]*$')];
    } else if (keyboardType == TextInputType.number) {
      return [AppValues.numberInputFormatter];
    } else {
      return [CustomInputFormatter(regx: r'^[a-zA-Z0-9 \n!@#$%^&*()_+\-=\[\]{};:\"\\,.<>\/?\b]*$')];
    }
  }

  CustomTextField({
    super.key,
    this.focusNode,
    this.hintText,
    this.heading,
    this.prefixType,
    this.prefixData,
    this.onPrefixClick,
    this.suffixType,
    this.suffixData,
    this.onSuffixClick,
    this.controller,
    this.enabled,
    this.validator,
    this.onChanged,
    this.onTap,
    this.prefixWidget,
    this.prefixSize = 50,
    this.prefixBackgroundColor = Colors.transparent,
    this.readOnly = false,
    this.hasPrefix = false,
    this.hasSuffix = false,
    this.textAlign = TextAlign.start,
    this.keyboardType = TextInputType.text,
    int? minLines,
    int? maxLines,
    List<TextInputFormatter>? inputFormatters,
    this.obscureText = false,
  })  : assert(_getPrefixAssert(hasPrefix, prefixType, prefixData, onPrefixClick)),
        assert(_getSuffixAssert(hasSuffix, suffixType, suffixData, onSuffixClick)),
        assert(_getMultilineAssert(keyboardType, minLines)),
        inputFormatterList = inputFormatters ?? getInputFormatter(keyboardType),
        fieldMinLines = minLines ?? (keyboardType == TextInputType.multiline ? 3 : null),
        fieldMaxLines = maxLines ?? (keyboardType == TextInputType.multiline ? 6 : 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null) ...[
          Text(
            heading!,
            style: AppStyles.titleSmall,
          ),
          const SpaceWidget(),
        ],
        TextFormField(
          focusNode: focusNode,
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          onTap: onTap,
          inputFormatters: inputFormatterList,
          enableSuggestions: true,
          enabled: enabled,
          readOnly: readOnly,
          minLines: fieldMinLines,
          maxLines: fieldMaxLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppStyles.bodyMedium,
          textAlignVertical: TextAlignVertical.center,
          onChanged: onChanged,
          textAlign: textAlign,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            isDense: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            prefixIcon: !hasPrefix
                ? null
                : Semantics(
                    button: onPrefixClick != null,
                    enabled: onPrefixClick != null,
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Material(
                            color: prefixBackgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                            ),
                            child: InkWell(
                              onTap: onPrefixClick,
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                              child: SizedBox(
                                width: prefixSize,
                                child: Center(
                                  child: Builder(
                                    builder: (context) {
                                      switch (prefixType) {
                                        case TextFieldPrefixSuffixType.TEXT:
                                          return Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            margin: EdgeInsets.only(bottom: 1),
                                            child: Center(child: Text(prefixData!, style: AppStyles.bodyMedium)),
                                          );
                                        //return Text(prefixData!, style: AppStyles.bodyMedium);
                                        case TextFieldPrefixSuffixType.SVG_ASSET:
                                          return SvgPicture.asset(prefixData!);
                                        case TextFieldPrefixSuffixType.IMAGE_ASSET:
                                          return Image.asset(prefixData!);
                                        case TextFieldPrefixSuffixType.WIDGET:
                                          return prefixWidget!;
                                        default:
                                          return Text(prefixData!, style: AppStyles.bodyMedium);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (prefixBackgroundColor != Colors.transparent) const SpaceWidget(),
                        ],
                      ),
                    ),
                  ),
            suffixIcon: !hasSuffix
                ? null
                : Semantics(
                    button: onSuffixClick != null,
                    enabled: onSuffixClick != null,
                    child: InkWell(
                      onTap: onSuffixClick,
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                      child: SizedBox(
                        width: 50,
                        child: Center(
                          child: Builder(
                            builder: (context) {
                              switch (suffixType) {
                                case TextFieldPrefixSuffixType.TEXT:
                                  return Text(suffixData!, style: AppStyles.bodyMedium);
                                case TextFieldPrefixSuffixType.SVG_ASSET:
                                  return SvgPicture.asset(suffixData!);
                                case TextFieldPrefixSuffixType.IMAGE_ASSET:
                                  return Image.asset(suffixData!);
                                default:
                                  return Text(suffixData!, style: AppStyles.bodyMedium);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
