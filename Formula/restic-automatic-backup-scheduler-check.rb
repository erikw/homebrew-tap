# This formula is not intended to be installed on its own, just as a dependency for restic-automatic-backup-scheduler.
class ResticAutomaticBackupSchedulerCheck < Formula
  desc "Install restic-check LaunchAgent for restic-automatic-backup-scheduler formula"
  homepage "https://github.com/erikw/restic-automatic-backup-scheduler"
  url "https://github.com/erikw/restic-automatic-backup-scheduler/archive/refs/tags/v7.4.0.tar.gz"
  sha256 "0adf4a5aaa25bf9860b22fb67972f6b892caa9a06d2c5acd59195725f5b4e6dc"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/erikw/homebrew-tap/releases/download/restic-automatic-backup-scheduler-check-7.4.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "609e5b96aa4b6313688905134530d3572e899523ff5e29b22a055f395b93cc8d"
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
