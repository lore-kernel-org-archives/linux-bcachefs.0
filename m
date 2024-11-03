Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B83188736
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Nov 2024 22:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673145; cv=none; b=SqmLnD09xCzmxFzCb/bFP4NiXb8Z07sRU1iA/t1zQXL4BNKPQAR1fL9O4P4ED6B3XXWhXlsjBlo7l9eNUnHD4TXrmwAl88dUOyNDAjibQDzBgGEHk/4Z2JnplB0MAScMdvZ7ALZIKh06NDNwIrYCqgKaAo6hJwMcIU9//MEyVbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673145; c=relaxed/simple;
	bh=U7yQN7uuHol7Q0Zbwpna++BOWr+J0C1+Q9iKy5vHxn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3ksjnI5aZlyzFo0msD0vGU45sSVv9ljLdmFcRrBnUZ4al1TEJjbQGCjpCpgyI4FVQnqezI8CsqtU0s7+vsg9dgei0NnMc3zvuoa4lKPEJsSEQjOleZ2Da+4OL/jlsN4SVPJ8l3dQ/JIKXPNQygPuYyxgl8SzlTzwLtEm4D/r+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rboh1bw4; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rboh1bw4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730673140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uz1pot+lB7c3Gkbz5qFNZOKCKh8a9+P84q91bLcKoA8=;
	b=Rboh1bw4/AMn9fG7TNiZuWu/e8rLEIHgjNVqznNA2PL44+kW/gBzf/y9EQCHWHL/MxOGAj
	pcx7yyU8yiiRBsAMTIdOBU0dRACrw+6KX5pWC/o8ONNnhnvatIr3vIulO8AY3z9+oeEwm6
	8clAmU17VGeb6ERp5sjGo/yzY2Ttjh0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+8a0109511de9d4b61217@syzkaller.appspotmail.com
Subject: [PATCH 3/5] bcachefs: Ancient versions with bad bkey_formats are no longer supported
Date: Sun,  3 Nov 2024 17:32:01 -0500
Message-ID: <20241103223205.176754-4-kent.overstreet@linux.dev>
In-Reply-To: <20241103223205.176754-1-kent.overstreet@linux.dev>
References: <20241103223205.176754-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Syzbot found an assertion pop, by generating an ancient filesystem
version with an invalid bkey_format (with fields that can overflow) as
well as packed keys that aren't representable unpacked.

This breaks key comparisons in all sorts of painful ways.

Filesystems have been automatically rewriting nodes with such invalid
formats for years; we can safely drop support for them.

Reported-by: syzbot+8a0109511de9d4b61217@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bkey.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/bkey.c b/fs/bcachefs/bkey.c
index 587d7318a2e8..995ba32e9b6e 100644
--- a/fs/bcachefs/bkey.c
+++ b/fs/bcachefs/bkey.c
@@ -643,7 +643,7 @@ int bch2_bkey_format_invalid(struct bch_fs *c,
 			     enum bch_validate_flags flags,
 			     struct printbuf *err)
 {
-	unsigned i, bits = KEY_PACKED_BITS_START;
+	unsigned bits = KEY_PACKED_BITS_START;
 
 	if (f->nr_fields != BKEY_NR_FIELDS) {
 		prt_printf(err, "incorrect number of fields: got %u, should be %u",
@@ -655,9 +655,8 @@ int bch2_bkey_format_invalid(struct bch_fs *c,
 	 * Verify that the packed format can't represent fields larger than the
 	 * unpacked format:
 	 */
-	for (i = 0; i < f->nr_fields; i++) {
-		if ((!c || c->sb.version_min >= bcachefs_metadata_version_snapshot) &&
-		    bch2_bkey_format_field_overflows(f, i)) {
+	for (unsigned i = 0; i < f->nr_fields; i++) {
+		if (bch2_bkey_format_field_overflows(f, i)) {
 			unsigned unpacked_bits = bch2_bkey_format_current.bits_per_field[i];
 			u64 unpacked_max = ~((~0ULL << 1) << (unpacked_bits - 1));
 			unsigned packed_bits = min(64, f->bits_per_field[i]);
-- 
2.46.0

