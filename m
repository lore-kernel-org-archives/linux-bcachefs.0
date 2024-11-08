Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6927B1BC3F
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Nov 2024 02:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731033364; cv=none; b=eFMmHFE6HPs+mYKtPLXvGBs9Dw8GRvE0OJgm7t44Ws6IylTaVBHrBmyVwbirgKftQCkMk1sjtqJqzFzJW6cb1szcrelXzJfsdrQI0BE/U2zzzOL/bxCTyzH81wgTjnrf6CH4CuAT65uIOa4hEQsmrKHzOfcK8o15Gu/Sx1Nmk1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731033364; c=relaxed/simple;
	bh=ylao5bEk/CD05cKWA3bDeTSncBr7iaNyh+pD1alF4BE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Bs8LqopOEtoKNGiaIBHZDH4B0aMsTNsjWCrlykm1tzhtXhTbPVvRlJk3kWYhlNtyKUYRTdft0+rI2F5ipC1A4tkXblVzHFVxQ/cgXSrIddjRfrnw/r5R0u5vpr7fCecAjTp/7rozU6LKX6X8qOPXK+AXBVM813b4ZlfPCWZAbsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-83acaa1f819so189781539f.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 07 Nov 2024 18:36:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731033362; x=1731638162;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=88RupAuqMASawdtlRRshtw6JABpEerpNHWxBoUTT8Mg=;
        b=Fjv/bT6ukSiRZMv3SKPh40HYV41cHKkfPJGcrbIspuzCMWG0GM3Vr8njI1GBFCrfcf
         089id8GHXaYS4R1EI0DMyqQwm9jAVAKTJ1orocUy+mPbSM4QimDDwlNHq7aZ+MllLOVP
         cq1SUBnFjIwDR0ZK9fLYtIMdFoBtZC4h69tWlB4Lj+FZ1Cl43Mrq7H136n2OC97e/zkR
         6snormX01b5Y6fVjKNmfCDLquHuo0Y8C/ZL3/JvKj/CRO6abYqj3ZBqIqeYFlja9Rox5
         BRUFqVD877T6o0Tt8FmExWC+4+EYZ8ZNUm+SikKY2V22MmJKdoxqYcA7ua0XSEhjFrJn
         7F3g==
X-Forwarded-Encrypted: i=1; AJvYcCUw/1cqRfmodhDK34QPHEsHJwktlZdWk6XZ4S3ycZ/4N6Qh0Go8Ce1uK/wxgW/lUN3H9+RooYsaG2PSRviEkg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj1Sn1veDOKnIAnr6f1rCKpGndtXktq/ihJH9UMOczQrxpQuQK
	iPX52U+M28DKJ7EYB36mk+MaIpvIsBBx/MaFiLztMYaeEn+FypbHIH5qVAj3KmZhayANOqCXC34
	ePzxVM3ySfpxeR9nC81FMKQ5B8mSKxXBqwvH0lR0BVrAPN2YVI4TMl2Q=
X-Google-Smtp-Source: AGHT+IFSSWvfz5vQMH6XlEgHhK+BKrpmJIarnq77o5ZAE6cfC6hvhCNT6yYlCD/JOWeXDYTVB/1kTrjfXkUIsJ/iYhLIZgVt24ZX
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c87:b0:3a6:b0a3:5400 with SMTP id
 e9e14a558f8ab-3a6f1a21e21mr16301345ab.16.1731033362539; Thu, 07 Nov 2024
 18:36:02 -0800 (PST)
Date: Thu, 07 Nov 2024 18:36:02 -0800
In-Reply-To: <671b3f75.050a0220.2eb763.00d8.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672d7912.050a0220.0db4.01b8.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_trans_node_iter_init
From: syzbot <syzbot+b17df21b4d370f2dc330@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit bf4baaa087e2be0279991f1dbf9acaa7a4c9148c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 5 21:37:02 2024 +0000

    bcachefs: Fix lockdep splat in bch2_accounting_read

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d95d87980000
start commit:   ff7afaeca1a1 Merge tag 'nfs-for-6.12-3' of git://git.linux..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10395d87980000
console output: https://syzkaller.appspot.com/x/log.txt?x=17d95d87980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=921b01cbfd887a9b
dashboard link: https://syzkaller.appspot.com/bug?extid=b17df21b4d370f2dc330
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16997d5f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119e3f40580000

Reported-by: syzbot+b17df21b4d370f2dc330@syzkaller.appspotmail.com
Fixes: bf4baaa087e2 ("bcachefs: Fix lockdep splat in bch2_accounting_read")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
