import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes/route_names.dart';
import '../view_model/auth_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6000),
        title: Text('My Profile',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  // Avatar
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: const Color(0xFFFF6000),
                    child: Text(
                      user.firstName[0].toUpperCase(),
                      style: TextStyle(
                          fontSize: 40.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    user.fullName,
                    style: TextStyle(
                        fontSize: 22.sp, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '@${user.username}',
                    style: TextStyle(
                        fontSize: 14.sp, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 32.h),
                  // Info card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        _InfoTile(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: user.email),
                        const Divider(height: 1, indent: 56),
                        _InfoTile(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: user.phone),
                        const Divider(height: 1, indent: 56),
                        _InfoTile(
                            icon: Icons.location_city_outlined,
                            label: 'City',
                            value: user.city),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await context.read<AuthViewModel>().logout();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                              context, RouteNames.login);
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: Text('Logout',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: const Color(0xFFFF6000), size: 22.sp),
        title: Text(label,
            style:
                TextStyle(fontSize: 11.sp, color: Colors.grey.shade500)),
        subtitle: Text(value,
            style: TextStyle(
                fontSize: 14.sp, fontWeight: FontWeight.w600)),
        dense: true,
      );
}
