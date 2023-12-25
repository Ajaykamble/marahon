import 'package:flutter/services.dart';

/// This CustomInputFormatter can be used as an input formatter for a TextFormField widget by passing it as a parameter to the inputFormatters property of the TextFormField.
/// This will ensure that only input matching the specified regular expression will be allowed in the TextFormField.
/// The class takes in a regular expression [regx] in its constructor, which is used to match the input text.
class CustomInputFormatter extends TextInputFormatter {
  final String regx;

  CustomInputFormatter({required this.regx});

  ///This method is called every time the user inputs a character, deletes a character, or pastes text into the TextFormField.
  ///It takes in two arguments - oldValue and newValue, which are the previous and current values of the text field respectively.
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    /// Checking if the newValue text is empty. If it is empty, it returns the newValue as it is.
    if (newValue.text.isEmpty) {
      return newValue;
    }

    /// Checks if [newValue] text matches the regular expression
    /// If it matches the regular expression, it returns the newValue.
    if (RegExp(regx).hasMatch(newValue.text)) {
      return newValue;
    }

    /// if above regx doesn't match, it returns the oldValue, which means that the last entered character is not allowed and it will be ignored.

    return oldValue;
  }
}
