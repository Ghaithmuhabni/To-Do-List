import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/views/tasks/widget/task_view.dart';
import 'package:intl/intl.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController textEditingControllerForTitle = TextEditingController();
  TextEditingController textEditingControllerForSubTitle =
      TextEditingController();

  @override
  void initState() {
    textEditingControllerForTitle.text = widget.task.title;
    textEditingControllerForSubTitle.text = widget.task.subTitle;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerForTitle.dispose();
    textEditingControllerForSubTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (ctx) => TaskView(
                    titleTaskController: textEditingControllerForTitle,
                    descriptionTaskController: textEditingControllerForSubTitle,
                    task: widget.task)));
      },
      child: AnimatedContainer(
        width: double
            .infinity, 
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: widget.task.isComleted
              ? const Color.fromARGB(154, 119, 144, 229)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: const Offset(0, 4),
              blurRadius: 10,
            )
          ],
        ),
        duration: const Duration(milliseconds: 600),
        child: ListTile(
          //check icon
          leading: GestureDetector(
            //check or unCheck the task
            onTap: () {
              widget.task.isComleted = !widget.task.isComleted;
              widget.task.save();
            },

            //Main card
            child: AnimatedContainer(
              width:
                  40, // Specify a fixed width and height for the leading container
              height: 40,
              duration: Duration(milliseconds: 600),
              decoration: BoxDecoration(
                color: widget.task.isComleted
                    ? AppColors.primaryColor
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: .8),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),

          //Task Title
          title: Padding(
            padding: EdgeInsets.only(bottom: 5, top: 3),
            child: Text(
              textEditingControllerForTitle.text,
              style: TextStyle(
                  fontSize: 40,
                  color: widget.task.isComleted
                      ? AppColors.primaryColor
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  decoration: widget.task.isComleted
                      ? TextDecoration.lineThrough
                      : null),
            ),
          ),

          //Task descrption
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textEditingControllerForSubTitle.text,
                style: TextStyle(
                    fontSize: 35,
                    color: widget.task.isComleted
                        ? AppColors.primaryColor
                        : Colors.black,
                    fontWeight: FontWeight.w300,
                    decoration: widget.task.isComleted
                        ? TextDecoration.lineThrough
                        : null),
              ),

              //Date of Task
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(widget.task.createdAtTime),
                        style: TextStyle(
                            fontSize: 25,
                            color: widget.task.isComleted
                                ? Colors.white
                                : Colors.grey),
                      ),
                      Text(
                        DateFormat.yMMMEd().format(widget.task.createdAtDate),
                        style: TextStyle(
                            fontSize: 25,
                            color: widget.task.isComleted
                                ? Colors.white
                                : Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
