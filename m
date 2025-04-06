Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294568488;
	Sun,  6 Apr 2025 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743951261; cv=none; b=Aisn+J2P//t74b7TpbS2hOnhZ/Zv8Kz17IZwTGrdwFkpgNEOBTJV1Ea0uT1SzfjRZDA+UMj6Qvj7d62CmkBYj5FqAieroKNEwHYJ9Z5Q6jaTOuICzyFKRw7xu9pCTiplE5q6fg0XEEbIULw/twzUR9eAcTVuK4c+5qDRm8e97W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743951261; c=relaxed/simple;
	bh=FvSnzeCWbeWXR/c43RnAwajUbG0B8sM00b7VfAy1W84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8UaWVjwmtJWqUApkJmFDMCYu4bFaJ+t/XBhAgPcvFWpxbLQ8/fJrrIpEM9uIIC3/mkKW9g6EI5uOOJO2/HFBPMin9fHAPimF5xmIBsRm9VMd3gdFNxJqoJPzoEyIbkVMe+0523N4i6fm3oxqqzobERVbnpHwdUVy/Qpl5cXe9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=FXFnfUyS; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="FXFnfUyS"
DKIM-Signature: a=rsa-sha256; bh=T4yhOExp78Tq/BIcyKG/npR27cSLhYT4DmXZitXOyFg=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1743951242; v=1; x=1744383242;
 b=FXFnfUySyADv+2Qp0ZCF8cm90yVTRHSw9EH7oysypql3r7oLCE5RwCf1PhbzfGQqFkVEEq1v
 Ux9bxwgqhiY5evWT1EDHl1p0BZOS3sk1NTXBvWCKEGaK5X56Iu7F0+Teze0/i2Rkg9wmqgf+BwB
 IBE4RRagA7u7mI0hq6PE1vSkpaPZHbpUwy85INbnViuT1N66QJyOm13jkfMOxgU7hUDEFNQs5IF
 97Vw2i1+jcufx118AuItIY47JZIjz8z1d5qh6keKmucne9I3wlrhSj7a/ws1iilOem2EG34p0f0
 jwAEKnHeUYxBd5dxhsejdM9GC7vycZY0COdMqPK1Ht5KA==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 5dc00875; Sun, 06 Apr 2025
 22:54:02 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@linux.dev
Cc: integral@archlinuxcn.org,
	kent.overstreet@gmail.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] bcachefs: early return for negative values when parsing BCH_OPT_UINT
Date: Sun,  6 Apr 2025 22:53:28 +0800
Message-ID: <20250406145327.191479-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <hepk5mxy7zfr534i4mbqbjr3jzkqytbnfz66lelzcewwu5h47h@df7qq7laaypr>
References: <hepk5mxy7zfr534i4mbqbjr3jzkqytbnfz66lelzcewwu5h47h@df7qq7laaypr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when passing a negative integer as argument, the error
message is "too big" due to casting to an unsigned integer:

    > bcachefs format --block_size=-1 bcachefs.img
    invalid option: block_size: too big (max 65536)

When negative value in argument detected, return early before
calling bch2_opt_validate().

A new error code `BCH_ERR_option_negative` is added.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 fs/bcachefs/errcode.h |  1 +
 fs/bcachefs/opts.c    | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index c4eb0ed9838d..e3c85288fd6d 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -213,6 +213,7 @@
 	x(EINVAL,			inode_unpack_error)			\
 	x(EINVAL,			varint_decode_error)			\
 	x(EINVAL,			erasure_coding_found_btree_node)	\
+	x(EINVAL,			option_negative)			\
 	x(EOPNOTSUPP,			may_not_use_incompat_feature)		\
 	x(EROFS,			erofs_trans_commit)			\
 	x(EROFS,			erofs_no_writes)			\
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index e64777ecf44f..1bf2580ab735 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -360,9 +360,15 @@ int bch2_opt_parse(struct bch_fs *c,
 			return -EINVAL;
 		}
 
-		ret = opt->flags & OPT_HUMAN_READABLE
-			? bch2_strtou64_h(val, res)
-			: kstrtou64(val, 10, res);
+		if (*val != '-') {
+			ret = opt->flags & OPT_HUMAN_READABLE
+			    ? bch2_strtou64_h(val, res)
+			    : kstrtou64(val, 10, res);
+		} else {
+			prt_printf(err, "%s: must be a non-negative number", opt->attr.name);
+			return -BCH_ERR_option_negative;
+		}
+
 		if (ret < 0) {
 			if (err)
 				prt_printf(err, "%s: must be a number",
-- 
2.49.0

