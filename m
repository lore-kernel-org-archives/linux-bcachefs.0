Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E1BC001B0
	for <linux-bcachefs@archiver.kernel.org>; Tue, 15 Aug 2023 12:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbjHOMem (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 15 Aug 2023 08:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237271AbjHOMeV (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 15 Aug 2023 08:34:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84AC19B4
        for <linux-bcachefs@vger.kernel.org>; Tue, 15 Aug 2023 05:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692102783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kfiD0C27rHiSjCZ7pupbA2nLVMOp1AGD1WgQuwUPNPs=;
        b=Ulz58PU3JxgJyVpiO1rkPEPmEATe0Ubdl51a2FalpL3yMMEWRBLeAINTylEqIJGfFwhFCX
        thyeufi7ay6S/uPCzQqnancVmdU7Cm7EjE2H1L01CJKtzs2bHtVm3G6lvWwFppSCPMD2qv
        F85ieKSr1YjJfM6XMZhHfgu8boJOp04=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-J_adAVNDOtCba3v5OgbJhw-1; Tue, 15 Aug 2023 08:33:01 -0400
X-MC-Unique: J_adAVNDOtCba3v5OgbJhw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-767564705f5so602871285a.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 15 Aug 2023 05:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692102781; x=1692707581;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kfiD0C27rHiSjCZ7pupbA2nLVMOp1AGD1WgQuwUPNPs=;
        b=CkK6ovjkxHWF42cK4bR7IN2YpTwLyH3jYbJM6hK+I4RbqSu7b78pbvFwjCtxrED2G0
         2UKfu5L2ob57rbAGTAq+SmL/G5iAGpnYk1I1polLA1BwblaiPZf/D7+fqfaZK9rg4XCE
         6e50cCChvyc7T6QpxxyeDTq2n4oiHmZt5BOIhoxdlu+mtK/p5e4Si/mJ5wvxs2HHKuRM
         Z7VIdk0xpPuhFnpzQpGK1JXi5pshHCW17FB1cf49pV+HR8oCAimnOy1+vSY91QS/YAnJ
         6Dls2bAmu39aEWYHjhT/qPCxov41u/la3WUAJ8YeST2nwerNQPYq4YJpbrDL8OLGcIsj
         V4wQ==
X-Gm-Message-State: AOJu0YzCYS5fHm3qiIijEMyCxMG3KzrgBBuBwDPi/5fCRieqEHUgWAA6
        AxVFADlvsux4mR9O0I2LQKuczi372qvsHucfvb4iVHqfs9n4mCgW/326caceszTDnhg/e5LPt/U
        hb4kQ8InI+g7UslE/jB8bYLC9+jk=
X-Received: by 2002:a05:620a:2449:b0:767:954:a743 with SMTP id h9-20020a05620a244900b007670954a743mr15953118qkn.51.1692102781167;
        Tue, 15 Aug 2023 05:33:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5AXPUZ+m+G9InvzR3SJ7JT96UuoBJK9SbXniYv8UvJ113dRC7e1d59iCLH221K8x4EBf97Q==
X-Received: by 2002:a05:620a:2449:b0:767:954:a743 with SMTP id h9-20020a05620a244900b007670954a743mr15953095qkn.51.1692102780805;
        Tue, 15 Aug 2023 05:33:00 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id g3-20020a05620a13c300b0075cd80fde9esm3714172qkl.89.2023.08.15.05.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 05:33:00 -0700 (PDT)
Date:   Tue, 15 Aug 2023 08:36:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org,
        =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [v4 3/3] bcachefs: Implement casefolding
Message-ID: <ZNtxM447DrmJDA3W@bfoster>
References: <20230814012434.627641-1-joshua@froggi.es>
 <20230814012434.627641-4-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230814012434.627641-4-joshua@froggi.es>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Aug 14, 2023 at 02:24:27AM +0100, Joshua Ashton wrote:
> This patch implements support for case-insensitive file name lookups
> in bcachefs.
> 
> The implementation uses the same UTF-8 lowering and normalization that
> ext4 and f2fs is using.
> 
> More information is provided in Documentation/bcachefs/casefolding.rst
> 
> Signed-off-by: Joshua Ashton <joshua@froggi.es>
> 
> Cc: André Almeida <andrealmeid@igalia.com>
> Cc: Gabriel Krisman Bertazi <krisman@suse.de>
> ---

Hi Joshua,

I'm still grokking the implementation and I see Gabriel has already
provided much more substantive feedback, so just a few random comments...

>  .../filesystems/bcachefs/casefolding.rst      |  73 ++++++++
>  fs/bcachefs/bcachefs.h                        |   6 +
>  fs/bcachefs/bcachefs_format.h                 |  26 ++-
>  fs/bcachefs/dirent.c                          | 177 +++++++++++++++---
>  fs/bcachefs/fs-common.c                       |   4 +
>  fs/bcachefs/fs-ioctl.c                        |  22 +++
>  fs/bcachefs/fs-ioctl.h                        |  20 +-
>  fs/bcachefs/str_hash.h                        |   4 +
>  fs/bcachefs/super.c                           |  19 ++
>  9 files changed, 318 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/filesystems/bcachefs/casefolding.rst
> 
> diff --git a/Documentation/filesystems/bcachefs/casefolding.rst b/Documentation/filesystems/bcachefs/casefolding.rst
> new file mode 100644
> index 000000000000..c8580d892ae8
> --- /dev/null
> +++ b/Documentation/filesystems/bcachefs/casefolding.rst
> @@ -0,0 +1,73 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Casefolding
> +===========
> +
> +bcachefs has support for case-insensitive file and directory
> +lookups using the regular `chattr +F` (`S_CASEFOLD`, `FS_CASEFOLD_FL`)
> +casefolding attributes.
> +
> +The main usecase for casefolding is compatibility with software written
> +against other filesystems that rely on casefolded lookups
> +(eg. NTFS and Wine/Proton).
> +Taking advantage of file-system level casefolding can lead to great
> +loading time gains in many applications and games.
> +
> +Casefolding support requires a kernel with the `CONFIG_UNICODE` enabled.
> +Once a directory has been flagged for casefolding, a feature bit
> +is enabled on the superblock which marks the filesystem as using
> +casefolding.
> +When the feature bit for casefolding is enabled, it is no longer possible
> +to mount that filesystem on kernels without `CONFIG_UNICODE` enabled.
> +
> +On the lookup/query side: casefolding is implemented by allocating a new
> +string of `BCH_NAME_MAX` length using the `utf8_casefold` function to
> +casefold the query string.
> +
> +On the dirent side: casefolding is implemented by ensuring the `bkey`'s
> +hash is made from the casefolded string and storing the cached casefolded
> +name with the regular name in the dirent.
> +
> +The structure looks like this:
> +
> +Regular:    [dirent data][regular name][nul][nul]...
> +Casefolded: [dirent data][reg len][cf len][regular name][casefolded name][nul][nul]...
> +
> +(Do note, the number of `NUL`s here is merely for illustration, they count can vary
> + per-key, and they may not even be present if the key is aligned to `sizeof(u64)`.)
> +
> +This is efficient as it means that for all file lookups that require casefolding,
> +it has identical performance to a regular lookup:
> +a hash comparison and a `memcmp` of the name.
> +

Thanks for the writeup. This is very helpful.

> +Rationale
> +---------
> +
> +Several designs were considered for this system:
> +One was to introduce a dirent_v2, however that would be painful especially as
> +the hash system only has support for a single key type. This would also need
> +`BCH_NAME_MAX` to change between versions, and a new feature bit.
> +
> +Another option was to store without the two lengths, and just take the length of
> +the regular name and casefolded name contiguously / 2 as the length. This would
> +assume that the regular length == casefolded length, but that could potentially
> +not be true, if the uppercase unicode glyph had a different UTF-8 encoding than
> +the lowercase unicode glyph.
> +It would be possible to disregard the casefold cache for those cases, but it was
> +decided to simply encode the two string lengths in the key to avoid random
> +performance issues if this edgecase was ever hit.
> +
> +The option settled on was to use a free-bit in d_type to mark a dirent as having
> +a casefold cache, and then treat the first 4 bytes the name block as lengths.
> +You can see this in the `d_cf_name_block` member of union in `bch_dirent`.
> +
> +The feature bit was used to allow casefolding support to be enabled for the majority
> +of users, but some allow users who have no need for the feature to still use bcachefs as
> +`CONFIG_UNICODE` can increase the kernel side a significant amount due to the tables used,
> +which may be decider between using bcachefs for eg. embedded platforms.
> +
> +Other filesystems like ext4 and f2fs have a super-block level option for casefolding
> +encoding, but bcachefs currently does not provide this. ext4 and f2fs do not expose
> +any encodings than a single UTF-8 version. When future encodings are desirable,
> +they will be added trivially using the opts mechanism.
> +
...
> diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> index 23bae622309c..cc6797422977 100644
> --- a/fs/bcachefs/bcachefs_format.h
> +++ b/fs/bcachefs/bcachefs_format.h
...
> @@ -864,6 +866,7 @@ enum {
>  #define BCH_INODE_I_SECTORS_DIRTY (1 << __BCH_INODE_I_SECTORS_DIRTY)
>  #define BCH_INODE_UNLINKED	(1 << __BCH_INODE_UNLINKED)
>  #define BCH_INODE_BACKPTR_UNTRUSTED (1 << __BCH_INODE_BACKPTR_UNTRUSTED)
> +#define BCH_INODE_CASEFOLDED	(1 << __BCH_INODE_CASEFOLDED)
>  
>  LE32_BITMASK(INODE_STR_HASH,	struct bch_inode, bi_flags, 20, 24);
>  LE32_BITMASK(INODE_NR_FIELDS,	struct bch_inode, bi_flags, 24, 31);
> @@ -908,9 +911,25 @@ struct bch_dirent {
>  	 * Copy of mode bits 12-15 from the target inode - so userspace can get
>  	 * the filetype without having to do a stat()
>  	 */
> -	__u8			d_type;
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +	__u8			d_type:5,
> +				d_unused:2,
> +				d_casefold:1;
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +	__u8			d_casefold:1,
> +				d_unused:2,
> +				d_type:5;
> +#endif

Interesting. I didn't realize that bitfield endianness matched general
endianness, so I presume this is required to ensure data is always le on
disk.

>  
> -	__u8			d_name[];
> +	union {
> +	struct {
> +		__u8		d_pad;
> +		__le16		d_name_len;
> +		__le16		d_cf_name_len;
> +		__u8		d_names[0];
> +	} d_cf_name_block __packed;
> +	__u8			d_name[0];
> +	} __packed;
>  } __packed __aligned(8);
>  
>  #define DT_SUBVOL	16
> @@ -1841,7 +1860,8 @@ static inline void SET_BCH_SB_BACKGROUND_COMPRESSION_TYPE(struct bch_sb *sb, __u
>  	x(new_varint,			15)	\
>  	x(journal_no_flush,		16)	\
>  	x(alloc_v2,			17)	\
> -	x(extents_across_btree_nodes,	18)
> +	x(extents_across_btree_nodes,	18)	\
> +	x(casefolding,			19)
>  
>  #define BCH_SB_FEATURES_ALWAYS				\
>  	((1ULL << BCH_FEATURE_new_extent_overwrite)|	\
> diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
> index 6bdcccabd732..6ac45d7ce6e9 100644
> --- a/fs/bcachefs/dirent.c
> +++ b/fs/bcachefs/dirent.c
> @@ -13,8 +13,39 @@
>  
>  #include <linux/dcache.h>
>  
> -static inline unsigned dirent_val_u64s(unsigned len)
> +static inline int bch2_casefold(struct btree_trans *trans, const struct bch_hash_info *info,
> +				const struct qstr *str, struct qstr *out_cf)
>  {
> +#if IS_ENABLED(CONFIG_UNICODE)
> +	unsigned char *buf = NULL;
> +	int ret;
> +
> +	*out_cf = (struct qstr) QSTR_INIT(NULL, 0);
> +
> +	buf = bch2_trans_kmalloc(trans, BCH_NAME_MAX + 1);
> +	ret = PTR_ERR_OR_ZERO(buf);
> +	if (ret)
> +		return ret;
> +
> +	ret = utf8_casefold(info->cf_encoding, str, buf, BCH_NAME_MAX + 1);

Looks like this helper really only needs the encoding pointer rather
than the full hash_info..?

> +	if (ret <= 0)
> +		return ret;
> +
> +	*out_cf = (struct qstr) QSTR_INIT(buf, ret);
> +	return 0;
> +#else
> +	*out_cf = (struct qstr) QSTR_INIT(NULL, 0);
> +
> +	return -EOPNOTSUPP;
> +#endif

It also looks like the #else could be completely avoided here. For
example, lift the local vars out of the ifdef, init out_cf using the
NULL buf, init ret to -EOPNOTSUPP and push 'return ret;' out of the end
of the ifdef. Hm?

> +}
> +
> +static inline unsigned dirent_val_u64s(unsigned len, unsigned cf_len)
> +{
> +	if (cf_len > 0) {
> +		return DIV_ROUND_UP(offsetof(struct bch_dirent, d_cf_name_block.d_names) + len + cf_len,
> +				    sizeof(u64));
> +	}
>  	return DIV_ROUND_UP(offsetof(struct bch_dirent, d_name) + len,
>  			    sizeof(u64));

FWIW, I think something along the lines of the pattern you use just
below makes this a bit more readable. For example, something like:

        unsigned name_offset;
        name_offset = (cf_len > 0) ?
                        offsetof(struct bch_dirent, d_cf_name_block.d_names) :
                        offsetof(struct bch_dirent, d_name);
        return DIV_ROUND_UP(name_offset + len + cf_len, sizeof(u64));

... but just a thought.

>  }
...
>  /* bcachefs inode flags -> FS_IOC_FSGETXATTR: */
> diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
> index ae21a8cca1b4..866cfc145889 100644
> --- a/fs/bcachefs/str_hash.h
> +++ b/fs/bcachefs/str_hash.h
> @@ -34,6 +34,7 @@ bch2_str_hash_opt_to_type(struct bch_fs *c, enum bch_str_hash_opts opt)
>  
>  struct bch_hash_info {
>  	u8			type;
> +	struct unicode_map 	*cf_encoding;
>  	/*
>  	 * For crc32 or crc64 string hashes the first key value of
>  	 * the siphash_key (k0) is used as the key.
> @@ -48,6 +49,9 @@ bch2_hash_info_init(struct bch_fs *c, const struct bch_inode_unpacked *bi)
>  	struct bch_hash_info info = {
>  		.type = (bi->bi_flags >> INODE_STR_HASH_OFFSET) &
>  			~(~0U << INODE_STR_HASH_BITS),
> +#if IS_ENABLED(CONFIG_UNICODE)
> +		.cf_encoding = !!(bi->bi_flags & BCH_INODE_CASEFOLDED) ? c->cf_encoding : NULL,
> +#endif

What's the purpose for propagating this pointer via the hash? Is this
necessary to (eventually) support per-directory encodings, or something
else? If purely the former and that is something to possibly come later,
it does seem a little premature to me in that the infrastructure part
should probably go along with the feature functionality that takes
advantage of it.

BTW on a similar train of thought.. I'm not familiar enough with the
feature to have an opinion on Gabriel's feedback wrt to storing the
casefolded name on-disk, but I do think there's value in breaking down
the feature into smaller logical components, particularly when there are
performance vs. complexity tradeoffs. So for example if you wanted to
continue to implement the on-disk format change approach, perhaps factor
out core functionality along the lines of what ext4 does into a patch 1,
then add the on-disk format change support in patch 2 as an (optional?)
optimization (then lift off the per-dir bits into later patches that
implement the granular approach, etc.).

That not only makes this easier to review, but IMO significantly easier
to maintain, test, diagnose, etc., such that it's at least worth
considering. Just my .02.

Brian

>  		.siphash_key = { .k0 = bi->bi_hash_seed }
>  	};
>  
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index 5c62fcf3afdb..78d19cfb966a 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -757,6 +757,25 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
>  	if (ret)
>  		goto err;
>  
> +#if IS_ENABLED(CONFIG_UNICODE)
> +	/* Default encoding until we can potentially have more as an option. */
> +	c->cf_encoding = utf8_load(BCH_FS_DEFAULT_UTF8_ENCODING);
> +	if (IS_ERR(c->cf_encoding)) {
> +		printk(KERN_ERR "Cannot load UTF-8 encoding for filesystem. Version: %u.%u.%u",
> +			unicode_major(BCH_FS_DEFAULT_UTF8_ENCODING),
> +			unicode_minor(BCH_FS_DEFAULT_UTF8_ENCODING),
> +			unicode_rev(BCH_FS_DEFAULT_UTF8_ENCODING));
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +#else
> +	if (c->sb.features & (1ULL << BCH_FEATURE_casefolding)) {
> +		printk(KERN_ERR "Cannot mount a filesystem with casefolding on a kernel without CONFIG_UNICODE\n");
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +#endif
> +
>  	pr_uuid(&name, c->sb.user_uuid.b);
>  	strscpy(c->name, name.buf, sizeof(c->name));
>  	printbuf_exit(&name);
> -- 
> 2.41.0
> 

