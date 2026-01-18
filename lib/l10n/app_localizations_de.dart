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
  String get profileAppBarTitle => 'Profil';

  @override
  String get profileLogoutTitle => 'Abmelden';

  @override
  String get profileLogoutMessage => 'Möchtest du dich wirklich abmelden?';

  @override
  String get profileLogoutCancel => 'Abbrechen';

  @override
  String get profileLogoutConfirm => 'Abmelden';

  @override
  String get profileSectionPersonalData => 'Persönliche Daten';

  @override
  String get profileSectionAthleteInfo => 'Athleten-Infos';

  @override
  String get profileSectionAccount => 'Konto';

  @override
  String get profileSectionShowInfo => 'Show-Informationen';

  @override
  String get profileLabelFullName => 'Vollständiger Name';

  @override
  String get profileLabelEmail => 'E-Mail';

  @override
  String get profileLabelGender => 'Geschlecht';

  @override
  String get profileLabelStatus => 'Status';

  @override
  String get profileLabelCategory => 'Kategorie';

  @override
  String get profileLabelCheckInDay => 'Check-in-Tag';

  @override
  String get profileLabelHeight => 'Größe (cm)';

  @override
  String get profileLabelAge => 'Alter';

  @override
  String get profileLabelAgeYearsSuffix => 'Jahre';

  @override
  String get profileLabelGoal => 'Ziel';

  @override
  String get profileLabelTrainingDaySteps => 'Schritte Trainingstag';

  @override
  String get profileLabelRestDaySteps => 'Schritte Ruhetag';

  @override
  String get profileLabelStepsSuffix => 'Schritte';

  @override
  String get profileLabelRole => 'Rolle';

  @override
  String get profileLabelCoach => 'Coach';

  @override
  String get profileLabelMemberSince => 'Mitglied seit';

  @override
  String get profileLabelShowName => 'Show-Name';

  @override
  String get profileLabelShowDate => 'Show-Datum';

  @override
  String get profileLabelLocation => 'Ort';

  @override
  String get profileLabelDivision => 'Division';

  @override
  String get profileLabelCountdown => 'Countdown';

  @override
  String get profileLabelDaysSuffix => 'Tage';

  @override
  String get profileTimelineHeaderWeek => 'Woche';

  @override
  String get profileTimelineHeaderDate => 'Datum';

  @override
  String get profileTimelineHeaderPhase => 'Phase';

  @override
  String get profileEmpty => 'Keine Profildaten gefunden';

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

  @override
  String get dailyTrackingAppBarTitle => 'Tägliches Tracking';

  @override
  String get dailyTrackingError => 'Fehler';

  @override
  String get dailyTrackingSaved => 'Gespeichert';

  @override
  String get trainingAppBarTitle => 'Training';

  @override
  String get trainingStatsPrsThisWeek => 'PRs dieser Woche';

  @override
  String get trainingStatsWeeklyVolume => 'Wöchentliches Volumen';

  @override
  String get trainingStatsTrainings => 'Trainingseinheiten';

  @override
  String get trainingMenuExercisesTitle => 'ÜBUNGEN';

  @override
  String get trainingMenuExercisesSubtitle => 'Datenbank';

  @override
  String get trainingMenuPlanTitle => 'TRAININGSPLAN';

  @override
  String get trainingMenuPlanSubtitle => 'Wochenübersicht';

  @override
  String get trainingMenuHistoryTitle => 'HISTORIE';

  @override
  String get trainingMenuHistorySubtitle => 'Vergangene Workouts';

  @override
  String get trainingMenuSplitTitle => 'TRAINING SPLIT';

  @override
  String get trainingMenuSplitSubtitle => 'Trainingssplit ansehen';

  @override
  String get trainingSplitAppBarTitle => 'Training Split';

  @override
  String get trainingExerciseAppBarTitle => 'Übungen';

  @override
  String get trainingExerciseSearchHint => 'Übung suchen';

  @override
  String get trainingExerciseFilterAll => 'Alle';

  @override
  String get trainingExerciseFilterChest => 'Brust';

  @override
  String get trainingExerciseFilterBack => 'Rücken';

  @override
  String get trainingExerciseFilterLegs => 'Beine';

  @override
  String get trainingExerciseGenericError => 'Es ist ein Fehler aufgetreten';

  @override
  String get trainingPlanAppBarTitle => 'Trainingsplan';

  @override
  String get trainingHistoryAppBarTitle => 'Training Historie';

  @override
  String get trainingHistoryEmpty => 'Keine Historie verfügbar';

  @override
  String trainingHistoryHeaderWorkouts(Object count) {
    return '$count Workout';
  }

  @override
  String get trainingHistoryLabelSetsBest => 'Sätze / Bestes Set → Bestes Set';

  @override
  String get trainingHistoryLabelBest => 'Bestes';

  @override
  String get trainingHistoryLabelPrs => 'PRs';

  @override
  String get trainingSplitHeaderDay => 'Tag';

  @override
  String get trainingSplitHeaderWork => 'Arbeit';

  @override
  String get dailyDateLabel => 'Datum:';

  @override
  String get dailyDateToday => 'Heute';

  @override
  String get dailyWeightLabel => 'Gewicht:';

  @override
  String get dailyWeightHint => '65,2 (kg)';

  @override
  String get dailySleepLabel => 'Schlaf:';

  @override
  String get dailySleepDurationHint => '08 : 45 (Minuten)';

  @override
  String get dailySleepQualityLabel => 'Schlafqualität (1 - 10)';

  @override
  String get dailySickLabel => 'Krank:';

  @override
  String get commonYes => 'Ja';

  @override
  String get commonNo => 'Nein';

  @override
  String get dailyWaterLabel => 'Wasser:';

  @override
  String get dailyWaterHint => '1,2 (Liter)';

  @override
  String get dailyWaterAdvice => 'Mindestens 2,5 Liter empfohlen.';

  @override
  String get dailyEnergySectionTitle => 'Energie & Wohlbefinden';

  @override
  String get dailyEnergyLevelLabel => 'Energieniveau (1-10)';

  @override
  String get dailyStressLevelLabel => 'Stresslevel (1-10)';

  @override
  String get dailyMuscleSorenessLabel => 'Muskelkater (1-10)';

  @override
  String get dailyMoodLabel => 'Stimmung (1-10)';

  @override
  String get dailyMotivationLabel => 'Motivation (1-10)';

  @override
  String get dailyBodyTempLabel => 'Körpertemperatur';

  @override
  String get dailyGenericTypeHint => 'Eingeben...';

  @override
  String get dailyTrainingSectionTitle => 'Training';

  @override
  String get dailyTrainingCompletedTitle => 'Training abgeschlossen?';

  @override
  String get dailyTrainingPlanTitle => 'Trainingsplan?';

  @override
  String get dailyTrainingPlanPlaceholder => 'Platzhalter';

  @override
  String get dailyTrainingPlanPushFullbody => 'Push Ganzkörper';

  @override
  String get dailyTrainingPlanLegDayAdvanced => 'Beintag Fortgeschritten';

  @override
  String get dailyTrainingPlanPlan1 => 'Trainingsplan 1';

  @override
  String get dailyCardioCompletedTitle => 'Cardio abgeschlossen?';

  @override
  String get dailyCardioTypeTitle => 'Cardio-Typ?';

  @override
  String get dailyCardioWalking => 'Gehen';

  @override
  String get dailyCardioCycling => 'Radfahren';

  @override
  String get dailyDurationHint => 'Dauer (Minuten)';

  @override
  String get dailyActivityStepsLabel => 'Aktivitätsschritte:';

  @override
  String get dailyActivityStepsHint => '10000';

  @override
  String get dailyNutritionSectionTitle => 'Ernährung';

  @override
  String get dailyNutritionCaloriesLabel => 'Kalorien';

  @override
  String get dailyNutritionCarbsLabel => 'Kohlenhydrate';

  @override
  String get dailyNutritionProteinLabel => 'Protein';

  @override
  String get dailyNutritionFatsLabel => 'Fette';

  @override
  String get nutritionAppBarTitle => 'Ernährung';

  @override
  String get nutritionMenuFoodItemsTitle => 'Lebensmittel';

  @override
  String get nutritionMenuFoodItemsSubtitle => 'Datenbank';

  @override
  String get nutritionMenuPlanTitle => 'Ernährungsplan';

  @override
  String get nutritionMenuPlanSubtitle => 'Wochenübersicht';

  @override
  String get nutritionMenuTrackMealsTitle => 'Mahlzeiten tracken';

  @override
  String get nutritionMenuTrackMealsSubtitle => 'Zum protokollieren';

  @override
  String get nutritionMenuStatisticsTitle => 'Statistiken';

  @override
  String get nutritionMenuStatisticsSubtitle => 'Verlauf ansehen';

  @override
  String get nutritionMenuSupplementTitle => 'Supplement-Plan';

  @override
  String get nutritionMenuPedTitle => 'PEDs';

  @override
  String get nutritionMenuPedSubtitle => 'Plan';

  @override
  String get nutritionTodayMacrosTitle => 'Heutige Makros';

  @override
  String get nutritionMacroProteinLabel => 'Protein';

  @override
  String get nutritionMacroCarbsLabel => 'Kohlenhydrate';

  @override
  String get nutritionMacroFatsLabel => 'Fett';

  @override
  String get nutritionTrackDailyGoalTitle => 'Tagesziel';

  @override
  String get nutritionTrackDailyGoalSubtitle => 'Mahlzeiten tracken';

  @override
  String get nutritionTrackAddItem => 'Eintrag hinzufügen';

  @override
  String get nutritionTrackCancel => 'Abbrechen';

  @override
  String get nutritionTrackAddMeal => 'Mahlzeit hinzufügen';

  @override
  String get nutritionTrackMealNameLabel => 'Mahlzeitenname';

  @override
  String get nutritionTrackMealTimeLabel => 'Zeitlabel';

  @override
  String get nutritionTrackFoodNameLabel => 'Lebensmittelname';

  @override
  String get nutritionTrackFoodQuantityLabel => 'Menge';

  @override
  String get nutritionTrackFoodQuantityHint => 'z.B. 200g';

  @override
  String get nutritionTrackFoodNameHint => 'Eingeben...';

  @override
  String get nutritionTrackValidationMealRequired =>
      'Mahlzeitenname und mindestens ein Eintrag erforderlich';

  @override
  String get nutritionTrackTrainingDayLabel => 'Trainingstag';

  @override
  String get nutritionTrackTableActionLabel => 'Aktion';

  @override
  String get nutritionTrackNoItemsLogged => 'Keine Einträge erfasst.';

  @override
  String nutritionFoodItemsEnergyLabel(Object quantity) {
    return 'Energie ($quantity):';
  }

  @override
  String get nutritionFoodItemsProteinLabel => 'Protein';

  @override
  String get nutritionFoodItemsCarbsLabel => 'Kohlenhydrate';

  @override
  String get nutritionFoodItemsFatsLabel => 'Fette';

  @override
  String get nutritionFoodItemsSatFatsLabel => 'ges. F';

  @override
  String get nutritionFoodItemsUnsatFatsLabel => 'unges. F';

  @override
  String get nutritionFoodItemsSugarLabel => 'Zucker';

  @override
  String get nutritionFoodItemsCategoryProtein => 'Protein';

  @override
  String get nutritionFoodItemsCategoryCarbs => 'Kohlenhydrate';

  @override
  String get nutritionFoodItemsCategoryFats => 'Fette';

  @override
  String get nutritionFoodItemsCategorySupplements => 'Supplements';

  @override
  String get nutritionFoodItemsCategoryFruits => 'Obst';

  @override
  String get nutritionFoodItemsCategoryVegetables => 'Gemüse';

  @override
  String get nutritionFoodItemsCategoryAll => 'Alle';

  @override
  String get nutritionSupplementsHeaderTitle => 'Supplement';

  @override
  String get nutritionSupplementsTableName => 'Name';

  @override
  String get nutritionSupplementsTableDosage => 'Dosierung';

  @override
  String get nutritionSupplementsTableTime => 'Zeit';

  @override
  String get nutritionSupplementsTablePurpose => 'Zweck';

  @override
  String get nutritionSupplementsTableBrand => 'Marke';

  @override
  String get nutritionSupplementsTableComment => 'Kommentar';

  @override
  String get nutritionSupplementsEmpty => 'Keine Supplements gefunden';

  @override
  String get dailyNutritionHungerLabel => 'Hunger (1-10)';

  @override
  String get dailyNutritionDigestionLabel => 'Verdauung (1-10)';

  @override
  String get dailyNutritionSaltLabel => 'Salz (g)';

  @override
  String get dailyWomenSectionTitle => 'Frauen';

  @override
  String get dailyWomenCyclePhaseTitle => 'Zyklusphase?';

  @override
  String dailyWomenCycleDayTitle(Object dayLabel) {
    return 'Zyklustag ($dayLabel)';
  }

  @override
  String get dailyWomenPmsLabel => 'PMS-Symptome (1-10)';

  @override
  String get dailyWomenCrampsLabel => 'Krämpfe (1-10)';

  @override
  String get dailyWomenSymptomsTitle => 'Symptome';

  @override
  String get dailyPedSectionTitle => 'PED';

  @override
  String get dailyPedDosageTitle => 'Tägliche Dosis eingenommen';

  @override
  String get dailyPedSideEffectsTitle => 'Nebenwirkungsnotizen';

  @override
  String get dailyBpSectionTitle => 'Blutdruck';

  @override
  String get dailyBpSystolicLabel => 'Systolisch';

  @override
  String get dailyBpDiastolicLabel => 'Diastolisch';

  @override
  String get dailyBpRestingHrLabel => 'Ruhepuls';

  @override
  String get dailyBpGlucoseLabel => 'Blutzucker';

  @override
  String get dailyNotesSectionTitle => 'Tägliche Notizen';

  @override
  String get dailySubmitButton => 'Speichern';

  @override
  String get checkInAppBarTitle => 'Check-In';

  @override
  String get checkInStepProfile => 'Profil';

  @override
  String get checkInStepPhotos => 'Fotos';

  @override
  String get checkInStepQuestions => 'Fragen';

  @override
  String get checkInStepChecking => 'Überprüfung';

  @override
  String get checkInTabWeekly => 'Wöchentliches Check-In';

  @override
  String get checkInTabOld => 'Alte Check-Ins';

  @override
  String get checkInDateLabel => 'Check-in Datum:';

  @override
  String get checkInDayLabel => 'Tag:';

  @override
  String get checkInLoading => 'Laden...';

  @override
  String get checkInNoPreviousFound => 'Keine früheren Check-Ins gefunden';

  @override
  String get checkInLabel => 'Check-in:';

  @override
  String get checkInSinceLastBadge => 'Check-in seit letztem Mal';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonSubmit => 'Absenden';

  @override
  String get checkInProfileCurrentWeightTitle => 'Aktuelles Gewicht (kg)';

  @override
  String get checkInProfileAverageWeightTitle => 'Durchschnittsgewicht in %';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonAnswer => 'Antwort';

  @override
  String get commonTypeHint => 'Eingeben...';

  @override
  String get commonUpload => 'Hochladen';

  @override
  String get commonNoAnswer => 'Keine Antwort';

  @override
  String get checkInPhotosMultiFileInfo =>
      'Sie können mehrere Dateien auswählen, aber mindestens eine Datei muss ausgewählt werden';

  @override
  String get checkInPhotosSelectFileLabel => 'Datei auswählen';

  @override
  String get checkInPhotosSingleVideoInfo =>
      'Es kann nur ein Video hochgeladen werden, und die maximale Dateigröße beträgt 500 MB.';

  @override
  String get checkInPhotosVideoDropLabel => 'Video-Datei hierher ziehen';

  @override
  String get checkInPhotosUploadSuccess => 'Dateien erfolgreich hochgeladen';

  @override
  String get checkInQuestion1Title => 'F1 . Worauf bist du stolz? *';

  @override
  String get checkInQuestion2Title =>
      'F2 . Kalorien pro Standardmenge *';

  @override
  String get checkInWellBeingSectionTitle => 'Wohlbefinden';

  @override
  String get checkInWellBeingEnergyLabel => 'Energieniveau (1-10)';

  @override
  String get checkInWellBeingStressLabel => 'Stressniveau (1-10)';

  @override
  String get checkInWellBeingMoodLabel => 'Stimmungsniveau (1-10)';

  @override
  String get checkInWellBeingSleepLabel => 'Schlafqualität (1-10)';

  @override
  String get checkInNutritionSectionTitle => 'Ernährung';

  @override
  String get checkInNutritionDietLevelLabel => 'Diätlevel (1-10)';

  @override
  String get checkInNutritionDigestionLabel => 'Verdauung (1-10)';

  @override
  String get checkInNutritionChallengeTitle => 'Schwierige Diät';

  @override
  String get checkInTrainingSectionTitle => 'Training';

  @override
  String get checkInTrainingFeelStrengthLabel => 'Kraftgefühl (1-10)';

  @override
  String get checkInTrainingPumpsLabel => 'Pump (1-10)';

  @override
  String get checkInTrainingCompletedLabel => 'Training abgeschlossen?';

  @override
  String get checkInTrainingCardioCompletedLabel => 'Cardio abgeschlossen?';

  @override
  String get checkInTrainingFeedbackTitle => 'Training-Feedback';

  @override
  String get checkInAthleteNoteTitle => 'Notizen des Athleten';

  @override
  String get checkInCheckingCurrentWeightTitle => 'Aktuelles Gewicht';

  @override
  String get checkInCheckingAverageWeightTitle => 'Durchschnittsgewicht';

  @override
  String get checkInCheckingBasicDataTitle => 'Grunddaten';

  @override
  String get checkInCheckingPicturesUploadedLabel => 'Bilder hochgeladen?';

  @override
  String get checkInCheckingVideoUploadedLabel => 'Video hochgeladen?';

  @override
  String get checkInCheckingVideoPlaceholderTitle => 'Muskeltraining';

  @override
  String get checkInCheckingVideoUploadedSubtitle => 'Hochgeladenes Video';

  @override
  String get checkInCheckingVideoDefaultSubtitle => 'Oberkörper – niedrig';

  @override
  String get checkInCheckingQuestionCountDescription =>
      'Wähle, wie viele Fragen du beantwortet hast (du musst mindestens 7 Fragen beantworten)';
}
