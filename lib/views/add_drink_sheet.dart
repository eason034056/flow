import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow/controllers/drink_record_controller.dart';
import 'package:flow/controllers/auth_controller.dart';
import 'package:flow/models/drink_record_model.dart';

class AddDrinkSheet extends StatefulWidget {
  const AddDrinkSheet({super.key});

  @override
  State<AddDrinkSheet> createState() => _AddDrinkSheetState();
}

class _AddDrinkSheetState extends State<AddDrinkSheet> {
  final _formKey = GlobalKey<FormState>();
  String _amount = ''; // 改用 String 來存儲輸入值
  String _selectedType = 'water';

  @override
  void dispose() {
    super.dispose();
  }

  void _addNumber(String number) {
    setState(() {
      if (_amount.length < 4) {
        // 限制最大輸入長度為4位數
        _amount += number;
      }
    });
  }

  void _deleteNumber() {
    setState(() {
      if (_amount.isNotEmpty) {
        _amount = _amount.substring(0, _amount.length - 1);
      }
    });
  }

  void _submit() {
    if (_amount.isEmpty) return;

    final amount = int.parse(_amount);
    if (amount <= 0) return;

    final userId = context.read<AuthController>().currentUser?.id;
    if (userId == null) return;

    context.read<DrinkRecordController>().addRecord(
          DrinkRecord(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: userId,
            amount: amount,
            timestamp: DateTime.now(),
            type: _selectedType,
            source: 'manual',
          ),
        );

    Navigator.pop(context);
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
              shadowColor: Colors.black,
            ),
            onPressed: () => _addNumber(number),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                '新增飲水紀錄(ml)',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                _amount.isEmpty ? '0' : _amount,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: '飲品類型',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  items: [
                    DropdownMenuItem(
                      value: 'water',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.water_drop, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          const Text('水'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'tea',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.emoji_food_beverage, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          const Text('茶'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'coffee',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.coffee, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          const Text('咖啡'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'juice',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_drink, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          const Text('手搖杯'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedType = value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              // 自定義數字鍵盤
              Row(
                children: [
                  _buildNumberButton('1'),
                  _buildNumberButton('2'),
                  _buildNumberButton('3'),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  _buildNumberButton('4'),
                  _buildNumberButton('5'),
                  _buildNumberButton('6'),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  _buildNumberButton('7'),
                  _buildNumberButton('8'),
                  _buildNumberButton('9'),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(), // 空白佔位
                    ),
                  ),
                  _buildNumberButton('0'),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: ElevatedButton(
                          onPressed: _deleteNumber,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            elevation: 0,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Icon(
                            Icons.backspace,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('確認', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
