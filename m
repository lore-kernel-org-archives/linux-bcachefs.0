Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92F17EF09
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Nov 2024 06:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732601885; cv=none; b=N6X/piIFrEEiE6q12crGxGpGqCE3mFKvrrzAPOrWOudYSUN2jkKVXM7cAOi93kkD5323XE8dVhPZHiMn+HbU6+7je5BNyAFQWIW3t7LJVoKc3Jbj+PnwXxE3u8w5HI44eaoW3KPujWIKaU4THWqsfBkZfU+g8+DNd6xa7KsgHgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732601885; c=relaxed/simple;
	bh=Qpm9QckVXXb1I47uG9Cbd0F9B7qgMLOqlrzqwDWvSi0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=W1OCUVF4jeEoWrB+3XGCAf4hBmhUGJboFy5F89RSCjKJueaQsANVG+2bApruWq4aZbOf3ogvOwjdVv+3Z6v8+7+H8X5Qvce4LJ1XnSqwgsC3Slwks9Tw6WfWMInnWF3NPCqLkyODV5Gkn8eTS48bCqgGXdb/Bhj8aPLtoZ3bt/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a79f4c0729so47384835ab.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 22:18:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732601883; x=1733206683;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pL2C14kac8GxQPAK0YBWf+8pIClL7rO8LcoNOTLxqyw=;
        b=nfJyf1Tsq6tMBvrnBvpQEn00JBJl3gNKWPGlcR7oDBV51gIbn+WWtitFYoo5stXvyT
         GioG1XzVM+qZW77VwZI+TOD/3ZFsttJhXM+UreSKn5DE/Vqw6eoaRkA4kUrDcFmNq8mN
         KXuEUsg6iX6NpiCdhggtGuT4mkcoLtIPUrR8Nrv/IVSEmC1ua6sx0mhtIH8Wv6l1Gyf8
         6UsCtHqgosqgHxgBqwYfRCjFpEkIEzktg1k3PbL/HCM+kown6jiZAm3nYyb/mW1U5OC/
         8+JrMued1pOljqwjFIHNaMfbymqxb9Kx4HVrWVwrJUO50DxaNNrgREXUWh4LwiEvqTjn
         RZXQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4KsIC6LQjMnE8yHSChh+Qm7t+KQb86NgGqkLnwCy3wQxb4VYeOq4OcWmq9BeufU2heGGFASgiKKeIIh4Pkg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQo6Lf5YPuMuDOJbTE4dEATjFAz5zzFbsPjKt0XiEcmMqcPLXq
	19kiL255/0YbBe6ccTsPBgzSbJ2hKKOiW+yWEbYo/QjrMueVqK1FS7dyQDnADP0fXKelW6iI+Cz
	bkFxdKbRVfDW6cS8XFIacyU8OyzjvFnpxgmHXxpmxGoZDSD4JTRaKT0g=
X-Google-Smtp-Source: AGHT+IHHuq1eA3d/8v5iJGzp/2kIAPVqTOHn3ot2tTzc6xBRcSU0Ootp/4mSOLTvkGzObB+BmF/GaR+5C5nepmxcl8Pnkc+StMwI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:164d:b0:3a7:7811:1101 with SMTP id
 e9e14a558f8ab-3a79af1e894mr172826015ab.20.1732601883112; Mon, 25 Nov 2024
 22:18:03 -0800 (PST)
Date: Mon, 25 Nov 2024 22:18:03 -0800
In-Reply-To: <67447614.050a0220.1cc393.007f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6745681b.050a0220.1286eb.0010.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_evacuate_bucket
From: syzbot <syzbot+bd56952613b5dae47ca4@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 33dfafa90285c0873a24d633877d505ab8e3fc20
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Jun 19 13:55:48 2024 +0000

    bcachefs: Fix safe errors by default

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117715c0580000
start commit:   9f16d5e6f220 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=137715c0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=157715c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e92fc420ca55fe33
dashboard link: https://syzkaller.appspot.com/bug?extid=bd56952613b5dae47ca4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124c25c0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164c25c0580000

Reported-by: syzbot+bd56952613b5dae47ca4@syzkaller.appspotmail.com
Fixes: 33dfafa90285 ("bcachefs: Fix safe errors by default")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
