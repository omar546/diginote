import 'package:diginote/shared/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_quill/flutter_quill.dart';

import '../shared/cubit/states.dart';

class ShowEditScreen extends StatefulWidget {
   const ShowEditScreen({Key? key}) : super(key: key);

  @override
  State<ShowEditScreen> createState() => _ShowEditScreenState();
}

class _ShowEditScreenState extends State<ShowEditScreen> {

  var edittimeController = TextEditingController();

  var editdateController = TextEditingController();

   @override
   void initState() {
     super.initState();
     // Set the initial title to the edittitleController when the widget initializes
     AppCubit.get(context).edittitleController.text = AppCubit.get(context).tappedTitle;
   }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
    builder: (context, state) {
    return Scaffold(
      body: Container(
        color:
        Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          color:
          Theme.of(context).scaffoldBackgroundColor,
          child: Column(
              children: [
                Visibility(
                  visible: AppCubit.get(context).formater,
                  child: QuillToolbar.simple(
                    configurations: QuillSimpleToolbarConfigurations(
                      showDividers: false,
                      showClipboardPaste: false,
                      showClipboardCut: false,
                      showClipboardCopy: false,
                      showRightAlignment:false,
                      showCodeBlock: false,
                      showFontFamily: false,
                      showInlineCode: false,
                      showHeaderStyle: false,
                      showAlignmentButtons: true,
                      showQuote: false,
                      showIndent: false,
                      showStrikeThrough: false,
                      controller: AppCubit.get(context).quillController,
                      sharedConfigurations: const QuillSharedConfigurations(
                        locale: Locale('en'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                        controller: AppCubit.get(context).quillController,
                        sharedConfigurations: const QuillSharedConfigurations(
                          locale: Locale('en'),
                        ),
                      ),
                    ),
                  ),
                )
              ],
          ),

          // Form(
          //   key: AppCubit.get(context).editformKey,
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(AppCubit.get(context).tappedDate,style: const TextStyle(color: Colors.grey,fontSize: 12),),
          //           const SizedBox(width: 10,),
          //           Text(AppCubit.get(context).tappedTime,style: const TextStyle(color: Colors.grey,fontSize: 12),),
          //         ],),
          //       const SizedBox(
          //           height: 35.0,
          //           width: double.infinity),
          //       buildTextField(
          //         context: context,
          //         labelText: 'Title',
          //         controller: AppCubit.get(context).edittitleController,
          //         validate: (String? value) {
          //           if (value == null ||
          //               value.isEmpty) {
          //             return 'Please type a title';
          //           }
          //           return null; // Return null to indicate the input is valid
          //         },
          //         type: TextInputType.multiline,
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  });
}
}
