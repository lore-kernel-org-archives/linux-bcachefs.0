Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBE3C433EF
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Apr 2022 01:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245727AbiDSBoY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 18 Apr 2022 21:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343544AbiDSBoY (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 18 Apr 2022 21:44:24 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA7325C7B
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Apr 2022 18:41:43 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id t26so2620206qtn.6
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Apr 2022 18:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X6G8ooQhCa27UqDLifl2rIewi8LC3Wfr6fvoA4tNueE=;
        b=ZexoE9cldG17ytXBX5qJcEW5f3THeqXl51ocgiKfoAIHwBAdV7FeY2PQwhvQ+CPQ8t
         wPfIrF0D2HK7inR6PAHrvivE3jTozjvUux71gBUrdKsyexkTtT6MdkJjbt0EaIN293yM
         LXeKHqpkmPOjGReLjwIy9m6gPXzlehO+vVDXgt5sXDnOqF1b9ZWVwH4ulX/dafmSEOEU
         YBG8m35VzNYdJROKzaQlfIybqKdUOESWvWvcroY6/fB13z7DpnAwd793nXqfEmNSa3Jv
         Tl0ehctbJPFLpEXtfXhnOZTRNcysDgNNvgNKItskav+FCS0ocQpb7HeGZP7IECS5OVTd
         Ly3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X6G8ooQhCa27UqDLifl2rIewi8LC3Wfr6fvoA4tNueE=;
        b=sbtAG4fF3eAgYlBJ2U+HMj++tk4QZMOdsnSaothSV8+yyfBd/yxlxa9ZsMfniDv7O8
         quw+cfbUvXmrizD6bFBSPk6GPMGyOH9HdfwcTC/xIqrOII1sYFI62pDaVXDzNr2kEndq
         5G6//P+MJY1M5Z0OymRetr0cMAe4GYzwTalQ+dRlj271RSC8704hxPopwYomBNKkS0AV
         BhEgkGTwuCXOlMb4apy8QIcBN5Rf34wr9lJZyhSLb7zYgEJcE4lTOd3NQQjca/O2iwvw
         4c09daX5jG0JTrbVaTKelyf/zZqRCyPcfcLwGV0f8Dxy5cgMIrCtxWJZpcPm//mrERvU
         KoLg==
X-Gm-Message-State: AOAM532z1okSoMGoz1lZrdGF+kkU3/45m/vP+tTvpjJAqxpvgANEIdzb
        T3qJeyVnwX4p2DnFtM6byUsWjZn+bg==
X-Google-Smtp-Source: ABdhPJz8DE8ovKz3Wk3PHl8CeJHth6akYoAIOsCAoUnwf3Vg9drqHiyGP56Oe8V0RlnYsLhxeFB2iA==
X-Received: by 2002:ac8:5816:0:b0:2e0:6944:e5c2 with SMTP id g22-20020ac85816000000b002e06944e5c2mr8972621qtg.617.1650332502646;
        Mon, 18 Apr 2022 18:41:42 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id n8-20020ac85a08000000b002f1fc230725sm3309514qta.31.2022.04.18.18.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 18:41:41 -0700 (PDT)
Date:   Mon, 18 Apr 2022 21:41:40 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Eric Wheeler <bcachefs@lists.ewheeler.net>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs loop devs (was: Comparison to ZFS and BTRFS)
Message-ID: <20220419014140.5jz4hahhkfksulce@moria.home.lan>
References: <Yk05Sk4ztxLMpgrt@itl-email>
 <20220415191140.2xyni3kusht6wear@moria.home.lan>
 <1f3290c6-535a-a15f-c02f-325099ecc4e0@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f3290c6-535a-a15f-c02f-325099ecc4e0@ewheeler.net>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Apr 18, 2022 at 06:16:09PM -0700, Eric Wheeler wrote:
> On Fri, 15 Apr 2022, Kent Overstreet wrote:
> > On Wed, Apr 06, 2022 at 02:55:04AM -0400, Demi Marie Obenour wrote:
> > > - How does an O_DIRECT loop device on bcachefs compare to a zvol on ZFS?
> > 
> > I'd have to benchmark/profile it. It appears there's some bugs in the way the
> > loop driver in O_DIRECT mode interacts with bcachefs according to xfstests, and
> > the loopback driver is implemented in a more heavyweight way that it needs to be
> > - there's room for improvement.
> 
> Hi Kent, regarding loop devs:
> 
> We wrote this up before realizing that REQ_OP_FLUSH does not order writes 
> like REQ_FLUSH once did, so my premise for the email linked below was 
> incorrect---but perhaps the concept is relevant.
> 
> I wonder if something is going on between (1) filesystem above loop.c 
> (bcachefs in this case), (2) the block layer re-ordering, and (3) the 
> kiocb ki_complete callback in loop.c that could create out-of-order 
> journal commits in the filesystem above the loop device (eg, xfs from #1):
> 
> 	https://www.spinics.net/lists/linux-block/msg82730.html
> 
>   From loop.c in lo_rw_aio():
> 	[...]
> 	cmd->iocb.ki_pos = pos;
> 	cmd->iocb.ki_filp = file;
> 	cmd->iocb.ki_complete = lo_rw_aio_complete; 
> 	cmd->iocb.ki_flags = IOCB_DIRECT;
> 	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
> 
>   A more detailed loop.c call tree summary is here:
> 	https://lore.kernel.org/all/59a58637-837-fc28-6cb9-d584aa21d60@ewheeler.net/T/ 
> 
> If bcachefs immediately calls .ki_complete() after queueing the IO within 
> bcachefs but before it commits to bcachefs's disk, then loop.c will mark 
> the IO as complete (blk_mq_complete_request via lo_rw_aio_complete) too 
> soon after .write_iter is called, thus breaking the expected ordering in 
> the filesystem (eg, xfs) atop of the loop device.

We don't call .ki_complete (in DIO mode) until the write has been complete,
including the btree update - this is necessary for read-after-write consistency. 

If your description of the loopback code is correct that does sound suspicious
though - queuing every IO to work item shouldn't hurt anything from a
correctness POV but it definitely shouldn't be needed or wanted from a
performance POV.

What are you seeing?
