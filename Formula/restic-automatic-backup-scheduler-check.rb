# This formula is not intended to be installed on its own, just as a dependency for restic-automatic-backup-scheduler
class ResticAutomaticBackupSchedulerCheck < Formula
  desc "Install restic-check LaunchAgent for restic-automatic-backup-scheduler formula"
  homepage "https://github.com/erikw/restic-automatic-backup-scheduler"
  url "https://github.com/erikw/restic-automatic-backup-scheduler/archive/refs/tags/v7.2.0.tar.gz"
  sha256 "0db7f747067427ae8ec5ad01d7d407588965d5259354401d93adda55c3e2ce79"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://github.com/erikw/homebrew-tap/releases/download/restic-automatic-backup-scheduler-check-7.2.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "992be52fd325fb096fc19b7bb5be8c54d8f956f60bfa4a2afc7c2eba0e32aa4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "13c4025fbd23c67e8e666a4d5fa06f096975c50fc6a2936bd1c877b1a5626586"
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
