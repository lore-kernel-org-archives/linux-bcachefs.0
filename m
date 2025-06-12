Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF58213252
	for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 07:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749714166; cv=none; b=S665pOZdNmQD4Gn7YJpprA1nEYpkmx0WUMvclGRp19/g+xqVxWKmdwyvDB+QtmhqNZ9x+WKoyqDQCcz6udNHU1eKpx4CQti1PTMKL9ScdPuD8eGParXLsGskcbzNEjw0gh4z4NbAp4MimqG4v71avKxHDb+f4XeJC3BjGXgeDYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749714166; c=relaxed/simple;
	bh=FOQXFaiVwO7dhrkbgNrBD2ORgwbO509L3NsVRqNVEVs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J/l8Dvb8sI0IAgSCxX9AWMKTFbrpEgC5gc3jFyYqnR08i3Gs9m6DnfGMq0H15INz7oUQ2u0Vu4Rd599v49kakK/99qRHkhJREgzbUnZuixkXGz/gJva4or9cur6iNwAZVz+naiy5xt+Rpty6AEPT2ZC//149iTIyEuVh1wjb9XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qSfwi0d/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qSfwi0d/"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-234b9dfb842so7068775ad.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 00:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749714164; x=1750318964; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/EqLSwnInI7/pMnd5ysWVbRy8uvQJPmZ91Nx+44JVcw=;
        b=qSfwi0d/Q3YbWvcH3abb1v/U4sMurxcSDSPjzXYbk9+9XLnPnMqcWOdFvWBKXeuTJh
         we0gKNyBP98BZgrPB95VV0h0rYKWa9CGn8XdT4Rk9dcBzdEHWFelLNqqgScxykOZ4DxU
         JUdnxG1+9y4Ag688nCexDNbFLcMCHyLDRqAS+yBs7hTcf1+LERbQZcCYubXXrIYecghG
         Fh0IWJV+q+E8EoTttE7T7YfkhDC7NidUrwsxud42A16rdeFzVKlV5wOmsF2mFOBpg8Pd
         Q2xv59/MFuuMgh4/DwQpsEkXIPeUwbyM7SrKK4CSsgKG/3+Q/KjAOL7564o8HhiZ38IE
         jOgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749714164; x=1750318964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/EqLSwnInI7/pMnd5ysWVbRy8uvQJPmZ91Nx+44JVcw=;
        b=H8enRXrhWH19Xxpg60fCaQa7GkwzrX9pbHNJ8x06mayJtgo1noMmLOOZ5FqeevEBLT
         hAYnzCeyMhTAhfyhAwNvbWRB7w0tCKuXn2TINr7F4bgm/xGWj/ir4FfQs3jw+023xXeB
         oxN5RdsTUImcGa2TmnUgELQSeFizQ28jsgRKNAPgefYqtp48cz8Bjom09ovSGWY8J45M
         a3txKpgcJFDyKEcParxzde/It+lk5edIHkikbGdiDTeN1c3qjEBorzi+eLVygkd30IWj
         ztkr10CDrk7LYWeMYKN0G7QNfROo+bCHbSOyYp1RUiNrgJHamZH6Z625j0i7SQF0qtHQ
         7B4w==
X-Forwarded-Encrypted: i=1; AJvYcCVpKD2aYqfkuD7Dgbn+kS8bRPIjGibhCXWnEwiMlW+DrJa2nFXuYGQWx+415lKf1DdVEwP+dn2gaj4O6X5qTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlEs5FHwQDkVt2HRmJGS8rsBGsfCIjGUFhBURjYGFkuzPODzzP
	Z1eafWx7H6NL2f+fL5O5pOiE8WWFrHGDFkUymHcVzirtoOWKCWvncNQEcnQ6BRVDqx52e88ryVt
	Pe3Bq1yhFbGZpavh353NCGh436I/PR84gXxhUuTUx
X-Gm-Gg: ASbGncui+4SG9sMfeQhI/KiwcIg20DAUM83IfxH9rgvuXPP8B7J+CN9QZsp+JTUwr+T
	XAv17XOZ87IteHlq1BzctUVHtKvXkNLpuY4gykRRXaxgDEE6hMGsLYdl1WSg0X6xeB3vfJ6a4YC
	nAwq/ooZn/TZhUDxnZLFDkeEvBEVrwQ5u53maEAF39bkcjyNd9EWT/QImYKHJf5WsoEyO4nOYax
	A==
X-Google-Smtp-Source: AGHT+IHWfz6ueRsBMvrL8ANKlYfntcz1uoa4QJR1XOifNxP+96m170S+IXM1efDQIk8mUoonHiE6qKHXDmQCeffxrW4=
X-Received: by 2002:a17:903:2448:b0:234:c86d:4572 with SMTP id
 d9443c01a7336-2364d8b7d4cmr29659685ad.30.1749714163932; Thu, 12 Jun 2025
 00:42:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aEnVuzK7VhGSizWj@pc636> <6849df90.a70a0220.cc01e.058d.GAE@google.com>
 <aEnuAp5w6QSoSu_M@tardis.local>
In-Reply-To: <aEnuAp5w6QSoSu_M@tardis.local>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 12 Jun 2025 09:42:32 +0200
X-Gm-Features: AX0GCFtO9O5G9ZnuVX3i1JpfXbgajBNsH_rdffk0L3gbJwN5FPeRccN9TijpSvM
Message-ID: <CANp29Y4d3de3cc9weuqHCw2sDMdtArOFz5B=783KZ4419Ux=Ag@mail.gmail.com>
Subject: Re: [syzbot] [bcachefs?] [rcu?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
To: Boqun Feng <boqun.feng@gmail.com>
Cc: syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, josh@joshtriplett.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, paulmck@kernel.org, rcu@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025 at 10:58=E2=80=AFPM Boqun Feng <boqun.feng@gmail.com> =
wrote:
>
> On Wed, Jun 11, 2025 at 12:57:04PM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot has tested the proposed patch and the reproducer did not trigger=
 any issue:
> >
> > Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> > Tested-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> >
> > Tested on:
> >
> > commit:         488ef356 KEYS: Invert FINAL_PUT bit
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D129a660c580=
000
>
> Is there a way to see the whole console output? If Ulad's patch fixes
> the exact issue, we should be able to see a WARN_ON_ONCE() triggered.

If WARN_ON_ONCE() were triggered, the associated kernel panic output
would have been at the end of this log.

>
> Regards,
> Boqun
>
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D713d218acd3=
3d94
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D80e5d6f453f14=
a53383a

FWIW the last time the bug was observed on syzbot was 100 days ago, so
it has likely been fixed since then or has become much harder to
reproduce.

> > compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07=
757-1~exp1~20250514183223.118), Debian LLD 20.1.6
> > patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D170e460c=
580000
> >
> > Note: testing is done by a robot and is best-effort only.
> >
>

--=20
Aleksandr
