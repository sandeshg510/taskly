import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/common/widgets/basics.dart';
import 'package:task_manager/src/values/colors.dart';

import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../blocs/task_state.dart';

class TaskScreen extends StatefulWidget {
  final String userId;
  const TaskScreen({super.key, required this.userId});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with CommonWidgets {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDueDate;
  Priority _selectedPriority = Priority.medium;

  Priority? _filterPriority;
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks(widget.userId));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<DateTime?> _selectDueDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.beigeColor,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.blackColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.blackColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void _showTaskFormModalSheet({TaskEntity? task}) {
    _titleController.text = task?.title ?? '';
    _descController.text = task?.description ?? '';
    _selectedDueDate = task?.dueDate;
    _selectedPriority = task?.priority ?? Priority.medium;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final textTheme = Theme.of(context).textTheme;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.beigeColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      task == null
                          ? "Time to Get Creative!"
                          : "Refine Your Task",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Your Task Title *',
                        labelStyle: TextStyle(
                          color: AppColors.blackColor.withOpacity(0.7),
                        ),
                        hintText: 'e.g., Finish report by Friday',
                        prefixIcon: Icon(
                          Icons.edit_outlined,
                          color: AppColors.greyColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.beigeColor,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.greyColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _descController,
                      decoration: InputDecoration(
                        labelText: 'What\'s it all about?',
                        labelStyle: TextStyle(
                          color: AppColors.blackColor.withOpacity(0.7),
                        ),
                        hintText: 'Add details here...',
                        prefixIcon: Icon(
                          Icons.description_outlined,
                          color: AppColors.greyColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.beigeColor,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.greyColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.calendar_month,
                          color: AppColors.greyColor,
                        ),
                        title: Text(
                          _selectedDueDate == null
                              ? 'When\'s the deadline?'
                              : 'Due: ${DateFormat('MMM dd, EEEE').format(_selectedDueDate!)}',
                          style: const TextStyle(color: AppColors.blackColor),
                        ),
                        trailing: _selectedDueDate != null
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: AppColors.greyColor.withOpacity(0.8),
                                ),
                                onPressed: () {
                                  setModalState(() {
                                    _selectedDueDate = null;
                                  });
                                },
                              )
                            : null,
                        onTap: () async {
                          final picked = await _selectDueDate(context);
                          if (picked != null) {
                            setModalState(() {
                              _selectedDueDate = picked;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<Priority>(
                          value: _selectedPriority,
                          decoration: InputDecoration(
                            labelText: 'How important is it?',
                            labelStyle: TextStyle(
                              color: AppColors.blackColor.withOpacity(0.7),
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.star_half,
                              color: AppColors.greyColor,
                            ),
                          ),
                          dropdownColor: AppColors.backgroundColor,
                          style: const TextStyle(color: AppColors.blackColor),
                          items: Priority.values.map((priority) {
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority.toString().split('.').last,
                                style: TextStyle(
                                  color: _getPriorityColor(priority),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (Priority? newValue) {
                            if (newValue != null) {
                              setModalState(() {
                                _selectedPriority = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightGreyColor,
                              foregroundColor: AppColors.blackColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 1,
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final title = _titleController.text.trim();
                              if (title.isNotEmpty &&
                                  _selectedDueDate != null) {
                                if (task == null) {
                                  final newTask = TaskEntity(
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    title: title,
                                    description: _descController.text.trim(),
                                    dueDate: _selectedDueDate!,
                                    priority: _selectedPriority,
                                    isCompleted: false,
                                  );
                                  context.read<TaskBloc>().add(
                                    CreateTask(newTask),
                                  );
                                } else {
                                  final updatedTask = TaskEntity(
                                    id: task.id,
                                    userId: task.userId,
                                    title: title,
                                    description: _descController.text.trim(),
                                    dueDate: _selectedDueDate!,
                                    priority: task.priority,
                                    isCompleted: task.isCompleted,
                                  );
                                  context.read<TaskBloc>().add(
                                    UpdateTask(updatedTask),
                                  );
                                }
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'A task needs a title and a due date!',
                                    ),
                                    backgroundColor: AppColors.warningColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.beigeColor,
                              foregroundColor: AppColors.blackColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: Text(
                              task == null ? "Add Task" : "Save Changes",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      _titleController.clear();
      _descController.clear();
      _selectedDueDate = null;
      _selectedPriority = Priority.medium;
    });
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return AppColors.highPriorityColor;
      case Priority.medium:
        return AppColors.mediumPriorityColor;
      case Priority.low:
        return AppColors.lowPriorityColor;
      default:
        return AppColors.blackColor.withOpacity(0.6);
    }
  }

  Color _getPriorityBgColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return AppColors.highPriorityColor.withOpacity(0.2);
      case Priority.medium:
        return AppColors.mediumPriorityColor.withOpacity(0.2);
      case Priority.low:
        return AppColors.lowPriorityColor.withOpacity(0.2);
      default:
        return AppColors.beigeColor.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.beigeColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.task_outlined, size: 22),
              ),
              horizontalSpace(width: 16),
              Text(
                "Task List",
                style: appBarTheme.titleTextStyle?.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  fontFamily: 'Amazon',
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.blackColor,
        elevation: 0,
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: Icon(
                Icons.filter_alt,
                size: 26,
                color: AppColors.blackColor,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (ctx) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: AppColors.beigeColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Text(
                            "Filter Your Tasks",
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Priority:",
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: [
                              FilterChip(
                                label: const Text("All"),
                                selected: _filterPriority == null,
                                selectedColor: AppColors.beigeColor.withOpacity(
                                  0.2,
                                ),
                                checkmarkColor: AppColors.beigeColor,
                                onSelected: (_) => setState(() {
                                  _filterPriority = null;
                                  Navigator.pop(context);
                                }),
                                labelStyle: textTheme.labelLarge?.copyWith(
                                  color: _filterPriority == null
                                      ? AppColors.beigeColor
                                      : AppColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                backgroundColor: AppColors.lightGreyColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: AppColors.greyColor.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              ...Priority.values.map((priority) {
                                return FilterChip(
                                  label: Text(
                                    priority.toString().split('.').last,
                                  ),
                                  selected: _filterPriority == priority,
                                  selectedColor: AppColors.beigeColor
                                      .withOpacity(0.2),
                                  checkmarkColor: AppColors.beigeColor,
                                  onSelected: (_) => setState(() {
                                    _filterPriority = priority;
                                    Navigator.pop(context);
                                  }),
                                  labelStyle: textTheme.labelLarge?.copyWith(
                                    color: _filterPriority == priority
                                        ? AppColors.beigeColor
                                        : AppColors.blackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  backgroundColor: AppColors.lightGreyColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: AppColors.greyColor.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Completion Status:",
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: [
                              FilterChip(
                                label: const Text("Show All"),
                                selected: _showCompleted,
                                selectedColor: AppColors.beigeColor.withOpacity(
                                  0.2,
                                ),
                                checkmarkColor: AppColors.beigeColor,
                                onSelected: (_) => setState(() {
                                  _showCompleted = true;
                                  Navigator.pop(context);
                                }),
                                labelStyle: textTheme.labelLarge?.copyWith(
                                  color: _showCompleted
                                      ? AppColors.beigeColor
                                      : AppColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                backgroundColor: AppColors.lightGreyColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: AppColors.greyColor.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              FilterChip(
                                label: const Text("Show Incomplete"),
                                selected: !_showCompleted,
                                selectedColor: AppColors.beigeColor.withOpacity(
                                  0.2,
                                ),
                                checkmarkColor: AppColors.beigeColor,
                                onSelected: (_) => setState(() {
                                  _showCompleted = false;
                                  Navigator.pop(context);
                                }),
                                labelStyle: textTheme.labelLarge?.copyWith(
                                  color: !_showCompleted
                                      ? AppColors.beigeColor
                                      : AppColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                backgroundColor: AppColors.lightGreyColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: AppColors.greyColor.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Close",
                                style: textTheme.labelLarge?.copyWith(
                                  fontSize: 16,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              tooltip: "Filter Tasks",
            ),
          ),
          horizontalSpace(width: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: Icon(Icons.logout, size: 24, color: AppColors.blackColor),
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
              tooltip: "Log out",
            ),
          ),
          horizontalSpace(width: 16),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.beigeColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading your tasks...",
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is TaskLoaded) {
            List<TaskEntity> filteredTasks = state.tasks.where((task) {
              final matchesPriority =
                  _filterPriority == null || task.priority == _filterPriority;
              final matchesStatus = _showCompleted || !task.isCompleted;
              return matchesPriority && matchesStatus;
            }).toList()..sort((a, b) => a.dueDate.compareTo(b.dueDate));

            if (filteredTasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 100,
                      color: AppColors.greyColor.withOpacity(0.7),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _filterPriority != null || !_showCompleted
                          ? "No matching tasks found."
                          : "You're all caught up! No tasks here.",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (_filterPriority == null && _showCompleted)
                      ElevatedButton.icon(
                        onPressed: () => _showTaskFormModalSheet(),
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.blackColor,
                        ),
                        label: const Text(
                          "Add New Task",
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.beigeColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    if (_filterPriority != null || !_showCompleted)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _filterPriority = null;
                            _showCompleted = true;
                          });
                        },
                        icon: Icon(Icons.clear, color: AppColors.greyColor),
                        label: Text(
                          "Clear Filters",
                          style: textTheme.labelLarge?.copyWith(
                            color: AppColors.greyColor,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(height: 30),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.cardColor,
                          border: Border.all(),

                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greyColor.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showTaskFormModalSheet(task: task),
                            borderRadius: BorderRadius.circular(15),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          task.title,
                                          style: textTheme.titleMedium
                                              ?.copyWith(
                                                fontSize: 18,
                                                fontFamily: 'Amazon',
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.blackColor,
                                                decoration: task.isCompleted
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                decorationColor:
                                                    AppColors.greyColor,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getPriorityBgColor(
                                            task.priority,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: _getPriorityColor(
                                              task.priority,
                                            ).withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          task.priority
                                              .toString()
                                              .split('.')
                                              .last
                                              .toUpperCase(),
                                          style: textTheme.labelSmall?.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (task.description.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      task.description,
                                      style: textTheme.bodyMedium?.copyWith(
                                        height: 1.4,
                                        color: AppColors.greyColor,
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                        decorationColor: AppColors.greyColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  Divider(
                                    color: AppColors.greyColor.withOpacity(0.3),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 18,
                                        color: AppColors.greyColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        DateFormat(
                                          'MMM dd, EEEE',
                                        ).format(task.dueDate),
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      Transform.scale(
                                        scale: 1.7,
                                        child: Checkbox(
                                          value: task.isCompleted,
                                          onChanged: (val) {
                                            context.read<TaskBloc>().add(
                                              UpdateTask(
                                                TaskEntity(
                                                  id: task.id,
                                                  userId: task.userId,
                                                  title: task.title,
                                                  description: task.description,
                                                  dueDate: task.dueDate,
                                                  priority: task.priority,
                                                  isCompleted: val ?? false,
                                                ),
                                              ),
                                            );
                                          },
                                          activeColor: AppColors.beigeColor,
                                          checkColor: AppColors.whiteColor,

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: AppColors.errorColor,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(
                                            context,
                                            task,
                                          );
                                        },
                                        tooltip: "Delete Task",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is TaskError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied,
                      size: 100,
                      color: AppColors.greyColor,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Something went wrong.",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.message,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.greyColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<TaskBloc>().add(LoadTasks(widget.userId));
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: AppColors.blackColor,
                      ),
                      label: const Text(
                        "Try Again",
                        style: TextStyle(color: AppColors.blackColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.beigeColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.beigeColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Loading tasks...",
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskFormModalSheet(),
        backgroundColor: AppColors.beigeColor,
        foregroundColor: AppColors.blackColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        tooltip: 'Add New Task',
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, TaskEntity task) {
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Task?',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${task.title}"?',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.greyColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: AppColors.greyColor),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTask(task.id!, task.userId));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              foregroundColor: AppColors.whiteColor,
              elevation: 3,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
