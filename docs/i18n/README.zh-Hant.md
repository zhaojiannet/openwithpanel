<p align="center">
  <img src="../assets/icon.png" width="128" alt="OpenWithPanel App 圖像">
</p>

<h1 align="center">OpenWithPanel</h1>

<p align="center">
  <strong>設定 Mac 上由哪個 App 打開哪類檔案，包括 macOS 不讓你設定的那些。</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26 或以上版本">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT 授權條款">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <b>繁體中文</b> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.id.md">Bahasa Indonesia</a> ·
  <a href="README.th.md">ไทย</a> ·
  <a href="README.vi.md">Tiếng Việt</a> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

OpenWithPanel 是一款免費、開源的 macOS App，用來管理**預設 App**：在同一個視窗裡選擇每種檔案類型、副檔名和連結要由哪個 App 打開。它還能做到 Finder 做不到的事：把你的編輯器設為**無副檔名檔案**的預設 App，例如 `.env`、`.gitignore`、`Dockerfile` 和 `.npmrc`。

<p align="center">
  <img src="../assets/screenshot.png" width="720" alt="OpenWithPanel 主視窗">
</p>

## 目錄

- [為什麼需要 OpenWithPanel](#為什麼需要-openwithpanel)
- [功能](#功能)
- [安裝](#安裝)
- [使用方式](#使用方式)
- [診斷](#診斷)
- [設定](#設定)
- [開發者模式](#開發者模式)
- [運作原理](#運作原理)
- [常見問題](#常見問題)
- [已知限制](#已知限制)
- [從原始碼建置](#從原始碼建置)

## 為什麼需要 OpenWithPanel

macOS 把大多數無副檔名的檔案歸類為 `public.data`，而且拒絕讓任何 App 成為這個類型的預設 App。在 Finder 中使用**取得資訊 › 打開檔案的應用程式 › 全部更改⋯**，對這些檔案毫無作用；命令列工具則會回報錯誤 `-50`。Finder 的**每次都用此應用程式來打開**只對你選取的那一個檔案有效。

所以不管你怎麼設定，`.env`、`.gitignore`、`Dockerfile` 這類檔案還是會用文字編輯打開，甚至根本打不開。OpenWithPanel 用一個名為 OpenWithPanel Helper 的小型輔助程式解決這個問題，詳見[運作原理](#運作原理)。

macOS 在其他地方也有缺漏：新安裝的 App（典型的是 Xcode）搶走你的檔案關聯時，macOS 不會告訴你，也沒有按鈕能把一切恢復原狀。OpenWithPanel 把這些也補上了。

## 功能

- **按分組設定預設 App**。檔案類型依用途分組：文字、Markdown、程式碼、設定與資料、無副檔名檔案、PDF、文件、影像、影片、音訊、壓縮檔，每組一個 App 選單。
- **一次套用**。一整組格式一次設好，不必逐一確認；幾秒內生效。
- **單一格式例外**。展開某個分組，即可為單一格式（如 `.md` 或 `.py`）單獨指定 App。之後更改分組的 App 時，這些例外保持不變。
- **無副檔名檔案**。用你選定的編輯器打開 `.env`、`Dockerfile`、`.gitignore` 等無副檔名檔案，即使該編輯器沒有宣告支援它們。
- **自訂副檔名**。加入清單裡沒有的任何副檔名，包括 macOS 只視為暫時類型的副檔名，如 `.go`、`.rs`、`.kt`、`.dart` 和 `.lua`。
- **連結的預設 App**。選擇打開網頁連結（`http`、`https`）、電子郵件（`mailto`）、行事曆訂閱（`webcal`）、電話、簡訊、FaceTime、SSH、FTP 和螢幕共享的 App；也可以選擇**不打開**，點按這類連結時就不會有任何反應。
- **依副檔名搜尋**。輸入 `py` 或 `env`，直接跳到對應的列。
- **診斷任何檔案**。拖入一個檔案，查看它為什麼用某個 App 打開，並當場改用別的 App。拖入一個檔案夾，找出單獨設定了**打開檔案的應用程式**的檔案並清除這些設定。
- **被搶占提醒**。如果其他 App（Xcode、瀏覽器）搶走了你設定的關聯，OpenWithPanel 會顯示橫幅，一鍵即可恢復。
- **撤銷與復原**。每次更改前都會儲存快照。可以用 `⌘Z` 撤銷、復原到任何歷史快照，或把一切復原到 OpenWithPanel 做任何更動之前的狀態，復原前會先預覽每一項變化。
- **檔案夾規則**。可選的備用方案：只用 macOS 官方 API，讓指定檔案夾（如 `~/Projects`）裡的無副檔名檔案用你的編輯器打開。
- **開發者模式**。依檔名模式（例如 `Dockerfile*`）、所在檔案夾或文字／二進位內容分流檔案的規則；診斷中的完整判定鏈，包括每個 App 宣告的類型和優先等級；預設組匯入與匯出。
- **乾淨解除安裝**。內建的解除安裝功能會先把每一項關聯復原到原本的 App，再把 OpenWithPanel 丟到垃圾桶。
- **15 種語言**。英文、簡體中文、繁體中文、日文、韓文、德文、法文、西班牙文、葡萄牙文、印尼文、泰文、越南文、阿拉伯文、俄文和印地文，可在 App 內切換。

## 安裝

需要 macOS 26 Tahoe 或以上版本。

1. 打開 [Releases 頁面](https://github.com/zhaojiannet/openwithpanel/releases)，在最新版本的 **Assets** 下載 `OpenWithPanel-<version>.dmg`。
2. 按兩下下載好的 DMG 將它打開。
3. 把 **OpenWithPanel** 拖到同一個視窗裡的**應用程式**檔案夾上。
4. 退出 DMG，然後從「應用程式」檔案夾打開 OpenWithPanel。第一次打開時 macOS 會要求你允許它，見[首次打開](#首次打開)。

沒有安裝程式，也不需要管理者密碼。

**更新**：下載新的 DMG，再把 OpenWithPanel 拖進「應用程式」，取代舊版本。你的設定、規則和快照都會保留。想知道有沒有新版本，選 **OpenWithPanel › 檢查更新項目…**。

**解除安裝**：見[解除安裝](#解除安裝)。

### 首次打開

OpenWithPanel 尚未經過 Apple 公證，所以第一次打開時 macOS 會擋下它。允許一次即可：

1. 按兩下 OpenWithPanel。macOS 提示無法驗證 OpenWithPanel 時，按一下**完成**。不要按藍色的**丟到垃圾桶**按鈕。

   <img src="../assets/first-launch-1.png" width="372" alt="第一個警告：按一下完成">

2. 打開**系統設定 › 隱私權與安全性**，向下捲動到**安全性**，按一下 OpenWithPanel 旁邊的**強制打開**。第 1 步之後大約一小時內這個按鈕都會在。

   <img src="../assets/first-launch-2.png" width="560" alt="隱私權與安全性：按一下強制打開">

3. 輸入登入密碼或使用 Touch ID。在接著出現的對話框裡再按一次**強制打開**。

   <img src="../assets/first-launch-3.png" width="372" alt="確認框：按一下強制打開">

之後 OpenWithPanel 就能正常打開。內建的輔助程式會一併獲得允許，所以無副檔名檔案打開時不會再有提示。DMG 裡的 `First Launch.txt` 也寫了這些步驟。截圖是英文介面，繁體中文 macOS 中的按鈕名稱就是上面寫的這些。

## 使用方式

### 檔案類型分組

**檔案類型**標籤頁以卡片列出每個分組：

| 分組 | 包含 |
|---|---|
| 文字 | `.txt` `.log` |
| Markdown | `.md` `.markdown` |
| 程式碼 | 熱門程式語言，見下文 |
| 設定與資料 | `.json` `.yaml` `.toml` `.xml` `.ini` `.plist` `.csv` |
| 無副檔名檔案 | `.env` `Dockerfile` `.gitignore` 等 |
| PDF | `.pdf` |
| 文件 | `.rtf` `.docx` `.doc` `.pages` `.odt` |
| 影像、影片、音訊、壓縮檔 | 各自的常見格式 |
| 自訂 | 你加入的、不屬於其他任何分組的副檔名；只在有內容時顯示 |

程式碼分組涵蓋 Stack Overflow 2025 開發者調查中至少 5% 受訪者使用的語言：JavaScript、TypeScript（`.tsx`）、Python、Java、C、C++、C#、PHP、Ruby、Swift、Go、Rust、Kotlin、Dart、Lua、Shell（sh、bash、zsh）、PowerShell、SQL 和組合語言，另加 CSS、Makefile 和 JSX。其他語言可以自行加入，見[加入副檔名](#加入副檔名)。

### 為整個分組設定 App

在卡片右側的選單裡選一個 App，分組裡的所有格式就都用它打開。選單列出 macOS 認為能打開該分組的 App；選擇**其他…** 可以從「應用程式」檔案夾中任選一個 App。

### 為單一格式指定 App

按一下分組所在的列或左側的箭頭即可展開。每個格式各佔一列，圖像是該檔案的系統圖像，標題是它的副檔名。在某一列的選單裡選另一個 App，這個格式之後就用它打開；該列會標上**單獨設定**，分組列會顯示有幾個格式是單獨設定的。

- 沒有單獨指定 App 的格式，選單裡會顯示灰色的**跟隨本組**。
- 要讓某個格式重新跟隨分組，在它的選單裡選擇**跟隨分組**。
- 之後更改分組的 App，不會影響已單獨指定 App 的格式。

格式超過 8 個的分組只顯示你單獨設定過或自行加入的格式，其餘的可按底部的**顯示全部 N 種格式**查看。程式碼分組全部顯示時，會分成網頁、系統與應用程式、JVM、腳本與命令列等小節。

### 搜尋

在右上角的搜尋欄位輸入副檔名，例如 `py` 或 `env`。符合的分組會展開並顯示所有格式，符合的列會反白。如果副檔名不在任何分組裡，搜尋結果會提供**加入…**。

### 加入副檔名

使用清單底部的**加入副檔名…**，或搜尋結果中的**加入…**。

1. 輸入副檔名，例如 `nim`。面板會顯示 macOS 把它辨識成什麼。
2. OpenWithPanel 據此建議一個分組：原始碼歸入程式碼，影像歸入影像，無法辨識的歸入自訂。你也可以另選分組。
3. 按一下**加入**。該格式會出現在所選分組裡，標有**自訂**，並跟隨分組的 App；你也可以為它單獨指定 App。

已經在某個分組裡的副檔名不會重複加入，面板會告訴你它在哪個分組。你加入的格式所在的列上有移除按鈕。

### 套用

上面所有更改都會先暫存。視窗底部的列會顯示有多少項待套用的更改；**套用**使其生效，**放棄**則捨棄它們。

- 檔案類型的更改不需要確認。無論改了多少個格式，OpenWithPanel 都會一次寫入系統偏好設定，並讓系統只重新讀取一次；全部更改幾秒內生效。
- 更改連結和網頁檔案（`.html`）時仍需在系統對話框裡確認，例如更改網頁瀏覽器時。悄悄更改瀏覽器是瀏覽器綁架程式的行為，所以應該由 macOS 直接詢問你。
- 如果寫入失敗（例如因為權限問題），或某個格式沒有生效，OpenWithPanel 會透過系統 API 逐一重新設定；這時 macOS 會詢問你要使用新的 App 還是保留原本的。如果你保留原本的，OpenWithPanel 會把該格式記為單獨設定為那個 App，之後不再更動它。
- 套用後 OpenWithPanel 會重新讀取真實的系統狀態，所以清單顯示的永遠是實際生效的結果。

### 撤銷與復原

- **編輯 › 還原**（`⌘Z`）撤銷上一次套用。可以連續撤銷多次。
- 工具列中的圓形箭頭按鈕是**復原到初始**：OpenWithPanel 改過的每種檔案類型和連結，都會指回你第一次打開 OpenWithPanel 時所用的 App。執行前會先列出每一項變化。

macOS 無法刪除檔案關聯，只能把它指向另一個 App，所以復原的意思是把每個類型指回快照中記錄的 App。原本由 macOS 自行選擇 App 的類型，復原後會得到一個指向同一 App 的明確設定；打開的效果與之前完全相同。

### 連結

在檔案類型下方，有一張卡片用來設定每種連結的 App：

| 列 | URL 協定 |
|---|---|
| 網頁瀏覽器 | `http:` `https:` |
| 電子郵件 | `mailto:` |
| 行事曆訂閱 | `webcal:` |
| 電話、簡訊、FaceTime | `tel:` `sms:` `facetime:` |
| SSH、FTP、螢幕共享 | `ssh:` `ftp:` `vnc:` |

只要 Mac 上有某個 App 能處理的連結類型，都會列出來。每個選單底部都有**不打開**：選擇後，在任何 App 中點按這類連結都不會有反應，例如可以讓網頁上的電話號碼不再撥出電話。要取消，在選單裡重新選一個 App 即可。為網頁瀏覽器選擇**不打開**之前會先確認，因為那樣所有網頁連結都打不開了。你也可以搜尋協定（如 `mailto`）或列名稱。

連結的暫存、套用、快照、撤銷和復原都與檔案類型完全相同。更改網頁瀏覽器需要在系統對話框裡確認；在 macOS 27 上，更改 `http` 也會同時更改 `https`，OpenWithPanel 隨後會略過對 `https` 的重複設定，所以你只需確認一次。

## 診斷

切換到視窗頂部的**診斷**標籤頁。

**為什麼某個檔案用這個 App 打開？** 把檔案拖進虛線框。結果會顯示由哪個 App 打開它，以及原因：

- 該檔案有自己的**打開檔案的應用程式**設定，是在 Finder 的**取得資訊**中設定的；
- OpenWithPanel Helper 收到了它，由某條規則或分組設定把它交給了某個 App；
- 你為這類檔案選擇了這個 App；
- 什麼都沒設定，由 macOS 選擇 App。

結果下方的**改用**可以直接切換到另一個 App。如果該檔案有自己的**打開檔案的應用程式**設定，這裡會改為顯示**移除這個檔案的單獨設定**。

**找出單獨設定了「打開檔案的應用程式」的檔案。** 把檔案夾拖進虛線框。OpenWithPanel 會列出其中所有單獨設定了**打開檔案的應用程式**的檔案，以及它們指向的 App。選取檔案後按一下**移除它們的單獨設定**，這些檔案就會改為跟隨所屬類型的設定。掃描會略過 `.git`、`node_modules`、`.build`、`DerivedData`、`Pods`、`vendor`、`.venv` 和 `__pycache__` 檔案夾。

**輸出診斷報告。** 標籤頁底部的**輸出診斷報告…** 會儲存一份文字報告，內容包括你的設定、OpenWithPanel 管理的每個類型目前由哪個 App 打開、這次執行的記錄，以及你剛診斷過的檔案。回報問題時請把它寄給開發者。

## 設定

打開 **OpenWithPanel › 設定…** 或按 `⌘,`。

**一般**

- **語言**：選擇**跟隨系統**或 15 種語言之一，然後按一下**立即重新開啟**。如果有尚未套用的更改，請先套用或放棄。
- **開發者模式**：顯示更多細節，見[開發者模式](#開發者模式)。它只改變顯示的內容，從不更動你的設定。

**檔案夾規則**

這是無副檔名檔案所用的方法失效時的備用方案。加入一個檔案夾並選擇一個 App，OpenWithPanel 就會為該檔案夾裡每個無副檔名的文字檔單獨設定**打開檔案的應用程式**為這個 App。

- 二進位檔案和你自己設定過的檔案不會被更動。
- 每次打開 OpenWithPanel 時會處理新檔案，也可以按**立即套用**馬上處理。
- **撤銷全部檔案夾設定**會把 OpenWithPanel 改過的每個檔案恢復原狀。
- **略過以下名稱的檔案夾**可以編輯；預設列出的是診斷中檔案夾掃描所略過的那些檔案夾。

**歷史**

列出每次套用前儲存的快照，最多 20 份，最新的排在最前面。最後一份**初始（OpenWithPanel 更動任何設定之前）** 是你第一次打開 OpenWithPanel 時記錄的狀態。任何一份都可以用**復原…** 來復原，復原前會先預覽差異。

**OpenWithPanel 寫入了什麼**

列出 OpenWithPanel 在你的 Mac 上更改或寫入的每一個位置，每項都附有**在 Finder 中顯示**：

- **檔案關聯**：OpenWithPanel 管理的項目（檔案類型和連結）有多少個；
- **LaunchServices 偏好設定項目**：OpenWithPanel 為檔案類型寫入的項目，包括無副檔名檔案；
- **OpenWithPanel Helper**：位於 OpenWithPanel App 內；
- **規則與快照**：`~/Library/Application Support/net.zhaojian.openwithpanel/`；
- **逐一檔案的「打開檔案的應用程式」設定**：只有在你使用過檔案夾規則時才會出現。

OpenWithPanel 不在背景執行，沒有登入項目，也不收集資料。只有在你選擇 **檢查更新項目…** 時才會連網，從 GitHub 讀取最新的版本號。

### 解除安裝

在 **OpenWithPanel 寫入了什麼**底部按一下**解除安裝 OpenWithPanel…**，並選擇是否一併刪除規則與快照。接著 OpenWithPanel 會：

1. 把它改過的每種檔案類型和連結指回原本的 App；
2. 撤銷檔案夾規則所做的每一項逐一檔案的設定；
3. 依你的選擇刪除或保留 `~/Library/Application Support/net.zhaojian.openwithpanel/`；
4. 把自己丟到垃圾桶。

如果有任何檔案類型或連結無法指回，例如你在系統確認框裡拒絕了，解除安裝會停止，不刪除任何東西。

如果保留了規則與快照，重新安裝 OpenWithPanel 後會出現一個橫幅，一鍵就能復原全部設定。有些清理工具會在 App 被丟到垃圾桶時刪除它的殘留檔案，這可能把你選擇保留的規則與快照也一併刪掉；請讓這類工具略過 OpenWithPanel。

如果你直接把 OpenWithPanel 拖到垃圾桶，OpenWithPanel Helper 會隨之一起刪除，macOS 會捨棄指向它的關聯；其他類型則保留 OpenWithPanel 設定的 App。Application Support 檔案夾裡的 `UNINSTALL.txt` 說明了這種情況下如何復原它們。

## 開發者模式

在**設定 › 一般**中開啟。開啟後會增加：

- 每個格式下方顯示系統類型識別碼（UTI），經由 OpenWithPanel Helper 轉交的格式帶有**輔助程式**標記；
- 診斷中的完整判定鏈：類型、父類型、文字還是二進位、判定結果，以及每個能打開該檔案的 App 在其 Info.plist 中如何宣告它（符合的副檔名或類型、角色和優先等級）；
- 主視窗中的**規則**標籤頁；
- 設定中的**非文字檔案**處理方式和**預設組**。

**規則**決定 OpenWithPanel Helper 把收到的檔案交給誰。一條規則包括：

- 條件，至少要填一項：檔名模式（如 `Dockerfile*`，不分大小寫）、所在檔案夾（如 `~/Projects`），以及內容是文字還是二進位；
- 適用的類型，預設是 `public.data`（無副檔名檔案）；你加入的其他類型也會經由 OpenWithPanel Helper 轉交；
- 檔案的去向：某個 App、**在 Finder 中顯示**，或**原本的 App**。

規則從上到下依序檢查，第一條符合的生效。拖移可以調整順序；左側的開關可以暫時停用某條規則。受規則影響的分組在標準模式下顯示**由規則控制**。

**非文字檔案**設定 OpenWithPanel Helper 如何處理二進位檔案：**在 Finder 中顯示**（預設）、**用同一個 App 打開**，或**用原本的 App 打開**。

**預設組**把你的分組設定、單一格式的設定、自訂副檔名和規則輸出為 JSON 檔案，可以在另一台 Mac 上匯入；匯入的設定在按一下**套用**後生效。檔案夾規則和原本的 App 的記錄是每台 Mac 各自的，所以既不會輸出，匯入時也不會被覆寫。

## 運作原理

OpenWithPanel 在自己的 App 包內附帶一個極小的輔助程式：**OpenWithPanel Helper**。當你為無副檔名檔案選擇編輯器時，OpenWithPanel 把 `public.data` 指向這個輔助程式。打開這類檔案時，輔助程式會檢查你的規則和檔案內容，把文字檔交給你選定的 App，在 Finder 中顯示二進位檔案，然後結束。它不會常駐：只有當 macOS 有檔案或連結要交給它時才會啟動它，閒置不到一秒就會結束。它沒有視窗，也不會出現在 Dock 中。設為**不打開**的連結也會交給輔助程式，輔助程式直接忽略它們。

如果檔案的前 8 KB 含有空位元組，或不是有效的 UTF-8，就視為二進位檔案。

你選定的 App 本來就支援的檔案類型（如 `.md` 或 `.py`）會直接分配給該 App，不經過輔助程式。

macOS 沒有提供為 `public.data` 設定預設 App 的公開 API，而且從 macOS 26.4 起，公開 API 每更改一種檔案類型都要確認一次。所以 OpenWithPanel 把所有檔案類型的更改一次寫入 LaunchServices 偏好設定，並重新啟動一次 `lsd` 服務使其生效。這個機制沒有 Apple 官方文件，系統更新後可能失效。如果某項更改沒有生效，OpenWithPanel 會改用公開 API，屆時需要你確認；對於無副檔名檔案，則提供檔案夾規則作為替代。

## 常見問題

**Mac 上要怎麼更改無副檔名檔案的預設 App？**
打開 OpenWithPanel，為**無副檔名檔案**選擇一個 App，然後按一下**套用**。之後 `.env`、`Dockerfile` 這類檔案就會用該 App 打開。

**為什麼 Finder 的「全部更改」對 `.env` 檔案沒有作用？**
macOS 把它們視為通用資料（`public.data`），並且不允許透過公開 API 更改這個類型的預設 App。OpenWithPanel 藉由輔助程式繞過了這個限制。

**要怎麼把 VS Code、Zed 或 Sublime Text 設為程式碼檔案的預設編輯器？**
為**程式碼**分組或單一格式選擇該編輯器，然後按一下**套用**。沒有 macOS 正式類型的副檔名（如 `.go` 和 `.rs`）同樣適用。

**可以撤銷所有更改嗎？**
可以。OpenWithPanel 第一次執行時會記錄原始關聯，而且永遠不會覆寫這份記錄。**復原到初始**會把每個改過的類型指回原本的 App。

**OpenWithPanel 會收集資料或在背景執行嗎？**
不會。它不收集資料，只在你選擇 **檢查更新項目…** 時連網，不安裝背景代理程式，結束後也不會繼續執行。**設定 › OpenWithPanel 寫入了什麼**列出了它寫入的每一個位置。

**為什麼 OpenWithPanel 不使用沙盒？**
macOS 不允許沙盒中的 App 更改預設 App。OpenWithPanel 改為啟用強化執行環境（hardened runtime）。

## 已知限制

- 在 macOS 上，`.ts` 被辨識為影片格式（MPEG-2 傳輸串流），更改它會影響真正的影片檔，所以程式碼分組只包含 TypeScript 的 `.tsx`。同樣地，`.r`、`.exs` 和 `.fs` 在 macOS 看來分別是 Rez 資源、Logic 取樣器檔案和著色器，也不在程式碼分組裡。
- 檔案類型設定依賴一個沒有文件的系統機制，系統更新後可能失效。如果失效，一般檔案類型會自動改用系統 API（每個類型確認一次），無副檔名檔案則可以改用檔案夾規則。
- macOS 只允許 App 讀取自己程序的記錄，所以診斷報告不包含 OpenWithPanel Helper 的記錄。如有需要，請在「系統監視程式」App 中搜尋 `net.zhaojian.openwithpanel`。
- 介面翻譯尚未經過母語人士審校。

## 從原始碼建置

需要 Xcode 27。

```sh
swift test --package-path OpenWithPanelKit
xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel build
```

建置 DMG：

```sh
scripts/package.sh
```

產物輸出到 `.build/dist/`，同時還有一個由 `packaging/openwithpanel.rb` 產生、已填入版本號碼和檢查碼的 Homebrew cask。不設定環境變數時，App 使用 ad hoc 簽署，不經過公證，這時 DMG 裡會附上 `First Launch.txt`。設定 `DEVELOPER_ID`（Developer ID Application 憑證名稱）即可用該憑證簽署；再設定 `NOTARY_PROFILE`（用 `xcrun notarytool store-credentials` 儲存的憑證設定檔）即可進行公證並裝訂公證票證。

發行版由 GitHub Actions 工作流程 `.github/workflows/release.yml` 建置。它如何簽署、如何發布新版本，見 [docs/release.md](../release.md)。

## 專案結構

- `OpenWithPanelKit/`：本機 Swift 套件。`OpenWithPanelCore` 包含全部邏輯；`OpenWithPanelPlatform` 封裝系統 API。
- `Apps/OpenWithPanel/`：主 App（SwiftUI）。
- `Apps/Helper/`：內嵌在主 App 包中的輔助程式。
- `scripts/`、`packaging/`：打包腳本和 Homebrew cask 範本。

## 授權條款

[MIT](../../LICENSE) © 2026 zhaoJian
