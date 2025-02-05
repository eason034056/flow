import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow/controllers/auth_controller.dart';
import 'package:flow/controllers/drink_record_controller.dart';
import 'package:flow/views/user_info_card.dart';
import 'package:flow/views/water_progress_circle.dart';
import 'package:flow/views/quick_add_buttons.dart';
import 'package:flow/views/add_drink_sheet.dart';
import 'package:flow/models/drink_record_model.dart';
import 'package:flow/views/drink_records_page.dart';
import 'package:flow/views/shop_page.dart';
import 'package:flow/views/rewards_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // 主頁面內容
  Widget _buildMainContent() {
    return Consumer<DrinkRecordController>(
      builder: (context, controller, child) {
        final user = context.watch<AuthController>().currentUser;
        if (user == null) return const Center(child: CircularProgressIndicator());

        final progress = controller.todayTotal / user.dailyGoal;

        return Column(
          children: [
            // 進度圓環和文字卡片
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  '今日進度',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 2; // 新增索引值為飲水紀錄頁面
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 32.0, 0.0),
                      child: Row(
                        children: [
                          // 左側文字資訊
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '今日飲水量',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${controller.todayTotal.toInt()} ml',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '目標: ${user.dailyGoal} ml',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // 右側進度圓環
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: WaterProgressCircle(
                              progress: progress,
                              current: controller.todayTotal.toDouble(),
                              goal: user.dailyGoal.toDouble(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 快捷按鈕
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  '快速紀錄',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: QuickAddButtons(
                options: user.quickAddOptions,
                onAdd: (amount, type) {
                  controller.addRecord(
                    DrinkRecord(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      userId: user.id,
                      amount: amount.toInt(),
                      timestamp: DateTime.now(),
                      type: type,
                      source: 'quick_add',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthController>(
          builder: (context, authController, child) {
            final user = authController.currentUser;
            if (user == null) return const SizedBox();

            return UserInfoCard(user: user);
          },
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Consumer2<AuthController, DrinkRecordController>(
              builder: (context, authController, drinkController, child) {
                final user = authController.currentUser;
                if (user == null) return const SizedBox();

                final rewardCount = drinkController.getAvailableRewardsCount(user);

                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.card_giftcard),
                      iconSize: 30,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 3; // 新增索引值為獎勵頁面
                        });
                      },
                    ),
                    if (rewardCount > 0)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            '$rewardCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildMainContent(),
          const ShopPage(),
          const DrinkRecordsPage(), // 新增飲水紀錄頁面
          const RewardsPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.0,
        color: Colors.transparent,
        height: 70.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              iconSize: 25,
              color: _currentIndex == 0 ? Theme.of(context).primaryColor : null,
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  size: 25,
                  color: Colors.black,
                ),
                iconSize: 25,
                splashRadius: 24,
                padding: const EdgeInsets.all(8),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    builder: (context) => const AddDrinkSheet(),
                  );
                },
              ),
            ),
            // 為中間的 FAB 留空間
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              iconSize: 25,
              color: _currentIndex == 1 ? Theme.of(context).primaryColor : null,
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
