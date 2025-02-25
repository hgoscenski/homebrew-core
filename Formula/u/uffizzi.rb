class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "aba32f08219487a679e050409e9af4a80d7a2a66599a368b9e3accd9837fe32c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e6f7abc9beae6d38b4468350b40fa848e9aed366e8c7651011a4ae80960317d"
    sha256 cellar: :any,                 arm64_ventura:  "688ca1d01638104b87a6069c712b85a015b896bbcd518d73e9988a27c91eefad"
    sha256 cellar: :any,                 arm64_monterey: "502e15c491e1a4c81c090463c1f3434449a272483e6e6b16e7c600e6b661e822"
    sha256 cellar: :any,                 sonoma:         "31b7ece9b3ec41aa460cf17bcc73712b3f4a6edc3ac99cf0fff5c73895828d55"
    sha256 cellar: :any,                 ventura:        "b4f602071176cdaee8ed48cd5408bfa8847843f2710d0ccf929df8842d263bb4"
    sha256 cellar: :any,                 monterey:       "dfc013f2549322b143a270929347917cc98495b0c6e86b6282afc864529b87a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54408265c61129954559bd311c8fba3031fb12f7331ff99f17f6b24bac2e92d"
  end

  depends_on "ruby@3.0"

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-6.1.4.1.gem"
    sha256 "44b781877c2189aa15ca5451e2d310dcedfd16c01df1106f68a91b82990cfda5"
  end

  resource "awesome_print" do
    url "https://rubygems.org/gems/awesome_print-1.9.2.gem"
    sha256 "e99b32b704acff16d768b3468680793ced40bfdc4537eb07e06a4be11133786e"
  end

  resource "faker" do
    url "https://rubygems.org/gems/faker-3.2.1.gem"
    sha256 "d6b201b520213f6d985ac9f9f810154397a146ca22c1d3ff0a6504ef37c5517b"
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.5.2.gem"
    sha256 "8aa0441655aec5514008e1d04892c2de3ba57bd337afb984568da091121a241b"
  end

  resource "minitar" do
    url "https://rubygems.org/gems/minitar-0.9.gem"
    sha256 "23c0bebead35dbfe9e24088dc436c8a233d03f51d365a686b9a11dd30dc2d588"
  end

  resource "securerandom" do
    url "https://rubygems.org/gems/securerandom-0.2.2.gem"
    sha256 "5fcb3b8aa050bac5de93a5e22b69483856f70d43affeb883bce0c58d71360131"
  end

  resource "sentry-ruby" do
    url "https://rubygems.org/gems/sentry-ruby-5.11.0.gem"
    sha256 "27f603638d75d28b974def362792f442ae39e3e1c1496427910f9a0f434f3a71"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.2.2.gem"
    sha256 "2f93c652828cba9fcf4f65f5dc8c306f1a7317e05aad5835a13740122c17f24c"
  end

  resource "tty-prompt" do
    url "https://rubygems.org/gems/tty-prompt-0.23.1.gem"
    sha256 "fcdbce905238993f27eecfdf67597a636bc839d92192f6a0eef22b8166449ec8"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "uffizzi-cli" do
    url "https://rubygems.org/gems/uffizzi-cli-2.2.0.gem"
    sha256 "a5a1c082e17ee8862bf7aaa7aa7ad52ff3fab66df8dc78376161b69cfc46293d"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document", "--install-dir", libexec
    end

    bin.install Dir["#{libexec}/bin/*"]

    bin.env_script_all_files(libexec, GEM_HOME: ENV["GEM_HOME"], GEM_PATH: ENV["GEM_PATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uffizzi version")
    server_url = "https://example.com"
    system bin/"uffizzi config set server #{server_url}"
    assert_match server_url, shell_output("#{bin}/uffizzi config get-value server")
  end
end
