# psoldunov's Homebrew tap

Casks for my own macOS apps.

## Skrepka

A clipboard-history manager for macOS 26 — menu bar, no Dock icon, ⌘⇧V opens a
Liquid Glass picker over whatever app you are in.
[Source and issues](https://github.com/psoldunov/skrepka).

```sh
brew install --cask psoldunov/tap/skrepka
```

Or tap first, then install:

```sh
brew tap psoldunov/tap
brew install --cask skrepka
```

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "psoldunov/tap"
cask "skrepka"
```

Skrepka needs macOS 26 (Tahoe) or newer, which the cask declares — `brew`
refuses rather than installing something that cannot launch. The build is
universal, so it runs on Apple silicon and on the four Intel Macs that still get
macOS 26.

The download is the notarized, stapled `Skrepka.zip` from the app's own GitHub
release, so it opens on first launch with no Gatekeeper detour.

### Updating

Skrepka has no in-app updater. `brew upgrade` is the whole update path:

```sh
brew upgrade --cask skrepka
```

#### Upgrading from 0.1.0

Skrepka 0.1.1 moved its bundle identifier from `com.psoldunov.skrepka` to
`dev.soldunov.skrepka` and ships no migration. macOS keys per-app state to that
identifier, so after the upgrade the clipboard history is empty, settings and
per-app exclusions are back to their defaults, Accessibility has to be granted
again on the first paste, and **Launch at login** needs switching back on.

The 0.1.0 history is not deleted — it is still at
`~/Library/Application Support/com.psoldunov.skrepka`. Copy that folder over
`~/Library/Application Support/dev.soldunov.skrepka` before first launch to
carry it across. If you do not want it, delete it rather than leaving it: it is
your whole clipboard history, in the clear.

The dead "Skrepka" entries under System Settings → Privacy & Security →
Accessibility and → General → Login Items & Extensions belong to the old
identifier and can be removed.

### Uninstalling

```sh
brew uninstall --cask skrepka
```

That leaves your clipboard history alone. To take it with you:

```sh
brew uninstall --zap --cask skrepka
```

`zap` removes `~/Library/Application Support/dev.soldunov.skrepka` — the
SwiftData store and the image payloads beside it — along with the preferences
and caches. It also removes the `com.psoldunov.skrepka` tree that Skrepka 0.1.0
wrote under the old bundle identifier, so nothing is left behind on a machine
that ran both.

One thing `zap` cannot reach: if you turned on **Launch at login**, that
registration belongs to launchd via `SMAppService`, not to any file Homebrew
owns. Switch it off in Skrepka's Settings before uninstalling, or remove
"Skrepka" afterwards under System Settings → General → Login Items &
Extensions.

## Issues

File them against the app they concern —
[`psoldunov/skrepka`](https://github.com/psoldunov/skrepka/issues) — unless the
problem is with the cask itself, in which case this repository is the place.
