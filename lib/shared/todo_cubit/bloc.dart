import 'package:basics/modules/todoApp/archievedTasksScreen.dart';
import 'package:basics/modules/todoApp/doneTasksScreen.dart';
import 'package:basics/modules/todoApp/newTasksScreen.dart';
import 'package:basics/shared/todo_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());

  // variables
  int currentIndex = 0;
  bool isBottomShown = false;

  // ui variables
  IconData icon = Icons.edit;

  // lists
  final List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  final List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];

  List<Map> newTasks = [];

  List<Map> doneTasks = [];

  List<Map> archivedTasks = [];

  //database variables
  Database database;

  // methods
  static TodoCubit get(context) => BlocProvider.of(context);

  void changeIndex(index) {
    currentIndex = index;
    emit(ChangeBottomNavIndex());
  }

  void changeBottomSheetIcon(isShow, i) {
    isBottomShown = isShow;
    icon = i;
    emit(TodoChangeBottomSheetIcon());
  }

  void createDatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) {
        print("database created");
        database
            .execute(
                "create table todo (id integer primary key , title text , date text , time text , status text)")
            .then((value) {
          print("table created");
        }).catchError((error) {
          print("error when created table ${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print("database opened");
      },
    ).then((value) {
      database = value;
      emit(TodoCreateDatabaseState());
    });
  }

  void insertInDatabase(String title, String time, String date) {
    database.transaction((txn) {
      txn
          .rawInsert(
              'insert into todo (title , time , date , status) values("$title" ,"$time" , "$date" , "New" )')
          .then((value) {
        print("$value records inserted successfully");
        emit(TodoInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print("${error.toString()}");
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(TodoGetDatabaseState());
    database.rawQuery("select * from todo").then((value) {
      value.forEach((element) {
        if (element["status"] == "New")
          newTasks.add(element);
        else if (element["status"] == "Done")
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });

      emit(TodoGetDatabaseState());
    });
  }

  void updateDatabase({@required String status, @required int id}) {
    database.rawUpdate('UPDATE todo SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(TodoUpdateDatabaseState());
    });
  }

  void deleteDatabase({@required int id}) {
    database.rawDelete('DELETE FROM todo WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(TodoDeleteDatabaseState());
    });
  }
}
