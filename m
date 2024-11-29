Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B871A38EC
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912100; cv=none; b=oOcbobG0zxh2QAlu4PT+OoBSSQc5Z/sHXItnTMx3qqOLoFXchwJwIs2BMAgTeb4dVG1KrNdgAtGUrebForyOV9Bsal1eV48RSZzWNTfhkfvO5XwWhzlFI9miGFIsQT4r6k4f8ae95k91icp57NynHjJ9NOZaaZtrzVE7Fow8ga0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912100; c=relaxed/simple;
	bh=hbMCM3KiQffWm8cNX4RuTDzCeSsb7Md79EyJfI5BTRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJ7Cuj5WzL7BygG4zd4WrXaljhNMtJyk9U6q8axlwXdhSmrt9APUHoYYHG2a1hWBp8qZuCpd07VL/omRVifVgcAHV6Dd4roZQKzz+9zDtInsyKGW5/ZJO4esxSU0TxwzD0lfSEOZXW4StCRZ00lRQbesp6PJHX5vGxeoP6mtMTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+50d3544c9b8db9c99fd2@syzkaller.appspotmail.com
Subject: [PATCH 33/34] bcachefs: Check for extent crc uncompressed/compressed size mismatch
Date: Fri, 29 Nov 2024 15:27:32 -0500
Message-ID: <20241129202736.2713679-34-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When not compressed, these must be equal - this fixes an assertion pop
in bch2_rechecksum_bio().

Reported-by: syzbot+50d3544c9b8db9c99fd2@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extents.c          | 22 +++++++++++++---------
 fs/bcachefs/sb-errors_format.h |  5 +++--
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index aa3b88291814..2fc9ace5533c 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1323,9 +1323,6 @@ int bch2_bkey_ptrs_validate(struct bch_fs *c, struct bkey_s_c k,
 		case BCH_EXTENT_ENTRY_crc128:
 			crc = bch2_extent_crc_unpack(k.k, entry_to_crc(entry));
 
-			bkey_fsck_err_on(crc.offset + crc.live_size > crc.uncompressed_size,
-					 c, ptr_crc_uncompressed_size_too_small,
-					 "checksum offset + key size > uncompressed size");
 			bkey_fsck_err_on(!bch2_checksum_type_valid(c, crc.csum_type),
 					 c, ptr_crc_csum_type_unknown,
 					 "invalid checksum type");
@@ -1333,6 +1330,19 @@ int bch2_bkey_ptrs_validate(struct bch_fs *c, struct bkey_s_c k,
 					 c, ptr_crc_compression_type_unknown,
 					 "invalid compression type");
 
+			bkey_fsck_err_on(crc.offset + crc.live_size > crc.uncompressed_size,
+					 c, ptr_crc_uncompressed_size_too_small,
+					 "checksum offset + key size > uncompressed size");
+			bkey_fsck_err_on(crc_is_encoded(crc) &&
+					 (crc.uncompressed_size > c->opts.encoded_extent_max >> 9) &&
+					 (from.flags & (BCH_VALIDATE_write|BCH_VALIDATE_commit)),
+					 c, ptr_crc_uncompressed_size_too_big,
+					 "too large encoded extent");
+			bkey_fsck_err_on(!crc_is_compressed(crc) &&
+					 crc.compressed_size != crc.uncompressed_size,
+					 c, ptr_crc_uncompressed_size_mismatch,
+					 "not compressed but compressed != uncompressed size");
+
 			if (bch2_csum_type_is_encryption(crc.csum_type)) {
 				if (nonce == UINT_MAX)
 					nonce = crc.offset + crc.nonce;
@@ -1346,12 +1356,6 @@ int bch2_bkey_ptrs_validate(struct bch_fs *c, struct bkey_s_c k,
 					 "redundant crc entry");
 			crc_since_last_ptr = true;
 
-			bkey_fsck_err_on(crc_is_encoded(crc) &&
-					 (crc.uncompressed_size > c->opts.encoded_extent_max >> 9) &&
-					 (from.flags & (BCH_VALIDATE_write|BCH_VALIDATE_commit)),
-					 c, ptr_crc_uncompressed_size_too_big,
-					 "too large encoded extent");
-
 			size_ondisk = crc.compressed_size;
 			break;
 		case BCH_EXTENT_ENTRY_stripe_ptr:
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 342eda8ab69f..3bbda181f314 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -172,10 +172,11 @@ enum bch_fsck_flags {
 	x(ptr_bucket_data_type_mismatch,			155,	0)		\
 	x(ptr_cached_and_erasure_coded,				156,	0)		\
 	x(ptr_crc_uncompressed_size_too_small,			157,	0)		\
+	x(ptr_crc_uncompressed_size_too_big,			161,	0)		\
+	x(ptr_crc_uncompressed_size_mismatch,			300,	0)		\
 	x(ptr_crc_csum_type_unknown,				158,	0)		\
 	x(ptr_crc_compression_type_unknown,			159,	0)		\
 	x(ptr_crc_redundant,					160,	0)		\
-	x(ptr_crc_uncompressed_size_too_big,			161,	0)		\
 	x(ptr_crc_nonce_mismatch,				162,	0)		\
 	x(ptr_stripe_redundant,					163,	0)		\
 	x(reservation_key_nr_replicas_invalid,			164,	0)		\
@@ -310,7 +311,7 @@ enum bch_fsck_flags {
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
 	x(compression_opt_not_marked_in_sb,			295,	FSCK_AUTOFIX)	\
 	x(compression_type_not_marked_in_sb,			296,	FSCK_AUTOFIX)	\
-	x(MAX,							300,	0)
+	x(MAX,							301,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.45.2

