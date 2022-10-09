import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/shared/cubit/todo_cubit.dart';
import 'package:flutter_app/shared/cubit/todo_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget commonButton({
  Color buttonColor = Colors.blue,
  double width = double.infinity,
  required VoidCallback function,
  required String child,
  bool isUpperCase = true,
}) =>
    MaterialButton(
      clipBehavior: Clip.antiAlias,
      color: buttonColor,
      height: 45,
      minWidth: width,
      textColor: Colors.white,
      onPressed: function,
      child: Text(isUpperCase ? '$child'.toUpperCase() : '$child'),
    );

Widget commonTextFormField({
  required TextEditingController controller,
  required FormFieldValidator<String>? validator,
  TextInputType? keyboardType,
  ValueChanged<String>? onChanged,
  GestureTapCallback? onTap,
  required String labelText,
  required IconData preFixIcon,
  IconData? suffixIcon,
  ValueChanged<String>? onFieldSubmitted,
  bool obscureText = false,
  VoidCallback? onPressed,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      // hintText: 'Enter Email',
      labelText: labelText,
      prefixIcon: Icon(preFixIcon),
      suffixIcon: IconButton(onPressed: onPressed, icon: Icon(suffixIcon)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onFieldSubmitted: onFieldSubmitted,
    onChanged: onChanged,
    onTap: onTap,
    obscureText: obscureText,
  );
}

Widget toDoItem(Map<dynamic, dynamic>? record, BuildContext context) {
  ToDoCubit cubit = ToDoCubit.get(context);
  return Dismissible(
    key: Key('item ${record!["id"]}'),
    onDismissed: (DismissDirection direction) {
      if (direction == DismissDirection.endToStart ||
          direction == DismissDirection.startToEnd)
        cubit.deleteRecords(id: record['id']);
    },
    background: Container(
      color: Colors.red,
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            'Move to trach',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
    secondaryBackground: Container(
      color: Colors.red,
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            'move to trach',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Text(
              "${record['time']}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${record['title']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${record['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              cubit.updateRecords(status: 'done', id: record['id']);
            },
            icon: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () {
              cubit.updateRecords(status: 'archive', id: record['id']);
            },
            icon: Icon(
              Icons.archive_rounded,
              size: 35,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildConditionalBuilder(List<Map<dynamic, dynamic>> records) {
  return ConditionalBuilder(
    condition: records.length > 0,
    builder: (context) {
      return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return toDoItem(records[index], context);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            thickness: 0.5,
            color: Colors.grey,
            indent: 10.0,
          );
        },
        itemCount: records.length,
      );
    },
    fallback: (BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 160,
              color: Colors.grey,
            ),
            Text(
              'Type Your Task,Please',
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    },
  );
}
