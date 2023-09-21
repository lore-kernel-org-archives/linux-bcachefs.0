Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30423E7D0A2
	for <linux-bcachefs@archiver.kernel.org>; Thu, 21 Sep 2023 17:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjIURvN (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjIURu6 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 21 Sep 2023 13:50:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0265B95
        for <linux-bcachefs@vger.kernel.org>; Thu, 21 Sep 2023 10:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zrsY6+iYydNvVJVsSl8JgdkyOYyS+atZazEfF3dyMIA=;
        b=hJsRnpiL9xmLCdqZuEJn6NjfIIH1E8fljveLPMy5ZXIBCqHF1NOa9XJtGBP3LM7mHPAXp7
        RYPtRxqxpYpGoKH0GcoCmExupEcL99MKGkD35mYu0sApXTF44RTm84E9lltBqoWK2t87Z+
        GjoJxU2M2DLiRptq1C/pd4eS/EczPrI=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-tVOmWq9qN1mzN3Bnj1FDwA-1; Thu, 21 Sep 2023 10:55:40 -0400
X-MC-Unique: tVOmWq9qN1mzN3Bnj1FDwA-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-d817775453dso1365978276.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 21 Sep 2023 07:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695308139; x=1695912939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrsY6+iYydNvVJVsSl8JgdkyOYyS+atZazEfF3dyMIA=;
        b=u1dkmNpAh8gQjPtBzYfohrXL6l2Pv2004ME/miEaO8iWWvk+Z2LNTK28jkhOpPwUs1
         LvOsv5SLeMOpEzgs0x/5s7DZyoDycNf5oj0zVn8hRpBIPl9sfsJraZ7D2dxV/CSXBdV9
         BmLxOzJwRx/RRQ4ezpFI9E7EIEUrde/51Ghuoo+oBIqUNzvKDLJcoUgwuxLaMW5p+uwU
         XXPLUkkwGcatT20Dyy72x9J2keEi2ptK52TQLc92deXOfN5HdZ8Fq0Yeqd/rkQLZpkMH
         W1k/BWqrROVFeVNflB4Vwn85aK4IRo7F6ty5soR15dx26UengDg3S21L8JmwL9ROYRmi
         /ePQ==
X-Gm-Message-State: AOJu0YyqeXpaMpJ0yhDuM7w3N5tL3uG8TbJh6XKzJhwOqCSQnKGgtEft
        gksBHsx+EGGkczGsbGlMXL6MkBYDj82sETw7hmM5w021mRzMo5qASS61DtzdtT8x3EjsDoqg9R+
        BqK3U/Iiam4svHYZ1oMmW5INGuTZSAxwmMnM=
X-Received: by 2002:a25:c54c:0:b0:d06:f0ab:e17b with SMTP id v73-20020a25c54c000000b00d06f0abe17bmr5839836ybe.55.1695308139464;
        Thu, 21 Sep 2023 07:55:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4+yGDUgZt0Nn2zWW3JAikgc86/A8o4VDNCMUVmdNqTROsevP2dG3OZFfHn30iKUW/oKX0Ag==
X-Received: by 2002:a25:c54c:0:b0:d06:f0ab:e17b with SMTP id v73-20020a25c54c000000b00d06f0abe17bmr5839825ybe.55.1695308139184;
        Thu, 21 Sep 2023 07:55:39 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id p8-20020a0cf548000000b0065896b9fb15sm630329qvm.29.2023.09.21.07.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 07:55:38 -0700 (PDT)
Date:   Thu, 21 Sep 2023 10:55:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] bcachefs: initial freeze/unfreeze support
Message-ID: <ZQxZehDOmHjg064p@bfoster>
References: <20230915125154.307450-1-bfoster@redhat.com>
 <20230915125154.307450-5-bfoster@redhat.com>
 <20230920012116.pi7nw5ziebrdffkq@moria.home.lan>
 <ZQrzjG5T2jSthuB9@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQrzjG5T2jSthuB9@bfoster>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Sep 20, 2023 at 09:28:44AM -0400, Brian Foster wrote:
> On Tue, Sep 19, 2023 at 09:21:16PM -0400, Kent Overstreet wrote:
> > Pulled this into the testing branch and then got
> > 
> > https://evilpiepirate.org/~testdashboard/c/de4ea1e2a9ceec5d55fffbc1acab89f0dc8f90b6/xfstests.generic.459/log.br
> > 
> > So I'll likely kick this patch back out for now, let me know when you
> > have a fixed version :)
> > 
> 
> Ah, sorry.. I should have mentioned this in the cover letter. I'm aware
> of this failure but my initial triage has it as an unrelated problem.
> That test basically induces I/O errors by explicitly overprovisioning a
> dm-thin volume for the fs. The original bug was a livelock issue on XFS
> related to metadata writeback failure/retry in this particular scenario.
> 
> The test relies on freeze in that it basically consumes all of the
> initially provisioned space, issues a freeze in the background (which
> will start off hanging because not everything can write back until more
> storage is available), and then grows available space so freeze can
> proceed to completion. It uses the success/failure of the freeze to
> determine pass/failure, and if the freeze fails it looks like it expects
> the filesystem to have been remounted ro (which I believe is ext4's way
> of dealing with this).
> 
> My notes say that freeze failed because the fs shutdown, which I think
> is due to the whole overprovision/flush thing leading to I/O errors
> (i.e. expected behavior, probably similar to ext4). But TBH I hadn't dug
> into it further than initial triage to rule out the core freeze
> mechanism itself. I'll dig more into that soon to see whether we need to
> change the test or something in the kernel, though I don't think it
> necessarily needs to gate freeze support..
> 

Yeah, so I can confirm that the only real difference in behavior between
ext4 and bcachefs wrt to this test is that the former sets SB_RDONLY in
its internal error remount read-only sequence, which in turn results in
"ro" text in the /proc/mounts output and thus satisfies the test.

bcachefs only does that in the ioctl shutdown paths for whatever reason.
Unfortunately it's not quite as simple as doing the same in the fatal
error path. If I do that, it looks like the async error handling worker
can race with a freeze, which does two different things wrt to internal
locks when sb_rdonly() is true vs. not.

This can possibly all be serialized via the right combination of
s_umount and freeze protection in the error handler to ensure we never
see the wrong combination of being freeze locked && sb_rdonly(), but
that requires a little more thought. Given the test could also easily
change to checking for -EROFS or some such on bcachefs vs. "ro" in the
mount status, this does strike me as more of a minor shutdown
inconsistency than a significant freeze or shutdown bug. What might be
more useful is at some point to audit the various read-only paths for
consistent behaviors regardless of how invoked (i.e. "ro" for remount,
shutdown) and proper serialization.

Brian

