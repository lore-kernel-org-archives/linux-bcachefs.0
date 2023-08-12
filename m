Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1AFC001E0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 22:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjHLWoN (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjHLWoN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 18:44:13 -0400
Received: from out-101.mta1.migadu.com (out-101.mta1.migadu.com [IPv6:2001:41d0:203:375::65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20513E7
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 15:44:15 -0700 (PDT)
Date:   Sat, 12 Aug 2023 18:44:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691880253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hv/pTgqWpza/w9I0OFTJyI1GCHl2fra15uY5XaojC+4=;
        b=Ha3d6GxBrNKRkTQdfX8NjOpMX54UQ0/440jq/itK2Ah18cck5GI0bzdtskGylBvybNO8pB
        EK1xKu4F8n68ZUTjO7Ut7dWg657NG28nKT+4xwjcPWRFY+BT6EW2W9zfm35Y6BSQ/pvoJN
        rYVyAAv/SXuz2bLDtlAmhUnXUo6PWRA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org,
        =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [PATCH 4/4] bcachefs: Implement casefolding
Message-ID: <20230812224410.smo25uzbquiwilie@moria.home.lan>
References: <20230812145017.259609-1-joshua@froggi.es>
 <20230812145017.259609-4-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230812145017.259609-4-joshua@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Aug 12, 2023 at 03:47:48PM +0100, Joshua Ashton wrote:
> This patch implements support for case-insensitive file name lookups
> in bcachefs.
> 
> The implementation the same utf8 lowering and normalization that ext4
> and f2fs is using currently.
> 
> It uses the regular CASEFOLD attributes and stores the casefolded name
> contiguously with the regular name on disk and in memory if space
> permits it.
> 
> Names that would be too long to fit contiguously are instead compared
> using a folding strcmp.
> 
> The crux of the implementation, is that cached casefolded names are
> twice the length of uncasefolded names.
> In the case that they are not (which I don't believe is possible in
> the current UTF-8 spec for any cased glyphs), it again, falls back to
> a folding strcmp.
> 
> There is currently no option provided for selecting the casefolding
> encoding; ext4 and f2fs only support a single encoding per-superblock
> (utf8 12.1), but it would be trivial to extend this on bcachefs on a
> per-inode level using the opts system so it not provided in this patch.

As discussed on IRC, repeating for the list: for new features, we need
to start making sure we document/save all the rationale and design
decisions we talked about - even just saving the IRC logs can be quite
helpful later, bonus points for turning it into nicely formatted and
structured markdown.

In particular, we need to document why we went with tacking this onto
bch_dirent instead of creating a bch_dirent_v2; the fact that _this_
type of casefolding doesn't change the number of glyphs is also
important.

Stick it in Documentation/filesystems/bcachefs/casefolding.

I've got other design docs on the wiki that could be moved there, as
well.

> +#define BCH_CF_NAME_MAX (BCH_NAME_MAX / 2)

We probably ought to have a single BCH_NAME_MAX for casefolded and non
casefolded names - and we discussed on IRC either making it the same as
other filesystems (255), or we could also make it somewhat bigger, since
other filesystems support longer names as well.

That could easily be a superblock option, so people can decide what sort
of compatibility they want (much like the inodes_32bit option).
