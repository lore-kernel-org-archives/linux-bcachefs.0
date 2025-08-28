Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631591FDA8E
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390597; cv=none; b=se8nRuCwSnVDHDAVZPjs6nvxQax4hSwIBO8gJSeQx82g4AoIHH2dVQ4kgtuEZLZxGL9Eu51V+gUGnfOoLI05/u8qOcXUQZbcbg89adUInbibG1upq9eZSHC1aXMP4cPUszBWqNxZYUd7idGzUqbuaBDRpKLdli5MyP9mcdQDe8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390597; c=relaxed/simple;
	bh=7lwd3S62PWO3PeHEbyWztYktjo0C1WlV2qo1YfViIQo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dHTrqDgkF3Rn80D8j+rics0Z68IplxxDokob8QRnxfLtOL65Fb0hwNBHwqxZSnKq4CqK2sLCztVIdQsfICcsSbOv5tLFeF7i26MCu7ZwQLjMFcS3M4Mhfh69KNEsF+CgzcrJTBmEOWQ9LaEAXueaR3VInTndTOwxuACp3x2XfjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfOg3G5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfOg3G5e"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E084C4CEF6;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=7lwd3S62PWO3PeHEbyWztYktjo0C1WlV2qo1YfViIQo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kfOg3G5eVOElrZ7PjdYf+t/zQUxM7GSmMCW6P10GF25sV8qdDiL0LsssNhXEb/sBj
	 ROqZcM9YsjdXkRjKYxkoK/i3l763q59pqDNqge6yWiRWuGushMrWZg+SKy2pzPNIPs
	 nWAKbwlGKwJrIZwmzxrbnUz1mqqy9b1lAG4946NPPUxOgwg7oKUpG7MTYZU4eAAhvg
	 D9jyMQpKXLJeCGQUBig71YB8dYj9dmsJubsOVJjreN7GUXzEMecXReeCLMvFd5tWhm
	 2c/R+pVXdoRJ+7bGyZ+aKDT9AP/ewRunxt7+QoY2R6bOIuMYquTG3snRvyqPmPBB6M
	 X7fU6ARorNZIw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25395CA0FFD;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 28 Aug 2025 17:16:05 +0300
Subject: [PATCH v2 03/15] bcachefs: Improve check_allocations pass speed
 when not in fsck
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-better-progress-v2-3-c088a2003940@gmail.com>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1395; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=LsH3HjIJ0C6BLAOki5osq6Lc4dYBqwtI+Ym2pal9WXY=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDn4PGbb/ECF3AdPCmf5cSr//Bf39f7mx0EP4qZue
 H3Y9E7qpo5SFgYxLgZZMUWWD0u+/lmTaf3HUmivIcwcViaQIQxcnAIwkbRdDH+lJvy1XLB9QeXa
 Neuln7/17/dSfqPgpSO4xm2ivL2EZr8+w//6GQ9X1Fn9eVC0ilVPQn92/v2S8zLrFbYnv+6rPXF
 F9RcrAA==
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
index 2a369aebdbe216ed665115e27388ab4821696bf8..b95a3610900de2eecf978c62f3809453455f7a5c 100644
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


