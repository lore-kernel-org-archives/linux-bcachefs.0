Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD071EB9E3
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506388; cv=none; b=YeDUOK8d+AgU0OlI1k/AyvGa5w6dmTfnfRXopP/fnmU1DJHy9yd532LDnRf7kw+ZU94pM8tOw7PB7nHnTNg7Z3W3r/nqTz8WMeERf29TJ514IymYrquNq4s03DG5Do/ibqczYqBnb5Oo7JWWAnlywZH6SWSEI24wYYsEtWD0/Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506388; c=relaxed/simple;
	bh=jmWf6OEuwV0iwqzQenyvr6onbRbNohfAu3MctxAiGos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfdv2NyRCTjktEv6yYFwGjCJ3nIOGxBG4TuHdDILiTBXmY94knKZyw2lvubCjVROSBXWvrAzqGGFvaB/jk+nbh0l+8YP5AD9P0aiMu7y9z79t05x1C8sxdKneUuVmf5og2NbEj2ut4HRAl4HkV9o5RbCCWE84z4xfVvdV9bpvbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cs7TQtFD; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cs7TQtFD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zjgDV7+jK2Y/4+UqPgGDOmVMcW0Ut5jdovpS/5QmUEY=;
	b=Cs7TQtFDjBIidFQVD21jv5D07/gT9g6g7KuP0omuD4HNCsr6d+To9Sy33MEycLAtpromSN
	QgJuPhwzUZlvlA7M184e2et+UIcIpTTKYbX9YjicI7BzvbYWqfAPfokbR/Ko4NH9of0LOf
	va4Mz4VCewCsIroKr4pKStwzODNbZaI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/5] bcachefs: Fix kmsan warnings in bch2_extent_crc_pack()
Date: Thu, 20 Mar 2025 17:32:50 -0400
Message-ID: <20250320213256.3359777-3-kent.overstreet@linux.dev>
In-Reply-To: <20250320213256.3359777-1-kent.overstreet@linux.dev>
References: <20250320213256.3359777-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We store to all fields, so the kmsan warnings were spurious - but
initializing via stores to bitfields appear to have been giving the
compiler/kmsan trouble, and they're not necessary.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extents.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 04946d9911f5..ae1a1d917805 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -592,29 +592,35 @@ static void bch2_extent_crc_pack(union bch_extent_crc *dst,
 				 struct bch_extent_crc_unpacked src,
 				 enum bch_extent_entry_type type)
 {
-#define set_common_fields(_dst, _src)					\
-		_dst.type		= 1 << type;			\
-		_dst.csum_type		= _src.csum_type,		\
-		_dst.compression_type	= _src.compression_type,	\
-		_dst._compressed_size	= _src.compressed_size - 1,	\
-		_dst._uncompressed_size	= _src.uncompressed_size - 1,	\
-		_dst.offset		= _src.offset
+#define common_fields(_src)						\
+		.type			= BIT(type),			\
+		.csum_type		= _src.csum_type,		\
+		.compression_type	= _src.compression_type,	\
+		._compressed_size	= _src.compressed_size - 1,	\
+		._uncompressed_size	= _src.uncompressed_size - 1,	\
+		.offset			= _src.offset
 
 	switch (type) {
 	case BCH_EXTENT_ENTRY_crc32:
-		set_common_fields(dst->crc32, src);
-		dst->crc32.csum		= (u32 __force) *((__le32 *) &src.csum.lo);
+		dst->crc32		= (struct bch_extent_crc32) {
+			common_fields(src),
+			.csum		= (u32 __force) *((__le32 *) &src.csum.lo),
+		};
 		break;
 	case BCH_EXTENT_ENTRY_crc64:
-		set_common_fields(dst->crc64, src);
-		dst->crc64.nonce	= src.nonce;
-		dst->crc64.csum_lo	= (u64 __force) src.csum.lo;
-		dst->crc64.csum_hi	= (u64 __force) *((__le16 *) &src.csum.hi);
+		dst->crc64		= (struct bch_extent_crc64) {
+			common_fields(src),
+			.nonce		= src.nonce,
+			.csum_lo	= (u64 __force) src.csum.lo,
+			.csum_hi	= (u64 __force) *((__le16 *) &src.csum.hi),
+		};
 		break;
 	case BCH_EXTENT_ENTRY_crc128:
-		set_common_fields(dst->crc128, src);
-		dst->crc128.nonce	= src.nonce;
-		dst->crc128.csum	= src.csum;
+		dst->crc128		= (struct bch_extent_crc128) {
+			common_fields(src),
+			.nonce		= src.nonce,
+			.csum		= src.csum,
+		};
 		break;
 	default:
 		BUG();
-- 
2.49.0

