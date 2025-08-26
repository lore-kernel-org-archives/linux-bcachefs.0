Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7936226A09F
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248607; cv=none; b=JrF0Qc/Ih0ym9Xd7u1SZTJU5GZA5wa+WpZxUsbhC9W/fhi9a9futahw8Co1YAAIYGd8CbLN1nGX9u5G3MODOS1DWtH2tS/Ak2xWK4K67qK/z/jssPyaGGJ9azvMFgfOC03OFMOyHHj2Y6JwBSIaKSukZgy6UnTcPmmOKLVtX8hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248607; c=relaxed/simple;
	bh=H/JZyEM7sUvuSQwIOqhY90ar1j9qQALvqhR7e0DrN40=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BDwdbb9Ygsdd/ZTW2TkB67FXsrYTErrAVN0J9byRZMxFj8psSIZJ8IH7D89yDtfvTHvwzxcS6sjjV2Ij4JFic9X783AkQuZXDIOfLmWjVI48elLlX8BM46hvi+G9KZYB0QVg/LiGzZ10UzgY2Tffo96dxvkll9C/BrB8FxUuBtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=abOOKqS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="abOOKqS0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35827C4CEF4;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756248607;
	bh=H/JZyEM7sUvuSQwIOqhY90ar1j9qQALvqhR7e0DrN40=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=abOOKqS0LTl5kIaQ6//PBRYnDn0BKxBcFB6JjaCiO+re599ijO3oWgnKv7FhTWqQU
	 xdWv2LStOtt0OAGaKXIbGca9NV52OpRsgZN2Uuaq8Sb1uLjr3S7wYJbK3Ptk8DNvty
	 lqIqvp5CtVMNiGe4mhUaQqXBO74uCwyaol/LcWcFXb8TcHX9rj1ZRsbYQT5aguIMjz
	 29tCAFMScihcHi2r7YzIoLd16vchL/4EZ71Hipu0/FPiIEND/eBbYFFfzggeIU4BnW
	 IrJQVtFTJd/xRPPhhBmhDYXd0yW00V+vOyOynsjKaU56rgVVRaDIt4KLfkrMq0hw8g
	 KeUYKP2/0NopA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0C7CA0FFA;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Wed, 27 Aug 2025 01:49:09 +0300
Subject: [PATCH 03/12] bcachefs: Use explicit node counts in progress
 reporting
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-better-progress-v1-3-74c24de7988a@gmail.com>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1732; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=p6ZQ5qb7up5dXkybwqOQgIZGEK+4x+O9wYQQdfMd+mU=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSss5LZUs6wPPuQ5POzZ7u2+EhtODnb3IXLPsMm5Sert
 YLZc36ujlIWBjEuBlkxRZYPS77+WZNp/cdSaK8hzBxWJpAhDFycAjCR1S8ZGSZIrZha53zzfN3s
 w49CZLaePSt9+NBUTy09y+dxX0UdT59n+KfenT/rr8OFpvoDik84LxxssTgm84WxXrbi5rVpiV0
 8Z1gA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Also consider the metadata_replicas option when better
accounting is not available.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/progress.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/progress.c b/fs/bcachefs/progress.c
index 792fc6fef27018c73168c59857e7f3497c1969f4..3ad4e1f6f653c8c75205efdd6d72560b8dda4c51 100644
--- a/fs/bcachefs/progress.c
+++ b/fs/bcachefs/progress.c
@@ -12,6 +12,10 @@ void bch2_progress_init(struct progress_indicator_state *s,
 
 	s->next_print = jiffies + HZ * 10;
 
+	/* This is only an estimation: nodes can have different replica counts */
+	const u32 expected_node_disk_sectors =
+		READ_ONCE(c->opts.metadata_replicas) * btree_sectors(c);
+
 	for (unsigned i = 0; i < BTREE_ID_NR; i++) {
 		if (!(btree_id_mask & BIT_ULL(i)))
 			continue;
@@ -19,9 +23,23 @@ void bch2_progress_init(struct progress_indicator_state *s,
 		struct disk_accounting_pos acc;
 		disk_accounting_key_init(acc, btree, .id = i);
 
-		u64 v;
-		bch2_accounting_mem_read(c, disk_accounting_pos_to_bpos(&acc), &v, 1);
-		s->nodes_total += div64_ul(v, btree_sectors(c));
+		struct {
+			u64 disk_sectors;
+			u64 total_nodes;
+			u64 inner_nodes;
+		} v = {0};
+		bch2_accounting_mem_read(c, disk_accounting_pos_to_bpos(&acc),
+			(u64 *)&v, sizeof(v) / sizeof(u64));
+
+		/*
+		 * We check for zeros to degrade gracefully when run
+		 * with un-upgraded accounting info (missing some counters).
+		 */
+
+		if (v.total_nodes != 0)
+			s->nodes_total += v.total_nodes - v.inner_nodes;
+		else
+			s->nodes_total += div_u64(v.disk_sectors, expected_node_disk_sectors);
 	}
 }
 

-- 
2.50.1


