Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id C107F10D0
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Dec 2023 04:49:14 -0800 (PST)
Received: from chris by delta.arachsys.com with local (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rBwlc-0001fs-MT
	for linux-bcachefs@vger.kernel.org; Sat, 09 Dec 2023 12:49:12 +0000
Date: Sat, 9 Dec 2023 12:49:12 +0000
From: Chris Webb <chris@arachsys.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH 1/2] bcachefs-tools: Use sysinfo(2) directly to implement
 si_meminfo()
Message-ID: <2d7abd52206065d763691b082e089811e1e2b962.1702125906.git.chris@arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use a single sysinfo(2) call to fill out struct sysinfo instead of
multiple libc sysconf(3) requests, which will only make sysinfo(2) calls
internally anyway. This also enables us to access other struct sysinfo
fields, not just the three filled-out previously.

As we provide our own definition of struct sysinfo in include/linux/mm.h
to match the kernel, which is not guaranteed to align with the definition
libc provides in <sys/sysinfo.h>, use syscall(SYS_sysinfo, ...) directly
instead of the libc wrapper.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 include/linux/mm.h |  8 +++++++-
 linux/shrinker.c   | 15 ---------------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4bf80ba..744a14c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2,6 +2,7 @@
 #ifndef _TOOLS_LINUX_MM_H
 #define _TOOLS_LINUX_MM_H
 
+#include <sys/syscall.h>
 #include <linux/types.h>
 
 struct sysinfo {
@@ -20,6 +21,11 @@ struct sysinfo {
 	__u32 mem_unit;			/* Memory unit size in bytes */
 };
 
-extern void si_meminfo(struct sysinfo * val);
+
+
+static inline void si_meminfo(struct sysinfo *val)
+{
+	BUG_ON(syscall(SYS_sysinfo, val));
+}
 
 #endif /* _TOOLS_LINUX_MM_H */
diff --git a/linux/shrinker.c b/linux/shrinker.c
index 91f633b..7658fb7 100644
--- a/linux/shrinker.c
+++ b/linux/shrinker.c
@@ -33,21 +33,6 @@ void unregister_shrinker(struct shrinker *shrinker)
 	mutex_unlock(&shrinker_lock);
 }
 
-struct meminfo {
-	u64		total;
-	u64		available;
-};
-
-void si_meminfo(struct sysinfo *val)
-{
-	long page_size = sysconf(_SC_PAGESIZE);
-	memset(val, 0, sizeof(*val));
-	val->mem_unit = 1;
-
-	val->totalram = sysconf(_SC_PHYS_PAGES) * page_size;
-	val->freeram  = sysconf(_SC_AVPHYS_PAGES) * page_size;
-}
-
 static void run_shrinkers_allocation_failed(gfp_t gfp_mask)
 {
 	struct shrinker *shrinker;
