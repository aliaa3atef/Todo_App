import 'package:basics/shared/components/constants.dart';
import 'package:basics/shared/todo_cubit/bloc.dart';
import 'package:flutter/material.dart';

Widget sharedMaterialButton({
  double width = double.infinity,
  double height = 50.0,
  Color background = Colors.blue,
  double radius = 0.0,
  bool isUppercase = true,
  @required Function pressed,
  @required String txt,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: MaterialButton(
      onPressed: pressed,
      child: Text(
        txt.toUpperCase(),
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
  );
}

Widget sharedTextFormField({
  bool isPassword = false,
  @required TextEditingController controller,
  @required IconData prefixIcon,
  @required String text,
  @required Function validate,
  @required TextInputType type,
  Function tap,
  Function onTap,
  Color iconColor = Colors.blue,
  double radius = 0.0,
  IconData suffixIcon,
}) => TextFormField(
      validator: validate,
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
          color: iconColor,
        ),
        suffixIcon: InkWell(
          onTap: onTap,
          child: isPassword
              ? Icon(
                  Icons.visibility_off,
                  color: iconColor,
                )
              : Icon(
                  suffixIcon,
                  color: iconColor,
                ),
        ),
        hintText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      keyboardType: type,
      onTap: tap,
    );

Widget taskItem({@required Map tasks , @required BuildContext context }) {
  return Dismissible(
    key: Key(tasks["id"].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colorApp,
            radius: 30.0,
            child: Text(
              "${tasks["time"]}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),

          SizedBox(
            width: 5,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${tasks["title"]}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                Text(
                  "${tasks["date"]}",
                  style: TextStyle(color: Colors.grey),
                ),

              ],
            ),
          ),

          IconButton(
            icon: Icon(Icons.check_circle_rounded),
            onPressed: () {
              TodoCubit.get(context).updateDatabase(status : "Done",id : tasks["id"]);
            },
            color: colorApp,
          ),

          IconButton(
            icon: Icon(Icons.archive),
            onPressed: () {
              TodoCubit.get(context).updateDatabase(status: "Archived",id: tasks["id"]);
            },
            color: colorApp,
          ),
        ],
      ),
    ),
    onDismissed: (direction){
      TodoCubit.get(context).deleteDatabase(id: tasks["id"]);
    },
  );
}

Widget buildWhileEmptyTasks(String type){
  return  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu , size: 50, color: Colors.grey,),

        Text("No $type Tasks Yet, Please Enter Some Tasks ",

          style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold , color: Colors.grey),
        ),
      ],
    ),
  );
}