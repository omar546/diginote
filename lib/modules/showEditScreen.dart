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
     AppCubit.get(context).quillController = QuillController(document: Document()..insert(0, AppCubit.get(context).tappedTitle), selection: TextSelection.collapsed(offset:AppCubit.get(context).tappedTitle.length));
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
                  visible: AppCubit.get(context).formaterB,
                  child: QuillToolbar.simple(
                    configurations: QuillSimpleToolbarConfigurations(
                      showSuperscript: false,
                      showSubscript: false,
                      showBoldButton: false,
                      showItalicButton: false,
                      showUnderLineButton: false,
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
                      showStrikeThrough: false,
                      showFontSize: false,
                      showBackgroundColorButton: false,
                      showColorButton: false,
                      showSearchButton: false,
                      controller: AppCubit.get(context).quillController,
                      sharedConfigurations: const QuillSharedConfigurations(
                        locale: Locale('en'),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: AppCubit.get(context).formaterA,
                  child: QuillToolbar.simple(
                    configurations: QuillSimpleToolbarConfigurations(
                      showListNumbers: false,
                      showListBullets: false,
                      showListCheck: false,
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
                      showSmallButton: false,
                      showCenterAlignment: false,
                      showDirection: false,
                      showJustifyAlignment: false,
                      showLeftAlignment:false,
                      showLink: false,
                      showSubscript: false,
                      showSuperscript: false,

                      controller: AppCubit.get(context).quillController,
                      sharedConfigurations: const QuillSharedConfigurations(
                        locale: Locale('en'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 55,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                        scrollPhysics: BouncingScrollPhysics(),
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
