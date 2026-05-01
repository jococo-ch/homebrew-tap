class LolaSumup < Formula
  desc "A cli program to create LoLa specific exports from monthly SumUp reports"
  homepage "https://github.com/jococo-ch/lola-sumup"
  version "0.4.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.4.10/lola-sumup-aarch64-apple-darwin.tar.xz"
      sha256 "a039c8c5831abff08f8e60ad92c22c38c288525dfc4f61f20923c252473e9038"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.4.10/lola-sumup-x86_64-apple-darwin.tar.xz"
      sha256 "d1e883101167e851abb73fac149f587f0def28923b39e58a1d00c1c1b8d7f1b6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.4.10/lola-sumup-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "da436a0d3f01d06821f988bc79480256fade29e38254a00732a4a3d6aa92bb28"
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
