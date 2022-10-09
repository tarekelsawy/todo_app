import 'package:flutter/material.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_app/shared/components/constants.dart';
import 'package:flutter_app/shared/cubit/todo_cubit.dart';
import 'package:flutter_app/shared/cubit/todo_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return buildConditionalBuilder(ToDoCubit.get(context).newRecords);
      },
    );
  }
}
// BlocConsumer<ToDoCubit, ToDoStates>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         ToDoCubit cubit = ToDoCubit.get(context);
//         return ListView.separated(
//           itemBuilder: (BuildContext context, int index) {
//             return toDoItem(cubit.newRecords[index], context);
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Divider(
//               height: 1,
//               color: Colors.grey,
//               indent: 10.0,
//               // thickness: 1,
//             );

//             // return Padding(
//             //   padding: const EdgeInsetsDirectional.only(
//             //     start: 20.0,
//             //   ),
//             //   child: Container(
//             //     height: 1,
//             //     width: double.infinity,
//             //     color: Colors.grey,
//             //   ),
//             // );
//           },
//           itemCount: cubit.newRecords.length,
//         );
//       },
//     );
