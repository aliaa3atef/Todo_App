import 'package:basics/shared/components/components.dart';
import 'package:basics/shared/components/constants.dart';
import 'package:basics/shared/todo_cubit/bloc.dart';
import 'package:basics/shared/todo_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = TodoCubit.get(context).newTasks;
        return tasks.length > 0
            ? ListView.separated(
                itemBuilder: (ctx, index) {
                  return taskItem(tasks: tasks[index], context: context);
                },
                separatorBuilder: (ctx, index) => Divider(
                  color: colorApp,
                ),
                itemCount: tasks.length,
              )
            : buildWhileEmptyTasks("New");
      },
    );
  }
}
