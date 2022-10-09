import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/todo_archived_tasks/archived_tasks.dart';
import 'package:flutter_app/modules/todo_done_tasks/done_tasks.dart';
import 'package:flutter_app/modules/todo_new_tasks/new_tasks.dart';
import 'package:flutter_app/shared/cubit/todo_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit() : super(ToDoInitialState());

  static ToDoCubit get(BuildContext context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = <Widget>[
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  // appbar text
  List<String> appBarTitle = <String>[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ToDoChangeCurrentIndexState());
  }

  bool isShowBottomSheet = false;
  void bottomSheetState(bool isShow) {
    isShowBottomSheet = isShow;
    emit(ToDoChangeBottomSheetState());
  }

  ////----------------------
  Database? database, db;
  List<Map> newRecords = [];
  List<Map> archivedRecords = [];
  List<Map> doneRecords = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database db, int version) {
        print('database created');
        db
            .execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)',
        )
            .then(
          (value) {
            print('Table is created');
          },
        ).catchError(
          (onError) {
            print('the error is $onError');
          },
        );
      },
      onOpen: (Database db) async {
        getRecord(db);
        print('in onOpen?!!!');
      },
    ).then((value) {
      database = value;
      emit(ToDoCreateDatabaseState());
    });
  }

  Future<dynamic> insertRecord({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database!.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        emit(ToDoInsertDatabaseState());

        getRecord(database!);
        print('$value data inserted successfully');
      }).catchError((onError) {
        print('the error is $onError');
      });
    });
  }

  void getRecord(Database db) {
    newRecords = [];
    doneRecords = [];
    archivedRecords = [];
    emit(ToDoLoadingState());
    db.rawQuery('SELECT * FROM tasks WHERE status = ?', ["new"]).then((value) {
      newRecords = value;
      emit(ToDoGetDatabaseState());
    });
    db.rawQuery('SELECT * FROM tasks WHERE status = ?', ["done"]).then((value) {
      doneRecords = value;
      emit(ToDoGetDatabaseState());
    });
    db.rawQuery('SELECT * FROM tasks WHERE status = ?', ["archive"]).then(
        (value) {
      archivedRecords = value;
      emit(ToDoGetDatabaseState());
    });

    // db.rawQuery('SELECT * FROM tasks').then((value) {
    //   for (int i = 0; i < value.length; ++i) {
    //     if (value[i]['status'] == 'done') {
    //       doneRecords.add(value[i]);
    //     } else if (value[i]['status'] == 'archive') {
    //       archivedRecords.add(value[i]);
    //     } else
    //       newRecords.add(value[i]);
    //   }
    //   emit(ToDoGetDatabaseState());
    // }).catchError((onError) {
    //   print('the error is $onError');
    // });
  }

  ///----------------update---------------------//
  void updateRecords({required String? status, required int? id}) {
    database!.rawUpdate(
        'UPDATE tasks SET status = ? where id = ?', [status, id]).then((value) {
      emit(ToDoUpdateDatabaseState());
      getRecord(database!);
    });
  }

  //--------------------Delete records--------------//
  void deleteRecords({required id}) {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(ToDoDeleteDatabaseState());
      getRecord(database!);
    });
  }
}
