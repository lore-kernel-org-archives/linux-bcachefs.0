Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5A1EB64D9
	for <linux-bcachefs@archiver.kernel.org>; Fri,  7 Jul 2023 17:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjGGRaJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 7 Jul 2023 13:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjGGRaI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 7 Jul 2023 13:30:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6F81FE0
        for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jul 2023 10:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688750972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=xZfKRA5lqSbFPWE4Xeo5Un9keBBdjq+PTkiimLwh1gs=;
        b=SvdMqJtkWynmHWWBEyVN4Yybbg9N7MW4+ieOwDYIZJ9/Ycps0KEi5YXMhfjhuNxRilCYsZ
        LYk7XxkOcryUjLYiAyLt3rVjyzTR6TU1RAEA6zW87rpmjOv+4DqcfKZnb0wz/P0JHCX9Yo
        HizomdEC6zmuzE/1nStU/EQLTBl6i9M=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-aCaGflJhMFC1jmU_s--JVA-1; Fri, 07 Jul 2023 13:29:29 -0400
X-MC-Unique: aCaGflJhMFC1jmU_s--JVA-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4009c8a8d74so21118301cf.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Jul 2023 10:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688750969; x=1691342969;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZfKRA5lqSbFPWE4Xeo5Un9keBBdjq+PTkiimLwh1gs=;
        b=ZQGsK83wW1fsqokMY4boJKcvEzqLiz6U5oG6AFvOn0N90GuVKhVuOxr9FYE8bDXMCh
         QhTgekSvH1rRxo7NnkwBN5NVhV+1+ftKC52+s22My7d3NhClnuLfZtGLjhUo3dTC7+Iv
         AcY3mlyDhdUec5umi1y1MDk5NEtRpyjmbBoNDwBJ7J5QMDW2hNP8uYplfJlVyXWA2iU/
         /87ujOVzd6bnon7eY5Xz01tUgi3hVwSTRsQ1z132a12jFJd5Y4yMtwKuejc0fNtAkz1P
         YGxwrse4bLBu0DEwWQOyM69I4qRrx3F5l2fH7rdaOha+QqNo3Q1iPY7Vwswmspc2L0rT
         NNMA==
X-Gm-Message-State: ABy/qLbgOcbCxx0fdXIusLTr8cZd/ng4kl/5eoDb/Jom2hLi3CypZdw2
        /I3eoo0Q3nrQ3uLesyv8rdIZI/0EP+QV4LpSrt764cVo5wXVeMXN56KE6yA/CWAjdbTQm8URWbB
        dToQxREsOhhDVMbDizSEIkPxNEtVPRveMYXD7mEqdMJ2V5c2BCVza2WqZXXCFNT85lVYQQC47o0
        WIfI7tDEtS/Q==
X-Received: by 2002:a05:622a:18a6:b0:400:84e2:74d8 with SMTP id v38-20020a05622a18a600b0040084e274d8mr5913418qtc.25.1688750968978;
        Fri, 07 Jul 2023 10:29:28 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGYMZn1impL8xxAXdY9CKowhf4jf0bDaBJGhH5sy975QxRCvFf+aCYRlfEeNeBcosuZAhs9LQ==
X-Received: by 2002:a05:622a:18a6:b0:400:84e2:74d8 with SMTP id v38-20020a05622a18a600b0040084e274d8mr5913393qtc.25.1688750968619;
        Fri, 07 Jul 2023 10:29:28 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id i18-20020ac80052000000b003fe0a89447fsm1963927qtg.14.2023.07.07.10.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 10:29:28 -0700 (PDT)
Date:   Fri, 7 Jul 2023 13:32:09 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: bcachefs backpointers errors in no write buf mode
Message-ID: <ZKhMGZBokKMq5p1P@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent,

I'm doing some analysis of these "existing backpointer found when
inserting" errors observed when running generic/388 in
backpointers_no_use_write_buffer=1 mode. To start with context, here's
what I see in one particular variant of the issue...

We're in read bio completion path doing a CRC narrow. The commit for
that transaction runs trans triggers on the extent key, which then falls
into bch2_trans_mark_extent() and attempts backpointer updates from
there. I stuck a warning in the backpointer error checking code just to
get a stack trace for the error context, which is appended below for
reference.

On IRC Kent mentioned this was likely a trigger ordering issue and that
something similar was addressed in the normal backpointer write buffer
update path. I think I follow what's going on there from commit
0a1b82456400 ("bcachefs: btree write buffer update ordering"), but the
context for the no write buf path seems a bit different..

WRT ordering, if I follow the code correctly, run_btree_triggers() in
the commit path basically implements an overwrite followed by !overwrite
pass, except if the old and new key type/triggers match we call into
bch2_trans_mark_key() with both the old and new keys. This calls into
bch2_trans_mark_extent(), which then implements an explicit insert ->
overwrite order. If that falls into the backpointer write buffer path,
that then has to reorder the updates in the write buffer by putting the
overwrite update at the head, presumably so it won't remove the
backpointer insert that is about to be added. (I assume there are
legitimate design reasons for the update ordering at each level here,
but the reordering back and forth seems like unfortunate complexity.)

This raises a few questions wrt the non write buffer path. First, the
existing bp error check lives in
bch2_bucket_backpointer_mod_nowritebuffer() before we even call into
bch2_trans_update(), so changing the order of trans updates doesn't seem
like it would avoid this particular error. I don't think we want to
change the high level order of the extent key trigger, so that means we
probably need to do something with the error check itself.

It also seems like this is possibly different from whatever issue lead
to the ordering fix in the write buf path, though I'm not quite sure how
that one manifests or is reproduced. A missing backpointer due to
unexpected bp removal, perhaps? If so, I suppose I could see why the
updates should be reordered in the non-buf trans, assuming the overwrite
would delete the just inserted bp key from the trans (and then btree on
commit), and perhaps I'm just not seeing that because I hit the existing
bp error check first.

So I'm still trying to piece high level things together such that an
appropriate fix is not yet clear to me. I'm wondering if perhaps the
high level (narrow crc) trans needs a flag to modify the bp checking
behavior to indicate we aren't actually inserting a new bp here (so
seeing an existing one is fine/expected), and then subsequently
bch2_bucket_backpointer_mod_nowritebuffer() needs to do something to
turn the "insert" into a bp key overwrite, and perhaps ignore the higher
level overwrite, or something *handwavy* along those lines.

I need to think about this some more, but wanted to put some thoughts
down in case I'm misunderstanding things or there's an obvious fix I'm
just not seeing yet..

Brian

--- 8< ---

WARNING: CPU: 1 PID: 31479 at fs/bcachefs/backpointers.c:128 backpointer_mod_err.isra.0+0x193/0x1b0 [bcachefs]
...
CPU: 1 PID: 31479 Comm: kworker/u16:4 Tainted: G        W  OE      6.4.0+ #68
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc36 04/01/2014
Workqueue: events_unbound __bch2_read_endio [bcachefs]

RIP: 0010:backpointer_mod_err.isra.0+0x193/0x1b0 [bcachefs]
...
Call Trace:
 <TASK>
 ? backpointer_mod_err.isra.0+0x193/0x1b0 [bcachefs]
 ? __warn+0x7d/0x130
 ? backpointer_mod_err.isra.0+0x193/0x1b0 [bcachefs]
 ? report_bug+0x18d/0x1c0
 ? handle_bug+0x41/0x70
 ? exc_invalid_op+0x13/0x60
 ? asm_exc_invalid_op+0x16/0x20
 ? backpointer_mod_err.isra.0+0x193/0x1b0 [bcachefs]
 bch2_bucket_backpointer_mod_nowritebuffer+0x15b/0x210 [bcachefs]
 ? bch2_bucket_backpointer_mod_nowritebuffer+0x5/0x210 [bcachefs]
 bch2_bucket_backpointer_mod+0x2ad/0x2c0 [bcachefs]
 bch2_trans_mark_pointer.constprop.0+0x34d/0x360 [bcachefs]
 ? bch2_trans_start_alloc_update+0x5/0x140 [bcachefs]
 __trans_mark_extent+0x1c5/0x3e0 [bcachefs]
 ? __trace_bprintk+0x54/0x60
 bch2_trans_mark_extent+0x9f/0xe0 [bcachefs]
 run_btree_triggers+0x1ae/0x330 [bcachefs]
 __bch2_trans_commit+0x92/0x1e70 [bcachefs]
 ? __bch2_rbio_narrow_crcs+0xbb/0x380 [bcachefs]
 bch2_rbio_narrow_crcs+0xbf/0x100 [bcachefs]
 ? bch2_rbio_narrow_crcs+0x45/0x100 [bcachefs]
 __bch2_read_endio+0x7c7/0x8f0 [bcachefs]
 ? process_one_work+0x1c8/0x3c0
 process_one_work+0x1c8/0x3c0
 worker_thread+0x4d/0x380
 ? _raw_spin_lock_irqsave+0x23/0x50
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xf3/0x120
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2c/0x50
 </TASK>

