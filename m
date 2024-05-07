Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972CA16D9D2
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 May 2024 19:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715109065; cv=none; b=BdydhuJNvr7YjgGFM+JtmVEC8L6fVqhEbFKztbY4GgA/8CiDUCMmf5HQRx5CUuyyXlOCpRUUb4MW5iAn58rldlZWzk3PeAHtKCMuYW3uaJM4I1/NdAGbb+3zfXbUul6vEPrX0nhpME1Hk5llxPt2k6GVymOJCUUpQ5gDGuVavz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715109065; c=relaxed/simple;
	bh=MZDRcTYIrPY/KVDPzLf3Ur1jeAmwMRwZb4IO6MJFfP4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=uhNYaP4TLZNP+G6HxuapEPseSnrYoPzIb4CYrnfB90jW9AVV9yN4xx4kIADwB2MalzTbeezaF1zDwYnTBO05k/o7dSKy2FnAnf5506IhkqoUOAnKZ0ImoqK3+B9HNAp30OwnIh8F5qvylQ34M1xooO0dmh31JPLuV8vMU9GWa2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7e182885d98so120393339f.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 07 May 2024 12:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715109064; x=1715713864;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EMMmdnnhlCk6lDibFaruqJ+bDg8KgHzYf4Lb5blyQuQ=;
        b=Dic0MRlPAs53UNtM7fSmKJ/xXYrrKWsUCQfTMkoWtYwyJEbjfZ3ob/Yqdrhx6w8QCq
         1CVxPlzmFSmQH6t2uybqryVLz8pXWMc4Pdj3+wXK22xE5TvVZo7F/OwwSnVgiHgdPYQY
         vowZ+wxn77nVcDv7yUkX4PShUYI/s4Sy3cdQ0pomIJ7xs0f0zWTDB7ihoK+PlryQ3gAM
         O8NYb+OOv9lyo914fC5kuR4sbuZo4p3EDzrotmotobZdtXToQt3+Kg58Hkk105XEAxYe
         6PjdsksPZ1aaahuSFHaEODOWGqEEJifDISvEEUQ2XrCgzjnZMEc6hynlZatsOgSLQ3a+
         Xf4w==
X-Forwarded-Encrypted: i=1; AJvYcCXZzO1vWxs8j+rgs60Jx+1hUxuD0+6h0DHCAinuZnZvfxGl49u7lRyl/kxNPT9jotDW7i0JU/5rcW5pwaZJ5kHm3We8NW304DzKkGlXIpA=
X-Gm-Message-State: AOJu0YyyEWj1OOSLW+0DQoekw2+x/dxR5X/9OfiDf68hayE9EAh8byxI
	cxf9sSicgcXJ0d9zSvwoYYQdynpi4i/ppY6wc/YKAZIf8cNniMLMlBKBLS1ADRipToo0vr3DrDg
	ZLKKVepwle8NTgre2pJQXuib1Zs1ZYF0AVgcWqm3Z9nkN8BSlV5uaidM=
X-Google-Smtp-Source: AGHT+IEtr+Z39qefIZO5XPc+3zq+HrmB0hikp4+IjhHgaHCLJ1/SO5ihOTsmd39/5axw913OgOIRhRdWd2p2AaH1XlWhF4l6RT8a
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d9c:b0:36c:5520:9597 with SMTP id
 e9e14a558f8ab-36caed58de7mr195005ab.6.1715109063836; Tue, 07 May 2024
 12:11:03 -0700 (PDT)
Date: Tue, 07 May 2024 12:11:03 -0700
In-Reply-To: <0000000000000498630617b740d3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008059400617e1f284@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in rewrite_old_nodes_pred
From: syzbot <syzbot+594427aebfefeebe91c6@syzkaller.appspotmail.com>
To: bfoster@redhat.com, eadavis@qq.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lizhi.xu@windriver.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17afcbc0980000
start commit:   7367539ad4b0 Merge tag 'cxl-fixes-6.9-rc7' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=146fcbc0980000
console output: https://syzkaller.appspot.com/x/log.txt?x=106fcbc0980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f00edef461175
dashboard link: https://syzkaller.appspot.com/bug?extid=594427aebfefeebe91c6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d1b2a0980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=135c2ca8980000

Reported-by: syzbot+594427aebfefeebe91c6@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
