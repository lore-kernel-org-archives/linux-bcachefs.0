Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044D534F255
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Nov 2025 11:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763463726; cv=none; b=SnCuaQ3fIIHwWfBXdkkD1FoY3VrZLj50LyNI+LKUWyyOZ/08+qK5eslVpq05Yerst3ZM+AsOKC7ms3S+Ev4uGG2XNg91ukzD97eBhdywtC9jg4gC1j4bQTLSNkH7CYcVujhrAAs3thW0OnK6In97NMEqei4lJwV640L+gu0a6Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763463726; c=relaxed/simple;
	bh=ipr1SdDM+8DdmmzGrZfFGQecEOvuLywosb0kTBTb+xU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bC7oOZATev1KUCXL4yI8dldcbwJU93ClgHY5YTlAeTfzH4IGW+vtOpHyYa3LicoxOlYa1KRjBxKnS0/zi7cwslo1ermGibH+lGnZsugYKsyFwVKIwMpLuB9A/rw9T75tpDR+2gEQe7iKbVGBmKKZJl9ZkYo9ZBL1t/SXlVtATOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-43373c85296so54481415ab.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 18 Nov 2025 03:02:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763463724; x=1764068524;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6JLc8JW3pSFgcQGNmeZLleDqZy1Xso+o+/IqN+EjkWI=;
        b=tVCQhS3G+3npz5C3DzWNg9zIfph7pnYkseE/fBMBlwJD/pNSPGXxus1CaRoXySWVZ0
         w4MZQ2csnGCAmQCQDrXRoceNJ0nnFcGu+xiM+s5BCHBBg1060j9YGrlOb0d3rkI7Ls/b
         FttXBnHG09+c4K0NlShEFD5C556NOS6Bdsh8q+8c3GCQGCFH2tlRmHwNW9jucPHGkMOX
         v/KgfNzSVKHV1K98/sUrG1MLsJZEJ1UEPE5Jnilns0/TYlmCju7bRkV223wt/Cd89fHm
         Fyz9GVqxnA7/UXj6cPPmn0Y6+9aNzwI7lnRlHbhh+VFRTFn4qp1C3R9DCTeRQwNU06Vj
         NqaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYlIwNjEsiOC6wRdI2yYkZ3wlII/zTou6pE6i39B1dYJQkarlLyHv8yFosLqc99HlVJ4LUOSO28xT3tyF+tw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4b9JNVx5/N49Vvig9tt8T8/jt4fgfS0A3mYvCn8hK31rLS3LN
	gfzdTMwaBFXn7IKTvp6o/KEt+hBWkgLezj2TUSvOiZibxNW2++8KJY6tv7TGD08AwouAjPHniWK
	WIC8noOxQGFs+0Q3RB/Y9rv2V/rCMR17MK35I5SPRbSA/Dq+pi7wgrrNiov8=
X-Google-Smtp-Source: AGHT+IEDbmF50LUxDgeO3GhzEunIAfogZM4pPE7UZYkvOND/ZRzxupXwsq1D53qeZh+ZCRdP7irrX9Bp4xhiiE0HA7q592Yy2lCR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:214e:b0:433:5b75:64cf with SMTP id
 e9e14a558f8ab-4348c93c155mr190866345ab.21.1763463724062; Tue, 18 Nov 2025
 03:02:04 -0800 (PST)
Date: Tue, 18 Nov 2025 03:02:04 -0800
In-Reply-To: <68dae1e2.050a0220.1696c6.001e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691c522c.a70a0220.3124cb.00c0.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in bch2_extent_ptr_to_text
From: syzbot <syzbot+564efbe31172fe908429@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssrane_b23@ee.vjti.ac.in, 
	syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13b43914580000
start commit:   8f9736633f8c Merge tag 'trace-v6.17-rc7' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5b21423ca3f0a96
dashboard link: https://syzkaller.appspot.com/bug?extid=564efbe31172fe908429
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d48334580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12e7bf12580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
