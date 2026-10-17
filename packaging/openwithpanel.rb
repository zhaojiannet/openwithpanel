cask "openwithpanel" do
  version "@VERSION@"
  sha256 "@SHA256@"

  url "https://github.com/zhaojiannet/openwithpanel/releases/download/v#{version}/OpenWithPanel-#{version}.dmg"
  name "OpenWithPanel"
  desc "Choose default apps for file types, links and extensionless files"
  homepage "https://github.com/zhaojiannet/openwithpanel"

  depends_on macos: :tahoe

  app "OpenWithPanel.app"

  # brew uninstall 不会恢复文件关联，那要靠 App 内的「卸载 OpenWithPanel…」
  uninstall quit: "net.zhaojian.openwithpanel"

  zap trash: [
    "~/Library/Application Support/net.zhaojian.openwithpanel",
    "~/Library/Preferences/net.zhaojian.openwithpanel.plist",
  ]
end
