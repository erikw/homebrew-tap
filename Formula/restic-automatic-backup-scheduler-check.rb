# This formula is not intended to be installed on its own, just as a dependency for restic-automatic-backup-scheduler.
class ResticAutomaticBackupSchedulerCheck < Formula
  desc "Install restic-check LaunchAgent for restic-automatic-backup-scheduler formula"
  homepage "https://github.com/erikw/restic-automatic-backup-scheduler"
  url "https://github.com/erikw/restic-automatic-backup-scheduler/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "c268a9c2ec86e84f966e254cb5a008a835354c37931c3608d557f8c6fb96d7ac"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/erikw/homebrew-tap/releases/download/restic-automatic-backup-scheduler-check-7.5.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "833eda5680750542862d71cf2131e112fb44b5529499456cca095d9df679bb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "044eba537aaf716eba924ac1514c617d276f7f01caf7edb5ce2deb0976a1432f"
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
