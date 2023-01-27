Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0CAC54EAA
	for <linux-bcachefs@archiver.kernel.org>; Fri, 27 Jan 2023 14:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjA0Ots (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 27 Jan 2023 09:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjA0Otr (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 27 Jan 2023 09:49:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B352F83964
        for <linux-bcachefs@vger.kernel.org>; Fri, 27 Jan 2023 06:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674830935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c9N5HJg5RbvvCRnDbHHAQ3IVVWCyu/uwa1AnPSmjas4=;
        b=XjSQA+Q0AbKPuG8HFKgpg69UK2KatjZ41uWsRmnSIeBS5AUGak1pfWpQQNZlkzGQd7DigD
        4/kWY/yoWpkNA0EeJd+UADamO5+OfHadaKAaUmBucC1mwe5Dra9H/pRGWeN+MweERpjLxp
        zpXSoTyX+efnjz4ajbBQYRSsJGEZY2w=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-33-nyr5pGJYMk6f3i1KPX9ZAA-1; Fri, 27 Jan 2023 09:48:54 -0500
X-MC-Unique: nyr5pGJYMk6f3i1KPX9ZAA-1
Received: by mail-qv1-f69.google.com with SMTP id ob12-20020a0562142f8c00b004c6c72bf1d0so2849944qvb.9
        for <linux-bcachefs@vger.kernel.org>; Fri, 27 Jan 2023 06:48:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9N5HJg5RbvvCRnDbHHAQ3IVVWCyu/uwa1AnPSmjas4=;
        b=sOG6efR+PLh+Noxm/O/9cerusMP+QNXvxmXVrnUxRyiCGCay5UxLe1FLyCAUEeOeLu
         8gYHmJ/CxknSL9ldS3GPfBcmvtbfKGsvUQ0IxYO4UYwCYYhQr//SuxihAx/4/m3/a2rs
         vfkoI1lZlGgHCIcP0kFVZZP2sharCCFblkwvID7vOGTOvAuBp33NJ6IIHnocqtFkrWUK
         9X/DIvRbOUtZi4yngemvPqqrAeANCu8piiQuuEVqqr2pLPOb3v+7yef10XkGDO8cO/7R
         fdVSJ4brH9J7SHxSZPfynMIwV8M4oVKK/5rW1ku9+wVQI9pnoOh0NJZLOb9DghewMIkS
         AHEA==
X-Gm-Message-State: AO0yUKWcmRY/0TRWm5p9G6f0k/xOPa9v31J2ng1Yk1o0F1CKoYQkZvvV
        0cXzILx5+go2lYE94mj7lHYi0/4uc26YUFsOpb1PvVoxp3uwTh0lWxMi1ydA91uJTGkdTcgkDWd
        sqwzV/Ez1IKVWFffVl9wP0uF0P2w=
X-Received: by 2002:a05:622a:1b8a:b0:3b8:24f0:64f5 with SMTP id bp10-20020a05622a1b8a00b003b824f064f5mr3288101qtb.9.1674830933064;
        Fri, 27 Jan 2023 06:48:53 -0800 (PST)
X-Google-Smtp-Source: AK7set9CuTRK5bqGOg24X8Y7UUk19H25HtZHEZNF5OWDDN3XBCs/Om0IeNqmmiIe5gOXgY7iX4k6wg==
X-Received: by 2002:a05:622a:1b8a:b0:3b8:24f0:64f5 with SMTP id bp10-20020a05622a1b8a00b003b824f064f5mr3288067qtb.9.1674830932756;
        Fri, 27 Jan 2023 06:48:52 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id g13-20020ac8468d000000b003a7e4129f83sm2727982qto.85.2023.01.27.06.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 06:48:51 -0800 (PST)
Date:   Fri, 27 Jan 2023 09:50:05 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y9PkndpTQcHrZ+im@bfoster>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9KXaSkuMZM663Vi@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Jan 26, 2023 at 10:08:25AM -0500, Kent Overstreet wrote:
> On Wed, Jan 25, 2023 at 10:45:24AM -0500, Brian Foster wrote:
> > Hi Kent, list,
> > 
> > I've noticed occasional failures of generic/441 on bcachefs that look
> > something like this:
> > 
> > generic/441 11s ... - output mismatch (see /root/xfstests-dev/results//generic/441.out.bad)
> >     --- tests/generic/441.out   2022-10-11 14:20:36.986202162 -0400
> >     +++ /root/xfstests-dev/results//generic/441.out.bad 2023-01-24 13:33:54.977729904 -0500
> >     @@ -1,3 +1,3 @@
> >      QA output created by 441
> >      Format and mount
> >     -Test passed!
> >     +First fsync after reopen of fd[0] failed: Input/output error
> >     ...
> >     (Run 'diff -u /root/xfstests-dev/tests/generic/441.out /root/xfstests-dev/results//generic/441.out.bad'  to see the entire diff)
> > 
> > This test covers fsync error reporting across multiple fds. What it does
> > in a nutshell is open a bunch of fds, write to them and fsync them, and
> > then repeat that a couple times over after switching to an error table
> > (i.e. dm-error) and back to a working table, verifying error reporting
> > expectations at each step along the way.
> > 
> > The error above is associated with an fsync failure after switching from
> > an error table back to a working table, and essentially occurs because
> > the filesystem has shutdown and the bcachefs inode has a journal
> > sequence number ahead of what the journal shows has been flushed to
> > disk. That makes sense in general because even though the vfs error
> > reporting might not expect an error, the filesystem has been shutdown
> > and fsync has work to do. I've been digging into it a bit regardless to
> > try and understand why the behavior seems transient..
> > 
> > What I'm seeing looks like a matter of timing at the point the test
> > switches to an error table and issues the first fsync (where failure is
> > expected). IIUC, what I think is happening here in the scenario where
> > the test passes is something like this:
> 
> Hey Brian - my understanding of this bug was that it was even simpler.
> 
> As I understand it, the decreed semantics of fsync by the Powers That Be
> are that it should return a given error _once_  - if a subsequent fsync
> returns an error, then there must have been another write that errored.
> 

Yep, that's my understanding as well. This particular test is just
checking that the error reporting spreads across distinct fds for the
same underlying file. I.e., so when writeback fails and sets an error on
the mapping, each open fd/file should see an instance of that error on
fsync (but presumably not repeatedly unless pages are written and failed
again).

> So we just need to plumb our errors from the journal through the
> errseq_t mechanism. The tricky bit is that bch2_fsync() doesn't record
> or check if it's actually doing a journal flush or if the journal flush
> was already done.
> 

That's an interesting idea. I'd have to poke around the errseq stuff and
think about it a bit..

Something else that occurred to me while looking further at this is we
can also avoid the error in this case fairly easily by bailing out of
bch2_fsync() if page writeback fails, as opposed to the unconditional
flush -> sync meta -> flush log sequence that returns the first error
anyways. That would prevent marking the inode with a new sequence number
when I/Os are obviously failing. The caveat is that the test still
fails, now with a "Read-only file system" error instead of EIO, because
the filesystem is shutdown by the time the vfs write inode path actually
runs.

All in all ISTM the shutdown is the fundamental issue wrt to this test.
I'm not sure it's worth complicating the log flush error handling with
errseq and whatnot just to filter out certain errors when the fs has
seen a catastrophic failure/shutdown (also agree with your followup that
isn't the most critical bug in the world anyways).

Either way, I am trying to grok the commit/writeback/journaling path a
bit better here to try and understand why the fs shuts down in this test
whereas other fs' don't seem to. One thing I'm noticing is that this
whole path is rather asynchronous, making it a bit hard to follow. Any
tips on the best way to work through the big picture steps involved in
the path from a trans commit, through journaling, to eventual btree
writeback?

Thanks for the feedback..

Brian

> So I think we'd need to add another sequence number to
> bch_inode_info to track the sequence that was flushed, and then only
> call bch2_journal_flush_seq() if flushed_seq !=
> journal_seq_of_last_update, and then to make this work correctly when an
> inode has been evicted it might need to go in struct bch_inode, stored
> in the btree, as well.
> 

