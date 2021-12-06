class XdgUrlview < Formula
  desc "URL extractor/launcher. A fork which respects the XDG specification"
  homepage "https://github.com/ozangulle/xdg-urlview"
  url "https://github.com/ozangulle/xdg-urlview/archive/refs/tags/v0.9-xdg-1.0.0.tar.gz"
  version "0.9-xdg-1.0.0"
  sha256 "6a03ce08cba4a7bc16630f17bd8225fc16b01844dfac8f756baae1a14e1d7807"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://github.com/ozangulle/xdg-urlview/tags"
    regex(/(\d+(?:[.-]\d+)+-xdg-\d+(?:[.-]\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/erikw/homebrew-xdg-urlview/releases/download/xdg-urlview-0.9-xdg-1.0.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina: "e4aa07f46566e01127248a091e3a53f1ae295b963b91845e179be0405f12c3c5"
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
end
