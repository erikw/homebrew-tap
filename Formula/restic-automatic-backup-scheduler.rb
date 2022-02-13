class ResticAutomaticBackupScheduler < Formula
  desc "Automatic restic backup schedule using Backblaze B2 storage & macOS LaunchAgents"
  homepage "https://github.com/erikw/restic-automatic-backup-scheduler"
  url "https://github.com/erikw/restic-automatic-backup-scheduler/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "25ef0ad96f6be2a927342ceaa64e6e12d3df2a1a79495affc47024f971311c14"
  license "BSD-3-Clause"
  revision 2

  bottle do
    root_url "https://github.com/erikw/homebrew-tap/releases/download/restic-automatic-backup-scheduler-5.3.1_2"
    sha256 cellar: :any_skip_relocation, big_sur:      "2331370ef765781e9d3ac16aaac9bb5af752215addf0c5aad1830d3696a883f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "18bad2130ca2c3cfdb4add2a278727c8dff243105ff18a5204ea446ad8415baa"
  end

  depends_on "bash"
  depends_on "restic"

  # Variables documented at:
  # https://docs.brew.sh/Formula-Cookbook#variables-for-directory-locations
  def install
    args = %W[
      PREFIX=#{prefix}
      INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      SYSCONFDIR=#{etc}/..
      SYSCONFDIR=#{etc}/..
      LAUNCHAGENTDIR=#{prefix}
    ]

    system "make", "install-launchagent", *args

    # The LaunchAgent need to have a special name for brew-services to pick it up.
    # Reference: https://docs.brew.sh/Formula-Cookbook#launchd-plist-files
    prefix.install_symlink \
      "Library/LaunchAgents/com.github.erikw.restic-automatic-backup.plist" => "#{plist_name}.plist"
  end

  def caveats
    <<~EOS
      ===========
      To get started with backups, do the following:

      1. Edit config files at /etc/restic/*.env.sh
      1. Enable the service:
         $ brew services start restic-automatic-backup-scheduler
      2. If you want a different schedule or profile, edit + restart:
         $ vim ~/Library/LaunchAgents/homebrew.mxcl.restic-automatic-backup-scheduler.plist
         $ brew services restart restic-automatic-backup-scheduler
      4. To stop the backups,
         $ brew services stop restic-automatic-backup-scheduler

      **NOTE** If you updated the .plist file, you need to restart the service to
      reload the values.

      See full tutorial at https://github.com/erikw/restic-automatic-backup-scheduler
      ===========
    EOS
  end

  test do
    act = shell_output("resticw -h").lines.first.strip
    exp = "A little wrapper over restic just to handle profiles and environment loading."
    assert_equal exp, act
  end
end
