import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLOW'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            '隱私權政策',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            '最後更新日期：2024年3月1日',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 24),
          _PolicySection(
            title: '1. 資料收集',
            content: '''我們收集的個人資料包括：
• 基本資料：姓名、電子郵件
• 身體數據：年齡、身高、體重
• 活動數據：每日飲水量、飲水類型、飲水時間
• 使用者設定：每日飲水目標、快捷鍵設定
            
這些資料用於提供個人化的飲水建議和追蹤服務。''',
          ),
          _PolicySection(
            title: '2. 資料使用',
            content: '''我們使用您的資料來：
• 追蹤和分析您的飲水習慣
• 提供個人化的飲水建議
• 計算並顯示您的飲水進度
• 提供成就系統和獎勵機制
• 改善我們的服務品質''',
          ),
          _PolicySection(
            title: '3. 資料保護',
            content: '''我們採取以下措施保護您的資料：
• 使用加密技術保護資料傳輸
• 定期備份資料
• 限制資料存取權限
• 定期檢查和更新安全措施''',
          ),
          _PolicySection(
            title: '4. 資料分享',
            content: '''我們不會與第三方分享您的個人資料，除非：
• 您明確同意
• 法律要求
• 為提供服務所必需（如雲端儲存服務）''',
          ),
          _PolicySection(
            title: '5. 使用者權利',
            content: '''您擁有以下權利：
• 查看您的個人資料
• 更正不正確的資料
• 刪除您的帳號和相關資料
• 要求匯出您的資料
• 隨時撤回同意''',
          ),
          _PolicySection(
            title: '6. Cookie 使用',
            content: '我們使用 Cookie 來改善使用體驗，包括記住您的登入狀態和偏好設定。',
          ),
          _PolicySection(
            title: '7. 資料保留',
            content: '我們會在您使用服務期間保留您的資料。如果您刪除帳號，我們會在30天內完全刪除您的個人資料。',
          ),
          _PolicySection(
            title: '8. 隱私權政策更新',
            content: '我們可能會不定期更新隱私權政策。重大變更時，我們會通知您並徵求同意。',
          ),
          _PolicySection(
            title: '9. 聯絡我們',
            content: '如果您對隱私權政策有任何疑問，請聯絡我們的支援團隊。',
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
