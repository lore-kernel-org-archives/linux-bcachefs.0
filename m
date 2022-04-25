Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6919C433F5
	for <linux-bcachefs@archiver.kernel.org>; Mon, 25 Apr 2022 05:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241298AbiDYFlL (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 25 Apr 2022 01:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbiDYFlJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 25 Apr 2022 01:41:09 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDE5DB9
        for <linux-bcachefs@vger.kernel.org>; Sun, 24 Apr 2022 22:38:04 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id q20so8586827wmq.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 24 Apr 2022 22:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=MvxycxMawhzSKA0lvWI7jqRwPqbTC8pt+WNZf+CFJC4=;
        b=P6DC6SsCENQ8YrdsRwNj6h8inn9bPM5XX2AG7CBaEeAe0GioUgQ65kvL37dvM5DBP8
         OTXlDC6DNX32UQFh7dQXMQqqKvqidb7AqlFMKZgyTD2LYTf1Szb4ILMmW84jUhSUIsEe
         34fB2UKssJBB1wIX6DJY8cn1Qd7Xtyps4F0SM25mv1by/UrAtjYL2duqs3YQOoqpOf7J
         TR+bKeyJ2VuNsPVd4LCucg+k+7dZhOT62d9DON9NsRCRYJ13AVcMHLtyfBM+K0pxECfW
         oMJYF8EWPjsFjqjLYM/kAhN2jxGSNFxAUrKK6iG8uwX0iKVuy1G0804ENMXlBaOUR0fz
         fo1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MvxycxMawhzSKA0lvWI7jqRwPqbTC8pt+WNZf+CFJC4=;
        b=d5M2XQVY9Ps7AQd+qbry9406uHzpDromfX67wK1/8CDZ/+GMckDjyHDcFgZx6TVIyz
         9ZYvbCefRol/HDaEsJKK5ZMnNkF0JNRHRfRfG/hYb7QLziTVmKl/1vnPJBGqwDKpmBoh
         AUYspEMxlmRXwhKhiQBY8ErD+IMgY5y4BcAS2ufmor5GLfhMiJBSq6qXDJg3hnyE19KA
         hgL1ncywL90FsO/bfJ/4oB+JNRKO39wmhUEfAdKAL/DqF+R5yGrNKw1I1+xVS7KPO6vj
         AVrclA3pfB/jtTxBPgptnBOa9DOV/IY7/k6ydrU5SYx52T9vM+M0aP1grGp9Li4GTFf5
         xFow==
X-Gm-Message-State: AOAM532D9Zon4F0zvRxOY8fzDnIM42sjejjWY7Hg185zlY93+iF5MBX8
        fEcOjDqrR5v4pxioE0Ofy6Uop8eO2JONzyVt2QU9aLUmiK0=
X-Google-Smtp-Source: ABdhPJxv9GGlGLCnuObyrHe8wysKYnDx1nkJeB1u9WNZNvZiClm8wmD+u/f64cD88yF4fj8OqK6sCn85HH+GlPXGTFY=
X-Received: by 2002:a05:600c:600c:b0:38e:cb2f:318b with SMTP id
 az12-20020a05600c600c00b0038ecb2f318bmr14942438wmb.121.1650865082895; Sun, 24
 Apr 2022 22:38:02 -0700 (PDT)
MIME-Version: 1.0
From:   Wout Mertens <wout.mertens@gmail.com>
Date:   Mon, 25 Apr 2022 07:37:51 +0200
Message-ID: <CAO3V83+SSfYXLj18NvkVzJ68K3LxdPQnG0U-Zhnq+ZQLp5p0wA@mail.gmail.com>
Subject: content-addressed storage?
To:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi,

I'm idly wondering if bcachefs could support lookups and reuse of
variable-size chunks based on their hash checksum, thus allowing
deduplication.

So, instead of using a user-level storage layer like
https://github.com/systemd/casync, it would be a layer deeper, inside
bcachefs.

Would that be more optimal in memory/cpu/disk, or would it not make
much difference besides comfort?

As a quick overview, casync splits files into chunks. The chunks are
variable-sized based on their content using a rolling hash, which
makes insertions and deletions change only the affected blocks and not
the blocks following them. Then, the chunks are compressed and hashed,
and stored under their hash.
So files stored this way are lists of variable-size hashed chunks. If
two files are similar, they will be sharing a lot of the chunks
automatically.

A straightforward implementation would result in a single directory
with millions/billions of small files. Is that something bcachefs can
handle?

Inside bcachefs I'd instead imagine a btree with all the chunks as
extents, keyed by their hash, and files somehow being able to
arbitrarily point at those extents.

Thoughts? Just musing.

Wout.
