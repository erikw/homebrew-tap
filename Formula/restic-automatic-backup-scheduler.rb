class ResticAutomaticBackupScheduler < Formula
  desc "Automatic restic backup schedule using Backblaze B2 storage & macOS LaunchAgents"
  homepage "https://github.com/erikw/restic-systemd-automatic-backup"
  url "https://github.com/erikw/restic-systemd-automatic-backup/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "15f8a553e29ccb6c65ff2044392985834c451c51b4405891a47698442f0a532c"
  license "BSD-3-Clause"
  revision 2

  bottle do
    root_url "https://github.com/erikw/homebrew-tap/releases/download/restic-automatic-backup-scheduler-5.2.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "eb3df8d6eb97a1d8aa44bce2a6064cd68543c3e4d6d63133d18755e583bb3d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00dc2792b06c4c2cb7f6c519b19dbeb5e3f045871daa4ebd168d037c96d28d62"
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
    ]
    system "make", "install-launchagent", *args
  end

  def caveats
    <<~EOS
      ===========
      To get started with backups, do the following:

      1. Edit config files at /etc/restic/*.env.sh
      2. Possibly edit schedule and profile to use in
         ~/Library/LaunchAgents/com.github.erikw.restic-automatic-backup.plist
      3. Install, enable and start the first run!
         $ launchctl bootstrap gui/$UID ~/Library/LaunchAgents/com.github.erikw.restic-automatic-backup.plist
         $ launchctl enable gui/$UID/com.github.erikw.restic-automatic-backup
         $ launchctl kickstart -p gui/$UID/com.github.erikw.restic-automatic-backup
      4. Use the disable command to temporarily pause the agent, or bootout to uninstall it.
         $ launchctl disable gui/$UID/com.github.erikw.restic-automatic-backup
         $ launchctl bootout gui/$UID/com.github.erikw.restic-automatic-backup


      **NOTE** If you updated the .plist file, you need to issue the bootout followed by bootrstrap
      and enable sub-commands of launchctl. This will guarantee that the file is properly reloaded.


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
