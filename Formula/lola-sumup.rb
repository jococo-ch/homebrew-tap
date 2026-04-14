class LolaSumup < Formula
  desc "A cli program to create LoLa specific exports from monthly SumUp reports"
  homepage "https://github.com/jococo-ch/lola-sumup"
  version "0.4.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.4.8/lola-sumup-aarch64-apple-darwin.tar.xz"
      sha256 "ea2c38e9a356afb83ee1a52f2421fc98239f884d425b65f5d02c8d64577208b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.4.8/lola-sumup-x86_64-apple-darwin.tar.xz"
      sha256 "9789824d22517f484cc913d7cf9bdf83852d6a486017dc4ca4acb82a1aaef8d9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.4.8/lola-sumup-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "478d8c7e82b34ac94dc1d65c0dd320c936893cbb293eccdb6ecab463ab387d01"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "lola-sumup" if OS.mac? && Hardware::CPU.arm?
    bin.install "lola-sumup" if OS.mac? && Hardware::CPU.intel?
    bin.install "lola-sumup" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
