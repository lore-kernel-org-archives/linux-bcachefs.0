Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC262C001DB
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 18:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjHMSSw (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 14:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjHMSSw (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 14:18:52 -0400
Received: from out-75.mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116EF10C0
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 11:18:54 -0700 (PDT)
Date:   Sun, 13 Aug 2023 14:18:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691950732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A4tcwg13O9RHu3CiigetPHjeBCRptuexeiDhdyeMTtE=;
        b=AvrvKTwI92labbMehIg/Zb3bUeypwCPbsmzASVjHInoF9N8k7KfL+Zo2AOewkb2lkHiIVm
        raxg1bY+tA0mVjtg09bptjuNVxOExLNvXOO5NiaIkYWDeYcraX89vMhM0RHbtH4rys3Ahp
        o1G5YrCXVicIjK9N58duI64bx+Ca0rQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org,
        =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [v3 3/3] bcachefs: Implement casefolding
Message-ID: <20230813181845.ukbrchtfjck3qdcw@moria.home.lan>
References: <20230813173835.195840-1-joshua@froggi.es>
 <20230813173835.195840-4-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813173835.195840-4-joshua@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Aug 13, 2023 at 06:38:27PM +0100, Joshua Ashton wrote:
>  struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d)
>  {
> -	return (struct qstr) QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
> +	unsigned block_len = bch2_dirent_name_bytes(d);
> +	if (d.v->d_casefold) {
> +		unsigned name_len = min_t(unsigned, le16_to_cpu(d.v->d_cf_name_block.d_name_len), block_len);

You need to be validating d_name_len and d_cf_name_len - that they don't
overrun the end of the bkey - in bch2_dirent_invalid(), then you won't
need this min_t here

> +		return (struct qstr) QSTR_INIT(&d.v->d_cf_name_block.d_names[0], name_len);
> +	} else {
> +		unsigned name_len = block_len;
> +		return (struct qstr) QSTR_INIT(d.v->d_name, name_len);
> +	}
> +}
> +
> +struct qstr bch2_dirent_get_casefold_name(struct bkey_s_c_dirent d)
> +{
> +	unsigned block_len = bch2_dirent_name_bytes(d);
> +	if (d.v->d_casefold) {
> +		unsigned name_len = min_t(unsigned, le16_to_cpu(d.v->d_cf_name_block.d_name_len), block_len);
> +		unsigned cf_name_len = min_t(unsigned, le16_to_cpu(d.v->d_cf_name_block.d_cf_name_len), block_len - name_len);

Ditto

> @@ -157,6 +190,24 @@ int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
>  		return -BCH_ERR_invalid_bkey;
>  	}
>  
> +	if (d.v->d_casefold) {
> +#if !IS_ENABLED(CONFIG_UNICODE)
> +		prt_printf(err, "dirent bkey with casefolding without CONFIG_UNICODE");
> +		return -BCH_ERR_invalid_bkey;
> +#endif

This is wrong - failing the .key_invalid() check means the key is
_deleted_, we don't want that to happen just because a kernel config
option was flipped.

> @@ -241,10 +320,19 @@ int bch2_dirent_create(struct btree_trans *trans, subvol_inum dir,
>  		       u8 type, const struct qstr *name, u64 dst_inum,
>  		       u64 *dir_offset, int flags)
>  {
> +	char cf_name_buf[BCH_NAME_MAX + 1];

No, as discussed 512 bytes is too much to stack allocate. And we don't
need a separate buffer here, move the bch2_casefold() call into
dirent_create_key, create it directly in place.

Big unnecessary stack allocations is a major no-no in the kernel, unless
you've _really_ done the analysis and know that it's OK, and usually
it's not. When we call into the btree code that can initiate IO
directly, or we can end up invoking memory reclaim and _that_ can
initiate IO, and btree_trans and our btree_iters have already consumed
as much stack as we're allowed to in our code.

> @@ -294,6 +382,10 @@ int bch2_dirent_rename(struct btree_trans *trans,
>  		const struct qstr *dst_name, subvol_inum *dst_inum, u64 *dst_offset,
>  		enum bch_rename_mode mode)
>  {
> +	char src_cf_name[BCH_NAME_MAX + 1];
> +	char dst_cf_name[BCH_NAME_MAX + 1];

Use bch2_trans_kmalloc() for these.

> @@ -507,16 +611,24 @@ u64 bch2_dirent_lookup(struct bch_fs *c, subvol_inum dir,
>  		       const struct bch_hash_info *hash_info,
>  		       const struct qstr *name, subvol_inum *inum)
>  {
> +	char cf_name[BCH_NAME_MAX + 1];

Ditto, use bch2_trans_kmalloc().

> diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
> index bb5305441f27..9649872797da 100644
> --- a/fs/bcachefs/fs-common.c
> +++ b/fs/bcachefs/fs-common.c
> @@ -46,6 +46,10 @@ int bch2_create_trans(struct btree_trans *trans,
>  	if (ret)
>  		goto err;
>  
> +	/* Inherit casefold state from parent. */
> +	if (dir_type == DT_DIR && (dir_u->bi_flags & BCH_INODE_CASEFOLDED))
> +		new_inode->bi_flags |= BCH_INODE_CASEFOLDED;

if (S_ISDIR(mode))
	new_inode->bi_flags |= dir_u->bi_flags & BCH_INODE_CASEFOLDED;

How have you tested it so far?
