// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Fitness App';

  @override
  String get navHome => 'Startseite';

  @override
  String get navTraining => 'Training';

  @override
  String get navDaily => 'Täglich';

  @override
  String get navNutrition => 'Ernährung';

  @override
  String get navProfile => 'Profil';

  @override
  String get loginAppBarTitle => 'Anmelden';

  @override
  String get loginHeadline => 'Wolves Win.';

  @override
  String get loginEmailLabel => 'E-Mail';

  @override
  String get loginEmailHint => 'Gib deine E-Mail ein';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginPasswordHint => 'Gib dein Passwort ein';

  @override
  String get loginForgotPassword => 'Passwort vergessen?';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get forgetPasswordAppBarTitle => 'Passwort vergessen';

  @override
  String get forgetPasswordTitle => 'Passwort vergessen';

  @override
  String get forgetPasswordDescription => 'Gib die E-Mail oder Telefonnummer deines Kontos ein, und wir senden dir einen Code, um dein Passwort zurückzusetzen';

  @override
  String get forgetPasswordEmailLabel => 'E-Mail';

  @override
  String get forgetPasswordEmailHint => 'Gib deine E-Mail-Adresse ein';

  @override
  String get forgetPasswordSending => 'Senden...';

  @override
  String get forgetPasswordSendCode => 'Code senden';

  @override
  String get forgetPasswordEmailRequired => 'Bitte gib deine E-Mail ein';
}
