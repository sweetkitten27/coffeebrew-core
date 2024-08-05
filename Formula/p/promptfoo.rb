class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.75.0.tgz"
  sha256 "dcb92a874c319fe0fcf057bba7587bb7ec2c3ac0428b09ac299b3a8565809b55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "175f6afb95e174f46af82e5b5cc296b182f49ea6954dc106e90ae177fa85a1d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f9d0d772736c844edb3aa419b9e8d5a9c0844901c566eb97bf26cf2b8e97b87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24d97ae11615112f97e17d4df7eaa972eedc5fa2fa155e7da3904786c20947fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ba1d8e23193240bd3e28e338f8f384ed87caf9cf1cf729076872ac61add21c0"
    sha256 cellar: :any_skip_relocation, ventura:        "e8fb7fe5a5be16332b033cf11d04a3d6b78a2089b93666377bbe06a16a2276d5"
    sha256 cellar: :any_skip_relocation, monterey:       "371d93b057ba379890ed4ec2d8547a32589655c2fa9021cca36b3ecaa7bfbef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eeffd88a9884708bce4bafe7895969c878dd73efbeef4f03373d476811aa1ef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
