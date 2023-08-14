Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF721C001DB
	for <linux-bcachefs@archiver.kernel.org>; Mon, 14 Aug 2023 16:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjHNQfA (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 14 Aug 2023 12:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbjHNQev (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 14 Aug 2023 12:34:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022D2BC
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Aug 2023 09:34:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 88DE01F383;
        Mon, 14 Aug 2023 16:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692030888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/x2Rkam84Y3+pOw2TvQFjTCLdxa2iq6ARleUesXGA28=;
        b=NJeKCRE9f+pQnKqRHQBz8ZkFmt0QH3vmI1bGozWCxrnES1B2+A37+G58NmLS9A9SQJKrPQ
        tcsVU9Er1fZfE0fHq2spvqcZLGmb+s70EJEHZBDHcv+i42ooVAtg0JDTxrVLp1u7Admu9D
        qA+ssqoidkZ9g5CYSGy2cHo2RMA6YbU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692030888;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/x2Rkam84Y3+pOw2TvQFjTCLdxa2iq6ARleUesXGA28=;
        b=DX4LFMfH97BJQffgxmSSc/kVWGSTkp4m4EE15Sv7HVFRPD9zDLQ6cmhqJN8vmquBg5gsl1
        +v26zIgR7K3pbwDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3F25E138EE;
        Mon, 14 Aug 2023 16:34:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0r2kB6hX2mRhNwAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 14 Aug 2023 16:34:48 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org,
        =?utf-8?Q?Andr=C3=A9?= Almeida <andrealmeid@igalia.com>
Subject: Re: [v4 3/3] bcachefs: Implement casefolding
In-Reply-To: <20230814012434.627641-4-joshua@froggi.es> (Joshua Ashton's
        message of "Mon, 14 Aug 2023 02:24:27 +0100")
Organization: SUSE
References: <20230814012434.627641-1-joshua@froggi.es>
        <20230814012434.627641-4-joshua@froggi.es>
Date:   Mon, 14 Aug 2023 12:34:46 -0400
Message-ID: <87v8dh60rd.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Joshua Ashton <joshua@froggi.es> writes:

> This patch implements support for case-insensitive file name lookups
> in bcachefs.
>
> The implementation uses the same UTF-8 lowering and normalization that
> ext4 and f2fs is using.
>
> More information is provided in Documentation/bcachefs/casefolding.rst
>
> Signed-off-by: Joshua Ashton <joshua@froggi.es>

Please, cc the entire thread as i don't think I even got the cover
letter.

Did you test this against fstests generic/556?  it checks all sorts of
common pitfalls and corner-cases in case-insensitive filesystems.

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

Why do you want to store the casefolded name?  In ext4, we just store
the case-exact name that was created, and do a code-point by code-point
comparison with the name under lookup through utf8_strncasecmp, which is
optimized to compare two not casefolded strings.  We just modify the
filename hash to be case-insensitive, so we know which dirent to look
for during lookup.  Finally, we use d_compare/d_hash to leverage the
dcache into finding negative dentries.

Sure, if you have both, dirent and dentry->d_name casefolded, then it is
just a regular memcmp, but at least you don't have to change the disk
format and your implementation becomes simpler.



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
> diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
> index 30b3d7b9f9dc..0e1facdc7876 100644
> --- a/fs/bcachefs/bcachefs.h
> +++ b/fs/bcachefs/bcachefs.h
> @@ -202,6 +202,7 @@
>  #include <linux/types.h>
>  #include <linux/workqueue.h>
>  #include <linux/zstd.h>
> +#include <linux/unicode.h>
>  
>  #include "bcachefs_format.h"
>  #include "errcode.h"
> @@ -657,6 +658,8 @@ enum bch_write_ref {
>  	BCH_WRITE_REF_NR,
>  };
>  
> +#define BCH_FS_DEFAULT_UTF8_ENCODING UNICODE_AGE(12, 1, 0)
> +
>  struct bch_fs {
>  	struct closure		cl;
>  
> @@ -723,6 +726,9 @@ struct bch_fs {
>  		u64		compat;
>  	}			sb;
>  
> +#if IS_ENABLED(CONFIG_UNICODE)
> +	struct unicode_map 	*cf_encoding;
> +#endif

This goes in struct super_block.


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
> +	if (ret <= 0)
> +		return ret;

The error path leaks buf.

> @@ -472,6 +600,7 @@ int __bch2_dirent_lookup_trans(struct btree_trans *trans,
>  			       const struct qstr *name, subvol_inum *inum,
>  			       unsigned flags)
>  {
> +	struct qstr lookup_name = *name;
>  	struct bkey_s_c k;
>  	struct bkey_s_c_dirent d;
>  	u32 snapshot;
> @@ -481,8 +610,14 @@ int __bch2_dirent_lookup_trans(struct btree_trans *trans,
>  	if (ret)
>  		return ret;
>  
> +	ret = hash_info->cf_encoding
> +		? bch2_casefold(trans, hash_info, name, &lookup_name)
> +		: 0;
> +	if (ret)
> +		return ret;
> +
>  	ret = bch2_hash_lookup(trans, iter, bch2_dirent_hash_desc,
> -			       hash_info, dir, name, flags);
> +			       hash_info, dir, &lookup_name, flags);
>  	if (ret)
>  		return ret;


(Skipping the bcachefs-specific bits that I'm not qualified to review)

I don't get your model for the dcache.  I don't see any handling
anywhere in the patch.  Also, I fetched the code and it seems bcachefs
will just do d_splice_alias at the end of the lookup. So, when someone
lookups FOO, ->lookup will be called and the dentry FOO will be created.
Then, when FOo is looked up, the dcache won't find the previous dentry
and ->lookup will be called again (perhaps creating another dentry?)

There are two ways around it. Rely on the libfs' generic handlers for
d_hash/d_compare and soon d_revalidate, or use d_add_ci to search for
case-insensitive aliases at lookup time, but then you don't benefit much
from the dcache if looking up for different cases.


> @@ -54,6 +54,28 @@ static int bch2_inode_flags_set(struct btree_trans *trans,
>  	    (newflags & (BCH_INODE_NODUMP|BCH_INODE_NOATIME)) != newflags)
>  		return -EINVAL;
>  
> +	if ((newflags ^ oldflags) & BCH_INODE_CASEFOLDED) {
> +#if IS_ENABLED(CONFIG_UNICODE)
> +		int ret = 0;
> +		/* Not supported on individual files. */
> +		if (!S_ISDIR(bi->bi_mode))
> +			return -EOPNOTSUPP;
> +
> +		/*
> +		 * Make sure the dir is empty, as otherwise we'd need to
> +		 * rehash everything and update the dirent keys.
> +		 */
> +		ret = bch2_empty_dir_trans(trans, inode_inum(inode));
> +		if (ret < 0)
> +			return ret;
> +
> +		bch2_check_set_feature(c, BCH_FEATURE_casefolding);

fwiw, we use _CASEFOLD in other filesystems, not _casefolding.

Thanks,

-- 
Gabriel Krisman Bertazi
