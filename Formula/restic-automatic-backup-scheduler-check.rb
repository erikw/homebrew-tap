# This formula is not intended to be installed on its own, just as a dependency for restic-automatic-backup-scheduler
class ResticAutomaticBackupSchedulerCheck < Formula
  desc "Install restic-check LaunchAgent for restic-automatic-backup-scheduler formula"
  homepage "https://github.com/erikw/restic-automatic-backup-scheduler"
  url "https://github.com/erikw/restic-automatic-backup-scheduler/archive/refs/tags/v7.3.3.tar.gz"
  sha256 "e67a620f53badac9eaab8b22f426143b9d4cf1a3c2279871b750975f3c6f548a"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/erikw/homebrew-tap/releases/download/restic-automatic-backup-scheduler-check-7.3.3"
    sha256 cellar: :any_skip_relocation, big_sur:      "f9154878dcadfad8ab349160522a722bb86d82c6bd0e191d99abbb445c929d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1dce6c4bda2ff6b3b97133848c12348b85ad16da0ef3c638ae83dfe50f3f4bf9"
  end

  depends_on "bash"

  def install
    args = %W[
      PREFIX=#{prefix}
      INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      SYSCONFDIR=#{etc}/..
      LAUNCHAGENTDIR=#{prefix}
    ]

    # Build and install only the LaunchAgent.
    # Don't use string interpolation to avoid fault brew-audit check.
    # "#{prefix}/Lib" should be "#{lib}"
    plist = prefix.to_s + "/Library/LaunchAgents/com.github.erikw.restic-check.plist"
    system "make", plist, *args

    # The LaunchAgent need to have a special name for brew-services to pick it up.
    # Reference: https://docs.brew.sh/Formula-Cookbook#launchd-plist-files
    prefix.install_symlink \
      "Library/LaunchAgents/com.github.erikw.restic-check.plist" => "#{plist_name}.plist"
  end

  test do
    system "true"
  end
end
