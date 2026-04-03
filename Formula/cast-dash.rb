class CastDash < Formula
  desc "Terminal UI dashboard for Claude Code — htop for CAST"
  homepage "https://github.com/ek33450505/cast-dash"
  url "https://github.com/ek33450505/cast-dash/archive/refs/heads/main.tar.gz"
  version "0.1.0"
  sha256 ""
  license "MIT"

  depends_on "python@3"

  def install
    libexec.install Dir["scripts/*"]
    (libexec/"config").install Dir["config/*"]
    (libexec/"VERSION").write(File.read("VERSION"))
    prefix.install "VERSION"

    inreplace "bin/cast-dash",
              'CAST_DASH_DIR=""',
              "CAST_DASH_DIR=\"#{libexec}\""

    inreplace "bin/cast-dash",
              /CD_VERSION="\$\(cat.*\|\| echo .unknown.\)"/,
              "CD_VERSION=\"#{version}\""

    bin.install "bin/cast-dash"
  end

  def caveats
    <<~EOS
      Set up the Python environment and install textual:
        cast-dash setup

      Launch the dashboard:
        cast-dash

      Note: cast-dash reads ~/.claude/cast.db. Install cast-hooks or the
      full CAST framework to populate the database with observability data.
    EOS
  end

  test do
    system "#{bin}/cast-dash", "--version"
  end
end
