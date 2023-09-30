Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2D4E7737B
	for <linux-bcachefs@archiver.kernel.org>; Sat, 30 Sep 2023 17:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbjI3RPP (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 30 Sep 2023 13:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbjI3RPO (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 30 Sep 2023 13:15:14 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D543DD
        for <linux-bcachefs@vger.kernel.org>; Sat, 30 Sep 2023 10:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
        t=1696094110; bh=Fe3Qw9G+2iGnIBqTIl2A1ejsMmSLPohiuvnas2Ga0vs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n4im5qMamSSL6MTEo0m9ZEvHxSCQhDxImZnccmnTl05Tl+CNDfhPTbeRT29KE9MNu
         3z6bcqkcz0G6qwzRxuGC1dC1p2+rpd/CShfYijhJtZTcKgWrbE8eIy/Z2eGKmFJR+W
         dJ/cAVteFDzbBzf0V0/8O7PgCOdVpcxLhuzwiSEk=
Date:   Sat, 30 Sep 2023 19:15:09 +0200
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs-tools for members v2
Message-ID: <14e5d4d2-c3d3-4974-b45f-0955a7e31fba@t-8ch.de>
References: <063cc43e-0c7f-4bb1-ad8f-7ca05a62c1cf@t-8ch.de>
 <20230929181928.n2tklx624e5mg6gp@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230929181928.n2tklx624e5mg6gp@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent,

On 2023-09-29 14:19:28-0400, Kent Overstreet wrote:
> On Fri, Sep 29, 2023 at 05:17:24PM +0200, Thomas Weißschuh wrote:
> > I'd like to extend libblkid/util-linux to handle the new members v2
> > format. We are using the superblock members to calculate the overall
> > filesystem size and per-device UUIDs.
> > 
> > While I found the kernel part, I did not so for the userspace part.
> > Could you give me a hint?
> 
> It'll be landing in -tools shortly.
> 
> > Also it would be great to know when the new members v2 layout is
> > considered stable.
> 
> It's stable now.
> 
> I don't think you'll actually need to use members_v2 in util-linux
> though - we'll always be including members_v1 in the superblock for
> compatibility with older versions, you'll only need to switch to
> members_v2 if you want to access newer fields in bch_member.
> 
> That'll be the new iops fields, and shortly a new sequence number for
> detecting split brain conditions, possibly some error counters later...

Great, then we won't have to do anything.
Thanks for the clarification.


Thomas
