cask "skrepka" do
  version "0.1.0"
  sha256 "798d42c44e34ed967614d7a6f53bbcd7aa52b413608eb947261079902552dd2c"

  # No `verified:` — deprecated in Homebrew 6.0, and unnecessary here anyway:
  # the download host and the homepage are the same repository.
  url "https://github.com/psoldunov/skrepka/releases/download/v#{version}/Skrepka.zip"
  name "Skrepka"
  desc "Clipboard-history manager that lives in the menu bar"
  homepage "https://github.com/psoldunov/skrepka"

  livecheck do
    url :url
    strategy :github_latest
  end

  # macOS 26 is the floor the app declares in its own Info.plist
  # (LSMinimumSystemVersion 26.0) — Liquid Glass lives in SwiftUICore and there
  # is nothing to fall back to on an older release. In a cask a bare symbol
  # means ">=", so this reads "Tahoe or newer".
  #
  # No `depends_on arch:`: the release build is universal (arm64 + x86_64),
  # because four Intel Macs still run macOS 26.
  depends_on macos: :tahoe

  app "Skrepka.app"

  # No `auto_updates`: Skrepka ships no in-app updater, so `brew upgrade` is the
  # whole update path and must not be told to leave this cask alone.

  # `~/Library/Application Support/com.psoldunov.skrepka` is the SwiftData store
  # plus the externally-stored image payloads beside it — the clipboard history
  # itself. That is why it is on `zap` and not on `uninstall`.
  zap trash: [
    "~/Library/Application Support/com.psoldunov.skrepka",
    "~/Library/Caches/com.psoldunov.skrepka",
    "~/Library/Preferences/com.psoldunov.skrepka.plist",
    "~/Library/Saved Application State/com.psoldunov.skrepka.savedState",
  ]

  # Launch at login is registered with `SMAppService.mainApp`, so launchd owns
  # it and neither `uninstall` nor `zap` can reach it.
  caveats <<~EOS
    If you turned on "Launch at login", switch it off in Skrepka's Settings
    before uninstalling — otherwise remove "Skrepka" afterwards under
    System Settings → General → Login Items & Extensions.
  EOS
end
