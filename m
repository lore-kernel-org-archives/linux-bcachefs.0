Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47D1C433EF
	for <linux-bcachefs@archiver.kernel.org>; Thu, 17 Mar 2022 06:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiCQGKS (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 17 Mar 2022 02:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiCQGHE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 17 Mar 2022 02:07:04 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911661CD7CA
        for <linux-bcachefs@vger.kernel.org>; Wed, 16 Mar 2022 22:40:29 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id b67so3624622qkc.6
        for <linux-bcachefs@vger.kernel.org>; Wed, 16 Mar 2022 22:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Iq8t2hLQrbmVYyYH4++yi/7hshVv18w2OqjS5InmyUI=;
        b=Wm+MjO9yeUSbMBjB3ZyTo8qo01zlQYvRZ8tBWKDS82cYeroMgX+ZHTgUjY8LUyp3aE
         rRgHOlyyWBuGsVCSZ/yGzMAcqMpM+NITJvGcfWRMsU9xbpFIUXZk6xsB/6ZhvsINvd0u
         BaAiJQus7kXVzZLFZJ6A5pTFUK1t95fHsWfGHCgG+2aoixR0P8h6FBhEv05hN1PffMOZ
         DvVY8AOgSCH5I90LuXRXPc/sFuqJV0y397/SRwiBqmey/EeGbNtUFtVomiGhu8YSflGC
         c94m6tNRIoKuh4NHbZoT9ZHS10yfu1zPK8yes8yqul6lDBBiZHO654T63UJWS8Og46CP
         LzcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iq8t2hLQrbmVYyYH4++yi/7hshVv18w2OqjS5InmyUI=;
        b=uUO5u5F3UK6ZBq6JOJqRKw2JK458jxjBl8WMUqu4jwIEne385hWPYNBTUubwObCtbQ
         5wYq/p5S8VaFP21pXmr+CnZWKwqcebINzY3jdug5VdfrAaTTIZrVVe2Y7dlo+ChWFV3/
         1/dmXKIP4F9cgQ/YKttvcR1TTWfIYXvO147jJOc/lHRcPgyylvuhzm4wlykwGypoff1b
         b3EopGR6HFVj6aVKiqxH2rHuD8v1NsfnwjcskdcEicEaO+wWhRIdE5ntFj4D3YE4Wopx
         /r6usFb8V8CwDuLmmwn8HXQAuCZ8pqclmW42iUzHv6jI5gbE1CzvALyOgHZZG87Wxbsq
         xErQ==
X-Gm-Message-State: AOAM531TsTbgMjNmpVcIiO3urpVoEhnSP0TPLLChY0puhFufyM92yLVE
        MeNO2iXwl4bezENDxBAPO8v/qZrIbW6b
X-Google-Smtp-Source: ABdhPJyOpzrpjtczDy8P5dkuV4SByxwcspKBqAd4onNckAlVb7TjQJeK0j063CO94pMUiZK/i/PP7A==
X-Received: by 2002:ac8:5711:0:b0:2e1:cde2:6922 with SMTP id 17-20020ac85711000000b002e1cde26922mr2295826qtw.116.1647488679387;
        Wed, 16 Mar 2022 20:44:39 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id e7-20020a37ac07000000b0067d7cd47af4sm1836864qkm.31.2022.03.16.20.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 20:44:38 -0700 (PDT)
Date:   Wed, 16 Mar 2022 23:44:36 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Eric Wheeler <bcachefs@lists.ewheeler.net>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs filesystem corruption
Message-ID: <20220317010742.dm35ejttjbjrddsi@moria.home.lan>
References: <a55372e3-c4d5-ecb0-782e-242d166140c5@lists.ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55372e3-c4d5-ecb0-782e-242d166140c5@lists.ewheeler.net>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Mar 16, 2022 at 03:58:34PM -0700, Eric Wheeler wrote:
> Hi Kent,
> 
> The MySQL+snapshots deployment we has become corrupt and InnoDB is 
> crashing with a stack trace and lots of borken database noise.
> 
> We are going to rebuild it from other replicas and see if it happens 
> again.  We started using your new-allocator code (commit 
> 3985f5f4eff86ee667da7da6e36ca2c346f56be3) after the original deployment 
> and we haven't re-loaded since you fixed the snapshot iterator issue, or 
> maybe it broke during the allocator conversion, can't be certain.
> 
> There isn't any especially obvious problem but there are some WARNING's 
> below that you might look at.
> 
> There were lots of these:
> 	WARNING: CPU: 0 PID: 7796 at fs/bcachefs/fs-io.c:1290 
> 	  bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs

So the warnings are just a symptom, and not terribly interesting. I'm changing
them to WARN_ON_ONCE().

> bcachefs (dm-6): initializing new filesystem
> bcachefs (dm-6): going read-write
> bucket 0:10 gen 0 different types of data in same bucket: btree, journal
> while marking journal

^ That's probably the real culprit - we're using the same bucket for both
journal and btree, no wonder things got hosed.

Interesting bug, something strange must have happened for us to not catch this
right away.

Would it be possible for you to dump the filesystem metadata for me, with the
bcachefs dump tool? I might get some clues from examining it.

Also, how long was the system in use before this happened? How many reboots?
Were you by chance running the resize-journal command?
