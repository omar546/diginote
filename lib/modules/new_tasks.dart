import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/styles/styles.dart';


class NewNotesScreen extends StatelessWidget {
   NewNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        if (!AppCubit.get(context).sortAscending) {
          tasks.sort((a, b) => b['id'].compareTo(a['id'])); // Change 'date' to your sorting key
        } else {
          tasks.sort((a, b) => a['id'].compareTo(b['id'])); // Change 'date' to your sorting key
        }

        return ConditionalBuilder(
          condition: tasks.isEmpty,
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.hourglass_empty_rounded,
                  color: Styles.greyColor,
                  size: 40.0,
                ),
                Text(
                  'Take new Notes !!',
                  style: TextStyle(
                    color: Styles.greyColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          fallback: (context) => ListView.separated(
            itemBuilder: (context, index) => buildTaskItem(
              model: tasks[index],context: context,index: 0,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 1,
            ),
            itemCount: tasks.length,
          ),
        );
      },
    );
  }
}
