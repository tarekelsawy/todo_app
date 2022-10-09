import 'package:flutter/material.dart';
import 'package:flutter_app/shared/components/components.dart';

import 'package:flutter_app/shared/cubit/todo_cubit.dart';
import 'package:flutter_app/shared/cubit/todo_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return buildConditionalBuilder(ToDoCubit.get(context).archivedRecords);
      },
    );
  }
}
