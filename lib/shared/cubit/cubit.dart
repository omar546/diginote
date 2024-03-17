import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../modules/archived_tasks.dart';
import '../../modules/done_tasks.dart';
import '../../modules/new_tasks.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  var currentIndex = 0;


  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeBottomNavBarState(index) {
    currentIndex = index;
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
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT,time TEXT ,status TEXT)');
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
    required String date,
    required String time,
  }) {
    return database.transaction(
      (Transaction txn) async {
        txn
            .rawInsert(
          'INSERT INTO tasks(title, date, time,status) VALUES("$title",  "$date", "$time", "new")',
        )
            .then(
          (value) {
            emit(AppInsertDatabaseState());
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
            if (element['status'] == 'new') {
              newTasks.add(element);
              newTasks.sort(
                (b, a) => a['id'].compareTo(b['id']),
              );
            } else if (element['status'] == 'done') {
              doneTasks.add(element);
              doneTasks.sort(
                (b, a) => a['id'].compareTo(b['id']),
              );
            } else {
              archivedTasks.add(element);
              archivedTasks.sort(
                (b, a) => a['id'].compareTo(b['id']),
              );
            }
          },
        );
        emit(AppGetDatabaseState());
      },
    );
  }

  void updateDatabase({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then(
      (value) {
        getFromDatabase(database);
        emit(AppUpdateDatabaseState());
      },
    );
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
  var fabIcon = Icons.edit;

  void changeAddTaskIcon(
    bool showing,
    IconData icon,
  ) {
    isBottomSheetShown = showing;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
