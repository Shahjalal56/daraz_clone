import 'package:flutter/material.dart';
import '../../features/auth/presentation/view/login_screen.dart';
import '../../features/auth/presentation/view/profile_screen.dart';
import '../../features/products/presentation/view/product_listing_screen.dart';
import 'route_names.dart';

class AppRoutes {
  AppRoutes._();
  static const String initialRoute = RouteNames.login;

  static Map<String, WidgetBuilder> get routes => {
        RouteNames.login: (_) => const LoginScreen(),
        RouteNames.productListing: (_) => const ProductListingScreen(),
        RouteNames.profile: (_) => const ProfileScreen(),
      };
}
