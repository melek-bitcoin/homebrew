require 'formula'

class Bitcoind <Formula
  url 'http://downloads.sourceforge.net/project/bitcoin/Bitcoin/bitcoin-0.3.20/bitcoin-0.3.20.01-macosx.zip'
  version '0.3.20.01'
  homepage 'http://www.bitcoin.org/'
  md5 '7647795a0137eb7ef6b8c43a72e8f52f'

  depends_on 'boost'
  depends_on 'berkeley-db'

  def patches
    DATA
  end

  def install
    cd "bitcoin-0.3.20.01/src" do
        system "make -f makefile.osx bitcoind"
        bin.install "bitcoind"
    end
  end

  def caveats; <<-EOS.undent
    Bitcoin depends on berkeley-db 4.x, but Homebrew provides version 5.x,
    which doesn't work. To work around this, do:
      $ brew install https://github.com/adamv/homebrew/raw/versions/Library/Formula/berkeley-db4.rb --without-java
      $ brew install boost
      $ brew install --ignore-dependencies bitcoind
    EOS
  end

end

__END__
diff --git a/bitcoin-0.3.20.01/src/makefile.osx b/bitcoin-0.3.20.01/src/makefile.osx
index 5c1ca6f..858ddd1 100644
--- a/bitcoin-0.3.20.01/src/makefile.osx
+++ b/bitcoin-0.3.20.01/src/makefile.osx
@@ -5,8 +5,8 @@
 # Mac OS X makefile for bitcoin
 # Laszlo Hanyecz (solar@heliacal.net)

-CXX=llvm-g++
-DEPSDIR=/Users/macosuser/bitcoin/deps
+CXX=llvm-g++
+DEPSDIR=/usr/local

 INCLUDEPATHS= \
  -I"$(DEPSDIR)/include"
@@ -14,22 +14,20 @@ INCLUDEPATHS= \
 LIBPATHS= \
  -L"$(DEPSDIR)/lib"

-WXLIBS=$(shell $(DEPSDIR)/bin/wx-config --libs --static)
-
 LIBS= -dead_strip \
- $(DEPSDIR)/lib/libdb_cxx-4.8.a \
- $(DEPSDIR)/lib/libboost_system.a \
- $(DEPSDIR)/lib/libboost_filesystem.a \
- $(DEPSDIR)/lib/libboost_program_options.a \
- $(DEPSDIR)/lib/libboost_thread.a \
- $(DEPSDIR)/lib/libssl.a \
- $(DEPSDIR)/lib/libcrypto.a 
+ -ldb_cxx-4.8 \
+ -lboost_system-mt \
+ -lboost_filesystem-mt \
+ -lboost_program_options-mt \
+ -lboost_thread-mt \
+ -lssl \
+ -lcrypto 

-DEFS=$(shell $(DEPSDIR)/bin/wx-config --cxxflags) -D__WXMAC_OSX__ -DNOPCH -DMSG_NOSIGNAL=0 -DUSE_SSL
+DEFS= -D__WXMAC_OSX__ -DNOPCH -DMSG_NOSIGNAL=0 -DUSE_SSL

 DEBUGFLAGS=-g -DwxDEBUG_LEVEL=0
 # ppc doesn't work because we don't support big-endian
-CFLAGS=-mmacosx-version-min=10.5 -arch i386 -arch x86_64 -O3 -Wno-invalid-offsetof -Wformat $(DEBUGFLAGS) $(DEFS) $(INCLUDEPATHS)
+CFLAGS=-mmacosx-version-min=10.6 -arch x86_64 -O3 -Wno-invalid-offsetof -Wformat $(DEBUGFLAGS) $(DEFS) $(INCLUDEPATHS)
 HEADERS=headers.h strlcpy.h serialize.h uint256.h util.h key.h bignum.h base58.h \
     script.h db.h net.h irc.h main.h rpc.h uibase.h ui.h noui.h init.h
