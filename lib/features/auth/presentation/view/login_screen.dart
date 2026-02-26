import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes/route_names.dart';
import '../view_model/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController(text: 'mor_2314');
  final _passwordCtrl = TextEditingController(text: '83r5^_');
  bool _obscure = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final vm = context.read<AuthViewModel>();
    final success = await vm.login(
      _usernameCtrl.text.trim(),
      _passwordCtrl.text,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, RouteNames.productListing);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Login failed'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthViewModel>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60.h),
              _buildLogo(),
              SizedBox(height: 40.h),
              _buildCard(isLoading),
              SizedBox(height: 20.h),
              _buildHint(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() => Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6000),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(Icons.shopping_bag_rounded,
                color: Colors.white, size: 44.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            'DarazClone',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFFF6000),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Sign in to continue',
            style: TextStyle(
                fontSize: 14.sp, color: Colors.grey.shade600),
          ),
        ],
      );

  Widget _buildCard(bool isLoading) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            _InputField(
              controller: _usernameCtrl,
              label: 'Username',
              icon: Icons.person_outline,
            ),
            SizedBox(height: 16.h),
            _InputField(
              controller: _passwordCtrl,
              label: 'Password',
              icon: Icons.lock_outline,
              obscure: _obscure,
              suffix: IconButton(
                icon: Icon(_obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                color: Colors.grey,
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 50.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6000),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  elevation: 0,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
      );

  Widget _buildHint() => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3EC),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFFFD5B8)),
        ),
        child: Text(
          '💡 Demo: mor_2314 / 83r5^_',
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF854D0E)),
          textAlign: TextAlign.center,
        ),
      );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20.sp),
          suffixIcon: suffix,
          filled: true,
          fillColor: const Color(0xFFF8F8F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide:
                const BorderSide(color: Color(0xFFFF6000), width: 1.5),
          ),
        ),
      );
}
