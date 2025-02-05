// import 'package:cloud_firestore/cloud_firestore.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}

class QuickAddOption {
  final int amount;
  final String type;

  const QuickAddOption({
    required this.amount,
    required this.type,
  });

  factory QuickAddOption.fromMap(Map<String, dynamic> map) {
    return QuickAddOption(
      amount: map['amount'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
    };
  }
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? currentAvatarUrl;
  final String? profileImageUrl;
  final double height;
  final double weight;
  final int age;
  final String activityLevel;
  final int dailyGoal;
  final int coins;
  final int streak;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Achievement> achievements;
  final int totalDrinkCount;
  final List<QuickAddOption> quickAddOptions;
  final List<String> avatars;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.currentAvatarUrl,
    this.profileImageUrl,
    required this.height,
    required this.weight,
    required this.age,
    required this.activityLevel,
    required this.dailyGoal,
    required this.coins,
    required this.createdAt,
    required this.updatedAt,
    required this.streak,
    this.achievements = const [],
    this.totalDrinkCount = 0,
    this.quickAddOptions = const [],
    this.avatars = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      currentAvatarUrl: json['currentAvatarUrl'],
      profileImageUrl: json['profileImageUrl'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      age: json['age'],
      activityLevel: json['activityLevel'],
      dailyGoal: json['dailyWaterGoal'],
      coins: json['coins'],
      streak: json['streak'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      achievements: (json['achievements'] as List<dynamic>?)?.map((e) => Achievement.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      totalDrinkCount: json['totalDrinkCount'] ?? 0,
      quickAddOptions: (json['quickAddOptions'] as List<dynamic>?)?.map((e) => QuickAddOption.fromMap(e as Map<String, dynamic>)).toList() ??
          const [
            QuickAddOption(amount: 100, type: '水'),
            QuickAddOption(amount: 200, type: '水'),
            QuickAddOption(amount: 300, type: '水'),
            QuickAddOption(amount: 500, type: '水'),
          ],
      avatars: (json['avatars'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'currentAvatarUrl': currentAvatarUrl,
      'height': height,
      'weight': weight,
      'age': age,
      'activityLevel': activityLevel,
      'dailyWaterGoal': dailyGoal,
      'coins': coins,
      'streak': streak,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'achievements': achievements.map((e) => e.toJson()).toList(),
      'totalDrinkCount': totalDrinkCount,
      'quickAddOptions': quickAddOptions.map((e) => e.toMap()).toList(),
      'avatars': avatars,
    };
  }

  UserModel copyWith({
    String? email,
    String? name,
    String? currentAvatarUrl,
    String? profileImageUrl,
    double? height,
    double? weight,
    int? age,
    String? activityLevel,
    int? dailyGoal,
    int? coins,
    int? streak,
    DateTime? updatedAt,
    List<Achievement>? achievements,
    int? totalDrinkCount,
    List<QuickAddOption>? quickAddOptions,
    List<String>? avatars,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      currentAvatarUrl: currentAvatarUrl ?? this.currentAvatarUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      coins: coins ?? this.coins,
      streak: streak ?? this.streak,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      achievements: achievements ?? this.achievements,
      totalDrinkCount: totalDrinkCount ?? this.totalDrinkCount,
      quickAddOptions: quickAddOptions ?? this.quickAddOptions,
      avatars: avatars ?? this.avatars,
    );
  }
}
