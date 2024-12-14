import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../layout/layout_cubit/layout_cubit.dart';
import '../../layout/layout_cubit/layout_states.dart';
import '../../shared/constants/constants.dart';

class ChangePasswordScreen extends StatelessWidget {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: Color(0xfffdfbda),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please enter your current password and a new password to update.',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            // Current Password Field
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Current Password",
                hintText: "Enter your current password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 16.h),
            // New Password Field
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                hintText: "Enter your new password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 24.h),
            // Update Button
            BlocConsumer<LayoutCubit, LayoutStates>(
              listener: (context, state) {
                if (state is ChangePasswordSuccessState) {
                  showSnackBarItem(context, "Password Updated Successfully", true);
                  Navigator.pop(context);
                }
                if (state is ChangePasswordWithFailureState) {
                  showSnackBarItem(context, state.error, false);
                }
              },
              builder: (context, state) {
                return MaterialButton(
                  onPressed: () {
                    debugPrint("From TextField: ${currentPasswordController.text}, current: $currentPassword");
                    if (currentPasswordController.text == currentPassword) {
                      if (newPasswordController.text.length >= 6) {
                        cubit.changePassword(
                            userCurrentPassword: currentPassword!, newPassword: newPasswordController.text.trim());
                      } else {
                        showSnackBarItem(context, "Password must be at least 6 characters", false);
                      }
                    } else {
                      showSnackBarItem(context, "Please verify your current password and try again", false);
                    }
                  },
                  color: Color(0xff2d4569),
                  height: 50.h,
                  minWidth: double.infinity,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: Text(state is ChangePasswordLoadingState ? "Loading..." : "Update"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBarItem(BuildContext context, String message, bool forSuccessOrFailure) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: forSuccessOrFailure ? Colors.green : Colors.red,
    ));
  }
}
