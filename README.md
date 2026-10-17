<p align="center">
  <img src="docs/assets/icon.png" width="128" alt="OpenWithPanel app icon">
</p>

<h1 align="center">OpenWithPanel</h1>

<p align="center">
  <strong>Set which app opens what on your Mac — including the files macOS won't let you.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26 or later">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

<p align="center">
  <b>English</b> ·
  <a href="docs/i18n/README.zh-Hans.md">简体中文</a> ·
  <a href="docs/i18n/README.zh-Hant.md">繁體中文</a> ·
  <a href="docs/i18n/README.ja.md">日本語</a> ·
  <a href="docs/i18n/README.ko.md">한국어</a> ·
  <a href="docs/i18n/README.de.md">Deutsch</a> ·
  <a href="docs/i18n/README.fr.md">Français</a> ·
  <a href="docs/i18n/README.es.md">Español</a> ·
  <a href="docs/i18n/README.pt.md">Português</a> ·
  <a href="docs/i18n/README.id.md">Bahasa Indonesia</a> ·
  <a href="docs/i18n/README.th.md">ไทย</a> ·
  <a href="docs/i18n/README.vi.md">Tiếng Việt</a> ·
  <a href="docs/i18n/README.ar.md">العربية</a> ·
  <a href="docs/i18n/README.ru.md">Русский</a> ·
  <a href="docs/i18n/README.hi.md">हिन्दी</a>
</p>

OpenWithPanel is a free, open-source macOS app for managing **default apps**: choose which app opens each file type, file extension and link, in one window. It can also do something Finder can't: make your editor the default app for **files without an extension**, such as `.env`, `.gitignore`, `Dockerfile` and `.npmrc`.

<p align="center">
  <img src="docs/assets/screenshot.png" width="720" alt="OpenWithPanel main window">
</p>

## Contents

- [Why OpenWithPanel](#why-openwithpanel)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Diagnose](#diagnose)
- [Settings](#settings)
- [Developer mode](#developer-mode)
- [How it works](#how-it-works)
- [FAQ](#faq)
- [Known limitations](#known-limitations)
- [Build from source](#build-from-source)

## Why OpenWithPanel

macOS classifies most files without an extension as `public.data`, and it refuses to let any app become the default for that type. Finder's **Get Info › Open with › Change All…** has no effect on these files, and command-line tools fail with error `-50`. Finder's **Always Open With** only applies to the single file you selected.

So `.env`, `.gitignore`, `Dockerfile` and similar files keep opening in TextEdit — or don't open at all — no matter what you set. OpenWithPanel fixes this with a small helper app called OpenWithPanel Helper, described in [How it works](#how-it-works).

It also covers what macOS leaves out elsewhere: when a newly installed app (typically Xcode) takes over your file associations, macOS doesn't tell you, and there is no button to put things back the way they were.

## Features

- **Default apps by group.** File types are grouped by purpose — Text, Markdown, Code, Config & Data, Files Without Extension, PDF, Documents, Images, Video, Audio, Archives — and each group has one app menu.
- **Apply in one go.** Set a whole group of formats at once without confirming each one; changes take effect in a few seconds.
- **Per-format exceptions.** Expand a group to give a single format, such as `.md` or `.py`, its own app. Changing the group's app later leaves the exceptions alone.
- **Files without an extension.** Open `.env`, `Dockerfile`, `.gitignore` and other extensionless files in the editor of your choice, even if that editor doesn't declare support for them.
- **Custom extensions.** Add any extension that isn't listed, including ones macOS only knows as temporary types, such as `.go`, `.rs`, `.kt`, `.dart` and `.lua`.
- **Default apps for links.** Choose the app for web links (`http`, `https`), email (`mailto`), calendar subscriptions (`webcal`), phone calls, text messages, FaceTime, SSH, FTP and screen sharing — or choose **Don't Open** so that clicking such a link does nothing.
- **Search by extension.** Type `py` or `env` to jump straight to the right row.
- **Diagnose any file.** Drop a file to see why it opens in a certain app, then pick a different one right there. Drop a folder to find files with their own **Open With** setting and clear them.
- **Takeover alerts.** If another app (Xcode, a browser) takes over an association you set, OpenWithPanel shows a banner with a one-click fix.
- **Undo and restore.** A snapshot is saved before every change. Undo with `⌘Z`, restore any earlier snapshot, or restore everything to how it was before OpenWithPanel changed anything, with a preview of each change first.
- **Folder rules.** An optional fallback that sets extensionless files inside chosen folders, such as `~/Projects`, to open in your editor, using only official macOS APIs.
- **Developer mode.** Rules that route files by name pattern (for example `Dockerfile*`), folder or text-vs-binary content; the full decision chain in diagnostics, including each app's declared types and rank; preset import and export.
- **Clean uninstall.** The built-in uninstaller restores every association to its original app before moving OpenWithPanel to the Trash.
- **15 languages.** English, Simplified Chinese, Traditional Chinese, Japanese, Korean, German, French, Spanish, Portuguese, Indonesian, Thai, Vietnamese, Arabic, Russian and Hindi, switchable inside the app.

## Installation

Requires macOS 26 Tahoe or later.

1. Open the [Releases page](https://github.com/zhaojiannet/openwithpanel/releases) and, under **Assets** of the latest release, download `OpenWithPanel-<version>.dmg`.
2. Double-click the downloaded DMG to open it.
3. Drag **OpenWithPanel** onto the **Applications** folder shown in the same window.
4. Eject the DMG, then open OpenWithPanel from the Applications folder. The first time, macOS asks you to allow it; see [First launch](#first-launch).

There is no installer and no administrator password is needed.

**Updating:** download the new DMG and drag OpenWithPanel into Applications again, replacing the old copy. Your settings, rules and snapshots are kept.

**Uninstalling:** see [Uninstall](#uninstall).

### First launch

OpenWithPanel isn't notarized by Apple yet, so macOS blocks it the first time you open it. Allow it once:

1. Double-click OpenWithPanel. When macOS says it could not verify OpenWithPanel, click **Done**. Don't click the blue **Move to Trash** button.

   <img src="docs/assets/first-launch-1.png" width="372" alt="The first warning: click Done">

2. Open **System Settings › Privacy & Security**, scroll down to **Security**, and click **Open Anyway** next to OpenWithPanel. The button is there for about an hour after step 1.

   <img src="docs/assets/first-launch-2.png" width="560" alt="Privacy & Security: click Open Anyway">

3. Enter your login password or use Touch ID. In the dialog that follows, click **Open Anyway** again.

   <img src="docs/assets/first-launch-3.png" width="372" alt="The confirmation: click Open Anyway">

After this, OpenWithPanel opens normally. Its built-in helper is allowed along with it, so files without an extension open without further prompts. The DMG also contains these steps in `First Launch.txt`.

## Usage

### File type groups

The **File Types** tab lists every group as a card:

| Group | Includes |
|---|---|
| Text | `.txt` `.log` |
| Markdown | `.md` `.markdown` |
| Code | Popular programming languages, see below |
| Config & Data | `.json` `.yaml` `.toml` `.xml` `.ini` `.plist` `.csv` |
| Files Without Extension | `.env` `Dockerfile` `.gitignore` and similar |
| PDF | `.pdf` |
| Documents | `.rtf` `.docx` `.doc` `.pages` `.odt` |
| Images, Video, Audio, Archives | Their common formats |
| Custom | Extensions you added that fit no other group; shown only when it has any |

The Code group covers the languages used by at least 5% of respondents in the Stack Overflow 2025 Developer Survey: JavaScript, TypeScript (`.tsx`), Python, Java, C, C++, C#, PHP, Ruby, Swift, Go, Rust, Kotlin, Dart, Lua, Shell (sh, bash, zsh), PowerShell, SQL and assembly, plus CSS, Makefile and JSX. Add others yourself, see [Add an extension](#add-an-extension).

### Set an app for a whole group

Pick an app from the menu on the right of a card. Every format in the group then opens in it. The menu lists the apps macOS considers able to open the group; choose **Other…** to pick any app from the Applications folder.

### Give one format its own app

Click a group's row, or the arrow on its left, to expand it. Each format has its own row, with the system icon for that file and its extension as the title. Choose a different app in a row's menu and that format uses it from then on; the row is marked **Set separately**, and the group row shows how many formats are set separately.

- A format without its own app shows a grey **Same as Group** in its menu.
- To make a format follow the group again, choose **Follow Group** in its menu.
- Changing the group's app later leaves formats with their own app alone.

Groups with more than 8 formats show only the formats you set separately or added yourself; **Show All N Formats** at the bottom lists the rest. When the Code group shows everything, it is split into sections such as Web, Systems & Apps, JVM and Scripting & Shell.

### Search

Type an extension, such as `py` or `env`, into the search field at the top right. The matching group expands with all its formats and the matching row is highlighted. If the extension isn't in any group, the search result offers **Add…**.

### Add an extension

Use **Add Extension…** at the bottom of the list, or **Add…** in a search result.

1. Type the extension, such as `nim`. The sheet shows what macOS recognizes it as.
2. OpenWithPanel suggests a group based on that: source code goes to Code, images to Images, anything unrecognized to Custom. You can pick another group.
3. Click **Add**. The format appears in that group, marked **Custom**, and follows the group's app; you can also give it its own app.

An extension that is already in a group isn't added twice; the sheet tells you which group it is in. Formats you added have a remove button on their row.

### Apply

Every change above is staged first. A bar at the bottom of the window shows how many changes are pending; **Apply** makes them take effect and **Discard** drops them.

- File type changes don't ask for confirmation. However many formats you change, OpenWithPanel writes them to the system preferences at once and has the system reload them a single time; everything takes effect in a few seconds.
- Changes to links and to web files (`.html`) still ask you to confirm in a system dialog, for example when you change your web browser. Silently changing the browser is what browser hijackers do, so macOS should ask you directly.
- If writing fails (for example because of permissions), or a format doesn't take effect, OpenWithPanel sets it again through the system API, one by one; macOS then asks whether to use the new app or keep the old one. If you keep the old one, OpenWithPanel records the format as set separately to that app and leaves it alone from then on.
- After applying, OpenWithPanel reads back the actual system state, so the list always shows what really took effect.

### Undo and restore

- **Edit › Undo** (`⌘Z`) undoes the last apply. You can undo several times in a row.
- The round arrow button in the toolbar is **Restore Initial**: every file type and link OpenWithPanel changed points back to the app it used when you first opened OpenWithPanel. Each change is listed before anything happens.

macOS has no way to remove a file association, only to point it at another app, so restoring means pointing each type back to the app recorded in the snapshot. A type that macOS used to pick on its own gets an explicit setting for that same app afterwards; it opens exactly as before.

### Links

Below the file types, a card sets the app for each kind of link:

| Row | URL schemes |
|---|---|
| Web Browser | `http:` `https:` |
| Email | `mailto:` |
| Calendar Subscriptions | `webcal:` |
| Phone Calls, Text Messages, FaceTime | `tel:` `sms:` `facetime:` |
| SSH, FTP, Screen Sharing | `ssh:` `ftp:` `vnc:` |

Every kind of link that some app on your Mac can handle is listed. At the bottom of each menu is **Don't Open**: choose it and clicking that kind of link in any app does nothing — for example, so a phone number on a web page doesn't start a call. To undo it, choose an app in the menu again. Choosing **Don't Open** for the web browser asks for confirmation first, since no web link would open at all. You can also search for a scheme (such as `mailto`) or a row name.

Links are staged, applied, snapshotted, undone and restored just like file types. Changing the web browser asks for confirmation in a system dialog; on macOS 27, changing `http` also changes `https`, and OpenWithPanel then skips setting `https` again, so you confirm only once.

## Diagnose

Switch to the **Diagnose** tab at the top of the window.

**Why does a file open in this app?** Drop a file into the dashed box. The result shows which app opens it and why:

- the file has its own **Open With** setting, made in Finder's **Get Info**;
- OpenWithPanel Helper received it and a rule or a group setting sent it to an app;
- you chose this app for this kind of file;
- nothing was set, so macOS picked the app.

Below the result, **Use instead** switches to another app directly. If the file has its own **Open With** setting, **Remove This File's Own Setting** appears instead.

**Find files with their own "Open with" setting.** Drop a folder into the dashed box. OpenWithPanel lists every file in it that has its own **Open With** setting, with the app it points to. Select files and click **Remove Their Own Settings**; they then follow the setting for their kind. The scan skips `.git`, `node_modules`, `.build`, `DerivedData`, `Pods`, `vendor`, `.venv` and `__pycache__` folders.

**Export a diagnostic report.** **Export Diagnostic Report…** at the bottom of the tab saves a text report with your configuration, which app currently opens each type OpenWithPanel manages, this session's log and the file you just diagnosed. Send it to the developer when reporting a problem.

## Settings

Open **OpenWithPanel › Settings…** or press `⌘,`.

**General**

- **Language:** choose **Follow System** or one of the 15 languages, then click **Relaunch Now**. If there are unapplied changes, apply or discard them first.
- **Developer mode:** shows more detail, see [Developer mode](#developer-mode). It only changes what is displayed, never your settings.

**Folder Rules**

A fallback for when the method used for files without an extension stops working. Add a folder and choose an app, and OpenWithPanel gives every extensionless text file in that folder its own **Open With** setting for that app.

- Binary files, and files you set yourself, are left alone.
- New files are handled each time you open OpenWithPanel, or right away with **Apply Now**.
- **Undo All Folder Settings** puts every file OpenWithPanel changed back the way it was.
- **Skip folders named** is editable; by default it lists the folders the folder scan in Diagnose skips.

**History**

Lists the snapshot saved before each apply, up to 20, newest first. The last one, **Initial (before OpenWithPanel changed anything)**, is the state recorded the first time you opened OpenWithPanel. Any of them can be restored with **Restore…**, with a preview of the differences first.

**What OpenWithPanel Wrote**

Lists every place OpenWithPanel changes or writes on your Mac, each with **Show in Finder**:

- **File associations:** how many items (file types and links) OpenWithPanel manages;
- **LaunchServices preference entries:** the entries OpenWithPanel wrote for file types, including files without an extension;
- **OpenWithPanel Helper:** inside the OpenWithPanel app;
- **Rules and snapshots:** `~/Library/Application Support/net.zhaojian.openwithpanel/`;
- **Per-file "Open with" settings:** only present if you used folder rules.

OpenWithPanel doesn't run in the background, has no login item, makes no network connections and collects no data.

### Uninstall

At the bottom of **What OpenWithPanel Wrote**, click **Uninstall OpenWithPanel…** and choose whether to delete rules and snapshots as well. OpenWithPanel then:

1. points every file type and link it changed back to its original app;
2. undoes every per-file setting made by folder rules;
3. deletes or keeps `~/Library/Application Support/net.zhaojian.openwithpanel/` as you chose;
4. moves itself to the Trash.

If any file type or link can't be pointed back — for example, because you declined a system confirmation — the uninstall stops and nothing is removed.

If you keep rules and snapshots, reinstalling OpenWithPanel shows a banner that puts all your settings back with one click. App-cleaning tools that delete an app's leftover files when it's moved to the Trash may also delete the rules and snapshots you chose to keep; tell such a tool to skip OpenWithPanel.

If you drag OpenWithPanel to the Trash yourself instead, OpenWithPanel Helper goes with it and macOS drops the associations that pointed to it; other types keep the apps OpenWithPanel set. A `UNINSTALL.txt` file in the Application Support folder explains how to restore them in that case.

## Developer mode

Turn it on in **Settings › General**. It adds:

- the system type identifier (UTI) under each format, and a **Helper** badge on formats routed through OpenWithPanel Helper;
- the full decision chain in diagnostics: type, parent types, text or binary, the decision, and how each app that can open the file declares it in its Info.plist (matching extension or type, role and rank);
- a **Rules** tab in the main window;
- the handling of **Files that are not text** and **Presets** in Settings.

**Rules** decide where OpenWithPanel Helper sends the files it receives. A rule has:

- conditions, at least one of which must be filled in: a file name pattern (such as `Dockerfile*`, case-insensitive), a containing folder (such as `~/Projects`), and whether the content is text or binary;
- the types it applies to, `public.data` (files without an extension) by default; other types you add are routed through OpenWithPanel Helper as well;
- where to send the file: an app, **Show in Finder**, or the **Original app**.

Rules are checked from top to bottom and the first match wins. Drag to reorder; the switch on the left turns a rule off temporarily. Groups affected by rules show **Controlled by rules** in standard mode.

**Files that are not text** sets what OpenWithPanel Helper does with binary files: **Show in Finder** (default), **Open with the same app**, or **Open with the original app**.

**Presets** export your group settings, per-format settings, custom extensions and rules to a JSON file that you can import on another Mac; imported settings take effect after you click **Apply**. Folder rules and original-app records are specific to each Mac, so they are neither exported nor overwritten on import.

## How it works

OpenWithPanel ships a tiny helper app, **OpenWithPanel Helper**, inside its app bundle. When you choose an editor for files without an extension, OpenWithPanel points `public.data` at the helper. When you open such a file, the helper checks your rules and the file's content, hands text files to your chosen app, shows binary files in Finder, and quits. It doesn't stay running: macOS starts it only when it has a file or link to deliver, and it exits after less than a second of idle time. It has no window and doesn't appear in the Dock. Links set to **Don't Open** are sent to the helper too, which simply ignores them.

A file counts as binary if its first 8 KB contain a null byte or aren't valid UTF-8.

File types that your chosen app already supports, such as `.md` or `.py`, are assigned to that app directly, without the helper.

macOS doesn't offer a public API to set a default app for `public.data`, and since macOS 26.4 its public API asks for confirmation for every single file type you change. So OpenWithPanel writes all file type changes to the LaunchServices preferences at once and restarts the `lsd` service once so they take effect. This mechanism isn't documented by Apple and may stop working after a system update. If a change doesn't take effect, OpenWithPanel falls back to the public API, which asks you to confirm; for files without an extension, it offers folder rules instead.

## FAQ

**How do I change the default app for files without an extension on a Mac?**
Open OpenWithPanel, choose an app for **Files Without Extension**, and press **Apply**. Files like `.env` and `Dockerfile` then open in that app.

**Why doesn't Finder's "Change All" work for `.env` files?**
macOS treats them as generic data (`public.data`) and blocks changing the default app for that type through its public APIs. OpenWithPanel works around this with its helper app.

**How do I make VS Code, Zed or Sublime Text the default editor for code files?**
Choose the editor for the **Code** group, or for individual formats, and press **Apply**. Extensions without an official macOS type, such as `.go` and `.rs`, are covered too.

**Can I undo everything?**
Yes. OpenWithPanel records the original associations the first time it runs and never overwrites that record. **Restore Initial** points every changed type back to its original app.

**Does OpenWithPanel collect data or run in the background?**
No. It makes no network connections, collects no data, installs no background agents and doesn't stay running after you quit. **Settings › What OpenWithPanel Wrote** lists every place it writes to.

**Why isn't OpenWithPanel sandboxed?**
macOS doesn't allow sandboxed apps to change default apps. OpenWithPanel uses the hardened runtime instead.

## Known limitations

- On macOS, `.ts` is recognized as a video format (MPEG-2 transport stream), and changing it would affect real video files, so the Code group only covers TypeScript's `.tsx`. Likewise `.r`, `.exs` and `.fs` are Rez resources, Logic sampler files and shaders to macOS and aren't in the Code group.
- File type settings rely on an undocumented system mechanism that may stop working after a system update. If it does, ordinary file types automatically fall back to the system API (one confirmation per type), and files without an extension can use folder rules instead.
- macOS only lets an app read its own process's log, so the diagnostic report doesn't include OpenWithPanel Helper's log. Search for `net.zhaojian.openwithpanel` in the Console app if you need it.
- The interface translations haven't been reviewed by native speakers yet.

## Build from source

Requires Xcode 27.

```sh
swift test --package-path OpenWithPanelKit
xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel build
```

To build a DMG:

```sh
scripts/package.sh
```

The output goes to `.build/dist/`, together with a Homebrew cask generated from `packaging/openwithpanel.rb` with the version and checksum filled in. Without environment variables the app is signed ad hoc and isn't notarized; the DMG then includes `First Launch.txt`. Set `DEVELOPER_ID` (a Developer ID Application certificate name) to sign with it, and also set `NOTARY_PROFILE` (a credential profile saved with `xcrun notarytool store-credentials`) to notarize and staple.

Releases are built by the GitHub Actions workflow in `.github/workflows/release.yml`. How it signs, and how to publish a release, is described in [docs/release.md](docs/release.md).

## Project structure

- `OpenWithPanelKit/`: a local Swift package. `OpenWithPanelCore` holds all the logic; `OpenWithPanelPlatform` wraps the system APIs.
- `Apps/OpenWithPanel/`: the main app (SwiftUI).
- `Apps/Helper/`: the helper embedded in the main app bundle.
- `scripts/`, `packaging/`: the packaging script and the Homebrew cask template.

## License

[MIT](LICENSE) © 2026 zhaoJian
