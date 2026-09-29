cask "token-station" do
  version "0.1.0"
  sha256 "dc943c5894d3f55a66ef5775df2aebe725d14fb18d9fd5f5595c760b984def38"

  url "https://github.com/psoldunov/token-station/releases/download/v#{version}/TokenStation-macOS.zip"
  name "Token Station"
  desc "Claude Code and Codex plan usage in the menu bar"
  homepage "https://github.com/psoldunov/token-station"

  livecheck do
    url :url
    strategy :github_latest
  end

  # macOS 14 is the floor the app declares in its own Info.plist
  # (LSMinimumSystemVersion 14.0). The build is universal, so no `arch`.
  depends_on macos: :sonoma

  app "Token Station.app"

  # Menu-bar app with no Dock icon that runs its own daemon, so it is nearly
  # always running during `brew upgrade`. Ask it to quit first.
  uninstall quit: "dev.soldunov.TokenStation"

  zap trash: [
    "~/Library/Application Support/dev.soldunov.TokenStation",
    "~/Library/Caches/dev.soldunov.TokenStation",
    "~/Library/Preferences/dev.soldunov.TokenStation.plist",
  ]
end
