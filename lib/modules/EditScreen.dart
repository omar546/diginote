import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/styles/styles.dart';

class EditScreen extends StatelessWidget {
  EditScreen(BuildContext context, {Key? key}) : super(key: key);
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AppCubit cubit = BlocProvider.of<AppCubit>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_rounded, size: 30,),
            color: Styles.gumColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                cubit.insertIntoDatabase(
                  title: titleController.text.replaceAll("'", "''").replaceAll('"', '""'),
                  date: DateFormat.yMMMd().format(DateTime.now()),
                  time: TimeOfDay.now().format(context),
                ).then(
                      (value) {
                    titleController.text = '';
                    dateController.text = '';
                    timeController.text = '';
                  },
                ).catchError(
                      (error) {},
                );
              }
            },
            icon: const Icon(Icons.check_circle, size: 30,),
            color: Styles.gumColor,
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 35.0, width: double.infinity),
                buildTextField(
                  context: context,
                  labelText: 'Title',
                  controller: titleController,
                  prefix: Icons.title_rounded,
                  validate: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please type a title';
                    }
                    return null; // Return null to indicate the input is valid
                  },
                  type: TextInputType.multiline,
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
