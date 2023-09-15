Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5232BEE645B
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbjIOM5p (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235149AbjIOM5p (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:57:45 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A591FDF
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:57:39 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-403004a96a4so23481625e9.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694782658; x=1695387458; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DeqZFyNnw7LfJsZNfFmhfXNpjc8pgTjkOeQy3hGEVBk=;
        b=XWr4VHNQTbEgUapjo0gnx7CrNXYyhP1/FW55nK4GB87s8JMCoYXM4TLe6bCrW4A3T8
         XC4aCZAzs0bi39Hb8ma//qBgCq13H6wYuQDFAWwD6Zeh6QrwUYqu+ksE2RDQhHXhiOas
         /E+Hc+Atj7ZOb30Pt/1Q+aZyvSw2IkNT3Stzhkn92uUtB/eCTI4Jc5SE2aRjHL15j/Su
         OGR/q/qGj5+Pi9MVvlAuaA5NZ+kA+LBXq4GugHQu5LEkMbC/TeGeq0JBApXtuwwpLmw3
         fX4nt/QYwSzxQuOADlp04jIe5w28Dp8wOQjwFCLomX9BWn48nTmyFjSRnqsbpA3xgsgu
         k04g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694782658; x=1695387458;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DeqZFyNnw7LfJsZNfFmhfXNpjc8pgTjkOeQy3hGEVBk=;
        b=vankANHa+9xTYgsFFdtN9ge7DweuHhVJoszmPD69m7h+Av2ZVN2A05aPwEQL775JSD
         CPEUlWRRO9u25344qwAjhAAdUZtP3jvP9xufiiU75F/KQnMhYYhVZK8CbMTiXIomBZid
         gnMUwVjopLuDQTYT5ujd32SKh39vS53zQLRYTI/iXGuNy3qS2ZnSbY2o59ti8XbiGPhz
         lzhR+XKGKsNza5CG7ISxHyF98pt4j1KODo+/8ZhVkBbUq7ss79AZyPL8pD9A/agZKvu/
         khWDdI2Vb234dsdx6TwYM+lma9hedGCCJO2lKf+ANMpkAPUyZgo0rPTs7hIfLRinIczM
         tNzA==
X-Gm-Message-State: AOJu0YxmPwwDSTbgTMoaFrMJEdysYDtmTl2jg1DAV7auIzgAuwVe0mvE
        +UIT19NU67j0L98LlyM4TJglJ8UbzGA5BWNxPVA=
X-Google-Smtp-Source: AGHT+IEb0wYArljLQsBryWQz4SePUTq+2JYO3eCRi8PNm1rHamsh7DhkQrq2SO35QgoJIpEtDQvirQ==
X-Received: by 2002:a05:600c:2209:b0:3f9:255e:ee3b with SMTP id z9-20020a05600c220900b003f9255eee3bmr1572313wml.30.1694782658181;
        Fri, 15 Sep 2023 05:57:38 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c22c400b00403b63e87f2sm4585162wmg.32.2023.09.15.05.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 05:57:37 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:57:34 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@linux.dev
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: sleeping in atomic
Message-ID: <cf328a38-b2a6-4cae-8ec0-fb17551623c0@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch 93a640e2570b: "bcachefs: GFP_NOIO -> GFP_NOFS" from May 28,
2023 (linux-next), leads to the following Smatch static checker
warning:

fs/bcachefs/journal_io.c:1461 journal_buf_realloc() warn: sleeping in atomic context
fs/bcachefs/journal_io.c:1662 bch2_journal_entries_postprocess() warn: sleeping in atomic context
fs/bcachefs/journal_io.c:1764 bch2_journal_write() warn: sleeping in atomic context
fs/bcachefs/journal_io.c:788 jset_validate() warn: sleeping in atomic context
fs/bcachefs/replicas.c:439 bch2_mark_replicas() warn: sleeping in atomic context

All this sleeping in atomic warnings start in journal_write_done()
where it takes spin_lock(&j->lock) so preempt is disabled.

The call tree for the first warning is:

journal_write_done() <- disables preempt
-> bch2_journal_write()
   -> journal_buf_realloc()

fs/bcachefs/journal_io.c
    1452 static void journal_buf_realloc(struct journal *j, struct journal_buf *buf)
    1453 {
    1454         /* we aren't holding j->lock: */
    1455         unsigned new_size = READ_ONCE(j->buf_size_want);
    1456         void *new_buf;
    1457 
    1458         if (buf->buf_size >= new_size)
    1459                 return;
    1460 
--> 1461         new_buf = kvpmalloc(new_size, GFP_NOFS|__GFP_NOWARN);

This sleeps.  GFP_NOWAIT and GFP_ATOMIC don't sleep.  But kvpmalloc() is
always going to have to be treated as a sleeping function because it
allocates giant amounts of memory.

    1462         if (!new_buf)
    1463                 return;
    1464 
    1465         memcpy(new_buf, buf->data, buf->buf_size);
    1466 
    1467         spin_lock(&j->lock);
    1468         swap(buf->data,                new_buf);
    1469         swap(buf->buf_size,        new_size);
    1470         spin_unlock(&j->lock);
    1471 
    1472         kvpfree(new_buf, new_size);
    1473 }

regards,
dan carpenter
