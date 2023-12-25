import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marathon/screen/home_screen.dart';
import 'package:marathon/utils/app_styles.dart';
import 'package:marathon/utils/app_validator.dart';
import 'package:marathon/utils/app_values.dart';
import 'package:marathon/utils/common_functions.dart';
import 'package:marathon/utils/enums.dart';
import 'package:marathon/viewModel/userProvider.dart';
import 'package:marathon/widget/custom_textfield.dart';
import 'package:marathon/widget/primary_filled_button.dart';
import 'package:marathon/widget/space_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String TITLE_USER_LOGIN = "User Login";
  final String TITLE_FIELD_USERID = "User Id";
  final String HINT_FIELD_USERID = "Enter User Id";
  final String TITLE_FIELD_PASSWORD = "Password";
  final String HINT_FIELD_PASSWORD = "Enter your Password";
  final String TITLE_BUTTON_OTP = "Sign Up";
  final String TITLE_BUTTON_LOGIN = "Login";

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      bool isSuccessful = await _userProvider.loginUser(userName: _userIdController.text, password: _passwordController.text);
      if (isSuccessful) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double appLogoSize = screenSize.width * 0.6;
    appLogoSize = appLogoSize > 200 ? 200 : appLogoSize;
    bool isMobileView = screenSize.width < 600;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Selector<UserProvider, ApiStatus>(
              selector: (p0, p1) => p1.signInStatus,
              builder: (context, status, _) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppValues.kAppPadding),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
                                child: IntrinsicHeight(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const SpaceWidget(height: 15),
                                        /* Hero(
                                          tag: "splash_icon",
                                          child: AppLogo(
                                            dimension: appLogoSize,
                                          ),
                                        ), */
                                        const SpaceWidget(height: 20),
                                        Text(
                                          TITLE_USER_LOGIN,
                                          style: AppStyles.titleMedium,
                                        ),
                                        const SpaceWidget(height: 20),
                                        // Email TextField with Controller
                                        CustomTextField(
                                          controller: _userIdController,
                                          heading: TITLE_FIELD_USERID,
                                          hintText: HINT_FIELD_USERID,
                                          keyboardType: TextInputType.text,
                                          
                                          validator: AppValidators.requiredFiled,
                                        ),
                                        const SpaceWidget(height: 15),
                                        // Password TextField with Controller
                                        CustomTextField(
                                          heading: TITLE_FIELD_PASSWORD,
                                          hintText: HINT_FIELD_PASSWORD,
                                          controller: _passwordController,
                                          keyboardType: TextInputType.text,
                                          obscureText: true,
                                          validator: AppValidators.requiredFiled,
                                        ),
                                        const SpaceWidget(height: 15),
                                        // Login Button
                                        SizedBox(
                                          width: double.infinity,
                                          child: PrimaryFilledButton(
                                            buttonTitle: TITLE_BUTTON_LOGIN,
                                            onPressed: _handleSignIn,
                                          ),
                                        ),

                                        const SpaceWidget(height: 15),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (status == ApiStatus.LOADING)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.black12),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
