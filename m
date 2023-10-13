Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27FCCDB47E
	for <linux-bcachefs@archiver.kernel.org>; Fri, 13 Oct 2023 11:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjJMLxK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 13 Oct 2023 07:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjJMLxJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 13 Oct 2023 07:53:09 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55DDCA
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Oct 2023 04:53:07 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9b9a494cc59so309552066b.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Oct 2023 04:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1697197986; x=1697802786; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPckyR8Mj3YMjMqnvDBmTmXKO9IHlSBnUUBMlhDqDmI=;
        b=nOLatwPuh7Twgq6Rf1oTXxH2nLd2nAiuOr6tnFBoPfoW+ZgIVwKgyRpk9ETGPRmvZu
         hSqTWLEJY/ymLabC4Xl3Sp2BgnsSxaLecMH5U0N7dTn4VCppT2SSg4tKS3bvkTyrmYt+
         RKIZG4q3cEbZrimIziaUz0/4C+7Z22l7e1qbI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697197986; x=1697802786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPckyR8Mj3YMjMqnvDBmTmXKO9IHlSBnUUBMlhDqDmI=;
        b=bOuVNNJ1MzHPHV1H4uY1Ecoqu7HHSbgLDhroBZe9jRyd0brnEg4UlfQYekEsvGeSgn
         NV0aORQ7+mY5R2874ixFL6+7IuDhKnJqPW+Xm4YNvAaIggUvUAllmNN5bepA65SCjv+Z
         vArOUAS5ADHupCt0phUrhxSOu7XSATC5fJQC/2Byc5ofpcQmzboc25ICSBTKo+6a9HLC
         FBhkSC89EDrmxKsYFUlODVLVZOK2PLE0LhMvWrOUbrLId/93oDVLqIUEMeWDIXHAvWYp
         X0llTls323ZXp04qkm3UHHJ0ofUaWF+vDn6J8ms1IjHhSmsO09kfOpF3iqzHOAM2bt8/
         gItw==
X-Gm-Message-State: AOJu0YyFkGGMRM0EkSYdS8M4X/K/UL1NCkNeqH/WmkQ6Lm8vQ6ZpUmBN
        j9N+tkYoBXY8Ne0oaK0gwZ6w/yN04eYBtD+e6tlA3g==
X-Google-Smtp-Source: AGHT+IEdhH6XbbHQD70aRXmoxI3TRf0lp2zfotyN9xqrP+S0b3h778DERrYukQihWFxZJJ3jZZiurOxcAz0zN/k0MN8=
X-Received: by 2002:a17:906:23e1:b0:9ae:53a2:4289 with SMTP id
 j1-20020a17090623e100b009ae53a24289mr25104026ejg.63.1697197985747; Fri, 13
 Oct 2023 04:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAMVG2sun2sqFXt=H-0cVWnATGMMFpe-0ksRWy3uhUZXbA5m1qA@mail.gmail.com>
 <72438765-AD46-4C8A-975F-982223CE7A40@suse.de> <ZSkk0W9Dk5q5hUge@bfoster>
In-Reply-To: <ZSkk0W9Dk5q5hUge@bfoster>
From:   Daniel J Blueman <daniel@quora.org>
Date:   Fri, 13 Oct 2023 19:52:54 +0800
Message-ID: <CAMVG2svBFVkjnEJRdC5H=uXxL6T_mYH8XdQQcBrUP7mqrsh61Q@mail.gmail.com>
Subject: Re: trans path overflow during metadata replication with lockdep
To:     Brian Foster <bfoster@redhat.com>
Cc:     Coly Li <colyli@suse.de>, linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, 13 Oct 2023 at 19:06, Brian Foster <bfoster@redhat.com> wrote:
> On Tue, Oct 10, 2023 at 11:20:59PM +0800, Coly Li wrote:
> > Forward it to linux-bcachefs@vger.kenrel.org <mailto:linux-bcachefs@vge=
r.kenrel.org>
> >
> > > 2023=E5=B9=B410=E6=9C=8810=E6=97=A5 07:43=EF=BC=8CDaniel J Blueman <d=
aniel@quora.org> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Firstly, bcachefs introduces a new era of in-tree filesystems with
> > > some monumental features (sorry, ZFS); hats off to Kent for landing
> > > this!
> > >
> > > My testing finds it is in great shape; far better than BTRFS was when
> > > it landed. Testing on linux next-20231005 with additional debug check=
s
> > > atop the Ubuntu 23.04 kernel generic config [1], I was able to provok=
e
> > > a btree trans path overflow cornercase [2].
>
> Thanks for testing and for the bug report. I'm curious what kind of
> testing you've been doing in general and perhaps if you have any more
> interesting results to share? ;)

Thanks for asking Brian! My validation seeks to exercise edge cases by
triggering multiple conditions in parallel, then working backwards to
identify a minimal and reliable reproducer.

I'll prepare a post with additional early findings in the coming days.

> > > The minimal reproducer is:
> > > # modprobe brd rd_nr=3D2 rd_size=3D1048576
> > > # bcachefs format --metadata_replicas=3D2 --label=3Dtier1.1 /dev/ram0
> > > --label=3Dtier1.2 /dev/ram1
> > > # mount -t bcachefs /dev/ram0:/dev/ram1 /mnt
> > > # dd if=3D/dev/zero of=3D/mnt/test bs=3D128M
> > >
> > > The issue doesn't reproduce with metadata_replicas=3D1 or a single bl=
ock device.
>
> My naive assumption would be that the higher replica count increases the
> size of some of these transactions due to having to update multiple
> devices, but this is not an area I've dug into in depth tbh. I've not
> seen this yet myself, but I think most of the multi device testing I've
> done so far has still been with replicas=3D1.

With the stock Ubuntu kernel config (no CONFIG_LOCKDEP, likely similar
to your codebase), my testing eventually provoked a crash; I'll see if
I can reproduce this later in case it's the same path as this report
with CONFIG_LOCKDEP.

> > > At debug entry, I couldn't determine why BTREE_ITER_MAX must be 64
> > > rather than 32 when CONFIG_LOCKDEP is set, however the panic doesn't
> > > occur without CONFIG_LOCKDEP, so it appears related; keeping it at
> > > value 32 with CONFIG_LOCKDEP doesn't prevent the panic also.
> > >
> > > @Kent/anyone?
>
> Hmm, that is interesting. I'm not sure why lockdep would be a factor
> here. Where did you come up with the notion that ITER_MAX could be 32
> (and the idea to test it) with CONFIG_LOCKDEP=3Dy? It looks like it's
> hardcoded to 64, but perhaps I'm missing something.

See https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tre=
e/fs/bcachefs/btree_types.h#n390

#ifndef CONFIG_LOCKDEP
#define BTREE_ITER_MAX 64
#else
#define BTREE_ITER_MAX 32
#endif

> We'll see if Kent can make more sense of the crash signature whenever
> he's back around. Otherwise I'll make a note to try and reproduce it
> once I work through some other things...

It would be good to get some independent confirmation on this.

Thanks again!
  Dan
--=20
Daniel J Blueman
