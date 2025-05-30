Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1B428B51A
	for <linux-bcachefs@vger.kernel.org>; Fri, 30 May 2025 22:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748642433; cv=none; b=P5spGZwVw3YS5F7ZzHqtkfX3W1j7Vu0VlgoJknt75hQlhPm4pdc65QqWKU2E5X/aTHvpjt5eL4L1lIb7nuhE2DD+nKanCEstFOTJf4PRosuUAmMhl3QfVqP435YgYCSD8zuJBJTLgtDXllkqowhFRaTlGF2yZf9djFFv13gRNk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748642433; c=relaxed/simple;
	bh=n1vdjX4H6fOupZk0/h2dL+fzcwOJSQvuhM9H3TGycaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZkTYULTkfBsDV/an8omcuWUQzdv/yiBLwt5fkzg2KIZERE/yav1clwphgCdKTBVWXDJka+UXiuAwF8e66tgPImsHQOGMAkDVEE9GuCOGF3WS9K1uOmns+N3GBynV0TDlIaqcfY4hFTtaPw2+8iYhAsQSomMBPHQaKvpPsGDouk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h3PWZQP/; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h3PWZQP/"
Date: Fri, 30 May 2025 18:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748642418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SDARd/7SRGDCC5emopquYxL1jJVUbuyoIAKn0WNzMvY=;
	b=h3PWZQP/1HXUwKK9UG685lwL6kNPSFte6o8jNVOJ+Pc0ur9qE8S1vpXvoxuXILla4tUD3E
	zgbsEmPJzvnUiIuEYxIb/9ASMUcWAWFsxnWwLpnR/TnrTStSkQ4cXcli34fRdyVjsPhsqy
	ueacaKPgVa3anmBD41WHFWsU+gnKUaE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: George Hu <integral@archlinux.org>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: use union for bch_compression_opt to make
 encode & decode easier
Message-ID: <zxcvscosad6yv2y6km3xsdhh26qse3qcx5u66a4nqybev4u64y@uzdekpsliv35>
References: <20250530145243.163974-1-integral@archlinux.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250530145243.163974-1-integral@archlinux.org>
X-Migadu-Flow: FLOW_OUT

On Fri, May 30, 2025 at 10:52:43PM +0800, George Hu wrote:
> Eliminate redundant encode & decode function by using union for
> bch_compression_opt, which reduces code complexity.

order of bitfield members is not fixed, to do this you need #ifdef
__LITTLE_ENDIN_BITFIELD...

> 
> Signed-off-by: George Hu <integral@archlinux.org>
> ---
>  fs/bcachefs/compress.c | 17 +++++++++--------
>  fs/bcachefs/compress.h | 32 +++++++-------------------------
>  fs/bcachefs/extents.c  |  2 +-
>  3 files changed, 17 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
> index 1bca61d17092..10e88e14f5ed 100644
> --- a/fs/bcachefs/compress.c
> +++ b/fs/bcachefs/compress.c
> @@ -336,7 +336,7 @@ static int attempt_compress(struct bch_fs *c,
>  			    void *workspace,
>  			    void *dst, size_t dst_len,
>  			    void *src, size_t src_len,
> -			    struct bch_compression_opt compression)
> +			    union bch_compression_opt compression)
>  {
>  	enum bch_compression_type compression_type =
>  		__bch2_compression_opt_to_type[compression.type];
> @@ -426,7 +426,7 @@ static int attempt_compress(struct bch_fs *c,
>  static unsigned __bio_compress(struct bch_fs *c,
>  			       struct bio *dst, size_t *dst_len,
>  			       struct bio *src, size_t *src_len,
> -			       struct bch_compression_opt compression)
> +			       union bch_compression_opt compression)
>  {
>  	struct bbuf src_data = { NULL }, dst_data = { NULL };
>  	void *workspace;
> @@ -553,7 +553,7 @@ unsigned bch2_bio_compress(struct bch_fs *c,
>  
>  	compression_type =
>  		__bio_compress(c, dst, dst_len, src, src_len,
> -			       bch2_compression_decode(compression_opt));
> +			       (union bch_compression_opt){ .value = compression_opt });
>  
>  	dst->bi_iter.bi_size = orig_dst;
>  	src->bi_iter.bi_size = orig_src;
> @@ -602,7 +602,8 @@ static int __bch2_check_set_has_compressed_data(struct bch_fs *c, u64 f)
>  int bch2_check_set_has_compressed_data(struct bch_fs *c,
>  				       unsigned compression_opt)
>  {
> -	unsigned compression_type = bch2_compression_decode(compression_opt).type;
> +	unsigned int compression_type = ((union bch_compression_opt){ .value = compression_opt })
> +					.type;
>  
>  	BUG_ON(compression_type >= ARRAY_SIZE(bch2_compression_opt_to_feature));
>  
> @@ -683,7 +684,7 @@ static int __bch2_fs_compress_init(struct bch_fs *c, u64 features)
>  
>  static u64 compression_opt_to_feature(unsigned v)
>  {
> -	unsigned type = bch2_compression_decode(v).type;
> +	unsigned int type = ((union bch_compression_opt){ .value = v }).type;
>  
>  	return BIT_ULL(bch2_compression_opt_to_feature[type]);
>  }
> @@ -703,7 +704,7 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
>  {
>  	char *val = kstrdup(_val, GFP_KERNEL);
>  	char *p = val, *type_str, *level_str;
> -	struct bch_compression_opt opt = { 0 };
> +	union bch_compression_opt opt = { 0 };
>  	int ret;
>  
>  	if (!val)
> @@ -736,7 +737,7 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
>  		opt.level = level;
>  	}
>  
> -	*res = bch2_compression_encode(opt);
> +	*res = opt.value;
>  err:
>  	kfree(val);
>  	return ret;
> @@ -744,7 +745,7 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
>  
>  void bch2_compression_opt_to_text(struct printbuf *out, u64 v)
>  {
> -	struct bch_compression_opt opt = bch2_compression_decode(v);
> +	union bch_compression_opt opt = { .value = v };
>  
>  	if (opt.type < BCH_COMPRESSION_OPT_NR)
>  		prt_str(out, bch2_compression_opts[opt.type]);
> diff --git a/fs/bcachefs/compress.h b/fs/bcachefs/compress.h
> index bec2f05bfd52..8cded510b2ac 100644
> --- a/fs/bcachefs/compress.h
> +++ b/fs/bcachefs/compress.h
> @@ -10,41 +10,23 @@ static const unsigned __bch2_compression_opt_to_type[] = {
>  #undef x
>  };
>  
> -struct bch_compression_opt {
> -	u8		type:4,
> -			level:4;
> -};
> -
> -static inline struct bch_compression_opt __bch2_compression_decode(unsigned v)
> -{
> -	return (struct bch_compression_opt) {
> -		.type	= v & 15,
> -		.level	= v >> 4,
> +union bch_compression_opt {
> +	u8 value;
> +	struct {
> +		u8 type:4, level:4;
>  	};
> -}
> +};
>  
>  static inline bool bch2_compression_opt_valid(unsigned v)
>  {
> -	struct bch_compression_opt opt = __bch2_compression_decode(v);
> +	union bch_compression_opt opt = { .value = v };
>  
>  	return opt.type < ARRAY_SIZE(__bch2_compression_opt_to_type) && !(!opt.type && opt.level);
>  }
>  
> -static inline struct bch_compression_opt bch2_compression_decode(unsigned v)
> -{
> -	return bch2_compression_opt_valid(v)
> -		? __bch2_compression_decode(v)
> -		: (struct bch_compression_opt) { 0 };
> -}
> -
> -static inline unsigned bch2_compression_encode(struct bch_compression_opt opt)
> -{
> -	return opt.type|(opt.level << 4);
> -}
> -
>  static inline enum bch_compression_type bch2_compression_opt_to_type(unsigned v)
>  {
> -	return __bch2_compression_opt_to_type[bch2_compression_decode(v).type];
> +	return __bch2_compression_opt_to_type[((union bch_compression_opt){ .value = v }).type];
>  }
>  
>  struct bch_write_op;
> diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
> index 677cf453b332..64419c028662 100644
> --- a/fs/bcachefs/extents.c
> +++ b/fs/bcachefs/extents.c
> @@ -1512,7 +1512,7 @@ int bch2_bkey_ptrs_validate(struct bch_fs *c, struct bkey_s_c k,
>  			const struct bch_extent_rebalance *r = &entry->rebalance;
>  
>  			if (!bch2_compression_opt_valid(r->compression)) {
> -				struct bch_compression_opt opt = __bch2_compression_decode(r->compression);
> +				union bch_compression_opt opt = { .value = r->compression };
>  				prt_printf(err, "invalid compression opt %u:%u",
>  					   opt.type, opt.level);
>  				return -BCH_ERR_invalid_bkey;
> -- 
> 2.49.0
> 
