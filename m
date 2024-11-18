Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AB517FE
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731894315; cv=none; b=brRtlSmiBdzuInfxfYV/G4i1OEkH4vdoFnYnnWzKnhCfQqySqU2nVszJFXYbPazRw4CHFMplIiCOgpbwGX8yZMOlmcttPnXCRrAZjjt/bRJKYlJPNzATEc8BrOuEBRMM2+XEBO4cVBm1nZAqRG9Kn1lUVL+HKVatdMWmc76KgX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731894315; c=relaxed/simple;
	bh=aZa4fSJ2PuyASDu+5J0vx4sc5qFncBbf0LyTCIkEnik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yja6UNDz+GU/3EL0b5JtaSboKLtO9OBXkp82ajKssvAVRzLBwjBTYuk6Sjew8bO3S0dguI3/MdmxmWSDHd5Y95nNSst7wa96qmMMN/J1jQSCegQMl5lfBHEF77C1D84CKUhX/AGQr8o+rfkbrYgUvsJvRvU+rZoG/+fGp4/BUOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vai7XjTk; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vai7XjTk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731894311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Qjy2/UbgJw3HFFuGcIkmB25lBTCfgDV/llRQ9Wfyio=;
	b=vai7XjTkOciKj/TiCUw0RsaLSWF6O5qAgHTIh8daveZPJsIkRrI3nJf40gbtBdFfk+bQZP
	igowxLJR1k9XwtnhobmOsTASrwGuq4590S6e1wKrkBM1Ch52mn4SY418BW6XsIRcreBoIR
	8izTnOCkNj0bHAB9v/Knnl/yDu+QYf8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/7] bcachefs: kill bch_backpointer.bucket_offset usage
Date: Sun, 17 Nov 2024 20:44:46 -0500
Message-ID: <20241118014451.2275941-6-kent.overstreet@linux.dev>
In-Reply-To: <20241118014451.2275941-1-kent.overstreet@linux.dev>
References: <20241118014451.2275941-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bch_backpointer.bucket_offset is going away - it's no longer needed
since we no longer store backpointers in alloc keys, the same
information is in the key position itself.

And we'll be reclaiming the space in bch_backpointer for the bucket
generation number.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 15 +++++++--------
 fs/bcachefs/backpointers.h |  8 ++++++++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index d5f17767a72c..bd14900773d2 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -50,21 +50,20 @@ void bch2_backpointer_to_text(struct printbuf *out, struct bch_fs *c, struct bke
 	struct bkey_s_c_backpointer bp = bkey_s_c_to_backpointer(k);
 
 	rcu_read_lock();
-	struct bch_dev *ca = bch2_dev_rcu_noerror(c, k.k->p.inode);
+	struct bch_dev *ca = bch2_dev_rcu_noerror(c, bp.k->p.inode);
 	if (ca) {
-		struct bpos bucket = bp_pos_to_bucket(ca, k.k->p);
+		u32 bucket_offset;
+		struct bpos bucket = bp_pos_to_bucket_and_offset(ca, bp.k->p, &bucket_offset);
 		rcu_read_unlock();
-		prt_str(out, "bucket=");
-		bch2_bpos_to_text(out, bucket);
-		prt_str(out, " ");
+		prt_printf(out, "bucket=%llu:%llu:%u", bucket.inode, bucket.offset, bucket_offset);
 	} else {
 		rcu_read_unlock();
+		prt_printf(out, "sector=%llu:%llu", bp.k->p.inode, bp.k->p.offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT);
 	}
 
 	bch2_btree_id_level_to_text(out, bp.v->btree_id, bp.v->level);
-	prt_printf(out, " offset=%llu:%u len=%u pos=",
-		   (u64) (bp.v->bucket_offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT),
-		   (u32) bp.v->bucket_offset & ~(~0U << MAX_EXTENT_COMPRESS_RATIO_SHIFT),
+	prt_printf(out, " suboffset=%u len=%u pos=",
+		   (u32) bp.k->p.offset & ~(~0U << MAX_EXTENT_COMPRESS_RATIO_SHIFT),
 		   bp.v->bucket_len);
 	bch2_bpos_to_text(out, bp.v->pos);
 }
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index 5f34a25b599a..d8a15f5fa767 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -42,6 +42,14 @@ static inline struct bpos bp_pos_to_bucket(const struct bch_dev *ca, struct bpos
 	return POS(bp_pos.inode, sector_to_bucket(ca, bucket_sector));
 }
 
+static inline struct bpos bp_pos_to_bucket_and_offset(const struct bch_dev *ca, struct bpos bp_pos,
+						      u32 *bucket_offset)
+{
+	u64 bucket_sector = bp_pos.offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT;
+
+	return POS(bp_pos.inode, sector_to_bucket_and_offset(ca, bucket_sector, bucket_offset));
+}
+
 static inline bool bp_pos_to_bucket_nodev_noerror(struct bch_fs *c, struct bpos bp_pos, struct bpos *bucket)
 {
 	rcu_read_lock();
-- 
2.45.2

