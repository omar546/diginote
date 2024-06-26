import 'dart:convert';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/styles/styles.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  bool notSheeting = true;
  bool _doubleTapped = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If bottom sheet is not showing
        if (!_doubleTapped && notSheeting) {
          // On first back press, show a toast and set a flag
          showToast(message: 'Press again to quit', state: ToastStates.WARNING);
          _doubleTapped = true;

          // Start a timer for double tap interval
          Future.delayed(const Duration(seconds: 2), () {
            _doubleTapped = false; // Reset the flag after delay
          });
          return false; // Prevent back navigation
        } else {
          // On second back press, allow back navigation (exit the app)
          return true;
        }
      },
      child: BlocProvider(
        create: (context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is AppInsertDatabaseState &&
                AppCubit.get(context).currentIndex != 0) {
              Navigator.of(context).pop();
            }
            if (state is AppInsertDatabaseState &&
                AppCubit.get(context).isBottomSheetShown == true) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);

            return Scaffold(
              key: scaffoldKey,
              appBar: cubit.currentIndex == 4 || cubit.currentIndex == 3
                  ? AppBar(
                surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      title: Visibility(
                          visible: cubit.currentIndex != 4,
                          child: const Center(
                              child: Text("Categories",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Styles.gumColor)))))
                  : AppBar(
                surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      leadingWidth: cubit.currentIndex == 2
                          ? MediaQuery.sizeOf(context).width * 0.4
                          : MediaQuery.sizeOf(context).width * 0.25,
                      leading: cubit.isBottomSheetShown
                          ? null
                          : (cubit.currentIndex == 0)
                              ? Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        AppCubit.get(context)
                                            .toggleSortingOrder();
                                      },
                                      icon: const Icon(Icons.sort_rounded,
                                          size: 30),
                                      color: Styles.gumColor,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cubit.showSettingPrompt(context);
                                      },
                                      icon: const Icon(Icons.more_horiz_rounded,
                                          size: 30),
                                      color: Styles.gumColor,
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisSize:
                                      MainAxisSize.min, // Adjusted mainAxisSize
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        cubit.filteredNotes = [];
                                        cubit.changeBottomNavBarState(0);
                                      },
                                      icon: const Icon(Icons.arrow_back_rounded,
                                          size: 30),
                                      color: Styles.gumColor,
                                    ),
                                    Visibility(
                                      visible: cubit.currentIndex == 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          cubit.showCategoryUpdatePrompt(
                                              context);
                                        },
                                        child: Container(
                                          height: double.maxFinite,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.folder,
                                                size: 25,
                                                color: hexToColor(
                                                    cubit.tappedColor),
                                              ),
                                              const SizedBox(width: 2),
                                              Visibility(
                                                visible:
                                                    cubit.editorLocked == true,
                                                child: Text(
                                                  cubit.tappedCat.length > 13
                                                      ? '${cubit.tappedCat.substring(0, 11)}...'
                                                      : cubit.tappedCat,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      actions: (cubit.isBottomSheetShown ||
                              cubit.currentIndex > 0)
                          ? [
                              Visibility(
                                visible: !cubit.isBottomSheetShown &&
                                    cubit.currentIndex != 2 &&
                                    cubit.currentIndex != 3,
                                child: IconButton(
                                    onPressed: () async {
                                      cubit.toggleFlashLight();
                                    },
                                    icon: const Icon(
                                      Icons.flare_sharp,
                                      size: 30,
                                      color: Styles.gumColor,
                                    )),
                              ),
                              Visibility(
                                visible: !cubit.isBottomSheetShown &&
                                    cubit.currentIndex != 2 &&
                                    cubit.currentIndex != 3,
                                child: IconButton(
                                    onPressed: () async {
                                      if (cubit.currentIndex == 0) {
                                        cubit.changeBottomNavBarState(1);
                                      } else {
                                        await cubit.pickImageFromGallery();
                                        cubit.insertIntoDatabaseFromApi(
                                            title: cubit.responseValue
                                                .replaceAll(
                                                    '{"insert": ""},', ''),
                                            ptitle: Document.fromJson(
                                                    jsonDecode(
                                                        cubit.responseValue))
                                                .toPlainText(),
                                            time:
                                                TimeOfDay.now().format(context),
                                            date: DateFormat.yMMMd()
                                                .format(DateTime.now()));
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.image_search_rounded,
                                      size: 30,
                                      color: Styles.gumColor,
                                    )),
                              ),
                              Row(
                                children: [
                                  // Visibility(
                                  //   visible: !cubit.isBottomSheetShown &&
                                  //       cubit.currentIndex == 2 &&
                                  //       cubit.editorLocked == true,
                                  //   child: IconButton(
                                  //       onPressed: () {
                                  //
                                  //       },
                                  //       icon: const Icon(
                                  //         Icons.picture_as_pdf_outlined,
                                  //         size: 30,
                                  //         color: Styles.gumColor,
                                  //       )),
                                  // ),
                                  Visibility(
                                    visible: !cubit.isBottomSheetShown &&
                                        cubit.currentIndex == 2 &&
                                        !cubit.editorLocked,
                                    child: IconButton(
                                        onPressed: () {
                                          cubit.FormaterVisbilityC();
                                        },
                                        icon: Icon(
                                          Icons.content_paste_go_rounded,
                                          size: 30,
                                          color: cubit.formaterC
                                              ? Styles.greyColor
                                              : Styles.gumColor,
                                        )),
                                  ),
                                  Visibility(
                                    visible: !cubit.isBottomSheetShown &&
                                        cubit.currentIndex == 2 &&
                                        cubit.formaterC &&
                                        !cubit.editorLocked,
                                    child: IconButton(
                                        onPressed: () {
                                          cubit.selectAll();
                                        },
                                        icon: const Icon(
                                          Icons.select_all,
                                          size: 30,
                                          color: Styles.gumColor,
                                        )),
                                  ),
                                  Visibility(
                                    visible: !cubit.isBottomSheetShown &&
                                        cubit.currentIndex == 2 &&
                                        !cubit.editorLocked,
                                    child: IconButton(
                                        onPressed: () {
                                          cubit.FormaterVisbilityB();
                                        },
                                        icon: Icon(
                                          Icons.short_text_rounded,
                                          size: 30,
                                          color: cubit.formaterB
                                              ? Styles.greyColor
                                              : Styles.gumColor,
                                        )),
                                  ),
                                  Visibility(
                                    visible: !cubit.isBottomSheetShown &&
                                        cubit.currentIndex == 2 &&
                                        !cubit.editorLocked,
                                    child: IconButton(
                                        onPressed: () {
                                          cubit.FormaterVisbilityA();
                                        },
                                        icon: Icon(
                                          Icons.text_format_rounded,
                                          size: 30,
                                          color: cubit.formaterA
                                              ? Styles.greyColor
                                              : Styles.gumColor,
                                        )),
                                  ),
                                  Visibility(
                                    visible: !cubit.isBottomSheetShown &&
                                        cubit.currentIndex == 2 &&
                                        !cubit.editorLocked,
                                    child: IconButton(
                                        onPressed: () {
                                          if (true
                                              // cubit.edittitleController.text !=
                                              //         cubit.tappedTitle &&
                                              //     cubit.editformKey.currentState!
                                              //         .validate()
                                              ) {
                                            cubit.updateDatabase(
                                                category: cubit.tappedCat,
                                                color: cubit.tappedColor,
                                                time: TimeOfDay.now()
                                                    .format(context),
                                                date: DateFormat.yMMMd()
                                                    .format(DateTime.now()),
                                                title: jsonEncode(cubit
                                                    .quillController.document
                                                    .toDelta()
                                                    .toJson()),
                                                ptitle: cubit
                                                    .quillController.document
                                                    .toPlainText());
                                          }
                                          // cubit.changeBottomNavBarState(0);
                                          cubit.hideFormatter();
                                        },
                                        icon: const Icon(
                                          Icons.check_rounded,
                                          size: 30,
                                          color: Styles.gumColor,
                                        )),
                                  ),
                                  Visibility(
                                    visible: !cubit.isBottomSheetShown &&
                                        cubit.currentIndex == 2 &&
                                        cubit.editorLocked,
                                    child: IconButton(
                                        onPressed: () {
                                          cubit.showEditor();
                                        },
                                        icon: const Icon(
                                          Icons.mode_edit_outlined,
                                          size: 30,
                                          color: Styles.gumColor,
                                        )),
                                  ),
                                ],
                              )
                            ]
                          : [
                              GestureDetector(
                                onLongPress: () {
                                  cubit.changeBottomNavBarState(3);
                                },
                                child: IconButton(
                                  onPressed: () {
                                    cubit.showCategoryFilterPrompt(context);
                                  },
                                  icon: Icon(
                                    (cubit.notFiltered)
                                        ? Icons.category_outlined
                                        : Icons.filter_alt_off,
                                    size: 30,
                                  ),

                                  color: (cubit.notFiltered)?Styles.gumColor:Styles.greyColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (cubit.isBottomSheetShown) {
                                    if (formKey.currentState!.validate()) {
                                      cubit
                                          .insertIntoDatabase(
                                        title: titleController.text,
                                        ptitle: titleController.text,
                                        // date: dateController.text,

                                        date: DateFormat.yMMMd()
                                            .format(DateTime.now()),
                                        // time: timeController.text,
                                        time: TimeOfDay.now().format(context),
                                      )
                                          .then(
                                        (value) {
                                          titleController.text = '';
                                          dateController.text = '';
                                          timeController.text = '';
                                        },
                                      ).catchError(
                                        (error) {},
                                      );
                                    }
                                  } else {
                                    notSheeting = false;
                                    scaffoldKey.currentState!
                                        .showBottomSheet(
                                          (context) => Container(
                                            height: double.infinity,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 3,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Styles.greyColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                  ),
                                                  const SizedBox(
                                                      height: 35.0,
                                                      width: double.infinity),
                                                  buildTextField(
                                                    context: context,
                                                    labelText: 'Title',
                                                    controller: titleController,
                                                    validate: (String? value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please type a title';
                                                      }
                                                      return null; // Return null to indicate the input is valid
                                                    },
                                                    type:
                                                        TextInputType.multiline,
                                                  ),
                                                  const SizedBox(
                                                      height: 15.0,
                                                      width: double.infinity),
                                                  const SizedBox(
                                                      height: 5.0,
                                                      width: double.infinity),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .closed
                                        .then(
                                      (value) {
                                        notSheeting = true;
                                        cubit.changeAddTaskIcon(false);
                                      },
                                    ).catchError(
                                      (error) {},
                                    );

                                    cubit.changeAddTaskIcon(true);
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_circle_rounded,
                                  size: 30,
                                ),
                                color: Styles.gumColor,
                              )
                            ],
                      title: (cubit.isBottomSheetShown ||
                              (cubit.currentIndex > 0))
                          ? null
                          : Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  25.0,
                                ),
                                color: Theme.of(context)
                                        .inputDecorationTheme
                                        .suffixIconColor ??
                                    Colors.black, // Text color for dark theme,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
                                      fontSize: 13),
                                  controller: cubit.searchController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: Theme.of(context)
                                              .inputDecorationTheme
                                              .prefixIconColor
                                              ?.withOpacity(0.5) ??
                                          Colors.black,
                                    ),
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                              .inputDecorationTheme
                                              .prefixIconColor
                                              ?.withOpacity(0.5) ??
                                          Colors.black,
                                      fontSize: 13,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 8),
                                  ),
                                  onChanged: (query) {
                                    // Perform filtering whenever the text changes
                                    cubit.searchFilterNotes(query);
                                  },
                                ),
                              ),
                            ),
                    ),
              body: ConditionalBuilder(
                condition:
                    state is AppGetDatabaseLoadingState, //cubit.tasks.isEmpty,
                builder: ((context) =>
                    const Center(child: CircularProgressIndicator())),
                fallback: ((context) => cubit.screens[cubit.currentIndex]),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: (cubit.isBottomSheetShown)
                    ? MainAxisAlignment.end // Text color for light theme
                    : MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Visibility(
                        visible: (!(cubit.isBottomSheetShown) &&
                            (cubit.currentIndex != 4 &&
                                cubit.currentIndex != 2 &&
                                cubit.currentIndex != 3)),
                        child: FloatingActionButton(
                          shape: const CircleBorder(),
                          backgroundColor: Styles.gumColor,
                          onPressed: () async {
                            if (cubit.currentIndex == 0) {
                              cubit.changeBottomNavBarState(1);
                            } else {
                              await cubit.take();
                              cubit.insertIntoDatabaseFromApi(
                                  title: cubit.responseValue,
                                  ptitle: Document.fromJson(
                                          jsonDecode(cubit.responseValue))
                                      .toPlainText(),
                                  time: TimeOfDay.now().format(context),
                                  date: DateFormat.yMMMd()
                                      .format(DateTime.now()));
                            }
                          },
                          child: const Icon(
                            Icons.camera,
                            size: 55,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Visibility(
                    visible: (cubit.isBottomSheetShown),
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: const Icon(
                        Icons.check_circle,
                        color: Styles.gumColor,
                        size: 40,
                      ),
                      onPressed: () {
                        if (cubit.isBottomSheetShown) {
                          if (formKey.currentState!.validate()) {
                            cubit
                                .insertIntoDatabase(
                              title: titleController.text,
                              ptitle: titleController.text,
                              date: DateFormat.yMMMd().format(DateTime.now()),
                              time: TimeOfDay.now().format(context),
                            )
                                .then(
                              (value) {
                                titleController.text = '';
                                dateController.text = '';
                                timeController.text = '';
                                // cubit.changeBottomNavBarState(0);
                              },
                            ).catchError(
                              (error) {},
                            );
                          }
                        } else {
                          scaffoldKey.currentState!
                              .showBottomSheet(
                                enableDrag: cubit.currentIndex < 2,
                                (context) => Container(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Container(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                              height: 35.0,
                                              width: double.infinity),
                                          buildTextField(
                                            context: context,
                                            labelText: 'Title',
                                            controller: titleController,
                                            prefix: Icons.title_rounded,
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
                              )
                              .closed
                              .then(
                            (value) {
                              cubit.changeAddTaskIcon(false);
                            },
                          ).catchError(
                            (error) {},
                          );

                          cubit.changeAddTaskIcon(true);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
//tasks
