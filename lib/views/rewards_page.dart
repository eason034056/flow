import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/drink_record_controller.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  List<Map<String, dynamic>> _getAvailableRewards(BuildContext context) {
    final drinkController = context.read<DrinkRecordController>();
    final todayTotal = drinkController.todayTotal;
    final records = drinkController.records;
    final user = context.read<AuthController>().currentUser;

    if (user == null) return [];

    final List<Map<String, dynamic>> rewards = [];

    // 檢查每日目標達成獎勵
    if (todayTotal >= user.dailyGoal && !drinkController.isRewardCollected('daily_goal')) {
      rewards.add({
        'id': 'daily_goal',
        'title': '達成每日目標',
        'description': '完成今日飲水目標',
        'points': 50,
        'icon': Icons.local_drink,
      });
    }

    // 檢查頻率達人獎勵
    if (records.length >= 6 && !drinkController.isRewardCollected('frequency_master')) {
      rewards.add({
        'id': 'frequency_master',
        'title': '均衡達人',
        'description': '單日內分散飲水時間達到 6 次',
        'points': 80,
        'icon': Icons.balance,
      });
    }

    // 檢查累計飲水量獎勵
    if (records.fold<int>(0, (sum, record) => sum + record.amount) >= 100000 && !drinkController.isRewardCollected('volume_master')) {
      rewards.add({
        'id': 'volume_master',
        'title': '喝水大師',
        'description': '累計飲水量達到 100 公升',
        'points': 200,
        'icon': Icons.emoji_events,
      });
    }

    return rewards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthController, DrinkRecordController>(
        builder: (context, authController, drinkController, child) {
          final user = authController.currentUser;
          if (user == null) {
            return const Center(child: Text('請先登入'));
          }

          final rewards = _getAvailableRewards(context);

          if (rewards.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('目前沒有可領取的獎勵'),
                  Text('繼續保持喝水習慣來解鎖更多成就！'),
                ],
              ),
            );
          }

          return Column(
            children: [
              // 獎勵列表
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: rewards.length,
                  itemBuilder: (context, index) {
                    final reward = rewards[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                      child: ListTile(
                        leading: Icon(
                          reward['icon'] as IconData,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        title: Text(reward['title'] as String),
                        subtitle: Text(reward['description'] as String),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            // 領取獎勵
                            final newCoins = user.coins + (reward['points'] as int);
                            await authController.updateUserCoins(newCoins);

                            // 標記獎勵為已領取
                            drinkController.markRewardAsCollected(reward['id'] as String);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('恭喜獲得 ${reward['points']} 金幣！'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          child: Text('領取 ${reward['points']} 金幣'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
