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
  String get profileAppBarTitle => 'Profile';

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
  String get profileSectionAthleteInfo => 'Athlete Info';

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get profileSectionShowInfo => 'Show Information';

  @override
  String get profileLabelFullName => 'Full Name';

  @override
  String get profileLabelEmail => 'Email';

  @override
  String get profileLabelGender => 'Gender';

  @override
  String get profileLabelStatus => 'Status';

  @override
  String get profileLabelCategory => 'Category';

  @override
  String get profileLabelCheckInDay => 'Check-in day';

  @override
  String get profileLabelHeight => 'Height (cm)';

  @override
  String get profileLabelAge => 'Age';

  @override
  String get profileLabelAgeYearsSuffix => 'Years';

  @override
  String get profileLabelGoal => 'Goal';

  @override
  String get profileLabelTrainingDaySteps => 'Training Day Steps';

  @override
  String get profileLabelRestDaySteps => 'Rest day Steps';

  @override
  String get profileLabelStepsSuffix => 'Step';

  @override
  String get profileLabelRole => 'Role';

  @override
  String get profileLabelCoach => 'Coach';

  @override
  String get profileLabelMemberSince => 'Member since';

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
  String get profileLabelDaysSuffix => 'Days';

  @override
  String get profileTimelineHeaderWeek => 'Week';

  @override
  String get profileTimelineHeaderDate => 'Date';

  @override
  String get profileTimelineHeaderPhase => 'Phase';

  @override
  String get profileEmpty => 'No profile data found';

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
  String get trainingAppBarTitle => 'Training';

  @override
  String get trainingStatsPrsThisWeek => "PR's this week";

  @override
  String get trainingStatsWeeklyVolume => 'Weekly Volume';

  @override
  String get trainingStatsTrainings => 'Trainings';

  @override
  String get trainingMenuExercisesTitle => 'EXERCISES';

  @override
  String get trainingMenuExercisesSubtitle => 'Database';

  @override
  String get trainingMenuPlanTitle => 'TRAINING PLAN';

  @override
  String get trainingMenuPlanSubtitle => 'Weekly Overview';

  @override
  String get trainingMenuHistoryTitle => 'HISTORIE';

  @override
  String get trainingMenuHistorySubtitle => 'Past Workouts';

  @override
  String get trainingMenuSplitTitle => 'TRAINING SPLIT';

  @override
  String get trainingMenuSplitSubtitle => 'View Training Split';

  @override
  String get trainingSplitAppBarTitle => 'Training Split';

  @override
  String get trainingExerciseAppBarTitle => 'Exercises';

  @override
  String get trainingExerciseSearchHint => 'Search exercise';

  @override
  String get trainingExerciseFilterAll => 'All';

  @override
  String get trainingExerciseFilterChest => 'Chest';

  @override
  String get trainingExerciseFilterBack => 'Back';

  @override
  String get trainingExerciseFilterLegs => 'Legs';

  @override
  String get trainingExerciseGenericError => 'An error occurred';

  @override
  String get trainingPlanAppBarTitle => 'Training Plan';

  @override
  String get trainingHistoryAppBarTitle => 'Training History';

  @override
  String get trainingHistoryEmpty => 'No history available';

  @override
  String trainingHistoryHeaderWorkouts(Object count) {
    return '$count Workout';
  }

  @override
  String get trainingHistoryLabelSetsBest => 'Sets / Best Set → Best Set';

  @override
  String get trainingHistoryLabelBest => 'Best';

  @override
  String get trainingHistoryLabelPrs => 'PRs';

  @override
  String get trainingSplitHeaderDay => 'Day';

  @override
  String get trainingSplitHeaderWork => 'Work';

  @override
  String get dailyDateLabel => 'Date:';

  @override
  String get dailyDateToday => 'Today';

  @override
  String get dailyWeightLabel => 'Weight:';

  @override
  String get dailyWeightHint => '65.2 (kg)';

  @override
  String get dailySleepLabel => 'Sleep:';

  @override
  String get dailySleepDurationHint => '08 : 45 (Minutes)';

  @override
  String get dailySleepQualityLabel => 'Sleep Quality (1 - 10 )';

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
  String get nutritionAppBarTitle => 'Nutrition';

  @override
  String get nutritionMenuFoodItemsTitle => 'Food Items';

  @override
  String get nutritionMenuFoodItemsSubtitle => 'Database';

  @override
  String get nutritionMenuPlanTitle => 'Nutrition Plan';

  @override
  String get nutritionMenuPlanSubtitle => 'Weekly Overview';

  @override
  String get nutritionMenuTrackMealsTitle => 'Track Meals';

  @override
  String get nutritionMenuTrackMealsSubtitle => 'To record';

  @override
  String get nutritionMenuStatisticsTitle => 'Statistics';

  @override
  String get nutritionMenuStatisticsSubtitle => 'View history';

  @override
  String get nutritionMenuSupplementTitle => 'Supplements Plan';

  @override
  String get nutritionMenuPedTitle => "PED's";

  @override
  String get nutritionMenuPedSubtitle => 'Plan';

  @override
  String get nutritionTodayMacrosTitle => "Today's Macros";

  @override
  String get nutritionMacroProteinLabel => 'Protein';

  @override
  String get nutritionMacroCarbsLabel => 'Carbs';

  @override
  String get nutritionMacroFatsLabel => 'Fat';

  @override
  String get nutritionTrackDailyGoalTitle => 'Daily Goal';

  @override
  String get nutritionTrackDailyGoalSubtitle => 'Track Your Meals';

  @override
  String get nutritionTrackAddItem => 'Add item';

  @override
  String get nutritionTrackCancel => 'Cancel';

  @override
  String get nutritionTrackAddMeal => 'Add Meal';

  @override
  String get nutritionTrackMealNameLabel => 'Meal Name';

  @override
  String get nutritionTrackMealTimeLabel => 'Time Label';

  @override
  String get nutritionTrackFoodNameLabel => 'Food Name';

  @override
  String get nutritionTrackFoodQuantityLabel => 'Quantity';

  @override
  String get nutritionTrackFoodQuantityHint => 'e.g. 200g';

  @override
  String get nutritionTrackFoodNameHint => 'Type...';

  @override
  String get nutritionTrackValidationMealRequired =>
      'Meal name and at least one item required';

  @override
  String get nutritionTrackTrainingDayLabel => 'training day';

  @override
  String get nutritionTrackTableActionLabel => 'Action';

  @override
  String get nutritionTrackNoItemsLogged => 'No items logged.';

  @override
  String nutritionFoodItemsEnergyLabel(Object quantity) {
    return 'Energy ($quantity):';
  }

  @override
  String get nutritionFoodItemsProteinLabel => 'Protein';

  @override
  String get nutritionFoodItemsCarbsLabel => 'Carbs';

  @override
  String get nutritionFoodItemsFatsLabel => 'Fats';

  @override
  String get nutritionFoodItemsSatFatsLabel => 'Sat F';

  @override
  String get nutritionFoodItemsUnsatFatsLabel => 'Unsat F';

  @override
  String get nutritionFoodItemsSugarLabel => 'Sugar';

  @override
  String get nutritionFoodItemsCategoryProtein => 'Protein';

  @override
  String get nutritionFoodItemsCategoryCarbs => 'Carbs';

  @override
  String get nutritionFoodItemsCategoryFats => 'Fats';

  @override
  String get nutritionFoodItemsCategorySupplements => 'Supplements';

  @override
  String get nutritionFoodItemsCategoryFruits => 'Fruits';

  @override
  String get nutritionFoodItemsCategoryVegetables => 'Vegetables';

  @override
  String get nutritionFoodItemsCategoryAll => 'All';

  @override
  String get nutritionSupplementsHeaderTitle => 'Supplement';

  @override
  String get nutritionSupplementsTableName => 'Name';

  @override
  String get nutritionSupplementsTableDosage => 'Dosage';

  @override
  String get nutritionSupplementsTableTime => 'Time';

  @override
  String get nutritionSupplementsTablePurpose => 'Purpose';

  @override
  String get nutritionSupplementsTableBrand => 'Brand';

  @override
  String get nutritionSupplementsTableComment => 'Comment';

  @override
  String get nutritionSupplementsEmpty => 'No supplements found';

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
  String get checkInTabWeekly => 'Weekly Check-In';

  @override
  String get checkInTabOld => 'Old Check-In';

  @override
  String get checkInDateLabel => 'Check-in Date:';

  @override
  String get checkInDayLabel => 'Day:';

  @override
  String get checkInLoading => 'Loading...';

  @override
  String get checkInNoPreviousFound => 'No previous check-ins found';

  @override
  String get checkInLabel => 'Check-in:';

  @override
  String get checkInSinceLastBadge => 'Check-in since last';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get checkInProfileCurrentWeightTitle => 'Current Weight (kg)';

  @override
  String get checkInProfileAverageWeightTitle => 'Average Weight in %';

  @override
  String get commonBack => 'Back';

  @override
  String get commonAnswer => 'Answer';

  @override
  String get commonTypeHint => 'Type...';

  @override
  String get commonUpload => 'Upload';

  @override
  String get commonNoAnswer => 'No answer';

  @override
  String get checkInPhotosMultiFileInfo =>
      'You Can Select Multiple Files, But At Least One File Must Be Chosen';

  @override
  String get checkInPhotosSelectFileLabel => 'Select File';

  @override
  String get checkInPhotosSingleVideoInfo =>
      'Only One Video Can Be Uploaded, And The Maximum File Size Is 500 MB.';

  @override
  String get checkInPhotosVideoDropLabel => 'Drag & drop video file';

  @override
  String get checkInPhotosUploadSuccess => 'Files uploaded successfully';

  @override
  String get checkInQuestion1Title => 'Q1 . What are you proud of? *';

  @override
  String get checkInQuestion2Title => 'Q2 . Calories per default quantity *';

  @override
  String get checkInWellBeingSectionTitle => 'Well-Being';

  @override
  String get checkInWellBeingEnergyLabel => 'Energy Level (1-10)';

  @override
  String get checkInWellBeingStressLabel => 'Stress level (1-10)';

  @override
  String get checkInWellBeingMoodLabel => 'Mood level (1-10)';

  @override
  String get checkInWellBeingSleepLabel => 'Sleep quality (1-10)';

  @override
  String get checkInNutritionSectionTitle => 'Nutrition';

  @override
  String get checkInNutritionDietLevelLabel => 'Diet Level  (1-10)';

  @override
  String get checkInNutritionDigestionLabel => 'Digestion  (1-10)';

  @override
  String get checkInNutritionChallengeTitle => 'Challenge Diet';

  @override
  String get checkInTrainingSectionTitle => 'Training';

  @override
  String get checkInTrainingFeelStrengthLabel => 'Feel Strength (1-10)';

  @override
  String get checkInTrainingPumpsLabel => 'Pumps  (1-10)';

  @override
  String get checkInTrainingCompletedLabel => 'Training Completed?';

  @override
  String get checkInTrainingCardioCompletedLabel => 'Cardio Completed?';

  @override
  String get checkInTrainingFeedbackTitle => 'Feedback Training';

  @override
  String get checkInAthleteNoteTitle => 'Athlete Note';

  @override
  String get checkInCheckingCurrentWeightTitle => 'Current Weight';

  @override
  String get checkInCheckingAverageWeightTitle => 'Average Weight';

  @override
  String get checkInCheckingBasicDataTitle => 'Basic Data';

  @override
  String get checkInCheckingPicturesUploadedLabel => 'Pictures uploaded?';

  @override
  String get checkInCheckingVideoUploadedLabel => 'Video uploaded?';

  @override
  String get checkInCheckingVideoPlaceholderTitle => 'Muscular Workout';

  @override
  String get checkInCheckingVideoUploadedSubtitle => 'Uploaded Video';

  @override
  String get checkInCheckingVideoDefaultSubtitle => 'Upper Body Low';

  @override
  String get checkInCheckingQuestionCountDescription =>
      'Select how many questions you have answered (You must answer at least 7 questions)';
}
