import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/notifications/notifications_cubit.dart';
import 'core/routes/app_router.dart';
import 'core/routes/routes.dart';
import 'core/session/patient_cubit.dart';
import 'core/theme/theme.dart';
import 'features/appointments/presentation/cubit/appointments_cubit.dart';
import 'features/assistance/presentation/cubit/assistance_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/community/presentation/cubit/community_cubit.dart';
import 'features/family/presentation/cubit/family_cubit.dart';
import 'features/fluids/presentation/cubit/fluids_cubit.dart';
import 'features/food_assistant/presentation/cubit/food_history_cubit.dart';
import 'features/medications/presentation/cubit/medications_cubit.dart';
import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'features/reports/presentation/cubit/reports_cubit.dart';

class KelitiApp extends StatelessWidget {
  const KelitiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => PatientCubit()),
        BlocProvider(create: (_) => NotificationsCubit()),
        BlocProvider(create: (_) => OnboardingCubit()),
        BlocProvider(create: (_) => FamilyCubit()),
        BlocProvider(create: (_) => MedicationsCubit()),
        BlocProvider(create: (_) => AppointmentsCubit()),
        BlocProvider(create: (_) => ReportsCubit()),
        BlocProvider(create: (_) => FluidsCubit()),
        BlocProvider(create: (_) => AssistanceCubit()),
        BlocProvider(create: (_) => CommunityCubit()),
        BlocProvider(create: (_) => FoodHistoryCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'كليتي',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, widget) => Directionality(textDirection: TextDirection.rtl, child: widget!),
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
