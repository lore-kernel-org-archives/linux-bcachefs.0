Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A822EC77B73
	for <linux-bcachefs@archiver.kernel.org>; Wed, 24 May 2023 07:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239935AbjEXHfJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 24 May 2023 03:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239993AbjEXHfH (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 24 May 2023 03:35:07 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9528F
        for <linux-bcachefs@vger.kernel.org>; Wed, 24 May 2023 00:35:05 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-51b0f9d7d70so590738a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 24 May 2023 00:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684913705; x=1687505705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O0M90dYEtoB+tX95FKz0Jj4hKmcCt+vtzXw6fRk3trk=;
        b=WCK/moH3TMm6NtivNgmKsUsBm8l+Kxtmp01ZtIL/pbTxvgi6Exn7jWFQY0TR+67vQ8
         HmK5bZ8rQmm9BdvoKo6XBR8Idrsnq4ykCG/sKaXvVjQVFiU2sxMBcxnhKMBX/lXCWbpd
         fHxz/1EubAeHIGNQrS9P28TswPGD3DvJdFIJd4ZmY/FSXiZX6vxV4uJjTt4c69lVfXCB
         fggs7ICMEOPjrWYK9R+N2gKGYMxx1CRHH89iIaSeq5M3L4eHnX0Xq2P8wBaT7MCyXxFK
         AFnP5HPLO0ad5B62yxOiTOkUPZsbUTLddDV8yIrsHn/syehTZ/vQ68X2T5iz+zvn8JjW
         7mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684913705; x=1687505705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O0M90dYEtoB+tX95FKz0Jj4hKmcCt+vtzXw6fRk3trk=;
        b=lEmlsALPyeyWnqPWw1ncvInEmbCnGywCMAgVSvhPY5UIKzjd7EKqtAnMx6uX7+AxBU
         UhVntTXPIH/fk0lO1MfKL75gC//AfhOzGGCZFhQ8FgjObDSgtfDXvQiyfomJioMU3qNV
         7YitwSP3vU7Zn0jfjl5l/WOCgFuaVHK8Fbo6J3C6vgu7WJK62UnxYFXKqut5iw1buKeV
         vNPwsP44buro+NYBRrToQHRnBegWHkx7PL/oXPFx4DmWR6/283ZwA8DeIcbtPM4NAYj2
         VHIlUzJkAdwCcXDCs7dV4SxSHdBBpg/le0bmruTsfPZKZJD+IAklWjbSFX57+6ioxYQI
         HBcg==
X-Gm-Message-State: AC+VfDw1sGzNLoe4XgptwgQ0VbCLLe2cGiCnkOY5KZf795bRX/SNPfzo
        zz3SnxkAoQA8j3G8RNvZJJgpPQ==
X-Google-Smtp-Source: ACHHUZ6UeStupei4VgkExMH9NL+gLbB8bBfErJC2pwxidR1k45P0Di9t+zSp2el1Ydxxv+Ev+VA3Rw==
X-Received: by 2002:a17:902:e5c8:b0:1aa:e425:2527 with SMTP id u8-20020a170902e5c800b001aae4252527mr17443473plf.21.1684913705482;
        Wed, 24 May 2023 00:35:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id v5-20020a170902b7c500b001a505f04a06sm7976312plz.190.2023.05.24.00.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 00:35:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q1j1S-003FTy-2N;
        Wed, 24 May 2023 17:35:02 +1000
Date:   Wed, 24 May 2023 17:35:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: (subset) [PATCH 20/32] vfs: factor out inode hash head
 calculation
Message-ID: <ZG2+Jl8X1i5zGdMK@dread.disaster.area>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-21-kent.overstreet@linux.dev>
 <20230523-plakat-kleeblatt-007077ebabb6@brauner>
 <ZG1D4gvpkFjZVMcL@dread.disaster.area>
 <ZG2yM1vzHZkW0yIA@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG2yM1vzHZkW0yIA@infradead.org>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 23, 2023 at 11:44:03PM -0700, Christoph Hellwig wrote:
> On Wed, May 24, 2023 at 08:53:22AM +1000, Dave Chinner wrote:
> > Hi Christian - I suspect you should pull the latest version of these
> > patches from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git vfs-scale
> > 
> > The commit messages are more recent and complete, and I've been
> > testing the branch in all my test kernels since 6.4-rc1 without
> > issues.
> 
> Can you please send the series to linux-fsdevel for review?

When it gets back to the top of my priority pile. Last time I sent
it there was zero interest in reviewing it from fs/vfs developers
but it attracted lots of obnoxious shouting from some RTPREEMPT
people about using bit locks. If there's interest in getting it
merged, then I can add it to my backlog of stuff to do...

As it is, I'm buried layers deep right now, so I really have no
bandwidth to deal with this in the foreseeable future. The code is
there, it works just fine, if you want to push it through the
process of getting it merged, you're more than welcome to do so.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
