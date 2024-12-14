import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled20/shared/constants/constants.dart';
import 'package:untitled20/shared/network/local_network.dart';
import 'layout/layout_cubit/layout_cubit.dart';
import 'layout/layout_screen.dart';
import 'modules/Screens/auth_screens/auth_cubit/auth_cubit.dart';
import 'modules/Screens/auth_screens/login_screen.dart';
import 'modules/Screens/splash_screen/splash_screen.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheNetwork.cacheInitialization();
userToken = await CacheNetwork.getCacheData(key: 'token');
  currentPassword = await CacheNetwork.getCacheData(key: 'password');
 debugPrint("User token is : $userToken");
  debugPrint("Current Password is : $currentPassword");


  final appDocumentDir = await getDocumentsDirectory();
  Hive.init(appDocumentDir);

  await Hive.openBox<String>('imageBox');

  var userBox = await Hive.openBox('userBox');
var userData = userBox.get('userData');
  debugPrint("User Data: $userData");

  // التحقق من الاتصال بالشبكة
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // في حالة عدم وجود اتصال بالشبكة
    debugPrint("No network connection");
  } else {
    // التحقق من الاتصال بالإنترنت الفعلي
    bool isConnected = await _isInternetConnected();
    if (isConnected) {
      debugPrint("Connected to the internet");
    } else {
      debugPrint("No internet connection");
    }
  }

  runApp(const MyApp());
}


Future<bool> _isInternetConnected() async {
  try {
    if (kIsWeb) {
       var connectivityResult = await (Connectivity().checkConnectivity());
      return connectivityResult != ConnectivityResult.none;
    } else {
       final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    }
  } on SocketException catch (_) {
    return false;
  }
}

Future<String> getDocumentsDirectory() async {
  if (kIsWeb) {
    return 'Web does not support application documents directory';
  } else {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => LayoutCubit()
          ..getFavorites()
          ..getBannersData()
          ..getProducts()
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),


        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
