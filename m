Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110DDCDB47E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 00:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjJSA1E (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSA1D (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 20:27:03 -0400
Received: from out-196.mta1.migadu.com (out-196.mta1.migadu.com [IPv6:2001:41d0:203:375::c4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AC9115
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 17:27:01 -0700 (PDT)
Date:   Wed, 18 Oct 2023 20:26:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697675220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3N86S8Q3f4+pSEhn/TqFHknvc5p4Ix+0nP97hGGli8A=;
        b=SwQSfPmY7cqLqHQoB0I/sT7xJ1YOmnskqU6LcvkD1GsdJrVgPtqVMsPgh6bT3Kzp8C6aa7
        9jt5i9xyhdmaLskFI4KP9y2SmBtWtAtA+gAT8fLPTBsvIkJBEE5RH0qClUQDXRcVzLFr8J
        Di5qc9nPwxn0uHIpo6G9YkIWEVi1EBE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Parke <parke.nexus@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Bcachefs: export a different st_dev for each subvolume
Message-ID: <20231019002654.cgsmfhu6pxnh4vro@moria.home.lan>
References: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
 <20231018202955.i2xjqqpd7cubunvg@moria.home.lan>
 <CAPxz1+ZTODcUt=nbToDtpsHr1LW04VNVqDPJNV2QhuXb-=+CnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPxz1+ZTODcUt=nbToDtpsHr1LW04VNVqDPJNV2QhuXb-=+CnQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 18, 2023 at 02:49:58PM -0700, Parke wrote:
> > Unfortunately nothing so easy - snapshots will have the same inode
> > number for their root as the parent subvolume, but new (empty)
> > subvolumes get new inode numbers for their root inode.
> >
> > Perhaps we could sketch out a proper interface for this...
> 
> Could Bcachefs communicate whether or not a directory is subvolume
> somehow via the st_rdev field?  Or does bcachefs already use st_rdev
> for something else?
> 
> (I am unfamiliar with st_rdev, its uses, and what restrictions the
> kernel might place upon it.)

st_rdev is for device nodes, so no, that's not available.

What about testing if st_dev is different from the parent directory?
