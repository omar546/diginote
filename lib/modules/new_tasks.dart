import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/styles/styles.dart';

class NewNotesScreen extends StatelessWidget {
  const NewNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var tasks = cubit.newTasks; // Use newTasks instead of ftasks
        var ftasks = cubit.filteredTasks;

        if (cubit.sortAscending) {
          tasks.sort((a, b) => b['id'].compareTo(a['id']));
        } else {
          tasks.sort((a, b) => a['id'].compareTo(b['id']));
        }

        return ConditionalBuilder(
          condition: tasks.isEmpty,
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icon/icon_trans.png',opacity: const AlwaysStoppedAnimation(.09)),
              ],
            ),
          ),
          fallback: (context) => ConditionalBuilder(
            condition: ftasks.isEmpty,
            builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  cubit.tappedTitle = tasks[index]['title'];
                  cubit.tappedTime = tasks[index]['time'];
                  cubit.tappedDate = tasks[index]['date'];
                  cubit.tappedId = tasks[index]['id'];
                  cubit.changeBottomNavBarState(2);
                },
                child: buildTaskItem(
                  model: tasks[index],
                  context: context,
                  index: 0,
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 1),
              itemCount: tasks.length,
            ),
            fallback: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  cubit.tappedTitle = ftasks[index]['title'];
                  cubit.tappedTime = ftasks[index]['time'];
                  cubit.tappedDate = ftasks[index]['date'];
                  cubit.tappedId = ftasks[index]['id'];
                  cubit.changeBottomNavBarState(2);
                },
                child: buildTaskItem(
                  model: ftasks[index],
                  context: context,
                  index: 0,
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 1),
              itemCount: ftasks.length,
            ),
          ),
        );
      },
    );
  }
}
