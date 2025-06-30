Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97AA2264BB
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 21:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751319089; cv=none; b=RJC02w5rkU2o4F9Skx7EGvtKSf34h/OrBk5pilwB8+SJvR/dob4I3PdTMizRaza3hXC/MofVF10SRtpr7E7HBnD+xJxi3Pv9AYGVUAY/9C9patsQwIYV/ZAy/dFMUI7VH5SrRyLWzeKgK5UQGZSTfEGJ7RX7ddFZf4tTIOmOA+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751319089; c=relaxed/simple;
	bh=uE8fBwYDOCKeqD7mM9JY6RR68f3FmxpRt3jfC8hVdHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7b9CU6Zrh/sp3mFTEv1ML06a4Z38dhiwfJsRqM43adV8UMcJDL7i6acjhcmXCeNxEr+wm3+5Eth5AOr3V+Wpd8j0roWPW0rZco6gg2MoXhDAwD1D6QWbOIq0SOavtVFyYgjmk7W0ye3ieLTooCdSyZWQDDb57V5QTS6lgsvUgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=muJOVBs0; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="muJOVBs0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751319086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fcdSFeTYSiKYpYb80zyib6wszbpy4GK/FYwhAKQ2Zyw=;
	b=muJOVBs0uRua9Y3lT3kVp+rbApV4dRUqW2rSE+KaCw0fM10ID1Ow9tzNKVy9435UkUDY9d
	WftoQw8EGo943ZpOF9+tZiAAHSxazlwKXK+TytP7QK0v3FBFbSYTK7mrXieZgBm82LF2No
	Aq8NJIvCxoNJRoqGIa7IH19nIRFJ3ao=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: check_key_has_inode() reconstructs more aggressively
Date: Mon, 30 Jun 2025 17:31:18 -0400
Message-ID: <20250630213118.2063622-3-kent.overstreet@linux.dev>
In-Reply-To: <20250630213118.2063622-1-kent.overstreet@linux.dev>
References: <20250630213118.2063622-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

For regular files: reconstruct if more than three extents are found
found

For directories: reconstruct if a single dirent is found.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index a94dea16e4cf..52f4dc7ba477 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1500,6 +1500,10 @@ static int check_key_has_inode(struct btree_trans *trans,
 					 SPOS(k.k->p.inode, 0, k.k->p.snapshot),
 					 POS(k.k->p.inode, U64_MAX),
 					 0, k2, ret) {
+		if (k.k->type == KEY_TYPE_error ||
+		    k.k->type == KEY_TYPE_hash_whiteout)
+			continue;
+
 		nr_keys++;
 		if (nr_keys <= 10) {
 			bch2_bkey_val_to_text(&buf, c, k2);
@@ -1512,9 +1516,11 @@ static int check_key_has_inode(struct btree_trans *trans,
 	if (ret)
 		goto err;
 
+	unsigned reconstruct_limit = iter->btree_id == BTREE_ID_extents ? 3 : 0;
+
 	if (nr_keys > 100)
 		prt_printf(&buf, "found > %u keys for this missing inode\n", nr_keys);
-	else if (nr_keys > 10)
+	else if (nr_keys > reconstruct_limit)
 		prt_printf(&buf, "found %u keys for this missing inode\n", nr_keys);
 
 	if (!have_inode) {
-- 
2.50.0

