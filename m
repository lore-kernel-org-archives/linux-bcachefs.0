X-Greylist: delayed 1672 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 03 Dec 2023 04:27:45 PST
Received: from delta.arachsys.com (delta.arachsys.com [91.203.57.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 434B79C
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Dec 2023 04:27:45 -0800 (PST)
Received: from richard by delta.arachsys.com with local (Exim 4.80)
	(envelope-from <richard@daviesmail.org>)
	id 1r9l8a-0007iG-9e; Sun, 03 Dec 2023 11:59:52 +0000
Date: Sun, 3 Dec 2023 11:59:52 +0000
From: Richard Davies <richard@arachsys.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Remove obsolete comment about zstd
Message-ID: <ZWxtuIL8nbIHQ3bw@delta.arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Remove obsolete comment about zstd, since approach changed during development 
of commit bbc3a46065d08f9ab3412b1f26bbfa778c444833

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
