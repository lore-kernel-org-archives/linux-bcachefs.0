Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0861D554;
	Fri,  2 May 2025 01:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746151000; cv=none; b=aFRyXhAxFJc7Y+kiRlyquNwR999p4jlLFnqJ3+KeOLrb1bmTp27dAnBdSZRq+YqCYsRHVHbv96mL5Qh18Md9ROuJbyeezTwut+Km8MXD4mfZlLsK4+4xH4KK8u1DBgOCLpusmBGLAp4IQYvtGMDswTINLAv54vwNE7xP86x7c9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746151000; c=relaxed/simple;
	bh=oIAA241I10bL+UcbexuTYjT4ifhRDzrM/O1Ae9pQ040=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgYJK2pKcrsrBLvsHD7giV8n57J0LOGR1ADUl5AeqcyudmvUobRPd8vwb9mUPiR5IzE1PqocaTWjOgOJvUmWFsSeL8Ak1hYk1FooqbP6dtv23+ZJ/N98vBZgfIUGJroqQgnWCqetKHzVrxfobfte2vW5LiUstXEVeflOai/Vmrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=NiPfbSem; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sjXWJkAt; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="NiPfbSem";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sjXWJkAt"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1427A11401FB;
	Thu,  1 May 2025 21:56:38 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 01 May 2025 21:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1746150998; x=1746237398; bh=CqPLmB/osf
	3U7LXU6ml8lh57mZM1Snh5zBF/nbIIAeI=; b=NiPfbSemoq7mp0e31OWCFvEyJ5
	UxtVqO48F5AHHJwEUV0YjrCrMprm0NS9pUzt/G3q6u5cJ3X8nrZt8RY0R8l7JPns
	jU5v+uxD/fEnsaZQvVaZYYkSwOhbLv0rrEwHeA1GMcTC3Dj9wQP8DDtUlag6bDzV
	qLeaMM+6FHqifl079Hl4TQsoh1+eiNdHRBfRayqcI4zI8I46VI2UjYnIAJTfdWFb
	DAvpZ5MUNpe4bO9IZdmxuZvS7+2dGcvWzpSXw+QtSqUMxwKZctskQL7vrThbU2K2
	enX9FvzEpeeIqplJkEWbMZsIBg7/gknenIukx6gXy3I7rXPQNV7ZphsAx8BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1746150998; x=1746237398; bh=CqPLmB/osf3U7LXU6ml8lh57mZM1Snh5zBF
	/nbIIAeI=; b=sjXWJkAtkN+VRgcQomaIcg5aDdDUvRPtjQGGtiA4xhuQlcEUXRf
	QKy17qwbHc2D8/C1trHSti8phBfAmPvNLOygluAonBRdXmlWIzI/h0I/9C3jxNpZ
	eieeMS2SI1X7vIK5l62H6pPou0um7ckOAxVfx8KEKLDqNrUPUAkTGaIQ6zIVYheO
	qMNeZLzvAFCArdoepRWnLdMavAXZ0AG/RPMeyi2b2kIOzSX7Tv/rksTX6rhcN/jY
	+CMn60mQsnD/HqWnceO+hnVm7qLig9ZrbRSECQSjafWppwP6y3URsjO6gsQ+JbRF
	vFto1gUhb7xPJvcQitvQZ1xd4ooivwd4QNg==
X-ME-Sender: <xms:VSYUaCWmR_7xh1Li7Q--snBH4rqU9eoY9_CBspHZZdhcGecEdF6apQ>
    <xme:VSYUaOkX2SvEQw4MRly5W7t_vsft-q9myozf3cUrtrNsRAJuImrESd8Tm3i8RizWY
    RU_ugUldm_EN5JNTu8>
X-ME-Received: <xmr:VSYUaGbcFsdb8xC3odfuPSzg-l_80A_p9AKQRKDuiENYd00CyfPX87LAh7OtfJaVaBpJQWwZFOsnY1yFYurfFeLncGFl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvjeduudelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffuc
    dlfedtmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhm
    peflrghnucfjvghnughrihhkucfhrghrrhcuoehkvghrnhgvlhesjhhfrghrrhdrtggtqe
    enucggtffrrghtthgvrhhnpedukeegffdtfeeihfehteevvdeiueetteelgfefvdfhleeu
    feegieduieduhfekieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkvghrnhgvlhesjhhfrghrrhdrtggtpdhnsggprhgtphhtthhopeejpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehmmhhpghhouhhrihguvgesghhmrghilh
    drtghomhdprhgtphhtthhopehkvghnthdrohhvvghrshhtrhgvvghtsehlihhnuhigrdgu
    vghvpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehguh
    hsthgrvhhorghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhhohhrshhtvghn
    rdgslhhumhesthhosghluhigrdgtohhmpdhrtghpthhtoheplhhinhhugidqsggtrggthh
    gvfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqhhgr
    rhguvghnihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:VSYUaJXnqjWQ46tM2yh3u48vc83bJIO25Yj_fwWAlfqfVvh0gKGVEQ>
    <xmx:VSYUaMk8dFWhjExSqq1Wjmsrle9XSwGk594_V9ST6vymdtM0HuCCjQ>
    <xmx:VSYUaOcTTalJlKzH2miIKaBC3DNrGjiO4LSw6jQDy4BtoFjRtqFBSA>
    <xmx:VSYUaOGURHOAAx-5jPs_oOAsboQWB7LYCvCFW6fj4LXEeCCIs6uTTg>
    <xmx:ViYUaF3Rjjj311UZ3LaKZN9LSiH3bppdj2_IwKtHmotMmw2dGOlZtgnE>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 May 2025 21:56:36 -0400 (EDT)
Date: Fri, 2 May 2025 03:56:35 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Alan Huang <mmpgouride@gmail.com>
Cc: kent.overstreet@linux.dev, kees@kernel.org, gustavoars@kernel.org,
	thorsten.blum@toblux.com, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: Rename x_name to x_name_and_value
Message-ID: <aBQmU9xS0exdHoDk@archlinux>
References: <20250501200132.216859-1-mmpgouride@gmail.com>
 <20250501200132.216859-2-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501200132.216859-2-mmpgouride@gmail.com>

On 02 04:01:32, Alan Huang wrote:
> The flexible array contains name and value, the x_name is misleading.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Reviewed-by: Jan Hendrik Farr <kernel@jfarr.cc>

> ---
>  fs/bcachefs/xattr.c        | 16 ++++++++--------
>  fs/bcachefs/xattr.h        |  4 ++--
>  fs/bcachefs/xattr_format.h |  4 ++--
>  3 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> index 3d324e485ee9..b8bc2fb04f15 100644
> --- a/fs/bcachefs/xattr.c
> +++ b/fs/bcachefs/xattr.c
> @@ -38,7 +38,7 @@ static u64 xattr_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
>  	struct bkey_s_c_xattr x = bkey_s_c_to_xattr(k);
>  
>  	return bch2_xattr_hash(info,
> -		 &X_SEARCH(x.v->x_type, x.v->x_name, x.v->x_name_len));
> +		 &X_SEARCH(x.v->x_type, x.v->x_name_and_value, x.v->x_name_len));
>  }
>  
>  static bool xattr_cmp_key(struct bkey_s_c _l, const void *_r)
> @@ -48,7 +48,7 @@ static bool xattr_cmp_key(struct bkey_s_c _l, const void *_r)
>  
>  	return l.v->x_type != r->type ||
>  		l.v->x_name_len != r->name.len ||
> -		memcmp(l.v->x_name, r->name.name, r->name.len);
> +		memcmp(l.v->x_name_and_value, r->name.name, r->name.len);
>  }
>  
>  static bool xattr_cmp_bkey(struct bkey_s_c _l, struct bkey_s_c _r)
> @@ -58,7 +58,7 @@ static bool xattr_cmp_bkey(struct bkey_s_c _l, struct bkey_s_c _r)
>  
>  	return l.v->x_type != r.v->x_type ||
>  		l.v->x_name_len != r.v->x_name_len ||
> -		memcmp(l.v->x_name, r.v->x_name, r.v->x_name_len);
> +		memcmp(l.v->x_name_and_value, r.v->x_name_and_value, r.v->x_name_len);
>  }
>  
>  const struct bch_hash_desc bch2_xattr_hash_desc = {
> @@ -96,7 +96,7 @@ int bch2_xattr_validate(struct bch_fs *c, struct bkey_s_c k,
>  			 c, xattr_invalid_type,
>  			 "invalid type (%u)", xattr.v->x_type);
>  
> -	bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_len),
> +	bkey_fsck_err_on(memchr(xattr.v->x_name_and_value, '\0', xattr.v->x_name_len),
>  			 c, xattr_name_invalid_chars,
>  			 "xattr name has invalid characters");
>  fsck_err:
> @@ -120,13 +120,13 @@ void bch2_xattr_to_text(struct printbuf *out, struct bch_fs *c,
>  	unsigned name_len = xattr.v->x_name_len;
>  	unsigned val_len  = le16_to_cpu(xattr.v->x_val_len);
>  	unsigned max_name_val_bytes = bkey_val_bytes(xattr.k) -
> -		offsetof(struct bch_xattr, x_name);
> +		offsetof(struct bch_xattr, x_name_and_value);
>  
>  	val_len  = min_t(int, val_len, max_name_val_bytes - name_len);
>  	name_len = min(name_len, max_name_val_bytes);
>  
>  	prt_printf(out, "%.*s:%.*s",
> -		   name_len, xattr.v->x_name,
> +		   name_len, xattr.v->x_name_and_value,
>  		   val_len,  (char *) xattr_val(xattr.v));
>  
>  	if (xattr.v->x_type == KEY_TYPE_XATTR_INDEX_POSIX_ACL_ACCESS ||
> @@ -202,7 +202,7 @@ int bch2_xattr_set(struct btree_trans *trans, subvol_inum inum,
>  		xattr->v.x_type		= type;
>  		xattr->v.x_name_len	= namelen;
>  		xattr->v.x_val_len	= cpu_to_le16(size);
> -		memcpy(xattr->v.x_name, name, namelen);
> +		memcpy(xattr->v.x_name_and_value, name, namelen);
>  		memcpy(xattr_val(&xattr->v), value, size);
>  
>  		ret = bch2_hash_set(trans, bch2_xattr_hash_desc, hash_info,
> @@ -270,7 +270,7 @@ static int bch2_xattr_emit(struct dentry *dentry,
>  	if (!prefix)
>  		return 0;
>  
> -	return __bch2_xattr_emit(prefix, xattr->x_name, xattr->x_name_len, buf);
> +	return __bch2_xattr_emit(prefix, xattr->x_name_and_value, xattr->x_name_len, buf);
>  }
>  
>  static int bch2_xattr_list_bcachefs(struct bch_fs *c,
> diff --git a/fs/bcachefs/xattr.h b/fs/bcachefs/xattr.h
> index 132fbbd15a66..1139bf345f70 100644
> --- a/fs/bcachefs/xattr.h
> +++ b/fs/bcachefs/xattr.h
> @@ -18,12 +18,12 @@ void bch2_xattr_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
>  
>  static inline unsigned xattr_val_u64s(unsigned name_len, unsigned val_len)
>  {
> -	return DIV_ROUND_UP(offsetof(struct bch_xattr, x_name) +
> +	return DIV_ROUND_UP(offsetof(struct bch_xattr, x_name_and_value) +
>  			    name_len + val_len, sizeof(u64));
>  }
>  
>  #define xattr_val(_xattr)					\
> -	((void *) (_xattr)->x_name + (_xattr)->x_name_len)
> +	((void *) (_xattr)->x_name_and_value + (_xattr)->x_name_len)
>  
>  struct xattr_search_key {
>  	u8		type;
> diff --git a/fs/bcachefs/xattr_format.h b/fs/bcachefs/xattr_format.h
> index 67426e33d04e..4121b78d9a92 100644
> --- a/fs/bcachefs/xattr_format.h
> +++ b/fs/bcachefs/xattr_format.h
> @@ -16,10 +16,10 @@ struct bch_xattr {
>  	/*
>  	 * x_name contains the name and value counted by
>  	 * x_name_len + x_val_len. The introduction of
> -	 * __counted_by(x_name_len) caused a false positive
> +	 * __counted_by(x_name_len) previously caused a false positive
>  	 * detection of an out of bounds write.
>  	 */
> -	__u8			x_name[];
> +	__u8			x_name_and_value[];
>  } __packed __aligned(8);
>  
>  #endif /* _BCACHEFS_XATTR_FORMAT_H */
> -- 
> 2.48.1
> 
