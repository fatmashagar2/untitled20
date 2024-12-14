import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart'; // استيراد الحزمة
import 'dart:io'; // لاستعمال File لتحميل الصورة
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../../layout/layout_cubit/layout_cubit.dart';
import '../../../layout/layout_cubit/layout_states.dart';
import '../change_password_screen.dart';
import '../update_user_data_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  late Box<String> imageBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    //بعرف المسار اللي هيتخزن فيه
    final appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    imageBox = await Hive.openBox<String>('imageBox');
    setState(() {
      _image = imageBox.get('userProfileImage') != null
          ? File(imageBox.get('userProfileImage')!)
          : null;
    });
  }


  Future<void> _pickImage() async {
    final XFile? pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an option"),
          actions: [
            TextButton(
              onPressed: () async {
                final XFile? file = await _picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, file);
              },
              child: const Text("Camera"),
            ),
            TextButton(
              onPressed: () async {
                final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, file);
              },
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );


    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imageBox.put('userProfileImage', pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = BlocProvider.of<LayoutCubit>(context);
        if (cubit.userModel == null) cubit.getUserData();

        return Scaffold(
          backgroundColor: Color(0xffFFFFFF),
          body: cubit.userModel != null
              ? Padding(
            padding:  EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 20.0.w),
            child: Center(
              child: Column(
                children: [
                     GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : NetworkImage(cubit.userModel!.image!) as ImageProvider,
                      radius: 60.r,
                    ),
                  ),
                   SizedBox(height: 20.h),

                  Text(
                    cubit.userModel!.name!,
                    style:  TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                   SizedBox(height: 10.h),

                  Text(
                    cubit.userModel!.email!,
                    style:  TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white60,
                    ),
                  ),
                   SizedBox(height: 30.h),

                  _buildButton(
                    context,
                    label: "Change Password",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                      );
                    },
                  ),
                   SizedBox(height: 20.h),
                  _buildButton(
                    context,
                    label: "Update Data",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateUserDataScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
              : const Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      },
    );
  }


  Widget _buildButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      color: Color(0xff2d4569),
      textColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.r),
      ),
      padding:  EdgeInsets.symmetric(vertical: 15.h, horizontal: 40.w),
      child: Text(
        label,
        style:  TextStyle(fontSize: 16.sp),
      ),
    );
  }
}
