Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED644C433EF
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 16:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8021604AC
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 16:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhJXQ40 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 24 Oct 2021 12:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhJXQ40 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 24 Oct 2021 12:56:26 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE55C061745
        for <linux-bcachefs@vger.kernel.org>; Sun, 24 Oct 2021 09:54:05 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id r15so9619148qkp.8
        for <linux-bcachefs@vger.kernel.org>; Sun, 24 Oct 2021 09:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N+HOIud0HutlYVtFOK8OcaJnbmW3rN4LV3Ow0k5+ugE=;
        b=VFJcJcLe45GgCF8TtRU1miNdn+ASI6/3MxbNGesvPqnNPZQDlgxSDwVQIwFhU6kz2L
         tKtWQuyU9jDsxas0KXqpR5TDTMjOQV7xsc4rqQhbPs8a2FiP3oCic4GCxhmHKrlmJ48y
         qKRxtACQ1MJJe/y/yeOKD4wRgpd3GIE4E+rt70JLlwg55vx/3FAVmbMORiANNc1JaiA/
         vEYXyMJZXRz+Gby15J+UHLSz0nnlx959+G+w+yRM3SqQdfiQIHCsBRpdK2dIH4Sq90rX
         ptPRRTghfiyOXlJiQa+UISmsOcei95I7qeE4gSZ/gnIZtc0+b26jwhHkX0+o0K1p3NU6
         8RXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N+HOIud0HutlYVtFOK8OcaJnbmW3rN4LV3Ow0k5+ugE=;
        b=PbiPvffrNaoh3HAxAVaB0N9ii89Wb4XGIe/od83Z7tlSoplzjKAxBJZ7R7L9Nq8e/O
         NLmnDPO/1ilC1nJtW4R0Q9Lnd6dC20KUvTx/ss9CFhiKzQDxqksELXktU3U25Jpb7Zm2
         lh1+pRI8dLxUmedR/GykY2L5Y24rlXvJnrMxdvtmQpeP8wKpl5989GFb25Z9fT3770hT
         s76sQlNlrY0dZg16trf5U3svr+SEM9Ni0ZkBESyuU+wvrm6JfCGCKcyGdtrBQE/mWQTb
         A+HiJqwkeABMGVgX/1s3cJUgSj8cV32Kgn95Rp4llvYy0hTSYuL/+d8kVFShFV3K4scV
         /NTQ==
X-Gm-Message-State: AOAM532adLTolJncgQnswsJ6QDZHnBkel4E1bDulMrFsJTxnKirxL6sV
        pAWPjs9zCh1lD1r2Y1vyaLcaxcvJPw==
X-Google-Smtp-Source: ABdhPJwgxdCKRIFWoeSxC7o1FFCC31ACmt4V8ZxOjYgNZx53l4ikHEaBM2T+Va5f0QlTcqNLHsIMqA==
X-Received: by 2002:a37:a48d:: with SMTP id n135mr9405334qke.296.1635094444771;
        Sun, 24 Oct 2021 09:54:04 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id h2sm7621282qkf.106.2021.10.24.09.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 09:54:04 -0700 (PDT)
Date:   Sun, 24 Oct 2021 12:54:02 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Chris Webb <chris@arachsys.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Kernel hang with excessive resize-journal on replicated fs
Message-ID: <YXWPqn3qtSiTIw+F@moria.home.lan>
References: <20211024132638.GI11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024132638.GI11670@arachsys.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Oct 24, 2021 at 02:26:39PM +0100, Chris Webb wrote:
> The following ktest hangs in the kernel instead of producing an error from the
> excessive journal resize:
> 
>   test_oversize_journal()
>   {
>       bcachefs format --errors=panic --replicas=2 /dev/sd[bc]
>       mount -t bcachefs /dev/sdb:/dev/sdc /mnt
> 
>       # should fail, but actually hangs:
>       ! bcachefs device resize-journal /dev/sdb $(blockdev --getsize64 /dev/sdb)
> 
>       umount /mnt
>   }
> 
> (It would correctly return with an error on a single-device filesystem.)

Cool find, and nice test :)

> The kernel is continuously looping on ret == -EAGAIN in
> bch2_set_nr_journal_buckets. The disk reservation (unexpectedly) succeeds but
> __bch2_set_nr_journal_buckets then keeps returning -EAGAIN because
> bch2_bucket_alloc (correctly) fails.
> 
> Is the problem here that the disk reservation isn't confined to the specific
> device we then want to allocate from? So although the space is available, it's
> not available solely on the device where we want it?

Yes. This isn't uniquely a problem with journal allocations - I think it's still
possible to hit a hang like this by doing replicated writes on a two-device
filesystem with devices with mismatched sizes.

I haven't figured out what the right solution is yet. One (easier) thing that
needs to happen is that disk space allocations need to be changed to
interruptible, or at least killable sleeps. The closure code doesn't have good
support for that, though.

Relevant idea I had awhile back - meant to apply it to standard kernel
wait_queue_head_t, should be just as easy to apply to closure waitlists which is
what we're using here: wait lists should be embedding a sequence number, which
is incrementing on wakeup. Then instead of adding ourself to the waitlist and
checking the wait condition, we read the sequence number and check the wait
condition; then we sleep until the sequence number is different from the one we
originally read.

This would be useful for standard kernel wait lists because right now,
prepare_to_wait() changes the task state, and that needs to happen before
checking the wait condition so that wakups will set it back to TASK_RUNNING
without racing. But changing the task state greatly restricts the code that can
be run inside the wait condition (no mutex_lock()!).

This would be useful for closure waitlists for a different reason - putting a
closure on a closure waitlist doesn't change the task state, but we can't take a
closure off of a waitlist without taking _everything_ off the waitlist (doing a
wake_up_all()) because closure waitlists are singly linked (and lockless) -
which is what we need to do when the operation is interrupted or the task is
killed.
