import 'package:camera/camera.dart';
// import 'package:delta_to_html/delta_to_html.dart';
import 'package:diginote/modules/loadingScreen.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:diginote/modules/CameraScreen.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/categoryScreen.dart';
import '../../modules/new_tasks.dart';
import '../../modules/showEditScreen.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  QuillController quillController = QuillController.basic();


  bool formaterC = false;
  bool formaterB = false;
  bool formaterA = false;
  var editformKey = GlobalKey<FormState>();
  var searchController = TextEditingController();
  var edittitleController = TextEditingController();
  String tappedTitle = "";
  String tappedTime = "";
  String tappedDate = "";
  var tappedId = 0;
  bool flashflag = false;
  String imagePath = "";
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  var currentIndex = 0;
  bool sortAscending = true; // Initial sorting order

  List<Map> filteredTasks = [];

  void filterTasks(String query) {
    // If the query is empty, show all tasks
    if (query.isEmpty) {
      filteredTasks = newTasks;
    } else {
      // Filter tasks based on the query
      filteredTasks = newTasks.where((task) {
        // Check if the task title contains the query (case-insensitive)
        return task['title'].toLowerCase().contains(query.toLowerCase());
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
    } catch (e) {}
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
    // open a bytestream
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://example-pre-reader.onrender.com/upload/");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) async {
      textfromimage = extractText(value);
      emit(CameraPictureTaken());
      print(textfromimage);
    });
    return textfromimage;
  }

  Future<void> pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      // Use the path of the picked image
      String imagePath = pickedImage.path;

      try {
        // FormData formData = FormData.fromMap({
        //   'file': await MultipartFile.fromFile(imagePath),
        // });

        // Use DioHelper.postData to upload the image
        changeBottomNavBarState(4);
        responseValue = await upload(File(imagePath));
      } catch (e) {
        print('Error uploading image: $e');
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

  List<String> titles = ['New Notes', 'Loading', 'Camera'];

  Future<void> changeBottomNavBarState(index) async {
    if (index > 4) {
      index = 0;
    }
    currentIndex = index;
    await cameraController?.setFlashMode(FlashMode.off);
    emit(AppChangeNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,ptitle TEXT, date TEXT,time TEXT)');
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
          'INSERT INTO tasks(title,ptitle, date, time) VALUES(?, ?, ?,?)',
          [
            '[{\"insert\":\"${title.replaceAll("'", "''").replaceAll('"', '""').replaceAll('\n', '\\n')}\\n\"}]',
            ptitle.replaceAll("'", "''").replaceAll('"', '""'),
            date,
            time
          ],
        ).then(
          (value) {
            filteredTasks = [];
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
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('Select * FROM tasks').then(
      (values) {
        values.forEach(
          (element) {
            //sego sort algo :)
            newTasks.add(element);
            newTasks.sort(
              (b, a) => a['id'].compareTo(b['id']),
            );
          },
        );
        emit(AppGetDatabaseState());
      },
    );
  }

  Future<void> updateDatabase({
    required int oldId,
    required String title,
    required String ptitle,
    required String date,
    required String time,
  }) async {
    // Insert a new row with updated data
    await database.transaction((txn) async {
      int newId = await txn.rawInsert(
        'INSERT INTO tasks(title,ptitle, date, time) VALUES(?, ?, ?,?)',
        [
          title.replaceAll("'", "''").replaceAll('\\"', '""'),
          ptitle.replaceAll("'", "''").replaceAll('"', '""'),
          date,
          time
        ],
      );

      // Delete the old row
      await txn.rawDelete('DELETE FROM tasks WHERE id = ?', [oldId]);
      filteredTasks = [];
      searchController.clear();
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

  void showPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Handle "Yes" action
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void hideFormatter() {
    formaterB = false;
    formaterA = false;
    formaterC = false;
    emit(FormattingState());
  }
  void selectAll() {
    final docLength = quillController.document.length;
    final selection = TextSelection(baseOffset: 0, extentOffset: docLength);
    quillController.updateSelection(selection,ChangeSource.local);
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
