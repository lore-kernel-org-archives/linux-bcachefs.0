Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A731EC05027
	for <linux-bcachefs@archiver.kernel.org>; Thu, 26 Jan 2023 15:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbjAZPOZ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 26 Jan 2023 10:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjAZPOU (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 26 Jan 2023 10:14:20 -0500
X-Greylist: delayed 346 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Jan 2023 07:14:19 PST
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9F36B9A9
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Jan 2023 07:14:19 -0800 (PST)
Date:   Thu, 26 Jan 2023 10:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674745708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JfW7vJS8aC1rDUQ5N3zvvnVkC4A+V4bIehJyufFcR70=;
        b=azvBWrrbfmeb/tx0zUbBpJQJRBkeYeoH/ziZ6dB4Ceb3JaeM997TDPbNwa6aJ+Nbsq2AHp
        bgJerIL3FfCVR3pot5aHJqdwnh6Dnq3a6yu3W635tDoHBzOhMM4Gy+WB34gboAn6fjXtrB
        obzmLXyFsTZsWBfj+iojxgz3oWWcv2Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y9KXaSkuMZM663Vi@moria.home.lan>
References: <Y9FOlMILXFcNFsSW@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9FOlMILXFcNFsSW@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Jan 25, 2023 at 10:45:24AM -0500, Brian Foster wrote:
> Hi Kent, list,
> 
> I've noticed occasional failures of generic/441 on bcachefs that look
> something like this:
> 
> generic/441 11s ... - output mismatch (see /root/xfstests-dev/results//generic/441.out.bad)
>     --- tests/generic/441.out   2022-10-11 14:20:36.986202162 -0400
>     +++ /root/xfstests-dev/results//generic/441.out.bad 2023-01-24 13:33:54.977729904 -0500
>     @@ -1,3 +1,3 @@
>      QA output created by 441
>      Format and mount
>     -Test passed!
>     +First fsync after reopen of fd[0] failed: Input/output error
>     ...
>     (Run 'diff -u /root/xfstests-dev/tests/generic/441.out /root/xfstests-dev/results//generic/441.out.bad'  to see the entire diff)
> 
> This test covers fsync error reporting across multiple fds. What it does
> in a nutshell is open a bunch of fds, write to them and fsync them, and
> then repeat that a couple times over after switching to an error table
> (i.e. dm-error) and back to a working table, verifying error reporting
> expectations at each step along the way.
> 
> The error above is associated with an fsync failure after switching from
> an error table back to a working table, and essentially occurs because
> the filesystem has shutdown and the bcachefs inode has a journal
> sequence number ahead of what the journal shows has been flushed to
> disk. That makes sense in general because even though the vfs error
> reporting might not expect an error, the filesystem has been shutdown
> and fsync has work to do. I've been digging into it a bit regardless to
> try and understand why the behavior seems transient..
> 
> What I'm seeing looks like a matter of timing at the point the test
> switches to an error table and issues the first fsync (where failure is
> expected). IIUC, what I think is happening here in the scenario where
> the test passes is something like this:

Hey Brian - my understanding of this bug was that it was even simpler.

As I understand it, the decreed semantics of fsync by the Powers That Be
are that it should return a given error _once_  - if a subsequent fsync
returns an error, then there must have been another write that errored.

So we just need to plumb our errors from the journal through the
errseq_t mechanism. The tricky bit is that bch2_fsync() doesn't record
or check if it's actually doing a journal flush or if the journal flush
was already done.

So I think we'd need to add another sequence number to
bch_inode_info to track the sequence that was flushed, and then only
call bch2_journal_flush_seq() if flushed_seq !=
journal_seq_of_last_update, and then to make this work correctly when an
inode has been evicted it might need to go in struct bch_inode, stored
in the btree, as well.
