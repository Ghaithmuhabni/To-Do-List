import 'package:flutter/material.dart';
import 'package:flutter_application_1/extensions/space_exs.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_str.dart';
import 'package:flutter_application_1/utils/constants.dart';
import 'package:flutter_application_1/views/tasks/components/date_time_selection.dart';
import 'package:flutter_application_1/views/tasks/components/rep_textfield.dart';
import 'package:flutter_application_1/views/tasks/widget/task_view_app_bar.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';

class TaskView extends StatefulWidget {
  const TaskView(
      {super.key,
      required this.titleTaskController,
      required this.descriptionTaskController,
      required this.task});

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subTitle;

        widget.task?.save();
        Navigator.pop(context);
      } catch (e) {
        updateTaskWarning(context);
      }
    } else {
      if (title != null && subTitle != null) {
        var task = Task.create(
            title: title,
            subTitle: subTitle,
            createdAtTime: time,
            createdAtDate: date);

        BaseWidget.of(context).dataStore.addTask(task: task);

        Navigator.pop(context);
      } else {
        emptyWarning(context);
      }
    }
  }

  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: SafeArea(
        child: Scaffold(
          //AppBar
          appBar: TaskViewAppBar(),

          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Top Side Texts
                    buildTopSideTexts(textTheme),

                    //Main Task View Activity
                    _buildMainTaskViewAcitivty(
                      textTheme,
                      context,
                    ),

                    //Bottom Side Buttons
                    _buildBottomAppButtons()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAppButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExist()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExist()
              ? Container()
              : MaterialButton(
                  onPressed: () {
                    deleteTask();
                    Navigator.pop(context);
                  },
                  minWidth: 180,
                  height: 85,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.close,
                        color: AppColors.primaryColor,
                        size: 30,
                      ),
                      5.w,
                      const Text(
                        MyString.deleteTask,
                        style: TextStyle(
                            color: AppColors.primaryColor, fontSize: 30),
                      ),
                    ],
                  ),
                )

          // Add Or Update
          ,
          MaterialButton(
            onPressed: () {
              isTaskAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 180,
            height: 85,
            color: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text(
              isTaskAlreadyExist()
                  ? MyString.addTaskString
                  : MyString.updateTaskString,
              style: const TextStyle(color: Colors.white, fontSize: 30),
            ),
          )
        ],
      ),
    );
  }

  //Main Task View Activity
  Widget _buildMainTaskViewAcitivty(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 630,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 35),
            child: Text(MyString.titleOfTitleTextField,
                style: textTheme.headlineLarge),
          ),

          //Task Title
          RepTextField(
            controller: widget.titleTaskController ?? TextEditingController(),
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
          ),

          30.h,

          //Task Title
          RepTextField(
            controller:
                widget.descriptionTaskController ?? TextEditingController(),
            isForDescription: true,
            onFieldSubmitted: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
            onChanged: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
          ),

          ///Time Selection
          dateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) => SizedBox(
                        height: 280,
                        child: TimePickerWidget(
                          initDateTime: showDateAsDateTime(time),
                          onChange: (_, __) {},
                          dateFormat: 'HH:mm',
                          onConfirm: (dateTime, _) {
                            setState(() {
                              if (widget.task?.createdAtTime == null) {
                                time = dateTime;
                              } else {
                                widget.task!.createdAtTime = dateTime;
                              }
                            });
                          },
                        ),
                      ));
            },
            title: "Time",
            time: showTime(time),
          ),

          ///Time Selection
          dateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(context,
                  maxDateTime: DateTime(2030, 4, 5),
                  minDateTime: DateTime.now(),
                  initialDateTime: showDateAsDateTime(date),
                  onConfirm: (dateTime, _) {
                setState(() {
                  if (widget.task?.createdAtDate == null) {
                    date = dateTime;
                  } else {
                    widget.task!.createdAtDate = dateTime;
                  }
                });
              });
            },
            title: MyString.dateString,
            isTime: true,
            time: showDate(date),
          ),
        ],
      ),
    );
  }

  //Top Side Texts
  Widget buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 75,
            child: Divider(
              thickness: 5,
            ),
          ),
          RichText(
              text: TextSpan(
                  text: isTaskAlreadyExist()
                      ? MyString.addNewTask
                      : MyString.updateCurrentTask,
                  style: textTheme.titleLarge,
                  children: [
                TextSpan(
                    text: MyString.taskString,
                    style: TextStyle(fontWeight: FontWeight.w400))
              ])),
          const SizedBox(
            width: 55,
            child: Divider(
              thickness: 5,
            ),
          ),
        ],
      ),
    );
  }
}
