import 'package:diginote/layout/home_layout.dart';
import 'package:diginote/shared/components/constants.dart';
import 'package:diginote/shared/network/local/cache_helper.dart';
import 'package:diginote/shared/network/remote/dio_helper.dart';
import 'package:diginote/shared/styles/Themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/login/login_screen.dart';
import 'modules/onboarding/onboarding_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/cubit/cubit.dart';

void main() async {
  // just to show branding
  // await Future.delayed(const Duration(milliseconds: 750));
  // if main() is async and there is await down here it will wait for it to finish before launching app
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  DioHelper2.init();

  await CacheHelper.init();
  Widget widget;
  bool onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
  token = CacheHelper.getData(key: 'token') ?? 'null';
  if (kDebugMode) {
    print(token);
  }
  await AppCubit().initializeCamera();
  if (onBoarding != false) {
    if (token != 'null') {
      widget = HomeLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp(widget)));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp(this.startWidget, {super.key});
  // constructor
  // build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: startWidget,
          );
        },
      ),
    );
  }
}
