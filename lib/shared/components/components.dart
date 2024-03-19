import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/cubit.dart';
import '../styles/styles.dart';

Widget buildTextField({
  double widthRit = 0.6,
  required BuildContext context,
  required String labelText,
  required TextEditingController controller,
  required IconData prefix,
  bool isClickable = true,
  var onTap,
  var validate,
  required TextInputType type,
  var onSubmit,
  var onChange,
}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Styles.blackColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: TextFormField(
            enabled: isClickable,
            validator: validate,
            keyboardType: type,
            minLines: 1,
            maxLines: null,
            onFieldSubmitted: onSubmit,
            onChanged: onChange,
            onTap: onTap,
            style: const TextStyle(color: Styles.greyColor, fontSize: 16),
            cursorColor: Styles.gumColor,
            controller: controller,
            // Set the validator function
            decoration: InputDecoration(
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
    ),
  );
}

Widget buildTaskItem({required Map model, context, required index}) =>
    Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: AlignmentDirectional.centerStart,
        color: Styles.blackColor,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(30.0, 0.0, 10.0, 0.0),
          child: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(
              Icons.delete_forever_rounded,
              color: Styles.blackColor,
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
                      maxWidth: MediaQuery.of(context).size.width * 0.85),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Styles.lightBlackColor,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    color: Styles.greyColor.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.85,
                          // child: Text('${model['title']}',
                          //     textAlign: TextAlign.left,
                          //     overflow: TextOverflow.ellipsis,
                          //     maxLines: 5,
                          //     style: const TextStyle(
                          //         fontFamily: 'Thunder',
                          //         fontSize: 20,
                          //         height: 1.1,
                          //         letterSpacing: 2,
                          //         color: Styles.whiteColor)),
                          child: Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.1,
                                    letterSpacing: 2,
                                    color: Styles.whiteColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${model['title'].split('\n')[0]}',
                                      style: TextStyle(fontFamily:'bitter-bold'),
                                    ),
                                    TextSpan(
                                      text: '\n${model['title'].split('\n').sublist(1).join('\n')}',
                                      style: TextStyle(fontFamily:'bitter'),

                                    ),
                                  ],
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
                                  '${model['time']}',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'bitter',
                                      color: Styles.greyColor),
                                ),
                                const SizedBox(width: 10,),
                                Text(
                                  '${model['date']}',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Thunder',
                                      color: Styles.greyColor),
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
    );
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
    width: MediaQuery.of(context).size.width * widthRatio,
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
  required IconData prefix,
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
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
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
      color = Colors.amber;
      break;
  }

  return color;
}
