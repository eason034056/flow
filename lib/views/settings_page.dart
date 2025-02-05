import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../controllers/quick_add_controller.dart';
import '../views/profile_edit_page.dart';
import '../views/privacy_policy_page.dart';
import '../views/terms_of_service_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      });
    } catch (e) {
      setState(() {
        _appVersion = '1.0.0'; // 預設版本號
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          // 帳號設定
          _buildSection(
            title: '帳號設定',
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('個人資料'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileEditPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('通知設定'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // 導航到通知設定頁面
                },
              ),
            ],
          ),

          // 快捷鍵設定
          _buildQuickAddSection(),

          // 一般設定
          _buildSection(
            title: '一般設定',
            children: [
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('語言'),
                trailing: const Text('繁體中文'),
                onTap: () {
                  // 語言設定
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text('深色模式'),
                trailing: Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    // 切換深色模式
                  },
                ),
              ),
            ],
          ),

          // 其他
          _buildSection(
            title: '其他',
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('關於'),
                trailing: Text(_appVersion),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AboutDialog(
                      applicationName: 'Flow 飲水紀錄',
                      applicationVersion: _appVersion,
                      applicationIcon: Image.asset(
                        'assets/app_icon.png',
                        width: 50,
                        height: 50,
                      ),
                      children: const [
                        SizedBox(height: 16),
                        Text(
                          'Flow 是一款幫助您追蹤每日飲水量的應用程式。透過簡單的介面和智能提醒，讓您輕鬆養成良好的飲水習慣。',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '功能特色：',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• 每日飲水追蹤\n'
                          '• 個人化飲水目標\n'
                          '• 成就系統\n'
                          '• 數據統計與分析\n'
                          '• 客製化提醒',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '© 2024 Flow Team. All rights reserved.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('隱私權政策'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('使用條款'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsOfServicePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('登出'),
                onTap: () {
                  _showLogoutDialog();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Future<void> _showQuickAddDialog(int index) async {
    final quickAddController = context.read<QuickAddController>();
    final options = quickAddController.options;

    final TextEditingController amountController = TextEditingController(
      text: options[index].amount.toString(),
    );
    final TextEditingController typeController = TextEditingController(
      text: options[index].type,
    );

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('設定快捷鍵 ${index + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '飲水量 (ml)',
                suffixText: 'ml',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: typeController.text,
              decoration: const InputDecoration(
                labelText: '飲水類型',
              ),
              items: const [
                DropdownMenuItem(value: 'water', child: Text('水')),
                DropdownMenuItem(value: 'coffee', child: Text('咖啡')),
                DropdownMenuItem(value: 'tea', child: Text('茶')),
                DropdownMenuItem(value: 'juice', child: Text('手搖杯')),
              ],
              onChanged: (value) {
                if (value != null) {
                  typeController.text = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final newAmount = int.tryParse(amountController.text);
              final newType = typeController.text;
              if (newAmount != null && newAmount > 0 && newType.isNotEmpty) {
                quickAddController.updateOption(
                  index,
                  QuickAddOption(
                    amount: newAmount,
                    type: newType,
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddSection() {
    return Consumer<QuickAddController>(
      builder: (context, controller, child) {
        return _buildSection(
          title: '快捷鍵設定',
          children: List.generate(
            controller.options.length,
            (index) => ListTile(
              leading: const Icon(Icons.water_drop_outlined),
              title: Text('快捷鍵 ${index + 1}'),
              subtitle: Text(controller.options[index].type),
              trailing: Text('${controller.options[index].amount}ml'),
              onTap: () {
                _showQuickAddDialog(index);
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('登出'),
        content: const Text('確定要登出嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthController>().signOut();
              Navigator.pop(context);
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }
}
