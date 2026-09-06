cask "skrepka" do
  version "0.1.3"
  sha256 "8a8acb49fd5859863e47bc405566b0adb6010ee04bfa5b0f4374b4cfdbb5f8c6"

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

  # `~/Library/Application Support/<bundle id>` is the SwiftData store plus the
  # externally-stored image payloads beside it — the clipboard history itself.
  # That is why it is on `zap` and not on `uninstall`.
  #
  # Both identifiers are listed: 0.1.1 moved the bundle from
  # `com.psoldunov.skrepka` to `dev.soldunov.skrepka` without migrating, so a
  # machine that ever ran 0.1.0 still has the old tree — including the old
  # history, in the clear — and `zap` is what is supposed to leave nothing behind.
  zap trash: [
    "~/Library/Application Support/com.psoldunov.skrepka",
    "~/Library/Application Support/dev.soldunov.skrepka",
    "~/Library/Caches/com.psoldunov.skrepka",
    "~/Library/Caches/dev.soldunov.skrepka",
    "~/Library/Preferences/com.psoldunov.skrepka.plist",
    "~/Library/Preferences/dev.soldunov.skrepka.plist",
    "~/Library/Saved Application State/com.psoldunov.skrepka.savedState",
    "~/Library/Saved Application State/dev.soldunov.skrepka.savedState",
  ]

  # Launch at login is registered with `SMAppService.mainApp`, so launchd owns
  # it and neither `uninstall` nor `zap` can reach it.
  #
  # The upgrade note is here rather than in the release notes alone because
  # macOS keys per-app state to the bundle identifier: 0.1.1 changed it, so
  # everything 0.1.0 stored is orphaned rather than migrated, and `brew upgrade`
  # is the moment the user finds out.
  caveats <<~EOS
    Upgrading from 0.1.0: the bundle identifier changed, so macOS treats this as
    a different app. Clipboard history, settings and per-app exclusions start
    over, Accessibility has to be granted again on the first paste, and "Launch
    at login" needs switching back on. The old history is still on disk at
    ~/Library/Application Support/com.psoldunov.skrepka — copy it over
    ~/Library/Application Support/dev.soldunov.skrepka before first launch to
    keep it, or delete it, but do not leave it there unread: it is your whole
    clipboard history in the clear. Stale "Skrepka" entries under System
    Settings → Privacy & Security → Accessibility and → General → Login Items &
    Extensions are dead and can be removed.

    If you turned on "Launch at login", switch it off in Skrepka's Settings
    before uninstalling — otherwise remove "Skrepka" afterwards under
    System Settings → General → Login Items & Extensions.
  EOS
end
