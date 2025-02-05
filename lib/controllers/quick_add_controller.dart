import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class QuickAddController extends ChangeNotifier {
  final AuthController _authController;

  QuickAddController(this._authController) {
    _initializeOptions();
  }

  List<QuickAddOption> _options = [];
  List<QuickAddOption> get options => List.unmodifiable(_options);

  void _initializeOptions() {
    final user = _authController.currentUser;
    if (user != null) {
      _options = List.from(user.quickAddOptions);
      notifyListeners();
    }
  }

  Future<void> updateOption(int index, QuickAddOption option) async {
    if (index >= 0 && index < _options.length) {
      _options[index] = option;

      // 更新使用者資料
      final user = _authController.currentUser;
      if (user != null) {
        final updatedUser = user.copyWith(
          quickAddOptions: List.from(_options),
          updatedAt: DateTime.now(),
        );
        await _authController.updateUser(updatedUser);
      }

      notifyListeners();
    }
  }
}
