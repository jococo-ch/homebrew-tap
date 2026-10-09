class LolaSumup < Formula
  desc "A cli program to create LoLa specific exports from monthly SumUp reports"
  homepage "https://github.com/jococo-ch/lola-sumup"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.5.3/lola-sumup-aarch64-apple-darwin.tar.xz"
      sha256 "47f7461ef1e4b3ab2ca8f692de5d8e2902a8bb82980fb0cc270be4d138c90673"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.5.3/lola-sumup-x86_64-apple-darwin.tar.xz"
      sha256 "8faf108bee714cdd3aecbe96b91a737f6814a3121f851ce7cf223a4896dadd87"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.5.3/lola-sumup-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "33b476a36428e636590b119c76bcbbbfa0607b649337c9e5cf2fbb3c7b1c7354"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "lola-sumup"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "lola-sumup"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "lola-sumup"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
