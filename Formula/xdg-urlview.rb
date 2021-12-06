class XdgUrlview < Formula
  desc "URL extractor/launcher. This is a fork which respects the XDG directory specifications for configuration files"
  homepage "https://github.com/ozangulle/xdg-urlview"
  url "https://github.com/ozangulle/xdg-urlview/archive/refs/tags/v0.9-xdg-1.0.0.tar.gz"
  version "v0.9-xdg-1.0.0"
  sha256 "6a03ce08cba4a7bc16630f17bd8225fc16b01844dfac8f756baae1a14e1d7807"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://github.com/ozangulle/xdg-urlview/tags"
    regex(/(\d+(?:[.-]\d+)+-xdg-\d+(?:[.-]\d+)+)/i)
  end

  on_linux do
    depends_on "automake"
  end

  conflicts_with "urlview", because: "xdg-urlview is a fork of urlview, using the same binary installation paths"

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
