import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow/controllers/drink_record_controller.dart';
import 'package:flow/controllers/auth_controller.dart';
import 'package:flow/models/drink_record_model.dart';
import 'package:intl/intl.dart';

class DrinkRecordsPage extends StatefulWidget {
  const DrinkRecordsPage({super.key});

  @override
  State<DrinkRecordsPage> createState() => _DrinkRecordsPageState();
}

class _DrinkRecordsPageState extends State<DrinkRecordsPage> {
  String? selectedDate;

  Future<void> _showEditDialog(
    BuildContext context,
    DrinkRecordController drinkController,
    DrinkRecord record,
  ) async {
    final formKey = GlobalKey<FormState>();
    int amount = record.amount;
    String type = record.type;
    DateTime selectedDate = record.timestamp;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(record.timestamp);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('編輯飲水紀錄'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 飲水量輸入
              TextFormField(
                initialValue: amount.toString(),
                decoration: const InputDecoration(
                  labelText: '飲水量 (ml)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入飲水量';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return '請輸入有效的飲水量';
                  }
                  return null;
                },
                onSaved: (value) {
                  amount = int.parse(value!);
                },
              ),
              const SizedBox(height: 16),

              // 飲品類型選擇
              DropdownButtonFormField<String>(
                value: type,
                decoration: const InputDecoration(
                  labelText: '飲品類型',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(15),
                items: const [
                  DropdownMenuItem(value: 'water', child: Text('水')),
                  DropdownMenuItem(value: 'coffee', child: Text('咖啡')),
                  DropdownMenuItem(value: 'tea', child: Text('茶')),
                  DropdownMenuItem(value: 'juice', child: Text('果汁')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    type = value;
                  }
                },
              ),
              const SizedBox(height: 16),

              // 日期選擇
              StatefulBuilder(
                builder: (context, setState) => ListTile(
                  title: Text('日期: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  },
                ),
              ),

              // 時間選擇
              StatefulBuilder(
                builder: (context, setState) => ListTile(
                  title: Text('時間: ${selectedTime.format(context)}'),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                try {
                  await drinkController.updateRecord(
                    record.id,
                    amount: amount,
                    type: type,
                    timestamp: selectedDate,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('紀錄已更新')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('更新失敗: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('儲存'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DrinkRecordController, AuthController>(
      builder: (context, drinkController, authController, child) {
        final user = authController.currentUser;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // 按日期分組的紀錄
        Map<String, List<DrinkRecord>> groupedRecords = {};
        for (var record in drinkController.records) {
          String date = DateFormat('yyyy-MM-dd').format(record.timestamp);
          groupedRecords.putIfAbsent(date, () => []);
          groupedRecords[date]!.add(record);
        }

        // 如果沒有選擇日期，預設選擇最新的日期
        selectedDate ??= groupedRecords.keys.first;

        return Column(
          children: [
            // 日期選擇器
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: groupedRecords.length,
                itemBuilder: (context, index) {
                  // 按日期排序
                  List<String> sortedDates = groupedRecords.keys.toList()..sort((a, b) => b.compareTo(a));
                  String date = sortedDates[index];
                  List<DrinkRecord> dayRecords = groupedRecords[date]!;
                  int dailyTotal = dayRecords.fold(0, (sum, record) => sum + record.amount);
                  double progress = dailyTotal / user.dailyGoal;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedDate == date ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.grey[200],
                                      strokeWidth: 8,
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat('EEE').format(DateFormat('yyyy-MM-dd').parse(date)).substring(0, 3),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: selectedDate == date ? Colors.black : Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd').format(DateFormat('yyyy-MM-dd').parse(date)),
                                        style: TextStyle(
                                          color: selectedDate == date ? Colors.black : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 當日詳細記錄
            Expanded(
              child: selectedDate == null
                  ? const Center(child: Text('無飲水紀錄'))
                  : ListView.builder(
                      itemCount: groupedRecords[selectedDate]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final record = groupedRecords[selectedDate]![index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.black),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 0,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            leading: Icon(_getIconForType(record.type)),
                            title: Text('${record.amount}ml'),
                            subtitle: Text(
                              DateFormat('HH:mm').format(record.timestamp),
                            ),
                            trailing: Theme(
                              data: Theme.of(context).copyWith(
                                popupMenuTheme: PopupMenuThemeData(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                  elevation: 0,
                                  color: Colors.white,
                                ),
                              ),
                              child: PopupMenuButton<String>(
                                offset: const Offset(-20, 0),
                                icon: const Icon(Icons.more_vert, color: Colors.black),
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    await _showEditDialog(context, drinkController, record);
                                  } else if (value == 'delete') {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('確認刪除'),
                                        content: const Text('確定要刪除這筆紀錄嗎？'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('取消'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('刪除'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      try {
                                        await drinkController.deleteRecord(record.id);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('紀錄已刪除')),
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('刪除失敗: $e')),
                                          );
                                        }
                                      }
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20, color: Colors.black),
                                        SizedBox(width: 8),
                                        Text('編輯', style: TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: Colors.black),
                                        SizedBox(width: 8),
                                        Text('刪除', style: TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'water':
        return Icons.water_drop;
      case 'tea':
        return Icons.emoji_food_beverage;
      case 'coffee':
        return Icons.coffee;
      default:
        return Icons.local_drink;
    }
  }
}
