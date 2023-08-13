Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E001FEB64DD
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 20:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjHMUtb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 16:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjHMUtb (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 16:49:31 -0400
Received: from out-72.mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74B8E6D
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 13:49:32 -0700 (PDT)
Date:   Sun, 13 Aug 2023 16:49:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691959770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0LywsYQ4k0lIt608KwHGoVthwnD668AtqxuScaeLZhk=;
        b=u2fVeMlIY9FYdmcC46FOrMmECLAk5Oh0YKOoPmNR6DaPa3SbWGvcKF6ZEmxaMGSLEuakFQ
        m3vauBgAWYD7UjaDiRsEcVNupFKohSW/JjX9ZtfqQEuy7G3/FM4oiy4WKgQIWGmKYQiVIx
        Y4wrHexsSNWIQS9qju58oMYSbWtb6Ss=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org,
        =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [v3 3/3] bcachefs: Implement casefolding
Message-ID: <20230813204925.6b3aha24ky57sg5f@moria.home.lan>
References: <20230813173835.195840-1-joshua@froggi.es>
 <20230813173835.195840-4-joshua@froggi.es>
 <20230813181845.ukbrchtfjck3qdcw@moria.home.lan>
 <5a138da7-869a-4cb4-a274-dbf4b36bc72f@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a138da7-869a-4cb4-a274-dbf4b36bc72f@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Aug 13, 2023 at 08:20:37PM +0100, Joshua Ashton wrote:
> On 8/13/23 19:18, Kent Overstreet wrote:
> > This is wrong - failing the .key_invalid() check means the key is
> > _deleted_, we don't want that to happen just because a kernel config
> > option was flipped.
> 
> We should never ever be in this situation to begin with -- that means a
> casefolded dir exists on a filesystem without the feature flag.
> 
> What would be a better alternative? A BUG_ON? Nothing?

Checking the feature bit directly would be better, but I would prefer to
leave this entirely out of .key_invalid() and just add error paths in
the appropriate places. .key_invalid methods preferably shouldn't be too
complicated or depend on external state; they're more about catching
corruption that would cause e.g. memory safety issues.

> > > @@ -241,10 +320,19 @@ int bch2_dirent_create(struct btree_trans *trans, subvol_inum dir,
> > >   		       u8 type, const struct qstr *name, u64 dst_inum,
> > >   		       u64 *dir_offset, int flags)
> > >   {
> > > +	char cf_name_buf[BCH_NAME_MAX + 1];
> > 
> > No, as discussed 512 bytes is too much to stack allocate. And we don't
> > need a separate buffer here, move the bch2_casefold() call into
> > dirent_create_key, create it directly in place.
> > 
> > Big unnecessary stack allocations is a major no-no in the kernel, unless
> > you've _really_ done the analysis and know that it's OK, and usually
> > it's not. When we call into the btree code that can initiate IO
> > directly, or we can end up invoking memory reclaim and _that_ can
> > initiate IO, and btree_trans and our btree_iters have already consumed
> > as much stack as we're allowed to in our code.
> 
> Makes sense, sorry about that. I forgot about it since I slept between that
> conversation. :-)

Always take notes - I often take notes by starting an empty commit and
having the initial commit message be the todo list.

> I do not think putting it in dirent_create_key is the right place -- that
> would mean we end up doing the casefolding operation multiple times in
> bch2_dirent_rename which seems bad.

You mean on transaction restart? That's no big deal, transaction
restarts are rare. Or?

> We also need to know the length of the casefolded string before allocating
> it, so we cannot do it in-place either way...

Ah, true.

> For smoke-testing I have a script that builds with CONFIG_UNICODE=y and n
> and then I just have a qemu vm with a script to bcachefs format and mount
> some -o loop file. Test with a few things and edgecases to make sure stuff
> is working.
> 
> For more serious testing before sending to the ML, I have been running the
> kernel locally and copying a few Proton games + prefixes over, chattr'ing
> and testing actual games. So far I have had no issues.

Ok, that's a good start.

> Looking into your ktest and stuff to make sure we have coverage there too is
> on my radar also, but I have not done it yet.

Yeah, we'll need to make sure there's tests for this in either fstests
or ktest before merging.
