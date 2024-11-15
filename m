Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81415188015
	for <linux-bcachefs@vger.kernel.org>; Fri, 15 Nov 2024 10:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731667765; cv=none; b=FJb/C4eeInwIOV0aERU6JYuXabZwswTGVuekm3tQf24AspZ8xFrf8czT3xOg1xsu1Xx2IkjerxJdTYfv6MlIocaBUlVmoKFpwTT80r7/NNdzVFviHuubhOpjw7wI6pGVXdVYID1b41MebAYXAjAN6CaMJOEsTHxnl2OzeUISuxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731667765; c=relaxed/simple;
	bh=gxy3kncUMYhSkyjaYeTXEbo3a7tEM0PY6y5ReWwPsec=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=S9V5JfSA9HU06p4M+fyuEc8nflch0341FjWnxT1TIU4LebmbWUUTu6cBsL1EsWUbWggcNJsVvPhx9TGTbgnoqjHx2kAakQWjgEq3DhBjfuQaTEwPZF89HguaPG16Rzx7MZy5/11HaJ7iXiZ4T0zGeJtFHJ147FJi2/pqpVJV7tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a71d04c76dso6597145ab.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Nov 2024 02:49:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731667763; x=1732272563;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3s4HffnOB2aGqugKtXeHjNUydA3cBYAPBxfBWZhwEtk=;
        b=r17t/1F5A9+US28TL1Zkv520v7Bb7oYQW+ad0hKIycCnKtArUt3S7l+K5PB+53W6eA
         +g/ncYXoZ6iud5Bd67uHt6tKbOMHvnQhim+4geHEhOAyV9+l7Et4r9ntK74HXrfOreJM
         xSIHPRVqH5CoWa5slyg/pXnZt0X2A1djX/jppbOfrGpH/GGMqzhniizOzeKLms0nw81U
         9XAkgXdnQNdEjx2pVhQ4QqyGrq8g4JKch/RmrZR9nXZZcBBjwQUTDdqvSdTKaau8ZHH6
         9S/XRHMd2UnaB7kqYypeHeKSK6wE1OyDgDfbHMH/EQFsN4nG0fMF/4e7Js0jDxkRMiWO
         jhyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwy/6Km3HYTSAoagc95Nj9AMRbTpEBHxFT9yR7mOMqQTreioCNOpEiy9zm/s4o0Q8Atq1e78RZmB6Yjt0TLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv8V79omMdwnmkB/vMVsvM5hYRT0bgtevl6/W7Am67XHLjO/t0
	gFt48jqHan0yfuwA8/1OpRMHaWGbmWa0iuMk75iyXx3kpiVi27zBGIEYzAY2a2JOekktqeG7Etf
	uD20U8NnaqRjAI4ceGcrRh0mhIRlcNdjW8gwTNqoMAcl/uSUTvjwlOwc=
X-Google-Smtp-Source: AGHT+IHXMzR+T8ykMN2gdIf/rq47rB7rG+6DPx5BInp/GkP8WzgbHyEwpqP/Y5X7MH5u3h0rJocUgDifvSO3ojwOMGvTZRL+448T
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c248:0:b0:3a6:b6b4:1d64 with SMTP id
 e9e14a558f8ab-3a748093facmr22442615ab.24.1731667763697; Fri, 15 Nov 2024
 02:49:23 -0800 (PST)
Date: Fri, 15 Nov 2024 02:49:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67372733.050a0220.2a2fcc.0076.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Nov 2024)
From: syzbot <syzbot+list513443baf0d817bf8fa0@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 26 new issues were detected and 9 were fixed.
In total, 75 issues are still open and 98 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  17171   Yes   INFO: task hung in bch2_copygc_stop
                   https://syzkaller.appspot.com/bug?extid=c6fd966ebbdea1e8ff08
<2>  5974    Yes   INFO: task hung in __closure_sync
                   https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<3>  3337    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<4>  2345    Yes   INFO: task hung in __closure_sync_timeout
                   https://syzkaller.appspot.com/bug?extid=43d0c6eb00a26a41ec60
<5>  1263    Yes   INFO: task hung in __bch2_fs_stop
                   https://syzkaller.appspot.com/bug?extid=6d3e28b33490b3085412
<6>  832     Yes   BUG: Bad rss-counter state (5)
                   https://syzkaller.appspot.com/bug?extid=f2bbbb592debc978d46d
<7>  541     Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
                   https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
<8>  285     Yes   INFO: task hung in bch2_fs_read_only_work
                   https://syzkaller.appspot.com/bug?extid=8996d8f176cf946ef641
<9>  299     Yes   KASAN: slab-use-after-free Read in percpu_ref_put (2)
                   https://syzkaller.appspot.com/bug?extid=905d719acdbd213bf67e
<10> 256     No    WARNING in bch2_trans_put
                   https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
