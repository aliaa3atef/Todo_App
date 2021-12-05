import 'package:basics/shared/components/components.dart';
import 'package:basics/shared/components/constants.dart';
import 'package:basics/shared/todo_cubit/bloc.dart';
import 'package:basics/shared/todo_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';

class TodoHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(builder: (context, state) {
        var cubit = TodoCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: TextStyle(),
            ),
            backgroundColor: colorApp,
          ),
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorApp,
            onPressed: () {
              if (cubit.isBottomShown) {
                if (formKey.currentState.validate()) {
                  cubit.insertInDatabase(textController.text,
                      timeController.text, dateController.text);
                }
              } else {
                scaffoldKey.currentState
                    .showBottomSheet(
                      (context) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                sharedTextFormField(
                                  controller: textController,
                                  prefixIcon: Icons.title,
                                  iconColor: colorApp,
                                  text: "Task Title",
                                  validate: (String val) {
                                    if (val.isEmpty)
                                      return "Task title can not be empty";
                                    return null;
                                  },
                                  type: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                sharedTextFormField(
                                    controller: timeController,
                                    prefixIcon: Icons.watch_later,
                                    iconColor: colorApp,
                                    type: TextInputType.datetime,
                                    text: "Task time",
                                    validate: (String val) {
                                      if (val.isEmpty)
                                        return "Task Time Can Not Be Empty";

                                      return null;
                                    },
                                    tap: () {
                                      print("tapped");
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) => timeController.text =
                                          value.format(context));
                                      print(timeController.text);
                                    }),
                                SizedBox(
                                  height: 20.0,
                                ),
                                sharedTextFormField(
                                    controller: dateController,
                                    prefixIcon: Icons.calendar_today,
                                    iconColor: colorApp,
                                    type: TextInputType.datetime,
                                    text: "Task date",
                                    validate: (String val) {
                                      if (val.isEmpty)
                                        return "Task Date Can Not Be Empty";

                                      return null;
                                    },
                                    tap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse("2022-01-06"),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value);
                                        print(dateController.text);
                                      });
                                    })
                              ],
                            ),
                          ),
                        );
                      },
                      elevation: 30.0,
                    )
                    .closed
                    .then((value) {
                      cubit.changeBottomSheetIcon(false, Icons.edit);
                    });
                cubit.changeBottomSheetIcon(true, Icons.add);
              }
            },
            child: Icon(
              cubit.icon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: colorApp,
            currentIndex: TodoCubit.get(context).currentIndex,
            onTap: (index) {
              TodoCubit.get(context).changeIndex(index);
            },
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
              BottomNavigationBarItem(icon: Icon(Icons.check), label: "Done"),
              BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archive"),
            ],
          ),
        );
      }, listener: (context, state) {
        if (state is TodoInsertDatabaseState) Navigator.pop(context);
      }),
    );
  }
}
