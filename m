Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FBAC433F5
	for <linux-bcachefs@archiver.kernel.org>; Sat,  7 May 2022 18:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446822AbiEGSbp (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 7 May 2022 14:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386863AbiEGSbo (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 7 May 2022 14:31:44 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEC6237CF
        for <linux-bcachefs@vger.kernel.org>; Sat,  7 May 2022 11:27:56 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id j9so8149306qkg.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 07 May 2022 11:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nElYfIWyVOu13ux80uAmyxut7T+aqfiYeHnK51miSkc=;
        b=D76I8VCVwyie06WOwRJEHoBk1RV9sfwHzHE7EGXpYbzGGgncOqTTS54aKdbSNC1Wq7
         uOztcnJKv9gWHjEAsnhxlHNv+7VGQ54FECxyAq55W9A+j9pMJhLBRfIsEIRLNu2EbOEO
         P/+8e6vvS9jFY4dMDuRtLrEIf8ZNwTIrB3JgFTyCjDNpixzfIqIe2gWwh9N9zx/IIW/0
         BVhIAliGP6rw7OjY8gE68pda/D1hUgdpl7YnwxhHZ/9MeZFGuIBX2G50gMA/H1ugNs4p
         9CCWc/7qcQ6dd0Enx/+kfYcWwjgx18fkM+bNSGpg/ka3mjOaLQYrjplVgGjOjmallR48
         WEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nElYfIWyVOu13ux80uAmyxut7T+aqfiYeHnK51miSkc=;
        b=YouK40Fbacj97Iuf0Fll/emM1UOo+Hqubs/HvnDqiOQ9Kv88RXizALt113wsa6j8pH
         V7Kp4pQ68ED7XQ6GnrQoSc/p/vAr4+cJEX/6Pf5HLOKiVKIec1lGY3wt/XACnbgTQhRz
         fM3dBIs/SPSFV3lxHC2QORPaHtyLcmUiFFUifINrPQrYEDqvfnw5Jl/OeCKHcNxVa6Q7
         rCAScwJzc94IjG68mA2J4X6n1PBbKPjB4fvilQVQOVuHBhxYGuVRADOlLmRQrZAhXzsW
         IcYGM4iLe+2ZK5E5vMXCc47bZ7OnhjiMVBR3WVrK2vWFCa9Dk+ALYt3/aXXvbBuhHYl5
         +hpw==
X-Gm-Message-State: AOAM531UbFc5/OpXRF5aVh2LZktV3qcLAcS8V4/RxFZqSKULg+l7vlfO
        ePtiVRe/Mm3Kg1YG1qLhaCJiPV11fQ==
X-Google-Smtp-Source: ABdhPJyXyxFZZ40bzph/fXDRyYYSpLy3w60iBVX66z8ssQN1P/LAr1nE0pqLaaa9ppvSIXZ7yPS6Gw==
X-Received: by 2002:a05:620a:280d:b0:67d:2480:fdea with SMTP id f13-20020a05620a280d00b0067d2480fdeamr6721796qkp.157.1651948075883;
        Sat, 07 May 2022 11:27:55 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id y7-20020ac87c87000000b002f39b99f67csm4608862qtv.22.2022.05.07.11.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 11:27:55 -0700 (PDT)
Date:   Sat, 7 May 2022 14:27:53 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Janpieter Sollie <janpieter.sollie@kabelmail.de>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs csum: what about scrubbing with ec?
Message-ID: <20220507182753.mzxgdygeucgpkekv@moria.home.lan>
References: <800887d8-7c00-76d0-81af-e0fd08a77847@kabelmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <800887d8-7c00-76d0-81af-e0fd08a77847@kabelmail.de>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Apr 24, 2022 at 03:10:57PM +0200, Janpieter Sollie wrote:
> Hi everyone,
> 
> 
> I'm still learning about bcachefs, my experiments are currently mostly targeted at the part of
> bcachefs-tools ,
> digging into the whole bcachefs structure is still somewhat advanced.
> I'm considering implementing bcachefs scrub: During the past months, I had several fs upgrades
> where the filesystem decided the checksum wasn't correct, whereas the data was fine.  It would
> be nice to be fixable.
> However, something I thought about:
> All non-encryption checksum algorithms are < 64 bits wide, and as such fit in the .lo part of
> bch_csum.
> What about using the upper part for ec? possibilities are here:
> - using another checksum algorihm to check whether a failed checksum isn't an error of the
> checksum itself.  maybe using bit 4 here of CSUM_TYPES to say: if 0, no 2nd, if 1, use crc32c
> (as it is mostly hardware accelerated).

Not following your idea here? What do you mean by by error of the checksum
itself?

> This would be fast + would tell whether the checksum is corrupt, or the file is.
> it would however limit future checksums to 3: 1b1000 (a none algorithm can't have a 2nd
> checksum), 1b1011 and 1b1100 (as those do not have room for a 2nd checksum + it may be unsafe)

> - using reed-solomon as a new algorithm (nr 8).
> I'm not entirely sure of that, using RS in a situation where there are only 16 bytes for ec in a
> billion-size data block (many files are > 1GB these days) is mostly useless.
> But, for what it's worth, it would allow to correct single bit errors on the fly (eg: the user
> would never notice a bit error in its file, and it could be corrected automatically).
> would any feature be worth investigating?

Hmm, maybe.

In theory, on modern hardware we really shouldn't be seeing much bitrot, since
hdds and ssds have not just checksums but strong error correcting codes -
bitflips should have been caught & fixed by the devices themselves. But maybe
there's still too much buggy/garbage hardware out there - storing the error
correcting code in bch_csum is a cool idea for that.

> Technically, an invalid checksum would point at an invalid checksum calculation (in which case
> the file can be scrubbed), or a damaged file (in which case the file must be marked as dirty).
> currently, the only scrub way is assuming the data is correct and the checksum isn't

So generally if you get a checksum error you have to assume the data is garbage.
Technically, all that you know is that there's an error somewhere in (data +
checksum); but given that our checksums are stored separately and themselves
checksummed (in btree nodes) a checksum error pretty much always means the data
was damaged, and the only way to recover is from another replica (that will
hopefully pass the checksum check!).

Also marking something dirty has a specific meaning in filesystem terminology -
dirty is a property that cached data may have, and it means that the data in the
cache has been updated and must be written back. It doesn't really fit here :)

So, using RS for a checksum type is an interesting idea. I think this kind of RS
has been done before, code might even exist in the kernel for it already (as
opposed to large block RS, that RAID uses) - we'd have to check how the
performance is, and make sure it can still catch bitflips.

Could be a fun project :)
