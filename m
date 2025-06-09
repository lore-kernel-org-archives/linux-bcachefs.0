Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A951325A353
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Jun 2025 07:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749452604; cv=none; b=D6cZDtsMclEtZBz4r5BdnzzQHofyQmW1OOhxawsOIBmBG+rJJMyyzNDk+Flx8aGlVqRiROfcn4Q3p6LrSnoI+KL7j0PDxet5z2EvasIRX6ecpFQz7Rtfr4hWx+vc4Bn8DX52hLA4+QaKgle/EYaHEWBmM1qhas+f6YPdtYeJxTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749452604; c=relaxed/simple;
	bh=rAIUwE+SteEONfGEH8/2EWu3SKgU8HvraH4SbnWqTn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qGWCdSEXLNdUDxRAI6elSLOQRveKH19I4nyeOI4CEQegk3IYVF2hIirn+5tWrVxI64ZjC1VXD8yKpVT4HSVQRALjH54XqLvGnqwp4Urf37KaFLni3RPivfQtW9D4JH2BVgpKfvsGIIkqH4sxAbIfnGUAyXL8XkQG4jdQXIEsb8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zf5ZTXqn; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zf5ZTXqn"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ddd2710d14so23798075ab.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 09 Jun 2025 00:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749452602; x=1750057402; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zxn0gf5DjkiekmGDoc8f+jiCNw9RjSzuhtY2t6W/Yig=;
        b=Zf5ZTXqnNJBE1KGyvqh4XlHMy/+uL7dmvQkXaELcUTODzkSdIBxTAHuNhZ1CJTt2GX
         ZbZPu6U1FmVkd9/5OlgHvmTtxY4ma/iKCZoGtQyAn/Ze26z+pS3QqfWukRX4QTOqn9dn
         oKM3YHEGKAUSmunV+80sh8H78iaqjj+OnoKszKTaIekVfKoWtXlBtV/Zc4m+z6Kn4cQD
         LH6erfXlj/AvbpDSWoZU48CpmRdAZ+rHZFA1/qKyq/FwEKqEuMyjXthysORfI4AUByeR
         XZu+iF7b8U7sXm9DglXhG5q4ExXbU7KF5VaDxyI9UDqqiut8Xl6efd8CJVjh2qBpCuHd
         Sz4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749452602; x=1750057402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zxn0gf5DjkiekmGDoc8f+jiCNw9RjSzuhtY2t6W/Yig=;
        b=iZbjmX40BOVxQW6NnIE8WPA/ucmhgbTtxUhnVt8Cvhw0nonUiBxvNVfmEfxnkXk6bn
         XArZQVkuCr/EmKN4MiqkVmo1S2D1rAsQAFAV0Pud4PVXHyqneA0FItGIaZyvME8/z/z5
         qtUT4FVNX9XW0qC70iKnP3qTiZpRg6gnygYvNOWbAxKPl0EDw5rMWCcHhuB3Z8/Zf19U
         iQyU8q0+bCnyXDHeronZi59O/vV5YivrXsjXleVndFlV6jV/VqyqDLqYkvzoCIRkFAPU
         fyawCsdJqNYXvo8laqpMWSMzblXgwXMsQHIeOeGXbhuKPfajUrAdw/KVNCsgX00y6dwX
         W+OQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu8PlOldbeVuhAhn2vKF85kwjfYLCkUxWMkrDAtwDptLme4TJZxNh0mEU2h+HEBoQnaICr7iENDvj4v/i4Fw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRYl5i9RhC8j2gWpW8odb3qkKKcRTMJ7zKquDdJIOVMHEVvWVn
	K/1fpdeLKIMZ5TixODgcv627vMoC5oUcxIQOPrbTCkdIzuNvY2JaJgnkmjt9aSKKjQ5SfN43Z2z
	keQQdK9fdDWCliXiS4ksb7qVuWyvmQ/AVVmkqNpZRY4eNpomiD4+neYKCw5w=
X-Gm-Gg: ASbGncsQ5jXlJJm5ypog95oYGc2MV9C02CehjimRpWUsLUsSbqf3i9pDm3trpyZodkF
	E569YKmdUghkyPhmfgomq8wIvcP0CxMapMaUn23GUFmwAeqlz2h3q/trDQXsPPTwcYMiw6MokQb
	2BV3HzZak6chMgs/EYNR6DTVFSr8RgCPMZLip5qYIXalNXlN8KV/Do+qGEA4gIjLtiudOhae7+z
	WnV
X-Google-Smtp-Source: AGHT+IGe/4/44D/ghxEowOkcRodziGm99URjyJEhwDGnJ1beM5CL7lH4P2Iro03Zrvx61SWSJqecABON5p5OEInqeUs=
X-Received: by 2002:a17:90b:224c:b0:311:e8cc:4248 with SMTP id
 98e67ed59e1d1-31347797dc1mr18023465a91.33.1749452591283; Mon, 09 Jun 2025
 00:03:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6745a8df.050a0220.1286eb.0015.GAE@google.com> <684650c6.050a0220.d8705.0018.GAE@google.com>
 <esjz6hewatxgaiqdluqf2sdorpybqxcwr4c77y2fozs6plj3yx@bkpt7rrtzdid>
In-Reply-To: <esjz6hewatxgaiqdluqf2sdorpybqxcwr4c77y2fozs6plj3yx@bkpt7rrtzdid>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 9 Jun 2025 09:02:59 +0200
X-Gm-Features: AX0GCFu11bVvrlwk_kziMotGT1GDhGmAjiJrfo_A6N8T_GTNzVdIJee0BK1Gteg
Message-ID: <CANp29Y5Ew-7FCrSmCXngSJ66SeWMMX=bgztUZP99i-tGX=jMbg@mail.gmail.com>
Subject: Re: [syzbot] [kernfs?] general protection fault in kernfs_dop_revalidate
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: syzbot <syzbot+e37a1730d63d207fe403@syzkaller.appspotmail.com>, 
	bfoster@redhat.com, gregkh@linuxfoundation.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org, 
	syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 9, 2025 at 5:19=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Sun, Jun 08, 2025 at 08:11:02PM -0700, syzbot wrote:
> > syzbot has bisected this issue to:
> >
> > commit f7643bc9749f270d487c32dc35b578575bf1adb0
> > Author: Kent Overstreet <kent.overstreet@linux.dev>
> > Date:   Wed Apr 17 05:26:02 2024 +0000
> >
> >     bcachefs: make btree read errors silent during scan
>
> syzbot bisections have been looking _very_ unreliable
>

In the bisection log[1], syzbot has run the reproducer (that mounts a
bcachefs image) on the original commit 20 times and it has got lots of
very different crash titles. One of those was actually the original
crash:

run #1: crashed: general protection fault in kernfs_dop_revalidate

but the others were in quite different subsystems (net, block,
bcachefs). They look like different manifestations of some memory
corruption caused by the mount of a corrupted bcachefs image.

I don't see where the bisection could have derailed later during the
process - on the tested commits, the kernel either crashed 100% of
repro runs or none of them. So the result very likely is reasonable
w.r.t. to some bcachefs bug, which has apparently been fixed since
then. The reproducer no longer works on syzbot and the last "general
protection fault in kernfs_dop_revalidate" crash was recorded almost
100 days ago.

[1] https://syzkaller.appspot.com/x/bisect.txt?x=3D17abb20c580000

--=20
Aleksandr
