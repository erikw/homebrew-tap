class ResticAutomaticBackupScheduler < Formula
  desc "Automatic restic backup schedule using Backblaze B2 storage & macOS LaunchAgents"
  homepage "https://github.com/erikw/restic-automatic-backup-scheduler"
  url "https://github.com/erikw/restic-automatic-backup-scheduler/archive/refs/tags/v7.2.0.tar.gz"
  sha256 "0db7f747067427ae8ec5ad01d7d407588965d5259354401d93adda55c3e2ce79"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://github.com/erikw/homebrew-tap/releases/download/restic-automatic-backup-scheduler-7.1.0_1"
    sha256 cellar: :any_skip_relocation, big_sur:      "909911cb85d948cc2c2adabf9762153b878a70b1377e75c36f38c54f7826ef73"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ad75e8d195089b00b68bb800eaaba91141ed5b70a4829959d9e53cea45185c47"
  end

  depends_on "bash"
  depends_on "erikw/tap/restic-automatic-backup-scheduler-check"
  depends_on "restic"

  # Variables documented at:
  # https://docs.brew.sh/Formula-Cookbook#variables-for-directory-locations
  def install
    args = %W[
      PREFIX=#{prefix}
      INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      SYSCONFDIR=#{etc}/..
      LAUNCHAGENTDIR=#{prefix}
    ]

    system "make", "install-launchagent", *args

    # The LaunchAgent need to have a special name for brew-services to pick it up.
    # Reference: https://docs.brew.sh/Formula-Cookbook#launchd-plist-files
    prefix.install_symlink \
      "Library/LaunchAgents/com.github.erikw.restic-backup.plist" => "#{plist_name}.plist"
  end

  def caveats
    <<~EOS
      ===========
      To get started with backups, do the following:

      1. Edit config files at /etc/restic/*.env.sh
      1. Enable the backup service:
         $ brew services start restic-automatic-backup-scheduler
      2. If you want a different schedule or profile, edit + restart:
         $ vim ~/Library/LaunchAgents/homebrew.mxcl.restic-automatic-backup-scheduler.plist
         $ brew services restart restic-automatic-backup-scheduler
      4. To stop the backups,
         $ brew services stop restic-automatic-backup-scheduler
      4. (recommended) enable the check service:
         $ brew services start restic-automatic-backup-scheduler-check

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
