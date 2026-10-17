<p align="center">
  <img src="../assets/icon.png" width="128" alt="Icône de l’app OpenWithPanel">
</p>

<h1 align="center">OpenWithPanel</h1>

<p align="center">
  <strong>Choisissez quelle app ouvre quoi sur votre Mac — y compris les fichiers pour lesquels macOS ne vous laisse pas le choix.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26 ou ultérieur">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="Licence MIT">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <b>Français</b> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.id.md">Bahasa Indonesia</a> ·
  <a href="README.th.md">ไทย</a> ·
  <a href="README.vi.md">Tiếng Việt</a> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

OpenWithPanel est une app macOS gratuite et open source pour gérer les **apps par défaut** : choisissez dans une seule fenêtre quelle app ouvre chaque type de fichier, chaque extension et chaque lien. Elle sait aussi faire ce que le Finder ne sait pas faire : définir votre éditeur comme app par défaut pour les **fichiers sans extension**, comme `.env`, `.gitignore`, `Dockerfile` et `.npmrc`.

<p align="center">
  <img src="../assets/screenshot.png" width="720" alt="Fenêtre principale d’OpenWithPanel">
</p>

## Sommaire

- [Pourquoi OpenWithPanel](#pourquoi-openwithpanel)
- [Fonctionnalités](#fonctionnalités)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Diagnostic](#diagnostic)
- [Réglages](#réglages)
- [Mode développeur](#mode-développeur)
- [Fonctionnement](#fonctionnement)
- [FAQ](#faq)
- [Limitations connues](#limitations-connues)
- [Compiler depuis les sources](#compiler-depuis-les-sources)

## Pourquoi OpenWithPanel

macOS classe la plupart des fichiers sans extension dans le type `public.data` et refuse qu’une app quelconque devienne l’app par défaut pour ce type. **Lire les informations › Ouvrir avec › Tout modifier…** dans le Finder n’a aucun effet sur ces fichiers, et les outils en ligne de commande échouent avec l’erreur `-50`. **Toujours ouvrir avec** dans le Finder ne s’applique qu’au seul fichier sélectionné.

Résultat : `.env`, `.gitignore`, `Dockerfile` et les fichiers similaires continuent de s’ouvrir dans TextEdit — ou ne s’ouvrent pas du tout — quoi que vous régliez. OpenWithPanel corrige cela grâce à une petite app auxiliaire, OpenWithPanel Helper, décrite dans [Fonctionnement](#fonctionnement).

Elle comble aussi d’autres lacunes de macOS : lorsqu’une app fraîchement installée (typiquement Xcode) s’approprie vos associations de fichiers, macOS ne vous prévient pas, et aucun bouton ne permet de revenir à la situation précédente.

## Fonctionnalités

- **Apps par défaut par groupe.** Les types de fichiers sont regroupés par usage — Texte, Markdown, Code, Configuration et données, Fichiers sans extension, PDF, Documents, Images, Vidéo, Audio, Archives — et chaque groupe a un seul menu d’app.
- **Tout appliquer d’un coup.** Réglez tout un groupe de formats à la fois sans confirmer chacun ; les modifications prennent effet en quelques secondes.
- **Exceptions par format.** Développez un groupe pour attribuer à un seul format, comme `.md` ou `.py`, sa propre app. Changer ensuite l’app du groupe ne touche pas aux exceptions.
- **Fichiers sans extension.** Ouvrez `.env`, `Dockerfile`, `.gitignore` et les autres fichiers sans extension dans l’éditeur de votre choix, même si cet éditeur ne déclare pas les prendre en charge.
- **Extensions personnalisées.** Ajoutez n’importe quelle extension absente de la liste, y compris celles que macOS ne connaît que comme types temporaires, comme `.go`, `.rs`, `.kt`, `.dart` et `.lua`.
- **Apps par défaut pour les liens.** Choisissez l’app pour les liens web (`http`, `https`), les e-mails (`mailto`), les abonnements de calendrier (`webcal`), les appels, les SMS, FaceTime, SSH, FTP et le partage d’écran — ou choisissez **Ne pas ouvrir** pour qu’un clic sur ce type de lien ne fasse rien.
- **Recherche par extension.** Tapez `py` ou `env` pour aller directement à la bonne ligne.
- **Diagnostic de n’importe quel fichier.** Déposez un fichier pour voir pourquoi il s’ouvre dans telle app, puis choisissez-en une autre sur place. Déposez un dossier pour trouver les fichiers qui ont leur propre réglage **Ouvrir avec** et les effacer.
- **Alertes d’appropriation.** Si une autre app (Xcode, un navigateur) s’approprie une association que vous avez définie, OpenWithPanel affiche une bannière qui la rétablit en un clic.
- **Annuler et restaurer.** Un instantané est enregistré avant chaque modification. Annulez avec `⌘Z`, restaurez n’importe quel instantané antérieur, ou ramenez tout à l’état d’avant toute modification par OpenWithPanel, avec un aperçu de chaque changement au préalable.
- **Règles de dossier.** Une solution de repli facultative qui fait ouvrir dans votre éditeur les fichiers sans extension de dossiers choisis, comme `~/Projects`, en n’utilisant que des API officielles de macOS.
- **Mode développeur.** Des règles qui aiguillent les fichiers selon un motif de nom (par exemple `Dockerfile*`), un dossier ou un contenu texte ou binaire ; la chaîne de décision complète dans le diagnostic, y compris les types déclarés par chaque app et leur rang ; l’import et l’export de préréglages.
- **Désinstallation propre.** Le désinstalleur intégré rend chaque association à son app d’origine avant de placer OpenWithPanel dans la Corbeille.
- **15 langues.** Anglais, chinois simplifié, chinois traditionnel, japonais, coréen, allemand, français, espagnol, portugais, indonésien, thaï, vietnamien, arabe, russe et hindi, à changer depuis l’app.

## Installation

Nécessite macOS 26 Tahoe ou ultérieur.

1. Ouvrez la [page Releases](https://github.com/zhaojiannet/openwithpanel/releases) et, dans la section **Assets** de la dernière version, téléchargez `OpenWithPanel-<version>.dmg`.
2. Double-cliquez sur le DMG téléchargé pour l’ouvrir.
3. Faites glisser **OpenWithPanel** sur le dossier **Applications** affiché dans la même fenêtre.
4. Éjectez le DMG, puis ouvrez OpenWithPanel depuis le dossier Applications. La première fois, macOS vous demande de l’autoriser ; voir [Premier lancement](#premier-lancement).

Il n’y a pas d’installeur et aucun mot de passe administrateur n’est nécessaire.

**Mise à jour :** téléchargez le nouveau DMG et faites de nouveau glisser OpenWithPanel dans Applications en remplaçant l’ancienne copie. Vos réglages, règles et instantanés sont conservés. Pour savoir si une version plus récente est sortie, choisissez **OpenWithPanel › Rechercher les mises à jour…**.

**Désinstallation :** voir [Désinstallation](#désinstallation).

### Premier lancement

OpenWithPanel n’est pas encore notarié par Apple, donc macOS le bloque la première fois que vous l’ouvrez. Autorisez-le une fois :

1. Double-cliquez sur OpenWithPanel. Lorsque macOS indique qu’il n’a pas pu vérifier OpenWithPanel, cliquez sur **Terminé**. Ne cliquez pas sur le bouton bleu **Placer dans la corbeille**.

   <img src="../assets/first-launch-1.png" width="372" alt="Le premier avertissement : cliquez sur Terminé">

2. Ouvrez **Réglages Système › Confidentialité et sécurité**, faites défiler jusqu’à **Sécurité** et cliquez sur **Ouvrir quand même** à côté d’OpenWithPanel. Le bouton reste disponible environ une heure après l’étape 1.

   <img src="../assets/first-launch-2.png" width="560" alt="Confidentialité et sécurité : cliquez sur Ouvrir quand même">

3. Saisissez votre mot de passe de session ou utilisez Touch ID. Dans la zone de dialogue qui suit, cliquez de nouveau sur **Ouvrir quand même**.

   <img src="../assets/first-launch-3.png" width="372" alt="La confirmation : cliquez sur Ouvrir quand même">

Ensuite, OpenWithPanel s’ouvre normalement. Son app auxiliaire intégrée est autorisée en même temps, donc les fichiers sans extension s’ouvrent sans autre demande. Le DMG contient aussi ces étapes dans `First Launch.txt`. Les captures d’écran montrent l’interface en anglais ; dans macOS en français, les boutons portent les noms indiqués ci-dessus.

## Utilisation

### Groupes de types de fichiers

L’onglet **Types de fichiers** présente chaque groupe sous forme de carte :

| Groupe | Contient |
|---|---|
| Texte | `.txt` `.log` |
| Markdown | `.md` `.markdown` |
| Code | Les langages de programmation populaires, voir ci-dessous |
| Configuration et données | `.json` `.yaml` `.toml` `.xml` `.ini` `.plist` `.csv` |
| Fichiers sans extension | `.env` `Dockerfile` `.gitignore` et similaires |
| PDF | `.pdf` |
| Documents | `.rtf` `.docx` `.doc` `.pages` `.odt` |
| Images, Vidéo, Audio, Archives | Leurs formats courants |
| Personnalisé | Les extensions que vous avez ajoutées et qui n’entrent dans aucun autre groupe ; affiché seulement s’il en contient |

Le groupe Code couvre les langages utilisés par au moins 5 % des répondants du Stack Overflow 2025 Developer Survey : JavaScript, TypeScript (`.tsx`), Python, Java, C, C++, C#, PHP, Ruby, Swift, Go, Rust, Kotlin, Dart, Lua, Shell (sh, bash, zsh), PowerShell, SQL et l’assembleur, plus CSS, Makefile et JSX. Ajoutez-en d’autres vous-même, voir [Ajouter une extension](#ajouter-une-extension).

### Choisir une app pour tout un groupe

Choisissez une app dans le menu à droite d’une carte. Tous les formats du groupe s’ouvrent alors avec elle. Le menu liste les apps que macOS juge capables d’ouvrir le groupe ; choisissez **Autre…** pour sélectionner n’importe quelle app du dossier Applications.

### Attribuer à un format sa propre app

Cliquez sur la ligne d’un groupe, ou sur la flèche à sa gauche, pour le développer. Chaque format a sa propre ligne, avec l’icône système de ce fichier et son extension comme titre. Choisissez une autre app dans le menu d’une ligne et ce format l’utilisera désormais ; la ligne est marquée **Réglé à part**, et la ligne du groupe indique combien de formats sont réglés à part.

- Un format sans app propre affiche **Comme le groupe** en gris dans son menu.
- Pour qu’un format suive de nouveau le groupe, choisissez **Suivre le groupe** dans son menu.
- Changer ensuite l’app du groupe ne touche pas aux formats qui ont leur propre app.

Les groupes de plus de 8 formats n’affichent que les formats réglés à part ou ajoutés par vous ; **Afficher les N formats** en bas liste les autres. Quand le groupe Code affiche tout, il est divisé en sections comme Web, Systèmes et apps, JVM et Scripts et shell.

### Recherche

Tapez une extension, comme `py` ou `env`, dans le champ de recherche en haut à droite. Le groupe correspondant se développe avec tous ses formats et la ligne correspondante est mise en évidence. Si l’extension n’appartient à aucun groupe, le résultat de recherche propose **Ajouter…**.

### Ajouter une extension

Utilisez **Ajouter une extension…** en bas de la liste, ou **Ajouter…** dans un résultat de recherche.

1. Tapez l’extension, comme `nim`. La feuille indique comment macOS la reconnaît.
2. OpenWithPanel propose un groupe en conséquence : le code source va dans Code, les images dans Images, tout ce qui n’est pas reconnu dans Personnalisé. Vous pouvez choisir un autre groupe.
3. Cliquez sur **Ajouter**. Le format apparaît dans ce groupe, marqué **Personnalisé**, et suit l’app du groupe ; vous pouvez aussi lui attribuer sa propre app.

Une extension déjà présente dans un groupe n’est pas ajoutée deux fois ; la feuille vous indique dans quel groupe elle se trouve. Les formats que vous avez ajoutés ont un bouton de suppression sur leur ligne.

### Appliquer

Toutes les modifications ci-dessus sont d’abord mises en attente. Une barre en bas de la fenêtre indique combien de modifications sont en attente ; **Appliquer** les rend effectives et **Abandonner** les annule.

- Les modifications de types de fichiers ne demandent pas de confirmation. Quel que soit le nombre de formats modifiés, OpenWithPanel les écrit d’un coup dans les préférences système et fait recharger le système une seule fois ; tout prend effet en quelques secondes.
- Les modifications des liens et des fichiers web (`.html`) demandent toujours une confirmation dans une zone de dialogue du système, par exemple quand vous changez de navigateur web. Changer le navigateur en silence, c’est ce que font les pirates de navigateur, donc macOS doit vous le demander directement.
- Si l’écriture échoue (par exemple pour une question d’autorisations), ou si un format ne prend pas effet, OpenWithPanel le règle de nouveau via l’API du système, un par un ; macOS demande alors s’il faut utiliser la nouvelle app ou garder l’ancienne. Si vous gardez l’ancienne, OpenWithPanel enregistre ce format comme réglé à part sur cette app et n’y touche plus.
- Après l’application, OpenWithPanel relit l’état réel du système, donc la liste montre toujours ce qui a réellement pris effet.

### Annuler et restaurer

- **Édition › Annuler** (`⌘Z`) annule la dernière application. Vous pouvez annuler plusieurs fois de suite.
- Le bouton à flèche circulaire de la barre d’outils est **Restaurer l’état initial** : chaque type de fichier et chaque lien modifié par OpenWithPanel est redirigé vers l’app qu’il utilisait quand vous avez ouvert OpenWithPanel pour la première fois. Chaque changement est listé avant que quoi que ce soit ne se passe.

macOS ne permet pas de supprimer une association de fichiers, seulement de la rediriger vers une autre app ; restaurer signifie donc rediriger chaque type vers l’app enregistrée dans l’instantané. Un type pour lequel macOS choisissait lui-même l’app reçoit ensuite un réglage explicite pour cette même app ; il s’ouvre exactement comme avant.

### Liens

Sous les types de fichiers, une carte définit l’app pour chaque type de lien :

| Ligne | Schémas d’URL |
|---|---|
| Navigateur web | `http:` `https:` |
| E-mail | `mailto:` |
| Abonnements de calendrier | `webcal:` |
| Appels, SMS, FaceTime | `tel:` `sms:` `facetime:` |
| SSH, FTP, Partage d’écran | `ssh:` `ftp:` `vnc:` |

Tous les types de liens qu’une app de votre Mac sait traiter sont listés. En bas de chaque menu se trouve **Ne pas ouvrir** : choisissez-le et un clic sur ce type de lien, dans n’importe quelle app, ne fait rien — par exemple pour qu’un numéro de téléphone sur une page web ne lance pas d’appel. Pour revenir en arrière, choisissez de nouveau une app dans le menu. Choisir **Ne pas ouvrir** pour le navigateur web demande d’abord une confirmation, puisque plus aucun lien web ne s’ouvrirait. Vous pouvez aussi rechercher un schéma (comme `mailto`) ou un nom de ligne.

Les liens sont mis en attente, appliqués, enregistrés dans les instantanés, annulés et restaurés exactement comme les types de fichiers. Changer de navigateur web demande une confirmation dans une zone de dialogue du système ; sous macOS 27, changer `http` change aussi `https`, et OpenWithPanel ne règle alors pas `https` une seconde fois, donc vous ne confirmez qu’une fois.

## Diagnostic

Passez à l’onglet **Diagnostic** en haut de la fenêtre.

**Pourquoi un fichier s’ouvre-t-il dans cette app ?** Déposez un fichier dans le cadre en pointillés. Le résultat indique quelle app l’ouvre et pourquoi :

- le fichier a son propre réglage **Ouvrir avec**, défini dans **Lire les informations** du Finder ;
- OpenWithPanel Helper l’a reçu et une règle ou un réglage de groupe l’a envoyé à une app ;
- vous avez choisi cette app pour ce type de fichier ;
- rien n’était réglé, donc macOS a choisi l’app.

Sous le résultat, **Utiliser plutôt** passe directement à une autre app. Si le fichier a son propre réglage **Ouvrir avec**, c’est **Supprimer le réglage propre à ce fichier** qui apparaît à la place.

**Trouver les fichiers qui ont leur propre réglage « Ouvrir avec ».** Déposez un dossier dans le cadre en pointillés. OpenWithPanel liste chaque fichier de ce dossier qui a son propre réglage **Ouvrir avec**, avec l’app vers laquelle il pointe. Sélectionnez des fichiers et cliquez sur **Supprimer leurs propres réglages** ; ils suivent alors le réglage de leur type. L’analyse ignore les dossiers `.git`, `node_modules`, `.build`, `DerivedData`, `Pods`, `vendor`, `.venv` et `__pycache__`.

**Exporter un rapport de diagnostic.** **Exporter le rapport de diagnostic…** en bas de l’onglet enregistre un rapport texte contenant votre configuration, l’app qui ouvre actuellement chaque type géré par OpenWithPanel, le journal de cette session et le fichier que vous venez de diagnostiquer. Envoyez-le au développeur quand vous signalez un problème.

## Réglages

Ouvrez **OpenWithPanel › Réglages…** ou appuyez sur `⌘,`.

**Général**

- **Langue :** choisissez **Comme le système** ou l’une des 15 langues, puis cliquez sur **Relancer maintenant**. S’il y a des modifications non appliquées, appliquez-les ou abandonnez-les d’abord.
- **Mode développeur :** affiche plus de détails, voir [Mode développeur](#mode-développeur). Il ne change que l’affichage, jamais vos réglages.

**Règles de dossier**

Une solution de repli pour le cas où la méthode utilisée pour les fichiers sans extension cesse de fonctionner. Ajoutez un dossier et choisissez une app : OpenWithPanel donne à chaque fichier texte sans extension de ce dossier son propre réglage **Ouvrir avec** pour cette app.

- Les fichiers binaires, et les fichiers que vous avez réglés vous-même, ne sont pas touchés.
- Les nouveaux fichiers sont traités à chaque ouverture d’OpenWithPanel, ou immédiatement avec **Appliquer maintenant**.
- **Annuler tous les réglages de dossier** remet chaque fichier modifié par OpenWithPanel dans son état d’origine.
- **Ignorer les dossiers nommés** est modifiable ; par défaut, la liste reprend les dossiers que l’analyse de dossier du Diagnostic ignore.

**Historique**

Liste l’instantané enregistré avant chaque application, jusqu’à 20, du plus récent au plus ancien. Le dernier, **Initial (avant toute modification par OpenWithPanel)**, est l’état enregistré la première fois que vous avez ouvert OpenWithPanel. Chacun peut être restauré avec **Restaurer…**, avec un aperçu des différences au préalable.

**Ce qu’OpenWithPanel a écrit**

Liste chaque endroit qu’OpenWithPanel modifie ou dans lequel il écrit sur votre Mac, chacun avec **Afficher dans le Finder** :

- **Associations de fichiers :** combien d’éléments (types de fichiers et liens) OpenWithPanel gère ;
- **Entrées de préférences LaunchServices :** les entrées écrites par OpenWithPanel pour les types de fichiers, y compris les fichiers sans extension ;
- **OpenWithPanel Helper :** à l’intérieur de l’app OpenWithPanel ;
- **Règles et instantanés :** `~/Library/Application Support/net.zhaojian.openwithpanel/` ;
- **Réglages « Ouvrir avec » par fichier :** présents seulement si vous avez utilisé les règles de dossier.

OpenWithPanel ne s’exécute pas en arrière-plan, n’a pas d’élément d’ouverture et ne collecte aucune donnée. Il ne se connecte à Internet que lorsque vous choisissez **Rechercher les mises à jour…**, pour lire le numéro de la dernière version sur GitHub.

### Désinstallation

En bas de **Ce qu’OpenWithPanel a écrit**, cliquez sur **Désinstaller OpenWithPanel…** et choisissez si les règles et instantanés doivent aussi être supprimés. OpenWithPanel :

1. redirige chaque type de fichier et chaque lien qu’il a modifié vers son app d’origine ;
2. annule chaque réglage par fichier créé par les règles de dossier ;
3. supprime ou conserve `~/Library/Application Support/net.zhaojian.openwithpanel/` selon votre choix ;
4. se place lui-même dans la Corbeille.

Si un type de fichier ou un lien ne peut pas être redirigé vers son app d’origine — par exemple parce que vous avez refusé une confirmation du système —, la désinstallation s’arrête et rien n’est supprimé.

Si vous conservez les règles et instantanés, la réinstallation d’OpenWithPanel affiche une bannière qui rétablit tous vos réglages en un clic. Les outils de nettoyage qui suppriment les fichiers restants d’une app quand on la place dans la Corbeille peuvent aussi supprimer les règles et instantanés que vous avez choisi de garder ; demandez à un tel outil d’ignorer OpenWithPanel.

Si vous faites plutôt glisser OpenWithPanel dans la Corbeille vous-même, OpenWithPanel Helper part avec lui et macOS abandonne les associations qui pointaient vers lui ; les autres types gardent les apps réglées par OpenWithPanel. Un fichier `UNINSTALL.txt` dans le dossier Application Support explique comment les restaurer dans ce cas.

## Mode développeur

Activez-le dans **Réglages › Général**. Il ajoute :

- l’identifiant de type système (UTI) sous chaque format, et un badge **Assistant** sur les formats aiguillés par OpenWithPanel Helper ;
- la chaîne de décision complète dans le diagnostic : type, types parents, texte ou binaire, la décision, et la façon dont chaque app capable d’ouvrir le fichier le déclare dans son Info.plist (extension ou type correspondant, rôle et rang) ;
- un onglet **Règles** dans la fenêtre principale ;
- le traitement des **Fichiers qui ne sont pas du texte** et les **Préréglages** dans les réglages.

Les **Règles** décident où OpenWithPanel Helper envoie les fichiers qu’il reçoit. Une règle comporte :

- des conditions, dont au moins une doit être remplie : un motif de nom de fichier (comme `Dockerfile*`, sans distinction de casse), un dossier contenant (comme `~/Projects`), et le fait que le contenu soit du texte ou du binaire ;
- les types auxquels elle s’applique, `public.data` (fichiers sans extension) par défaut ; les autres types que vous ajoutez sont eux aussi aiguillés par OpenWithPanel Helper ;
- la destination du fichier : une app, **Afficher dans le Finder**, ou l’**App d’origine**.

Les règles sont évaluées de haut en bas et la première qui correspond l’emporte. Faites-les glisser pour les réordonner ; l’interrupteur à gauche désactive temporairement une règle. Les groupes concernés par des règles affichent **Contrôlé par des règles** en mode standard.

**Fichiers qui ne sont pas du texte** définit ce qu’OpenWithPanel Helper fait des fichiers binaires : **Afficher dans le Finder** (par défaut), **Ouvrir avec la même app** ou **Ouvrir avec l’app d’origine**.

**Préréglages** exporte vos réglages de groupe, vos réglages par format, vos extensions personnalisées et vos règles dans un fichier JSON que vous pouvez importer sur un autre Mac ; les réglages importés prennent effet une fois que vous avez cliqué sur **Appliquer**. Les règles de dossier et les enregistrements d’app d’origine sont propres à chaque Mac : ils ne sont ni exportés ni écrasés à l’import.

## Fonctionnement

OpenWithPanel embarque une minuscule app auxiliaire, **OpenWithPanel Helper**, dans son paquet d’app. Quand vous choisissez un éditeur pour les fichiers sans extension, OpenWithPanel fait pointer `public.data` vers l’app auxiliaire. Quand vous ouvrez un tel fichier, l’app auxiliaire consulte vos règles et le contenu du fichier, transmet les fichiers texte à l’app choisie, affiche les fichiers binaires dans le Finder, puis quitte. Elle ne reste pas en cours d’exécution : macOS ne la lance que lorsqu’elle a un fichier ou un lien à transmettre, et elle se termine après moins d’une seconde d’inactivité. Elle n’a pas de fenêtre et n’apparaît pas dans le Dock. Les liens réglés sur **Ne pas ouvrir** sont eux aussi envoyés à l’app auxiliaire, qui les ignore simplement.

Un fichier est considéré comme binaire si ses 8 premiers Ko contiennent un octet nul ou ne sont pas de l’UTF-8 valide.

Les types de fichiers que l’app choisie prend déjà en charge, comme `.md` ou `.py`, lui sont attribués directement, sans passer par l’app auxiliaire.

macOS n’offre pas d’API publique pour définir une app par défaut pour `public.data`, et depuis macOS 26.4 son API publique demande une confirmation pour chaque type de fichier modifié. OpenWithPanel écrit donc toutes les modifications de types de fichiers d’un coup dans les préférences LaunchServices et redémarre une fois le service `lsd` pour qu’elles prennent effet. Ce mécanisme n’est pas documenté par Apple et peut cesser de fonctionner après une mise à jour du système. Si une modification ne prend pas effet, OpenWithPanel se rabat sur l’API publique, qui vous demande de confirmer ; pour les fichiers sans extension, il propose plutôt les règles de dossier.

## FAQ

**Comment changer l’app par défaut des fichiers sans extension sur Mac ?**
Ouvrez OpenWithPanel, choisissez une app pour **Fichiers sans extension** et appuyez sur **Appliquer**. Les fichiers comme `.env` et `Dockerfile` s’ouvrent alors dans cette app.

**Pourquoi « Tout modifier » du Finder ne fonctionne-t-il pas pour les fichiers `.env` ?**
macOS les traite comme des données génériques (`public.data`) et bloque, via ses API publiques, le changement d’app par défaut pour ce type. OpenWithPanel contourne cela avec son app auxiliaire.

**Comment faire de VS Code, Zed ou Sublime Text l’éditeur par défaut des fichiers de code ?**
Choisissez l’éditeur pour le groupe **Code**, ou pour des formats individuels, et appuyez sur **Appliquer**. Les extensions sans type macOS officiel, comme `.go` et `.rs`, sont aussi couvertes.

**Puis-je tout annuler ?**
Oui. OpenWithPanel enregistre les associations d’origine lors de sa première exécution et n’écrase jamais cet enregistrement. **Restaurer l’état initial** redirige chaque type modifié vers son app d’origine.

**OpenWithPanel collecte-t-il des données ou s’exécute-t-il en arrière-plan ?**
Non. Il ne collecte aucune donnée, ne se connecte à Internet que lorsque vous choisissez **Rechercher les mises à jour…**, n’installe aucun agent en arrière-plan et ne reste pas en cours d’exécution après que vous l’avez quitté. **Réglages › Ce qu’OpenWithPanel a écrit** liste chaque endroit où il écrit.

**Pourquoi OpenWithPanel n’est-il pas en sandbox ?**
macOS n’autorise pas les apps en sandbox à changer les apps par défaut. OpenWithPanel utilise à la place le hardened runtime.

## Limitations connues

- Sous macOS, `.ts` est reconnu comme un format vidéo (flux de transport MPEG-2) et le modifier affecterait de vrais fichiers vidéo ; le groupe Code ne couvre donc que le `.tsx` de TypeScript. De même, pour macOS, `.r`, `.exs` et `.fs` sont des ressources Rez, des fichiers d’échantillonneur Logic et des shaders, et ils ne font pas partie du groupe Code.
- Les réglages de types de fichiers reposent sur un mécanisme système non documenté qui peut cesser de fonctionner après une mise à jour du système. Le cas échéant, les types de fichiers ordinaires se rabattent automatiquement sur l’API du système (une confirmation par type), et les fichiers sans extension peuvent utiliser les règles de dossier à la place.
- macOS ne permet à une app de lire que le journal de son propre processus ; le rapport de diagnostic n’inclut donc pas le journal d’OpenWithPanel Helper. Recherchez `net.zhaojian.openwithpanel` dans l’app Console si vous en avez besoin.
- Les traductions de l’interface n’ont pas encore été relues par des locuteurs natifs.

## Compiler depuis les sources

Nécessite Xcode 27.

```sh
swift test --package-path OpenWithPanelKit
xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel build
```

Pour créer un DMG :

```sh
scripts/package.sh
```

Le résultat est placé dans `.build/dist/`, avec un cask Homebrew généré à partir de `packaging/openwithpanel.rb` dont la version et la somme de contrôle sont renseignées. Sans variables d’environnement, l’app est signée ad hoc et n’est pas notariée ; le DMG inclut alors `First Launch.txt`. Définissez `DEVELOPER_ID` (le nom d’un certificat Developer ID Application) pour signer avec ce certificat, et définissez aussi `NOTARY_PROFILE` (un profil d’identifiants enregistré avec `xcrun notarytool store-credentials`) pour notarier et agrafer le ticket (staple).

Les versions sont compilées par le workflow GitHub Actions de `.github/workflows/release.yml`. La façon dont il signe, et comment publier une version, est décrite dans [docs/release.md](../release.md).

## Structure du projet

- `OpenWithPanelKit/` : un package Swift local. `OpenWithPanelCore` contient toute la logique ; `OpenWithPanelPlatform` encapsule les API du système.
- `Apps/OpenWithPanel/` : l’app principale (SwiftUI).
- `Apps/Helper/` : l’app auxiliaire intégrée au paquet de l’app principale.
- `scripts/`, `packaging/` : le script d’empaquetage et le modèle de cask Homebrew.

## Licence

[MIT](../../LICENSE) © 2026 zhaoJian
