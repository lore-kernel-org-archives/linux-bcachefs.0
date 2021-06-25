Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF6FC49EA5
	for <linux-bcachefs@archiver.kernel.org>; Fri, 25 Jun 2021 03:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07EC3613FA
	for <linux-bcachefs@archiver.kernel.org>; Fri, 25 Jun 2021 03:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhFYDH0 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 24 Jun 2021 23:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbhFYDHZ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 24 Jun 2021 23:07:25 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F9AC061574
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Jun 2021 20:05:05 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id r7so6481280qta.12
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Jun 2021 20:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lSTdhDoTVVECQoEUuDVJzomEGls/zIXTYRGUGM1soZY=;
        b=E8uJ0XzGM5yuE7EQ/MOx5GifTbk4cZQRc33ant/I/V9LmVyplSR55Te6x+I3o02N9D
         Z2pyhywWDRIWHMy12iWPmCaJ/hBeq60ohGwBNET/pui17ibwDlnDvKaBs7A27aL2oxsC
         1fnP5A3RdYaM/lVbGgHS8CTJcShEcGk9FefgQUX9GiT1+7veSk7dmFJA8PbRhsN3HAxN
         xBSKXVp787U9F7FyjU6G/+2p/7TaCDgWkiew8fwhYtaXYAuaTJGhc0Xh1h2dGczDB/u6
         tM6nUUQrk5oz1weF+o4rnj+Nl1a7r9reqA5DcT1zJ2pKwIM5TLKOFHdmZcqCJBb2OqRg
         756A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lSTdhDoTVVECQoEUuDVJzomEGls/zIXTYRGUGM1soZY=;
        b=cRT2IjTSvHp3bTuGkoLRBbRAjb6stnKK2nU9z7FyZ34DTUX3XKoZuQN3Kyw/0Z4IOH
         SXLRuPuafnJVSwzAvLt7MZCNub4946dyqlJO1jttkP6BQYfTEkqzAjbYGkkd137H2/g2
         CsoIREjLMTOZ7Be1em5Mmv14eOLV40GNWjRqXgmgM59wdYs3wDHzexhuC3zQFF6wQHQ/
         17Eerlkihh8Pvbu+ZMjf5BAikvJIZjb+BJzSEL8f/Ed3FLiO3DzyzKEoA2SRdWCR9+yJ
         dbwvETh8MgQVEgztGtU+IkCC/4D6SNlWvMrCcPuI1U4laKm7POBQqZhpSGFCkk4mrqhB
         Gqmg==
X-Gm-Message-State: AOAM531OKivrC4DdvHLnFl15pE+cNdjywyzLbWNNuzPlOg1haTOS/0AO
        /Y/DY0YkLi2Tq+cY8KiS2s+iS4YZnmHD
X-Google-Smtp-Source: ABdhPJzvdA/l3GS1EhbSPXu80t2gCH69CERnKB03EkCH6B1QqDdM87BTDoDbwUPGTq2cmtuPKcN5ow==
X-Received: by 2002:a05:622a:50c:: with SMTP id l12mr355485qtx.292.1624590304157;
        Thu, 24 Jun 2021 20:05:04 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id u15sm3938419qku.33.2021.06.24.20.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 20:05:03 -0700 (PDT)
Date:   Thu, 24 Jun 2021 23:05:00 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Dan Robertson <dan@dlrobertson.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/1] generic/103: increase reserved bytes for bcachefs
Message-ID: <YNVH3Cnw8bwYjJ1Y@moria.home.lan>
References: <20210625021118.28813-1-dan@dlrobertson.com>
 <20210625021118.28813-2-dan@dlrobertson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625021118.28813-2-dan@dlrobertson.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Jun 24, 2021 at 10:11:18PM -0400, Dan Robertson wrote:
> The bcachefs btree nodes are quite large. If we only reserve 512 bytes
> we hit an intermittent failure where the fallocate that is intented to
> fill the available space triggers a btree node split and the exente update
> is interrupted. The retry of the extent update will fail because the
> new amount of available space is less than that of the request.
> 
> Signed-off-by: Dan Robertson <dan@dlrobertson.com>

Thanks, merged
