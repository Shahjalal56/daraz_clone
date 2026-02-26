import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'app/routes/app_routes.dart';
import 'app/viewmodels/app_viewmodels.dart';
import 'core/di/di_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await diConfig();
  runApp(
    MultiProvider(
      providers: AppViewModels.viewmodels,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'DarazClone',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.routes,
          theme: ThemeData(
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF6000),
            ),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
