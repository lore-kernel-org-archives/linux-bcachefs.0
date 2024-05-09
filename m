Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941B57F7F5
	for <linux-bcachefs@vger.kernel.org>; Thu,  9 May 2024 19:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715283148; cv=none; b=WDP6kd/sDI/AxFv7K5M0/+omXC+/zlt2gHiBgx6iXx2Zo80GLkGy3EeZHBnZFh+6NuUO7wU3pBBjsKw57XVxDvbvDC/2ahsbWY2yaOIE0M/5SY8AOXoMxwYwLNvGO8sbvtCmkYC+Xf76RGlvJNW3XjyFO/DD41eOlbIdWp6FGUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715283148; c=relaxed/simple;
	bh=s2TYtBfBeijGY2qR+HyjFf/zHVL+F9y8E+zetnHVtQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQAA4TpIDygaeXYxu/TQcvdvk6uKx9jZognR8bwgfz1KTfg8+8XjYmPPqinChr3kX/MpktP6hsx8UvoRETWSY+HyePpV2cz14HjVsWHoyi3DCNDrONGmh8gblcbyETQqFtjEzUcKThhctqcfn3gsmZhmmLkroNZ3lVLKStxyG08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XploBwL/; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XploBwL/"
Date: Thu, 9 May 2024 15:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715283143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BxtZvAQIwy3tRjZg+7GyLrseN3zxMNyVyd3LKLpf4iQ=;
	b=XploBwL/Z32I6PjY7cwf0f3uPtf1hHELji6r0Lspy1VodilW7lH4NV3TbUff0Cc34+mCaz
	+ZCQmJ71QmJyetKU5wlzMDFlPFYvheKqXK8dtDvUfI7rIPpL5OEN7OYlg/CLhDVNE1uOhz
	e1UdCI6XQby6uNk65uPM97TIC13EXmo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Camila Alvarez <cam.alvarez.i@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+9833a1d29d4a44361e2c@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: guard against invalid bits_per_field in
 bch2_bkey_format_invalid
Message-ID: <ygq5bsdf4suuqp3sfa4lj5ko6afk3kbhtyuo6e6fe6eiwr2uv5@u3igdwmfaful>
References: <20240509014030.671222-1-cam.alvarez.i@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509014030.671222-1-cam.alvarez.i@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 08, 2024 at 09:40:32PM -0400, Camila Alvarez wrote:
> A check for a valid value for bits_per_field is performed for each field before computing packed_max.
> If bits_per_field is invalid for any field the whole format is deemed
> invalid.
> 
> Reported-by: syzbot+9833a1d29d4a44361e2c@syzkaller.appspotmail.com
> Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
> ---
>  fs/bcachefs/bcachefs_format.h |  8 ++++++++
>  fs/bcachefs/bkey.c            | 18 ++++++++++++++++--
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> index d5b90439e581..9e688a8d780f 100644
> --- a/fs/bcachefs/bcachefs_format.h
> +++ b/fs/bcachefs/bcachefs_format.h
> @@ -318,6 +318,14 @@ enum bch_bkey_fields {
>  #define bkey_format_field(name, field)					\
>  	[BKEY_FIELD_##name] = (sizeof(((struct bkey *) NULL)->field) * 8)
>  
> +#define BCH_BKEY_FIELDS()						\
> +	x(INODE,        p.inode)					\
> +	x(OFFSET,       p.offset)					\
> +	x(SNAPSHOT,     p.snapshot)					\
> +	x(SIZE,         size)						\
> +	x(VERSION_HI,   version.hi)					\
> +	x(VERSION_LO,   version.lo)	
> +
>  #define BKEY_FORMAT_CURRENT						\
>  ((struct bkey_format) {							\
>  	.key_u64s	= BKEY_U64s,					\
> diff --git a/fs/bcachefs/bkey.c b/fs/bcachefs/bkey.c
> index 76e79a15ba08..f7847c96a105 100644
> --- a/fs/bcachefs/bkey.c
> +++ b/fs/bcachefs/bkey.c
> @@ -638,6 +638,13 @@ struct bkey_format bch2_bkey_format_done(struct bkey_format_state *s)
>  	return ret;
>  }
>  
> +static unsigned bch2_max_bits_per_field[] = {
> +#define x(name, field) \
> +	bkey_format_field(name, field),
> +	BCH_BKEY_FIELDS()
> +#undef x
> +};
> +
>  int bch2_bkey_format_invalid(struct bch_fs *c,
>  			     struct bkey_format *f,
>  			     enum bkey_invalid_flags flags,
> @@ -659,8 +666,15 @@ int bch2_bkey_format_invalid(struct bch_fs *c,
>  		if (!c || c->sb.version_min >= bcachefs_metadata_version_snapshot) {
>  			unsigned unpacked_bits = bch2_bkey_format_current.bits_per_field[i];
>  			u64 unpacked_max = ~((~0ULL << 1) << (unpacked_bits - 1));
> -			u64 packed_max = f->bits_per_field[i]
> -				? ~((~0ULL << 1) << (f->bits_per_field[i] - 1))
> +			unsigned bits_per_field = f->bits_per_field[i];
> +
> +			if (bits_per_field > bch2_max_bits_per_field[i]) {
> +				prt_printf(err, "field %u uses more bits than allowed: %u > %u",
> +						i, bits_per_field, bch2_max_bits_per_field[i]);
> +				return -BCH_ERR_invalid;
> +			}
> +			u64 packed_max = bits_per_field
> +				? ~((~0ULL << 1) << (bits_per_field - 1))
>  				: 0;
>  			u64 field_offset = le64_to_cpu(f->field_offset[i]);
>  
> -- 
> 2.34.1
> 

Already applied this patch:

commit 61692c7812ab2aca17a3751f6e7798acbdae4b6b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed May 8 10:58:26 2024 -0400

    bcachefs: bch2_bkey_format_field_overflows()
    
    Fix another shift-by-64 by factoring out a common helper for
    bch2_bkey_format_invalid() and bformat_needs_redo() (where it was
    already fixed).
    
    Reported-by: syzbot+9833a1d29d4a44361e2c@syzkaller.appspotmail.com
    Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/bkey.c b/fs/bcachefs/bkey.c
index 76e79a15ba08..952299a2e416 100644
--- a/fs/bcachefs/bkey.c
+++ b/fs/bcachefs/bkey.c
@@ -656,20 +656,17 @@ int bch2_bkey_format_invalid(struct bch_fs *c,
 	 * unpacked format:
 	 */
 	for (i = 0; i < f->nr_fields; i++) {
-		if (!c || c->sb.version_min >= bcachefs_metadata_version_snapshot) {
+		if ((!c || c->sb.version_min >= bcachefs_metadata_version_snapshot) &&
+		    bch2_bkey_format_field_overflows(f, i)) {
 			unsigned unpacked_bits = bch2_bkey_format_current.bits_per_field[i];
 			u64 unpacked_max = ~((~0ULL << 1) << (unpacked_bits - 1));
 			u64 packed_max = f->bits_per_field[i]
 				? ~((~0ULL << 1) << (f->bits_per_field[i] - 1))
 				: 0;
-			u64 field_offset = le64_to_cpu(f->field_offset[i]);
 
-			if (packed_max + field_offset < packed_max ||
-			    packed_max + field_offset > unpacked_max) {
-				prt_printf(err, "field %u too large: %llu + %llu > %llu",
-					   i, packed_max, field_offset, unpacked_max);
-				return -BCH_ERR_invalid;
-			}
+			prt_printf(err, "field %u too large: %llu + %llu > %llu",
+				   i, packed_max, le64_to_cpu(f->field_offset[i]), unpacked_max);
+			return -BCH_ERR_invalid;
 		}
 
 		bits += f->bits_per_field[i];
diff --git a/fs/bcachefs/bkey.h b/fs/bcachefs/bkey.h
index 3a45d128f608..1bb0bd4371b0 100644
--- a/fs/bcachefs/bkey.h
+++ b/fs/bcachefs/bkey.h
@@ -574,6 +574,29 @@ static inline void bch2_bkey_format_add_key(struct bkey_format_state *s, const s
 
 void bch2_bkey_format_add_pos(struct bkey_format_state *, struct bpos);
 struct bkey_format bch2_bkey_format_done(struct bkey_format_state *);
+
+static inline bool bch2_bkey_format_field_overflows(struct bkey_format *f, unsigned i)
+{
+	unsigned f_bits = f->bits_per_field[i];
+	unsigned unpacked_bits = bch2_bkey_format_current.bits_per_field[i];
+	u64 unpacked_mask = ~((~0ULL << 1) << (unpacked_bits - 1));
+	u64 field_offset = le64_to_cpu(f->field_offset[i]);
+
+	if (f_bits > unpacked_bits)
+		return true;
+
+	if ((f_bits == unpacked_bits) && field_offset)
+		return true;
+
+	u64 f_mask = f_bits
+		? ~((~0ULL << (f_bits - 1)) << 1)
+		: 0;
+
+	if (((field_offset + f_mask) & unpacked_mask) < field_offset)
+		return true;
+	return false;
+}
+
 int bch2_bkey_format_invalid(struct bch_fs *, struct bkey_format *,
 			     enum bkey_invalid_flags, struct printbuf *);
 void bch2_bkey_format_to_text(struct printbuf *, const struct bkey_format *);
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 4d94b7742dbb..45984a688e5b 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -975,26 +975,10 @@ static bool migrate_btree_pred(struct bch_fs *c, void *arg,
  */
 static bool bformat_needs_redo(struct bkey_format *f)
 {
-	for (unsigned i = 0; i < f->nr_fields; i++) {
-		unsigned f_bits = f->bits_per_field[i];
-		unsigned unpacked_bits = bch2_bkey_format_current.bits_per_field[i];
-		u64 unpacked_mask = ~((~0ULL << 1) << (unpacked_bits - 1));
-		u64 field_offset = le64_to_cpu(f->field_offset[i]);
-
-		if (f_bits > unpacked_bits)
-			return true;
-
-		if ((f_bits == unpacked_bits) && field_offset)
+	for (unsigned i = 0; i < f->nr_fields; i++)
+		if (bch2_bkey_format_field_overflows(f, i))
 			return true;
 
-		u64 f_mask = f_bits
-			? ~((~0ULL << (f_bits - 1)) << 1)
-			: 0;
-
-		if (((field_offset + f_mask) & unpacked_mask) < field_offset)
-			return true;
-	}
-
 	return false;
 }
 
