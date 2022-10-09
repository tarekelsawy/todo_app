import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/todo_archived_tasks/archived_tasks.dart';
import 'package:flutter_app/modules/todo_done_tasks/done_tasks.dart';
import 'package:flutter_app/modules/todo_new_tasks/new_tasks.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_app/shared/components/constants.dart';
import 'package:flutter_app/shared/cubit/todo_cubit.dart';
import 'package:flutter_app/shared/cubit/todo_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class TodoHome extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  // @override
  // void initState() {
  //   super.initState();
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoCubit()..createDatabase(),
      child: BlocConsumer<ToDoCubit, ToDoStates>(
        listener: (context, toDoStates) {
          if (toDoStates is ToDoInsertDatabaseState) {
            Navigator.pop(context);
            titleController.text = '';
            dateController.text = '';
            timeController.text = '';
          }
        },
        builder: (context, toDOStates) {
          ToDoCubit cubit = ToDoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.appBarTitle[cubit.currentIndex],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // try {
                //   String name = await getName();
                //   print('$name');
                //   print('hello world');
                //   throw ('my Exception');
                // } catch (e) {
                //   print('exception is $e');
                // }
                //then and catchError = try-catch
                // getName().then((value) {
                //   print(value);
                //   print('after one');
                //   throw ('my exception');
                // }).catchError((error) {
                //   print('the error is $error');
                // });
                // insertRecord();
                if (!cubit.isShowBottomSheet) {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) {
                        return bottomSheetContent(context);
                      })
                      .closed
                      .then((value) {
                        cubit.bottomSheetState(false);
                        // setState(() {
                        //   isShowBottomSheet = false;
                        // });
                      });
                  cubit.bottomSheetState(true);
                  // setState(() {
                  //   isShowBottomSheet = true;
                  // });
                } else {
                  if (formKey.currentState!.validate()) {
                    cubit.insertRecord(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    // insertRecord(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then(
                    //   (value) {
                    //     Navigator.pop(context);
                    //     // setState(
                    //     //   () {
                    //     //     isShowBottomSheet = false;
                    //     //   },
                    //     // );
                    //   },
                    // ).catchError((onError) {
                    //   print('$onError is the Error');
                    // });
                  }
                }
              },
              child: Icon(
                cubit.isShowBottomSheet ? Icons.add : Icons.edit,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              // backgroundColor: Colors.amber,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                ToDoCubit.get(context).changeIndex(index);
                // setState(() {});
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.today_rounded),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                )
              ],
            ),
            body: ConditionalBuilder(
              condition: toDOStates is! ToDoLoadingState,
              builder: (context) {
                return cubit.screens[cubit.currentIndex];
              },
              fallback: (context) {
                return Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }

  Future<String> getName() async {
    return 'Mohamed Abdullah';
  }

  //bottomSheetContent
  Widget bottomSheetContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.grey[200],
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            commonTextFormField(
              controller: titleController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'type a title of the task';
                }
              },
              labelText: 'Enter The Title',
              preFixIcon: Icons.title,
            ),
            SizedBox(
              height: 10,
            ),
            commonTextFormField(
              controller: timeController,
              keyboardType: TextInputType.datetime,
              onTap: () {
                showTimePicker(context: context, initialTime: TimeOfDay.now())
                    .then((value) {
                  timeController.text = value!.format(context);
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'type a time of the task';
                }
              },
              labelText: 'Enter The Time',
              preFixIcon: Icons.watch_later_outlined,
            ),
            SizedBox(
              height: 10,
            ),
            commonTextFormField(
              controller: dateController,
              keyboardType: TextInputType.datetime,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.parse('2021-10-29'),
                ).then((value) {
                  dateController.text = DateFormat.yMMMd().format(value!);
                  // String newValue = '';
                  // String newValue = value.toString().substring(0, 10);
                  // print(newValue);
                  // for (int i = 0; i < 10; ++i) {
                  //   newValue += value.toString()[i];
                  // }
                  // dateController.text = newValue;
                }).catchError((onError) {
                  print('The Error is $onError');
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'type a Date of the task';
                }
              },
              labelText: 'Enter The Date',
              preFixIcon: Icons.watch_later_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
