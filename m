Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33F3C54E94
	for <linux-bcachefs@archiver.kernel.org>; Wed, 25 Jan 2023 15:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbjAYPpE (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 25 Jan 2023 10:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbjAYPpD (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 25 Jan 2023 10:45:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747663867B
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 Jan 2023 07:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674661455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=tEt7Q1/r8y0k1WkcEB/B05kL8WxhpGE85spzlaRCJ+4=;
        b=IDejAEYp+uNNuuasN6xfqJXvc/eHrD1HA7f+ICBvA9Anj5Yi4oLzBWRJs3kxDtbcYN3zog
        5jmY41XhR59vqaeDsSrYKy2ne7Sq2rlRlDeBHUBznS4VCqStVGIeOGvNYmaRWmYzVZMybj
        bL0XwB5mlzERsJ80sglP33xBje4FaxQ=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-186-51PQfgjCNiShvKXw6lty0g-1; Wed, 25 Jan 2023 10:44:13 -0500
X-MC-Unique: 51PQfgjCNiShvKXw6lty0g-1
Received: by mail-ua1-f70.google.com with SMTP id y10-20020ab0560a000000b003af33bfa8c4so5703168uaa.21
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 Jan 2023 07:44:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tEt7Q1/r8y0k1WkcEB/B05kL8WxhpGE85spzlaRCJ+4=;
        b=vMhMaLtLC5HBMdfR1FerslpeF6m6mEfHVJl8VgoLpIhBV4OQjxopaimkYw/fswSbII
         UGZz9sewTlwcNa/PaFPFv5ePnBuVNPf55oZ3cK5P/zhf89odxb33ZSjD4GByu1MfM8Zj
         9MnvMhrDSryUEyjKSqy/qcmxB5uwTpQhSGc6m29sPCtEBL8SuslgEjJmGfQJPwPj+fOj
         DyoccWct/L/UUSRMBI5zqUmq6Z5oYpvWbpYFAkPeinyNzJtYbC413RxBKjh682foORSa
         sIsMclIxxhvHYy+e7CGngqQz7e5CBybkW/trhwCzL8OhocNrFmk6uvHg5muBHl0LY+64
         id5Q==
X-Gm-Message-State: AFqh2koxaVPlSK0Q6hKKUTN5eK0rsKwD9sv9iO0xXjTQuqISgGqVX7JP
        4oudJC9OBCqvyjRlM6Op7HvLZaEQy6vMjoPUca6dGX4rCezLunGVL0a09QaReVz5dgEepCaUEIe
        BgXXM+4bdXxGLN4h7YkOT8PXRoIBXkO27bBfM/w/S/42Sg9rJ0Y+Pkc9nJ0EjdcIykFBFwDjWnH
        y4iA==
X-Received: by 2002:a05:6102:290b:b0:3d0:ec6c:239 with SMTP id cz11-20020a056102290b00b003d0ec6c0239mr22844816vsb.14.1674661451798;
        Wed, 25 Jan 2023 07:44:11 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtL2LHkRFSoUiIUI2QfFeRIgeuTisTHazq+xuLmR2IhK2FnY/obIa/8MfFvj2ckcK5X1cLLow==
X-Received: by 2002:a05:6102:290b:b0:3d0:ec6c:239 with SMTP id cz11-20020a056102290b00b003d0ec6c0239mr22844795vsb.14.1674661451325;
        Wed, 25 Jan 2023 07:44:11 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id x3-20020a05620a12a300b006fa4ac86bfbsm3658662qki.55.2023.01.25.07.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 07:44:10 -0800 (PST)
Date:   Wed, 25 Jan 2023 10:45:24 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y9FOlMILXFcNFsSW@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent, list,

I've noticed occasional failures of generic/441 on bcachefs that look
something like this:

generic/441 11s ... - output mismatch (see /root/xfstests-dev/results//generic/441.out.bad)
    --- tests/generic/441.out   2022-10-11 14:20:36.986202162 -0400
    +++ /root/xfstests-dev/results//generic/441.out.bad 2023-01-24 13:33:54.977729904 -0500
    @@ -1,3 +1,3 @@
     QA output created by 441
     Format and mount
    -Test passed!
    +First fsync after reopen of fd[0] failed: Input/output error
    ...
    (Run 'diff -u /root/xfstests-dev/tests/generic/441.out /root/xfstests-dev/results//generic/441.out.bad'  to see the entire diff)

This test covers fsync error reporting across multiple fds. What it does
in a nutshell is open a bunch of fds, write to them and fsync them, and
then repeat that a couple times over after switching to an error table
(i.e. dm-error) and back to a working table, verifying error reporting
expectations at each step along the way.

The error above is associated with an fsync failure after switching from
an error table back to a working table, and essentially occurs because
the filesystem has shutdown and the bcachefs inode has a journal
sequence number ahead of what the journal shows has been flushed to
disk. That makes sense in general because even though the vfs error
reporting might not expect an error, the filesystem has been shutdown
and fsync has work to do. I've been digging into it a bit regardless to
try and understand why the behavior seems transient..

What I'm seeing looks like a matter of timing at the point the test
switches to an error table and issues the first fsync (where failure is
expected). IIUC, what I think is happening here in the scenario where
the test passes is something like this:

1. With the working table in place, the bch2_vfs_write_inode() ->
bch2_write_inode() path commits a transaction with pending changes to
the inode. These changes end up in some sort of cache (i.e. key cache?).

2. The bch2_flush_inode() path flushes the journal based on the sequence
number in the inode.

3. Sometime shortly after that, journal reclaim kicks in presumably to
write out pending btree node data and release the item from the journal.
Since the test switches to an error table after fsync() return, this
async (workqueue) journal reclaim context is what typically first
encounters I/O failures and essentially shuts down the fs (i.e. we end
up in bch2_fs_emergency_read_only()).

4. The test switches back to working context. The next fsync loop
appears to succeed even though the fs is shutdown because
bch2_vfs_write_inode() transaction commit fails with -EROFS in the
commit path, which means the inode sequence number is not updated by the
bch2_mark_inode() trigger, and thus bch2_flush_inode() appears to have
nothing to do and returns 0.

In the case where the test fails, the journal reclaim context in step 3
appears to race with the transaction commit in step 4 such that
bch2_mark_inode() is called, updates the inode seq number, and
transaction commit actually succeeds before the fs is shutdown. By the
time bch2_flush_inode() is called, however, the journal->err_seq value
has been set and the flush returns -EIO back to userspace.

So all in all this doesn't really seem like a bug. The fs is shutdown
either way and the error depends on whether fsync needs to flush the
log. I was trying to think about whether this could be improved slightly
to perhaps be more consistent and avoid spurious test failure.  For
example, an artificial delay after the dm-table switchover seems to
always prevent the problem because it ensures journal reclaim has
processed the error before a subsequent fsync has a chance to bump the
inode sequence number.

There's still a lot I don't understand here on the bcachefs side, so
after poking around a bit I didn't see anything terribly obvious that
might prevent this in the fs itself. AFAICS there is no serialization
between journal reclaim and the transaction commit, so something like
rechecking journal error state after the transaction is locked (but
before the mem triggers are run) seems like it could help reduce the
race window, but not necessarily prevent the race. Is that accurate? If
so, any other thoughts on how we might prevent this particular failure?

Sorry for the longish writeup on what likely amounts to a minor
behavioral quirk... I dug into it as sort of a proxy to help get more
familiar with the code, so if the right approach is basically to leave
things as is (and/or potentially tweak the test to keep it quiet), then
that seems reasonable to me as well.

Brian

