// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fitness App';

  @override
  String get navHome => 'Home';

  @override
  String get navTraining => 'Training';

  @override
  String get navDaily => 'Daily';

  @override
  String get navNutrition => 'Nutrition';

  @override
  String get navProfile => 'Profile';

  @override
  String get loginAppBarTitle => 'Login';

  @override
  String get loginHeadline => 'Wolves Win.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'Enter your email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginButton => 'Login';

  @override
  String get forgetPasswordAppBarTitle => 'Forgot Password';

  @override
  String get forgetPasswordTitle => 'Forgot Password';

  @override
  String get forgetPasswordDescription => 'Enter the email or phone your account and we’ll send a code to reset your password';

  @override
  String get forgetPasswordEmailLabel => 'Email';

  @override
  String get forgetPasswordEmailHint => 'Enter your email address';

  @override
  String get forgetPasswordSending => 'Sending...';

  @override
  String get forgetPasswordSendCode => 'Send Code';

  @override
  String get forgetPasswordEmailRequired => 'Please enter your email';
}
