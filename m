Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D09314A79
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390597; cv=none; b=KYytoqiRc/MShCK3iUTLJV82MsMayNAQeotrfGw6YPa+trW1ULBlCV13e764BZGhx4OEfsMLRHGnSzG1B5GoRtgfVINtSILo6KkXddmsPT4bJOS1tnqKR68Z4HE+kiEPrHmjyO2i0iTFMM1oqGA7KzgWinP5K9JjTReNhdT2sw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390597; c=relaxed/simple;
	bh=5kaNbljiU1EwY//+7Q9xUBUb/sz+L57XXYxGDkdVrPQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QoCKDXaoxZrXXpi7zwH3MfEANxvvfiZEVTOnYNM+vsDcSEp4QHzPz9hv5je7aeKb8SwAFkYe63Xg3h0GOkE3fOEn1BJKY9vRL4W0K6Od9HPL4lsnOQCz2cGdp49+AEBCAWKkwCfPuIPBoPgNnWWfmgr7clGxkaxupYw+AFG5neA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJXa1Q4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJXa1Q4p"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BF93C4CEED;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=5kaNbljiU1EwY//+7Q9xUBUb/sz+L57XXYxGDkdVrPQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MJXa1Q4p6EOLoMuGeudPUixNptiZx1ycu3KE6eSu7qQ/iAozx1HEeZ2RC4JNfXDlr
	 FsoPrGMN0hhUHLv32Bwj+lSODs2TsEMce34F2kPP4vggJ+uNSd5Xq7fxgMrSImkUJx
	 7aP6lj2w74+ZYBpCvgdUf7cn+uycR7hXZmqxvvh5PMa8Bb0/nIdRMPxLaONy6llxDg
	 5kYxvNPdQbYM+DQ/PvF+cCT39CF33DveaPsgzsCn9WgfkBIupqfD6kER5rwJazOyTU
	 OPeU7P548sC7XhD1jtTDRmsiOqMmL61p2LRdosXMzRI1CTK0vWSjdMxRQq1sgk3y0R
	 ZYhrVxbqubwoA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BCDCA0EED;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 28 Aug 2025 17:16:12 +0300
Subject: [PATCH v2 10/15] bcachefs: Fix outdated documentation comment
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-better-progress-v2-10-c088a2003940@gmail.com>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=656; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=Ja5AdRlLz1IgrvsbQ5f5meoJxfm3EYsfj2T8f5z89XA=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDnUuL0//6P4iSLWi/VPLX7q2V9mXB0k37icf3Lnj
 6mPwp6kdpSyMIhxMciKKbJ8WPL1z5pM6z+WQnsNYeawMoEMYeDiFICJ6MQzMmy5LXNp5f2I68Za
 IheKlpdvTl+zLljfpvPrvtRjW1T9WMUY/imxhfQEfVWdFfZ11735Hh829s/a7uYrsuRB33wxC7e
 wm5wA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/bcachefs_format.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index b2de993d802b128cb503740d41028e51c14110ee..0839397105a9d20bcdb99090b508dcff2e0f1886 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -654,7 +654,6 @@ struct bch_sb_field_ext {
 /*
  * field 1:		version name
  * field 2:		BCH_VERSION(major, minor)
- * field 3:		recovery passess required on upgrade
  */
 #define BCH_METADATA_VERSIONS()						\
 	x(bkey_renumber,		BCH_VERSION(0, 10))		\

-- 
2.50.1


