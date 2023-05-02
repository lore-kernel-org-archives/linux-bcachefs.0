Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD64FC77B7E
	for <linux-bcachefs@archiver.kernel.org>; Tue,  2 May 2023 14:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjEBO5V (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 2 May 2023 10:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbjEBO5U (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 2 May 2023 10:57:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5673D94
        for <linux-bcachefs@vger.kernel.org>; Tue,  2 May 2023 07:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683039392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=1emxf3KmIeJt6+7G6RYzsglhtI/P4qQVCZgFrlLQcVk=;
        b=JD2ia2KbXsSlbbBVfWXDdsTHXLNfXh8pAFfP8bkQZvugYIjRmtwAB49v7qZP/kRptXVMoC
        M2yEe0zQ2ujgjmz/xo4Q/a/xiQsMe7mqQ9HHUKL7HTUJVQ+V70IrZnZY1XyXLw6OFjaVbs
        xocKwTfhhpa9rmYAsY0liw1AwrfALUM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-Iy_gdoLPNya6hc_bjTT_SQ-1; Tue, 02 May 2023 10:56:31 -0400
X-MC-Unique: Iy_gdoLPNya6hc_bjTT_SQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3ef65714d24so51359391cf.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 02 May 2023 07:56:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683039390; x=1685631390;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1emxf3KmIeJt6+7G6RYzsglhtI/P4qQVCZgFrlLQcVk=;
        b=dxsD06XMiNouq3BXHeMVspLLngqSILpzGTua8i0YZnptGbnPMlroE09EsIJbVAIEVG
         84utsoAE2zlRbnB2ouJKWPlmeDDq9mNWBGX6t7Xvk8ayGzkKhaOHuYEKL7GJ8CD43las
         GFaKD3bXRcxzsQhz5G1XAhvr1uRi9Tbf7sAoYrXtxSN8EjiRzIcqMjCd1/TQDpyQLL9v
         5uk7oGe3S0IqilBxGgJ5BfeGsdLHSMlzobQ768lnRIW6NN7oCknv2zJ7HW8WKkszwieo
         JSub3omKaQO9SOMzeAOFuxZ/OXNLNm10slBvwx60sGAAonp+hbng06alfjoEQR+PnHhO
         6LGw==
X-Gm-Message-State: AC+VfDzbDvyUjpWGfQY+K3rGtAtKU3en62Gzqmuulr3ExhOnTz91+oCv
        +ZufJTq0+saZSrMwa1K1w581j6EwTMgvKHzTKK3lTcuBBPs+UaHpRJEfLzMqqGOIBdzBusep0v+
        ZHQzluMr9qlrY76uG9F4gh8kF1YSzY/BOcF+xVdnfqnbbKaVobljADfnlStjvoQllB2MsyB9oMm
        XHPszpdMuoeg==
X-Received: by 2002:ac8:5b8e:0:b0:3e4:dece:cd16 with SMTP id a14-20020ac85b8e000000b003e4dececd16mr27756444qta.67.1683039390559;
        Tue, 02 May 2023 07:56:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6t7O2NuyHEvlMYpe0AUgE4HFQI6NvR+951Jc2XWOvq9+QBqV31pq1CmHXOlrV46ahIrv3IGg==
X-Received: by 2002:ac8:5b8e:0:b0:3e4:dece:cd16 with SMTP id a14-20020ac85b8e000000b003e4dececd16mr27756413qta.67.1683039390182;
        Tue, 02 May 2023 07:56:30 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id d18-20020ac84e32000000b003e6a1bf26a4sm10324903qtw.64.2023.05.02.07.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 07:56:29 -0700 (PDT)
Date:   Tue, 2 May 2023 10:58:50 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: bcachefs replica garbage collection
Message-ID: <ZFEjdJE8Q/wzGF7w@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent,

I'm tracking an issue that seems to be related to bch_replica garbage
collection, where fsck reports the following:

  superblock not marked as containing replicas journal: 1/1 [1], not fixing

... and the fs doesn't want to mount (until repaired).

The short of it looks like there's a window where we write out the sb
replica info with no BCH_DATA_journal usage where a shutdown/recovery
doesn't otherwise expect it. I've not fully root caused the problem yet,
but when looking into the code it looks like we have a couple different
mechanisms for clearing out unused replicas...

The "old" _start/_end mechanism handles journal data only and is invoked
after pin flush. I presume the start/end calls wrap marking journal dev
replicas to ensure usage accounting is up to date, but I'm not totally
sure. Is that the case? If so, any reason the marking via
journal_write_done() isn't sufficient?

The "new" bch2_replicas_gc2() mechanism is invoked from various other
places and always propagates journal data replica entries. Is that
filter on journal data by design, or temporary because journal replica
gc is handled separately as above? If the latter, is there some explicit
reason the old mechanism was left around to handle journal data like
this?

As noted above, I still need to track down the root cause of the
unexpectedly absent journal data replica sb field. It may be agnostic to
either gc mechanism, but I'm trying to understand the higher level
situation here a bit better before getting too deep into the weeds...
thanks.

Brian

