Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939224437
	for <linux-bcachefs@vger.kernel.org>; Mon, 22 Jul 2024 03:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721619916; cv=none; b=qkw40dbOhbHGIHbUCP9DMtMwoCt3/V8VktJ+3t29F3FS0h+KPbHhfkqBGVjTSLtoOXQUN0B+msf8KSqOxUZ0ZFTT+HBcPAQlodE7NEUS2oGxt1RXwg0v6YMki4MJug/+FXErS7br2xJQ8AgLPdhAdRT1tVoRxwU8Y1N+b146woM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721619916; c=relaxed/simple;
	bh=oM1CnO0VibbtPSRZw0s4NgByybk1YPu3ofkeDMAjSPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fNAFZWexF40Gk6EKW1zYMwK6HlxXtKjLOGkZ/jVfR6af9FFi0yd843+wV32FXY/a9GJegmkznyQ6oHEKYy31O+et6Heobp3uzgxv3SLOwVcB6Tj0xCtVSJqtL/IIOtSPvz9Y00ofz/33URI8j21TvZRTMvJfclWh73gPIoaLBGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A2mIL9uA; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A2mIL9uA"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2ef2fccca2cso6316461fa.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 20:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721619913; x=1722224713; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L4Tx1mxyp+6xQOzbbKKDGsHkXOu5yPJTtwgVVqjePxo=;
        b=A2mIL9uA5px6vdVbl5QMASawPy9cUDTiiYocJTs+lZiupksmh4U7IU8QQPnv5u8YxO
         cK40gYHSTzthPIavR5wzkrEk8jox09hgmMj2YB6oEVNU9ameuNOk8UqpeVioDnroC4DA
         b3f3STtjidY6GJbsX1W9ZecXMl2hvGS2ftiFAE9mM1qnoBDwwMTa1lCoweObRHK3+3XX
         0+2RB3zZKOnFE+6zTApXPDQwgqRsVwiZCfmiLjI3814aknuAfP9RLBrgJKB7JEvhNIOe
         ZhCHhsTWOd2XwIxow5vTpAhFh/Zv1wQGVokUwkXrydGJrZdUUGFaJalW+JzVfA7+y1uD
         J4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721619913; x=1722224713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4Tx1mxyp+6xQOzbbKKDGsHkXOu5yPJTtwgVVqjePxo=;
        b=Rx/EkGalYguQ7KG6N14nyYK2Zn1vms7D96xjpXT3C21FIr5tyovbPRYm3JRyompBYB
         q6l8FGC0JiPb8Zsl0pGqFgRBY2Qt4POIIAcFg5DVAiATjUmHSpLcvvljme7PYnicUYIO
         +oIqT8482yT7V8CV07vr14Js6TKep42AUmFh4fFCZWHbheaLK91xcOG8UUDPDoUER5oP
         6x3BZSKl3CoY1iv8W34WJn4vIhNoI/jjUfkkSG2HV1a1KTcMIC7/T6XylMH8BV1jUn3K
         /0GO5YFO0a+aHg5433jmARjww3h93/dcqwECFNdy0rzDbd0MbFfBTA1AgvBGPiiOAxqF
         rnMQ==
X-Gm-Message-State: AOJu0YwubSzW2qFqqBHoAK0wtjqgQ4Dt8OA9bwudQlzFh1XiypP/SVKt
	J/vAfwdpC4GyBkel1pjFc0CpdhgUM77kPNIMY1ilWb3gtsDiF5/tMKTzfTeDWteXovo51b1XyqC
	q/BiHVyk3CeTHe6JZt32TLiqvNgQ=
X-Google-Smtp-Source: AGHT+IFTNnC+EyJqT2AztK050LhnEgYY04gOd0jB3G/DN6d28Y8EifW+wgEbEnly/90YFlCANe/VODmyQj1VSK6UJx0=
X-Received: by 2002:a05:651c:2118:b0:2ef:2543:457c with SMTP id
 38308e7fff4ca-2ef25435305mr35841471fa.24.1721619912343; Sun, 21 Jul 2024
 20:45:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240721123943.246705-1-sunjunchao2870@gmail.com> <591b47c7-7a5a-4d09-873e-722ce3ab97f1@huawei.com>
In-Reply-To: <591b47c7-7a5a-4d09-873e-722ce3ab97f1@huawei.com>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Sun, 21 Jul 2024 23:45:01 -0400
Message-ID: <CAHB1Naheb6ndY06-n34OY-6u7Bbu_DRQA2k8vUMZ_WeG6wY9fg@mail.gmail.com>
Subject: Re: [PATCH 0/4] bcachefs: some cleanups and fix about macro
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org, kent.overstreet@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hongbo Li <lihongbo22@huawei.com> =E4=BA=8E2024=E5=B9=B47=E6=9C=8821=E6=97=
=A5=E5=91=A8=E6=97=A5 23:24=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 2024/7/21 20:39, Julian Sun wrote:
> > In the macro definition detection tool I developed,
>
> > Is it commonly used in the kernel?
Not yet. Currently, it is still quite rough and its functionality is
not fully developed, resulting in some false positives. I am planning
to refine it further before integrating it into the kernel.
>
> Thanks,
> Hongbo
>
> > several issues were identified, including unused parameters
> > and unused macro definitions. Let us address these issues.
> >
> > Julian Sun (4):
> >    bcachefs: remove unused macro definition
> >    bcachefs: fix macro definition allocate_dropping_locks
> >    bcachefs: fix macro definition allocate_dropping_locks
> >    bcachefs: remove the unused parameter in macro bkey_crc_next
> >
> >   fs/bcachefs/btree_iter.h | 4 ++--
> >   fs/bcachefs/clock.h      | 9 ---------
> >   fs/bcachefs/extents.h    | 4 ++--
> >   3 files changed, 4 insertions(+), 13 deletions(-)
> >


Best regards,
--=20
Julian Sun <sunjunchao2870@gmail.com>
