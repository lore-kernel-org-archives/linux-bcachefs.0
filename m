Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D1519258C;
	Sun, 16 Feb 2025 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739722429; cv=none; b=elavAOk1dAVTAGUZEb834brVAGfEXKODyzfBoWmeK4Me5t27d6mtylTDJ10ddYBbdF7tWyuSsYDf7tWyPcWtJ5rva/ZW7v0lMb86UdfToVpblQ7XczXPYaBHX8iE4Lvdm3LRWj4/TXjqB8SDWnrSZPHOqX0upZLLCSq7N83+RJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739722429; c=relaxed/simple;
	bh=QURX3TCQnsTzseCqpM8c17Q7YT0zSNUmPLnf6rLZkSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gpYzi/bxGI9OxGGOJpfo6x/FPFl8L9YZZiEg6XUrCgm2+9rJo1LZVWJFyonnJ7+O54iS46EgQ+YpbPmJV5/H8VkxcMZhgXTky2bFqqxjcun8qK780k3DlKnWb2RExX4LIuRmEIPTq1fx+obDTNim7A+Fmc6De2xzhiHuqjnJ2dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uui/4bSL; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uui/4bSL"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-308f141518cso36855231fa.2;
        Sun, 16 Feb 2025 08:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739722426; x=1740327226; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JGff666KGP905Vy6KNFf0v62t2tqMA1/DHBMRQ+PAkw=;
        b=Uui/4bSLv2YHzl42Oiwq7JMUHyqLvncoA8Yg5gqq+scWpngbEhXoAPPvS0B1gKtkVU
         kdnjIRc1KEViLpae7DUhL6yCLek3cWKLuxg/og5+fw2dEw29QAw7HDoNOSry8GPcv29l
         B1dCnNyBqqGfBxUUEMPLc+AqdIzPkh8HYRKnl514Oif4v+Htd7pc4izw8SpaBt3u7Bsm
         DMsd6HCAoidSl9yONw2JumcMpQBERgNkzaPIzZs0TVIzo27NF9sHu5uCnShtkVsKaIi+
         OhO6Sr+nrYbGt/FHfigWg68MRVzm/rN460UO97mQQE8rcD0dvYBDuJcZZJ1tRlIRUAxV
         /hBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739722426; x=1740327226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JGff666KGP905Vy6KNFf0v62t2tqMA1/DHBMRQ+PAkw=;
        b=TWnM+sL80tQ1KUqdIH8qxXIBq22zg8V+brDLFoeZ2QqFNt/m/329iA+FooIplmuxWl
         ycanGxDxK4bDwzt2mYTzxtPlq4WCg2cT0AqTz+0R41/waHRcWRM4VDDn4VAXBBwfG9Le
         jq+OIZ8gHhSRaaIQV97YXbp0rELsg8EcnkuUhnuLB/P2pyjka5WBXOMfsDHzct8069NJ
         Gk4PogAvfMDwuaoMr9bPBBoq+xo/6xDhp1w1a62lcxenW4Qnk77ZEZ+G2bDBEvtfuJoX
         8rFnlDykl+aHUhB2UwJGPeoZQxs27Dp06mUmVt5Hdhh5EUM/TB+B/jTgSmUBZekPCHMx
         6Blw==
X-Forwarded-Encrypted: i=1; AJvYcCV87mmrgmHV/rzd8TYu6c4wroWlfemXlygKyHATlclOB9ZWA7JltOR4un3edhrEEzmQlUpjuRf+Ijhb+ftdrw==@vger.kernel.org, AJvYcCXJj+uNQ/vFnXlZaRYWD1EVClTzZV6Yq1Jpt10hFx+Dds/LlhUD7zLDiOxCulG0zKhKlUzD/KSntSHha+Vr@vger.kernel.org
X-Gm-Message-State: AOJu0YyMUgO1TImdRuobJohpyg169mQKjmZKk8gzpV17gvQ/+yUhKBqJ
	v5fW9vL8dZM97ZKu/caD5/+zgzn3sZdzfXHXXeTtmBVqZsx0dSQ2kT4TXRtLiEfTWeC2CAZLqcP
	pomC/4CzN25Z2pzey2jYzd2G4lII=
X-Gm-Gg: ASbGncuL4JsxmLl23Vl7Ny1ZaHJ9Rmrfxia5tO85fTsbMwnFg9MVpNg3tTi4RrKjBHH
	XzC6WFpWcy9S99kKQAY3PTJZnYxaKqPS0nqDvvyWpjWzTQJFwqVNcTkV6QHzKY5TQ1M+lJECo
X-Google-Smtp-Source: AGHT+IEPRagxZ65ybd4tMnjdDv98DMPP8zUFkYZRNxajhEeqtRsLRpLYM/sQhEuXJg+hx1mREhu1jEUYnLUSROxRQ0U=
X-Received: by 2002:a2e:97d1:0:b0:308:f75f:459 with SMTP id
 38308e7fff4ca-30927ad674bmr18832661fa.26.1739722425706; Sun, 16 Feb 2025
 08:13:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <675d01e9.050a0220.37aaf.00be.GAE@google.com> <67af8747.050a0220.21dd3.004c.GAE@google.com>
 <20250214152358.7ba29d10229e2155c0899774@linux-foundation.org>
In-Reply-To: <20250214152358.7ba29d10229e2155c0899774@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Feb 2025 00:13:29 +0800
X-Gm-Features: AWEUYZlmJ2cXycQc1qMxY9bHA8o93Vs9KEMzZuE7UBLlIeeIlca5E5nvbyGjY2E
Message-ID: <CAMgjq7DQm+nwTWMdWQ66WW84O6YnhRQvZEjaY3EeXZ5-iKXo-A@mail.gmail.com>
Subject: Re: [syzbot] [mm?] [bcachefs?] WARNING in lock_list_lru_of_memcg
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com>, 
	chengming.zhou@linux.dev, hannes@cmpxchg.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@suse.com, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, sashal@kernel.org, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org, yuzhao@google.com, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 15, 2025 at 7:24=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 14 Feb 2025 10:11:19 -0800 syzbot <syzbot+38a0cbd267eff2d286ff@sy=
zkaller.appspotmail.com> wrote:
>
> > syzbot has found a reproducer for the following issue on:
>
> Thanks.  I doubt if bcachefs is implicated in this?
>
> > HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of https:=
//g..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D148019a4580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc776e555cfb=
db82d
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D38a0cbd267eff=
2d286ff
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for D=
ebian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12328bf85=
80000
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/7feb34a89c2a/non_bootable_disk-128c8f96.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/a97f78ac821e/vmli=
nux-128c8f96.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/f451cf16fc9f=
/bzImage-128c8f96.xz
> > mounted in repro: https://storage.googleapis.com/syzbot-assets/a7da783f=
97cf/mount_3.gz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 5459 at mm/list_lru.c:96 lock_list_lru_of_memcg+0x=
39e/0x4d0 mm/list_lru.c:96
>
>         VM_WARN_ON(!css_is_dying(&memcg->css));

I'm checking this, when last time this was triggered, it was caused by
a list_lru user did not initialize the memcg list_lru properly before
list_lru reclaim started, and fixed by:
https://lore.kernel.org/all/20241222122936.67501-1-ryncsn@gmail.com/T/

This shouldn't be a big issue, maybe there are leaks that will be
fixed upon reparenting, and this new added sanity check might be too
lenient, I'm not 100% sure though.

Unfortunately I couldn't reproduce the issue locally with the
reproducer yet. will keep the test running and see if it can hit this
WARN_ON.
