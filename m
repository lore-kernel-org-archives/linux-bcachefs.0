Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39542C04FF3
	for <linux-bcachefs@archiver.kernel.org>; Mon, 24 May 2021 04:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13B6E610CE
	for <linux-bcachefs@archiver.kernel.org>; Mon, 24 May 2021 04:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhEXEYW (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 24 May 2021 00:24:22 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:37089 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229510AbhEXEYW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 24 May 2021 00:24:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UZqu58A_1621830173;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0UZqu58A_1621830173)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 24 May 2021 12:22:53 +0800
Date:   Mon, 24 May 2021 12:22:53 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Eryu Guan <guan@eryu.me>, fstests@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH 1/3] Initial bcachefs support
Message-ID: <20210524042253.GE60846@e18g06458.et15sqa>
References: <20210427164419.3729180-1-kent.overstreet@gmail.com>
 <20210427164419.3729180-2-kent.overstreet@gmail.com>
 <YJfzVSGu2BbE4oMY@desktop>
 <YKrchSzj8Zo4CnDs@moria.home.lan>
 <20210524035604.GD60846@e18g06458.et15sqa>
 <YKsl0ORHo/mhuUBx@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKsl0ORHo/mhuUBx@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, May 24, 2021 at 12:04:32AM -0400, Kent Overstreet wrote:
> On Mon, May 24, 2021 at 11:56:04AM +0800, Eryu Guan wrote:
> > On Sun, May 23, 2021 at 06:51:49PM -0400, Kent Overstreet wrote:
> > [snip]
> > 
> > > > >  	;;
> > > > > @@ -1179,6 +1197,19 @@ _repair_scratch_fs()
> > > > >  	fi
> > > > >  	return $res
> > > > >          ;;
> > > > > +    bcachefs)
> > > > > +	fsck -t $FSTYP -n $SCRATCH_DEV 2>&1
> > > > 
> > > > _repair_scratch_fs() is supposed to actually fix the errors, does
> > > > "fsck -n" fix errors for bcachefs?
> > > 
> > > No - but with bcachefs fsck finding errors _always_ indicates a bug, so for the
> > > purposes of these tests I think this is the right thing to do - I don't want the
> > > tests to pass if fsck is finding and fixing errors.
> > 
> > Then _check_scratch_fs() should be used instead, which will fail the
> > test if any fsck finds any corruptions. _repair_scratch_fs() is meant to
> > fix errors, and only report failure when there's unfixable errors.
> 
> I see no reason to make such a change to generic tests that were written for
> other filesystems, when this gets me exactly what I want.

Oh, I noticed that "with bcachefs fsck finding errors _always_ indicates
a bug" now.. Then I think using fsck -n is fine here, but better with
comments to describe why this is ok for bcachefs.

Also, we could just use _check_scratch_fs here instead of the open-coded
fsck command. As _check_scratch_fs calls _check_generic_filesystem()
which calls fsck -n internally, and handles mount/umount device
correctly and prints pretty log if there's any errors.

Thanks,
Eryu
