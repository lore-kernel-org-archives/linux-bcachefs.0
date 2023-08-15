Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF07C04A6A
	for <linux-bcachefs@archiver.kernel.org>; Tue, 15 Aug 2023 00:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbjHOA7N (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 14 Aug 2023 20:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbjHOA6p (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 14 Aug 2023 20:58:45 -0400
Received: from out-111.mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB406A6
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Aug 2023 17:58:43 -0700 (PDT)
Date:   Mon, 14 Aug 2023 20:58:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692061121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXICK0yP3Y4nhx4UcCa96T/gat0/V9JsaX33Bo+8SGw=;
        b=WPKWBVTW8O/1zyA5vT8ZEbYciMj2UUbN7/7bZw1qWnmffh47HqV2l0q32n+fX/yRjERFD2
        1GSc1XbCQ89n6N5jbjSywUxHR+7nuf4Jl96EzwObUzMSJbj3l65H37HBCIgj7yxOza4UCE
        W2ppBvv6Y/pFsoYI3ss2mtL2yNoKeK8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>,
        linux-bcachefs@vger.kernel.org,
        =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Subject: Re: [v4 3/3] bcachefs: Implement casefolding
Message-ID: <20230815005837.figd3mlz7if4w6oo@moria.home.lan>
References: <20230814012434.627641-1-joshua@froggi.es>
 <20230814012434.627641-4-joshua@froggi.es>
 <87v8dh60rd.fsf@suse.de>
 <8ffb410c-ebfc-490c-96d8-8ed72ef8eee2@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ffb410c-ebfc-490c-96d8-8ed72ef8eee2@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Aug 14, 2023 at 10:18:33PM +0100, Joshua Ashton wrote:
> 
> 
> On 8/14/23 17:34, Gabriel Krisman Bertazi wrote:
> > Joshua Ashton <joshua@froggi.es> writes:
> > 
> > > This patch implements support for case-insensitive file name lookups
> > > in bcachefs.
> > > 
> > > The implementation uses the same UTF-8 lowering and normalization that
> > > ext4 and f2fs is using.
> > > 
> > > More information is provided in Documentation/bcachefs/casefolding.rst
> > > 
> > > Signed-off-by: Joshua Ashton <joshua@froggi.es>
> > 
> > Please, cc the entire thread as i don't think I even got the cover
> > letter.
> 
> Thanks, I will for v5.
> 
> > 
> > Did you test this against fstests generic/556?  it checks all sorts of
> > common pitfalls and corner-cases in case-insensitive filesystems.
> 
> No, I wrote my own casefolding test that tests a bunch of edgecases.
> 
> I was not aware there were any casefolding tests in fstests -- I really
> really wish they had better names. :/

Seconded...

> Grepping the test right now I already know we will fail the
> `test_casefold_flag_removal` test as we don't support toggling the flag on
> non-empty directories as it would require rehashing and thus restructuring
> the btree.

What was the motivation for supporting that on other filesystems? I'm
not inclined to add that to bcachefs without a good reason.

> 
> There's a lot of edgecases to handle there (such as hash collisions) which
> are pretty gnarly to solve when doing something like that.
> 
> I diiiid try and implement something that did that, but it really did not
> end well... ^^;; So planning to defer this for now.

What hash collisions are you referring to? The str_hash code we use
handles hash collisions.

> > Why do you want to store the casefolded name?  In ext4, we just store
> > the case-exact name that was created, and do a code-point by code-point
> > comparison with the name under lookup through utf8_strncasecmp, which is
> > optimized to compare two not casefolded strings.  We just modify the
> > filename hash to be case-insensitive, so we know which dirent to look
> > for during lookup.  Finally, we use d_compare/d_hash to leverage the
> > dcache into finding negative dentries.
> 
> Yeah, am aware of how ext4 does it, I just wanted it to have basically the
> exact same performance characteristics as as regular lookup.
> 
> The utf8 cursor stuff in utf8_strncasecmp is still super expensive compared
> to a straight memcmp in some local benching.
> 
> > 
> > Sure, if you have both, dirent and dentry->d_name casefolded, then it is
> > just a regular memcmp, but at least you don't have to change the disk
> > format and your implementation becomes simpler.
> > 
> 
> Given we have the opportunity to have support for this in the dirent format
> for bcachefs, I think it makes sense to take it right now.

It also means that we have the option of defining a casefolding map that
handles ß correctly.
 
> > > +#if IS_ENABLED(CONFIG_UNICODE)
> > > +	struct unicode_map 	*cf_encoding;
> > > +#endif
> > 
> > This goes in struct super_block.
> 
> The code in libfs.c that uses the s_encoding in the super_block is never
> used for bcachefs as it defines its own inode_operations and doesn't use any
> of the libfs common code for lookups/hashes there (ie. the
> dentry_operations).
> 
> One thing we wanted to do down the line was to use the bcachefs options
> system to be able to pick the encoding on a per-inode basis.
> 
> Currently I am storing it in the struct bch_fs as currently there is no need
> for other encodings right now and it is convenient, so there can only be one
> -- but that could change at some point with an opt attached to the inode.
> 
> I am happy to bung it in the vfs super_block for now though -- but I need to
> look at how that all works out with mounting and the multiple drives
> situation. Just be aware that at some point, it will likely be moved back
> again to our code.

We also don't always have a super_block available when we have a running
bch_fs object (e.g. when running in userspace, for fsck and various
other tools). Since s_encoding is used in dirent.c, it probably needs to
be in bch_fs.

> > (Skipping the bcachefs-specific bits that I'm not qualified to review)
> > 
> > I don't get your model for the dcache.  I don't see any handling
> > anywhere in the patch.  Also, I fetched the code and it seems bcachefs
> > will just do d_splice_alias at the end of the lookup. So, when someone
> > lookups FOO, ->lookup will be called and the dentry FOO will be created.
> > Then, when FOo is looked up, the dcache won't find the previous dentry
> > and ->lookup will be called again (perhaps creating another dentry?)
> > 
> > There are two ways around it. Rely on the libfs' generic handlers for
> > d_hash/d_compare and soon d_revalidate, or use d_add_ci to search for
> > case-insensitive aliases at lookup time, but then you don't benefit much
> > from the dcache if looking up for different cases.
> 
> Thanks for the heads-up on this.
> 
> It seems like I may have potentially hit a foot-gun there if we are making
> vfs dentry's for each lookup.
> 
> I will investigate and validate that we are doing the right thing here for
> the next revision.
> 
> I will not lie, I know veeery little about the vfs or dcache side, so huge
> thanks for pointing this out to me. :)
> 
> I had a quick look at what f2fs does here, and it seems like it also just
> does d_splice_alias, but it has the following caveat.

I haven't dug into the dcache stuff yet either (thanks Gabriel for
pointing this out) - but, we'll want to create a dentry not with the
passed in name, but with the name from bch_dirent.

> [f2fs code]
> #if IS_ENABLED(CONFIG_UNICODE)
> 	if (!inode && IS_CASEFOLDED(dir)) {
> 		/* Eventually we want to call d_add_ci(dentry, NULL)
> 		 * for negative dentries in the encoding case as
> 		 * well.  For now, prevent the negative dentry
> 		 * from being cached.
> 		 */
> 		trace_f2fs_lookup_end(dir, dentry, ino, err);
> 		return NULL;
> 	}
> #endif
> 	new = d_splice_alias(inode, dentry);
> 
> I won't even pretend that I understand what a negative dentry is right
> now... :D

A negative dentry is used to indicate a dirent that doesn't exist in
dcache - it means lookups can be cached for dentries that don't exist,
instead of having to call into the filesystem's .lookup() every time.

Gabriel's the one who implemented them for ext4/f2fs, see: https://lwn.net/Articles/929986/
