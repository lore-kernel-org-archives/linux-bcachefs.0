Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D93FC001B0
	for <linux-bcachefs@archiver.kernel.org>; Mon, 14 Aug 2023 23:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbjHNXCE (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 14 Aug 2023 19:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbjHNXCC (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 14 Aug 2023 19:02:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938E110CE
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Aug 2023 16:02:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5382F21982;
        Mon, 14 Aug 2023 23:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692054120; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iKE3rUWqcgcFo1VrB55Gpvr5Bthbi03ES7AUEFvfe9s=;
        b=Eaa3vK5oZsYKnkriSnZgTdQCCuHPpKPh1V6fAgXOpkWmn04vj76DQlY1/hy2NLNb0NhD3H
        YhDlbon4MDp2cVrG0CvHflG0UwRLMhv1U0vEyslyTVjIZsHsL/8j1n0efdGTANykx8/s0l
        fsJb7cJpEKOi/Ob4JpdgliYf9aqHYUQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692054120;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iKE3rUWqcgcFo1VrB55Gpvr5Bthbi03ES7AUEFvfe9s=;
        b=c0U2JZrnzTpG772kpjc+9yn3MrHeeNbQP8lcuZJwLZdTWweghDnn/rWyhxIy27c36dKADx
        z6kaHd7dcaNHJfBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1A928138E2;
        Mon, 14 Aug 2023 23:02:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id E9qIAGiy2mSjTAAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 14 Aug 2023 23:02:00 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org,
        =?utf-8?Q?Andr=C3=A9?= Almeida <andrealmeid@igalia.com>
Subject: Re: [v4 3/3] bcachefs: Implement casefolding
In-Reply-To: <8ffb410c-ebfc-490c-96d8-8ed72ef8eee2@froggi.es> (Joshua Ashton's
        message of "Mon, 14 Aug 2023 22:18:33 +0100")
Organization: SUSE
References: <20230814012434.627641-1-joshua@froggi.es>
        <20230814012434.627641-4-joshua@froggi.es> <87v8dh60rd.fsf@suse.de>
        <8ffb410c-ebfc-490c-96d8-8ed72ef8eee2@froggi.es>
Date:   Mon, 14 Aug 2023 19:01:58 -0400
Message-ID: <87350l5iu1.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Joshua Ashton <joshua@froggi.es> writes:

> On 8/14/23 17:34, Gabriel Krisman Bertazi wrote:
>>> +
>>> +Another option was to store without the two lengths, and just take the length of
>>> +the regular name and casefolded name contiguously / 2 as the length. This would
>>> +assume that the regular length == casefolded length, but that could potentially
>>> +not be true, if the uppercase unicode glyph had a different UTF-8 encoding than
>>> +the lowercase unicode glyph.
>> Why do you want to store the casefolded name?  In ext4, we just store
>> the case-exact name that was created, and do a code-point by code-point
>> comparison with the name under lookup through utf8_strncasecmp, which is
>> optimized to compare two not casefolded strings.  We just modify the
>> filename hash to be case-insensitive, so we know which dirent to look
>> for during lookup.  Finally, we use d_compare/d_hash to leverage the
>> dcache into finding negative dentries.
>
> Yeah, am aware of how ext4 does it, I just wanted it to have basically
> the exact same performance characteristics as as regular lookup.
>
> The utf8 cursor stuff in utf8_strncasecmp is still super expensive
> compared to a straight memcmp in some local benching.

More expensive than strncasecmp, for sure. But I'm surprised it is
visible in benchmarks.  Of course, unless you are searching different
files at every lookup, once it makes proper use of the dcache it won't
matter much.  There is also utf8_strncasecmp_folded that avoids half of
the trie searches by caching the name-under-lookup.

> I am happy to bung it in the vfs super_block for now though -- but I
> need to look at how that all works out with mounting and the multiple
> drives situation. Just be aware that at some point, it will likely be
> moved back again to our code.

Different drives as in different filesystem volumes? They each should
have one superblock anyway.  Also, someone called my attention to your
v1 commit message in v1 regarding selecting encoding per-directory.  I'm
not sure it is a good idea, since it is definitely problematic once you
start moving files around different subtrees.

Unicode casefolding is only stable for defined code points (of course),
but newer versions might add new code points that previously didn't have
any casefolding.  So, if you have a name that has an invalid casepoint
in an older version (but is legal utf8) and moves it to a new directory
with an encoding version where that folds into something else, you have
a situation where one file occludes the other and all sorts of
unpredictable behavior.

It can happen while copying across disks, of course. But we already
reject many cases of cross-filesystem copying.  But failing to move a
file within the same filesystem is not very user-friendly.

I think the reason you want to support multiple encoding versions is to
enable applications built for different Windows ntfs versions. If that
is the case, you should be safe using the latest unicode disk-wide,
since it is backward compatible.  Take a look also at ext4 and f2fs'
"strict mode", that rejects invalid unicode sequences too.

>> and ->lookup will be called again (perhaps creating another dentry?)
>> There are two ways around it. Rely on the libfs' generic handlers for
>> d_hash/d_compare and soon d_revalidate, or use d_add_ci to search for
>> case-insensitive aliases at lookup time, but then you don't benefit much
>> from the dcache if looking up for different cases.
>
> Thanks for the heads-up on this.
>
> It seems like I may have potentially hit a foot-gun there if we are
> making vfs dentry's for each lookup.
>
> I will investigate and validate that we are doing the right thing here
> for the next revision.
>
> I will not lie, I know veeery little about the vfs or dcache side, so
> huge thanks for pointing this out to me. :)
>
> I had a quick look at what f2fs does here, and it seems like it also
> just does d_splice_alias, but it has the following caveat.
>
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

A negative dentry is simply a cache entry saying that a file doesn't
exist in the filesystem, so further lookups don't need to hit the disk
over and over.

The f2fs caveat you mentioned is entirely avoiding the creation of
negative dentries in IS_CASEFOLDED directories, since they aren't
supported currently. I explained a bit the reasoning for that in the
following series, that also remove this code.  It is (hopefully) going
upstream soon:

  https://www.spinics.net/lists/linux-ext4/msg90964.html

My suggestion is that you follow f2fs/ext4 closely.  Avoid d_add_ci, as
it was written for filesystems that deal with case-insensitive
directories in a slight different way, and don't make use good use of
the dcache, in my opinion.  A better approach would be to use
d_compare/d_hash and keep calling d_splice_alias.  Take a look at the
generic handlers in fs/libfs.c too.

-- 
Gabriel Krisman Bertazi
