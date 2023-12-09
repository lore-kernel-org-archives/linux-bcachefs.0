Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id C218AD1
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Dec 2023 06:31:40 -0800 (PST)
Received: from chris by delta.arachsys.com with local (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rByMm-0004Qm-5n
	for linux-bcachefs@vger.kernel.org; Sat, 09 Dec 2023 14:31:40 +0000
Date: Sat, 9 Dec 2023 14:31:40 +0000
From: Chris Webb <chris@arachsys.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs-tools: Disable -Wgnu-variable-sized-type-not-at-end
 for clang
Message-ID: <0625843a8474c4534cc9b34004c6150219f92a2c.1702132174.git.chris@arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

clang's default warnings include -Wgnu-variable-sized-type-not-at-end,
producing a lot of false alarms about the GNU extension for libbcachefs.
Disable these using cc-disable-warning when building with clang.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 177ee45..5693c0e 100644
--- a/Makefile
+++ b/Makefile
@@ -59,6 +59,7 @@ CFLAGS+=$(call cc-disable-warning, missing-braces)
 CFLAGS+=$(call cc-disable-warning, zero-length-array)
 CFLAGS+=$(call cc-disable-warning, shift-overflow)
 CFLAGS+=$(call cc-disable-warning, enum-conversion)
+CFLAGS+=$(call cc-disable-warning, gnu-variable-sized-type-not-at-end)
 
 PKGCONFIG_LIBS="blkid uuid liburcu libsodium zlib liblz4 libzstd libudev libkeyutils udev"
 ifdef BCACHEFS_FUSE
