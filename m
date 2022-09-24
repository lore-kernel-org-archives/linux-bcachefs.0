Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF6DC07E9D
	for <linux-bcachefs@archiver.kernel.org>; Sat, 24 Sep 2022 23:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiIXX17 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 24 Sep 2022 19:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiIXX1y (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 24 Sep 2022 19:27:54 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F88474F4
        for <linux-bcachefs@vger.kernel.org>; Sat, 24 Sep 2022 16:27:51 -0700 (PDT)
Date:   Sat, 24 Sep 2022 19:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664062070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yWPOgdnKJgQFWeTcSm18mYKx8C3RC/ksIe9yE609by4=;
        b=L11/w/Oetp65pWIGumdHA2dTiKSG3VGKl4NVOiea6ezsbUMtvxyqb/OJaeP6OKnGWHeR6A
        22kvAJ8mBCMQsxlke7BJnwi1r7mQik0mFSmMEbHWyKB8qHVeSXdDzOSkQGk7bjyVUoIY+n
        kXPz58q4lj1p+K+AWG63o0zxbmS1GlY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Josh Litherland <josh@temp123.org>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Secondary Superblock?
Message-ID: <20220924232746.jii5xobipya7acbd@moria.home.lan>
References: <CAKib_wJJCYxOzNqCAQOBBn2Y5mNgVXk-0Oow9Y0_=JNJvbgeDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKib_wJJCYxOzNqCAQOBBn2Y5mNgVXk-0Oow9Y0_=JNJvbgeDg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Sep 10, 2022 at 12:20:35AM -0400, Josh Litherland wrote:
> Is there a secondary superblock somewhere on a bcachefs volume that I
> can recover from in the event the primary gets overwritten?
> 
> Context: I have/had an encrypted bcachefs laid across 4 hard drives
> and 2 ssds.  Prior to experimenting with bcachefs, I had LUKS
> encryption on the same drives.  I accidentally ran an old script that
> ran "cryptsetup open" on all the drives, which astonishingly (1)
> worked at all, and (2) overwrote the bcachefs superblock with a LUKS
> one.  I'm still investigating how the hell that happened, but I have
> reproduced it in testing.
> 
> Is there any chance of finding a working copy of my bcachefs
> superblock and restoring it?

Yes - if you look at libbcachefs.c line 303 in bcachefs-tools, it allocates a
backup superblock at the end of the disk (in addition to two at the start of the
disk), which starts at the start of the last bucket.

Maybe we could add some code to probe for the superblock at the end of the disk,
and/or write the layout to the last sector in the partition.

If you know the bucket size you formatted with and can calculate where the
backup superblock should be, you can mount with the sb_offset= parameter.
