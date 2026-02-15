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
  String get loginHeadline => 'Evolve today.';

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

  @override
  String get dailyTrackingAppBarTitle => 'Daily Tracking';

  @override
  String get dailyTrackingError => 'Error';

  @override
  String get dailyTrackingSaved => 'Saved';

  @override
  String get dailyDateLabel => 'Date:';

  @override
  String get dailyDateToday => 'Today';

  @override
  String get dailyWeightLabel => 'Weight:';

  @override
  String get dailyWeightHint => '(kg)';

  @override
  String get dailySleepLabel => 'Sleep:';

  @override
  String get dailySleepDurationHint => '08 : 30';

  @override
  String get dailySleepQualityLabel => 'Sleep Quantity';

  @override
  String get dailySickLabel => 'Sick:';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get dailyWaterLabel => 'Water:';

  @override
  String get dailyWaterHint => '1.2 (Lit)';

  @override
  String get dailyWaterAdvice => 'At least 2.5 liters recommended.';

  @override
  String get dailyEnergySectionTitle => 'Energy & Well-Being';

  @override
  String get dailyEnergyLevelLabel => 'Energy Level (1-10)';

  @override
  String get dailyStressLevelLabel => 'Stress Level (1-10)';

  @override
  String get dailyMuscleSorenessLabel => 'Muscle Soreness (1-10)';

  @override
  String get dailyMoodLabel => 'Mood (1-10)';

  @override
  String get dailyMotivationLabel => 'Motivation (1-10)';

  @override
  String get dailyBodyTempLabel => 'Body Temperature';

  @override
  String get dailyGenericTypeHint => 'Type...';

  @override
  String get trainingHistoryAppBarTitle => 'Training History';

  @override
  String get trainingHistoryEmpty => 'Please complete a training first. After that, the history will be added.';

  @override
  String get coachAddedShortly => 'Please wait, the coach will be added shortly.';

  @override
  String get trainingSplitAppBarTitle => 'Training Split';

  @override
  String get dailyTrainingSectionTitle => 'Training';

  @override
  String get dailyTrainingCompletedTitle => 'Training Completed?';

  @override
  String get dailyTrainingPlanTitle => 'Training Plan?';

  @override
  String get dailyTrainingPlanPlaceholder => 'Placeholder';

  @override
  String get dailyTrainingPlanPushFullbody => 'Push Fullbody';

  @override
  String get dailyTrainingPlanLegDayAdvanced => 'Leg Day Advanced';

  @override
  String get dailyTrainingPlanPlan1 => 'Training plan 1';

  @override
  String get dailyCardioCompletedTitle => 'Cardio Completed?';

  @override
  String get dailyCardioTypeTitle => 'Cardio Type ?';

  @override
  String get dailyCardioWalking => 'Walking';

  @override
  String get dailyCardioCycling => 'Cycling';

  @override
  String get dailyDurationHint => 'Duration  (Minutes)';

  @override
  String get dailyActivityStepsLabel => 'Activity Steps:';

  @override
  String get dailyActivityStepsHint => '10000';

  @override
  String get dailyNutritionSectionTitle => 'Nutrition';

  @override
  String get dailyNutritionCaloriesLabel => 'Calories';

  @override
  String get dailyNutritionCarbsLabel => 'Carbs';

  @override
  String get dailyNutritionProteinLabel => 'Protein';

  @override
  String get dailyNutritionFatsLabel => 'Fats';

  @override
  String get dailyNutritionHungerLabel => 'Hunger  (1-10)';

  @override
  String get dailyNutritionDigestionLabel => 'Digestion  (1-10)';

  @override
  String get dailyNutritionSaltLabel => 'Salt (g)';

  @override
  String get dailyWomenSectionTitle => 'Women';

  @override
  String get dailyWomenCyclePhaseTitle => 'Cycle Phase?';

  @override
  String dailyWomenCycleDayTitle(Object dayLabel) {
    return 'Cycle Day  ( $dayLabel )';
  }

  @override
  String get dailyWomenPmsLabel => 'PMS Symptoms (1-10)';

  @override
  String get dailyWomenCrampsLabel => 'Cramps  (1-10)';

  @override
  String get dailyWomenSymptomsTitle => 'Symptoms';

  @override
  String get dailyPedSectionTitle => 'PED';

  @override
  String get dailyPedDosageTitle => 'Daily Dosage Taken';

  @override
  String get dailyPedSideEffectsTitle => 'Side Effects Notes';

  @override
  String get dailyBpSectionTitle => 'Blood Pressure';

  @override
  String get dailyBpSystolicLabel => 'Systolic';

  @override
  String get dailyBpDiastolicLabel => 'Diastolic';

  @override
  String get dailyBpRestingHrLabel => 'Resting Heart Rate';

  @override
  String get dailyBpGlucoseLabel => 'Blood Glucose';

  @override
  String get dailyNotesSectionTitle => 'Daily Notes';

  @override
  String get dailySubmitButton => 'Submit';

  @override
  String get nutritionMenuPlanTitle => 'Nutrition Plan';

  @override
  String get trainingPlanAppBarTitle => 'Training Plan';

  @override
  String get trainingSplitHeaderDay => 'Day';

  @override
  String get trainingSplitHeaderWork => 'Work';

  @override
  String get nutritionMenuFoodItemsTitle => 'Food Items';

  @override
  String get trainingExerciseGenericError => 'Error loading items';

  @override
  String get nutritionFoodItemsCategoryAll => 'All';

  @override
  String get nutritionFoodItemsCategoryProtein => 'Protein';

  @override
  String get nutritionFoodItemsCategoryCarbs => 'Carbs';

  @override
  String get nutritionFoodItemsCategoryFats => 'Fats';

  @override
  String get nutritionFoodItemsCategoryFruits => 'Fruits';

  @override
  String get nutritionFoodItemsCategorySupplements => 'Supplements';

  @override
  String get nutritionFoodItemsCategoryVegetables => 'Vegetables';

  @override
  String nutritionFoodItemsEnergyLabel(String quantity) {
    return 'Energy ($quantity)';
  }

  @override
  String get nutritionFoodItemsSatFatsLabel => 'Sat. Fats';

  @override
  String get nutritionFoodItemsUnsatFatsLabel => 'Unsat. Fats';

  @override
  String get nutritionFoodItemsSugarLabel => 'Sugar';

  @override
  String get trainingExerciseAppBarTitle => 'Exercises';

  @override
  String get trainingExerciseSearchHint => 'Search exercises...';

  @override
  String get trainingAppBarTitle => 'Training';

  @override
  String get trainingMenuExercisesTitle => 'Exercises';

  @override
  String get trainingMenuExercisesSubtitle => 'View all exercises';

  @override
  String get trainingMenuPlanTitle => 'Training Plan';

  @override
  String get trainingMenuPlanSubtitle => 'View your plan';

  @override
  String get trainingMenuHistoryTitle => 'History';

  @override
  String get trainingMenuHistorySubtitle => 'View history';

  @override
  String get trainingMenuSplitTitle => 'Split';

  @override
  String get trainingMenuSplitSubtitle => 'View split';

  @override
  String get profileAppBarTitle => 'Profile';

  @override
  String get profileSectionStats => 'Stats';

  @override
  String get profileLabelWeight => 'Weight';

  @override
  String get profileLabelHeight => 'Height';

  @override
  String get profileLabelFat => 'Body Fat';

  @override
  String get profileLabelMuscle => 'Muscle Mass';

  @override
  String get profileLabelTrainingDaySteps => 'Training Steps';

  @override
  String get profileLabelRestDaySteps => 'Rest Steps';

  @override
  String get profileLabelStepsSuffix => 'steps';

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get profileLabelRole => 'Role';

  @override
  String get profileLabelCoach => 'Coach';

  @override
  String get profileLabelMemberSince => 'Member Since';

  @override
  String get profileSectionShowInfo => 'Show Info';

  @override
  String get profileLabelShowName => 'Show Name';

  @override
  String get profileLabelShowDate => 'Show Date';

  @override
  String get profileLabelLocation => 'Location';

  @override
  String get profileLabelDivision => 'Division';

  @override
  String get profileLabelCountdown => 'Countdown';

  @override
  String get profileLabelDaysSuffix => 'days';

  @override
  String get profileTimelineHeaderWeek => 'Week';

  @override
  String get profileTimelineHeaderDate => 'Date';

  @override
  String get profileTimelineHeaderPhase => 'Phase';

  @override
  String get profileEmpty => 'No Data';

  @override
  String get nutritionTrackPageTitle => 'Track Meal';

  @override
  String get nutritionTrackMealNameLabel => 'Meal Name';

  @override
  String get nutritionTrackMealNameHint => 'e.g., Breakfast';

  @override
  String get nutritionTrackFoodNameLabel => 'Food Name';

  @override
  String get nutritionTrackFoodNameHint => 'e.g., Chicken Breast';

  @override
  String get nutritionTrackFoodQuantityLabel => 'Quantity';

  @override
  String get nutritionTrackFoodQuantityHint => 'e.g., 100g';

  @override
  String get nutritionTrackTableFoodHeader => 'Food';

  @override
  String get nutritionTrackTableQtyHeader => 'Qty';

  @override
  String get nutritionTrackTableCaloriesHeader => 'Kcal';

  @override
  String get nutritionTrackTableActionLabel => 'Action';

  @override
  String get nutritionTrackNoItemsLogged => 'No items logged';

  @override
  String get nutritionTrackAddItem => 'Add Item';

  @override
  String get nutritionTrackCancel => 'Cancel';

  @override
  String get nutritionTrackAddMeal => 'Save Meal';

  @override
  String get nutritionTrackValidationMealRequired => 'Meal name is required';

  @override
  String get nutritionTrackTrainingDayLabel => 'Training Day';

  @override
  String get profileLogoutTitle => 'Logout';

  @override
  String get profileLogoutMessage => 'Are you sure you want to logout?';

  @override
  String get profileLogoutCancel => 'Cancel';

  @override
  String get profileLogoutConfirm => 'Logout';

  @override
  String get profileSectionPersonalData => 'Personal Data';

  @override
  String get profileLabelFullName => 'Full Name';

  @override
  String get profileLabelEmail => 'Email';

  @override
  String get profileLabelGender => 'Gender';

  @override
  String get profileSectionAthleteInfo => 'Athlete Info';

  @override
  String get profileLabelStatus => 'Status';

  @override
  String get profileLabelCategory => 'Category';

  @override
  String get profileLabelCheckInDay => 'Check-in Day';

  @override
  String get profileLabelAge => 'Age';

  @override
  String get profileLabelAgeYearsSuffix => 'years';

  @override
  String get profileLabelGoal => 'Goal';

  @override
  String get nutritionMenuSupplementTitle => 'Supplements';

  @override
  String get nutritionMenuPedTitle => 'PEDs';

  @override
  String get nutritionMenuPedSubtitle => 'Performance Enhancers';

  @override
  String get nutritionTodayMacrosTitle => 'Today\'s Macros';

  @override
  String get nutritionMacroProteinLabel => 'Protein';

  @override
  String get nutritionMacroCarbsLabel => 'Carbs';

  @override
  String get nutritionMacroFatsLabel => 'Fats';

  @override
  String get nutritionMenuStatisticsTitle => 'Statistics';

  @override
  String get nutritionSupplementsHeaderTitle => 'Your Supplements';

  @override
  String get nutritionSupplementsTableName => 'Name';

  @override
  String get nutritionSupplementsTableDosage => 'Dosage';

  @override
  String get nutritionSupplementsTableFrequency => 'Frequency';

  @override
  String get nutritionSupplementsTableTime => 'Time';

  @override
  String get nutritionSupplementsTablePurpose => 'Purpose';

  @override
  String get nutritionSupplementsTableBrand => 'Brand';

  @override
  String get nutritionSupplementsTableComment => 'Comment';

  @override
  String get nutritionSupplementsEmpty => 'No supplements added';

  @override
  String get nutritionMenuTrackMealsTitle => 'Track Meals';

  @override
  String get nutritionTrackDailyGoalTitle => 'Daily Goal';

  @override
  String get nutritionTrackDailyGoalSubtitle => 'Calories and Macros';

  @override
  String get nutritionAppBarTitle => 'Nutrition';

  @override
  String get nutritionMenuFoodItemsSubtitle => 'Search database';

  @override
  String get nutritionMenuPlanSubtitle => 'View meal plan';

  @override
  String get nutritionMenuTrackMealsSubtitle => 'Log your daily meals';

  @override
  String get nutritionMenuStatisticsSubtitle => 'View progress';

  @override
  String get checkInAppBarTitle => 'Check-In';

  @override
  String get checkInStepProfile => 'Profile';

  @override
  String get checkInStepPhotos => 'Photos';

  @override
  String get checkInStepQuestions => 'Questions';

  @override
  String get checkInStepChecking => 'Checking';

  @override
  String get checkInTabWeekly => 'Weekly Check-in';

  @override
  String get checkInTabOld => 'Old Check-ins';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get checkInNoPreviousFound => 'No previous check-ins found.';

  @override
  String get checkInLabel => 'Check-In';

  @override
  String get checkInDateLabel => 'Date';

  @override
  String get checkInDayLabel => 'Day';

  @override
  String get checkInProfileCurrentWeightTitle => 'Current Weight';

  @override
  String get checkInProfileAverageWeightTitle => 'Average Weight';

  @override
  String get checkInPhotosMultiFileInfo => 'Select multiple photos';

  @override
  String get checkInPhotosSelectFileLabel => 'Select Photos';

  @override
  String get checkInPhotosSingleVideoInfo => 'Select a single video';

  @override
  String get checkInPhotosVideoDropLabel => 'Upload Video';

  @override
  String get checkInPhotosUploadSuccess => 'Uploaded Successfully';

  @override
  String get commonUpload => 'Upload';

  @override
  String get commonBack => 'Back';

  @override
  String get checkInSinceLastBadge => 'Since Last Check-in';

  @override
  String get checkInCheckingBasicDataTitle => 'Basic Data';

  @override
  String get checkInCheckingPicturesUploadedLabel => 'Photos Uploaded';

  @override
  String get checkInCheckingVideoUploadedLabel => 'Video Uploaded';

  @override
  String get checkInCheckingVideoPlaceholderTitle => 'Video';

  @override
  String get checkInCheckingVideoUploadedSubtitle => 'Video uploaded';

  @override
  String get checkInCheckingVideoDefaultSubtitle => 'No video uploaded';

  @override
  String get checkInCheckingQuestionCountDescription => 'Questions Answered';

  @override
  String get checkInQuestion1Title => 'How was your week?';

  @override
  String get commonNoAnswer => 'No Answer';

  @override
  String get checkInQuestion2Title => 'Any issues?';

  @override
  String get checkInWellBeingSectionTitle => 'Well-Being';

  @override
  String get checkInWellBeingEnergyLabel => 'Energy';

  @override
  String get checkInWellBeingStressLabel => 'Stress';

  @override
  String get checkInWellBeingMoodLabel => 'Mood';

  @override
  String get checkInWellBeingSleepLabel => 'Sleep';

  @override
  String get checkInNutritionSectionTitle => 'Nutrition';

  @override
  String get checkInNutritionDietLevelLabel => 'Diet Adherence';

  @override
  String get checkInNutritionDigestionLabel => 'Digestion';

  @override
  String get checkInNutritionChallengeTitle => 'Challenges';

  @override
  String get commonTypeHint => 'Type here...';

  @override
  String get checkInTrainingSectionTitle => 'Training';

  @override
  String get checkInTrainingFeelStrengthLabel => 'Strength';

  @override
  String get checkInTrainingPumpsLabel => 'Pump';

  @override
  String get checkInTrainingCompletedLabel => 'Training Completed';

  @override
  String get checkInTrainingCardioCompletedLabel => 'Cardio Completed';

  @override
  String get checkInTrainingFeedbackTitle => 'Feedback';

  @override
  String get checkInAthleteNoteTitle => 'Athlete Note';

  @override
  String get commonAnswer => 'Answer';

  @override
  String get checkInCheckingCurrentWeightTitle => 'Current Weight';

  @override
  String get checkInCheckingAverageWeightTitle => 'Avg Weight';
}
