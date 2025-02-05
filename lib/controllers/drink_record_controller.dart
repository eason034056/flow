// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/drink_record_model.dart';
import '../models/user_model.dart';

class DrinkRecordController extends ChangeNotifier {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DrinkRecord> _records = [];

  // 追蹤已領取的獎勵
  final Set<String> _collectedRewards = {};

  List<DrinkRecord> get records => _records;

  int get todayTotal {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    return _records.where((record) => record.timestamp.isAfter(startOfDay)).fold(0, (sum, record) => sum + record.amount);
  }

  DrinkRecordController() {
    loadRecords();
  }

  Future<void> loadRecords() async {
    // final QuerySnapshot snapshot = await _firestore
    //     .collection('drink_records')
    //     .orderBy('timestamp', descending: true)
    //     .get();

    // _records = snapshot.docs
    //     .map((doc) => DrinkRecordModel.fromMap(doc.data() as Map<String, dynamic>))
    //     .toList();

    // 使用模擬資料
    _records = [
      DrinkRecord(
        id: 'record-1',
        userId: 'dummy-user-123',
        type: 'coffee',
        source: 'manual',
        amount: 250,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DrinkRecord(
        id: 'record-2',
        userId: 'dummy-user-123',
        type: 'water',
        source: 'manual',
        amount: 500,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      DrinkRecord(
        id: 'record-3',
        userId: 'dummy-user-123',
        type: 'tea',
        source: 'manual',
        amount: 350,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      DrinkRecord(
        id: 'record-4',
        userId: 'dummy-user-123',
        type: 'water',
        source: 'manual',
        amount: 300,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      DrinkRecord(
        id: 'record-5',
        userId: 'dummy-user-123',
        type: 'juice',
        source: 'manual',
        amount: 400,
        timestamp: DateTime.now().subtract(const Duration(hours: 24)),
      ),
      DrinkRecord(
        id: 'record-6',
        userId: 'dummy-user-123',
        type: 'water',
        source: 'manual',
        amount: 500,
        timestamp: DateTime.now().subtract(const Duration(hours: 26)),
      ),
      DrinkRecord(
        id: 'record-7',
        userId: 'dummy-user-123',
        type: 'tea',
        source: 'manual',
        amount: 250,
        timestamp: DateTime.now().subtract(const Duration(hours: 28)),
      ),
      DrinkRecord(
        id: 'record-8',
        userId: 'dummy-user-123',
        type: 'water',
        source: 'manual',
        amount: 600,
        timestamp: DateTime.now().subtract(const Duration(hours: 48)),
      ),
      DrinkRecord(
        id: 'record-9',
        userId: 'dummy-user-123',
        type: 'coffee',
        source: 'manual',
        amount: 200,
        timestamp: DateTime.now().subtract(const Duration(hours: 50)),
      ),
      DrinkRecord(
        id: 'record-10',
        userId: 'dummy-user-123',
        type: 'water',
        source: 'manual',
        amount: 450,
        timestamp: DateTime.now().subtract(const Duration(hours: 52)),
      ),
      DrinkRecord(
        id: 'record-11',
        userId: 'dummy-user-123',
        type: 'tea',
        source: 'manual',
        amount: 300,
        timestamp: DateTime.now().subtract(const Duration(hours: 54)),
      ),
      DrinkRecord(
        id: 'record-12',
        userId: 'dummy-user-123',
        type: 'coffee',
        source: 'manual',
        amount: 250,
        timestamp: DateTime.now().subtract(const Duration(hours: 56)),
      ),
      DrinkRecord(
        id: 'record-13',
        userId: 'dummy-user-123',
        type: 'water',
        source: 'manual',
        amount: 500,
        timestamp: DateTime.now().subtract(const Duration(hours: 58)),
      ),
      DrinkRecord(
        id: 'record-14',
        userId: 'dummy-user-123',
        type: 'juice',
        source: 'manual',
        amount: 350,
        timestamp: DateTime.now().subtract(const Duration(hours: 60)),
      ),
      DrinkRecord(
        id: 'record-15',
        userId: 'dummy-user-123',
        type: 'water',
        source: 'manual',
        amount: 400,
        timestamp: DateTime.now().subtract(const Duration(hours: 62)),
      ),
      DrinkRecord(
        id: 'record-16',
        userId: 'dummy-user-123',
        type: 'tea',
        source: 'manual',
        amount: 250,
        timestamp: DateTime.now().subtract(const Duration(hours: 64)),
      ),
      DrinkRecord(
        id: 'record-17',
        userId: 'dummy-user-123',
        type: 'coffee',
        source: 'manual',
        amount: 200,
        timestamp: DateTime.now().subtract(const Duration(hours: 66)),
      ),
      DrinkRecord(
        id: 'record-18',
        userId: 'dummy-user-123',
        type: 'water',
        source: 'manual',
        amount: 500,
        timestamp: DateTime.now().subtract(const Duration(hours: 68)),
      ),
      DrinkRecord(
        id: 'record-19',
        userId: 'dummy-user-123',
        type: 'juice',
        source: 'manual',
        amount: 300,
        timestamp: DateTime.now().subtract(const Duration(hours: 70)),
      ),
      DrinkRecord(
        id: 'record-20',
        userId: 'dummy-user-123',
        type: 'water',
        source: 'manual',
        amount: 450,
        timestamp: DateTime.now().subtract(const Duration(hours: 72)),
      ),
      DrinkRecord(
        id: 'record-21',
        userId: 'dummy-user-123',
        type: 'tea',
        source: 'manual',
        amount: 200,
        timestamp: DateTime.now().subtract(const Duration(hours: 74)),
      ),
      DrinkRecord(
        id: 'record-22',
        userId: 'dummy-user-123',
        type: 'coffee',
        source: 'manual',
        amount: 250,
        timestamp: DateTime.now().subtract(const Duration(hours: 76)),
      ),
      DrinkRecord(
        id: 'record-23',
        userId: 'dummy-user-123',
        type: 'water',
        source: 'manual',
        amount: 550,
        timestamp: DateTime.now().subtract(const Duration(hours: 78)),
      ),
      DrinkRecord(
        id: 'record-24',
        userId: 'dummy-user-123',
        type: 'juice',
        source: 'manual',
        amount: 350,
        timestamp: DateTime.now().subtract(const Duration(hours: 80)),
      ),
    ];
    notifyListeners();
  }

  Future<void> addRecord(DrinkRecord record) async {
    // await _firestore.collection('drink_records').add(record.toMap());
    // await loadRecords();

    // 直接將新紀錄加入列表
    _records.insert(0, record);
    notifyListeners();
  }

  Future<void> updateRecord(
    String recordId, {
    required int amount,
    required String type,
    required DateTime timestamp,
  }) async {
    try {
      // 找到要更新的記錄
      final index = _records.indexWhere((record) => record.id == recordId);
      if (index == -1) return;

      // 創建更新後的記錄
      final updatedRecord = _records[index].copyWith(
        amount: amount,
        type: type,
        timestamp: timestamp,
      );

      // 更新記錄
      _records[index] = updatedRecord;

      // TODO: 當有 Firebase 時，更新到 Firestore
      // await _firestore.collection('drink_records').doc(recordId).update({
      //   'amount': amount,
      //   'type': type,
      //   'timestamp': timestamp,
      // });

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating record: $e');
      rethrow;
    }
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      // 從列表中移除記錄
      _records.removeWhere((record) => record.id == recordId);

      // TODO: 當有 Firebase 時，從 Firestore 刪除
      // await _firestore.collection('drink_records').doc(recordId).delete();

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting record: $e');
      rethrow;
    }
  }

  // 檢查獎勵是否已領取
  bool isRewardCollected(String rewardId) {
    return _collectedRewards.contains(rewardId);
  }

  // 標記獎勵為已領取
  void markRewardAsCollected(String rewardId) {
    _collectedRewards.add(rewardId);
    notifyListeners();
  }

  int getAvailableRewardsCount(UserModel user) {
    int count = 0;

    // 檢查每日目標達成獎勵
    if (todayTotal >= user.dailyGoal && !isRewardCollected('daily_goal')) {
      count++;
    }

    // 檢查頻率達人獎勵
    if (records.length >= 6 && !isRewardCollected('frequency_master')) {
      count++;
    }

    // 檢查累計飲水量獎勵
    if (records.fold<int>(0, (sum, record) => sum + record.amount) >= 100000 && !isRewardCollected('volume_master')) {
      count++;
    }

    return count;
  }
}
