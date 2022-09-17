import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controller/taskController.dart';
import 'package:todoapp/theme.dart';
import 'package:todoapp/ui/button.dart';

import '../model/tasks.dart';
import '../ui/input_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  get notifyHelper => null;
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskNoteController = TextEditingController();
  DateTime _taskSelecteddateTime = DateTime.now();
  String _taksEndTime = DateFormat("hh:mm a")
      .format(DateTime.now().add(Duration(hours: 1)))
      .toString();
  String _taskStartTime =
      DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _remindTime = 5;
  List<int> _reminderList = [5, 10, 15, 30, 60];
  String _repeatTime = "None";
  List<String> _repeatList = ['none', 'daily', 'weekly', 'monthly'];
  int _selectedColorIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputFieldWidget(
                inputFiledLabel: 'Task Name',
                hint: 'Enter Task Name',
                textEditingController: taskTitleController,
              ),
              InputFieldWidget(
                inputFiledLabel: 'Note',
                hint: 'Enter task details',
                textEditingController: taskNoteController,
              ),
              InputFieldWidget(
                inputFiledLabel: 'Date',
                hint: DateFormat.yMd().format(_taskSelecteddateTime),
                textEditingController: null,
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: Icon(Icons.calendar_month_outlined),
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputFieldWidget(
                      inputFiledLabel: 'Start TIme',
                      hint: _taskStartTime,
                      textEditingController: null,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(true);
                          //print('$_taskStartTime');
                        },
                        icon: Icon(Icons.access_time_outlined),
                        color: darkGrey,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InputFieldWidget(
                      inputFiledLabel: 'End Time',
                      hint: _taksEndTime,
                      textEditingController: null,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(false);
                        },
                        icon: Icon(Icons.access_time_outlined),
                        color: darkGrey,
                      ),
                    ),
                  )
                ],
              ),
              InputFieldWidget(
                inputFiledLabel: 'Remind me',
                hint: '$_remindTime minutes early',
                textEditingController: null,
                widget: DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    iconSize: 32,
                    items: _reminderList
                        .map((int value) => DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value.toString())))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _remindTime = int.parse(value!);
                      });
                    }),
              ),
              InputFieldWidget(
                inputFiledLabel: 'Repeat',
                hint: '$_repeatTime',
                textEditingController: null,
                widget: DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    iconSize: 32,
                    items: _repeatList
                        .map((String value) => DropdownMenuItem<String>(
                            value: value, child: Text(value)))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _repeatTime = value!;
                      });
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Color'),
                      Wrap(
                          children: List<Widget>.generate(
                              3,
                              (index) => GestureDetector(
                                    onTap: () {
                                      setState(
                                          () => _selectedColorIndex = index);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: index == 0
                                            ? primaryColor
                                            : index == 1
                                                ? yellow
                                                : pink,
                                        child: _selectedColorIndex == index
                                            ? Icon(Icons.done,
                                                color: Colors.white)
                                            : Container(),
                                      ),
                                    ),
                                  ))),
                    ],
                  ),
                  ButtonWidget(
                      btn_label: 'Create Task', btn_onTap: _validateController)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateController() {
    if (taskTitleController.text.isNotEmpty &&
        taskNoteController.text.isNotEmpty) {
      _addTaskToDB();
      //print('$_addTaskToDB()');
      Get.back();
    } else if (taskTitleController.text.isEmpty ||
        taskNoteController.text.isEmpty) {
      Get.snackbar('Warning', 'Title and note field can\'t be empty',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.warning_amber),
          backgroundColor: Get.theme.backgroundColor);
    }
  }

  _addTaskToDB() async {
    var rowvalue = await _taskController.addTask(
        task: Task(
            note: taskNoteController.text,
            title: taskTitleController.text,
            color: _selectedColorIndex,
            date: DateFormat.yMd().format(_taskSelecteddateTime),
            startDate: _taskStartTime,
            endDate: _taksEndTime,
            remind: _remindTime,
            repeat: _repeatTime,
            isCompleted: 0));
    //print("Insert row id $rowvalue");
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Icon(
          Icons.person_outline,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickDate = await showDatePicker(
        context: context,
        initialDate: _taskSelecteddateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (pickDate != null) {
      setState(() {
        _taskSelecteddateTime = pickDate;
        //print('$pickDate');
      });
    } else {
      print("Select date doesn't work");
    }
  }

  _getTimeFromUser(bool isStartTime) async {
    var pickedTime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: DateTime.now().hour, minute: DateTime.now().minute));
    String? formattedTime = pickedTime?.format(context);
    //print('$formattedTime');

    if (pickedTime == null) {
      print('Time can\'t be null');
    } else if (isStartTime) {
      setState(() {
        _taskStartTime = formattedTime!;
      });
    } else if (!isStartTime) {
      setState(() {
        _taksEndTime = formattedTime!;
      });
    }
  }
}
