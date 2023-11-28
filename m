Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F2D41C67;
	Tue, 28 Nov 2023 18:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CI/yy0Um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A02C433C8;
	Tue, 28 Nov 2023 18:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701195778;
	bh=cmXLCB6F0Jpxz1dOg+AMECgAoHmZ4123tddCyGivbbE=;
	h=Date:From:To:Cc:Subject:From;
	b=CI/yy0Umi/PpzvRt1FlzsEM7nnYvzJwqE3X5Im7HmTJPnRHmYCTu0qONSLZUIPjxz
	 J5F3P6b0AlI5jyvlE2NiIVMHqRXZQwCj/j5JWL8rk2GAv5FugU/wU2EzqPrkqth0l4
	 yOxmslgztj+TA7ToNy4NQURj1YZZVKLKTpq6VbgRpFxBUz8Hv1xC0CAlN1/0Tacsxs
	 FLtFehfOUXF3Pz0Lcutrq2hjsyifyOdE6rn+OWTjD7hE2JBbG/V5sl8SDKgK4xKdw0
	 k671ZdXQY73LErhZ22jaDgyYdY9XU7FyYalV5va1aE4UbOrezjSC3izJnDSijy9mJ9
	 pfJkPvZmLQzJg==
Date: Tue, 28 Nov 2023 12:22:55 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] bcachefs: Replace zero-length arrays with
 flexible-array members
Message-ID: <ZWYv/ywR/qxUhVSU@work>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Fake flexible arrays (zero-length and one-element arrays) are
deprecated, and should be replaced by flexible-array members.

So, replace zero-length arrays with flexible-array members
in multiple structures.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/bcachefs/bcachefs_ioctl.h | 4 ++--
 fs/bcachefs/io_read.c        | 2 +-
 fs/bcachefs/move.c           | 2 +-
 fs/bcachefs/replicas_types.h | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
index 44ba7a87aea7..43822c17297c 100644
--- a/fs/bcachefs/bcachefs_ioctl.h
+++ b/fs/bcachefs/bcachefs_ioctl.h
@@ -276,7 +276,7 @@ struct bch_ioctl_fs_usage {
 	__u32			replica_entries_bytes;
 	__u32			pad;
 
-	struct bch_replicas_usage replicas[0];
+	struct bch_replicas_usage replicas[];
 };
 
 /*
@@ -313,7 +313,7 @@ struct bch_ioctl_dev_usage_v2 {
 	__u32			bucket_size;
 	__u64			nr_buckets;
 
-	struct bch_ioctl_dev_usage_type  d[0];
+	struct bch_ioctl_dev_usage_type d[];
 };
 
 /*
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 3281c4dd1d52..4c9eaf7cea8d 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -80,7 +80,7 @@ struct promote_op {
 	struct bpos		pos;
 
 	struct data_update	write;
-	struct bio_vec		bi_inline_vecs[0]; /* must be last */
+	struct bio_vec		bi_inline_vecs[]; /* must be last */
 };
 
 static const struct rhashtable_params bch_promote_params = {
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index c5518a866276..5a693c3e2ed2 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -81,7 +81,7 @@ struct moving_io {
 
 	struct data_update		write;
 	/* Must be last since it is variable size */
-	struct bio_vec			bi_inline_vecs[0];
+	struct bio_vec			bi_inline_vecs[];
 };
 
 static void move_free(struct moving_io *io)
diff --git a/fs/bcachefs/replicas_types.h b/fs/bcachefs/replicas_types.h
index 030324078bba..ac90d142c4e8 100644
--- a/fs/bcachefs/replicas_types.h
+++ b/fs/bcachefs/replicas_types.h
@@ -21,7 +21,7 @@ struct replicas_delta_list {
 	u64			nr_inodes;
 	u64			persistent_reserved[BCH_REPLICAS_MAX];
 	struct			{} memset_end;
-	struct replicas_delta	d[0];
+	struct replicas_delta	d[];
 };
 
 #endif /* _BCACHEFS_REPLICAS_TYPES_H */
-- 
2.34.1

