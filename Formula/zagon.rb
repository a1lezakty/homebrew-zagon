# Written by release.yml of github.com/a1lezakty/zagon from packaging/homebrew/ in that repo: edit it there.
class Zagon < Formula
  desc "Jira worklogs, limits and time from Claude Code and Codex CLI sessions"
  homepage "https://github.com/a1lezakty/zagon"
  # Stated, not scanned: Homebrew reads "86.64" out of the zagon-linux-x86_64 URL.
  version "0.1.8"
  license "MIT"

  # One universal binary for both Mac CPUs (`url` is not allowed in on_macos itself).
  on_macos do
    depends_on macos: :ventura
    on_arm do
      url "https://github.com/a1lezakty/zagon/releases/download/v#{version}/zagon-macos-universal"
      sha256 "1e76e5923582707d8b6b1a86c3b42cb2b4dbfda7c330043fbc83dccd25be659c"
    end
    on_intel do
      url "https://github.com/a1lezakty/zagon/releases/download/v#{version}/zagon-macos-universal"
      sha256 "1e76e5923582707d8b6b1a86c3b42cb2b4dbfda7c330043fbc83dccd25be659c"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/a1lezakty/zagon/releases/download/v#{version}/zagon-linux-x86_64"
      sha256 "6a24cb543e55b904513f9fff5ac53e48900c493e7803b14c309e2ba20fd54e6f"
    end
    on_arm do
      url "https://github.com/a1lezakty/zagon/releases/download/v#{version}/zagon-linux-aarch64"
      sha256 "02508b74c0cc3a810258bfbc8c3cbe3da611272ce667662b281fa4a6956033fd"
    end
  end

  def install
    bin.install Dir["zagon-*"].first => "zagon"
  end

  def caveats
    s = <<~EOS
      Connect Claude Code and Codex (hooks, status line, MCP) through the path that stays the same across upgrades:
        zagon install --bin "#{opt_bin}/zagon"
      Without --bin, install writes this version's own Cellar path, which breaks after `brew upgrade`.
      Update with `brew upgrade zagon`, not `zagon update`.
    EOS
    if OS.linux?
      s += <<~EOS
        Add --enable-service to install to start the background service (zagon daemon).
        After `brew upgrade zagon`, restart it: systemctl --user restart zagon
      EOS
    else
      s += <<~EOS
        On a Mac, Zagon.app (brew install --cask a1lezakty/zagon/zagon) collects the data and connects Claude Code
        with the zagon inside it; this formula is the command line alone.
      EOS
    end
    s
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/zagon --version").strip
  end
end
