import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../layout/layout_screen.dart';
import 'auth_cubit/auth_cubit.dart';
import 'auth_cubit/auth_states.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  // Validate form and register user
  void validateFormAndRegister(AuthCubit authCubit) {
    if (formKey.currentState!.validate()) {
      authCubit.register(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    super.dispose();
  }
 String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your phone number";
    }
    final phonePattern = r"^(010|011|012|015)[0-9]{8}\$";
    final regExp = RegExp(phonePattern);
    if (!regExp.hasMatch(value)) {
      return "Invalid phone number. It should start with 010, 011, 012, or 015 and contain 10 digits.";
    }
    return null;
  }


  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email address";
    } else if (!value.contains('@gmail.com')) {
      return "Please enter a valid email address (must be @gmail.com)";
    }
    return null;
  }

   String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 15.w,
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 12.h),

              Image.asset(
                'assets/images/15547248.gif',
                height: 120.h,
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20.h),
              BlocConsumer<AuthCubit, AuthStates>(
                listener: (context, state) {
                  if (state is RegisterSuccessState) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LayoutScreen()),
                    );
                  } else if (state is FailedToRegisterState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registration failed")),
                    );
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: emailValidator,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.phone, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: phoneValidator,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          focusNode: passwordFocusNode,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: passwordValidator,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 8.w,
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 18.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: () {
                              validateFormAndRegister(authCubit);
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontFamily: 'Sevillana',
                                fontSize: 30.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? '),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontFamily: 'Sevillana',
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
