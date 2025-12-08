import 'package:fitness_app/presentation/daily/daily_tracking/presentation/pages/daily_page.dart';
import 'package:fitness_app/presentation/auth/pages/forgetPass_page.dart';
import 'package:fitness_app/presentation/auth/pages/otp_pages.dart';
import 'package:fitness_app/presentation/checkIn/pages/checkIn_pages.dart';
import 'package:fitness_app/presentation/home/pages/home_page.dart';
import 'package:fitness_app/presentation/training/pages/exercise_page.dart';
import 'package:fitness_app/presentation/training/pages/exercise_detail_page.dart';
import 'package:fitness_app/presentation/training/pages/training_plan_page.dart';
import 'package:fitness_app/presentation/training/pages/training_plan_detail_page.dart';
import 'package:fitness_app/presentation/training/pages/workout_session_page.dart';
import 'package:fitness_app/presentation/training/pages/training_history_page.dart';
import 'package:fitness_app/presentation/training/pages/training_history_detail_page.dart';
import 'package:fitness_app/presentation/training/pages/training_split_page.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/presentation/auth/pages/login_page.dart';
import 'package:fitness_app/presentation/auth/pages/splash_page.dart';

import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String splashPage = '/splash';
  static const String loginPage = '/login';
  static const String forgetPassPage = '/forgetPass';
  static const String otpPages = '/otpPages';
  static const String homePage = '/home';
  static const String checkinPages = '/checkinPages';
  static const String dailyPage = '/daily';
  static const String exercisesPage = '/exercises';
  static const String exerciseDetailPage = '/exercise_detail';
  static const String trainingPlanPage = '/training_plan';
  static const String trainingPlanDetailPage = '/training_plan_detail';
  static const String workoutSessionPage = '/workout_session';
  static const String trainingHistoryPage = '/training_history';
  static const String trainingHistoryDetailPage = '/training_history_detail';
  static const String trainingSplitPage = '/training_split';

  static Page<dynamic> fadeTransitionPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<dynamic>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

final GoRouter AppRouter = GoRouter(
  initialLocation: AppRoutes.splashPage,
  routes: [
    GoRoute(
      path: AppRoutes.splashPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.loginPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgetPassPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const ForgetpassPage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.otpPages,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: OtpPages(),
      ),
    ),

    GoRoute(
      path: AppRoutes.homePage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const HomePage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.checkinPages,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const CheckinPages(),
      ),
    ),

    GoRoute(
      path: AppRoutes.dailyPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const DailyPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.exercisesPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const ExercisePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.exerciseDetailPage,
      pageBuilder: (context, state) {
        final extra = state.extra;
        final ex = extra is ExerciseEntity ? extra : null;
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: ExerciseDetailPage(
            exercise:
                ex ??
                const ExerciseEntity(
                  id: 'unknown',
                  title: 'Exercise',
                  category: 'All',
                  equipment: '',
                  tags: [],
                  description: '',
                  imageUrl: '',
                ),
          ),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.trainingPlanPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const TrainingPlanPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.trainingPlanDetailPage,
      pageBuilder: (context, state) {
        final extra = state.extra;
        final plan = extra is TrainingPlanEntity
            ? extra
            : const TrainingPlanEntity(
                id: '0',
                title: 'Error',
                subtitle: '',
                date: '',
                type: 'Error',
              );
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: TrainingPlanDetailPage(plan: plan),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.workoutSessionPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const WorkoutSessionPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.trainingHistoryPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const TrainingHistoryPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.trainingHistoryDetailPage,
      pageBuilder: (context, state) {
        final extra = state.extra;
        // Handle potential null or wrong type for safety, though navigation logic ensures it
        final historyItem = extra is TrainingHistoryEntity
            ? extra
            : const TrainingHistoryEntity(
                id: '',
                month: '',
                workoutCount: 0,
                workoutName: 'Error',
                dateTime: '',
                exercises: [],
                duration: '',
                volume: '',
                prs: '',
              );

        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: TrainingHistoryDetailPage(historyItem: historyItem),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.trainingSplitPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const TrainingSplitPage(),
      ),
    ),
  ],
);
