Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B414CCDB474
	for <linux-bcachefs@archiver.kernel.org>; Fri, 20 Oct 2023 07:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376356AbjJTHUW (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376326AbjJTHUW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 20 Oct 2023 03:20:22 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B11CD7
        for <linux-bcachefs@vger.kernel.org>; Fri, 20 Oct 2023 00:20:20 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-53d9f001b35so602690a12.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 20 Oct 2023 00:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1697786419; x=1698391219; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hp5lWrh3Ns2ZbD53Yie5adKfxSO8NA1QxeHrVt+Px+4=;
        b=bbuhBEGYBc9ILaPLJTNwFYLBV5aWrmfXsgEu+QFlow1PS0i4muwiofEAVi4c5idbhO
         UlDKYK7u5w5k963fzmSB7Yhc8JKrN3DQw1j91asQszZpwTi4ijj5yBoOtv3BkbY5tquu
         XSWl+PglNIupnCUtzmT72AP0EC+2mcByqnBNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697786419; x=1698391219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hp5lWrh3Ns2ZbD53Yie5adKfxSO8NA1QxeHrVt+Px+4=;
        b=oeL4QzdRr6Vlxil50Tk8QczXN55KzC8e/FbVbEBUMzTjR2cLgC9LIPP7MRzWuVMhXg
         0DmsgSYdPPZxRa+ruhMULI22Z/LX9cSQznYthDDU3XZVV6zyvyknXgKNFKtsvnceWOWu
         +w2Rs2Lmc6DVXre4R1q/jlzX83huoJ2teKvHu6u8tzt0LgXsv4Sg8eRUXSsVyLZaNYf1
         FEbckyunhbEnelmpqj9qSPOuy3FW5h5T5sRSDTRKjdhByn0LMpL9Nh13K2m+0pxGy4e+
         vgMQPEBHBFnq0OUdMFqYjpLbjC6UGm3Ny+3hG/u6aoJiDMhXcHcgqIiuroSGlbO3A+y7
         E8TQ==
X-Gm-Message-State: AOJu0YyuPwlYneClg2nG6vOH623UzpBz1D4sIWL+PYetG7e+YZzEXHoM
        Z3b0tFVoopn0diuUYgnd95haclBOUgwKKyDUCxn9Lw==
X-Google-Smtp-Source: AGHT+IFbfPxx3eveBU3kBowF5OEuF9sObiMHofXyeYk7xqchd3poy7VDC6vXgrIpGwtpo0kBKj5ejAe/qS85GtKjk1k=
X-Received: by 2002:a50:954c:0:b0:53f:6c6d:2e30 with SMTP id
 v12-20020a50954c000000b0053f6c6d2e30mr877066eda.2.1697786418642; Fri, 20 Oct
 2023 00:20:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAMVG2sun2sqFXt=H-0cVWnATGMMFpe-0ksRWy3uhUZXbA5m1qA@mail.gmail.com>
 <72438765-AD46-4C8A-975F-982223CE7A40@suse.de> <20231019011657.gnx7l2ldqkbxmexj@moria.home.lan>
In-Reply-To: <20231019011657.gnx7l2ldqkbxmexj@moria.home.lan>
From:   Daniel J Blueman <daniel@quora.org>
Date:   Fri, 20 Oct 2023 15:20:07 +0800
Message-ID: <CAMVG2ssAbOpWm36rsyXr6EFZ-FxR7ZowiDPuqv7d4TJPjyrcHQ@mail.gmail.com>
Subject: Re: trans path overflow during metadata replication with lockdep
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org, Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, 19 Oct 2023 at 09:17, Kent Overstreet <kent.overstreet@linux.dev> w=
rote:
>
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
> > >
> > > The minimal reproducer is:
> > > # modprobe brd rd_nr=3D2 rd_size=3D1048576
> > > # bcachefs format --metadata_replicas=3D2 --label=3Dtier1.1 /dev/ram0
> > > --label=3Dtier1.2 /dev/ram1
> > > # mount -t bcachefs /dev/ram0:/dev/ram1 /mnt
> > > # dd if=3D/dev/zero of=3D/mnt/test bs=3D128M
> > >
> > > The issue doesn't reproduce with metadata_replicas=3D1 or a single bl=
ock device.
> > >
> > > At debug entry, I couldn't determine why BTREE_ITER_MAX must be 64
> > > rather than 32 when CONFIG_LOCKDEP is set, however the panic doesn't
> > > occur without CONFIG_LOCKDEP, so it appears related; keeping it at
> > > value 32 with CONFIG_LOCKDEP doesn't prevent the panic also.
>
> Lockup can only track up to 48 held locks but each btree path can hold a
> lock - hence we need to limit the number of max paths for lockdep to
> function.
>
> In the main branch there's a patch that ups the lockdep limit to 63 and
> drops the BTREE_ITER_MAX=3D32.
>
> The underlying issue is a bit more serious though; it is becoming
> increasingly impractical to count the number of paths we're going to
> need ahead of time so that we can run inside of a fixed limit. There's a
> number of extra btrees for allocation purposes that we only hit
> sometimes, and we really can't predict ahead of time which ones will
> need to be updated.
>
> Long term, we're probably going to need to figure out a way to
> dynamically allocate btree paths and get rid of the fixed limit.

Fantastic info Kent; this explains it; I'll revisit lockdep testing on
bcachefs when there are related changes later.

Thanks,
  Dan
--=20
Daniel J Blueman
