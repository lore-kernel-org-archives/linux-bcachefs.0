Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F2820DD72;
	Wed,  4 Jun 2025 19:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749065922; cv=none; b=gb1lN9NNIpbeQlGqrsiGdwN3jGItHUEO1EUIugyX6HmgsQKj+tpMz95MCz+vO91eRnmCKwY1fQ+RN7V68aaWUIQXvDbuYOY39AxpII7GFGgNZ+qMfyrdNCD2PZ6JO4/q3wNY5pFGGFynBzz1SHV6G84zW32WoxuI8d87CxeNESo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749065922; c=relaxed/simple;
	bh=ONBTs3bY32YZYeN0gY+ySm3lhYZWb6KxqKYNmJzDi7M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=BCdGWeYXtP5x0LBtBqaA5t8H1ajisMutCRZlhurwAWSU/BZp0IFWgIGYN52p8HFbHVVU0kB1xrxDj2H4Ulthd/pFWaHb3U5t/AbanwE6lIXw0InCzelZV+rGXBWLqxsBNGJttW+O542zOutWK+4NhBcTmiwriHpHEchzqXPzKAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bk/uqlKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bk/uqlKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11C2C4CEE4;
	Wed,  4 Jun 2025 19:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749065921;
	bh=ONBTs3bY32YZYeN0gY+ySm3lhYZWb6KxqKYNmJzDi7M=;
	h=From:Date:Subject:To:Cc:From;
	b=bk/uqlKTNH96pQe18y3REjmERxe4fJ8NKqvk+H8v0ttwn2oMf0bcY/cx3+4dWIf9J
	 MSCx4IgW1l1CmlTLUFsvsVchoK6Ypdsv8+VcXJPmVkQ01zZZWVUsOr+LaaeNGkJGSE
	 OSyJXry30PUPQKyODkiQFCdGSKZNuzzDDyVQsu7dzOeiT237z/Ki+qonPKnUdvdSbU
	 ttzQnwdj+vTA1s6hbVmymueYpLmKgxpF0fK4iZHhyZOSNoPZFiBZ6RcKU3IsncRq2e
	 OaiXUAIdJquQSwHynMX04irqYVN+IA4VQB/JZBtYtnrUbsHak75WGkHWsrckcbY9sJ
	 wM8+cA86Thodw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 04 Jun 2025 12:38:27 -0700
Subject: [PATCH] bcachefs: Fix -Wc23-extensions in bch2_check_dirents()
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250604-bcachefs-fix-clang-label-followed-by-declaration-v1-1-68a8bce1d981@kernel.org>
X-B4-Tracking: v=1; b=H4sIALKgQGgC/x2N2wrCQAxEf6Xk2cBaqqi/Ij5kk6wNhK7sihdK/
 93g42FmzqzQtZl2uAwrNH1Zt7oE7HcD8EzLXdEkGMY0HtIxTZiZeNbSsdgH2aOCTlkdS3WvbxX
 MXxSNpNEzZFiI6TwRp5MIhPbRNKb/y+tt235gBKhnggAAAA==
X-Change-ID: 20250604-bcachefs-fix-clang-label-followed-by-declaration-faca94ac08dd
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1537; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ONBTs3bY32YZYeN0gY+ySm3lhYZWb6KxqKYNmJzDi7M=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBkOC/bvlImIq/+oGJE966VrbTSPe27zHbEPF34t0H1ym
 3Par8SSjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCR1xMZGT7OWddpM1t6/h6O
 l9VlDh/+iz9V+BzwPzvuxN680zodn9gZ/pf0P7D6obookOHeL8YqzmM7GKdLlb7PvOxmq7i/RF7
 kAxsA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  fs/bcachefs/fsck.c:2325:2: error: label followed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
   2325 |         int ret = bch2_trans_run(c,
        |         ^

On clang-17 and older, this is an unconditional error:

  fs/bcachefs/fsck.c:2325:2: error: expected expression
   2325 |         int ret = bch2_trans_run(c,
        |         ^

Move the declaration of ret to the top of the function to resolve both
ways this issue manifests.

Fixes: c72def523799 ("bcachefs: Run check_dirents second time if required")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/bcachefs/fsck.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 40d6110c3671..68ed69a255e1 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2319,10 +2319,11 @@ int bch2_check_dirents(struct bch_fs *c)
 	struct snapshots_seen s;
 	struct bch_hash_info hash_info;
 	bool need_second_pass = false, did_second_pass = false;
+	int ret;
 
 	snapshots_seen_init(&s);
 again:
-	int ret = bch2_trans_run(c,
+	ret = bch2_trans_run(c,
 		for_each_btree_key_commit(trans, iter, BTREE_ID_dirents,
 				POS(BCACHEFS_ROOT_INO, 0),
 				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,

---
base-commit: c1af8a9222e641dbcb722a1d033f6aed4fbcfc34
change-id: 20250604-bcachefs-fix-clang-label-followed-by-declaration-faca94ac08dd

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

