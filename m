X-Greylist: delayed 1797 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 03 Dec 2023 06:40:27 PST
Received: from delta.arachsys.com (delta.arachsys.com [91.203.57.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A1E7FE
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Dec 2023 06:40:27 -0800 (PST)
Received: from [127.0.0.1] (helo=localhost.localdomain)
	by delta.arachsys.com with esmtp (Exim 4.80)
	(envelope-from <richard@arachsys.com>)
	id 1r9nAz-0002P0-0F; Sun, 03 Dec 2023 14:10:29 +0000
From: Richard Davies <richard@arachsys.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org
Subject: [PATCH v2] bcachefs: Remove obsolete comment about zstd
Date: Sun,  3 Dec 2023 14:10:27 +0000
Message-Id: <1701612627-9182-1-git-send-email-richard@arachsys.com>
X-Mailer: git-send-email 1.7.0.3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>

Remove obsolete comment about zstd, since approach changed during
development of commit bbc3a46065d08f9ab3412b1f26bbfa778c444833

Signed-off-by: Richard Davies <richard@arachsys.com>
---
 fs/bcachefs/compress.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index 51af8ea..33df8cf 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -572,10 +572,6 @@ static int __bch2_fs_compress_init(struct bch_fs *c, u64 features)
 	ZSTD_parameters params = zstd_get_params(zstd_max_clevel(),
 						 c->opts.encoded_extent_max);
 
-	/*
-	 * ZSTD is lying: if we allocate the size of the workspace it says it
-	 * requires, it returns memory allocation errors
-	 */
 	c->zstd_workspace_size = zstd_cctx_workspace_bound(&params.cParams);
 
 	struct {
-- 
1.7.0.3

