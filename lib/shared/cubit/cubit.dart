import 'package:camera/camera.dart';
import 'package:diginote/modules/loadingScreen.dart';
import 'package:diginote/modules/login/login_screen.dart';
import 'package:diginote/shared/styles/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:diginote/modules/cameraScreen.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/categoryScreen.dart';
import '../../modules/new_notes.dart';
import '../../modules/showEditScreen.dart';
import '../components/components.dart';
import '../network/remote/dio_helper.dart';
import '../styles/Themes.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  QuillController quillController = QuillController.basic();

  bool editorLocked = true;
  bool formaterC = false;
  bool formaterB = false;
  bool formaterA = false;
  var editformKey = GlobalKey<FormState>();
  var searchController = TextEditingController();
  var edittitleController = TextEditingController();
  var addCategoryController = TextEditingController();
  String tappedTitle = "";
  String tappedTime = "";
  String tappedDate = "";
  String tappedCat = "";
  String tappedColor = "";
  var tappedId = 0;
  bool flashflag = false;
  String imagePath = "";
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  var currentIndex = 0;
  bool sortAscending = true; // Initial sorting order

  List<Map> filteredNotes = [];
  bool notFiltered = true;

  void searchFilterNotes(String query) {
    // If the query is empty, show all tasks
    if (query.isEmpty) {
      filteredNotes = newNotes;
    } else {
      // Filter tasks based on the query
      filteredNotes = newNotes.where((note) {
        // Check if the task title contains the query (case-insensitive)
        return note['title'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    emit(AppFilterTasksState());
  }

  void catFilterNotes(String query) {
    // If the query is empty, show all tasks
    if (query.isEmpty) {
      filteredNotes = newNotes;
      notFiltered =true;
    } else {
      // Filter tasks based on the query
      notFiltered =false;
      filteredNotes = newNotes.where((note) {
        // Check if the task title contains the query (case-insensitive)
        return note['category'] == (query);
      }).toList();
    }
    emit(AppFilterTasksState());
  }

  List<CameraDescription>? cameras;
  CameraController? cameraController;
  bool isFlashOn = false;

  // Initialize camera
  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      cameraController = CameraController(cameras![0], ResolutionPreset.max);
      await cameraController!.initialize();
      cameraController?.setFlashMode(FlashMode.off);
      emit(AppCameraInitializedState());
    }
  }

  void disposeCamera() {
    cameraController?.dispose();
    emit(AppCameraDisposedState());
  }

  Future<void> toggleFlashLight() async {
    try {
      if (isFlashOn) {
        await cameraController?.setFlashMode(FlashMode.off);
      } else {
        await cameraController?.setFlashMode(FlashMode.torch);
      }

      isFlashOn = !isFlashOn;
      emit(AppCameraFlashState());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  String textfromimage = "";
  String responseValue = "";
  String extractText(String jsonString) {
    // Parse the JSON string
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Extract the value associated with the "text" key
    String text = jsonMap['text'];

    return text;
  }

  Future<String> upload(File imageFile) async {
    // Open a bytestream
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // Get file length
    var length = await imageFile.length();

    // String to URI
    var uri = Uri.parse("http://3.75.171.189/upload/");

    // Create multipart request
    var request = http.MultipartRequest("POST", uri);

    // Multipart that takes file
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // Add file to multipart
    request.files.add(multipartFile);

    // Send
    var response = await request.send();
    if (kDebugMode) {
      print(response.statusCode);
    }

    // Listen for response and await the response stream transformation
    var responseString = await response.stream.transform(utf8.decoder).join();
    textfromimage = extractText(responseString);
    emit(CameraPictureTaken());
    if (kDebugMode) {
      print("${textfromimage} upload");
    }
    return textfromimage;
  }


  Future<void> pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      String imagePath = pickedImage.path;

      try {
        changeBottomNavBarState(4);
        responseValue = await upload(File(imagePath));
      } catch (e) {
        if (kDebugMode) {
          print('Error uploading image: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('User canceled image selection');
      }
    }
  }

  Future<void> take() async {
    final image = await cameraController?.takePicture();
    imagePath = image!.path;
    try {
      // Take picture using camera controller

      // Emit a new state with the image path
      changeBottomNavBarState(4);

      // Await the upload operation and set responseValue
      responseValue = await upload(File(imagePath));
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        print('Error taking picture: $e');
      }
      emit(CameraError());
    }
  }

  // Method to toggle sorting order
  void toggleSortingOrder() {
    sortAscending = !sortAscending;
    // Emit a new state indicating that sorting order has changed
    emit(ToggleSortingOrderState());
  }

  List<Widget> screens = [
    const NewNotesScreen(),
    const CameraScreen(),
    const ShowEditScreen(),
    const CategoryScreen(),
    const LoadingScreen(),
  ];

  Future<void> changeBottomNavBarState(index) async {
    if (index > 4) {
      index = 0;
    }
    currentIndex = index;
    filteredNotes = [];
    notFiltered=true;
    await cameraController?.setFlashMode(FlashMode.off);
    emit(AppChangeNavBarState());
  }

  late Database database;
  List<Map> newNotes = [];
  List<Map> newCategories = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,ptitle TEXT, date TEXT,time TEXT,category TEXT,color TEXT)');
        await db.execute(
            'CREATE TABLE categories (id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT,color TEXT)');
        await db.execute(
            'INSERT INTO categories(category,color) VALUES("uncategorized", "#d2d2d2")');
      },
      onOpen: (database) {
        getFromDatabase(database);
      },
    ).then(
      (value) {
        database = value;
        emit(AppCreateDatabaseState());
      },
    );
  }

  Future insertIntoDatabase({
    required String title,
    required String ptitle,
    required String date,
    required String time,
  }) {
    return database.transaction(
      (Transaction txn) async {
        txn.rawInsert(
          'INSERT INTO tasks(title,ptitle, date, time,category,color) VALUES(?, ?, ?,?,"uncategorized","#d2d2d2")',
          [
            '[{\"insert\":\"${title.replaceAll("'", "''").replaceAll('"', '""').replaceAll('\n', '\\n')}\\n\"}]',
            ptitle.replaceAll("'", "''").replaceAll('"', '""'),
            date,
            time
          ],
        ).then(
          (value) {
            filteredNotes = [];
            notFiltered=true;
            searchController.clear();
            emit(AppInsertDatabaseState());
            changeBottomNavBarState(0);
            getFromDatabase(database);
          },
        );
      },
    );
  }

  Future insertIntoDatabaseFromApi({
    required String title,
    required String ptitle,
    required String date,
    required String time,
  }) {
    return database.transaction(
          (Transaction txn) async {
        txn.rawInsert(
          'INSERT INTO tasks(title,ptitle, date, time,category,color) VALUES(?, ?, ?,?,"uncategorized","#d2d2d2")',
          [
            title,
            ptitle,
            date,
            time
          ],
        ).then(
              (value) {
            filteredNotes = [];
            notFiltered=true;
            searchController.clear();
            emit(AppInsertDatabaseState());
            changeBottomNavBarState(0);
            getFromDatabase(database);
          },
        );
      },
    );
  }

  void getFromDatabase(database) {
    newNotes = [];
    newCategories = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('Select * FROM tasks').then(
      (values) {
        values.forEach(
          (element) {
            //sego sort algo :)
            newNotes.add(element);
            newNotes.sort(
              (b, a) => a['id'].compareTo(b['id']),
            );
          },
        );
        emit(AppGetDatabaseState());
      },
    );
    database.rawQuery('Select * FROM categories').then(
      (values) {
        values.forEach(
          (element) {
            //sego sort algo :)
            newCategories.add(element);
            newCategories.sort(
              (b, a) => a['id'].compareTo(b['id']),
            );
          },
        );
        emit(AppGetDatabaseState());
      },
    );
  }

  Future<void> updateDatabase({
    required String title,
    required String ptitle,
    required String date,
    required String time,
    required String category,
    required String color,
  }) async {
    // Insert a new row with updated data
    await database.transaction((txn) async {
      int newId = await txn.rawInsert(
        'INSERT INTO tasks(title,ptitle, date, time,category,color) VALUES(?, ?, ?,?,?,?)',
        [
          title.replaceAll("'", "''").replaceAll('\\"', '""'),
          ptitle.replaceAll("'", "''").replaceAll('"', '""'),
          date,
          time,
          category,
          color
        ],
      );

      // Delete the old row
      await txn.rawDelete('DELETE FROM tasks WHERE id = ?', [tappedId]);
      filteredNotes = [];
      notFiltered=true;
      searchController.clear();
      tappedId = newId;
      getFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });

    // Return null to satisfy the Future<void> return type
    return;
  }

  void deleteDatabase({required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then(
      (value) {
        getFromDatabase(database);
        emit(AppDeleteDatabaseState());
      },
    );
  }
  void deleteAllByCategory({required int id,required String cat,required BuildContext context}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titleTextStyle: const TextStyle(color: Styles.gumColor),
            backgroundColor: Theme.of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.95),
            title: const Text('Delete all notes under this category?'),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.gumColor,
                        foregroundColor: Styles.whiteColor),
                    onPressed: () {
                      database.delete('tasks',where: 'category = ?',whereArgs:[cat]);
                      database.rawDelete('DELETE FROM categories WHERE id = ?', [id]).then(
                            (value) {
                              if(cat=='uncategorized'){
                                database.rawInsert('INSERT INTO categories(category,color) VALUES("uncategorized", "#d2d2d2")');
                              }
                          getFromDatabase(database);
                          emit(AppDeleteDatabaseState());

                        },
                      ).then((v){
                        Navigator.of(context).pop();
                      });}
                    ,
                    child: const Text('Yes!')),
              )
            ],
          );
        });
  }

  void deleteCategory({required int id,required String cat}) {
    database.update('tasks',{'category':'uncategorized','color':'#d2d2d2'},where: 'category = ?',whereArgs:[cat]);
    database.rawDelete('DELETE FROM categories WHERE id = ?', [id]).then(
      (value) {
        getFromDatabase(database);
        emit(AppDeleteDatabaseState());
      },
    );
  }

  var isBottomSheetShown = false;

  void changeAddTaskIcon(
    bool showing,
  ) {
    isBottomSheetShown = showing;
    emit(AppChangeBottomSheetState());
  }

  void FormaterVisbilityA() {
    formaterA = !formaterA;
    if (formaterA == true) {
      formaterB = false;
    }
    emit(FormattingState());
  }

  void FormaterVisbilityB() {
    formaterB = !formaterB;
    if (formaterB == true) {
      formaterA = false;
    }
    emit(FormattingState());
  }

  void FormaterVisbilityC() {
    formaterC = !formaterC;
    emit(FormattingState());
  }

  void showSettingPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            'Settings',
            style: TextStyle(color: Styles.gumColor),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: "Ping",
                onPressed: () {
                  Navigator.of(context).pop();
                  DioHelper.getData(url: 'test').then((value) {
                    showToast(
                        message: value.data['text'],
                        state: ToastStates.SUCCESS);
                  }).catchError((error) {
                    showToast(message: 'Offline', state: ToastStates.ERROR);
                    if (kDebugMode) {
                      print(error);
                    }
                  });
                },
                icon: const Icon(
                  Icons.network_check,
                  color: Styles.gumColor,
                ),
              ),
              IconButton(
                tooltip: "Theme",
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.mode_night_rounded,
                  color: Styles.gumColor,
                ),
              ),
              IconButton(
                tooltip: "Logout",
                onPressed: () {
                  navigateAndFinish(context, LoginScreen());
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Styles.gumColor,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  var selectedCat;
  var selectedColor;

  void showCategoryUpdatePrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            scrollable: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Row(
              children: [
                Text(
                  'Categories',
                  style: TextStyle(color: Styles.gumColor),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.swipe,
                  color: Styles.gumColor,
                  size: 20,
                )
              ],
            ),
            content: newCategories.length == 1
                ? const Center(
                    child: Text(
                      'Long press category Icon on home to add categories',
                      textAlign: TextAlign.center,
                      maxLines: 5,
                    ),
                  )
                : SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 700),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: newCategories.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Long press category Icon on home to add categories',
                                    textAlign: TextAlign.center,
                                    maxLines: 5,
                                  ),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.1,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: newCategories.length,
                                    itemBuilder: (context, index) {
                                      var category = newCategories[index];
                                      return GestureDetector(
                                        onTap: () {
                                          tappedCat = category['category'];
                                          tappedColor = category['color'];

                                          updateDatabase(
                                              category: category['category'],
                                              color: category['color'],
                                              time: TimeOfDay.now()
                                                  .format(context),
                                              date: DateFormat.yMMMd()
                                                  .format(DateTime.now()),
                                              title: jsonEncode(quillController
                                                  .document
                                                  .toDelta()
                                                  .toJson()),
                                              ptitle: quillController.document
                                                  .toPlainText());
                                          Navigator.of(context).pop();
                                        },
                                        child: buildMenuCategoryItem(
                                          model: category,
                                          context: context,
                                          index: index,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ))));
      },
    );
  }

  void showCategoryFilterPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            scrollable: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Row(
              children: [
                Text(
                  'Categories',
                  style: TextStyle(color: Styles.gumColor),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.swipe,
                  color: Styles.gumColor,
                  size: 20,
                )
              ],
            ),
            content: newCategories.length == 1
                ? const Center(
                    child: Text(
                      'Long press category Icon on home to add categories',
                      textAlign: TextAlign.center,
                      maxLines: 5,
                    ),
                  )
                : SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 700),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: newCategories.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Long press category Icon on home to add categories',
                                    textAlign: TextAlign.center,
                                    maxLines: 5,
                                  ),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.1,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: newCategories.length,
                                    itemBuilder: (context, index) {
                                      var category = newCategories[index];
                                      return GestureDetector(
                                        onTap: () {
                                          catFilterNotes(
                                              category['category']);
                                          Navigator.of(context).pop();
                                        },
                                        child: buildMenuCategoryItem(
                                          model: category,
                                          context: context,
                                          index: index,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ))));
      },
    );
  }

  void showCategoryPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
          title: const Text(
            'Add Category',
            style: TextStyle(color: Styles.gumColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customForm(
                context: context,
                controller: addCategoryController,
                type: TextInputType.text,
                label: 'Name',
                suffix: Icons.color_lens_rounded,
                suffixPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titleTextStyle: const TextStyle(color: Styles.gumColor),
                          backgroundColor: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.95),
                          title: const Text('Pick a color'),
                          content: SingleChildScrollView(
                            child: ClipRect(
                              child: Align(
                                alignment: Alignment.topCenter,
                                heightFactor: 0.85,
                                child: ColorPicker(
                                    paletteType: PaletteType.hueWheel,
                                    pickerColor: catColor,
                                    onColorChanged: changeColor),
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Styles.gumColor,
                                    foregroundColor: Styles.whiteColor),
                                onPressed: () {
                                  insertIntoCategories(
                                      name: addCategoryController.text,
                                      color: catColor.toHexString());
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Ok!'))
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void showCategoryValueUpdatePrompt({required int id,required String cat,required BuildContext context}) {
    addCategoryController.text=cat;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
          title: const Text(
            'Edit Category',
            style: TextStyle(color: Styles.gumColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customForm(
                context: context,
                controller: addCategoryController,
                type: TextInputType.text,
                label: 'Name',
                suffix: Icons.color_lens_rounded,
                suffixPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titleTextStyle: const TextStyle(color: Styles.gumColor),
                          backgroundColor: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.95),
                          title: const Text('Pick a color'),
                          content: SingleChildScrollView(
                            child: ClipRect(
                              child: Align(
                                alignment: Alignment.topCenter,
                                heightFactor: 0.85,
                                child: ColorPicker(
                                    paletteType: PaletteType.hueWheel,
                                    pickerColor: catColor,
                                    onColorChanged: changeColor),
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Styles.gumColor,
                                    foregroundColor: Styles.whiteColor),
                                onPressed: () {
                                  database.update('tasks', {'category':addCategoryController.text,'color':catColor.toHexString()},where: 'category = ?',whereArgs: [cat]);
                                  database.update('categories', {'category':addCategoryController.text,'color':catColor.toHexString()},where: 'id = ?',whereArgs: [id]);
                                  emit(AppInsertDatabaseState());
                                  getFromDatabase(database);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Ok!'))
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Color catColor = Styles.greyColor;
  void changeColor(Color color) {
    catColor = color;
    emit(CategoryColor());
  }

  Future insertIntoCategories({
    required String name,
    required String color,
  }) {
    return database.transaction(
      (Transaction txn) async {
        txn.rawInsert(
          'INSERT INTO categories(category,color) VALUES(?, ?)',
          [name, color],
        ).then(
          (value) {
            emit(AppInsertDatabaseState());
            getFromDatabase(database);
          },
        );
      },
    );
  }

  void hideFormatter() {
    formaterB = false;
    formaterA = false;
    formaterC = false;
    editorLocked = true;
    quillController.readOnly = editorLocked;
    emit(FormattingState());
  }

  void showEditor() {
    editorLocked = false;
    quillController.readOnly = editorLocked;
    emit(FormattingState());
  }

  void selectAll() {
    final docLength = quillController.document.length;
    final selection = TextSelection(baseOffset: 0, extentOffset: docLength);
    quillController.updateSelection(selection, ChangeSource.local);
  }
  // Future<void> export() async {
  //   try {
  //     final htmlString = await DeltaToHTML.encodeJson(AppCubit.get(context).quillController.document.toDelta().toJson());
  //     var targetPath = "/storage/emulated/0/Download";
  //     var targetFileName = "example_pdf_file";
  //
  //     // Show loading indicator while generating PDF
  //
  //
  //     var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
  //       htmlString,
  //       targetPath,
  //       targetFileName,
  //     );
  //     changeBottomNavBarState(0);
  //
  //
  //     // Handle successful PDF generation (e.g., show a success message)
  //   } on Exception catch (e) {
  //     // Handle the exception (e.g., show a snackbar to the user)
  //     if (kDebugMode) {
  //       print("Error generating PDF: $e");
  //     }
  //   }
  // }
}
