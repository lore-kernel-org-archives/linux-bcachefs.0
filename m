Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF9071705
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Dec 2023 04:50:31 -0800 (PST)
Received: from chris by delta.arachsys.com with local (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rBwmt-0001it-AR
	for linux-bcachefs@vger.kernel.org; Sat, 09 Dec 2023 12:50:31 +0000
Date: Sat, 9 Dec 2023 12:50:31 +0000
From: Chris Webb <chris@arachsys.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH 2/2] bcachefs-tools: Avoid glibc-specific mallinfo() in
 shrinker
Message-ID: <a954a56e0923e067d646f584fc3838bdeae9e2d7.1702125906.git.chris@arachsys.com>
References: <2d7abd52206065d763691b082e089811e1e2b962.1702125906.git.chris@arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d7abd52206065d763691b082e089811e1e2b962.1702125906.git.chris@arachsys.com>

Before 326d7c1, the shrinker used freeram and totalram from a struct
sysinfo (constructed from /proc/meminfo) to target 25% free physical
memory. As well as the slowness of repeatedly reading /proc/meminfo,
this was a problem as freeram rises when the system starts to swap.
We don't want swapping to reduce our estimate of memory pressure.

To work around this, in 326d7c1 the shrinker started to use the total
allocated heap from a glibc-specific interface mallinfo2(), aiming to
shrink such that our heap is less than 80% of physical memory, unless
overall free memory is less than 6% so that becomes the determining factor.

Unfortunately, a sign error in the calculation means this heuristic
never worked. It would shrink aggressively when the process was small,
and not at all when the process grew beyond 80% of physical RAM. Only the
fallback test ensuring the free physical RAM doesn't fall below 6% would
actually kick in under memory pressure. It also breaks portability to
anything other than recent glibc.

Later, in 2440469 the mallinfo2() was replaced with the older mallinfo()
to improve compatibility with older glibc. This is even more problematic:
it's still not portable but also struct mallinfo has (signed) int fields
which overflow for large processes on 32-bit machines with a 3G/1G split.

Rather than trying to use libc-specific debug interfaces and our own heap
to inform the shrinker, use the information about free and total swap
we already have from sysinfo(2) to explicitly compensate for swapping
in our estimate of free physical memory. Target free memory of 6% of
physical RAM adjusted for zero swap use when calculating the pressure
on the shrinker, based on the effective behaviour of 326d7c1 in practice
given the sign error.

As well as fixing portability to non-glibc systems, this loosens the
assumption that we are the only process using significant memory when
setting the shrinker target. It wouldn't be unreasonable to run two
fsck jobs against independent devices on a large RAM machine and want to
balance physical RAM between them.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 linux/shrinker.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/linux/shrinker.c b/linux/shrinker.c
index 7658fb7..8a24565 100644
--- a/linux/shrinker.c
+++ b/linux/shrinker.c
@@ -54,7 +54,6 @@ void run_shrinkers(gfp_t gfp_mask, bool allocation_failed)
 {
 	struct shrinker *shrinker;
 	struct sysinfo info;
-	struct mallinfo malloc_info = mallinfo();
 	s64 want_shrink;
 
 	if (!(gfp_mask & GFP_KERNEL))
@@ -71,16 +70,11 @@ void run_shrinkers(gfp_t gfp_mask, bool allocation_failed)
 
 	si_meminfo(&info);
 
-	if (info.totalram && info.totalram >> 4 < info.freeram) {
-		/* freeram goes up when system swaps, use malloced data instead */
-		want_shrink = -malloc_info.arena + (info.totalram / 10 * 8);
-
-		if (want_shrink <= 0)
-			return;
-	} else {
-		/* We want to play nice with other apps keep 6% avaliable, free 3% */
-		want_shrink = (info.totalram >> 5);
-	}
+	/* Aim for 6% of physical RAM free without anything in swap */
+	want_shrink = (info.totalram << 4) - info.freeram
+			+ info.totalswap - info.freeswap;
+	if (want_shrink <= 0)
+		return;
 
 	mutex_lock(&shrinker_lock);
 	list_for_each_entry(shrinker, &shrinker_list, list) {
