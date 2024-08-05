class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3520",
      revision: "d3f0c7166adfa952237e0f437a5344362d8256d4"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d738a8504090e456626dd513f4615a03aa3b884970a63477355928dac3628e4e"
    sha256 cellar: :any,                 arm64_ventura:  "5a55ffdf7aeb95e1b39a58fd10ae2673fdf7596cb8b2288eddb740ef58967d42"
    sha256 cellar: :any,                 arm64_monterey: "3a6181bd086d3f198bb15808bfe0687169372563f99f5cd6ba3eb9e2c8fa7f14"
    sha256 cellar: :any,                 sonoma:         "ae3cea99908ffb44a94b8dc08c6603025f27c86941704f485d06c3fa37f5a906"
    sha256 cellar: :any,                 ventura:        "b5c20722e21f66dc720b61db1f3586f265234de2bcf962cdd5274b6c30603028"
    sha256 cellar: :any,                 monterey:       "ef7a4a3a493389d4c2c44993f884d3c2b6f982179ae41e12416ccf0488e040c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41437ad26b2508be095f702622c597047a8c0c20a763a5a4fe4a16be5323fff0"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    bin.install_symlink libexec.children.select { |file|
                          file.executable? && !file.basename.to_s.start_with?("test-")
                        }
  end

  test do
    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
