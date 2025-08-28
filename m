Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA9C3148BC
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390597; cv=none; b=oi8cN0nPGDvUPZOGSQj0Ycgs1jeOhrJuUJZcL1KYDfBEvJv/ewE6lwF1A2WpZKCJ1M8Xz6eYXoowylEsdNO9hHAZ2MRdz1mVAJsKDIlkDIcHC/PKGjcjDGsLzzEQBzmOXg3aVH++xwV2Ca8fqW4ScbLb7rQIsN1h7HDseYOWViM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390597; c=relaxed/simple;
	bh=J7NL5geMAAUjoFubOEj0EtK0nPS+mvUZ2x8FszOcDOc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Zs4SZ/ytfS97/F6SNQLSzA75ezUrigHroTE7RjC+xu6+sf3e9u5oy5T/9eKUz9ZzbtGuCse/lGKZf4Tpqaj3bF2GguNI5qvyc99GEh+NC9ZdPVbmwcRwt21TEuFUKDsNyFb8a7z2FvfvGP0UIbJizmTqhyezaYrQvWR59oBwT58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJQqT95g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJQqT95g"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 643DDC4CEFB;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=J7NL5geMAAUjoFubOEj0EtK0nPS+mvUZ2x8FszOcDOc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fJQqT95gBeU1Uk76NDqb4C/nUwnIZPm/YJbbOBEYrTN9OVPLKGt2KK2FX9p/f6Q/S
	 ePnvMOzggkGrMKt5fjIE262dzItsEnx5BGVX7WxzD+rkQIv0LhTEqTRWebT2m6E79y
	 cyii9Xlyq2RWPszgEbumJuNwNBDP/qgqmFtDh2h4BDEJvkZv0U2F7BJHvV7Pc/Jx+J
	 4sDrP3pI14/j9MXyEL3yVklUHB/qxv3Ee+JRvPYTZsnPzflA0iE69+S/JTNM147866
	 Ji2iLzItI8Y/LMV+a4eUtSwatwrfc0a1FG2sb6STPKNx21d3pzEs31Ls9PICzBnHLO
	 BXKoRCyvINLyA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8E3CA0FFD;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 28 Aug 2025 17:16:09 +0300
Subject: [PATCH v2 07/15] bcachefs: Fix missing c->usage updates from early
 recovery
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-better-progress-v2-7-c088a2003940@gmail.com>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1234; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=ANX9w19sEjOEn5vKRZr+Om3Rozy2fcgzJVXQu2XTjfA=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDm4O/qIYmgD049gp+fLf06fr3Poy1MF/pbUnfGXt
 dPmdxqd7yhlYRDjYpAVU2T5sOTrnzWZ1n8shfYawsxhZQIZwsDFKQATqVnB8L8q6cKap3MOpq6Z
 8OPop91KRiYXfr6eHJe+ua0pR2lb5YwcRoaGjBzGk+I7bNdc2bz4EtcjnYzLk3gjTzzU8G24dZw
 l1JwbAA==
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Make do_bch2_trans_commit_to_journal_replay apply global FS usage
updates stored in trans->fs_usage_delta, too.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/btree_trans_commit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 5fa7f2f9f1e9d0ddd1d4675774321b519313f477..e3f069ad4002e2b007600fb41cd220d13386d37f 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -970,6 +970,7 @@ do_bch2_trans_commit_to_journal_replay(struct btree_trans *trans,
 
 	struct bkey_i *accounting;
 retry:
+	memset(&trans->fs_usage_delta, 0, sizeof(trans->fs_usage_delta));
 	percpu_down_read(&c->mark_lock);
 	for (accounting = btree_trans_subbuf_base(trans, &trans->accounting);
 	     accounting != btree_trans_subbuf_top(trans, &trans->accounting);
@@ -981,6 +982,8 @@ do_bch2_trans_commit_to_journal_replay(struct btree_trans *trans,
 		if (ret)
 			goto revert_fs_usage;
 	}
+	/* Only fatal errors are possible later, so no need to revert this */
+	bch2_trans_account_disk_usage_change(trans);
 	percpu_up_read(&c->mark_lock);
 
 	trans_for_each_update(trans, i) {

-- 
2.50.1


