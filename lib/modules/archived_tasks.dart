import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/styles/styles.dart';


class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;
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
                  'archive some Tasks !!',
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
                model: tasks[index],context: context,index: 2
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