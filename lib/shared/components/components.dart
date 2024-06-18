import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/cubit.dart';
import '../styles/Themes.dart';
import '../styles/styles.dart';

Widget buildTextField({
  double widthRit = 0.6,
  required BuildContext context,
  required String labelText,
  required TextEditingController controller,
  IconData? prefix,
  bool isClickable = true,
  var onTap,
  var validate,
  required TextInputType type,
  var onSubmit,
  var onChange,
}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(
        right: 40,
      ),
      child: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        child: TextFormField(
          enabled: isClickable,
          validator: validate,
          keyboardType: type,
          minLines: 1,
          maxLines: double.maxFinite.toInt(),
          onFieldSubmitted: onSubmit,
          onChanged: onChange,
          onTap: onTap,
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 16),
          cursorColor: Styles.gumColor,
          controller: controller,
          // Set the validator function
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 45.0),
            prefixIcon: Icon(prefix, color: Styles.gumColor),
            hintText: labelText,
            hintStyle: TextStyle(
              color: Styles.gumColor.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            // contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
            border: InputBorder.none,
          ),
        ),
      ),
    ),
  );
}

Widget buildCategoryItem({required Map model, context, required index}) =>
    GestureDetector(onTap: (){
      if(model['category']!= 'uncategorized'){
        AppCubit.get(context).showCategoryValueUpdatePrompt(id: model['id'],context: context,cat: model['category']);
      }
    },
      onLongPress: () {AppCubit.get(context).deleteAllByCategory(id: model['id'],cat:model['category'],context: context);},
      child: Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(
                Icons.delete_forever_rounded,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
        onDismissed: (direction) {
          if(model['category']!='uncategorized'){
            AppCubit.get(context).deleteCategory(id: model['id'],cat:model['category']);
          }

        },
        key: Key(model['id'].toString()),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.75),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context)
                                .inputDecorationTheme
                                .prefixIconColor
                                ?.withOpacity(0.5) ??
                            Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                      color: hexToColor(model['color']),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      '${model['category']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: hexToColor(model['color'])
                                                      .computeLuminance() <
                                                  0.5
                                              ? Styles.whiteColor
                                              : Styles.blackColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

Widget buildMenuCategoryItem({required Map model, context, required int index}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Column(
      children: [
        Icon(Icons.folder,color: hexToColor(model['color']),size: 50,),
        Text(model['category'],style: const TextStyle(fontSize: 10,overflow: TextOverflow.ellipsis),),
      ],
    ),
  );
}

Widget buildNoteItem({required Map model, context, required index}) =>
    BlocBuilder<ThemeCubit, ThemeData>(builder: (context, theme) {
      return GestureDetector(
        onLongPress: () {
          Clipboard.setData(ClipboardData(
            text: model['ptitle']
                .replaceAll('""', '"')
                .replaceAll("''", "'")
                .replaceAll('￼', ''),
          ));
          showToast(message: 'Copied', state: ToastStates.SUCCESS);
        },
        child: Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
          onDismissed: (direction) {
            AppCubit.get(context).deleteDatabase(id: model['id']);

          },
          key: Key(model['id'].toString()),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.85),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context)
                                  .inputDecorationTheme
                                  .prefixIconColor
                                  ?.withOpacity(0.5) ??
                              Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        color: Theme.of(context)
                                .inputDecorationTheme
                                .suffixIconColor ??
                            Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: RichText(
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 6,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.1,
                                          letterSpacing: 2,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                '${model['ptitle'].replaceAll('""', '"').replaceAll("''", "'").replaceAll("￼", "🖼️").split('\n')[0] + '\n'}',
                                            style: const TextStyle(
                                                fontFamily: 'nunito-exbold'),
                                          ),
                                          TextSpan(
                                            text:
                                                '\n${model['ptitle'].replaceAll('""', '"').replaceAll("''", "'").replaceAll("￼", "🖼️").split('\n').sublist(1).join('\n')}',
                                            style: const TextStyle(
                                                fontFamily: 'nunito'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${model['date']}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'nunito',
                                    color: Theme.of(context)
                                            .inputDecorationTheme
                                            .prefixIconColor ??
                                        Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${model['time']}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'nunito',
                                    color: Theme.of(context)
                                            .inputDecorationTheme
                                            .prefixIconColor ??
                                        Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                CircleAvatar(
                                  backgroundColor: Colors.black45,
                                  radius: 6,
                                  child: CircleAvatar(
                                    backgroundColor: hexToColor(model['color']),
                                    radius: 5,
                                  ),
                                )
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(
                //   width: 10,
                // ),
                // Visibility(
                //   visible: index == 0 || index == 2,
                //   child: IconButton(
                //       splashRadius: 20,
                //       onPressed: () {
                //         AppCubit.get(context).updateDatabase(
                //           status: 'done',
                //           id: model['id'],
                //         );
                //       },
                //       icon: const Icon(
                //         Icons.check_circle_outline_rounded,
                //         color: Styles.greyColor,
                //         size: 25,
                //       )),
                // ),
                // Visibility(
                //   visible: index == 0 || index == 1,
                //   child: IconButton(
                //       splashRadius: 20,
                //       onPressed: () {
                //         AppCubit.get(context).updateDatabase(
                //           status: 'archive',
                //           id: model['id'],
                //         );
                //       },
                //       icon: const Icon(
                //         Icons.archive_outlined,
                //         color: Styles.greyColor,
                //         size: 25,
                //       )),
                // ),
                // Visibility(
                //   visible: index == 1 || index == 2,
                //   child: IconButton(
                //       splashRadius: 20,
                //       onPressed: () {
                //         AppCubit.get(context).updateDatabase(
                //           status: 'new',
                //           id: model['id'],
                //         );
                //       },
                //       icon: const Icon(
                //         Icons.hide_source_rounded,
                //         color: Styles.greyColor,
                //         size: 25,
                //       )),
                // ),
              ],
            ),
          ),
        ),
      );
    });

void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (Route<dynamic> route) => false);

Widget customButton(
    {required final String text,
    required BuildContext context,
    double widthRatio = double.infinity,
    double height = 50.0,
    required final VoidCallback onPressed}) {
  return SizedBox(
    height: height,
    width: MediaQuery.sizeOf(context).width * widthRatio,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(), backgroundColor: Styles.gumColor),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'bitter-bold',
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    ),
  );
}

Widget customForm({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType type,
  dynamic onSubmit,
  dynamic onChange,
  dynamic onTap,
  bool isPassword = false,
  dynamic validate,
  required String label,
  IconData? prefix,
  IconData? suffix,
  dynamic suffixPressed,
  bool isClickable = true,
  IconButton? suffixIcon,
}) {
  return TextFormField(
    enabled: isClickable,
    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    validator: validate,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        prefix,
      ),
      suffixIcon: suffix != null
          ? IconButton(
              onPressed: suffixPressed,
              icon: Icon(
                suffix,
                color: Styles.gumColor,
              ),
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(
          color: Styles.greyColor,
          width: 2.0,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Styles.gumColor,
        ),
      ),
    ),
  );
}

Widget customTextButton({
  required String text,
  required dynamic onPressed,
  Color color = Styles.gumColor,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(color: color),
    ),
  );
}

void showToast({
  required String message,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Styles.gumColor;
      break;
  }

  return color;
}
