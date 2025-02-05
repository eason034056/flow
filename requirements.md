# 記錄喝水App需求規格 (基於 MVC)

本文件詳細規範了使用 Flutter 開發的「記錄喝水 App」之功能與架構。此專案將依照 MVC 模型進行，以利後續開發與維護。本文件將從整體功能需求、系統架構 (MVC) 到各功能模組詳細說明。

---

## 目錄
1. [專案簡介](#專案簡介)
2. [功能概述](#功能概述)
3. [系統架構 - MVC](#系統架構---mvc)
4. [詳細功能規格](#詳細功能規格)
    1. [註冊與登入頁面](#1-註冊與登入頁面)
    2. [藍牙連線功能 (智能水壺)](#2-藍牙連線功能-智能水壺)
    3. [詳細飲水紀錄頁面](#3-詳細飲水紀錄頁面)
    4. [主頁面](#4-主頁面)
    5. [底層 Nav Bar](#5-底層-nav-bar)
    6. [快捷鍵設定與紀錄功能](#6-快捷鍵設定與紀錄功能)
    7. [自訂飲水紀錄 (加號按鈕)](#7-自訂飲水紀錄-加號按鈕)
    8. [定時推送飲水提醒](#8-定時推送飲水提醒)
    9. [領取獎勵頁面](#9-領取獎勵頁面)
    10. [設定頁面](#10-設定頁面)
    11. [商店頁面](#11-商店頁面)
5. [資料庫結構 (Model)](#資料庫結構-model)
6. [View: UI/UX 指南](#view-uiux-指南)
7. [Controller: 邏輯與流程說明](#controller-邏輯與流程說明)
8. [開發方法與注意事項](#開發方法與注意事項)
9. [未來延伸功能](#未來延伸功能)
10. [版本管理](#版本管理)

---

## 專案簡介
「記錄喝水App」的目標是讓使用者能夠輕鬆記錄每日飲水量，並可透過與「智能水壺」連線，達到自動同步飲水數據的效果。使用者可在主頁面一目了然地查看當日已喝水量與目標，同時能透過簡單的操作快速記錄、修改、或刪除飲水資料。

---

## 功能概述
1. **註冊登入**: 輸入身高、體重、年齡、活動量，系統自動計算每日目標飲水量。
2. **藍牙連線**: 連接智能水壺，水壺按鈕可自動回傳飲水量至App。
3. **飲水紀錄**: 可瀏覽、編輯、刪除詳細的飲水記錄。
4. **主頁**:
   - 顯示個人資訊 (頭像、姓名)
   - 顯示每日目標飲水量、已完成量之視覺化
   - 提供四個快捷添加按鈕
   - 連結獎勵領取頁面按鈕
   - 連接智能水壺按鈕
5. **底部 Nav Bar**: 包含主畫面、加號按鈕(直接記錄)與設定頁面。
6. **定時推播**: 提醒使用者喝水。
7. **獎勵機制**: 每日達成目標可領取金幣，並可在商店購買物品。
8. **設定頁面**: 可調整快捷按鈕的預設飲水量、種類等。
9. **商店**: 使用金幣購買商品。
10. **多語系或其他進階功能**(未來可考慮)。

---

## 系統架構 - MVC

1. **Model (資料層)**:
   - 使用 Firebase 作為後端資料庫
   - 負責處理資料庫存取、資料模型定義 (如飲水紀錄、使用者資料、獎勵機制等)。
2. **View (視圖層)**:
   - Flutter 前端UI，顯示主頁面、詳細紀錄頁面、商店頁面等。 
   - 負責接收使用者操作並呈現資料。
3. **Controller (控制層)**:
   - 負責業務邏輯、資料處理流程。 
   - 接收 View 的使用者操作，呼叫 Model 進行資料存取與運算，回傳處理結果給 View。

---

## 詳細功能規格

### 1. 註冊與登入頁面
- **需求**:
  - 使用 Firebase Authentication 進行用戶驗證
  - 使用者需先登入或註冊，無法跳過。
  - 使用者註冊時提供身高、體重、年齡、活動量 (可用選單或文字輸入)。
  - 系統根據此四項資訊自動計算每日目標飲水量 (具體計算方式可由健康指標或公式，預留擴充)。
  - 登入成功後可在應用程式中持續使用。

- **View**:
  - 註冊/登入頁面 UI，包含表單與驗證 (信箱、密碼等)。
  - 提示使用者身高、體重、年齡、活動量輸入欄位。
  
- **Controller**:
  - `AuthController` 負責處理註冊與登入，串接 Firebase Authentication。
  - 註冊成功後，將計算後的每日目標飲水量存入 Firestore。

- **Model**:
  - `UserModel`: 儲存使用者的基礎資訊 (身高、體重、年齡、活動量、目標飲水量等)。


### 2. 藍牙連線功能 (智能水壺)
- **需求**:
  - 使用者可點擊「連接智能水壺」按鈕進行藍牙配對。
  - 完成配對後，當用戶按下水壺按鈕時，自動將飲水量回傳給App並紀錄。
  - 預留函式與藍牙套件(如 `flutter_blue` 或其他)實作連接。

- **View**:
  - 在主頁面或設定頁面提供「連接智能水壺」的按鈕與狀態顯示(已連線/未連線)。

- **Controller**:
  - `BluetoothController` 負責掃描裝置、連線、接收水壺傳回的數據，並呼叫 `DrinkRecordController` 進行資料儲存。

- **Model**:
  - 可於 Firestore 的 devices collection 內紀錄水壺裝置資訊 (如MAC Address、狀態等)。
  - 透過 `DrinkRecordModel` 更新飲水數據至 Firestore。


### 3. 詳細飲水紀錄頁面
- **需求**:
  - 顯示使用者每次的飲水記錄 (時間、飲水量、來源)。
  - 支援刪除與修改既有紀錄。
  - 刪除後需更新當前主頁的已喝水量。
  - 修改後需同步更新當前主頁的已喝水量。

- **View**:
  - 可使用ListView或類似元件顯示歷史紀錄。
  - 點擊某筆紀錄可進入編輯 (彈出對話框或跳至新頁)。

- **Controller**:
  - `DrinkRecordController` 的 `getRecords()`, `updateRecord()`, `deleteRecord()` 等方法。
  - 刪除或更新後回傳給View使UI刷新。

- **Model**:
  - Firestore 的 drinkRecords collection: `id`, `userId`, `amount`, `timestamp`, 以及可能的來源欄位 (如: 手動添加, 水壺自動添加)。


### 4. 主頁面
- **需求**:
  1. **用戶頭像、用戶名稱**  
  2. **連接獎勵領取頁面按鈕**  
  3. **用戶每日目標飲水量**  
  4. **今日已喝水量視覺化呈現** (如進度條或環形圖)  
  5. **四個快捷添加按鈕** (預設 100ml, 200ml, 300ml, 500ml，未來可自訂)  
  6. **連接智能水壺按鈕** (顯示連線狀態與連接操作)

- **View**:
  - 主頁面UI依使用者資訊動態呈現。
  - 飲水量進度可用圓形進度條或水平進度條顯示。

- **Controller**:
  - `UserController` 從 Firestore 取得當前用戶資訊 (頭像、名稱、目標飲水量)。
  - `DrinkRecordController` 計算當日已喝水量並回傳給View。
  - `BluetoothController` 連接/斷開智能水壺。

- **Model**:
  - Firestore 的 users collection (個人資訊) 
  - Firestore 的 drinkRecords collection (當日飲水記錄)

### 5. 底層 Nav Bar
- **需求**:
  - 包含三個主要導航項目: **主畫面**、**加號按鈕**、**設定**。
  - 加號按鈕為置中的FloatingActionButton (FAB) 或其他樣式。
  - 按下加號按鈕即可手動輸入飲水量。

- **View**:
  - `BottomNavigationBar` 或自訂 NavBar。
  - 中間的加號按鈕跳轉至新增紀錄頁/彈出輸入視窗。

- **Controller**:
  - 負責監控按鈕點擊事件，切換或彈出對話框。

- **Model**:
  - 不需要特殊Model。與 Firestore 的 drinkRecords collection 整合做新增紀錄即可。

### 6. 快捷鍵設定與紀錄功能
- **需求**:
  - 使用者可在「設定頁面」自訂四個快捷按鈕所對應的飲水量或飲品種類。
  - 主頁面的快捷按鈕直接加入該預設量的飲水紀錄。

- **View**:
  - 主頁的四個快捷按鈕 (如「+100ml」、「+200ml」等)。
  - 設定頁中可修改預設量與名稱(如「水」、「茶」、「咖啡」等)。

- **Controller**:
  - `QuickAddController` 新增快捷按鈕的管理邏輯，讀取/寫入使用者設定。
  - 新增快捷按鈕飲水紀錄時，也由 `DrinkRecordController` 接收。

- **Model**:
  - Firestore 的 quickAdds collection: 儲存快捷按鈕設定 (id, userId, label, amount)。

### 7. 自訂飲水紀錄 (加號按鈕)
- **需求**:
  - 點擊底部 Nav Bar 的加號按鈕後，可輸入自定義的飲水量 (如 250ml, 450ml)。
  - 可選擇飲品種類 (水、茶、咖啡、其他)。

- **View**:
  - 可彈出對話框或跳轉新頁，包含輸入框和下拉式選單。
  - 錯誤處理: 飲水量不得小於等於 0。

- **Controller**:
  - `DrinkRecordController` 的 `addRecord()`。
  - 若添加成功，回到主頁或關閉彈窗，同步更新當日飲水量。

- **Model**:
  - Firestore 的 drinkRecords collection: 新增記錄。

### 8. 定時推送飲水提醒
- **需求**:
  - 根據使用者設定的頻率或預設(如每2小時)推播一次。
  - 使用本機通知 (Local Notification) 或 Firebase Cloud Messaging。

- **View**:
  - 無固定UI，需顯示系統推播通知。

- **Controller**:
  - `NotificationController`: 排程/取消通知，與本地通知套件(如 `flutter_local_notifications`)整合。

- **Model**:
  - Firestore 的 notificationSettings collection: 儲存推播時間、間隔、是否開啟等設定。

### 9. 領取獎勵頁面
- **需求**:
  - 用戶達成當日目標飲水量後，可在此頁面領取金幣。
  - 顯示當前金幣總數，與已領取/未領取狀態。
  - 領取按鈕使金幣 +X，領取後不可重複領取。

- **View**:
  - 領取獎勵按鈕 (若完成目標且未領取)。
  - 顯示金幣總數與可領取數量。

- **Controller**:
  - `RewardController`: 判斷是否達成條件、是否領取過獎勵。
  - 若符合條件，更新 Firestore 中的金幣數。

- **Model**:
  - Firestore 的 users collection。
  - 可在使用者資料中記錄「當日是否已領取」。

### 10. 設定頁面
- **需求**:
  - 可讓用戶設定:
    - 快捷按鈕對應的量/標籤。
    - 飲水提醒推播的開關、間隔。
    - 個人資料 (身高、體重、年齡、活動量) 的更新，重新計算每日目標。
  - 預留其他個人化設定 (主題顏色、語言等)。

- **View**:
  - `SettingsPage` UI，列出可調整項目。
  - 提供儲存修改/回到主頁的方式。

- **Controller**:
  - `SettingsController`: 負責更新個人資料及快捷設定等。

- **Model**:
  - Firestore 的 users, quickAdds, notificationSettings collections。

### 11. 商店頁面
- **需求**:
  - 使用者可使用金幣交換虛擬商品或其他獎勵。
  - 商品列表需顯示名稱、所需金幣、可否購買(若金幣不足則不可購買)。
  - 購買後金幣扣除。

- **View**:
  - `StorePage`: 商品以Card或List顯示。
  - 點擊購買按鈕後若成功，顯示成功訊息。

- **Controller**:
  - `StoreController`: 取得商品列表、判斷金幣是否足夠、扣除金幣。

- **Model**:
  - Firestore 的 items collection: 商品資訊 (id, name, price)。
  - Firestore 的 users collection: 使用者金幣餘額。

---

## 資料庫結構 (Model)

### users
- id: string
- email: string
- name: string 
- profileImageUrl: string
- currentAvatarUrl: string
- avatars: list of string
- height: number
- weight: number
- age: number
- activityLevel: number
- dailyWaterGoal: number
- coins: number
- createdAt: timestamp
- updatedAt: timestamp
- achievements: list of Achievement
- streak: number


### Achievement
- id: string
- title: string
- description: string
- icon: string
- isUnlocked: boolean
- unlockedAt: timestamp

### drinkRecords
- id: string
- userId: string (reference to users)
- amount: number
- timestamp: timestamp
- source: string // "手動" 或 "水壺"

### quickAdds
- id: string
- userId: string (reference to users)
- label: string
- amount: number

### notificationSettings
- id: string
- userId: string (reference to users)
- enable: boolean
- intervalInHours: number

### items
- id: string
- name: string
- price: number

### 關聯關係
- 一個使用者可以有多筆飲水紀錄 (users -> drinkRecords)
- 一個使用者可以設定多個快捷按鈕 (users -> quickAdds)
- 一個使用者可以有多個通知設定 (users -> notificationSettings)
- 一個使用者可以購買多個商品 (users -> items)