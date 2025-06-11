Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD2623643F
	for <linux-bcachefs@vger.kernel.org>; Wed, 11 Jun 2025 18:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749666318; cv=none; b=ADECGSLJucyOU34WnlWDc48E1ppxatUvYfNnnIGgi8zIfIXeQJmElIfBJeGa/r7LCftFTyfpOHx9rFYW202lnlmYMDFa/Alv2PcAv38obHmaVCrssetRkgtNJJOwoHNdANo7YoOeaj288FajAsMVgmPQAOpcdspw7bWvIKotop0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749666318; c=relaxed/simple;
	bh=WkIP6q09/kO639/VA+9jUW8hJ/jqp3VXSXt+kXeZWyI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=pZHw2+g1JMnKbQiuhikMAhkRzbB7tVmK4bDI731rznqCi5ZlgnNvlIWG8QNxtU8xmbGbprlOgn7tYqf8Hn/xSFGlKIuPT8lohGhvBIPJtBLAlNfzfuXSnkAezzZALRKkgjceBC/mHRcSJVwj0/AyULFgkfqElrkgcIdvNqvNfNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4066ff1aab8so122019b6e.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 11 Jun 2025 11:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749666313; x=1750271113;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TT8U0APacSFSss4rJFpVZ2Ta8ITNyPLTp/K2FTAkN1Q=;
        b=CtrH8ARCz8kFS6kHLjj44zUq92DK0CwV4i31mLFppmmH49HyTfL2NrZXwGbJegjiHK
         1qHiuBZrrfLh9lY2YqtuwxkRR+P3qY7PDzmGTTw/GOcyej/srmYEBLb/Ubv49YMOzEQQ
         I/GEAb5u5+4mIm5u21sZRJDKmz620BP5wlnWvBjBk07IX04OjMdmsJhiEdJX74eOtCbN
         2SC1opQfQndV1docCwx6nRCa6hmzo4q78VroNR7pfjbQetEbMwwAwdBJvoQlh4mbu30X
         tsxTKV3ijUpVP7LE8zIf3eYX5tks++HyQvQ24HaIs5I05Z74zIiIfO2ukgWNzIDbdnfB
         LXrw==
X-Forwarded-Encrypted: i=1; AJvYcCXnJm0sE4uAEeTc+iTOY5bsb0GTYOYwZxhQgw9Ka+B7czPyWYTBu9WC4p8F+GDY1myr+fgysFWmn1SqGrP2lg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCuBKbZbxdrEVZB2zzIChY+/hGdt/LvljuBMy/scc1DqEKBaiv
	Wtn6GK6tRDZ13/f7rQMY4T4ct/UPhOcq2TzVxHjJP71HRotVjgs76OBwtxYTUm4hyshaK3c3RNZ
	0kRZv/aoCLyZUa5J1SyShMWZ+aasj2H0tXY67fx3CX2kwofHMkhWO2Puyx0o=
X-Google-Smtp-Source: AGHT+IFB8AYaTkRJmjuKTdQ5okc5Om2wfzIkqdJ8+720iF+jrK+POAwGXletigkW6itSa4fOK92wADfO3HGVzJhQjgYi24gdkmwa
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a68:b0:3dc:875e:ed7e with SMTP id
 e9e14a558f8ab-3ddfa875ea0mr14392755ab.12.1749666302955; Wed, 11 Jun 2025
 11:25:02 -0700 (PDT)
Date: Wed, 11 Jun 2025 11:25:02 -0700
In-Reply-To: <68488453.a70a0220.27c366.0067.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6849c9fe.a00a0220.1eb5f5.00f4.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in bch2_sb_members_v1_to_text
From: syzbot <syzbot+e577022d4fba380653be@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit c5ae261c8095a37174e17eb13c5485cbd1b3bb20
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun Jun 8 15:31:23 2025 +0000

    bcachefs: Don't trust sb->nr_devices in members_to_text()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a6ad70580000
start commit:   b27cc623e01b Add linux-next specific files for 20250610
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17a6ad70580000
console output: https://syzkaller.appspot.com/x/log.txt?x=13a6ad70580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=846e731334efc0f8
dashboard link: https://syzkaller.appspot.com/bug?extid=e577022d4fba380653be
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a5e9d4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1766260c580000

Reported-by: syzbot+e577022d4fba380653be@syzkaller.appspotmail.com
Fixes: c5ae261c8095 ("bcachefs: Don't trust sb->nr_devices in members_to_text()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
