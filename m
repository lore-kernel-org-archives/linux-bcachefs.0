Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA741EB64DC
	for <linux-bcachefs@archiver.kernel.org>; Fri, 21 Jul 2023 13:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjGUN1q (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 21 Jul 2023 09:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjGUN1p (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 21 Jul 2023 09:27:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA81D30DB
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jul 2023 06:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689945952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=1ipY6W1GICBbcF9X2tfEiAVuQfb4rEvyVjigT2xCx4I=;
        b=EYOMg7j2ccySxzdqB7b1h7kIsMWJ3MM9Bvsas317I6P8jVS0tNkFe1TFSxloCNKHdq/+4v
        H0qNpr6k/d+9Ku1WCB/u/9mlbmnW7libRCxF/AoLlYxPFXZJrwPH2Q1gw68Qlu0qHTU683
        uj4reMkvN7bAiZShgnhD56rBvXhajKU=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-wDzqjqeLOFegak1bBINDew-1; Fri, 21 Jul 2023 09:25:46 -0400
X-MC-Unique: wDzqjqeLOFegak1bBINDew-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3a3a70425b4so4421171b6e.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jul 2023 06:25:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689945945; x=1690550745;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ipY6W1GICBbcF9X2tfEiAVuQfb4rEvyVjigT2xCx4I=;
        b=WXWDG13/SdwCbggngwKaP4UqDLeGrbvAhnZeO2Y81XinOVWhFaIm0Q9cCHx+7zJ9xC
         RG7p5yb4q0pb18TOT7KQAVk+1ph3pgiG8e8rK4B7EcTVIqVUOIgY2WcdiZs+1TVB/MI2
         IQnW3NXbz76xJg/pCDwrlOtE6gOVTprqIAudmk6cV9JUZaeEYYzzGzTHZm/9TKOJmmzC
         bapBFm5yNZm/o5IpMJc8mc9s42hUE7w9o21Yt7CTdmJaYMKuQqDpURWuEzGuMFbHXxkS
         S6DC8t01R7chiqkLZ8wAeHh0q3aWGKS5b7wRDevwg+AW/UaSMNdnrClSa7+xpgREzRgf
         FiJw==
X-Gm-Message-State: ABy/qLbePmLPS3h2vFDFiFFpNUF6jbAExy975O0QrVqpM6YlRkQMoL0c
        pFuSpV83qbGj1AirX/hkbfVfgF+o26pbIZa6fJsSlSPw0rJzfBpkBhWXCi+5Q2zfVUbQIbrgSfg
        +RSws/PVqkwQUziTabYryIqthxZSLiaiv0rN+6hHr9Kb7OcS0W/0+KW/ISUlZMQzBZw/iErlm3d
        OZj2Bs12G1EA==
X-Received: by 2002:a05:6808:3a98:b0:3a1:b9d7:3821 with SMTP id fb24-20020a0568083a9800b003a1b9d73821mr1858059oib.37.1689945945333;
        Fri, 21 Jul 2023 06:25:45 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHt5k3oQJUpaZGzflCToRWIOYih2XH5gS5xRYuup1RQ1cPnDl1iYwqp5Upp9++/6rOh8yK8OQ==
X-Received: by 2002:a05:6808:3a98:b0:3a1:b9d7:3821 with SMTP id fb24-20020a0568083a9800b003a1b9d73821mr1858039oib.37.1689945944938;
        Fri, 21 Jul 2023 06:25:44 -0700 (PDT)
Received: from bfoster (c-98-217-90-195.hsd1.ma.comcast.net. [98.217.90.195])
        by smtp.gmail.com with ESMTPSA id t9-20020a0cde09000000b00631ecb1052esm1260863qvk.74.2023.07.21.06.25.44
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 06:25:44 -0700 (PDT)
Date:   Fri, 21 Jul 2023 09:28:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [BUG] bcachefs fallocate btree lock contention
Message-ID: <ZLqIB3k600oAS3G1@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all,

When testing the recent write buffer journaling series, I reproduced
several fstests (i.e. generic/013) that seemed pretty much hung up in a
livelock in fsstress. On some further digging, it appears they were
stuck doing fallocates and were spinning heavily on transaction
restarts. I don't think these tests are stuck indefinitely, but rather
this manifests as some excessively long runtimes for tests that involve
concurrent fsstress runs. I was eventually able to reproduce the same
behavior without the write buffer patches, so it doesn't appear to be
related.

I think the issue is basically that if multiple fallocates are running
against independent inodes that might update the same extent btree node,
the __bchfs_fallocate() loop can get into a tight spin due to the lock
cycling around bch2_clamp_data_hole() contending with node updates. This
is where I see most restarts, and I've seen upwards of 100k+ restarts
and single fallocate latencies of tens of seconds. This is pretty
trivial to reproduce by just running concurrent sequential fallocates to
different files (8x or so on my test vm pretty much grinds things to a
halt) [1].

One question that comes to mind: why do we cycle locks here? Is this a
lock ordering requirement between folio locks and btree node locks?

To test the above, I ran with a quick hack to check for pagecache pages
before we decide to clamp the range during fallocate. This speeds up the
test significantly and pretty much removes the bottleneck. This only
handles the simple case and doesn't quite feel like the proper fix to
me, but since I'm low on time I threw it up on CI [2] for reference and
to get a test cycle. I'm heading on vacation for the next week+, so I
wanted to throw this up on the list so at least folks are aware of it if
any excessive test latencies are observed.

Any thoughts are appreciated in the meantime. I'll pick it up once I'm
back..

Brian

[1] Example sequential fallocate reproducer. Run against multiple files:

offset=0
while [ true ]; do
        xfs_io -fc "falloc ${offset}k 512k" $file
        offset=$((offset + 512))
done

[2] https://evilpiepirate.org/~testdashboard/ci?branch=bfoster&commit=d755bfd22fe0fabf8def3bfa0b758864538f79cd

