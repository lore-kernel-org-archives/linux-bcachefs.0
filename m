Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83941C0015E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 13 Jul 2023 15:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjGMPdc (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 13 Jul 2023 11:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjGMPcs (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 13 Jul 2023 11:32:48 -0400
Received: from out-50.mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF8035B6
        for <linux-bcachefs@vger.kernel.org>; Thu, 13 Jul 2023 08:32:29 -0700 (PDT)
Date:   Thu, 13 Jul 2023 11:31:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689262317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ap7f5qiOkcC+TzMe7Ep4cbrW0Xc/voSsTkD7JLb08Xs=;
        b=HEQjQRjVCn6cHB7Swnwq9i8+Lb+fO9yIvoy7+UE6vLdn22FwyS7br1M/RqDf2D+VK1+NmM
        ZuAcaYoIF8gBI4X734NqbrVd+BEBDpqGLRrPg0VBOn6GDOXCQwyHdUNZcot7tOwfxa4MIL
        WrgBO2M8hFFihRA+4kRhO8KaXEi9aG0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH 05/10] bcachefs: BCH_SB_VERSION_UPGRADE_COMPLETE()
Message-ID: <20230713153154.jbykm3s6xwttqoxp@moria.home.lan>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
 <20230709171551.2349961-6-kent.overstreet@linux.dev>
 <ZK//N+7BsrCuPK3+@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZK//N+7BsrCuPK3+@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Jul 13, 2023 at 09:42:15AM -0400, Brian Foster wrote:
> On Sun, Jul 09, 2023 at 01:15:46PM -0400, Kent Overstreet wrote:
> > Version upgrades are not atomic operations: when we do a version upgrade
> > we need to update the superblock before we start using new features, and
> > then when the upgrade completes we need to update the superblock again.
> > This adds a new superblock field so we can detect and handle incomplete
> > version upgrades.
> > 
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >  fs/bcachefs/alloc_background.c |  3 +-
> >  fs/bcachefs/bcachefs.h         |  7 +++++
> >  fs/bcachefs/bcachefs_format.h  |  5 ++++
> >  fs/bcachefs/recovery.c         | 54 +++++++++++++++++++---------------
> >  fs/bcachefs/super-io.c         | 18 ++++++++++++
> >  5 files changed, 62 insertions(+), 25 deletions(-)
> > 
> > diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
> > index c59629bbbc..b1dfe300d9 100644
> > --- a/fs/bcachefs/alloc_background.c
> > +++ b/fs/bcachefs/alloc_background.c
> > @@ -1232,8 +1232,7 @@ int bch2_check_alloc_hole_bucket_gens(struct btree_trans *trans,
> >  	unsigned i, gens_offset, gens_end_offset;
> >  	int ret;
> >  
> > -	if (c->sb.version < bcachefs_metadata_version_bucket_gens &&
> > -	    !c->opts.version_upgrade)
> > +	if (c->sb.version < bcachefs_metadata_version_bucket_gens)
> >  		return 0;
> >  
> >  	bch2_btree_iter_set_pos(bucket_gens_iter, alloc_gens_pos(start, &gens_offset));
> > diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
> > index a8488d4e18..d7f030aa30 100644
> > --- a/fs/bcachefs/bcachefs.h
> > +++ b/fs/bcachefs/bcachefs.h
> > @@ -712,6 +712,7 @@ struct bch_fs {
> >  
> >  		u16		version;
> >  		u16		version_min;
> > +		u16		version_upgrade_complete;
> >  
> >  		u8		nr_devices;
> >  		u8		clean;
> > @@ -1134,6 +1135,12 @@ static inline bool bch2_dev_exists2(const struct bch_fs *c, unsigned dev)
> >  	return dev < c->sb.nr_devices && c->devs[dev];
> >  }
> >  
> 
> So the commit log implies that when an upgrade starts, sb.version refers
> to the target version, and now version_upgrade_complete is updated to
> match upon completion of the upgrade. Am I following that correctly?
> 
> If so, I'm still missing something.. where exactly is sb.version updated
> to the target version?

I don't think that was at its final destination in this patch - it's
check_version_uprade() in recovery.c post major minor versioning.
