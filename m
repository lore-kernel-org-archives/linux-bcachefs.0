Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEE12D23B6
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248607; cv=none; b=kpPPs981mjSH6yD9TeMk6yWHpVeJ0V/KRe3Bim8XpsjOu60Hk2I7GbfHNFR4bVNSNhsHHqgDZ0yk2rKheV67cEpSG5nbFdTUzY1/YYBQ6eiWXOdu+AwnYKw2zTbpCCPafgsoEHWHyO02iWMtnNCvaFGQGWArCchdYOzs0G7isP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248607; c=relaxed/simple;
	bh=6mRhM/46m4zqN+OB+jCkfJVye6ROFLwRf2v+fZUFIbo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FGk5GIlEzZcznP658+SiqQnzwR+mF6lJB5KXdAb0OwdvyfSCavEwrTX3c4cf925m0outVofQTE/smWUzItdVO9IQrVzQlL606svrl1lqKsRF4JlDvjBEiN5gksP8+GaQk2+kwmf4MPC/zJ8HCy2+dVWluZhYu5T2WkffQT6zgSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBNssZyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBNssZyd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57B36C19421;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756248607;
	bh=6mRhM/46m4zqN+OB+jCkfJVye6ROFLwRf2v+fZUFIbo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nBNssZydH85ofkLZ1+eNzwUgLUo8RYrTI2C6I0TXpbgqyKGnfC6tstqX9opzE43hJ
	 lgUrpztM4YtTom4o5t+3jpLxRZWWXmSdeeo4HLjbhwuorH0OJm2+Wuq5TH/Kr+40QG
	 UBcM3C4LdDvqKfK/b6r2ZMlIMm5Z23uobBDxxXjhMyxKh+abHNwjHdS7ATcJ1Q0nN5
	 uWEyQupYsiLvnpT0WTS6p+W1JwS+4+A5bj41zPL49jB4wsjYNVbx2Ic8pkgRisKeq6
	 HAAgIZItGkb6kmgLNEuA5D54jkVafDSYe4uAJh1y507cWqG8WM5OJrpJrA56CHSwJP
	 /HCb8K4yoDEQQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526E0CA0FED;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Wed, 27 Aug 2025 01:49:12 +0300
Subject: [PATCH 06/12] bcachefs: Refactor/rename btree_type_has_ptrs
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-better-progress-v1-6-74c24de7988a@gmail.com>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3458; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=FQPiPFfaFbnjVux/gGFuoIpp03FQldNcu72MZxMYc9k=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSss5KRi5u9hss/eum6ddtMEmvkS2+c37hNwTBPcvs87
 mV9BeebOkpZGMS4GGTFFFk+LPn6Z02m9R9Lob2GMHNYmUCGMHBxCsBEvBkZGS4WFzH/brnPfmmV
 y4aU3TGTFTL95rQqTZXiPbuQi/Hrcl9Ghq3n5B5uPiIgcubgtrmJ2zkXlpvo+0Vl32xRq5u+N/V
 hDCcA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

The new name (btree_type_has_data_ptrs) better reflects the meaning.
Also introduce the explicit mask constant.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/backpointers.c | 2 +-
 fs/bcachefs/btree_gc.c     | 2 +-
 fs/bcachefs/btree_types.h  | 8 ++++----
 fs/bcachefs/migrate.c      | 2 +-
 fs/bcachefs/move.c         | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index cb25cddb759b84bed48c653605ba195218f2140c..0d585e5662be3f02580558e9a590075ea73193d5 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -809,7 +809,7 @@ static int bch2_check_extents_to_backpointers_pass(struct btree_trans *trans,
 	for (enum btree_id btree_id = 0;
 	     btree_id < btree_id_nr_alive(c);
 	     btree_id++) {
-		int level, depth = btree_type_has_ptrs(btree_id) ? 0 : 1;
+		int level, depth = btree_type_has_data_ptrs(btree_id) ? 0 : 1;
 
 		ret = commit_do(trans, NULL, NULL,
 				BCH_TRANS_COMMIT_no_enospc,
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 2b1b6b7ffdf0af7ec0bf4cbaf68cc9a53a20cfce..006bdd5c90bc805219d4e38923135986425ccf17 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -1228,7 +1228,7 @@ int bch2_gc_gens(struct bch_fs *c)
 	}
 
 	for (unsigned i = 0; i < BTREE_ID_NR; i++)
-		if (btree_type_has_ptrs(i)) {
+		if (btree_type_has_data_ptrs(i)) {
 			c->gc_gens_btree = i;
 			c->gc_gens_pos = POS_MIN;
 
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index ad9bd18fe9b6e51987da74d373830dca98df56ec..d06991c16d5c24c586e9449efa9553e2b8593bd4 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -886,15 +886,15 @@ static inline bool btree_type_has_snapshot_field(enum btree_id btree)
 	return BIT_ULL(btree) & mask;
 }
 
-static inline bool btree_type_has_ptrs(enum btree_id btree)
-{
-	const u64 mask = 0
+static const u64 btree_has_data_ptrs_mask = 0
 #define x(name, nr, flags, ...)	|((!!((flags) & BTREE_IS_data)) << nr)
 	BCH_BTREE_IDS()
 #undef x
 	;
 
-	return BIT_ULL(btree) & mask;
+static inline bool btree_type_has_data_ptrs(enum btree_id btree)
+{
+	return BIT_ULL(btree) & btree_has_data_ptrs_mask;
 }
 
 static inline bool btree_type_uses_write_buffer(enum btree_id btree)
diff --git a/fs/bcachefs/migrate.c b/fs/bcachefs/migrate.c
index 892990b4a6a6b16785e5030e5dc7cf15b05c0fc5..41657deb0e3807f4968272491faea09d05ec2299 100644
--- a/fs/bcachefs/migrate.c
+++ b/fs/bcachefs/migrate.c
@@ -122,7 +122,7 @@ static int bch2_dev_usrdata_drop(struct bch_fs *c,
 	CLASS(btree_trans, trans)(c);
 
 	for (unsigned id = 0; id < BTREE_ID_NR; id++) {
-		if (!btree_type_has_ptrs(id))
+		if (!btree_type_has_data_ptrs(id))
 			continue;
 
 		/* Stripe keys have pointers, but are handled separately */
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 62aeb54ef11b33814f2d06e5ec2787b656a67c30..c30e74a3f89450b08b3a8b89a863752611482c69 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -671,7 +671,7 @@ static int bch2_move_data(struct bch_fs *c,
 		unsigned min_depth_this_btree = min_depth;
 
 		/* Stripe keys have pointers, but are handled separately */
-		if (!btree_type_has_ptrs(id) ||
+		if (!btree_type_has_data_ptrs(id) ||
 		    id == BTREE_ID_stripes)
 			min_depth_this_btree = max(min_depth_this_btree, 1);
 

-- 
2.50.1


