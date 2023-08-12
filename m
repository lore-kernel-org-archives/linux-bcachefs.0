Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE302C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 22:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjHLWpI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjHLWpI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 18:45:08 -0400
Received: from out-74.mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59351E7
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 15:45:10 -0700 (PDT)
Date:   Sat, 12 Aug 2023 18:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691880308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clvzmFPpieqHk5gCL9eKOKRWiMQ3wlYRKb7aqBdUbDA=;
        b=b0ffRCfVmCPu2oMxOkyXTwLgmjamhriHRRTXjNICANqgnndw9p+6ehwRgRBY3hnuRpOwZz
        2qwT1PMZpXJRM5MGczSEpjBituEV4DhlYCHp0xhIViK7KN5AgnAyXmNNVSZXaE0znwg8cR
        0QV/KoNBFGnpwgSQkvuWUG5XwefFuYs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org,
        =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [v2 3/3] bcachefs: Implement casefolding
Message-ID: <20230812224506.nplzn2chz63xbiyb@moria.home.lan>
References: <20230812212647.490829-1-joshua@froggi.es>
 <20230812212647.490829-4-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230812212647.490829-4-joshua@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Aug 12, 2023 at 10:26:31PM +0100, Joshua Ashton wrote:
> This patch implements support for case-insensitive file name lookups
> in bcachefs.
> 
> The implementation uses the same UTF-8 lowering and normalization that
> ext4 and f2fs is using currently.
> 
> It uses the regular CASEFOLD attributes and stores the casefolded name
> contiguously with the regular name on disk and in memory if space
> permits it.
> 
> Names that would be too long to fit contiguously are instead compared
> using a folding strcmp.
> 
> There is currently no option provided for selecting the casefolding
> encoding; ext4 and f2fs only support a single encoding per-superblock
> (utf8 12.1), but it would be trivial to extend this on bcachefs on a
> per-inode level using the opts system so it not provided in this patch.
> 
> More information is provided in Documentation/bcachefs/casefolding.rst
> 
> Signed-off-by: Joshua Ashton <joshua@froggi.es>
> 
> Cc: André Almeida <andrealmeid@igalia.com>
> Cc: Gabriel Krisman Bertazi <krisman@suse.de>
> ---
>  .../filesystems/bcachefs/casefolding.rst      |  61 +++++
>  fs/bcachefs/bcachefs.h                        |   8 +
>  fs/bcachefs/bcachefs_format.h                 |  29 ++-
>  fs/bcachefs/dirent.c                          | 220 ++++++++++++++++--
>  fs/bcachefs/dirent.h                          |   6 +-
>  fs/bcachefs/fs-common.c                       |   4 +
>  fs/bcachefs/fs-ioctl.c                        |  23 ++
>  fs/bcachefs/fs-ioctl.h                        |  20 +-
>  fs/bcachefs/fsck.c                            |   8 +-
>  fs/bcachefs/str_hash.h                        |  84 ++++++-
>  fs/bcachefs/super.c                           |  10 +
>  fs/bcachefs/xattr.c                           |   6 +-
>  12 files changed, 429 insertions(+), 50 deletions(-)
>  create mode 100644 Documentation/filesystems/bcachefs/casefolding.rst
> 
> diff --git a/Documentation/filesystems/bcachefs/casefolding.rst b/Documentation/filesystems/bcachefs/casefolding.rst
> new file mode 100644
> index 000000000000..112532a90a1b
> --- /dev/null
> +++ b/Documentation/filesystems/bcachefs/casefolding.rst
> @@ -0,0 +1,61 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Casefolding
> +===========
> +
> +bcachefs has support for case-insensitive file and directory
> +lookups using the regular `chattr +F` (`S_CASEFOLD`, `FS_CASEFOLD_FL`)
> +casefolding attributes.

I see you made it automatically inherited by child directories,
definitely mention that.

Also, other inherited inode options are re-propagated on rename: we're
not for this one (quite reasonably, as we don't want to be rehashing
directories on rename!) but since the behaviour is different from other
inherited options that needs to be documented.

> +The main usecase for casefolding is compatibility with software written
> +against other filesystems that rely on casefolded lookups
> +(eg. NTFS and Wine/Proton).
> +Taking advantage of file-system level casefolding can lead to great
> +loading time gains in many applications and games.
> +
> +On the lookup/query side: casefolding is implemented by allocating a new
> +string of `BCH_NAME_MAX` length using the `utf8_casefold` function to
> +casefold the query string.
> +An allocation is required here as `BCH_NAME_MAX` is quite large ~1.9kb
> +and would not be safe to put on the stack.
> +
> +On the dirent side: casefolding is implemented by ensuring the `bkey`'s
> +hash is made from the casefolded string.
> +If the dirent's regular name and the casefolded name (and lengths) will
> +fit in the dirent key, then the casefolded string will be cached there.
> +The structures looks like this:
> +
> +Regular:    [dirent data][regular name][nul][nul]...
> +Casefolded: [dirent data][reg len][cf len][regular name][casefolded name][nul][nul]...
> +
> +(Do note, the number of `NUL`s here is merely for illustration, they count can vary
> + per-key, and they may not even be present if the key is aligned to `sizeof(u64)`.)
> +
> +If the names are too big to fit in the data of the `bkey`, it will fallback to not
> +caching the name, and instead a casefolding strcmp (`utf8_strncasecmp_folded`)
> +will be used at key comparison (`key_cmp`) time.
> +
> +This is efficient as it means that for 99.9% of typical file lookups
> +that require casefolding, it has identical performance to a regular lookup:
> +a hash comparison and a `memcmp` of the name.

99.9%? I believe we were getting rid of inline casefolding and always
storing the casefolded name in the dirent, did that not quite happen?

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
> +It would be possible to disregard the casefold cache for those cases, but it was
> +decided to simply encode the two string lengths in the key to avoid random
> +performance issues if this edgecase was ever hit.
> +
> +The option settled on was to use a free-bit in d_type to mark a dirent as having
> +a casefold cache, and then treat the first 4 bytes the name block as lengths.
> +You can see this in the `d_cf_name_block` member of union in `bch_dirent`.

Mention the incompatible feature bit, and when it gets set (when this
feature is first used).

> +static struct bch_cf_cache *dirent_prepare_key_casefold(const struct bch_hash_info *hash_info,
> +							const struct qstr *name)
> +{
> +	struct bch_cf_cache *cf_cache __free(bch2_hash_free_cf) = NULL;
> +#if IS_ENABLED(CONFIG_UNICODE)
> +	if (hash_info->cf_encoding != NULL) {
> +		int casefold_len;
> +		cf_cache = bch2_hash_create_cf(hash_info);

Missing allocation failure check - and as discussed on IRC this should
probably be a bch2_trans_kmalloc() allocation.
