class ResticAutomaticBackupScheduler < Formula
  desc "Automatic restic backup schedule using Backblaze B2 storage & macOS LaunchAgents"
  homepage "https://github.com/erikw/restic-automatic-backup-scheduler"
  url "https://github.com/erikw/restic-automatic-backup-scheduler/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "c268a9c2ec86e84f966e254cb5a008a835354c37931c3608d557f8c6fb96d7ac"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/erikw/homebrew-tap/releases/download/restic-automatic-backup-scheduler-7.5.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b4ee0ce4a22e7a95151790ebb30f6f715c3f086f6df5428aa3b37ea989781a5c"
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
    act = shell_output("#{bin}/resticw -h").lines.first.strip
    exp = "A little wrapper over restic just to handle profiles and environment loading, with small extensions."
    assert_equal exp, act
  end
end
