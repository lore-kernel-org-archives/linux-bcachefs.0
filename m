Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7D9264A9F
	for <linux-bcachefs@vger.kernel.org>; Tue, 27 May 2025 12:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748347866; cv=none; b=lbnRoF8jQbXu2okFCwe0MR+Hfop9uPhJfjrwcEUd8oOKmRV1HAou5gU4snX1PGXsejCiXJroioliggvGMhxdUxqWFsJEROyIBFhnhzRo/nf2+u1qvBDNQLxKfX9ZC+CBDvJWWKGOYRejIY/IOF1LnL82T++GwLvqXN3jnSj2UbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748347866; c=relaxed/simple;
	bh=7nzdsY+tw9XJsuzHhu7PU8LWMK8ftVc9MdradTmqDw8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=RqNhZVUD0sf4/gsgCNPF7ymTFCErkLtYcVfllFzxKO19F5I3DwJz/IrwI0M17rZEJkH+vr/yk09HvW9IH6c7UG9fui7RB1/h4iESfd9LIwNOb+ofDwmPqP7whi6EbcqwDsno+i0Yqgih7CXkib1Gh6iv2/O2LFpq4A5leKMk4G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-85e7e0413c2so283737539f.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 27 May 2025 05:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748347864; x=1748952664;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W4m1UUqpJAKgKSluML/kNfo/ue7vZEDdh4UZJYDFlyc=;
        b=TAM/KOUas0c/dqIeVuFYlBrOKsXaFhQfj/M1AsuQJMTBkyWpXMiEK5R6hOZinooJ3g
         F4fnYSXvJyw6DjjEGoi291LOa+HznwFGXDDZ37kBLkbg051+KjCIiTDr8Jf4nPqfutva
         QbhxRYcfZG+8duOEzUPzEfQFOoxjuWFRPxipaH+D6xgKh6TwKqIHgRxv2UnIYu2Ve9HK
         NypyBRTabi94wGC1ivac6J8n7i3Dfs3JXz0r7R2KOKZ15IgVqN3oLbHJ+ulO9RiHUOJi
         BWjGAugOsIEsk50ngm7LnTSEHHsdsk0cfa//CwbVR5IPH0okHyEqT23EAT6snxiZqSrg
         tMDg==
X-Forwarded-Encrypted: i=1; AJvYcCUCWUV5Pf2/yrCXmRquyJuYcEMgauW+Idc9URwbLR2KEz16V54lN1/4fmPFio52uBozbd+QcqUSUsTcCxxmvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzN866IntygI1rAdjnLzdTgTVbmy89vIeacedOsGMcjYtHtj3Qq
	BI3vARmKwoHYtUVSUnQmvnnU8WOPkgKrsqLPivGC26ChfrKQs56POmTrw3UoLrJOhR7k06xt21S
	gfg8DarL7j5ldvpV5G1ZFp1LwG1Z+FKMh/v9BWktsJMI59gYwUhloH1C3SGk=
X-Google-Smtp-Source: AGHT+IGSIYi5LdnFWkgJ0KvvU4ja4Y93K3443EfUaNTHWFd5hTIcdZto9eLwg1ST/yNQUSv/ulr77hadAEByejL8PZvym6cI0i1Q
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3791:b0:869:d7bf:6f31 with SMTP id
 ca18e2360f4ac-86cbb7f51cdmr2008782439f.6.1748347864379; Tue, 27 May 2025
 05:11:04 -0700 (PDT)
Date: Tue, 27 May 2025 05:11:04 -0700
In-Reply-To: <68342b55.a70a0220.253bc2.0092.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6835abd8.a70a0220.253bc2.00b0.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in rhashtable_init_noprof
From: syzbot <syzbot+bcc38a9556d0324c2ec2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, guoweikang.kernel@gmail.com, 
	kent.overstreet@linux.dev, kpsingh@kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, paulmck@kernel.org, 
	pmladek@suse.com, rrangel@chromium.org, syzkaller-bugs@googlegroups.com, 
	urezki@gmail.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 82067c916994dd1bfec65496144dc16e17899e36
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri May 9 03:21:28 2025 +0000

    bcachefs: buckets_in_flight on stack

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1528f882580000
start commit:   176e917e010c Add linux-next specific files for 20250523
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1728f882580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1328f882580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7902c752bef748
dashboard link: https://syzkaller.appspot.com/bug?extid=bcc38a9556d0324c2ec2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145948e8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d6a170580000

Reported-by: syzbot+bcc38a9556d0324c2ec2@syzkaller.appspotmail.com
Fixes: 82067c916994 ("bcachefs: buckets_in_flight on stack")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
