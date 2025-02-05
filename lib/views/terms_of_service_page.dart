import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

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
            '使用條款',
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
          _TermsSection(
            title: '1. 服務說明',
            content: '''Flow 是一款飲水追蹤應用程式，提供以下服務：
• 每日飲水量追蹤與記錄
• 個人化飲水目標設定
• 成就系統與獎勵機制
• 飲水提醒功能
• 數據統計與分析''',
          ),
          _TermsSection(
            title: '2. 帳號註冊與使用',
            content: '''使用本服務需要註冊帳號，您同意：
• 提供真實、準確、完整的個人資料
• 妥善保管您的帳號密碼
• 對您帳號下的所有活動負責
• 發現未授權使用立即通知我們''',
          ),
          _TermsSection(
            title: '3. 使用規範',
            content: '''使用本服務時，您同意不會：
• 違反任何法律法規
• 侵犯他人智慧財產權
• 上傳惡意程式或病毒
• 干擾服務運作
• 從事任何未經授權的商業行為''',
          ),
          _TermsSection(
            title: '4. 智慧財產權',
            content: '''Flow 應用程式的所有內容，包括但不限於：
• 程式碼
• 介面設計
• 圖示與圖片
• 文字內容
均受智慧財產權法保護，未經許可不得使用。''',
          ),
          _TermsSection(
            title: '5. 服務變更與終止',
            content: '''我們保留以下權利：
• 修改或終止服務內容
• 調整服務收費標準
• 限制特定功能的使用
• 刪除違規內容
• 停用違規帳號''',
          ),
          _TermsSection(
            title: '6. 免責聲明',
            content: '''本應用程式提供的建議僅供參考，我們不對以下情況負責：
• 使用者未達到預期目標
• 因使用本服務造成的任何損失
• 第三方連結或服務的可用性
• 因不可抗力導致的服務中斷''',
          ),
          _TermsSection(
            title: '7. 資料備份',
            content: '雖然我們會定期備份資料，但建議您定期自行備份重要資料。我們不對資料遺失負責。',
          ),
          _TermsSection(
            title: '8. 條款修改',
            content: '我們可能會不定期修改使用條款，修改後的條款將在應用程式內公告。繼續使用本服務即表示同意修改後的條款。',
          ),
          _TermsSection(
            title: '9. 準據法',
            content: '本使用條款的解釋與適用，以及與本服務相關的爭議，均受中華民國法律管轄。',
          ),
          _TermsSection(
            title: '10. 聯絡方式',
            content: '如對本使用條款有任何疑問，請聯絡我們的客服團隊。',
          ),
        ],
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  final String title;
  final String content;

  const _TermsSection({
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
