Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7610C636D4
	for <linux-bcachefs@archiver.kernel.org>; Mon,  6 Feb 2023 15:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjBFPoi (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 6 Feb 2023 10:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjBFPoc (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 6 Feb 2023 10:44:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82109A5F9
        for <linux-bcachefs@vger.kernel.org>; Mon,  6 Feb 2023 07:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675698132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6vVUr/A/d1m1DITT4ioRKljGyUondp09mAjm82WZZQQ=;
        b=c0cCLnpNzp6pTRbgw7GPXhVuWEph396s9ZDe6M2kEeyurZrSLaSUnZQHx/aD/lWA8MzloM
        FT9JfeDUXHZ0T2l/BRyicsh/5HLUI+BfyVDhl5s84PNrrx6vZR3txYk54sTujoRuijRT4W
        iT/UOmhojV3PBDv+Paa/RQk9JGCnIs4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-371-nDWsd9xJPyCZXWLk4JSeEA-1; Mon, 06 Feb 2023 10:31:51 -0500
X-MC-Unique: nDWsd9xJPyCZXWLk4JSeEA-1
Received: by mail-qk1-f198.google.com with SMTP id ay10-20020a05620a178a00b0072db6346c39so6706694qkb.16
        for <linux-bcachefs@vger.kernel.org>; Mon, 06 Feb 2023 07:31:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vVUr/A/d1m1DITT4ioRKljGyUondp09mAjm82WZZQQ=;
        b=RNqm7odammuvBo3qBqEcODRrz6TwwzPZbFkNXRlV7fnC2qjvkZuuqnK/Mvyt+VOGoU
         jBOW3zvRantHF8Bnq//vraWyH+q/BNI7udXUK+rjOyToh6KaeS7DC9zal//xRVdQd2tX
         Pa3d9qrwrUpprAGwVyxjCB5ZXJh8yxt0jjv8sCoFTxppy8N65S7MYHl6Wa5wz1a0zFcr
         82tU9PVislItiGMU+BrbIb3rq7/kL6kz9mR8pHigxLdbanTY9phbhnbDOe2ub2kKnVuB
         KsDo86hTfH08b9OX/jNZQSZGwRMfluksteL6nTXJdxHAr0scnzrrTfXOT5dLxEX+xH+D
         PBkw==
X-Gm-Message-State: AO0yUKVOTxTpj6UVj5GLRards6yEds+XDP4pg7+7sMMOpRpDDXXuXHaG
        jUDYhUXHsfe502ibRcz4DwkxJghZYyYAUUTqS3g5UP/evs5XRs6t3suVCSD6Or6D0u1C6u1ReK9
        w7mvwpEUN2OvvSc32G3KsbVT3yXs=
X-Received: by 2002:a05:622a:1789:b0:3b1:80ab:38e with SMTP id s9-20020a05622a178900b003b180ab038emr36360528qtk.0.1675697510719;
        Mon, 06 Feb 2023 07:31:50 -0800 (PST)
X-Google-Smtp-Source: AK7set8BD3lW2rSpfwHb5+XgrHkHUDnfXwcAs2UZK990CaFno2C7jF7mwfmA7hBGWyt/6y2q8+eztw==
X-Received: by 2002:a05:622a:1789:b0:3b1:80ab:38e with SMTP id s9-20020a05622a178900b003b180ab038emr36360487qtk.0.1675697510247;
        Mon, 06 Feb 2023 07:31:50 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id u31-20020a05622a199f00b003b0b903720esm7447709qtc.13.2023.02.06.07.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 07:31:49 -0800 (PST)
Date:   Mon, 6 Feb 2023 10:33:14 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y+EduoshRHXec+XU@bfoster>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9w/oMzjVp90c/Pk@moria.home.lan>
 <Y97PNdqx82rot2WC@bfoster>
 <Y97Y76dSCVkF0WIE@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y97Y76dSCVkF0WIE@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Feb 04, 2023 at 05:15:11PM -0500, Kent Overstreet wrote:
> On Sat, Feb 04, 2023 at 04:33:41PM -0500, Brian Foster wrote:
> > On Thu, Feb 02, 2023 at 05:56:32PM -0500, Kent Overstreet wrote:
> > > On Tue, Jan 31, 2023 at 11:04:11AM -0500, Brian Foster wrote:
> > > > On Mon, Jan 30, 2023 at 12:06:34PM -0500, Kent Overstreet wrote:
> > > > > On Fri, Jan 27, 2023 at 09:50:05AM -0500, Brian Foster wrote:
> > > > > > Something else that occurred to me while looking further at this is we
> > > > > > can also avoid the error in this case fairly easily by bailing out of
> > > > > > bch2_fsync() if page writeback fails, as opposed to the unconditional
> > > > > > flush -> sync meta -> flush log sequence that returns the first error
> > > > > > anyways. That would prevent marking the inode with a new sequence number
> > > > > > when I/Os are obviously failing. The caveat is that the test still
> > > > > > fails, now with a "Read-only file system" error instead of EIO, because
> > > > > > the filesystem is shutdown by the time the vfs write inode path actually
> > > > > > runs.
> > > > > 
> > > > > If some pages did write successfully we don't want to skip the rest of
> > > > > the fsync, though.
> > > > > 
> > > > 
> > > > What does it matter if the fsync() has already failed? ISTM this is
> > > > pretty standard error handling behavior across major fs', but it's not
> > > > clear to me if there's some bcachefs specific quirk that warrants
> > > > different handling..
> > > > 
> > > > FWIW, I think I've been able to fix this test with a couple small
> > > > tweaks:
> > > > 
> > > > 1. Change bch2_fsync() to return on first error.
> > > 
> > > I suppose it doesn't make sense to flush the journal if
> > > file_write_and_wait_range() didn't successfully do anything - but I
> > > would prefer to keep the behaviour where we do flush the journal on
> > > partial writeback.
> > > 
> > 
> > That seems reasonable to me in principle...
> > 
> > > What if we plumbed a did_work parameter through?
> > > 
> > 
> > ... but I'm not sure how that is supposed to work..? Tracking submits
> > from the current flush wouldn't be hard, but wouldn't tell us about
> > writeback that might have occurred in the background before fsync was
> > called. It also doesn't give any information about what I/Os succeeded
> > or failed.
> 
> Good point.
> 
> Now that I think about it, inode->bi_journal_seq won't be getting
> updated unless a write actually did successfully complete - meaning
> bch2_flush_inode() won't do anything unless there was a successful
> transaction commit; either data was written or the inode was updated for
> some other reason.
> 
> Maybe it's the sync_inode_metadata() call that's causing the journal
> flush to happen?
> 

Yeah, the sync_inode_metadata() -> bch2_vfs_write_inode() ->
bch2_write_inode() path is what commits a transaction and bumps the
->bi_journal_seq on the inode. Essentially I think there are a couple
issues related to this test and perhaps easier to reason about them
separately:

The first issue is that a shutdown occurs because the test basically
does a pwrite() -> fsync() -> dm-error error table switch sequence, and
the error table switch races with journal reclaim I/O that kicks in
after the fsync completes. This problem is resolved by the bcachefs
specific sleep during the dm-table switch (hopefully to be replaced by a
freeze cycle in the future), so no bcachefs changes are required for
that one.

The second issue is that bcachefs still shuts down with the
aforementioned delay in place for a slightly different reason. This
occurs because after the switch to an error table, the test does another
pwrite() -> fsync() sequence to test the "fsync should return error"
case. What I see happen in bcachefs here is that writepages occurs
(because the buffered write is able to dirty the pages and inode and
whatnot since everything is buffered) and fails, bch2_vfs_write_inode()
commits a transaction (again successful, and marks the inode with the
latest journal seq), and then bch2_flush_inode() grabs the updated inode
seq, attempts to flush the journal, fails due to I/O error, and then
shuts down the fs. The shutdown leads to general test failure because
the test eventually switches back to a functional dm table, but bcachefs
reports errors because it has shutdown.

So yes, it seems the sync_inode_metadata() path is what bumps the
journal seq and the explicit journal flush is what shuts down the fs,
but I assume sync_inode_metadata() attempts the inode flush simply
because the buffered write that precedes it works perfectly fine. This
is what had me thinking that bch2_fsync() is being more aggressive than
it really needs to be here. With the proposed logic tweak, the second
issue is resolved because bcachefs no longer attempts the inode flush
when page writeback has failed. So what happens in the test is that it
switches back over to the functional dm table, the vfs inode flush
occurs then and succeeds, and so the test sees no (unexpected) errors
and the fs has survived without shutting down.

All in all I think this test basically builds on some minor assumptions
about how fsync error behavior is implemented in Linux, and bcachefs
happens to slightly diverge in a way that leads to this shutdown. IOW,
I'd expect the same problematic behavior out of XFS if it implemented
this sort of fsync logic, but afaict no other fs does that, so the test
is functional in practice. I admit that's not the best pure engineering
justification for the change in bcachefs (so I understand any
hesitation), but IMO it's reasonable in practice and worthwhile enough
to improve test coverage. I haven't audited fstests for this or
anything, but it wouldn't surprise me much if there are other tests that
rely on this sort of "assumed behavior" for testing I/O failures.
Thoughts?

Brian

