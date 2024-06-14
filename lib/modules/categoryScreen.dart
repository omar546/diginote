import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:diginote/shared/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var categories = cubit.newCategories;
        
          categories.sort((a, b) => a['id'].compareTo(b['id']));

        return Column(mainAxisAlignment: MainAxisAlignment.end,
          children: [
          ConditionalBuilder(
          condition: categories.isEmpty,
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              ],
            ),
          ),fallback: (context) =>
            ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                    },
                    child: buildCategoryItem(
                      model: categories[index],
                      context: context,
                      index: 0,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(height: 1),
                  itemCount: categories.length,
                ),),
            const SizedBox(height: 1),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: (){},
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.55),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).inputDecorationTheme.prefixIconColor?.withOpacity(0.5) ?? Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Theme.of(context).inputDecorationTheme.suffixIconColor ?? Colors.black,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_circle_rounded,color: Styles.gumColor,)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ])),
            const SizedBox(height: 1),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: (){cubit.changeBottomNavBarState(0);},
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.55),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).inputDecorationTheme.prefixIconColor?.withOpacity(0.5) ?? Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Theme.of(context).inputDecorationTheme.suffixIconColor ?? Colors.black,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.arrow_circle_left,color: Styles.gumColor,)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50,)
                          ]),
                    ])),
          ],
        );
  }
  );
}}
