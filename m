Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716F71CCB41
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 22:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729636746; cv=none; b=YIfGA5ZhSps3UnsZLKNbv+EbV8ZDo0FAr4Qvj9hClULJeVYpqA3VnXNfJABhp5OhDUYBKng7R7HAKn4dIeRQqYft87szwFGHbmHWYe4hLN66fyI+RYsl/7lzS3dfH+RcBDnJVekwnX0ets08XEQZc7LGlM5F0KSPkbTMDaHWrtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729636746; c=relaxed/simple;
	bh=qluEbLL/61JnFJJ+1HrJtCML4J7G6Oi0jEbUGJwD6O0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=rVk+6UcKaPDjYieght2Yu4GVgr+bwcOBtiIZu1DTqDV2MEWbWMNkbYxnpWD9xnTUIrYVWZEUC9Jd574MUxvLnOkjcMBZxWtEKlhF04okjXrcuIVS8akPE96RCvuCieNllLHxT8eSW+mQNN81UTMrAKbOAT8NjU8dooqKd94/GHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3c70e58bfso53078045ab.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 15:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729636744; x=1730241544;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ou3ZSS8VXdcc2i16wGFKqFwy4n6TY8ZsZEapadHZyfM=;
        b=k90BjpxrFZEmF3Llot3Q6+H+yTeoHVCxSll4wedyVzW1Kgbuv/jTMfRSuNcS1AC45z
         GCNixMKF+0CFPjKBRNIOHhQZJuzhrz4h2tZEK+pYxuRapfcfF0+Lsz+ufqCDv6cVwIit
         lQPF6LUzFPlXBeLyseMnaceHjSpbwCxeUmKEdY5ZJvBT/mVEAZvNyrl6a7NUYFD/rOhw
         503j0CDr0iLDjulcZxJ1Rn2OihhRT2/TnQaehaoePFQ2VSa4cCSkDD9aUfKQYpMsmIBQ
         HFqeXqiPSN7H4eJcb40a0vadr7nr3lMXUiC0YEuz2bjsN5/uEn8/XpThYbdTb/Es6Imp
         S49w==
X-Forwarded-Encrypted: i=1; AJvYcCWfbUFLAkMkRIlfRA3Ssk635nW4V4RE+tTvDEp4dkuu30/YI02hCyfeT9K2u92f1mqQo/PjqMIsRQNgGMHkSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvyGgbROfxvLI54VPR67vUDop6vKreJ2z41OJu6Qeohc2j+/JD
	fFXaDOeYlzEcn8FJiAHD7HhKRJvZOlBO2l0T8UYBNQmwVswqSUJXhFhOMd+G9zHeZqRt1BbyT1y
	80+6hVVZ/6EtzqizhRw4E1Ar3QlfpOSZ3t9nTObvPBWWnzwknBo52B24=
X-Google-Smtp-Source: AGHT+IFOQm2zWuPY/iTsaUu2kI12hYW4zsOaIt6XeZET0rc7gdHnow318GkCuavuJN36Cgl7ruV9Pe5MyCWkd6+Iedn36f9J4nLR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1446:b0:3a0:9c99:32d6 with SMTP id
 e9e14a558f8ab-3a4d59d179bmr7359755ab.24.1729636744550; Tue, 22 Oct 2024
 15:39:04 -0700 (PDT)
Date: Tue, 22 Oct 2024 15:39:04 -0700
In-Reply-To: <6717a66e.050a0220.10f4f4.0127.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67182988.050a0220.1e4b4d.007c.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in __closure_sync_timeout
From: syzbot <syzbot+43d0c6eb00a26a41ec60@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit f7643bc9749f270d487c32dc35b578575bf1adb0
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1374a640580000
start commit:   c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10f4a640580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1774a640580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41330fd2db03893d
dashboard link: https://syzkaller.appspot.com/bug?extid=43d0c6eb00a26a41ec60
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12265430580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1105c640580000

Reported-by: syzbot+43d0c6eb00a26a41ec60@syzkaller.appspotmail.com
Fixes: f7643bc9749f ("bcachefs: make btree read errors silent during scan")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
