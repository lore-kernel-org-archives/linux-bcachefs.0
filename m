Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B02D1C7B81;
	Mon, 21 Oct 2024 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729529346; cv=none; b=ffCAl9xl/HocewL7YVhgertj/ixwbg7YPjsS/doUJhd/TsutTTc36Dq+rTMActl2kaHXHqGKbxRTzrXpCrEEAXytKaMO3+fShsFn0xX0vvafIoc7qmVWBYMb8actPq1HBHhvf+KkXJ5keDPRRxGzG5PT8M0T/wqyRhCesQWYCGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729529346; c=relaxed/simple;
	bh=Xhmz2Yd3SwGpseR8dLR4yXNrCUFWeAR1BlGSfk79iDc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=B5rdRn0d9bphCaDAq7NaUz++kFGSKc7l6n2oFO3W+XxDTY5FqtUYH9TNrk/ZkEwgD2o6ZMCEuAJCiB4ZrwGcDopWuB+VFI9ZolChkSO1VBnGBFSQkg9XLyC8Gu7xHd/SH/KfS3I+uhINcPFGBkcgWCNY6iOPeEnQ5dtbHRyezXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQMC3Ib1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQMC3Ib1"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1592C4CEC3;
	Mon, 21 Oct 2024 16:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729529345;
	bh=Xhmz2Yd3SwGpseR8dLR4yXNrCUFWeAR1BlGSfk79iDc=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=QQMC3Ib1hWtzksS58Xr0QSMETCSd3FBsbK4KEPcfRcbKxITTHSFBxd/U3uA9Cyo2F
	 oJL4+uMvhEuqCGNrkfZtav/8y8HTygCo5VOOuQodW3IxVQfEON+gyd+1W1t9smhkah
	 zS2iTHDBhXI08upVYblWsl59bfeIf86yMi1Gif1hCenvPuHZQqMekEAwWbTfiPSrYJ
	 sqmOfrk1QwrjKv/CWf6pNYBBUlnErv8HqCh3TF/qLh8wuE/qNnBn1YrEZCrLzQ9oyr
	 JFZzQIQDyM/pxW3wjVdA4tNlh8Ph8uHDceKBbAcFEfpLipp/CzHjg9rtUkptReMvl4
	 jtJSzJxiY1lLA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC49FD15DB2;
	Mon, 21 Oct 2024 16:49:05 +0000 (UTC)
From: Manas via B4 Relay <devnull+manas18244.iiitd.ac.in@kernel.org>
Date: Mon, 21 Oct 2024 22:18:57 +0530
Subject: [PATCH] Revert "bcachefs: Add asserts to
 bch2_dev_btree_bitmap_marked_sectors()"
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241021-revert-assert-bch2-v1-1-e869c7c55bb6@iiitd.ac.in>
X-B4-Tracking: v=1; b=H4sIAPmFFmcC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxNDAyNDXaCi1KIS3cTiYhCVlJxhpGtkamJukpZqYWCZYqgE1FhQlJqWWQE
 2NDq2thYAFnuBOGQAAAA=
X-Change-ID: 20241021-revert-assert-bch2-25474fe809d1
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Anup Sharma <anupnewsmail@gmail.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Manas <manas18244@iiitd.ac.in>, 
 syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729529344; l=1877;
 i=manas18244@iiitd.ac.in; s=20240813; h=from:subject:message-id;
 bh=M5hbMLylF0b+ZchbJH4bBirAx8QVk4kpDgu8JqXEiG0=;
 b=WgevtVQ8IzkqKxDmL4PPt4x+pwzKgX51dRXKIkpi/bHg+qtl1U1+wYlMsvhRz3aI+SKqx7uQJ
 /moCqOYxegOAir9iBXGhNInRIgLvsv2CRck4KxE2nrWm2swoQTEIXd3
X-Developer-Key: i=manas18244@iiitd.ac.in; a=ed25519;
 pk=pXNEDKd3qTkQe9vsJtBGT9hrfOR7Dph1rfX5ig2AAoM=
X-Endpoint-Received: by B4 Relay for manas18244@iiitd.ac.in/20240813 with
 auth_id=196
X-Original-From: Manas <manas18244@iiitd.ac.in>
Reply-To: manas18244@iiitd.ac.in

From: Manas <manas18244@iiitd.ac.in>

This reverts commit 60f2b1bcf519416dbffee219132aa949d0c39d0e.

This syzbot bug[1] is triggered due to the BUG_ON assertions added in
__bch2_dev_btree_bitmap_mark. During runtime, m->btree_bitmap_shift is
63 '?'. This triggers both the assertions.

Reverting the commit does not reproduce the said bug.

[1] https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41

Signed-off-by: Manas <manas18244@iiitd.ac.in>
Reported-by: syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
---
This syzbot bug[1] is triggered due to the BUG_ON assertions added in
__bch2_dev_btree_bitmap_mark. During runtime, m->btree_bitmap_shift is
63 '?'. This triggers both the assertions.

I am unfamiliar with the codebase, and there wasn't a lore discussion
about the assertions in the commit, so I am unsure about the relevance
of these assertions.

Reverting the commit does not reproduce the said bug.

[1] https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
---
 fs/bcachefs/sb-members.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index fb08dd680dacf82bca414f424024e4a00bf432de..9790fd47338c46d2af30547e1f41a1e578b71aa4 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -450,9 +450,6 @@ static void __bch2_dev_btree_bitmap_mark(struct bch_sb_field_members_v2 *mi, uns
 		m->btree_bitmap_shift += resize;
 	}
 
-	BUG_ON(m->btree_bitmap_shift > 57);
-	BUG_ON(end > 64ULL << m->btree_bitmap_shift);
-
 	for (unsigned bit = start >> m->btree_bitmap_shift;
 	     (u64) bit << m->btree_bitmap_shift < end;
 	     bit++)

---
base-commit: 42f7652d3eb527d03665b09edac47f85fb600924
change-id: 20241021-revert-assert-bch2-25474fe809d1

Best regards,
-- 
Manas <manas18244@iiitd.ac.in>


