Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A03ACDB47E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 18 Oct 2023 20:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjJRUao (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 16:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjJRUaa (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 16:30:30 -0400
Received: from out-210.mta0.migadu.com (out-210.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6ECD6D
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 13:29:59 -0700 (PDT)
Date:   Wed, 18 Oct 2023 16:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697660997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ThelgcPdbQVBiMthLurD4t/d/kD11jPWQqjYw72B5OQ=;
        b=Y5diJkwH8UuBrkYX7CVa8a/NOJupKggvhbyzOA1KTw9oHSr4/TchKz+qf8jW58Y0ASIWKz
        /ijO3ak0GPjvXJsvpNzXWwZhvSPRLia+SWcNOgEM1yJwVFPYLApfr4A9zwte6pjXVEAKcD
        I4I+DsuuOtLAhJsFWWzCwnzE6TOQVbw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Parke <parke.nexus@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Bcachefs: export a different st_dev for each subvolume
Message-ID: <20231018202955.i2xjqqpd7cubunvg@moria.home.lan>
References: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 18, 2023 at 12:37:59PM -0700, Parke wrote:
> Hello, linux-bcachefs@vger.kernel.org,
> 
> I am exploring the feasibility of adding colorization of subvolumes to
> the output of the coreutils `ls` program.  Specifically, for the
> BTRFS, ZFS, and Bcachefs filesystems.
> 
> In order for `ls` colorization of subvolumes to be feasible, detection
> of subvolumes, by non-root users, needs to be implemented in an
> efficient and reliable manner.
> 
> In searching the linux-bcachefs mailing list, I found a post by Kent Overstreet:
> 
> On 4 Nov 2021, Kent Overstreet wrote:
> Still todo:
>    - need to export a different st_dev for each subvolume, like btrfs, so that
>      find -xdev does what you want and skips snapshots
> 
> Source:
> https://lore.kernel.org/linux-bcachefs/YYQZ+QmATIgKfzZ8@moria.home.lan/
> 
> What is the status of the above todo item regarding a distinct st_dev
> value for each subvolume?

Not done yet (and thanks for the reminder!)

> A second question:  On Btrfs, each subvolume has an inode value of 256.
> 
> Source:  https://btrfs.readthedocs.io/en/latest/Subvolumes.html
> 
> Is there any easy method for users (especially non-root users) to
> identify Bcachefs subvolumes?

Unfortunately nothing so easy - snapshots will have the same inode
number for their root as the parent subvolume, but new (empty)
subvolumes get new inode numbers for their root inode.

Perhaps we could sketch out a proper interface for this...
