class ResticAutomaticBackupScheduler < Formula
  desc "Automatic restic backup schedule using Backblaze B2 storage & macOS LaunchAgents"
  homepage "https://github.com/erikw/restic-systemd-automatic-backup"
  url "https://github.com/erikw/restic-systemd-automatic-backup/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "aeda2d5818d9d18d271db2b73fda5816fb8f0eff9445570364f068dbc29567e2"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://github.com/erikw/homebrew-tap/releases/download/restic-automatic-backup-scheduler-5.2.0_2"
    sha256 cellar: :any_skip_relocation, big_sur:      "44dc83b1fa923b0128c9a69fea8c0b577bcafd6ab8dab031a1b772c3428bde78"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be2d3a3271e4bb15783a1b71dcc55d4afb9cb0c5dfed06a940e4b6738f9408e8"
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

      See full tutorial at https://github.com/erikw/restic-systemd-automatic-backup
      ===========
    EOS
  end

  test do
    act = shell_output("resticw -h").lines.first.strip
    exp = "A little wrapper over restic just to handle profiles and environment loading."
    assert_equal exp, act
  end
end
