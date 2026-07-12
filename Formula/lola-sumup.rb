class LolaSumup < Formula
  desc "A cli program to create LoLa specific exports from monthly SumUp reports"
  homepage "https://github.com/jococo-ch/lola-sumup"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.5.0/lola-sumup-aarch64-apple-darwin.tar.xz"
      sha256 "aa0bb7d964b9336ad4f0882cb4c6ca6be1e98a933ecc47550ead38cd959e1eba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.5.0/lola-sumup-x86_64-apple-darwin.tar.xz"
      sha256 "3bb96932a5db804ba7ea71d7395b7b6295ef9fb78565e05c044b53f7e1e41a5d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jococo-ch/lola-sumup/releases/download/v0.5.0/lola-sumup-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "752dcde01c6019d92db2e09cfa95a9d3f3b70b6949482e057670fba7f3481fc0"
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
