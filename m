Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D94122F384
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Jul 2025 00:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751500801; cv=none; b=ngD8azw2JLyuX6AoO/p2K/nKFhLHB8S8SETZKMt9AE/3hlfRBWg6FK+kwPSvtWviNS2Qo1fXuvSTc/Ohmc/kqFTyVGT12J1u6gzPxt/SF03N2Iq7bG7LYQ+tbVH/de4mmn7ylO+xhYco/54PoL0q0dsNV2vpFA12x6gsxRsvOsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751500801; c=relaxed/simple;
	bh=gnnjvecIMspwetzSVAe0VRtgLxZZswKaIGBkmePg2HM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=X7VhZviLv1exD+iv1veIxBPqoX3uICHT6oebgv6yaoGzbVYUWHn2BkJqHon1ajyxtcOH4rk6sOWZqfpIH2F0B22GaVRprxxA0sKr5YBh6HCq9NNckDVmlB0ftvqRNd/dVWz8kI0bMr0tpEvukAiRBcd18j2Yh+FxB7DPQuufNi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIM00h/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIM00h/3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9658C4CEE7;
	Thu,  3 Jul 2025 00:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751500800;
	bh=gnnjvecIMspwetzSVAe0VRtgLxZZswKaIGBkmePg2HM=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=MIM00h/3Om7FDUwqql+bkqFoxZJVJx/97gYiF9gcNBhxKnCOsiZ7bwgk7vedkB4YJ
	 KFoYktbHW1kDLyaMfrccfmqZvgqwiNQtMcQ/S9MyGzr/H4w1aVsQj2uaKSJShn1l3D
	 CibowCSiasLPfqP43iPhi8lfFbXz5ZxfULQK6O/IyJIU6bT5hZoYu70cSDBwDEL5el
	 lGBe2a3ZnRagalW+TtadB7WY5pXVH+UrlUkCtKjcPoAFs0o3hL8LzgjpJ7XlVsqwXW
	 sh665RmBijlHzem5LDy8b3FdPo1szeyb+rJDN5YQrzUbAyK94na5vqeBD+9y8f2YSq
	 RRzq24wB+qQyA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD68C77B7C;
	Thu,  3 Jul 2025 00:00:00 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 03 Jul 2025 02:59:11 +0300
Subject: [PATCH] bcachefs: Suppress unnecessary inode_i_sectors_wrong fsck
 error
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250703-isectors-not-wrong-v1-1-37002be151e0@gmail.com>
X-B4-Tracking: v=1; b=H4sIAM7HZWgC/x3MPQqAMAxA4atIZgO14g9eRRxKTWuWVhJRQby7x
 fEb3ntASZgUpuoBoZOVcypo6gr85lIk5LUYrLGdGUyLrOSPLIopH3hJThFHGl1jex9aM0AJd6H
 A9z+dl/f9AN1vRPtkAAAA
X-Change-ID: 20250703-isectors-not-wrong-8e8a126cf307
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1208; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=2wcJM/AavbId1UzNMVMhmkxxIl8bglzMr8gbV3nXSjw=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSkHv/veldg3gHD2C8hoV436lYaT/r0/lBo2yrHWR6Z6
 3Q/LrHb3lHKwiDGxSArpsjyYcnXP2syrf9YCu01hJnDygQyhIGLUwAmclOC4X+Zj9najUWHPt3P
 EXruNUHu7POZ82sPtmgWZ+/Zu12w/doURoZ5rZxfBNkm/Zsj4XvBKPtoya9SZtd/sXJcFmtsLPo
 Nq1gA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

It is possible that fsck first miscounted the expected sector count (due
to applying other fixes at the same time, for example) and then
corrected itself using extents. No need to log an fsck error and
write the inode in this case.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/fsck.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 1ceca63c87a3bf3eb75d396f7a10949c502b0e8d..471e93a3f00c637050b5c485d72b27cfb284282d 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1638,7 +1638,8 @@ static int check_i_sectors_notnested(struct btree_trans *trans, struct inode_wal
 			i->count = count2;
 		}
 
-		if (fsck_err_on(!(i->inode.bi_flags & BCH_INODE_i_sectors_dirty),
+		if (fsck_err_on(!(i->inode.bi_flags & BCH_INODE_i_sectors_dirty) &&
+				i->inode.bi_sectors != i->count,
 				trans, inode_i_sectors_wrong,
 				"inode %llu:%u has incorrect i_sectors: got %llu, should be %llu",
 				w->last_pos.inode, i->inode.bi_snapshot,

---
base-commit: 14a12362bb22b3735c51ecdb712570a12992a695
change-id: 20250703-isectors-not-wrong-8e8a126cf307

Best regards,
-- 
Nikita Ofitserov


