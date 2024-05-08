import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:diginote/layout/home_layout.dart';
import 'package:diginote/shared/styles/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import '../register/register_screen.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_states.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isPassword = true;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(ShopLoginInitialState()),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status ?? false) {
              if (kDebugMode) {
                print(state.loginModel.message);
              }
              if (kDebugMode) {
                print(state.loginModel.data?.token);
              }
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data?.token)
                  .then((value) {
                    token = state.loginModel.data?.token??'';
                    if (kDebugMode) {
                      print(token);
                    }
                    if (kDebugMode) {
                      print('after log in ');
                    }
                navigateAndFinish(context, HomeLayout());
              });
            } else {
              if (kDebugMode) {
                print(state.loginModel.message);
              }
              showToast(
                  message: state.loginModel.message ?? '',
                  state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment:MainAxisAlignment.start,
                              children: [
                                Text(
                                  'DIGI\nNOTE',textAlign: TextAlign.center,
                                  style: TextStyle(height:1,fontSize: 50, fontFamily: 'gyanko',color: Styles.gumColor,),
                                ),
                                SizedBox(height: 70,)
                              ],
                            ),
                          ],
                        ),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Text(
                          'Join now to take notes!',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        customForm(
                          context: context,
                          label: 'Email Address',
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          onSubmit: (String value) {
                            if (kDebugMode) {
                              print(value);
                            }
                          },
                          onChange: (String value) {
                            if (kDebugMode) {
                              print(value);
                            }
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "email..please!";
                            } else {
                              return null;
                            }
                          },
                          prefix: Icons.alternate_email_rounded,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        customForm(
                          context: context,
                          label: 'Password',
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: ShopLoginCubit.get(context).suffix,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          onChange: (String value) {
                            if (kDebugMode) {
                              print(value);
                            }
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "forgot your password!";
                            } else {
                              return null;
                            }
                          },
                          prefix: Icons.password_rounded,
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          suffixPressed: () {
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Center(
                          child: ConditionalBuilder(
                              condition: state is! ShopLoginLoadingState,
                              builder: (context) => customButton(
                                  widthRatio: 0.6,
                                  context: context,
                                  text: "LOGIN",
                                  onPressed: () {

                                    // if (formKey.currentState!.validate()) {
                                    //   NoteLoginCubit.get(context).userLogin(
                                    //       email: emailController.text,
                                    //       password: passwordController.text);
                                    // }
                                    navigateAndFinish(context, HomeLayout());
                                  }),
                              fallback: (context) =>
                              const CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            customTextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              text: 'REGISTER',
                              color: Colors.lightBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
