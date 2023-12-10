Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C7C9D9
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Dec 2023 23:28:33 -0800 (PST)
Received: from chris by delta.arachsys.com with local (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rCEEp-00045k-In
	for linux-bcachefs@vger.kernel.org; Sun, 10 Dec 2023 07:28:31 +0000
Date: Sun, 10 Dec 2023 07:28:31 +0000
From: Chris Webb <chris@arachsys.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs-tools: Fix typo in 872cd43
Message-ID: <e41d28947a1c8bee337af2c88411af0b21b76d84.1702192975.git.chris@arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

6% of physical RAM is info.totalram >> 4 not info.totalram << 4.

Signed-off-by: Chris Webb <chris@arachsys.com>
---

Sorry Kent, I'm afraid I didn't spot this embarrassing typo until
after I'd sent the original patch to the list!

 linux/shrinker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/linux/shrinker.c b/linux/shrinker.c
index 8a24565..8806976 100644
--- a/linux/shrinker.c
+++ b/linux/shrinker.c
@@ -71,7 +71,7 @@ void run_shrinkers(gfp_t gfp_mask, bool allocation_failed)
 	si_meminfo(&info);
 
 	/* Aim for 6% of physical RAM free without anything in swap */
-	want_shrink = (info.totalram << 4) - info.freeram
+	want_shrink = (info.totalram >> 4) - info.freeram
 			+ info.totalswap - info.freeswap;
 	if (want_shrink <= 0)
 		return;
