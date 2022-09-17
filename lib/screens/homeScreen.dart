import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controller/taskController.dart';
import 'package:todoapp/screens/addTask.dart';
import 'package:todoapp/services/notificationServiceHelper.dart';
import 'package:todoapp/theme.dart';
import 'package:todoapp/ui/button.dart';

import '../model/tasks.dart';
import '../services/themeServices.dart';
import '../ui/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var notifyHelper = NotificationHelper();
  //var scheduleNotifyHelper=NotificationHelper().scheduledNotification(hour, minute, task)
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  @override
  void initState() {
    super.initState();
    notifyHelper.initializeNotifaction();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Column(
          children: [_addTaskBar(), _addDateBar(), _showTaskList()],
        ));
  }

  _addTaskBar() => Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: subHeadingStyle,
                  ),
                  Text(
                    "Today",
                    style: headingStyle,
                  )
                ],
              ),
            ),
            ButtonWidget(
                btn_label: "Add Task",
                btn_onTap: () async {
                  await Get.to(() => AddTaskScreen());
                  _taskController.getTasks();
                })
          ],
        ),
      );
  _showTaskList() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
              DateTime date = DateFormat.jm().parse(task.startDate.toString());
              var notifyTime = DateFormat("HH:mm").format(date);
              print(notifyTime);
              notifyHelper.scheduledNotification(
                  int.parse(notifyTime.toString().split(":")[0]),
                  int.parse(notifyTime.toString().split(":")[1]),
                  task);
              if (task.repeat == "Daily") {
                /* print("get called");
                DateTime date = Intl.withLocale('en',
                    () => DateFormat.jm().parse(task.startDate.toString()));
                var notifyTime = DateFormat("HH:mm").format(date);
                if (kDebugMode) {
                  print(notifyTime);
                }*/
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (kDebugMode) {
                                  print("get called too fuck");
                                }
                                _bottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              }
              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _bottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Container();
              }
            });
      }),
    );
  }

  _addDateBar() => Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: DatePicker(DateTime.now(),
          height: 100,
          selectionColor: primaryColor,
          initialSelectedDate: DateTime.now(),
          selectedTextColor: white,
          dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 20),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 16),
          ),
          monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 12),
          ),
          onDateChange: (date) => setState(() {
                _selectedDate = date;
                //print('$_selectedDate');
              })));
  _appBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchThme();
          notifyHelper.displayNotification(
              notification_title: 'Theme Changed',
              notification_body: Get.isDarkMode
                  ? "Activate dark theme"
                  : "Activate light theme");
          //notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.sunny : Icons.nightlight_rounded,
          size: 25,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            Icons.person,
            size: 30,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        )
      ],
    );
  }

  _bottomSheetButton(
      {required String btnlabel,
      required Function()? onTap,
      required Color color,
      bool? isClose,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: isClose == true
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : color),
            borderRadius: BorderRadius.circular(20),
            color: isClose == true ? Colors.transparent : color),
        child: Center(
          child: Text(
            btnlabel,
            style: titleStyle.copyWith(
                color: isClose == true ? Colors.black : white),
          ),
        ),
      ),
    );
  }

  _bottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.2
          : MediaQuery.of(context).size.height * 0.3,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey : Colors.grey[800]),
          ),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  btnlabel: 'Task Completed',
                  onTap: () {
                    _taskController.markAsCompleted(task.id!);
                    // print("mark as completed callded");
                    Get.back();
                  },
                  color: primaryColor,
                  context: context,
                  isClose: false),
          _bottomSheetButton(
              btnlabel: 'Delete Task',
              onTap: () {
                Get.back();
                _taskController.delete(task);
                _taskController.getTasks();
              },
              color: pink,
              context: context,
              isClose: false),
          _bottomSheetButton(
              btnlabel: 'Close',
              onTap: () => Get.back(),
              color: Colors.red,
              context: context,
              isClose: true)
        ],
      ),
    ));
  }
}
