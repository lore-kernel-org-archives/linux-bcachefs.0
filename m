Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E3EC46CA1
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 01:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjJSBRI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 21:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjJSBRH (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 21:17:07 -0400
Received: from out-201.mta0.migadu.com (out-201.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C523112
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 18:17:03 -0700 (PDT)
Date:   Wed, 18 Oct 2023 21:16:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697678220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B9Dpd3F2tQPwhB7RppIAd842tnQYG9FNycphjgiCKog=;
        b=WvbGN3c1FX2khHggRAp7V5Ac4yjZs1ShBtpieWTcYGlLOxt0HQitM9NxK54YV3aVfxXqQu
        iiJcx6sI4yxXd74W3+EEMbpZJtoFLvm8d8jI1nbuR/yMTgL8IDmD+56cNNr7WIuuJ6rhYd
        g6EYjOeAVXoXqY3hF4ouVGnAkbi5yiw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Daniel J Blueman <daniel@quora.org>
Cc:     linux-bcachefs@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: Re: trans path overflow during metadata replication with lockdep
Message-ID: <20231019011657.gnx7l2ldqkbxmexj@moria.home.lan>
References: <CAMVG2sun2sqFXt=H-0cVWnATGMMFpe-0ksRWy3uhUZXbA5m1qA@mail.gmail.com>
 <72438765-AD46-4C8A-975F-982223CE7A40@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72438765-AD46-4C8A-975F-982223CE7A40@suse.de>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Oct 10, 2023 at 11:20:59PM +0800, Coly Li wrote:
> Forward it to linux-bcachefs@vger.kenrel.org <mailto:linux-bcachefs@vger.kenrel.org> 
> 
> > 2023年10月10日 07:43，Daniel J Blueman <daniel@quora.org> 写道：
> > 
> > Firstly, bcachefs introduces a new era of in-tree filesystems with
> > some monumental features (sorry, ZFS); hats off to Kent for landing
> > this!
> > 
> > My testing finds it is in great shape; far better than BTRFS was when
> > it landed. Testing on linux next-20231005 with additional debug checks
> > atop the Ubuntu 23.04 kernel generic config [1], I was able to provoke
> > a btree trans path overflow cornercase [2].
> > 
> > The minimal reproducer is:
> > # modprobe brd rd_nr=2 rd_size=1048576
> > # bcachefs format --metadata_replicas=2 --label=tier1.1 /dev/ram0
> > --label=tier1.2 /dev/ram1
> > # mount -t bcachefs /dev/ram0:/dev/ram1 /mnt
> > # dd if=/dev/zero of=/mnt/test bs=128M
> > 
> > The issue doesn't reproduce with metadata_replicas=1 or a single block device.
> > 
> > At debug entry, I couldn't determine why BTREE_ITER_MAX must be 64
> > rather than 32 when CONFIG_LOCKDEP is set, however the panic doesn't
> > occur without CONFIG_LOCKDEP, so it appears related; keeping it at
> > value 32 with CONFIG_LOCKDEP doesn't prevent the panic also.

Lockup can only track up to 48 held locks but each btree path can hold a
lock - hence we need to limit the number of max paths for lockdep to
function.

In the main branch there's a patch that ups the lockdep limit to 63 and
drops the BTREE_ITER_MAX=32.

The underlying issue is a bit more serious though; it is becoming
increasingly impractical to count the number of paths we're going to
need ahead of time so that we can run inside of a fixed limit. There's a
number of extra btrees for allocation purposes that we only hit
sometimes, and we really can't predict ahead of time which ones will
need to be updated.

Long term, we're probably going to need to figure out a way to
dynamically allocate btree paths and get rid of the fixed limit.
