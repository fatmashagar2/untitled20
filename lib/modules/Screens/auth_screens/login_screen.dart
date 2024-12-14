import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../layout/layout_screen.dart'; // الصفحة التي يتم التنقل إليها بعد تسجيل الدخول بنجاح
import '../../../modules/Screens/auth_screens/register_screen.dart'; // صفحة التسجيل
import 'auth_cubit/auth_cubit.dart';
import 'auth_cubit/auth_states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();

  bool isPasswordVisible = false;

  @override
  void dispose() {
    passwordFocusNode.removeListener(() {});
    super.dispose();
  }


  void validateEmailAndPassword(AuthCubit authCubit) {
    if (formKey.currentState!.validate()) {
      authCubit.login(
        email: emailController.text,
        password: passwordController.text,
      );
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please check your email and password"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            vertical: 80.h,
          ),
          child: Column(
            children: [

              SizedBox(
                height: MediaQuery.of(context).size.height / 3.h,
                child: Image.asset(
                  'assets/images/15547248.gif',
                  fit: BoxFit.contain,
                ),
              ),
              BlocConsumer<AuthCubit, AuthStates>(
                listener: (context, state) {
                  if (state is LoginSuccessState) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LayoutScreen()));
                  } else if (state is FailedToLoginState) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please check your email and password"),
                        backgroundColor: Colors.red,
                      ),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter an email";
                            } else if (!value.contains('@gmail.com')) {
                              return "Please enter a valid Gmail address";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),


                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
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
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a password";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 18.h),

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
                            onPressed: () => validateEmailAndPassword(authCubit),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'Sevillana',
                                fontSize: 30.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterScreen()));
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontFamily: 'Sevillana',
                                  color: Colors.black,
                                  fontSize: 20.sp,
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
