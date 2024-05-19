import 'dart:convert';

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
     AppCubit.get(context).hideFormatter();
     // Set the initial title to the edittitleController when the widget initializes
     // AppCubit.get(context).quillController = QuillController(document: Document()..insert(0, AppCubit.get(context).tappedTitle), selection: TextSelection.collapsed(offset:AppCubit.get(context).tappedTitle.length));
     AppCubit.get(context).quillController = QuillController(
       document: 
       Document.fromJson(
           jsonDecode(
               AppCubit.get(context).tappedTitle.replaceAll("''", "'").replaceAll('""', '\\"')
           )),
       selection: const TextSelection.collapsed(offset: 0),
     );
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
                  visible: AppCubit.get(context).formaterC,
                  child: QuillToolbar.simple(
                    configurations: QuillSimpleToolbarConfigurations(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor,
                      showRedo: false,
                      showUndo: false,
                      multiRowsDisplay: false,
                      showClearFormat: false,
                      showLeftAlignment: false,
                      showListBullets: false,
                      showJustifyAlignment: false,
                      showIndent: false,
                      showCenterAlignment: false,
                      showLink: false,
                      showListNumbers: false,
                      showListCheck: false,
                      showSuperscript: false,
                      showSubscript: false,
                      showBoldButton: false,
                      showItalicButton: false,
                      showUnderLineButton: false,
                      showDividers: false,
                      showRightAlignment:false,
                      showCodeBlock: false,
                      showInlineCode: false,
                      showHeaderStyle: false,
                      showAlignmentButtons: true,
                      showQuote: false,
                      showStrikeThrough: false,
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
                SizedBox(height: 20,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                        enableSelectionToolbar: false,
                        scrollPhysics: BouncingScrollPhysics(),
                        controller: AppCubit.get(context).quillController,
                        sharedConfigurations: const QuillSharedConfigurations(
                          locale: Locale('en'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: AppCubit.get(context).formaterB,
                  child: QuillToolbar.simple(
                    configurations: QuillSimpleToolbarConfigurations(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor,
                      multiRowsDisplay: false,
                      showSubscript: false,
                      showSuperscript: false,
                      showQuote: false,
                      showBoldButton: false,
                      showItalicButton: false,
                      showUnderLineButton: false,
                      showDividers: false,
                      showClipboardPaste: false,
                      showClipboardCut: false,
                      showClipboardCopy: false,
                      showRightAlignment:false,
                      showCodeBlock: false,
                      showInlineCode: false,
                      showHeaderStyle: false,
                      showAlignmentButtons: true,
                      showFontFamily: false,
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
                      color: Theme.of(context)
                          .scaffoldBackgroundColor,
                      multiRowsDisplay: false,
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
                      showFontSize: false,
                      controller: AppCubit.get(context).quillController,
                      sharedConfigurations: const QuillSharedConfigurations(
                        locale: Locale('en'),
                      ),
                    ),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  });
}
}
