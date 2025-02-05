import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  AuthController() {
    // 模擬初始化時的用戶資料
    _currentUser = UserModel(
      id: 'dummy-user-123',
      email: 'test@example.com',
      name: 'Test User',
      height: 170,
      weight: 60,
      age: 25,
      activityLevel: 'light',
      profileImageUrl: 'https://i.pinimg.com/736x/a5/1a/86/a51a860b9611219a6d28d2972f5a7826.jpg',
      dailyGoal: 2000,
      coins: 0,
      streak: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      achievements: _getDefaultAchievements(),
      totalDrinkCount: 0,
      quickAddOptions: const [
        QuickAddOption(amount: 100, type: 'water'),
        QuickAddOption(amount: 200, type: 'coffee'),
        QuickAddOption(amount: 300, type: 'water'),
        QuickAddOption(amount: 500, type: 'water'),
      ],
      currentAvatarUrl: 'https://i.pinimg.com/736x/22/c5/70/22c570dc951a0a6c9ce14a3fab858faa.jpg',
      avatars: [
        'https://i.pinimg.com/736x/22/c5/70/22c570dc951a0a6c9ce14a3fab858faa.jpg',
        'https://i.pinimg.com/736x/b9/ef/d2/b9efd29993586ca5fe4f5b8f8229a17e.jpg',
        'https://i.pinimg.com/736x/a3/4d/b5/a34db58869379f33e8b78ca7c5835762.jpg',
      ],
    );
    notifyListeners();
  }

  Future<void> signIn() async {
    try {
      // await _auth.signInWithPopup(GoogleAuthProvider());
      // 模擬登入
      _currentUser = UserModel(
        id: 'dummy-user-123',
        email: 'test@example.com',
        profileImageUrl: 'https://i.pinimg.com/736x/a5/1a/86/a51a860b9611219a6d28d2972f5a7826.jpg',
        name: 'Test User',
        height: 170,
        weight: 60,
        age: 25,
        activityLevel: 'medium',
        dailyGoal: 2000,
        coins: 0,
        streak: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        quickAddOptions: const [
          QuickAddOption(amount: 100, type: '水'),
          QuickAddOption(amount: 200, type: '水'),
          QuickAddOption(amount: 300, type: '水'),
          QuickAddOption(amount: 500, type: '水'),
        ],
        achievements: _getDefaultAchievements(),
        totalDrinkCount: 0,
        currentAvatarUrl: 'https://example.com/default-avatar.jpg',
        avatars: [
          'https://example.com/default-avatar.jpg',
          'https://example.com/avatar1.jpg',
          'https://example.com/avatar2.jpg',
        ],
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      // await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  List<Achievement> _getDefaultAchievements() {
    return [
      const Achievement(
        id: 'first_drink',
        title: '第一口',
        description: '記錄第一次飲水',
        icon: '0xe037', // local_drink
        isUnlocked: false,
      ),
      const Achievement(
        id: 'week_streak',
        title: '一週達人',
        description: '連續七天達成目標',
        icon: '0xe87e', // stars
        isUnlocked: false,
      ),
      const Achievement(
        id: 'perfect_month',
        title: '完美月份',
        description: '一個月內達成25天目標',
        icon: '0xe838', // emoji_events
        isUnlocked: true,
      ),
      // 可以添加更多預設成就...
    ];
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required double height,
    required double weight,
    required int age,
    required String activityLevel,
  }) async {
    try {
      // 使用 Firebase Auth 創建新用戶
      // final userCredential = await _auth.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      // 計算每日目標飲水量
      final dailyGoal = calculateDailyGoal(weight, activityLevel);

      // 創建用戶模型
      final user = UserModel(
        id: 'dummy-user-123', // userCredential.user!.uid,
        email: email,
        name: name,
        height: height,
        weight: weight,
        age: age,
        activityLevel: activityLevel,
        dailyGoal: dailyGoal,
        coins: 0,
        streak: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        achievements: _getDefaultAchievements(),
        totalDrinkCount: 0,
        quickAddOptions: const [
          QuickAddOption(amount: 100, type: 'coffee'),
          QuickAddOption(amount: 200, type: 'water'),
          QuickAddOption(amount: 300, type: 'water'),
          QuickAddOption(amount: 500, type: 'water'),
        ],
        currentAvatarUrl: 'https://example.com/default-avatar.jpg',
        avatars: [
          'https://example.com/default-avatar.jpg',
          'https://example.com/avatar1.jpg',
          'https://example.com/avatar2.jpg',
        ],
      );

      // 將用戶資料儲存到 Firestore
      // await _firestore.collection('users').doc(user.id).set(user.toFirestore());

      // 更新當前使用者
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  int calculateDailyGoal(double weight, String activityLevel) {
    // 基於體重和活動量計算每日建議飲水量（毫升）
    double multiplier = 30; // 基礎倍數

    switch (activityLevel) {
      case 'low':
        multiplier = 30;
        break;
      case 'medium':
        multiplier = 35;
        break;
      case 'high':
        multiplier = 40;
        break;
    }

    return (weight * multiplier).round();
  }

  Future<void> updateUserCoins(int newCoins) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        coins: newCoins,
        updatedAt: DateTime.now(),
      );
      // TODO: 當有 Firebase 時，更新到 Firestore
      // await _firestore.collection('users').doc(_currentUser!.id).update({
      //   'coins': newCoins,
      //   'updatedAt': DateTime.now(),
      // });
      notifyListeners();
    }
  }

  Future<void> updateUser(UserModel user) async {
    // TODO: Update user in Firestore
    _currentUser = user;
    notifyListeners();
  }
}
