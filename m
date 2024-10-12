Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3506012C549
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 21:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728767253; cv=none; b=VMsEv/HE1iKeSbunzwd97iq6AlZP3CZkelLfcemW1FBCKZ1omMSNtOTk00tMoPADoQSBi8FIJzV7HSJ0ayNRSOKJdg58gL4QijgFtph+c1qRnemzLRbmxTojsoQa8yddjD58aCpkSihUIbGlqZjbHa2FsdqRIC6gGGdS8U7CQLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728767253; c=relaxed/simple;
	bh=UtVnfU+KdFslMD+tuI5H+FDL9UnHaONLddyphp54BTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kxJ5uEeoIbZ41CzpK7e7UhZ6b2adzJjlfyBCkKQ87Ho+LsGAhQ3ZOB5J/5v+DexUpHJIt1V6Xfc4XP0+EInb15RZOh7YRLgBHucEb3ShCiKwVMvGSPlZciRcbpibdZwAdBKu7fxSbbHeycWynj+T019IhmN6ICZDYguMsDoeDrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kxkg39jo; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kxkg39jo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728767249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9X+oHEPK1NCptoPbNjP50kwyKt/DdHE/RJbOfqWKl5w=;
	b=Kxkg39joP82tDUmSy6F1RQHscPp222h3NNBwTIC4w8UmgknDpJrxqUOBFETkgGbJvW1aiO
	j+rm/gbWONyxm9tKBNEkZvzb0MvrlEB20n/GTbaLZL7GsNInmIsWwTKNN5SZk7P8v1DwZs
	y+EP+RN5WmzXUvqlNkqCWC4VhxL/2VI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Add missing validation for bch_stripe.csum_granularity_bits
Date: Sat, 12 Oct 2024 17:07:21 -0400
Message-ID: <20241012210721.3913529-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/ec.c               | 11 ++++++++++-
 fs/bcachefs/sb-errors_format.h |  3 ++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 564841e5a24b..411b6d6a70d0 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -124,6 +124,11 @@ int bch2_stripe_validate(struct bch_fs *c, struct bkey_s_c k,
 			 "incorrect value size (%zu < %u)",
 			 bkey_val_u64s(k.k), stripe_val_u64s(s));
 
+	bkey_fsck_err_on(s->csum_granularity_bits >= 64,
+			 c, stripe_csum_granularity_bad,
+			 "invalid csum granularity (%u >= 64)",
+			 s->csum_granularity_bits);
+
 	ret = bch2_bkey_ptrs_validate(c, k, flags);
 fsck_err:
 	return ret;
@@ -145,7 +150,11 @@ void bch2_stripe_to_text(struct printbuf *out, struct bch_fs *c,
 		   nr_data,
 		   s.nr_redundant);
 	bch2_prt_csum_type(out, s.csum_type);
-	prt_printf(out, " gran %u", 1U << s.csum_granularity_bits);
+	prt_str(out, " gran ");
+	if (s.csum_granularity_bits < 64)
+		prt_printf(out, "%llu", 1ULL << s.csum_granularity_bits);
+	else
+		prt_printf(out, "(invalid shift %u)", s.csum_granularity_bits);
 
 	if (s.disk_label) {
 		prt_str(out, " label");
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 62ad25f91b78..aab328ac6dfa 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -180,6 +180,7 @@ enum bch_fsck_flags {
 	x(reflink_p_to_missing_reflink_v,			166,	0)		\
 	x(stripe_pos_bad,					167,	0)		\
 	x(stripe_val_size_bad,					168,	0)		\
+	x(stripe_csum_granularity_bad,				290,	0)		\
 	x(stripe_sector_count_wrong,				169,	0)		\
 	x(snapshot_tree_pos_bad,				170,	0)		\
 	x(snapshot_tree_to_missing_snapshot,			171,	0)		\
@@ -301,7 +302,7 @@ enum bch_fsck_flags {
 	x(accounting_key_replicas_devs_unsorted,		280,	FSCK_AUTOFIX)	\
 	x(accounting_key_version_0,				282,	FSCK_AUTOFIX)	\
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
-	x(MAX,							290,	0)
+	x(MAX,							291,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.45.2

