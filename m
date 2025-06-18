Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9FE3085CC
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283707; cv=none; b=SY3FuNRFsCjsEsgdNDOTcD+4q31bUTS6GJarp3MAzOTnz1U5y+CB8Iwv3Pvj3gs96eELted8DCUSTZyv9kTVuVuq6yyZ2bpIMNRVDhi/YJoj/o3j0RZ208OloBIAmh+C6VLMv8ANPbl2pbL5I5vpV8OYAjF/TCzVXzlz3AwOzl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283707; c=relaxed/simple;
	bh=41Y2L9IL+AUf/wpG/X1vC9aAFW5Zxf6VhBD8Cfr1hgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPMg+GOiEOIn0ZDs/ktxEbpqPYWwlCpMYYlCPko5FyEewUAcbyYDm0X4PHNJiCmeJKYOgVYi4/hgTHzbdnX4/dZ4Aki5Qa/YUtLZoJ2gnlgVzybVYP2WkuX7lQRl5GKtWG1KU9FCEzi5FhAjGeBUHt7YBhPMsWeo0E/wAJJP18c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TZBb8/pm; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TZBb8/pm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QyXv3vL6aN8ov291kb9os2nry96xntteUfXhtwOYT9o=;
	b=TZBb8/pmqh46Y05b5H+O7oLi8fK5rghYK3tghpIosdVofCAc6b6ur09/23yS1N7HghwdJG
	59XSaLOs1OkJkoJXGk2gWCaee+fm/eNsmtIvtEXtYN9n1d5BRGtEQqLQNBICIGlfEpCCIC
	08154pE+d1MheLKTzaFIwsvf01fvELQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 25/37] bcachefs: fsck: Fix remove_backpointer() for subvol roots
Date: Wed, 18 Jun 2025 17:54:16 -0400
Message-ID: <20250618215431.738317-26-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The dirent will be in a different snapshot if the inode is a subvolume
root.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 0d87aa9b4f23..a3f73e7a2113 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -493,10 +493,18 @@ static int remove_backpointer(struct btree_trans *trans,
 	if (!inode->bi_dir)
 		return 0;
 
+	u32 snapshot = inode->bi_snapshot;
+
+	if (inode->bi_parent_subvol) {
+		int ret = bch2_subvolume_get_snapshot(trans, inode->bi_parent_subvol, &snapshot);
+		if (ret)
+			return ret;
+	}
+
 	struct bch_fs *c = trans->c;
 	struct btree_iter iter;
 	struct bkey_s_c_dirent d = dirent_get_by_pos(trans, &iter,
-				     SPOS(inode->bi_dir, inode->bi_dir_offset, inode->bi_snapshot));
+				     SPOS(inode->bi_dir, inode->bi_dir_offset, snapshot));
 	int ret = bkey_err(d) ?:
 		  dirent_points_to_inode(c, d, inode) ?:
 		  bch2_fsck_remove_dirent(trans, d.k->p);
-- 
2.50.0

