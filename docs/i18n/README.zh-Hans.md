<p align="center">
  <img src="../assets/icon.png" width="128" alt="OpenWithPanel 应用图标">
</p>

<h1 align="center">OpenWithPanel</h1>

<p align="center">
  <strong>设置 Mac 上哪个 App 打开哪类文件，包括 macOS 不让你设置的那些。</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26 或更高版本">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT 许可证">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <b>简体中文</b> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
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

OpenWithPanel 是一款免费、开源的 macOS 应用，用来管理**默认 App**：在一个窗口里选择每种文件类型、文件扩展名和链接由哪个 App 打开。它还能做到访达做不到的事：把你的编辑器设为**无扩展名文件**的默认 App，例如 `.env`、`.gitignore`、`Dockerfile` 和 `.npmrc`。

<p align="center">
  <img src="../assets/screenshot.png" width="720" alt="OpenWithPanel 主窗口">
</p>

## 目录

- [为什么需要 OpenWithPanel](#为什么需要-openwithpanel)
- [功能](#功能)
- [安装](#安装)
- [使用方法](#使用方法)
- [诊断](#诊断)
- [设置](#设置)
- [开发者模式](#开发者模式)
- [工作原理](#工作原理)
- [常见问题](#常见问题)
- [已知限制](#已知限制)
- [从源码构建](#从源码构建)

## 为什么需要 OpenWithPanel

macOS 把大多数无扩展名文件归为 `public.data`，并且拒绝让任何 App 成为这一类型的默认 App。在访达中使用**显示简介 › 打开方式 › 全部更改…**，对这些文件不起作用，命令行工具则报错 `-50`。访达的**始终以此方式打开**只对你选中的那一个文件生效。

所以不管你怎么设置，`.env`、`.gitignore`、`Dockerfile` 这类文件还是会用文本编辑打开，或者根本打不开。OpenWithPanel 用一个名为 OpenWithPanel Helper 的小型辅助程序解决这个问题，详见[工作原理](#工作原理)。

macOS 在别处也有缺漏：新装的 App（典型的是 Xcode）抢走了你的文件关联时，macOS 不会告诉你，也没有按钮能把一切恢复原样。OpenWithPanel 把这些也补上了。

## 功能

- **按分组设置默认 App**。文件类型按用途分组：文本、Markdown、代码、配置与数据、无扩展名文件、PDF、文稿、图片、视频、音频、压缩包，每组一个 App 菜单。
- **一次应用**。一整组格式一次设好，不用逐个确认；几秒内生效。
- **单个格式例外**。展开某个分组，可以给单个格式（如 `.md` 或 `.py`）单独指定 App。之后更改分组的 App 时，这些例外保持不变。
- **无扩展名文件**。用你选定的编辑器打开 `.env`、`Dockerfile`、`.gitignore` 等无扩展名文件，即使该编辑器没有声明支持它们。
- **自定义扩展名**。添加列表里没有的任意扩展名，包括 macOS 只认作临时类型的扩展名，如 `.go`、`.rs`、`.kt`、`.dart` 和 `.lua`。
- **链接的默认 App**。选择打开网页链接（`http`、`https`）、电子邮件（`mailto`）、日历订阅（`webcal`）、电话、短信、FaceTime、SSH、FTP 和屏幕共享的 App；也可以选择**不打开**，点击这类链接时什么也不会发生。
- **按扩展名搜索**。输入 `py` 或 `env`，直接跳到对应的行。
- **诊断任意文件**。拖入一个文件，查看它为什么用某个 App 打开，并当场改用别的 App。拖入一个文件夹，找出单独设置了**打开方式**的文件并清除这些设置。
- **被抢占提醒**。如果其他 App（Xcode、浏览器）抢走了你设置的关联，OpenWithPanel 会显示横幅，一键即可恢复。
- **撤销与恢复**。每次更改前都会保存快照。可以用 `⌘Z` 撤销、恢复到任意历史快照，或者把一切恢复到 OpenWithPanel 做任何改动之前的状态，恢复前会先预览每一项变化。
- **文件夹规则**。可选的备用方案：只用 macOS 官方 API，让指定文件夹（如 `~/Projects`）里的无扩展名文件用你的编辑器打开。
- **开发者模式**。按文件名模式（例如 `Dockerfile*`）、所在文件夹或文本/二进制内容分流文件的规则；诊断中的完整判定链，包括每个 App 声明的类型和优先级；预设导入与导出。
- **干净卸载**。内置的卸载功能会先把每一项关联恢复到原来的 App，再把 OpenWithPanel 移到废纸篓。
- **15 种语言**。英语、简体中文、繁体中文、日语、韩语、德语、法语、西班牙语、葡萄牙语、印度尼西亚语、泰语、越南语、阿拉伯语、俄语和印地语，可在 App 内切换。

## 安装

需要 macOS 26 Tahoe 或更高版本。

1. 打开 [Releases 页面](https://github.com/zhaojiannet/openwithpanel/releases)，在最新版本的 **Assets** 下载 `OpenWithPanel-<version>.dmg`。
2. 双击下载好的 DMG 打开它。
3. 把 **OpenWithPanel** 拖到同一窗口里的**应用程序**文件夹上。
4. 推出 DMG，然后从“应用程序”文件夹打开 OpenWithPanel。首次打开时 macOS 会要求你允许它，见[首次打开](#首次打开)。

没有安装程序，也不需要管理员密码。

**更新**：下载新的 DMG，再把 OpenWithPanel 拖进“应用程序”，替换旧版本。你的设置、规则和快照都会保留。想知道有没有新版本，选 **OpenWithPanel › 检查更新…**。

**卸载**：见[卸载](#卸载)。

### 首次打开

OpenWithPanel 尚未经过 Apple 公证，所以第一次打开时 macOS 会拦下它。允许一次即可：

1. 双击 OpenWithPanel。macOS 提示无法验证 OpenWithPanel 时，点按**完成**。不要点蓝色的**移到废纸篓**按钮。

   <img src="../assets/first-launch-1.png" width="372" alt="第一个警告：点按完成">

2. 打开**系统设置 › 隐私与安全**，向下滚动到**安全性**，点按 OpenWithPanel 旁边的**仍要打开**。第 1 步之后大约一小时内这个按钮都在。

   <img src="../assets/first-launch-2.png" width="560" alt="隐私与安全：点按仍要打开">

3. 输入登录密码或使用触控ID。在随后的对话框里再点按一次**仍要打开**。

   <img src="../assets/first-launch-3.png" width="372" alt="确认框：点按仍要打开">

之后 OpenWithPanel 就能正常打开。内置的辅助程序会一并获得允许，所以无扩展名文件打开时不会再有提示。DMG 里的 `First Launch.txt` 也写了这些步骤。截图是英文界面，简体中文 macOS 中的按钮名称就是上面写的这些。

## 使用方法

### 文件类型分组

**文件类型**标签页以卡片形式列出每个分组：

| 分组 | 包含 |
|---|---|
| 文本 | `.txt` `.log` |
| Markdown | `.md` `.markdown` |
| 代码 | 常用编程语言，见下文 |
| 配置与数据 | `.json` `.yaml` `.toml` `.xml` `.ini` `.plist` `.csv` |
| 无扩展名文件 | `.env` `Dockerfile` `.gitignore` 等 |
| PDF | `.pdf` |
| 文稿 | `.rtf` `.docx` `.doc` `.pages` `.odt` |
| 图片、视频、音频、压缩包 | 各自的常见格式 |
| 自定义 | 你添加的、不属于其他任何分组的扩展名；只在有内容时显示 |

代码分组覆盖 Stack Overflow 2025 开发者调查中至少 5% 受访者使用的语言：JavaScript、TypeScript（`.tsx`）、Python、Java、C、C++、C#、PHP、Ruby、Swift、Go、Rust、Kotlin、Dart、Lua、Shell（sh、bash、zsh）、PowerShell、SQL 和汇编，另加 CSS、Makefile 和 JSX。其他语言可以自己添加，见[添加扩展名](#添加扩展名)。

### 为整个分组设置 App

在卡片右侧的菜单里选一个 App，分组里的所有格式就都用它打开。菜单列出 macOS 认为能打开该分组的 App；选择**其他…** 可以从“应用程序”文件夹中任选一个 App。

### 给单个格式单独指定 App

点按分组所在的行或左侧的箭头即可展开。每个格式占一行，图标是该文件的系统图标，标题是它的扩展名。在某一行的菜单里选另一个 App，这个格式此后就用它打开；该行会标上**单独设置**，分组行会显示有几个格式是单独设置的。

- 没有单独指定 App 的格式，菜单里显示灰色的**跟随本组**。
- 要让某个格式重新跟随分组，在它的菜单里选择**跟随分组**。
- 之后更改分组的 App，不会影响已单独指定 App 的格式。

格式超过 8 个的分组只显示你单独设置过或自己添加的格式，其余的可以点底部的**显示全部 N 种格式**查看。代码分组全部显示时，会分成网页、系统与应用、JVM、脚本与命令行等小节。

### 搜索

在右上角的搜索框里输入扩展名，例如 `py` 或 `env`。匹配的分组会展开并显示全部格式，匹配的行会高亮。如果扩展名不在任何分组里，搜索结果会提供**添加…**。

### 添加扩展名

使用列表底部的**添加扩展名…**，或搜索结果中的**添加…**。

1. 输入扩展名，例如 `nim`。面板会显示 macOS 把它识别成什么。
2. OpenWithPanel 据此建议一个分组：源代码归入代码，图片归入图片，无法识别的归入自定义。你也可以另选分组。
3. 点按**添加**。该格式出现在所选分组里，标有**自定义**，并跟随分组的 App；你也可以给它单独指定 App。

已经在某个分组里的扩展名不会重复添加，面板会告诉你它在哪个分组。你添加的格式所在的行上有移除按钮。

### 应用

上面所有更改都会先暂存。窗口底部的栏会显示有多少项待应用的更改；**应用**使其生效，**放弃**则丢弃它们。

- 文件类型的更改不需要确认。无论改了多少个格式，OpenWithPanel 都会一次写入系统偏好设置，并让系统只重新读取一次；全部更改几秒内生效。
- 更改链接和网页文件（`.html`）时仍需在系统对话框里确认，例如更改网页浏览器时。悄悄更改浏览器是浏览器劫持程序的行为，所以应该由 macOS 直接询问你。
- 如果写入失败（例如因为权限问题），或者某个格式没有生效，OpenWithPanel 会通过系统 API 逐个重新设置；这时 macOS 会询问你是使用新的 App 还是保留原来的。如果你保留原来的，OpenWithPanel 会把该格式记为单独设置为那个 App，此后不再改动它。
- 应用后 OpenWithPanel 会重新读取真实的系统状态，所以列表显示的始终是实际生效的结果。

### 撤销与恢复

- **编辑 › 撤销**（`⌘Z`）撤销上一次应用。可以连续撤销多次。
- 工具栏中的圆形箭头按钮是**恢复到初始**：OpenWithPanel 改过的每种文件类型和链接，都会指回你第一次打开 OpenWithPanel 时所用的 App。执行前会先列出每一项变化。

macOS 无法删除文件关联，只能把它指向另一个 App，所以恢复的意思是把每个类型指回快照中记录的 App。原本由 macOS 自行选择 App 的类型，恢复后会得到一个指向同一 App 的明确设置；打开效果与之前完全一样。

### 链接

在文件类型下方，有一张卡片用来设置每种链接的 App：

| 行 | URL 协议 |
|---|---|
| 网页浏览器 | `http:` `https:` |
| 电子邮件 | `mailto:` |
| 日历订阅 | `webcal:` |
| 电话、短信、FaceTime | `tel:` `sms:` `facetime:` |
| SSH、FTP、屏幕共享 | `ssh:` `ftp:` `vnc:` |

只要 Mac 上有某个 App 能处理的链接类型，都会列出来。每个菜单底部都有**不打开**：选择后，在任何 App 中点击这类链接都不会有反应，例如可以让网页上的电话号码不再发起通话。要撤销，在菜单里重新选一个 App 即可。为网页浏览器选择**不打开**之前会先确认，因为那样所有网页链接都打不开了。你也可以搜索协议（如 `mailto`）或行名。

链接的暂存、应用、快照、撤销和恢复都与文件类型完全一样。更改网页浏览器需要在系统对话框里确认；在 macOS 27 上，更改 `http` 也会同时更改 `https`，OpenWithPanel 随后会跳过对 `https` 的重复设置，所以你只需确认一次。

## 诊断

切换到窗口顶部的**诊断**标签页。

**为什么某个文件用这个 App 打开？** 把文件拖进虚线框。结果会显示由哪个 App 打开它，以及原因：

- 该文件有自己的**打开方式**设置，是在访达的**显示简介**中设置的；
- OpenWithPanel Helper 收到了它，由某条规则或分组设置把它交给了某个 App；
- 你为这类文件选择了这个 App；
- 什么都没设置，由 macOS 选择 App。

结果下方的**改用**可以直接切换到另一个 App。如果该文件有自己的**打开方式**设置，这里会改为显示**移除这个文件的单独设置**。

**找出单独设置了“打开方式”的文件。** 把文件夹拖进虚线框。OpenWithPanel 会列出其中所有单独设置了**打开方式**的文件，以及它们指向的 App。选中文件后点按**移除它们的单独设置**，这些文件就会改为跟随所属类型的设置。扫描会跳过 `.git`、`node_modules`、`.build`、`DerivedData`、`Pods`、`vendor`、`.venv` 和 `__pycache__` 文件夹。

**导出诊断报告。** 标签页底部的**导出诊断报告…** 会保存一份文本报告，内容包括你的配置、OpenWithPanel 管理的每个类型当前由哪个 App 打开、本次运行的日志，以及你刚诊断过的文件。报告问题时请把它发给开发者。

## 设置

打开 **OpenWithPanel › 设置…** 或按 `⌘,`。

**通用**

- **语言**：选择**跟随系统**或 15 种语言之一，然后点按**立即重新打开**。如果有未应用的更改，请先应用或放弃。
- **开发者模式**：显示更多细节，见[开发者模式](#开发者模式)。它只改变显示内容，从不改动你的设置。

**文件夹规则**

这是无扩展名文件所用的方法失效时的备用方案。添加一个文件夹并选择一个 App，OpenWithPanel 就会给该文件夹里每个无扩展名的文本文件单独设置**打开方式**为这个 App。

- 二进制文件和你自己设置过的文件不会被改动。
- 每次打开 OpenWithPanel 时会处理新文件，也可以点**立即应用**马上处理。
- **撤销全部文件夹设置**会把 OpenWithPanel 改过的每个文件恢复原样。
- **跳过以下名称的文件夹**可以编辑；默认列出的是诊断中文件夹扫描所跳过的那些文件夹。

**历史**

列出每次应用前保存的快照，最多 20 份，最新的在最前面。最后一份**初始（OpenWithPanel 改动任何设置之前）** 是你第一次打开 OpenWithPanel 时记录的状态。任意一份都可以用**恢复…** 来恢复，恢复前会先预览差异。

**OpenWithPanel 写了什么**

列出 OpenWithPanel 在你的 Mac 上更改或写入的每一个位置，每项都带有**在访达中显示**：

- **文件关联**：OpenWithPanel 管理的项目（文件类型和链接）有多少个；
- **LaunchServices 偏好条目**：OpenWithPanel 为文件类型写入的条目，包括无扩展名文件；
- **OpenWithPanel Helper**：位于 OpenWithPanel App 内；
- **规则与快照**：`~/Library/Application Support/net.zhaojian.openwithpanel/`；
- **逐个文件的“打开方式”设置**：只有在你使用过文件夹规则时才会出现。

OpenWithPanel 不在后台运行，没有登录项，也不收集数据。只有在你选择 **检查更新…** 时才会联网，从 GitHub 读取最新的版本号。

### 卸载

在 **OpenWithPanel 写了什么**底部点按**卸载 OpenWithPanel…**，并选择是否同时删除规则与快照。随后 OpenWithPanel 会：

1. 把它改过的每种文件类型和链接指回原来的 App；
2. 撤销文件夹规则所做的每一项逐个文件的设置；
3. 按你的选择删除或保留 `~/Library/Application Support/net.zhaojian.openwithpanel/`；
4. 把自己移到废纸篓。

如果有任何文件类型或链接无法指回，例如你在系统确认框里拒绝了，卸载会停止，不删除任何东西。

如果保留了规则与快照，重新安装 OpenWithPanel 后会出现一个横幅，一键就能恢复全部设置。有些清理工具会在 App 被移到废纸篓时删除它的残留文件，这可能把你选择保留的规则与快照也一并删掉；请让这类工具跳过 OpenWithPanel。

如果你直接把 OpenWithPanel 拖到废纸篓，OpenWithPanel Helper 会随之一起删除，macOS 会丢弃指向它的关联；其他类型则保留 OpenWithPanel 设置的 App。Application Support 文件夹里的 `UNINSTALL.txt` 说明了这种情况下如何恢复它们。

## 开发者模式

在**设置 › 通用**中打开。打开后会增加：

- 每个格式下方显示系统类型标识符（UTI），经由 OpenWithPanel Helper 中转的格式带有**辅助程序**标记；
- 诊断中的完整判定链：类型、父类型、文本还是二进制、判定结果，以及每个能打开该文件的 App 在其 Info.plist 中如何声明它（匹配的扩展名或类型、角色和优先级）；
- 主窗口中的**规则**标签页；
- 设置中的**非文本文件**处理方式和**预设**。

**规则**决定 OpenWithPanel Helper 把收到的文件交给谁。一条规则包括：

- 条件，至少要填一项：文件名模式（如 `Dockerfile*`，不区分大小写）、所在文件夹（如 `~/Projects`），以及内容是文本还是二进制；
- 适用的类型，默认是 `public.data`（无扩展名文件）；你添加的其他类型也会经由 OpenWithPanel Helper 中转；
- 文件的去向：某个 App、**在访达中显示**，或**原来的 App**。

规则从上到下依次检查，第一条匹配的生效。拖动可以调整顺序；左侧的开关可以临时停用某条规则。受规则影响的分组在标准模式下显示**由规则控制**。

**非文本文件**设置 OpenWithPanel Helper 如何处理二进制文件：**在访达中显示**（默认）、**用同一个 App 打开**，或**用原来的 App 打开**。

**预设**把你的分组设置、单个格式的设置、自定义扩展名和规则导出为 JSON 文件，可以在另一台 Mac 上导入；导入的设置在点按**应用**后生效。文件夹规则和原来的 App 的记录是每台 Mac 各自的，所以既不会导出，导入时也不会被覆盖。

## 工作原理

OpenWithPanel 在自己的 App 包内附带一个极小的辅助程序：**OpenWithPanel Helper**。当你为无扩展名文件选择编辑器时，OpenWithPanel 把 `public.data` 指向这个辅助程序。打开这类文件时，辅助程序检查你的规则和文件内容，把文本文件交给你选定的 App，在访达中显示二进制文件，然后退出。它不会常驻：只有当 macOS 有文件或链接要交给它时才会启动它，空闲不到一秒就会退出。它没有窗口，也不会出现在程序坞中。设为**不打开**的链接也会交给辅助程序，辅助程序直接忽略它们。

如果文件的前 8 KB 含有空字节，或者不是有效的 UTF-8，就视为二进制文件。

你选定的 App 本来就支持的文件类型（如 `.md` 或 `.py`）会直接分配给该 App，不经过辅助程序。

macOS 没有提供为 `public.data` 设置默认 App 的公开 API，而且从 macOS 26.4 起，公开 API 每更改一种文件类型都要确认一次。所以 OpenWithPanel 把所有文件类型的更改一次写入 LaunchServices 偏好设置，并重启一次 `lsd` 服务使其生效。这一机制没有 Apple 官方文档，系统更新后可能失效。如果某项更改没有生效，OpenWithPanel 会改用公开 API，届时需要你确认；对于无扩展名文件，则提供文件夹规则作为替代。

## 常见问题

**Mac 上怎么更改无扩展名文件的默认 App？**
打开 OpenWithPanel，为**无扩展名文件**选择一个 App，然后点按**应用**。之后 `.env`、`Dockerfile` 这类文件就会用该 App 打开。

**为什么访达的“全部更改”对 `.env` 文件不起作用？**
macOS 把它们当作通用数据（`public.data`），并且不允许通过公开 API 更改这一类型的默认 App。OpenWithPanel 借助辅助程序绕过了这个限制。

**怎么把 VS Code、Zed 或 Sublime Text 设为代码文件的默认编辑器？**
为**代码**分组或单个格式选择该编辑器，然后点按**应用**。没有 macOS 正式类型的扩展名（如 `.go` 和 `.rs`）同样适用。

**能撤销所有更改吗？**
可以。OpenWithPanel 首次运行时会记录原始关联，并且永远不会覆盖这份记录。**恢复到初始**会把每个改过的类型指回原来的 App。

**OpenWithPanel 会收集数据或在后台运行吗？**
不会。它不收集数据，只在你选择 **检查更新…** 时联网，不安装后台代理，退出后也不会继续运行。**设置 › OpenWithPanel 写了什么**列出了它写入的每一个位置。

**为什么 OpenWithPanel 不使用沙盒？**
macOS 不允许沙盒中的 App 更改默认 App。OpenWithPanel 改为启用强化运行时（hardened runtime）。

## 已知限制

- 在 macOS 上，`.ts` 被识别为视频格式（MPEG-2 传输流），更改它会影响真正的视频文件，所以代码分组只包含 TypeScript 的 `.tsx`。同样，`.r`、`.exs` 和 `.fs` 在 macOS 看来分别是 Rez 资源、Logic 采样器文件和着色器，也不在代码分组里。
- 文件类型设置依赖一个没有文档的系统机制，系统更新后可能失效。如果失效，普通文件类型会自动改用系统 API（每个类型确认一次），无扩展名文件则可以改用文件夹规则。
- macOS 只允许 App 读取自己进程的日志，所以诊断报告不包含 OpenWithPanel Helper 的日志。如有需要，请在“控制台” App 中搜索 `net.zhaojian.openwithpanel`。
- 界面翻译尚未经过母语者审校。

## 从源码构建

需要 Xcode 27。

```sh
swift test --package-path OpenWithPanelKit
xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel build
```

构建 DMG：

```sh
scripts/package.sh
```

产物输出到 `.build/dist/`，同时还有一个由 `packaging/openwithpanel.rb` 生成、已填入版本号和校验和的 Homebrew cask。不设置环境变量时，App 使用 ad hoc 签名，不经过公证，这时 DMG 里会附带 `First Launch.txt`。设置 `DEVELOPER_ID`（Developer ID Application 证书名称）即可用该证书签名；再设置 `NOTARY_PROFILE`（用 `xcrun notarytool store-credentials` 保存的凭证配置）即可进行公证并装订公证票据。

发布版由 GitHub Actions 工作流 `.github/workflows/release.yml` 构建。它如何签名、如何发布新版本，见 [docs/release.md](../release.md)。

## 项目结构

- `OpenWithPanelKit/`：本地 Swift 包。`OpenWithPanelCore` 包含全部逻辑；`OpenWithPanelPlatform` 封装系统 API。
- `Apps/OpenWithPanel/`：主 App（SwiftUI）。
- `Apps/Helper/`：内嵌在主 App 包中的辅助程序。
- `scripts/`、`packaging/`：打包脚本和 Homebrew cask 模板。

## 许可证

[MIT](../../LICENSE) © 2026 zhaoJian
