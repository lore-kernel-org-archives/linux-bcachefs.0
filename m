Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDC72D323E
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248607; cv=none; b=tTLXrOfoSLN+44Uqhs+mSHq6EDxzLjcdsS3Jci0NKg9ING/OWV2vyedyuQg/yxEnpFaUeXJdzCnV6dZhhj2KYBKf9BlTMZxBSp2hzN/7fxyhzuC+aEHVJ618zCGWKfp4eYMML4a6bw+4GD13FAAbAjeyPkF8p0LohKwxss7abO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248607; c=relaxed/simple;
	bh=J7NL5geMAAUjoFubOEj0EtK0nPS+mvUZ2x8FszOcDOc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EhgcC+bHA08jGxoYxshVeCKU8s5Ny4jmFR2Zr/pax+z4Zmd8pE914hg0JEaoOWtiSn0qsmpTf0Fd7+YzYwzHDv1ogvRSjnEmyhe4FfzbudZf4FmWR7tmwba6hO6ulyl+qDDGOW/eJ2axF+6SWwjD7wkUpQT2CiTIqdLuTLBlz88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9YdhTca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9YdhTca"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EBEEC19425;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756248607;
	bh=J7NL5geMAAUjoFubOEj0EtK0nPS+mvUZ2x8FszOcDOc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=h9YdhTca0v5fKRFRGATkzcNh+L1RQeYPWk2rCwgXUsb/YbLAd+EmYVsJkTB/3JxLJ
	 czpxNrJxIumVtPtovHZxlHyYbMM7dFPHuy+VNsGkQTtA/PWrPZvXHeS1RLvArqhYoV
	 CbASHoJDWRDIaGsZwVVd0wd5EPZiChbPJLUUtZD++HwVaQD/NGX+yyZkMj7DEBsitf
	 AK9EdxVbt7cFT0SIWgudUD0ZrDT1ZeXS05ciYVU51xRhVWWImprrXsMOmhnW6uNAp8
	 Zy2pRcYMIIxbhJChx8DAdMImRsv0rZhVBlyGM8Z7K481R3ZTYc0tiF7KEscN7Lc87r
	 lHJ0OhojBjypw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FE6CA0FED;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Wed, 27 Aug 2025 01:49:17 +0300
Subject: [PATCH 11/12] bcachefs: Fix missing c->usage updates from early
 recovery
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-better-progress-v1-11-74c24de7988a@gmail.com>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1234; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=ANX9w19sEjOEn5vKRZr+Om3Rozy2fcgzJVXQu2XTjfA=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSss5JtuOF94ZD0+bxpO3IMNria/zu89ci7D8lVLLmWs
 72yV8++11HKwiDGxSArpsjyYcnXP2syrf9YCu01hJnDygQyhIGLUwAm0v+dkWHJ3Nvfj1c8Zr39
 6ZHUleV3rD02vX6xTvTclVeCXCwMO7/OYGRoXLjZdI+Alf7C/nM74t2mss9hLIv0D5d8GOYVpGC
 ftoIVAA==
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


