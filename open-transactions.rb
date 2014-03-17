require 'formula'

class OpenTransactions < Formula
  homepage 'http://opentransactions.org'
  #HEAD only formula until OT gets some sort of of offical release tarball/stable target
  # url 'https://github.com/Open-Transactions/Open-Transactions/archive/1b859c745fc41647c21cf37c1fc6e62b82b57994.zip'
  # version '1b859'
  # sha1 '2049092c67f00084529bc0394ecdbd347ebaa058'
  head 'https://github.com/Open-Transactions/Open-Transactions.git'

  depends_on 'libtool'    => :build
  depends_on 'automake'   => :build
  depends_on 'autoconf'   => :build
  depends_on 'pkg-config' => :build
  depends_on 'openssl'
#  depends_on 'protobuf' => 'c++11' #TODO: how should we link c++11 protobuf and the disable-cxx11 options together?
  depends_on 'protobuf'
  depends_on 'msgpack'
  depends_on 'homebrew/versions/zeromq22'

  depends_on 'perl'   => :optional
  depends_on 'ruby'   => :optional
  depends_on 'python' => :optional

  option 'with-java', 'SWIG support for Java (Java not managed by homebrew)'
  option 'with-php', 'SWIG support for PHP (PHP not managed by homebrew)'
  option 'with-csharp', 'SWIG support for C# (C# not managed by homebrew)'
  option 'with-d', 'SWIG support for D (D not managed by homebrew)'
  option 'with-tcl', 'SWIG support for tcl (tcl not managed by homebrew)'
  option 'with-go', 'SWIG support for GO (GO not supported by homebrew)'

  option 'enable-debug', 'Enable Configuration in Debug Mode'
  option 'enable-release', 'Enable Configuration in Release Mode'
  option "enable-warnings", 'Enable extra (noisy) warnings with compile'
  option "enable-sighandler", 'Enable the signal handling for catching segmentation faults (debug only)'
  option "with-keyring", 'Enable osx system keyring storage of OT passwords'
  option 'use-i686', "Build using an i686 (32bit) target"


  def install
    i686_args = ["--build=i686-apple-darwin11", "--host=i686-apple-darwin11", "--target=i686-apple-darwin11"]
    x64_args =  ["--build=x86_64-apple-darwin11","--host=x86_64-apple-darwin11","--target=x86_64-apple-darwin11"]
    config_args = (build.include? 'use-i686') ? i686_args : x64_args

    config_args << '--enable-debug'      if build.include? 'enable-debug'
    config_args << '--enable-release'    if build.include? 'enable-release'
    config_args << '--enable-warnings'   if build.include? 'enable-warnings'
    config_args << '--enable-sighandler' if build.include? 'enable-sighandler'
    config_args << '--with-keyring=mac'  if build.include? 'with-keyring'
    #SWIG Languages
    config_args << '--with-ruby'   if build.with? 'ruby'
    config_args << '--with-perl5'  if build.with? 'perl'
    config_args << '--with-python' if build.with? 'python'
    config_args << '--with-tcl'    if build.with? 'tcl'
    config_args << '--with-java'   if build.with? 'java'
    config_args << '--with-php'    if build.with? 'php'
    config_args << '--with-csharp' if build.with? 'csharp'
    config_args << '--with-d'      if build.with? 'd'
    
    system 'sh', 'autogen.sh'
    system "./configure", "--prefix=#{prefix}", "--with-openssl=#{HOMEBREW_PREFIX}/opt/openssl", *config_args
    system 'make'
    system 'make', 'install'
  end

  test do
    system "false"
  end
end
