Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87212EB64D9
	for <linux-bcachefs@archiver.kernel.org>; Mon, 10 Jul 2023 14:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjGJONF (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 10 Jul 2023 10:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbjGJOMt (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 10 Jul 2023 10:12:49 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08A0135
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jul 2023 07:12:39 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-5704fce0f23so57400097b3.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jul 2023 07:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688998358; x=1691590358;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uDPcZ9Lae/9h5y7VvFj1ershcxcFQe994FM8TFO11d8=;
        b=cjhqQgDnE2q71pnqENmIVOLPX5Y4yu6LlGmR/99dAv/G1bnwIvk0sYMjzIGM/gVBCf
         GRi4RyZbVX/8FBsYwKRrsKbSaM9nllVe3AukXylYeSF0S6kTBtIq0weW6PBgKzyKhyTz
         ToZYnxXQLvmi+WzK7DtzlBLL0nFXwsu8d+pig4IEaPGHd50v4cQHNecI35JAvsEurNWv
         +Lu2yHNfzXw6+zuSqFWtfhWyZ2Ur8rSDCNmrra6PLN+EBXrReC321TQzh/+Vf0Hgnfv9
         MJuv4kAL24o9n4y3UVX12LrLASsxQfZmEiFLukNZRHBGs400s/oX6J/WEbGXDaveir1F
         9RUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688998358; x=1691590358;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uDPcZ9Lae/9h5y7VvFj1ershcxcFQe994FM8TFO11d8=;
        b=YSjMvCYSmf1wrtdfvZV0CAHfz+1r2U9bu3xtEl3dqZzZfizYKqguCCGdzWP9ydL5mM
         BRH7wxNXqYBsPcsgs4ESW8RKtxk8d7PdRGmPOapMx0FUwNKv5LoBQ5yoZaukXrjwE2zY
         TvKKbYvM4mNOvRJhNW4prEDswmn6T6SYdAkColDF4XrEJg7s8xek/mT2N3MbgEAZWhSd
         dGJaWeQ882f+48ZhQmX9DlxIYyPOZ9UkmihGtSMK59YLvPNomn6x53u+S5NMfT7Zi4hy
         ZQ269o08+9Q9BBWEfTURKNZyYDPJ1L1yWXjMGrm7XgJXjS2XlCgt+Nwyav1Tzy48g6zU
         xwew==
X-Gm-Message-State: ABy/qLbM51w345IHuuL2Ik9QAwwL/hG7Vrjg5+n4XqP/Z2QGzOh6VJhi
        9LAx3kVlB4EqYqqQpp4sJ5JHvVP7nei5mbeBvWpuDoIcc/U=
X-Google-Smtp-Source: APBJJlHVruWnayIFdm3umN3MoqrnGkbcxHvAsdi/eUHuGHpJPaPsYdkbDyf3Auu+A8Mbou88Bsz6tlImUCIG2ThKoWs=
X-Received: by 2002:a25:a4c1:0:b0:c18:4f16:aaf6 with SMTP id
 g59-20020a25a4c1000000b00c184f16aaf6mr10991207ybi.58.1688998358571; Mon, 10
 Jul 2023 07:12:38 -0700 (PDT)
MIME-Version: 1.0
From:   Turritopsis Dohrnii Teo En Ming <tdtemccnp@gmail.com>
Date:   Mon, 10 Jul 2023 22:12:33 +0800
Message-ID: <CAD3upLuL3TWYrLOALoMFbM2QdiL8Va=PH3OYZDHZZTrSpfF-_w@mail.gmail.com>
Subject: Linus Torvalds calls for calm as bcachefs filesystem doesn't make
 Linux 6.5
To:     linux-bcachefs@vger.kernel.org
Cc:     ceo@teo-en-ming-corp.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Subject: Linus Torvalds calls for calm as bcachefs filesystem doesn't
make Linux 6.5

Good day from Singapore,

I have just read this article. Thought of sharing it. It looks like an
interesting read.

Article: Linus Torvalds calls for calm as bcachefs filesystem doesn't
make Linux 6.5
Link: https://www.theregister.com/2023/07/10/linux_6_5_rc1_bcachefs/

Thank you.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individual in Singapore
Blogs:
https://tdtemcerts.blogspot.com
https://tdtemcerts.wordpress.com
GIMP also stands for Government-Induced Medical Problems.
