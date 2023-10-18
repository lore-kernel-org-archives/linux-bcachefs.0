Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3214BCDB47E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 18 Oct 2023 21:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjJRVuj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjJRVui (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 17:50:38 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4326811C
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 14:50:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-27d538a73d6so3033287a91.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 14:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697665837; x=1698270637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZEJKFix9GVNmg5L73kdSMkchY4n+WWgjJYjDiD7cgk=;
        b=kDAleZF9/mqPI165yg+ThIP/OMJRWF+h5xusJV/WO/++H0F+Paxa/lPRiXzjkpsIzh
         2I88Eufrq3YlBK+S9eqrW0N7rHoVyzrHtVyvmd5MFgurryNpB/CXV8R8OQG1XqYjNmx7
         VV3Fm+b6HRhqi2IqakAFmgqiJRTcWvXo3V0E0Sq3mOp6RQMDRQ0FukW916Np6RSTMdyu
         WWxv/e51okhwuXgpyT78eOcElDgydMye4y6GMSyy3FKzuzCeJK6oq0Fxt5yqAHIHIiBA
         D02K0JcKmQneMbgz2Sa2ZhOHf5cIr8nKWIWKf0CBPU6E++g7MHN8mOKxAsLv7HLgADbV
         PKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697665837; x=1698270637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OZEJKFix9GVNmg5L73kdSMkchY4n+WWgjJYjDiD7cgk=;
        b=OQJy8GrZ1nAVib67rFNHvzVhAo/ZmBAze5+CeYeD+IcsCS52ukR5LEb0inWvxgBCmd
         p7uEM/nD5yPdEs0qZ26AR06GIFqcjzm+UDBcevTel+BziEXz5x7SITLi/9pYJNtZ8UB8
         TS7FKiWRRHFET0CLd2Bd/UxuomHm7iHmj0Iz56E+iMJfOh8w8uHVUOFXhqo528GHUVC6
         TbktbMUJ1mtBmJuYJ5JlIkI/V31kUK5vEzpfLIQc51ySpaGZNycn5B9BxqFhZu0HWvKI
         TnJdx8lPKggA8w4JItWenD8jYwLs3HObdnGRqfBzfQfcs1KCayH7q/pkd6AeNQhw/vCC
         gP2A==
X-Gm-Message-State: AOJu0YwsNoHqU/XL0nrWw1NgDQoyY/WnXLxzSv4jC4KzV4FjNY8FiiZC
        F/GejkUFuW0BzXp2hacrZn7UIl91St+QG/7ijHP01zAiixO8yQ==
X-Google-Smtp-Source: AGHT+IG/L0bIm5HwlTQoD4YOPa8tNxVQX39ov5LqvhNGV44oMuL+S5FMEtUJ916uLBQrkKVHQLfAjeWtgolL80uTJ2M=
X-Received: by 2002:a17:90a:1e:b0:27d:1af5:3b17 with SMTP id
 30-20020a17090a001e00b0027d1af53b17mr437207pja.26.1697665836624; Wed, 18 Oct
 2023 14:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
 <20231018202955.i2xjqqpd7cubunvg@moria.home.lan>
In-Reply-To: <20231018202955.i2xjqqpd7cubunvg@moria.home.lan>
From:   Parke <parke.nexus@gmail.com>
Date:   Wed, 18 Oct 2023 14:49:58 -0700
Message-ID: <CAPxz1+ZTODcUt=nbToDtpsHr1LW04VNVqDPJNV2QhuXb-=+CnQ@mail.gmail.com>
Subject: Re: Bcachefs: export a different st_dev for each subvolume
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

> On Wed, Oct 18, 2023 at 12:37:59PM -0700, Parke wrote:
> > What is the status of the above todo item regarding a distinct st_dev
> > value for each subvolume?

On Wed, Oct 18, 2023 at 1:29=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> Not done yet (and thanks for the reminder!)

Thanks for the info.

> > Is there any easy method for users (especially non-root users) to
> > identify Bcachefs subvolumes?

> Unfortunately nothing so easy - snapshots will have the same inode
> number for their root as the parent subvolume, but new (empty)
> subvolumes get new inode numbers for their root inode.
>
> Perhaps we could sketch out a proper interface for this...

Could Bcachefs communicate whether or not a directory is subvolume
somehow via the st_rdev field?  Or does bcachefs already use st_rdev
for something else?

(I am unfamiliar with st_rdev, its uses, and what restrictions the
kernel might place upon it.)

Thank you,

Parke
