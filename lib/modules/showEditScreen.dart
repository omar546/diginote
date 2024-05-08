import 'package:diginote/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';

import '../shared/components/components.dart';

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
    return Scaffold(
      body: Container(
        color:
        Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          color:
          Theme.of(context).scaffoldBackgroundColor,
          child: Form(
            key: AppCubit.get(context).editformKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppCubit.get(context).tappedDate,style: const TextStyle(color: Colors.grey,fontSize: 12),),
                    const SizedBox(width: 10,),
                    Text(AppCubit.get(context).tappedTime,style: const TextStyle(color: Colors.grey,fontSize: 12),),
                  ],),
                const SizedBox(
                    height: 35.0,
                    width: double.infinity),
                buildTextField(
                  context: context,
                  labelText: 'Title',
                  controller: AppCubit.get(context).edittitleController,
                  validate: (String? value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please type a title';
                    }
                    return null; // Return null to indicate the input is valid
                  },
                  type: TextInputType.multiline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
