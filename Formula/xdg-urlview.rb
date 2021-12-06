# This formula is based on the upstream package's formula at:
# https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/urlview.rb
class XdgUrlview < Formula
  desc "URL extractor/launcher. A fork which respects the XDG specification"
  homepage "https://github.com/ozangulle/xdg-urlview"
  url "https://github.com/ozangulle/xdg-urlview/archive/refs/tags/v0.9-xdg-1.0.0.tar.gz"
  version "0.9-xdg-1.0.0"
  sha256 "6a03ce08cba4a7bc16630f17bd8225fc16b01844dfac8f756baae1a14e1d7807"
  license "GPL-2.0-or-later"
  revision 2
  livecheck do
    url "https://github.com/ozangulle/xdg-urlview/tags"
    regex(/(\d+(?:[.-]\d+)+-xdg-\d+(?:[.-]\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/erikw/homebrew-xdg-urlview/releases/download/xdg-urlview-0.9-xdg-1.0.0_1"
    rebuild 2
    sha256 cellar: :any_skip_relocation, big_sur: "005302024b4ad6136302d5b66f2a90ba7d56324fe0385fefc69bc914a002fb22"
  end

  on_linux do
    depends_on "automake"
  end

  conflicts_with "urlview", because: "xdg-urlview this is a fork of urlview, using the same binary installation paths"

  def install
    inreplace "urlview.man", "/etc/urlview/url_handler.sh", "open"
    inreplace "urlview.c",
              '#define DEFAULT_COMMAND "/etc/urlview/url_handler.sh %s"',
              '#define DEFAULT_COMMAND "open %s"'

    man1.mkpath

    if OS.linux?
      touch("NEWS") # autoreconf will fail if this file does not exist
      system "autoreconf", "-i"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
           "--sysconfdir=#{etc}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      With this patched vesion of urlview, your config file is no longer in
      $HOME/.urlview
      but at
      $XDG_CONFIG_HOME/urlview/urlview.

      $XDG_CONFIG_HOME defaults to ~/.config, thus the config file would typically be at ~/.config/urlview/urlview.
    EOS
  end

  # Run manually with $(brew test xdg-urlview).
  # NOTE Disabled as it did not work in the end. The script works in my own shell, but not in the brew test shell.
  test do
    # (testpath/"test.sh").write <<~EOS
    # #!/usr/bin/env bash
    ## Starts urlview with one URL as input.

    # echo "https://google.com" | urlview
    # EOS

    # (testpath/"test.expect").write <<~EOS
    # #!/usr/bin/expect -f
    ## There are not commandline options like -h or -v that could be used for a simpe alive-test, thus..
    ## Test that urlview can read an URL (test.sh) and then we just quit the application by sending "q".

    # set timeout -1
    # #spawn ./test.sh
    ## Need interactive shell?
    # spawn bash -c ./test.sh

    # expect -re "UrlView \\[0-9\\]+.\\[0-9\\]+:"
    # send -- "q"

    # expect eof
    # EOS
    # system "chmod", "u+x", "test.expect", "test.sh"
    # system "./test.expect"
    system "true"
  end
end
