Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB0BC433EF
	for <linux-bcachefs@archiver.kernel.org>; Mon,  4 Jul 2022 14:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiGDO4k (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 4 Jul 2022 10:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbiGDO4L (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 4 Jul 2022 10:56:11 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A32A1116F
        for <linux-bcachefs@vger.kernel.org>; Mon,  4 Jul 2022 07:56:10 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id ay10so10147934qtb.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Jul 2022 07:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KsyvibnwdxStpjsQIaLdpizWkSC247niovcfnCCiHW8=;
        b=Sz07fwDm23rAMYgnJXfd0b3Mxv7dkhBplItayBPMEJbsFA20nkos8dxS6oYsVOGWmg
         h7hnDl0QW50Hvu5d6/d2svhHqQZyps5O90DzkKRtbUjyRsxZXwLPHBNfDrhMsM+W+ld4
         xTaOjkRynmv5DOGfQxp3QdTFxLrC7xHk3gweTOlzbOFmzvD3J7TU0918O4/8B1dOBj5E
         KDrnIO0LKbG9rV6jpz1XRvgnstk53Iaiu2x9oiWjwS2OnKd9V+NtnXB9BYhW6qmnvjCU
         W7OaB2JTD3YacpQIlnuXWnlLPfpXnMcC2VvRJm5skoldH5y27xZUM1vTEI53WzsePHi9
         v8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KsyvibnwdxStpjsQIaLdpizWkSC247niovcfnCCiHW8=;
        b=EeOO3RHkM43bHaQeRYV0Bq3mYIMzlYKEm2S+9Hd33tcwllaJcP0d8159WHrWcx4DEK
         1pE3POix7Ro9uNyzj6PV3JrDrWFofVk2ABws4mZkx+YliJe/a2fW7kohv3Y/etJL0wRE
         Y/NJEli600nS9TjhDBjEiwoh6bQp4QA6G94MTFicOZ2WxYcrXKNgav/GwqoYWLlRoedc
         efzo8fwb7VhY2VnykKhFnWi66yL4D0pzZdB8uJF7iU4HBbcngojs5D2i1G2mWKWIAsvz
         +bsgatFtsKc4r2RF3Wik/T9zz+MvLrU/Sbt7K5MKshFkhXMjLrH1kvsnxy7twmEAt+cW
         kF8w==
X-Gm-Message-State: AJIora8r678bIzyk9O6v0tIycouZ3d1OI82kCzmXkMA1B6//4KXFDOGt
        hQkSV9PVhRn5C/amYYsOnY/LnBJOB8+6qu0=
X-Google-Smtp-Source: AGRyM1svIjRV9wcSu2txqr3j4g8f7wbwr0IEdVKN9StQ64tUC1PlHRl8bS//J4EAcjvIiYiLO23yMQ==
X-Received: by 2002:ad4:5765:0:b0:473:20e:746c with SMTP id r5-20020ad45765000000b00473020e746cmr198382qvx.128.1656946569532;
        Mon, 04 Jul 2022 07:56:09 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id bm9-20020a05620a198900b006a73ad95d40sm24389074qkb.55.2022.07.04.07.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 07:56:08 -0700 (PDT)
Date:   Mon, 4 Jul 2022 10:56:08 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: Are reflinks always O(n)?
Message-ID: <20220704145608.3673qxxy5ubchvkn@moria.home.lan>
References: <Yr0uBS40F87h+Lxp@itl-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yr0uBS40F87h+Lxp@itl-email>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Jun 30, 2022 at 01:00:29AM -0400, Demi Marie Obenour wrote:
> In bcachefs, is creating a reflink O(n) in the size of the file, or in
> the number of currently unshared extents that need to be moved into the
> reflink btree?  The former would be annoying, but the latter is
> proportional to the number of modifications to the file since it was
> last reflinked, which is fine for my use-case so long as unlinking a
> heavily reflinked file is also fast.  My reading of “bcachefs:
> Principles of Operation” suggests the latter.
> 
> Basically, if a file is already reflinked, is reflinking it *again*
> cheap?

It's about the same. Reflinking a file doesn't change the number of extents, it
just makes them indirect, and then to reflink the file a second time we have to
bump the refcount on all those indirect extents.
