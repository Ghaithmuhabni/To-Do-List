import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/extensions/space_exs.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_str.dart';
import 'package:flutter_application_1/views/home/components/fab.dart';
import 'package:flutter_application_1/views/home/components/home_app_bar.dart';
import 'package:flutter_application_1/views/home/components/slider_drawer.dart';
import 'package:flutter_application_1/views/home/widget/task_widget.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/adapters.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 1;
    }
  }

  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks) {
      if (doneTask.isComleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();
          tasks.sort((a, b) => a.createdAtDate.compareTo((b.createdAtDate)));

          return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: const Fab(),

              //Body
              body: SafeArea(
                child: SliderDrawer(
                  key: drawerKey,
                  isDraggable: false,
                  animationDuration: 1000,

                  //Drawer
                  slider: CustomDrawer(),

                  appBar: HomeAppBar(
                    drawerKey: drawerKey,
                  ),

                  //Main Body
                  child: _BuildHomeBody(textTheme, base, tasks),
                ),
              ));
        });
  }

  //Home body
  Widget _BuildHomeBody(
      TextTheme textTheme, BaseWidget base, List<Task> tasks) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          //custom app Bar
          Container(
            margin: EdgeInsets.only(top: 60),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //progress Indicator
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),
                40.w,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MyString.mainTitle,
                      style: textTheme.displayLarge,
                    ),
                    6.h,
                    Text(
                      "${checkDoneTask(tasks)} of ${tasks.length} task",
                      style: TextStyle(fontSize: 30),
                    )
                  ],
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),
          //Tasks
          SizedBox(
              width: double.infinity,
              height: 600,
              child: tasks.isNotEmpty
                  ? ListView.builder(
                      itemCount: tasks.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var task = tasks[index];
                        return Dismissible(
                            direction: DismissDirection.horizontal,
                            onDismissed: (_) {
                              base.dataStore.deleteTask(task: task);
                            },
                            background: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                  size: 60,
                                ),
                                16.w,
                                const Text(
                                  MyString.deletedTask,
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                            key: Key(task.id),
                            child: TaskWidget(task: task));
                      })
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeIn(
                            child: const SizedBox(
                          width: 400,
                          height: 400,
                        )),
                        FadeInUp(
                            from: 50,
                            child: const Text(
                              MyString.doneAllTask,
                              style: TextStyle(fontSize: 40),
                            ))
                      ],
                    ))
        ],
      ),
    );
  }
}
