Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C0113FEE;
	Wed, 30 Apr 2025 19:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746040925; cv=none; b=QDEaGh487nv9MFYPRILFmEfaiHE5/daK5zmNlnpWz8tw6NifMzPQDNRDUGfbdA6NWeglFzO6q+KNnJak90Yn9818TImW1cHjL9J8ylzCUxymmE8FziyE+ku0Y63mvufMMMNLukOAdKDjfSeeiwF3Wd45sKWDOUoma8sXHreNjZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746040925; c=relaxed/simple;
	bh=YnTUDOH754pyg5CnYeSKoG0Rnpk8PAiwR8OZw83lcZU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ca4WEo3TsHoM3+Gp0Oc+vIEFpjBeTmCnmECRwiudMEdLbZhFyxPeG/y8m8xwew0yn5i0RdGovplmNrUPDe63guXsxd9QVHJqRULd/0Fb0CQccaTKh7UWYOIzgVtGMQXB67B9ZrbUaMey57x4aks5xOVq40ln36cXG1HoBhgIERQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/7Yt/GW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/7Yt/GW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0CBC4CEE7;
	Wed, 30 Apr 2025 19:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746040924;
	bh=YnTUDOH754pyg5CnYeSKoG0Rnpk8PAiwR8OZw83lcZU=;
	h=Date:From:To:Cc:Subject:From;
	b=U/7Yt/GW0d5lbiHz/ZYcv7bp9irYk96FjgG6rPrFQ5wVYNPwlshQECrk3GDVau5uO
	 YCsFmyP+n0jtfvXQC3kkPPfJAdOhnG4VwFWEU9bmQWFCzzls/6Zd5+38o8aeU8CdB0
	 29mmmT4PT1HDjER4EM3vK5YOJK5hYF6PE/d3OO6Cb05KHNwiCnjduGHGOu9/SUN38n
	 ydt4eRy/gWXRBYZzasn1lMsvUhYKHxhFa5l8itZbED5xTsMV1HaOhkul2gYzEhYXac
	 W7unjFix0ix9kv/kpzvb7ONQyyrDIyDNoaDeI+qIMac6xgC35b465pAeqXOxVfmBLu
	 Y50xWajN1Fz+w==
Date: Wed, 30 Apr 2025 13:22:01 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2][next] bcachefs: Avoid -Wflex-array-member-not-at-end
 warnings
Message-ID: <aBJ4WVcvHv9sD1K6@kspp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Refactor a couple of structs that contain flexible arrays in the
middle by replacing them with unions.

So, with these changes, fix the following warnings:

fs/bcachefs/disk_accounting.c:429:51: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
fs/bcachefs/ec_types.h:8:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Use a union instead of DEFINE_FLEX().
 - Address an additional -Wflex-array-member-not-at-end warning.

v1:
 - Link: https://lore.kernel.org/linux-hardening/aBF5udHEHwWvmWJw@kspp/

 fs/bcachefs/disk_accounting.c | 12 +++++++-----
 fs/bcachefs/ec_types.h        |  7 ++++---
 fs/bcachefs/journal_io.c      |  6 +++---
 fs/bcachefs/journal_reclaim.c |  2 +-
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index 7be71952425c..2dcccf1edbb9 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -287,7 +287,7 @@ static inline bool accounting_to_replicas(struct bch_replicas_entry_v1 *r, struc
 
 static int bch2_accounting_update_sb_one(struct bch_fs *c, struct bpos p)
 {
-	struct bch_replicas_padded r;
+	union bch_replicas_padded r;
 	return accounting_to_replicas(&r.e, p)
 		? bch2_mark_replicas(c, &r.e)
 		: 0;
@@ -361,7 +361,7 @@ static int __bch2_accounting_mem_insert(struct bch_fs *c, struct bkey_s_c_accoun
 int bch2_accounting_mem_insert(struct bch_fs *c, struct bkey_s_c_accounting a,
 			       enum bch_accounting_mode mode)
 {
-	struct bch_replicas_padded r;
+	union bch_replicas_padded r;
 
 	if (mode != BCH_ACCOUNTING_read &&
 	    accounting_to_replicas(&r.e, a.k->p) &&
@@ -425,10 +425,12 @@ int bch2_fs_replicas_usage_read(struct bch_fs *c, darray_char *usage)
 
 	percpu_down_read(&c->mark_lock);
 	darray_for_each(acc->k, i) {
-		struct {
+		union {
+			u8 bytes[struct_size_t(struct bch_replicas_usage, r.devs,
+					       BCH_BKEY_PTRS_MAX)];
 			struct bch_replicas_usage r;
-			u8 pad[BCH_BKEY_PTRS_MAX];
 		} u;
+		u.r.r.nr_devs = BCH_BKEY_PTRS_MAX;
 
 		if (!accounting_to_replicas(&u.r.r, i->pos))
 			continue;
@@ -627,7 +629,7 @@ static int bch2_disk_accounting_validate_late(struct btree_trans *trans,
 
 	switch (acc->type) {
 	case BCH_DISK_ACCOUNTING_replicas: {
-		struct bch_replicas_padded r;
+		union bch_replicas_padded r;
 		__accounting_to_replicas(&r.e, acc);
 
 		for (unsigned i = 0; i < r.e.nr_devs; i++)
diff --git a/fs/bcachefs/ec_types.h b/fs/bcachefs/ec_types.h
index 06144bfd9c19..809446c78951 100644
--- a/fs/bcachefs/ec_types.h
+++ b/fs/bcachefs/ec_types.h
@@ -4,9 +4,10 @@
 
 #include "bcachefs_format.h"
 
-struct bch_replicas_padded {
+union bch_replicas_padded {
+	u8				bytes[struct_size_t(struct bch_replicas_entry_v1,
+							    devs, BCH_BKEY_PTRS_MAX)];
 	struct bch_replicas_entry_v1	e;
-	u8				pad[BCH_BKEY_PTRS_MAX];
 };
 
 struct stripe {
@@ -28,7 +29,7 @@ struct gc_stripe {
 	u16			block_sectors[BCH_BKEY_PTRS_MAX];
 	struct bch_extent_ptr	ptrs[BCH_BKEY_PTRS_MAX];
 
-	struct bch_replicas_padded r;
+	union bch_replicas_padded r;
 };
 
 #endif /* _BCACHEFS_EC_TYPES_H */
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 58e3983d860a..7c09a3c109ab 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1404,7 +1404,7 @@ int bch2_journal_read(struct bch_fs *c,
 	}
 
 	genradix_for_each(&c->journal_entries, radix_iter, _i) {
-		struct bch_replicas_padded replicas = {
+		union bch_replicas_padded replicas = {
 			.e.data_type = BCH_DATA_journal,
 			.e.nr_devs = 0,
 			.e.nr_required = 1,
@@ -1632,7 +1632,7 @@ static CLOSURE_CALLBACK(journal_write_done)
 	closure_type(w, struct journal_buf, io);
 	struct journal *j = container_of(w, struct journal, buf[w->idx]);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
-	struct bch_replicas_padded replicas;
+	union bch_replicas_padded replicas;
 	u64 seq = le64_to_cpu(w->data->seq);
 	int err = 0;
 
@@ -2055,7 +2055,7 @@ CLOSURE_CALLBACK(bch2_journal_write)
 	closure_type(w, struct journal_buf, io);
 	struct journal *j = container_of(w, struct journal, buf[w->idx]);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
-	struct bch_replicas_padded replicas;
+	union bch_replicas_padded replicas;
 	unsigned nr_rw_members = dev_mask_nr(&c->rw_devs[BCH_DATA_journal]);
 	int ret;
 
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 66bfb95f1ea4..0acaf20f2181 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -953,7 +953,7 @@ int bch2_journal_flush_device_pins(struct journal *j, int dev_idx)
 	seq = 0;
 	spin_lock(&j->lock);
 	while (!ret) {
-		struct bch_replicas_padded replicas;
+		union bch_replicas_padded replicas;
 
 		seq = max(seq, journal_last_seq(j));
 		if (seq >= j->pin.back)
-- 
2.43.0

