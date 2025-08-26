Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA64E2BE641
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248607; cv=none; b=CwcD87G6ZSQjBCZC67EXbxqlpXRN6DaUap+Kh2foKFumpmw/x+64eabaqRk9iNNRZzgRbpDtg0FyDO5F+4/FzUfqPqjBOOp0Cvel1tLCVJmgAEhvtjNc6n1oUD9xpWzHVCP7LaV0MWWGWbbKgf56hIBK7QFCQLQO03U/uOeX8Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248607; c=relaxed/simple;
	bh=tWWHaLLRc2APwfQvajhC3gk8uj2Z91BIEFmLI+Rp9b4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FCybxTh3OwGmmS9jryo6V3SXrER/Vbu4hA/XvuC+dSS181Vr2IVMvZnyV1HC6wRM8xZHg/98BHBe1TIc700IFJGslDNt3oPCR41NoWx7+gL7aaBTMvoHJMKKDFPFJ8yZR/H+15wGTpVw19jTGSBCJ0okdC6aDyQ0npUz2IZl0M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0H06nLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0H06nLH"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83F97C2BC86;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756248607;
	bh=tWWHaLLRc2APwfQvajhC3gk8uj2Z91BIEFmLI+Rp9b4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=X0H06nLHce7SJSmkUkZmUpwpS8/x+UvI00T1Pg1Bxv9xh29rp7cscpkl5FEEcpUad
	 1/Vc6nDlox5BggG5fWqk9PWwmdSbx/NU1DuyWAhavKYx8du/qyw0nUEor7pfGk0sKT
	 LQI0lG9LFClR5r1utp29a6oVqU9A3ZOaYh8ogPKpvabZSrz2c0jCzF49t9/OclPQR8
	 Z4cX07N3awtfwiLC1PisMcR0UE4uAFek52dy4gfJiFMHHTCdcYBAlZvxX0DWNfZzHC
	 3cC1DlQTsl/20VZT7X6uoX8QiOtvZ5J45dboRGivFd/wE+PaZRqMHHBOxz562POvVi
	 wc3lS17hfHKBw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D58DCA0FF0;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Wed, 27 Aug 2025 01:49:16 +0300
Subject: [PATCH 10/12] bcachefs: Improve check_allocations pass speed not
 in fsck
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-better-progress-v1-10-74c24de7988a@gmail.com>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1395; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=WSNOd5gV6NmNyQNbSGutydt83aC8FZuQ9bqlIo3aZ8o=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSss5Jdv4/5fMBGrp9TPzHrftzxw6zcu0KK1+hw2DOLu
 tLGzUdXd5SyMIhxMciKKbJ8WPL1z5pM6z+WQnsNYeawMoEMYeDiFICJfGFmZJjOcui6nX/j3eCb
 ziKHeJVMqrr8GGUNtqu+tP79dP+tNeKMDK+uy/LxXRGTWB3/OlPaeleq26MobWMewUsdh4r1zR6
 /YwUA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Skip reading unnecessary leaf btree nodes unless running fsck.
For example, this should speed up version upgrade/downgrade when
rebuilding accounting information.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/btree_gc.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index b89e12a3112868f175d028ce9745c8b4944ca747..c04e88ec5c0ac73c21f01db597b19d1b0c798299 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -793,8 +793,21 @@ static int bch2_gc_btrees(struct bch_fs *c)
 		if (IS_ERR_OR_NULL(bch2_btree_id_root(c, btree)->b))
 			continue;
 
-		/* We need to make sure every leaf node is readable before going RW */
-		ret = bch2_gc_btree(trans, &progress, btree, 0, true);
+
+		unsigned target_depth = BIT_ULL(btree) & btree_leaf_has_triggers_mask ? 0 : 1;
+
+		/*
+		 * In fsck, we need to make sure every leaf node is readable
+		 * before going RW, otherwise we can no longer rewind inside
+		 * btree_lost_data to repair during the current fsck run.
+		 *
+		 * Otherwise, we can delay the repair to the next
+		 * mount or offline fsck.
+		 */
+		if (test_bit(BCH_FS_in_fsck, &c->flags))
+			target_depth = 0;
+
+		ret = bch2_gc_btree(trans, &progress, btree, target_depth, true);
 	}
 
 	bch_err_fn(c, ret);

-- 
2.50.1


