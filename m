Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DF62D29DB
	for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 19:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749754986; cv=none; b=EPw4e9C3ckFVMHnBR3KYYhW+RCNewjN0RRfCahqF3FesAuLWhmHhZuBv6l1u4wH2NosK0wNwL3leF3XnUEd0lyig4kPYiNHiU6Dib8DXAi0vQwTrQKFDkOsUr7DbZd1P/TeoXjvlbfyC/lwYmxY2a1gwsoWx482B6hB55PoXDAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749754986; c=relaxed/simple;
	bh=E25hx7WVsLUnc8xFFIwAYXvfW6ssIGhcdCgatchf42o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcA/ksmF+JS7bEDaLBUlNk3+g3DbJeDIsoLqwMvfIQiBmz6XRsh6o2F1Cen3SroavGxR6tj2oHka07zem+wfAJgy5UWAZtJTMoOv+n/esojV051yfd00Jkfya7UIcA/zhaZ9zIXUss6T1Zre9YTPE8FzFCk/i2QWHDLN8E718jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mgXExaSF; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mgXExaSF"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3122368d7cfso1158970a91.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 12:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749754984; x=1750359784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fAcFlmf8WWff+/HDvf9DWqmJBTYqVFHbD4mp8dmfd4c=;
        b=mgXExaSFqnrL8yVhwSi/GBzD4k40Ou/Lfa/bxLaEhUHcC71bqEKzkuQvjBqQGSQamy
         5orG8VjCxoXU4AeybocV6X85rHnEC7F1o9VkfCYIG8bDdsyBJQHkLfSQjWOLJM3WJBGL
         ZslPzQqeI0cg6ddcmrGeLDwfaaCXSUMJPpHR7GDAIJ3md9757bYDUzLGDrG9cbcSjSdQ
         cuu94y8JG+y6kxDblQDFReAAO/QtSx8sWcT2H2HObmFzb1qb/DTF7CJ0ojZ9hgKASkmY
         VCJ47ksMLBwjfRnv1tH7pG8rJrwawfgmgwXaWrMH46rfDX3IHiAGYEtyIQ5+LT7gqab+
         Ce/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749754984; x=1750359784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fAcFlmf8WWff+/HDvf9DWqmJBTYqVFHbD4mp8dmfd4c=;
        b=BCCMjfosE60kbpD2LaRQM1QK1w/AFpBddKcyFAoj0QPPZIXY7XDYj+rSqQCttLG5Sn
         ZH8tfKxjqvOc9ro4NGf+yMvtUTBkEWmPeymswZ5RiBGMSlmSZMAhFexDnu0MB0vCsw7o
         D6QrHmwpEF81MXq0QJKxdnR/oRVP4r+gUj7KnvWSacvCXnnp4uq07J7/IP0d/Me8IZ+I
         a26tm+fpXa8EUN2PQq5qDWM4fPO0nP4kf8iPRogNqlKNmFEkK0qhWRjzwwUaJGfzJ7i/
         4C3AFjkD9UHPtaYRoP4W+MQmhduxwhDDwpsx3NxHEoDufIVM/nuyJBDAMoY8eMke+dKO
         qYlA==
X-Gm-Message-State: AOJu0Ywo4f781Zd+auiuP/L/iAkvBIN3UOVr0koohreGZDPwVaBy2m4b
	qFmx5MmDeVW8OKaNJOJWc8aj4hlP5wSDjLVkZ2Wbl822EOjfVZABBoR4q9BlEw==
X-Gm-Gg: ASbGnctRSxaNuSF+Q9/vFjsQb3OMaXPSH5TFfciO8JpcRNEpKaJp9Hxk4Wj4JJKrGY/
	S3iBihFPOd+k030zKoMa8u6c/dRpJOR+HUpkVUXRE6U0mbFY7KIyQyLR8KkK2tHHULT4xkSWGjt
	4SEM/wPBDRExYtk+5aWXerc4p3wxOU6LAAUgivqswLhHcAtDQOpkSmGJAMswjnOFFbU5C7I6Uji
	sWB6ETEICCE0ecmtQ/d4L0+UdnEPsPIy6aYQbIOvk+SggvsptyI/nJF6UwTRi5AXdc1QW/KWvAe
	Dy0hBmwQL3GYtfLRWQcBSPSa7tNVHxSmDTVvzsCNc29gfoM=
X-Google-Smtp-Source: AGHT+IGt+xfdCeV7SWrA0GWLm24t7GhctmSbDDUqgJ54anyN0VY3OwBpJv+zYdEAHp0WCWCDLG17pQ==
X-Received: by 2002:a17:90b:5484:b0:312:e49b:c972 with SMTP id 98e67ed59e1d1-313d9c611b8mr463004a91.15.1749754983666;
        Thu, 12 Jun 2025 12:03:03 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1bd9a31sm1858472a91.13.2025.06.12.12.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 12:03:03 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 2/2] bcachefs: Delay calculation of trans->journal_u64s
Date: Fri, 13 Jun 2025 03:01:59 +0800
Message-ID: <20250612190159.331909-2-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250612190159.331909-1-mmpgouride@gmail.com>
References: <20250612190159.331909-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When there is commit error that need split btree leaf, fsck might change
the value of trans->journal_entries.u64s, when retry commit, the value of
trans->journal_u64s would be incorrect, which will lead to trans->journal_res.u64s
underflow, and then out of bounds write will occur:

[  464.496970][T11969] Call trace:
[  464.496973][T11969]  show_stack+0x3c/0x88 (C)
[  464.496995][T11969]  dump_stack_lvl+0xf8/0x178
[  464.497014][T11969]  dump_stack+0x20/0x30
[  464.497031][T11969]  __bch2_trans_log_str+0x344/0x350
[  464.497048][T11969]  bch2_trans_log_str+0x3c/0x60
[  464.497065][T11969]  __bch2_fsck_err+0x11bc/0x1390
[  464.497083][T11969]  bch2_check_discard_freespace_key+0xad4/0x10d0
[  464.497100][T11969]  bch2_bucket_alloc_freelist+0x99c/0x1130
[  464.497117][T11969]  bch2_bucket_alloc_trans+0x79c/0xcb8
[  464.497133][T11969]  bch2_bucket_alloc_set_trans+0x378/0xc20
[  464.497151][T11969]  __open_bucket_add_buckets+0x7fc/0x1c00
[  464.497168][T11969]  open_bucket_add_buckets+0x184/0x3a8
[  464.497185][T11969]  bch2_alloc_sectors_start_trans+0xa04/0x1da0
[  464.497203][T11969]  bch2_btree_reserve_get+0x6e0/0xef0
[  464.497220][T11969]  bch2_btree_update_start+0x1618/0x2600
[  464.497239][T11969]  bch2_btree_split_leaf+0xcc/0x730
[  464.497258][T11969]  bch2_trans_commit_error+0x22c/0xc30
[  464.497276][T11969]  __bch2_trans_commit+0x207c/0x4e30
[  464.497292][T11969]  bch2_journal_replay+0x9e0/0x1420
[  464.497305][T11969]  __bch2_run_recovery_passes+0x458/0xf98
[  464.497318][T11969]  bch2_run_recovery_passes+0x280/0x478
[  464.497331][T11969]  bch2_fs_recovery+0x24f0/0x3a28
[  464.497344][T11969]  bch2_fs_start+0xb80/0x1248
[  464.497358][T11969]  bch2_fs_get_tree+0xe94/0x1708
[  464.497377][T11969]  vfs_get_tree+0x84/0x2d0

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_trans_commit.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 55952143f0d3..61107f2310ab 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -1005,6 +1005,7 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 {
 	struct btree_insert_entry *errored_at = NULL;
 	struct bch_fs *c = trans->c;
+	unsigned journal_u64s = 0;
 	int ret = 0;
 
 	bch2_trans_verify_not_unlocked_or_in_restart(trans);
@@ -1033,10 +1034,10 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 
 	EBUG_ON(test_bit(BCH_FS_clean_shutdown, &c->flags));
 
-	trans->journal_u64s		= trans->journal_entries.u64s + jset_u64s(trans->accounting.u64s);
+	journal_u64s = jset_u64s(trans->accounting.u64s);
 	trans->journal_transaction_names = READ_ONCE(c->opts.journal_transaction_names);
 	if (trans->journal_transaction_names)
-		trans->journal_u64s += jset_u64s(JSET_ENTRY_LOG_U64s);
+		journal_u64s += jset_u64s(JSET_ENTRY_LOG_U64s);
 
 	trans_for_each_update(trans, i) {
 		struct btree_path *path = trans->paths + i->path;
@@ -1056,11 +1057,11 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 			continue;
 
 		/* we're going to journal the key being updated: */
-		trans->journal_u64s += jset_u64s(i->k->k.u64s);
+		journal_u64s += jset_u64s(i->k->k.u64s);
 
 		/* and we're also going to log the overwrite: */
 		if (trans->journal_transaction_names)
-			trans->journal_u64s += jset_u64s(i->old_k.u64s);
+			journal_u64s += jset_u64s(i->old_k.u64s);
 	}
 
 	if (trans->extra_disk_res) {
@@ -1078,6 +1079,8 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 		memset(&trans->journal_res, 0, sizeof(trans->journal_res));
 	memset(&trans->fs_usage_delta, 0, sizeof(trans->fs_usage_delta));
 
+	trans->journal_u64s = journal_u64s + trans->journal_entries.u64s;
+
 	ret = do_bch2_trans_commit(trans, flags, &errored_at, _RET_IP_);
 
 	/* make sure we didn't drop or screw up locks: */
-- 
2.48.1

