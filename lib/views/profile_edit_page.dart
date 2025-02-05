import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow/controllers/auth_controller.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;
  late TextEditingController _dailyGoalController;
  String _selectedActivityLevel = '輕度活動';

  final Map<String, String> _activityLevels = {
    'sedentary': '久坐',
    'light': '輕度活動',
    'moderate': '中度活動',
    'active': '重度活動',
  };

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthController>().currentUser!;
    _nameController = TextEditingController(text: user.name);
    _heightController = TextEditingController(text: user.height.toString());
    _weightController = TextEditingController(text: user.weight.toString());
    _ageController = TextEditingController(text: user.age.toString());
    _dailyGoalController = TextEditingController(text: user.dailyGoal.toString());
    _selectedActivityLevel = user.activityLevel;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _dailyGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編輯個人資料'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('儲存'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 頭像區域
                Center(
                  child: Stack(
                    children: [
                      Consumer<AuthController>(
                        builder: (context, controller, child) {
                          final user = controller.currentUser;
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: user?.profileImageUrl != null ? NetworkImage(user!.profileImageUrl!) : null,
                            child: user?.profileImageUrl == null ? const Icon(Icons.person, size: 50) : null,
                          );
                        },
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 基本資料表單
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '名稱',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入名稱';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _heightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: '身高 (cm)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入身高';
                          }
                          final height = double.tryParse(value);
                          if (height == null || height <= 0) {
                            return '請輸入有效的身高';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: '體重 (kg)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入體重';
                          }
                          final weight = double.tryParse(value);
                          if (weight == null || weight <= 0) {
                            return '請輸入有效的體重';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '年齡',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入年齡';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age <= 0) {
                      return '請輸入有效的年齡';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedActivityLevel,
                  decoration: const InputDecoration(
                    labelText: '活動量',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                  items: _activityLevels.entries
                      .map((e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedActivityLevel = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _dailyGoalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '每日目標 (ml)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入每日目標';
                    }
                    final goal = int.tryParse(value);
                    if (goal == null || goal <= 0) {
                      return '請輸入有效的目標量';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authController = context.read<AuthController>();
      final user = authController.currentUser;

      if (user != null) {
        final updatedUser = user.copyWith(
          name: _nameController.text,
          height: double.parse(_heightController.text),
          weight: double.parse(_weightController.text),
          age: int.parse(_ageController.text),
          activityLevel: _selectedActivityLevel,
          dailyGoal: int.parse(_dailyGoalController.text),
          updatedAt: DateTime.now(),
        );

        try {
          await authController.updateUser(updatedUser);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('個人資料已更新')),
            );
            Navigator.pop(context);
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('更新失敗: $e')),
            );
          }
        }
      }
    }
  }
}
