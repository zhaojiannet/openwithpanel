import Foundation

public struct AppSupportLayout: Sendable {
  public let root: URL

  public init(root: URL) {
    self.root = root
  }

  public static func standard() -> AppSupportLayout {
    let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    return AppSupportLayout(root: base.appendingPathComponent("net.zhaojian.openwithpanel"))
  }

  public var configuration: URL { root.appendingPathComponent("config.json") }
  public var snapshots: URL { root.appendingPathComponent("snapshots") }
  public var folderLedger: URL { root.appendingPathComponent("folder-ledger.json") }
  public var uninstallNote: URL { root.appendingPathComponent("UNINSTALL.txt") }
  // 卸载时选了保留数据才会有：重装后据此说明关联是被卸载恢复的，并等用户确认再重新应用
  public var uninstalledMarker: URL { root.appendingPathComponent("uninstalled") }

  public func prepare() throws {
    try FileManager.default.createDirectory(at: snapshots, withIntermediateDirectories: true)
    if !FileManager.default.fileExists(atPath: uninstallNote.path) {
      try Self.uninstallText.write(to: uninstallNote, atomically: true, encoding: .utf8)
    }
  }

  static let uninstallText = """
    OpenWithPanel
    =============

    If you deleted OpenWithPanel.app by dragging it to the Trash, its helper (OpenWithPanel Helper) is gone too,
    and macOS drops the file associations that pointed to it.
    To put back the apps that opened your files before OpenWithPanel, reinstall OpenWithPanel and use
    "Restore Initial", or set them again in Finder > Get Info > Open with.
    This folder holds OpenWithPanel's rules and snapshots. It is safe to delete.

    如果你是把 OpenWithPanel.app 直接拖进废纸篓删除的，它内嵌的 OpenWithPanel Helper 也一起删掉了，
    macOS 会自动清掉指向它的文件关联。
    想恢复使用 OpenWithPanel 之前的打开方式，可以重新安装 OpenWithPanel 后点「恢复到初始」，
    或者在访达「显示简介 > 打开方式」里重新设置。
    这个文件夹存放 OpenWithPanel 的规则和快照，可以放心删除。

    如果你是把 OpenWithPanel.app 直接拖到垃圾桶刪除的，它內嵌的 OpenWithPanel Helper 也一併刪除了，
    macOS 會自動清除指向它的檔案關聯。
    想恢復使用 OpenWithPanel 之前的打開方式，可以重新安裝 OpenWithPanel 後按一下「復原到初始」，
    或者在 Finder「取得資訊 > 打開檔案的應用程式」裡重新設定。
    這個檔案夾存放 OpenWithPanel 的規則和快照，可以放心刪除。

    OpenWithPanel.app をゴミ箱にドラッグして削除した場合、内蔵のヘルパー（OpenWithPanel Helper）も
    一緒に削除され、macOS はそれを指していたファイルの関連付けを解除します。
    OpenWithPanel より前にファイルを開いていた App に戻すには、OpenWithPanel を再インストールして
    「初期状態に復元」を使うか、Finder の「情報を見る > このアプリケーションで開く」で
    設定し直してください。
    このフォルダには OpenWithPanel のルールとスナップショットが保存されています。削除しても問題ありません。

    OpenWithPanel.app을 휴지통으로 드래그해서 삭제했다면 도우미(OpenWithPanel Helper)도 함께 삭제되었으며,
    macOS는 이를 가리키던 파일 연결을 해제합니다.
    OpenWithPanel 이전에 파일을 열던 앱으로 되돌리려면 OpenWithPanel을 다시 설치한 다음
    '초기 상태로 복원'을 사용하거나, Finder의 '정보 가져오기 > 다음으로 열기'에서 다시 설정하십시오.
    이 폴더에는 OpenWithPanel의 규칙과 스냅샷이 저장되어 있습니다. 삭제해도 안전합니다.

    Wenn du OpenWithPanel.app gelöscht hast, indem du es in den Papierkorb gezogen hast, ist auch sein
    Helfer (OpenWithPanel Helper) weg, und macOS entfernt die Dateizuordnungen, die auf ihn zeigten.
    Um die Apps zurückzuholen, die deine Dateien vor OpenWithPanel geöffnet haben, installiere OpenWithPanel
    erneut und verwende „Anfangszustand wiederherstellen“, oder lege sie unter
    Finder > Informationen > Öffnen mit neu fest.
    Dieser Ordner enthält die Regeln und Schnappschüsse von OpenWithPanel. Du kannst ihn bedenkenlos löschen.

    Si vous avez supprimé OpenWithPanel.app en le faisant glisser dans la Corbeille, son assistant
    (OpenWithPanel Helper) a disparu lui aussi, et macOS abandonne les associations de fichiers qui
    pointaient vers lui.
    Pour retrouver les apps qui ouvraient vos fichiers avant OpenWithPanel, réinstallez OpenWithPanel et
    utilisez « Restaurer l’état initial », ou redéfinissez-les dans
    Finder > Lire les informations > Ouvrir avec.
    Ce dossier contient les règles et les instantanés d’OpenWithPanel. Vous pouvez le supprimer sans risque.

    Si eliminaste OpenWithPanel.app arrastrándolo a la Papelera, su ayudante (OpenWithPanel Helper) también
    ha desaparecido, y macOS descarta las asociaciones de archivos que apuntaban a él.
    Para recuperar las apps que abrían tus archivos antes de OpenWithPanel, vuelve a instalar OpenWithPanel y
    usa "Restaurar estado inicial", o vuelve a configurarlas en
    Finder > Obtener información > Abrir con.
    Esta carpeta contiene las reglas y las instantáneas de OpenWithPanel. Puedes eliminarla sin problemas.

    Se você apagou o OpenWithPanel.app arrastando-o para o Lixo, o auxiliar dele (OpenWithPanel Helper)
    também foi removido, e o macOS descarta as associações de arquivos que apontavam para ele.
    Para voltar aos apps que abriam seus arquivos antes do OpenWithPanel, reinstale o OpenWithPanel e use
    "Restaurar o estado inicial", ou configure-os novamente em Finder > Obter Informações > Abrir Com.
    Esta pasta guarda as regras e os instantâneos do OpenWithPanel. É seguro apagá-la.

    Jika Anda menghapus OpenWithPanel.app dengan menyeretnya ke Tong Sampah, helper-nya
    (OpenWithPanel Helper) juga ikut terhapus, dan macOS melepas asosiasi file yang mengarah ke helper itu.
    Untuk mengembalikan aplikasi yang membuka file Anda sebelum OpenWithPanel, instal ulang OpenWithPanel lalu
    gunakan "Pulihkan ke Awal", atau atur ulang di Finder > Dapatkan Info > Buka Dengan.
    Folder ini menyimpan aturan dan snapshot OpenWithPanel. Folder ini aman untuk dihapus.

    หากคุณลบ OpenWithPanel.app ด้วยการลากไปที่ถังขยะ ตัวช่วย (OpenWithPanel Helper) ของแอปก็ถูกลบไปด้วย
    และ macOS จะยกเลิกการเชื่อมโยงไฟล์ที่ชี้ไปยังตัวช่วยนั้น
    หากต้องการกลับไปใช้แอปที่เคยเปิดไฟล์ของคุณก่อนใช้ OpenWithPanel ให้ติดตั้ง OpenWithPanel ใหม่
    แล้วใช้ "กู้คืนเป็นค่าเริ่มต้น" หรือตั้งค่าใหม่ใน Finder > ขอรายละเอียด > เปิดด้วย
    โฟลเดอร์นี้เก็บกฎและสแนปช็อตของ OpenWithPanel สามารถลบได้อย่างปลอดภัย

    Nếu bạn đã xóa OpenWithPanel.app bằng cách kéo vào Thùng rác, trình trợ giúp (OpenWithPanel Helper)
    của nó cũng đã bị xóa, và macOS sẽ bỏ các liên kết tệp trỏ tới nó.
    Để dùng lại các ứng dụng đã mở tệp của bạn trước khi có OpenWithPanel, hãy cài lại OpenWithPanel và dùng
    "Khôi phục ban đầu", hoặc đặt lại trong Finder > Lấy thông tin > Mở bằng.
    Thư mục này chứa quy tắc và ảnh chụp nhanh của OpenWithPanel. Bạn có thể xóa thư mục này một cách an toàn.

    إذا حذفت OpenWithPanel.app بسحبه إلى سلة المهملات، فقد حُذف مساعده (OpenWithPanel Helper) أيضًا،
    ويُسقط macOS اقترانات الملفات التي كانت تشير إليه.
    لإرجاع التطبيقات التي كانت تفتح ملفاتك قبل OpenWithPanel، أعد تثبيت OpenWithPanel واستخدم
    "استعادة الحالة الأولية"، أو عيّنها من جديد في Finder > إحضار المعلومات > فتح بواسطة.
    يحتوي هذا المجلد على قواعد OpenWithPanel ولقطاته. يمكن حذفه بأمان.

    Если вы удалили OpenWithPanel.app, перетащив его в Корзину, его помощник (OpenWithPanel Helper)
    тоже удалён, и macOS убирает связи файлов, которые указывали на него.
    Чтобы вернуть приложения, которые открывали ваши файлы до OpenWithPanel, установите OpenWithPanel
    заново и используйте «Восстановить исходное» или назначьте их снова в
    Finder > Свойства > Открыть в приложении.
    В этой папке хранятся правила и снимки OpenWithPanel. Её можно спокойно удалить.

    अगर आपने OpenWithPanel.app को रद्दी में ड्रैग करके डिलीट किया है, तो उसका हेल्पर (OpenWithPanel Helper)
    भी हट गया है, और macOS उसकी ओर इशारा करने वाले फ़ाइल संबंध हटा देता है।
    OpenWithPanel से पहले जो ऐप आपकी फ़ाइलें खोलते थे, उन्हें वापस लाने के लिए OpenWithPanel को फिर से
    इंस्टॉल करें और "शुरुआती स्थिति बहाल करें" का उपयोग करें, या उन्हें
    Finder > जानकारी प्राप्त करें > इसमें खोलें में फिर से सेट करें।
    यह फ़ोल्डर OpenWithPanel के नियम और स्नैपशॉट रखता है। इसे डिलीट करना सुरक्षित है।

    """
}

public struct ConfigurationStore: Sendable {
  public let layout: AppSupportLayout

  public init(layout: AppSupportLayout) {
    self.layout = layout
  }

  public func load() throws -> Configuration {
    guard FileManager.default.fileExists(atPath: layout.configuration.path) else {
      return Configuration()
    }
    return try JSONDecoder().decode(
      Configuration.self, from: Data(contentsOf: layout.configuration))
  }

  public func save(_ configuration: Configuration) throws {
    try layout.prepare()
    try Self.encode(configuration).write(to: layout.configuration, options: .atomic)
  }

  public static func encode(_ configuration: Configuration) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    return try encoder.encode(configuration)
  }

  public static func exportPreset(_ configuration: Configuration) throws -> Data {
    var preset = configuration
    preset.fallbacks = [:]
    preset.folderRules = []
    return try encode(preset)
  }

  // 交还目标取自本机的初始快照；文件夹规则指向本机路径，启动时会自动给里面的文件写打开方式，
  // 不能让别人的预设带进来
  public static func importPreset(_ data: Data, keepingLocalSettingsOf current: Configuration)
    throws -> Configuration
  {
    var configuration = try JSONDecoder().decode(Configuration.self, from: data)
    configuration.fallbacks = current.fallbacks
    configuration.folderRules = current.folderRules
    return configuration
  }
}
