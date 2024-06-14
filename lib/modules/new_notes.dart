import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class NewNotesScreen extends StatelessWidget {
  const NewNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var notes = cubit.newNotes; // Use newTasks instead of fnotes
        var fnotes = cubit.filteredNotes;

        if (cubit.sortAscending) {
          notes.sort((a, b) => b['id'].compareTo(a['id']));
        } else {
          notes.sort((a, b) => a['id'].compareTo(b['id']));
        }

        return ConditionalBuilder(
          condition: notes.isEmpty,
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icon/icon_trans.png',opacity: const AlwaysStoppedAnimation(.3),),
              ],
            ),
          ),
          fallback: (context) => ConditionalBuilder(
            condition: fnotes.isEmpty,
            builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  cubit.tappedTitle = notes[index]['title'];
                  cubit.tappedTime = notes[index]['time'];
                  cubit.tappedDate = notes[index]['date'];
                  cubit.tappedId = notes[index]['id'];
                  cubit.changeBottomNavBarState(2);
                },
                child: buildNoteItem(
                  model: notes[index],
                  context: context,
                  index: 0,
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 1),
              itemCount: notes.length,
            ),
            fallback: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  cubit.tappedTitle = fnotes[index]['title'];
                  cubit.tappedTime = fnotes[index]['time'];
                  cubit.tappedDate = fnotes[index]['date'];
                  cubit.tappedId = fnotes[index]['id'];
                  cubit.changeBottomNavBarState(2);
                },
                child: buildNoteItem(
                  model: fnotes[index],
                  context: context,
                  index: 0,
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 1),
              itemCount: fnotes.length,
            ),
          ),
        );
      },
    );
  }
}
