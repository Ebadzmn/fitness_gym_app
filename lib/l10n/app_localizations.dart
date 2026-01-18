import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fitness App'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get navTraining;

  /// No description provided for @navDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get navDaily;

  /// No description provided for @navNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get navNutrition;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @loginAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginAppBarTitle;

  /// No description provided for @loginHeadline.
  ///
  /// In en, this message translates to:
  /// **'Wolves Win.'**
  String get loginHeadline;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @forgetPasswordAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgetPasswordAppBarTitle;

  /// No description provided for @forgetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgetPasswordTitle;

  /// No description provided for @forgetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the email or phone your account and we’ll send a code to reset your password'**
  String get forgetPasswordDescription;

  /// No description provided for @forgetPasswordEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get forgetPasswordEmailLabel;

  /// No description provided for @forgetPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get forgetPasswordEmailHint;

  /// No description provided for @forgetPasswordSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get forgetPasswordSending;

  /// No description provided for @forgetPasswordSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get forgetPasswordSendCode;

  /// No description provided for @forgetPasswordEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get forgetPasswordEmailRequired;

  /// No description provided for @dailyTrackingAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Tracking'**
  String get dailyTrackingAppBarTitle;

  /// No description provided for @dailyTrackingError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get dailyTrackingError;

  /// No description provided for @dailyTrackingSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get dailyTrackingSaved;

  /// No description provided for @dailyDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get dailyDateLabel;

  /// No description provided for @dailyDateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dailyDateToday;

  /// No description provided for @dailyWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight:'**
  String get dailyWeightLabel;

  /// No description provided for @dailyWeightHint.
  ///
  /// In en, this message translates to:
  /// **'65.2 (kg)'**
  String get dailyWeightHint;

  /// No description provided for @dailySleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep:'**
  String get dailySleepLabel;

  /// No description provided for @dailySleepDurationHint.
  ///
  /// In en, this message translates to:
  /// **'08 : 45 (Minutes)'**
  String get dailySleepDurationHint;

  /// No description provided for @dailySleepQualityLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep Quality (1 - 10 )'**
  String get dailySleepQualityLabel;

  /// No description provided for @dailySickLabel.
  ///
  /// In en, this message translates to:
  /// **'Sick:'**
  String get dailySickLabel;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @dailyWaterLabel.
  ///
  /// In en, this message translates to:
  /// **'Water:'**
  String get dailyWaterLabel;

  /// No description provided for @dailyWaterHint.
  ///
  /// In en, this message translates to:
  /// **'1.2 (Lit)'**
  String get dailyWaterHint;

  /// No description provided for @dailyWaterAdvice.
  ///
  /// In en, this message translates to:
  /// **'At least 2.5 liters recommended.'**
  String get dailyWaterAdvice;

  /// No description provided for @dailyEnergySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Energy & Well-Being'**
  String get dailyEnergySectionTitle;

  /// No description provided for @dailyEnergyLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy Level (1-10)'**
  String get dailyEnergyLevelLabel;

  /// No description provided for @dailyStressLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Stress Level (1-10)'**
  String get dailyStressLevelLabel;

  /// No description provided for @dailyMuscleSorenessLabel.
  ///
  /// In en, this message translates to:
  /// **'Muscle Soreness (1-10)'**
  String get dailyMuscleSorenessLabel;

  /// No description provided for @dailyMoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Mood (1-10)'**
  String get dailyMoodLabel;

  /// No description provided for @dailyMotivationLabel.
  ///
  /// In en, this message translates to:
  /// **'Motivation (1-10)'**
  String get dailyMotivationLabel;

  /// No description provided for @dailyBodyTempLabel.
  ///
  /// In en, this message translates to:
  /// **'Body Temperature'**
  String get dailyBodyTempLabel;

  /// No description provided for @dailyGenericTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Type...'**
  String get dailyGenericTypeHint;

  /// No description provided for @dailyTrainingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get dailyTrainingSectionTitle;

  /// No description provided for @dailyTrainingCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Completed?'**
  String get dailyTrainingCompletedTitle;

  /// No description provided for @dailyTrainingPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Plan?'**
  String get dailyTrainingPlanTitle;

  /// No description provided for @dailyTrainingPlanPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Placeholder'**
  String get dailyTrainingPlanPlaceholder;

  /// No description provided for @dailyTrainingPlanPushFullbody.
  ///
  /// In en, this message translates to:
  /// **'Push Fullbody'**
  String get dailyTrainingPlanPushFullbody;

  /// No description provided for @dailyTrainingPlanLegDayAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Leg Day Advanced'**
  String get dailyTrainingPlanLegDayAdvanced;

  /// No description provided for @dailyTrainingPlanPlan1.
  ///
  /// In en, this message translates to:
  /// **'Training plan 1'**
  String get dailyTrainingPlanPlan1;

  /// No description provided for @dailyCardioCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Cardio Completed?'**
  String get dailyCardioCompletedTitle;

  /// No description provided for @dailyCardioTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Cardio Type ?'**
  String get dailyCardioTypeTitle;

  /// No description provided for @dailyCardioWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get dailyCardioWalking;

  /// No description provided for @dailyCardioCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get dailyCardioCycling;

  /// No description provided for @dailyDurationHint.
  ///
  /// In en, this message translates to:
  /// **'Duration  (Minutes)'**
  String get dailyDurationHint;

  /// No description provided for @dailyActivityStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity Steps:'**
  String get dailyActivityStepsLabel;

  /// No description provided for @dailyActivityStepsHint.
  ///
  /// In en, this message translates to:
  /// **'10000'**
  String get dailyActivityStepsHint;

  /// No description provided for @dailyNutritionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get dailyNutritionSectionTitle;

  /// No description provided for @dailyNutritionCaloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get dailyNutritionCaloriesLabel;

  /// No description provided for @dailyNutritionCarbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get dailyNutritionCarbsLabel;

  /// No description provided for @dailyNutritionProteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get dailyNutritionProteinLabel;

  /// No description provided for @dailyNutritionFatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get dailyNutritionFatsLabel;

  /// No description provided for @dailyNutritionHungerLabel.
  ///
  /// In en, this message translates to:
  /// **'Hunger  (1-10)'**
  String get dailyNutritionHungerLabel;

  /// No description provided for @dailyNutritionDigestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Digestion  (1-10)'**
  String get dailyNutritionDigestionLabel;

  /// No description provided for @dailyNutritionSaltLabel.
  ///
  /// In en, this message translates to:
  /// **'Salt (g)'**
  String get dailyNutritionSaltLabel;

  /// No description provided for @dailyWomenSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get dailyWomenSectionTitle;

  /// No description provided for @dailyWomenCyclePhaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle Phase?'**
  String get dailyWomenCyclePhaseTitle;

  /// No description provided for @dailyWomenCycleDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle Day  ( {dayLabel} )'**
  String dailyWomenCycleDayTitle(Object dayLabel);

  /// No description provided for @dailyWomenPmsLabel.
  ///
  /// In en, this message translates to:
  /// **'PMS Symptoms (1-10)'**
  String get dailyWomenPmsLabel;

  /// No description provided for @dailyWomenCrampsLabel.
  ///
  /// In en, this message translates to:
  /// **'Cramps  (1-10)'**
  String get dailyWomenCrampsLabel;

  /// No description provided for @dailyWomenSymptomsTitle.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get dailyWomenSymptomsTitle;

  /// No description provided for @dailyPedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'PED'**
  String get dailyPedSectionTitle;

  /// No description provided for @dailyPedDosageTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Dosage Taken'**
  String get dailyPedDosageTitle;

  /// No description provided for @dailyPedSideEffectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Side Effects Notes'**
  String get dailyPedSideEffectsTitle;

  /// No description provided for @dailyBpSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get dailyBpSectionTitle;

  /// No description provided for @dailyBpSystolicLabel.
  ///
  /// In en, this message translates to:
  /// **'Systolic'**
  String get dailyBpSystolicLabel;

  /// No description provided for @dailyBpDiastolicLabel.
  ///
  /// In en, this message translates to:
  /// **'Diastolic'**
  String get dailyBpDiastolicLabel;

  /// No description provided for @dailyBpRestingHrLabel.
  ///
  /// In en, this message translates to:
  /// **'Resting Heart Rate'**
  String get dailyBpRestingHrLabel;

  /// No description provided for @dailyBpGlucoseLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Glucose'**
  String get dailyBpGlucoseLabel;

  /// No description provided for @dailyNotesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Notes'**
  String get dailyNotesSectionTitle;

  /// No description provided for @dailySubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get dailySubmitButton;

  /// No description provided for @checkInAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-In'**
  String get checkInAppBarTitle;

  /// No description provided for @checkInStepProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get checkInStepProfile;

  /// No description provided for @checkInStepPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get checkInStepPhotos;

  /// No description provided for @checkInStepQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get checkInStepQuestions;

  /// No description provided for @checkInStepChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get checkInStepChecking;

  /// No description provided for @checkInTabWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly Check-In'**
  String get checkInTabWeekly;

  /// No description provided for @checkInTabOld.
  ///
  /// In en, this message translates to:
  /// **'Old Check-In'**
  String get checkInTabOld;

  /// No description provided for @checkInDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in Date:'**
  String get checkInDateLabel;

  /// No description provided for @checkInDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day:'**
  String get checkInDayLabel;

  /// No description provided for @checkInLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get checkInLoading;

  /// No description provided for @checkInNoPreviousFound.
  ///
  /// In en, this message translates to:
  /// **'No previous check-ins found'**
  String get checkInNoPreviousFound;

  /// No description provided for @checkInLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in:'**
  String get checkInLabel;

  /// No description provided for @checkInSinceLastBadge.
  ///
  /// In en, this message translates to:
  /// **'Check-in since last'**
  String get checkInSinceLastBadge;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get commonAnswer;

  /// No description provided for @commonTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Type...'**
  String get commonTypeHint;

  /// No description provided for @commonUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get commonUpload;

  /// No description provided for @commonNoAnswer.
  ///
  /// In en, this message translates to:
  /// **'No answer'**
  String get commonNoAnswer;

  /// No description provided for @checkInProfileCurrentWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Weight (kg)'**
  String get checkInProfileCurrentWeightTitle;

  /// No description provided for @checkInProfileAverageWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Average Weight in %'**
  String get checkInProfileAverageWeightTitle;

  /// No description provided for @checkInPhotosMultiFileInfo.
  ///
  /// In en, this message translates to:
  /// **'You can select multiple files, but at least one file must be chosen'**
  String get checkInPhotosMultiFileInfo;

  /// No description provided for @checkInPhotosSelectFileLabel.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get checkInPhotosSelectFileLabel;

  /// No description provided for @checkInPhotosSingleVideoInfo.
  ///
  /// In en, this message translates to:
  /// **'Only one video can be uploaded, and the maximum file size is 500 MB.'**
  String get checkInPhotosSingleVideoInfo;

  /// No description provided for @checkInPhotosVideoDropLabel.
  ///
  /// In en, this message translates to:
  /// **'Drag & drop video file'**
  String get checkInPhotosVideoDropLabel;

  /// No description provided for @checkInPhotosUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Files uploaded successfully'**
  String get checkInPhotosUploadSuccess;

  /// No description provided for @checkInQuestion1Title.
  ///
  /// In en, this message translates to:
  /// **'Q1 . What are you proud of? *'**
  String get checkInQuestion1Title;

  /// No description provided for @checkInQuestion2Title.
  ///
  /// In en, this message translates to:
  /// **'Q2 . Calories per default quantity *'**
  String get checkInQuestion2Title;

  /// No description provided for @checkInWellBeingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Well-Being'**
  String get checkInWellBeingSectionTitle;

  /// No description provided for @checkInWellBeingEnergyLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy Level (1-10)'**
  String get checkInWellBeingEnergyLabel;

  /// No description provided for @checkInWellBeingStressLabel.
  ///
  /// In en, this message translates to:
  /// **'Stress level (1-10)'**
  String get checkInWellBeingStressLabel;

  /// No description provided for @checkInWellBeingMoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Mood level (1-10)'**
  String get checkInWellBeingMoodLabel;

  /// No description provided for @checkInWellBeingSleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep quality (1-10)'**
  String get checkInWellBeingSleepLabel;

  /// No description provided for @checkInNutritionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get checkInNutritionSectionTitle;

  /// No description provided for @checkInNutritionDietLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Diet Level  (1-10)'**
  String get checkInNutritionDietLevelLabel;

  /// No description provided for @checkInNutritionDigestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Digestion  (1-10)'**
  String get checkInNutritionDigestionLabel;

  /// No description provided for @checkInNutritionChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge Diet'**
  String get checkInNutritionChallengeTitle;

  /// No description provided for @checkInTrainingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get checkInTrainingSectionTitle;

  /// No description provided for @checkInTrainingFeelStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Feel Strength (1-10)'**
  String get checkInTrainingFeelStrengthLabel;

  /// No description provided for @checkInTrainingPumpsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pumps  (1-10)'**
  String get checkInTrainingPumpsLabel;

  /// No description provided for @checkInTrainingCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Training Completed?'**
  String get checkInTrainingCompletedLabel;

  /// No description provided for @checkInTrainingCardioCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Cardio Completed?'**
  String get checkInTrainingCardioCompletedLabel;

  /// No description provided for @checkInTrainingFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback Training'**
  String get checkInTrainingFeedbackTitle;

  /// No description provided for @checkInAthleteNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Athlete Note'**
  String get checkInAthleteNoteTitle;

  /// No description provided for @checkInCheckingCurrentWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get checkInCheckingCurrentWeightTitle;

  /// No description provided for @checkInCheckingAverageWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Average Weight'**
  String get checkInCheckingAverageWeightTitle;

  /// No description provided for @checkInCheckingBasicDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Data'**
  String get checkInCheckingBasicDataTitle;

  /// No description provided for @checkInCheckingPicturesUploadedLabel.
  ///
  /// In en, this message translates to:
  /// **'Pictures uploaded?'**
  String get checkInCheckingPicturesUploadedLabel;

  /// No description provided for @checkInCheckingVideoUploadedLabel.
  ///
  /// In en, this message translates to:
  /// **'Video uploaded?'**
  String get checkInCheckingVideoUploadedLabel;

  /// No description provided for @checkInCheckingVideoPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Muscular Workout'**
  String get checkInCheckingVideoPlaceholderTitle;

  /// No description provided for @checkInCheckingVideoUploadedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Video'**
  String get checkInCheckingVideoUploadedSubtitle;

  /// No description provided for @checkInCheckingVideoDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upper Body Low'**
  String get checkInCheckingVideoDefaultSubtitle;

  /// No description provided for @checkInCheckingQuestionCountDescription.
  ///
  /// In en, this message translates to:
  /// **'Select how many questions you have answered (You must answer at least 7 questions)'**
  String get checkInCheckingQuestionCountDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
