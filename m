Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68056E728D6
	for <linux-bcachefs@archiver.kernel.org>; Fri, 29 Sep 2023 18:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbjI2STg (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 29 Sep 2023 14:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjI2STf (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 29 Sep 2023 14:19:35 -0400
Received: from out-194.mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70321136
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Sep 2023 11:19:33 -0700 (PDT)
Date:   Fri, 29 Sep 2023 14:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696011572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BeyMtmUp+CKqzukQMkDyjD/N+WAMS95ddBL+HV/ngAU=;
        b=CYL6QbQbgd9kuXiEsokjQHP+LxLkTZPfklO1rFwaT6V1S9myqnPAzncrWhoAeoVpdADGrd
        2m70YrYqhAct8teYcHqzbLIbeYypr8YdExeChLN8r9kH8IiyVdn3/ePV26b5+3ZMLkkAjj
        4urIjNiGtFku4RYLmUF8oJh6UVEsttY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs-tools for members v2
Message-ID: <20230929181928.n2tklx624e5mg6gp@moria.home.lan>
References: <063cc43e-0c7f-4bb1-ad8f-7ca05a62c1cf@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <063cc43e-0c7f-4bb1-ad8f-7ca05a62c1cf@t-8ch.de>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 29, 2023 at 05:17:24PM +0200, Thomas Weißschuh wrote:
> Hi,
> 
> I'd like to extend libblkid/util-linux to handle the new members v2
> format. We are using the superblock members to calculate the overall
> filesystem size and per-device UUIDs.
> 
> While I found the kernel part, I did not so for the userspace part.
> Could you give me a hint?

It'll be landing in -tools shortly.

> Also it would be great to know when the new members v2 layout is
> considered stable.

It's stable now.

I don't think you'll actually need to use members_v2 in util-linux
though - we'll always be including members_v1 in the superblock for
compatibility with older versions, you'll only need to switch to
members_v2 if you want to access newer fields in bch_member.

That'll be the new iops fields, and shortly a new sequence number for
detecting split brain conditions, possibly some error counters later...
