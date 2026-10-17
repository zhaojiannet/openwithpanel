<p align="center">
  <img src="../assets/icon.png" width="128" alt="App-Symbol von OpenWithPanel">
</p>

<h1 align="center">OpenWithPanel</h1>

<p align="center">
  <strong>Lege fest, welche App was auf deinem Mac öffnet – auch bei den Dateien, bei denen macOS dich nicht lässt.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26 oder neuer">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT-Lizenz">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <b>Deutsch</b> ·
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

OpenWithPanel ist eine kostenlose Open-Source-App für macOS zum Verwalten von **Standard-Apps**: Wähle in einem einzigen Fenster, welche App jeden Dateityp, jede Dateiendung und jeden Link öffnet. Außerdem kann sie, was der Finder nicht kann: deinen Editor zur Standard-App für **Dateien ohne Endung** machen, etwa `.env`, `.gitignore`, `Dockerfile` und `.npmrc`.

<p align="center">
  <img src="../assets/screenshot.png" width="720" alt="Hauptfenster von OpenWithPanel">
</p>

## Inhalt

- [Warum OpenWithPanel](#warum-openwithpanel)
- [Funktionen](#funktionen)
- [Installation](#installation)
- [Verwendung](#verwendung)
- [Diagnose](#diagnose)
- [Einstellungen](#einstellungen)
- [Entwicklermodus](#entwicklermodus)
- [Funktionsweise](#funktionsweise)
- [Häufige Fragen](#häufige-fragen)
- [Bekannte Einschränkungen](#bekannte-einschränkungen)
- [Aus dem Quellcode bauen](#aus-dem-quellcode-bauen)

## Warum OpenWithPanel

macOS ordnet die meisten Dateien ohne Endung dem Typ `public.data` zu und verweigert es, irgendeine App zum Standard für diesen Typ zu machen. **Informationen › Öffnen mit › Alle ändern …** im Finder wirkt sich auf diese Dateien nicht aus, und Befehlszeilentools scheitern mit dem Fehler `-50`. **Immer öffnen mit** im Finder gilt nur für die einzelne Datei, die du ausgewählt hast.

Deshalb öffnen sich `.env`, `.gitignore`, `Dockerfile` und ähnliche Dateien weiterhin in TextEdit – oder gar nicht –, egal was du einstellst. OpenWithPanel löst das mit einer kleinen Hilfs-App namens OpenWithPanel Helper, beschrieben unter [Funktionsweise](#funktionsweise).

Außerdem deckt OpenWithPanel ab, was macOS an anderer Stelle auslässt: Wenn eine neu installierte App (typischerweise Xcode) deine Dateizuordnungen übernimmt, sagt macOS dir nichts, und es gibt keine Taste, um alles wieder so herzustellen, wie es war.

## Funktionen

- **Standard-Apps nach Gruppen.** Dateitypen sind nach Zweck gruppiert – Text, Markdown, Code, Konfiguration & Daten, Dateien ohne Endung, PDF, Dokumente, Bilder, Video, Audio, Archive –, und jede Gruppe hat ein App-Menü.
- **In einem Rutsch anwenden.** Lege eine ganze Gruppe von Formaten auf einmal fest, ohne jedes einzeln zu bestätigen; Änderungen wirken in wenigen Sekunden.
- **Ausnahmen pro Format.** Klappe eine Gruppe auf, um einem einzelnen Format wie `.md` oder `.py` eine eigene App zu geben. Änderst du später die App der Gruppe, bleiben die Ausnahmen unberührt.
- **Dateien ohne Endung.** Öffne `.env`, `Dockerfile`, `.gitignore` und andere Dateien ohne Endung im Editor deiner Wahl, selbst wenn dieser Editor keine Unterstützung dafür deklariert.
- **Eigene Dateiendungen.** Füge jede Endung hinzu, die nicht aufgeführt ist, auch solche, die macOS nur als temporäre Typen kennt, etwa `.go`, `.rs`, `.kt`, `.dart` und `.lua`.
- **Standard-Apps für Links.** Wähle die App für Weblinks (`http`, `https`), E-Mail (`mailto`), Kalenderabos (`webcal`), Anrufe, SMS, FaceTime, SSH, FTP und Bildschirmfreigabe – oder wähle **Nicht öffnen**, damit ein Klick auf einen solchen Link nichts bewirkt.
- **Suche nach Endung.** Tippe `py` oder `env`, um direkt zur passenden Zeile zu springen.
- **Jede Datei diagnostizieren.** Lege eine Datei ab, um zu sehen, warum sie in einer bestimmten App geöffnet wird, und wähle direkt dort eine andere. Lege einen Ordner ab, um Dateien mit eigener **Öffnen mit**-Einstellung zu finden und diese zu entfernen.
- **Hinweis bei Übernahme.** Übernimmt eine andere App (Xcode, ein Browser) eine von dir festgelegte Zuordnung, zeigt OpenWithPanel ein Banner, über das du sie mit einem Klick zurückholst.
- **Widerrufen und wiederherstellen.** Vor jeder Änderung wird ein Schnappschuss gesichert. Widerrufe mit `⌘Z`, stelle einen beliebigen früheren Schnappschuss wieder her oder setze alles auf den Stand zurück, bevor OpenWithPanel etwas geändert hat – jeweils mit einer Vorschau jeder Änderung.
- **Ordnerregeln.** Ein optionaler Ausweichweg, der Dateien ohne Endung in ausgewählten Ordnern wie `~/Projects` in deinem Editor öffnen lässt und dabei nur offizielle macOS-APIs nutzt.
- **Entwicklermodus.** Regeln, die Dateien nach Namensmuster (zum Beispiel `Dockerfile*`), Ordner oder Inhalt (Text oder binär) weiterleiten; die vollständige Entscheidungskette in der Diagnose, einschließlich der deklarierten Typen und des Rangs jeder App; Import und Export von Voreinstellungen.
- **Saubere Deinstallation.** Das integrierte Deinstallationsprogramm stellt jede Zuordnung auf ihre ursprüngliche App zurück, bevor es OpenWithPanel in den Papierkorb legt.
- **15 Sprachen.** Englisch, vereinfachtes Chinesisch, traditionelles Chinesisch, Japanisch, Koreanisch, Deutsch, Französisch, Spanisch, Portugiesisch, Indonesisch, Thai, Vietnamesisch, Arabisch, Russisch und Hindi, umschaltbar in der App.

## Installation

Erfordert macOS 26 Tahoe oder neuer.

1. Öffne die [Releases-Seite](https://github.com/zhaojiannet/openwithpanel/releases) und lade unter **Assets** der neuesten Version `OpenWithPanel-<version>.dmg` herunter.
2. Doppelklicke auf das geladene DMG, um es zu öffnen.
3. Ziehe **OpenWithPanel** auf den Ordner **Programme**, der im selben Fenster angezeigt wird.
4. Wirf das DMG aus und öffne OpenWithPanel dann über den Ordner „Programme“. Beim ersten Mal fragt macOS, ob du es erlauben möchtest; siehe [Erster Start](#erster-start).

Es gibt kein Installationsprogramm, und es wird kein Administratorpasswort benötigt.

**Aktualisieren:** Lade das neue DMG herunter und ziehe OpenWithPanel erneut in „Programme“, um die alte Version zu ersetzen. Deine Einstellungen, Regeln und Schnappschüsse bleiben erhalten.

**Deinstallieren:** siehe [Deinstallieren](#deinstallieren).

### Erster Start

OpenWithPanel ist noch nicht von Apple notarisiert, deshalb blockiert macOS die App beim ersten Öffnen. Erlaube sie einmalig:

1. Doppelklicke auf OpenWithPanel. Wenn macOS meldet, dass OpenWithPanel nicht überprüft werden konnte, klicke auf **Fertig**. Klicke nicht auf die blaue Taste **In den Papierkorb legen**.

   <img src="../assets/first-launch-1.png" width="372" alt="Die erste Warnung: auf Fertig klicken">

2. Öffne **Systemeinstellungen › Datenschutz & Sicherheit**, scrolle nach unten zu **Sicherheit** und klicke neben OpenWithPanel auf **Dennoch öffnen**. Die Taste ist nach Schritt 1 etwa eine Stunde lang dort.

   <img src="../assets/first-launch-2.png" width="560" alt="Datenschutz & Sicherheit: auf Dennoch öffnen klicken">

3. Gib dein Anmeldepasswort ein oder verwende Touch ID. Klicke im anschließenden Dialog erneut auf **Dennoch öffnen**.

   <img src="../assets/first-launch-3.png" width="372" alt="Die Bestätigung: auf Dennoch öffnen klicken">

Danach öffnet sich OpenWithPanel ganz normal. Die integrierte Hilfs-App wird gleich mit erlaubt, sodass sich Dateien ohne Endung ohne weitere Rückfragen öffnen. Das DMG enthält diese Schritte auch in `First Launch.txt`. Die Bildschirmfotos zeigen die englische Oberfläche; in einem deutschen macOS heißen die Tasten so wie oben angegeben.

## Verwendung

### Dateityp-Gruppen

Der Tab **Dateitypen** listet jede Gruppe als Karte auf:

| Gruppe | Enthält |
|---|---|
| Text | `.txt` `.log` |
| Markdown | `.md` `.markdown` |
| Code | Verbreitete Programmiersprachen, siehe unten |
| Konfiguration & Daten | `.json` `.yaml` `.toml` `.xml` `.ini` `.plist` `.csv` |
| Dateien ohne Endung | `.env` `Dockerfile` `.gitignore` und ähnliche |
| PDF | `.pdf` |
| Dokumente | `.rtf` `.docx` `.doc` `.pages` `.odt` |
| Bilder, Video, Audio, Archive | Ihre gängigen Formate |
| Eigene | Von dir hinzugefügte Endungen, die in keine andere Gruppe passen; wird nur angezeigt, wenn es welche gibt |

Die Gruppe Code umfasst die Sprachen, die in der Stack Overflow Developer Survey 2025 von mindestens 5 % der Befragten genutzt werden: JavaScript, TypeScript (`.tsx`), Python, Java, C, C++, C#, PHP, Ruby, Swift, Go, Rust, Kotlin, Dart, Lua, Shell (sh, bash, zsh), PowerShell, SQL und Assembler, dazu CSS, Makefile und JSX. Weitere kannst du selbst hinzufügen, siehe [Dateiendung hinzufügen](#dateiendung-hinzufügen).

### App für eine ganze Gruppe festlegen

Wähle im Menü rechts auf einer Karte eine App. Jedes Format der Gruppe öffnet sich dann darin. Das Menü listet die Apps auf, die macOS für geeignet hält, die Gruppe zu öffnen; mit **Andere …** wählst du eine beliebige App aus dem Ordner „Programme“.

### Einem Format eine eigene App geben

Klicke auf die Zeile einer Gruppe oder auf den Pfeil links daneben, um sie aufzuklappen. Jedes Format hat eine eigene Zeile mit dem Systemsymbol für diese Datei und ihrer Endung als Titel. Wähle im Menü einer Zeile eine andere App, und das Format verwendet sie fortan; die Zeile wird mit **Eigene Einstellung** markiert, und die Gruppenzeile zeigt, wie viele Formate eine eigene Einstellung haben.

- Ein Format ohne eigene App zeigt in seinem Menü ein graues **Wie Gruppe**.
- Damit ein Format wieder der Gruppe folgt, wähle in seinem Menü **Gruppe folgen**.
- Änderst du später die App der Gruppe, bleiben Formate mit eigener App unberührt.

Gruppen mit mehr als 8 Formaten zeigen nur die Formate, die du eigens eingestellt oder selbst hinzugefügt hast; **Alle N Formate anzeigen** ganz unten listet den Rest. Wenn die Gruppe Code alles zeigt, ist sie in Abschnitte wie Web, Systeme & Apps, JVM und Skripte & Shell unterteilt.

### Suche

Tippe eine Endung wie `py` oder `env` in das Suchfeld oben rechts. Die passende Gruppe klappt mit allen Formaten auf, und die passende Zeile wird hervorgehoben. Ist die Endung in keiner Gruppe, bietet das Suchergebnis **Hinzufügen …** an.

### Dateiendung hinzufügen

Verwende **Dateiendung hinzufügen …** unten in der Liste oder **Hinzufügen …** in einem Suchergebnis.

1. Gib die Endung ein, etwa `nim`. Das Fenster zeigt, als was macOS sie erkennt.
2. OpenWithPanel schlägt auf dieser Grundlage eine Gruppe vor: Quellcode kommt zu Code, Bilder zu Bilder, alles Unbekannte zu Eigene. Du kannst eine andere Gruppe wählen.
3. Klicke auf **Hinzufügen**. Das Format erscheint in dieser Gruppe, markiert als **Eigene**, und folgt der App der Gruppe; du kannst ihm auch eine eigene App geben.

Eine Endung, die schon in einer Gruppe ist, wird nicht doppelt hinzugefügt; das Fenster sagt dir, in welcher Gruppe sie ist. Von dir hinzugefügte Formate haben in ihrer Zeile eine Taste zum Entfernen.

### Anwenden

Alle obigen Änderungen werden zunächst vorgemerkt. Eine Leiste unten im Fenster zeigt, wie viele Änderungen ausstehen; **Anwenden** setzt sie in Kraft, **Verwerfen** verwirft sie.

- Änderungen an Dateitypen erfordern keine Bestätigung. Egal wie viele Formate du änderst, OpenWithPanel schreibt sie auf einmal in die Systemeinstellungsdateien und lässt das System sie ein einziges Mal neu laden; alles wirkt in wenigen Sekunden.
- Änderungen an Links und an Webdateien (`.html`) musst du weiterhin in einem Systemdialog bestätigen, zum Beispiel wenn du den Webbrowser wechselst. Den Browser stillschweigend zu wechseln ist das, was Browser-Hijacker tun, deshalb sollte macOS dich direkt fragen.
- Schlägt das Schreiben fehl (zum Beispiel wegen fehlender Berechtigungen) oder wirkt ein Format nicht, setzt OpenWithPanel es einzeln über die System-API erneut; macOS fragt dann, ob die neue App verwendet oder die alte behalten werden soll. Behältst du die alte, vermerkt OpenWithPanel das Format als eigens auf diese App eingestellt und lässt es fortan in Ruhe.
- Nach dem Anwenden liest OpenWithPanel den tatsächlichen Systemzustand zurück, sodass die Liste immer zeigt, was wirklich in Kraft ist.

### Widerrufen und wiederherstellen

- **Bearbeiten › Widerrufen** (`⌘Z`) widerruft das letzte Anwenden. Du kannst mehrmals hintereinander widerrufen.
- Die Taste mit dem runden Pfeil in der Symbolleiste ist **Anfangszustand wiederherstellen**: Jeder Dateityp und jeder Link, den OpenWithPanel geändert hat, zeigt wieder auf die App, die beim ersten Öffnen von OpenWithPanel verwendet wurde. Jede Änderung wird aufgelistet, bevor etwas passiert.

macOS bietet keine Möglichkeit, eine Dateizuordnung zu entfernen, nur sie auf eine andere App zu richten. Wiederherstellen heißt daher, jeden Typ wieder auf die im Schnappschuss vermerkte App zu richten. Ein Typ, für den macOS die App zuvor selbst gewählt hat, erhält danach eine ausdrückliche Einstellung für genau diese App; er öffnet sich genau wie vorher.

### Links

Unterhalb der Dateitypen legt eine Karte die App für jede Art von Link fest:

| Zeile | URL-Schemata |
|---|---|
| Webbrowser | `http:` `https:` |
| E-Mail | `mailto:` |
| Kalenderabos | `webcal:` |
| Anrufe, SMS, FaceTime | `tel:` `sms:` `facetime:` |
| SSH, FTP, Bildschirmfreigabe | `ssh:` `ftp:` `vnc:` |

Jede Art von Link, die irgendeine App auf deinem Mac verarbeiten kann, wird aufgeführt. Ganz unten in jedem Menü steht **Nicht öffnen**: Wählst du es, bewirkt ein Klick auf diese Art von Link in keiner App etwas – etwa damit eine Telefonnummer auf einer Webseite keinen Anruf startet. Zum Rückgängigmachen wähle im Menü wieder eine App. **Nicht öffnen** für den Webbrowser verlangt vorher eine Bestätigung, da sich dann überhaupt kein Weblink mehr öffnen würde. Du kannst auch nach einem Schema (etwa `mailto`) oder einem Zeilennamen suchen.

Links werden genau wie Dateitypen vorgemerkt, angewendet, gesichert, widerrufen und wiederhergestellt. Den Webbrowser zu wechseln erfordert eine Bestätigung in einem Systemdialog; unter macOS 27 ändert eine Änderung an `http` auch `https`, und OpenWithPanel setzt `https` dann nicht noch einmal, sodass du nur einmal bestätigst.

## Diagnose

Wechsle oben im Fenster zum Tab **Diagnose**.

**Warum öffnet sich eine Datei in dieser App?** Lege eine Datei in das gestrichelte Feld. Das Ergebnis zeigt, welche App sie öffnet und warum:

- die Datei hat eine eigene **Öffnen mit**-Einstellung, vorgenommen im Finder unter **Informationen**;
- OpenWithPanel Helper hat sie empfangen, und eine Regel oder eine Gruppeneinstellung hat sie an eine App weitergegeben;
- du hast diese App für diese Art von Datei gewählt;
- nichts war festgelegt, also hat macOS die App gewählt.

Unter dem Ergebnis wechselt **Stattdessen verwenden** direkt zu einer anderen App. Hat die Datei eine eigene **Öffnen mit**-Einstellung, erscheint stattdessen **Eigene Einstellung dieser Datei entfernen**.

**Dateien mit eigener „Öffnen mit“-Einstellung finden.** Lege einen Ordner in das gestrichelte Feld. OpenWithPanel listet jede Datei darin auf, die eine eigene **Öffnen mit**-Einstellung hat, zusammen mit der App, auf die sie zeigt. Wähle Dateien aus und klicke auf **Ihre eigenen Einstellungen entfernen**; sie folgen dann der Einstellung für ihre Art. Die Suche überspringt die Ordner `.git`, `node_modules`, `.build`, `DerivedData`, `Pods`, `vendor`, `.venv` und `__pycache__`.

**Diagnosebericht exportieren.** **Diagnosebericht exportieren …** unten im Tab sichert einen Textbericht mit deiner Konfiguration, welcher App derzeit jeden von OpenWithPanel verwalteten Typ öffnet, dem Protokoll dieser Sitzung und der gerade diagnostizierten Datei. Schicke ihn an den Entwickler, wenn du ein Problem meldest.

## Einstellungen

Öffne **OpenWithPanel › Einstellungen …** oder drücke `⌘,`.

**Allgemein**

- **Sprache:** Wähle **Wie System** oder eine der 15 Sprachen und klicke dann auf **Jetzt neu starten**. Gibt es nicht angewendete Änderungen, wende sie zuerst an oder verwirf sie.
- **Entwicklermodus:** zeigt mehr Details, siehe [Entwicklermodus](#entwicklermodus). Er ändert nur die Anzeige, nie deine Einstellungen.

**Ordnerregeln**

Ein Ausweichweg für den Fall, dass die Methode für Dateien ohne Endung nicht mehr funktioniert. Füge einen Ordner hinzu und wähle eine App, und OpenWithPanel gibt jeder Textdatei ohne Endung in diesem Ordner eine eigene **Öffnen mit**-Einstellung für diese App.

- Binärdateien und Dateien, die du selbst eingestellt hast, bleiben unberührt.
- Neue Dateien werden bei jedem Öffnen von OpenWithPanel verarbeitet, oder sofort mit **Jetzt anwenden**.
- **Alle Ordnereinstellungen widerrufen** stellt jede von OpenWithPanel geänderte Datei wieder so her, wie sie war.
- **Ordner mit diesem Namen überspringen** ist bearbeitbar; standardmäßig enthält die Liste die Ordner, die die Ordnersuche in der Diagnose überspringt.

**Verlauf**

Listet die vor jedem Anwenden gesicherten Schnappschüsse auf, bis zu 20, die neuesten zuerst. Der letzte, **Anfangszustand (bevor OpenWithPanel etwas geändert hat)**, ist der Zustand, der beim ersten Öffnen von OpenWithPanel aufgezeichnet wurde. Jeder davon lässt sich mit **Wiederherstellen …** wiederherstellen, mit einer vorherigen Vorschau der Unterschiede.

**Was OpenWithPanel geschrieben hat**

Listet jede Stelle auf, die OpenWithPanel auf deinem Mac ändert oder beschreibt, jeweils mit **Im Finder zeigen**:

- **Dateizuordnungen:** wie viele Einträge (Dateitypen und Links) OpenWithPanel verwaltet;
- **LaunchServices-Einstellungseinträge:** die Einträge, die OpenWithPanel für Dateitypen geschrieben hat, einschließlich Dateien ohne Endung;
- **OpenWithPanel Helper:** in der OpenWithPanel-App;
- **Regeln und Schnappschüsse:** `~/Library/Application Support/net.zhaojian.openwithpanel/`;
- **„Öffnen mit“-Einstellungen einzelner Dateien:** nur vorhanden, wenn du Ordnerregeln verwendet hast.

OpenWithPanel läuft nicht im Hintergrund, hat kein Anmeldeobjekt, baut keine Netzwerkverbindungen auf und sammelt keine Daten.

### Deinstallieren

Klicke unten in **Was OpenWithPanel geschrieben hat** auf **OpenWithPanel deinstallieren …** und wähle, ob auch Regeln und Schnappschüsse gelöscht werden sollen. OpenWithPanel führt dann Folgendes aus:

1. Jeder Dateityp und Link, den es geändert hat, zeigt wieder auf seine ursprüngliche App;
2. jede von Ordnerregeln vorgenommene Einstellung einzelner Dateien wird widerrufen;
3. `~/Library/Application Support/net.zhaojian.openwithpanel/` wird je nach deiner Wahl gelöscht oder behalten;
4. OpenWithPanel legt sich selbst in den Papierkorb.

Lässt sich ein Dateityp oder Link nicht zurücksetzen – etwa weil du eine Bestätigung des Systems abgelehnt hast –, bricht die Deinstallation ab und es wird nichts entfernt.

Behältst du Regeln und Schnappschüsse, zeigt OpenWithPanel nach einer Neuinstallation ein Banner, über das du alle deine Einstellungen mit einem Klick zurückholst. Aufräum-Apps, die beim Verschieben einer App in den Papierkorb deren übrig gebliebene Dateien löschen, können dabei auch die Regeln und Schnappschüsse löschen, die du behalten wolltest; weise ein solches Programm an, OpenWithPanel auszulassen.

Ziehst du OpenWithPanel stattdessen selbst in den Papierkorb, verschwindet OpenWithPanel Helper mit, und macOS verwirft die Zuordnungen, die darauf zeigten; andere Typen behalten die Apps, die OpenWithPanel festgelegt hat. Eine Datei `UNINSTALL.txt` im Ordner Application Support erklärt, wie du sie in diesem Fall wiederherstellst.

## Entwicklermodus

Schalte ihn unter **Einstellungen › Allgemein** ein. Er fügt hinzu:

- den System-Typbezeichner (UTI) unter jedem Format und ein **Helfer**-Abzeichen bei Formaten, die über OpenWithPanel Helper laufen;
- die vollständige Entscheidungskette in der Diagnose: Typ, übergeordnete Typen, Text oder binär, die Entscheidung und wie jede App, die die Datei öffnen kann, sie in ihrer Info.plist deklariert (passende Endung oder passender Typ, Rolle und Rang);
- einen Tab **Regeln** im Hauptfenster;
- die Behandlung von **Dateien, die kein Text sind** und **Voreinstellungen** in den Einstellungen.

**Regeln** bestimmen, wohin OpenWithPanel Helper die empfangenen Dateien schickt. Eine Regel besteht aus:

- Bedingungen, von denen mindestens eine ausgefüllt sein muss: ein Dateinamensmuster (etwa `Dockerfile*`, ohne Beachtung der Groß-/Kleinschreibung), ein enthaltender Ordner (etwa `~/Projects`) und ob der Inhalt Text oder binär ist;
- den Typen, für die sie gilt, standardmäßig `public.data` (Dateien ohne Endung); weitere hinzugefügte Typen laufen ebenfalls über OpenWithPanel Helper;
- dem Ziel der Datei: eine App, **Im Finder zeigen** oder die **Ursprüngliche App**.

Regeln werden von oben nach unten geprüft, und die erste Übereinstimmung gewinnt. Ziehe sie, um die Reihenfolge zu ändern; der Schalter links deaktiviert eine Regel vorübergehend. Gruppen, die von Regeln betroffen sind, zeigen im Standardmodus **Durch Regeln gesteuert**.

**Dateien, die kein Text sind** legt fest, was OpenWithPanel Helper mit Binärdateien macht: **Im Finder zeigen** (Standard), **Mit derselben App öffnen** oder **Mit der ursprünglichen App öffnen**.

**Voreinstellungen** exportieren deine Gruppeneinstellungen, Einstellungen pro Format, eigenen Endungen und Regeln in eine JSON-Datei, die du auf einem anderen Mac importieren kannst; importierte Einstellungen wirken, nachdem du auf **Anwenden** geklickt hast. Ordnerregeln und Aufzeichnungen der ursprünglichen Apps sind für jeden Mac spezifisch, daher werden sie weder exportiert noch beim Import überschrieben.

## Funktionsweise

OpenWithPanel bringt in seinem App-Bundle eine winzige Hilfs-App mit, **OpenWithPanel Helper**. Wenn du einen Editor für Dateien ohne Endung wählst, richtet OpenWithPanel `public.data` auf die Hilfs-App. Öffnest du eine solche Datei, prüft die Hilfs-App deine Regeln und den Inhalt der Datei, gibt Textdateien an deine gewählte App weiter, zeigt Binärdateien im Finder und beendet sich. Sie läuft nicht dauerhaft: macOS startet sie nur, wenn es eine Datei oder einen Link zuzustellen hat, und sie beendet sich nach weniger als einer Sekunde Leerlauf. Sie hat kein Fenster und erscheint nicht im Dock. Auf **Nicht öffnen** gesetzte Links werden ebenfalls an die Hilfs-App geschickt, die sie einfach ignoriert.

Eine Datei gilt als binär, wenn ihre ersten 8 KB ein Nullbyte enthalten oder kein gültiges UTF-8 sind.

Dateitypen, die deine gewählte App bereits unterstützt, etwa `.md` oder `.py`, werden dieser App direkt zugewiesen, ohne die Hilfs-App.

macOS bietet keine öffentliche API, um eine Standard-App für `public.data` festzulegen, und seit macOS 26.4 verlangt die öffentliche API für jeden einzelnen geänderten Dateityp eine Bestätigung. Deshalb schreibt OpenWithPanel alle Dateitypänderungen auf einmal in die LaunchServices-Einstellungen und startet den Dienst `lsd` einmal neu, damit sie wirken. Dieser Mechanismus ist von Apple nicht dokumentiert und könnte nach einem Systemupdate nicht mehr funktionieren. Wirkt eine Änderung nicht, weicht OpenWithPanel auf die öffentliche API aus, die dich um Bestätigung bittet; für Dateien ohne Endung bietet es stattdessen Ordnerregeln an.

## Häufige Fragen

**Wie ändere ich auf dem Mac die Standard-App für Dateien ohne Endung?**
Öffne OpenWithPanel, wähle eine App für **Dateien ohne Endung** und klicke auf **Anwenden**. Dateien wie `.env` und `Dockerfile` öffnen sich dann in dieser App.

**Warum funktioniert „Alle ändern“ im Finder nicht für `.env`-Dateien?**
macOS behandelt sie als generische Daten (`public.data`) und blockiert über seine öffentlichen APIs die Änderung der Standard-App für diesen Typ. OpenWithPanel umgeht das mit seiner Hilfs-App.

**Wie mache ich VS Code, Zed oder Sublime Text zum Standard-Editor für Code-Dateien?**
Wähle den Editor für die Gruppe **Code** oder für einzelne Formate und klicke auf **Anwenden**. Endungen ohne offiziellen macOS-Typ, etwa `.go` und `.rs`, werden ebenfalls abgedeckt.

**Kann ich alles rückgängig machen?**
Ja. OpenWithPanel zeichnet beim ersten Start die ursprünglichen Zuordnungen auf und überschreibt diese Aufzeichnung nie. **Anfangszustand wiederherstellen** richtet jeden geänderten Typ wieder auf seine ursprüngliche App.

**Sammelt OpenWithPanel Daten oder läuft es im Hintergrund?**
Nein. Es baut keine Netzwerkverbindungen auf, sammelt keine Daten, installiert keine Hintergrundagenten und läuft nach dem Beenden nicht weiter. **Einstellungen › Was OpenWithPanel geschrieben hat** listet jede Stelle auf, an die es schreibt.

**Warum läuft OpenWithPanel nicht in einer Sandbox?**
macOS erlaubt Apps in einer Sandbox nicht, Standard-Apps zu ändern. OpenWithPanel verwendet stattdessen die gehärtete Laufzeitumgebung (Hardened Runtime).

## Bekannte Einschränkungen

- Unter macOS wird `.ts` als Videoformat (MPEG-2-Transportstrom) erkannt, und eine Änderung würde echte Videodateien betreffen, daher enthält die Gruppe Code von TypeScript nur `.tsx`. Ebenso sind `.r`, `.exs` und `.fs` für macOS Rez-Ressourcen, Logic-Sampler-Dateien und Shader und gehören nicht zur Gruppe Code.
- Dateityp-Einstellungen beruhen auf einem nicht dokumentierten Systemmechanismus, der nach einem Systemupdate nicht mehr funktionieren könnte. In diesem Fall weichen gewöhnliche Dateitypen automatisch auf die System-API aus (eine Bestätigung pro Typ), und für Dateien ohne Endung kannst du stattdessen Ordnerregeln verwenden.
- macOS erlaubt einer App nur, das Protokoll ihres eigenen Prozesses zu lesen, daher enthält der Diagnosebericht nicht das Protokoll von OpenWithPanel Helper. Suche bei Bedarf in der App „Konsole“ nach `net.zhaojian.openwithpanel`.
- Die Übersetzungen der Oberfläche wurden noch nicht von Muttersprachlern geprüft.

## Aus dem Quellcode bauen

Erfordert Xcode 27.

```sh
swift test --package-path OpenWithPanelKit
xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel build
```

Ein DMG bauen:

```sh
scripts/package.sh
```

Die Ausgabe landet in `.build/dist/`, zusammen mit einem Homebrew-Cask, der aus `packaging/openwithpanel.rb` mit eingesetzter Version und Prüfsumme erzeugt wird. Ohne Umgebungsvariablen wird die App ad hoc signiert und nicht notarisiert; das DMG enthält dann `First Launch.txt`. Setze `DEVELOPER_ID` (der Name eines Developer-ID-Application-Zertifikats), um damit zu signieren, und zusätzlich `NOTARY_PROFILE` (ein mit `xcrun notarytool store-credentials` gesichertes Anmeldeprofil), um zu notarisieren und das Ticket anzuheften.

Releases werden vom GitHub-Actions-Workflow in `.github/workflows/release.yml` gebaut. Wie er signiert und wie ein Release veröffentlicht wird, steht in [docs/release.md](../release.md).

## Projektstruktur

- `OpenWithPanelKit/`: ein lokales Swift-Paket. `OpenWithPanelCore` enthält die gesamte Logik; `OpenWithPanelPlatform` kapselt die System-APIs.
- `Apps/OpenWithPanel/`: die Haupt-App (SwiftUI).
- `Apps/Helper/`: die in das Bundle der Haupt-App eingebettete Hilfs-App.
- `scripts/`, `packaging/`: das Paketierungsskript und die Vorlage für den Homebrew-Cask.

## Lizenz

[MIT](../../LICENSE) © 2026 zhaoJian
