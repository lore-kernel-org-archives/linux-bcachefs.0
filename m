Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523D3C433EF
	for <linux-bcachefs@archiver.kernel.org>; Thu, 10 Mar 2022 01:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiCJBuG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 9 Mar 2022 20:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbiCJBuG (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 9 Mar 2022 20:50:06 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0401275D2
        for <linux-bcachefs@vger.kernel.org>; Wed,  9 Mar 2022 17:49:06 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id v189so3344224qkd.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 09 Mar 2022 17:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gxcd4qsSX20+L4NYsHmaJ2V6xowXso33BdCx/9QNizA=;
        b=S2chfwM+5XuZh6zejGeQtaU/H1Kc4zysCONucaYnlWu4IGqhMP8+E1iVZfreiJUi0y
         0RocStgM8wy8NwHWiWPiYTNKhsyykhkbv5FFHYWMpAsnv9rhFEiHuevmD/a2cxHwHw/e
         Eq+8jhBgOBjAL+KUb2BM1BjR1uP7zqs2FYuWv+e8V4FoVBp91Y2E1z9zUccLH4XvAKW2
         lINkPg4kcjPEec1SotcK+/+0biLaErFGJKbk5bvoF51lBBUvdrRFskuplziAm4ibxMDR
         2u+N0N0zL4hrM6gXhT0x3/0mCGZXLoyCNZFFYK4EfWHnIIsMVK0zBQ6G3vhHpV4+Qm+P
         JRbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gxcd4qsSX20+L4NYsHmaJ2V6xowXso33BdCx/9QNizA=;
        b=4Tdrhv/5m1jGZ5DoU4dfP+DwX6X6N9OeiIjCVspAj4++zhjAp184Bvsv3AAPxRVVkv
         Iw9LILProcS/9lYvb68CSnY/t0FIdNDtbQ8SRWkxUKoBVP/X2h/3m3+4WA6PSaQCyEcD
         LEP/lM3BM1IageYjTUnK1ThNZfvInNIqALOxOzlB9sDpVgqb13QNaF3G8Io/6RzSk8n7
         KmNfNFDk+XJLVMkKfv5VU+OM3tyVL1e2niKVjLEYK6yywDZD54u+EnPV2M8TtBnMwizf
         tm1IZwZ+qad3neNsyicWrQmVmHBgpu//8g3kJVnskdYDd9FFg6c2PYAl/7PDRl+IlqV1
         6PYw==
X-Gm-Message-State: AOAM530R+zjSQstxf9kVejxBwB0jMY2ydVnbufa33cRDgepkCHTozjbN
        AOfGeIoFwLR2AXv/3Ab+TO/oH2m02Q==
X-Google-Smtp-Source: ABdhPJzYQYjpgVlDvyVbQrO0Gp6RzvuWOfIORaVLV+uIXaEkv3jyFwFRmq2FeIve8mHhtMKbZe7gXQ==
X-Received: by 2002:a37:8784:0:b0:67b:1205:e588 with SMTP id j126-20020a378784000000b0067b1205e588mr1713294qkd.354.1646876945553;
        Wed, 09 Mar 2022 17:49:05 -0800 (PST)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id 70-20020a370649000000b0067b4cd8ffbasm1716016qkg.60.2022.03.09.17.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 17:49:04 -0800 (PST)
Date:   Wed, 9 Mar 2022 20:49:03 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Eric Wheeler <bcachefs@lists.ewheeler.net>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs: Kernel panic - not syncing: trans path oveflow
Message-ID: <YilZD2oxhUtFVCfu@moria.home.lan>
References: <6bc8aca6-2f93-4a81-376-13155fcc5d7@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bc8aca6-2f93-4a81-376-13155fcc5d7@ewheeler.net>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Mar 09, 2022 at 01:14:58PM -0800, Eric Wheeler wrote:
> Hi Kent,
> 
> We just started testing bcachefs snapshots this week: we have a bunch of 
> mysql replicas, each in its own subvolume.  Every 4 hours we stop mysql, 
> run a subvolume snapshot and restart mysql, so it gets lots of snapshot 
> and sync IO from the many database instances.

Cool! Would love to hear any comments you've got so far.

> We hit the following bcachefs panic while testing commit# 
> 5490c9c529770aa18b2571bd98f5416ed9ae24c6 from March 3rd. Can you tell what 
> the issue might be?
> 
> It is easily reproducable, the same problem hits shortly after we reboot 
> and remount so happy to test patches or git-pull's to rebuild with:
> 
> Here is the stack trace (more logs below):

So it looks like there's some code that iterates over btree keys and goes
further than it's supposed to - we have paths that point to different inode
numbers and that's not supposed to happen in the write path, we're only updating
a single inode.

I've had a report of a similar bug in the data move path, which may or may not
be the same as this bug - but I haven't worked up a repro for it yet so I
haven't figured out yet which code path is allocating these btree paths. Could
you enable CONFIG_BCACHEFS_DEBUG, then run your log through
scripts/decode_stacktrace.sh from the kernel source tree?
