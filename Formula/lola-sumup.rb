class LolaSumup < Formula
  desc "A cli program to create LoLa specific exports from monthly SumUp reports"
  homepage "https://github.com/jococo-ch/lola-sumup"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.5.1/lola-sumup-aarch64-apple-darwin.tar.xz"
      sha256 "2faa0399a6be74a27d964941dba84ecc4fa811a6f2063dbf81566b0ed217e202"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.5.1/lola-sumup-x86_64-apple-darwin.tar.xz"
      sha256 "3190a0a470ad3b284dfc6d9cef93f4f99643e3f66bbf37318d8f59f4d2c083f6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.5.1/lola-sumup-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "41b757d4d06da8e7618541bf97784236bccfb491f3342e43aa91991670b6b952"
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
