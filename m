Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12B87E575
	for <linux-bcachefs@vger.kernel.org>; Sun, 29 Sep 2024 07:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727594885; cv=none; b=qPpmgV4zdPdojkqjLGrmGGZYph2wLBCGdzQbATKfUbGL4sLAbQlTmRXbOUPqjJOdPpPt+bMChjSZgeUyvZtWI4e8UMQOC3gR3xOPZhAb6JSayXor7TYn+oAew3im9EgISmsWOO2KlTG3C4A13Tkbt2w5vYy5biDowk2Ma9ucwHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727594885; c=relaxed/simple;
	bh=D0f0JngKS9vM6m4p6b4eqZ//KcfC7dTDIrQ4MQNLMmY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=gGtIcmOpK+RJzoCN7matk4uM3oDO4Xa7TEn/LIV4Hk6Pr4QRwa2e3b2D+9WaAAmJMrgxmAWffzpJ7WBK+Bdchi74K6uXCFhB++b0w83vj2H12BT8KRCO0I6XpVAbDeYgvn/Fk2aMZTmDy6zPctmGejSPyCPzYWxLZogv6CDP3oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a2762bfcbbso53449435ab.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 29 Sep 2024 00:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727594883; x=1728199683;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YZQOrBnRRLRoipx6pmRkgEgCTe+4V3ousUZTXEBFjJ8=;
        b=Oem+Wfw5ZQDbhlaJvl+C8idch15kMivA1ljie5pmjPhjaqkpKvxJEFw2+98dxQzmfw
         wcNeb0TgpMD/INb5kRLpHdSlOtnWedkKybRtKeGse9+fzYzMYcPRoPq/zfLeG14LQgYf
         gMVsGHmvqHrlL1EWK0UxatcCUfLOlKqcjYEO1/8Ys+Wgo81gLAYIkbnLYUCjclHkBBGW
         mE2QrkcAvfA/4F/yH1VmWY/d30BdrG2jCLb3BbLSM8e1E8sU8vWDyuUl8qtepbt8nz3E
         y8C/mVgCInrvpkDvduKxJUsx90ex7w2TSH1er6GJecceJz4fzicTd9+AcIH9ybLFK4Tf
         N0gw==
X-Forwarded-Encrypted: i=1; AJvYcCUQorhAdHxuZ2UBpJqvUkw5w/8cGreZEHQeIVFfUGWuyKwX/WzSm2H7eYhQbtK0lDjbCL7QbJenfIu2UDRJaA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOXs0pECnDdOWxsIPI8KpZGR0AxFVORa20DzMaxUHgvitITYbL
	J0FcTYQXxyWyssQy9SluMNeIEvAWhBBiEgMA4YGofJZNKmBEkSrCva2XTgj9NAetBuagMf6tWWu
	+xB+8Ht9LOAhhri3EqMWGZtde9Hw0byZkRO5pjDa/2EaKLHQZd9ZFA1g=
X-Google-Smtp-Source: AGHT+IHZjBv2kLweSPvvYEqUMYojV7jh9P68h92HKb0xtENthnSuxE79mfYmj0YFqXPLNfJ3oNcpLelDMNl49/iJ+/ooSK9TapOO
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2195:b0:3a2:7651:9846 with SMTP id
 e9e14a558f8ab-3a34517ab68mr65912765ab.13.1727594882762; Sun, 29 Sep 2024
 00:28:02 -0700 (PDT)
Date: Sun, 29 Sep 2024 00:28:02 -0700
In-Reply-To: <66ee8204.050a0220.3195df.0041.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f90182.050a0220.4a974.0017.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_journal_reclaim_thread
 (2)
From: syzbot <syzbot+820dc3b465c69f766a57@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit b1d63b06e8398eb048dcc455acc628e6655d7499
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri Jun 28 22:10:47 2024 +0000

    bcachefs: Make read_only a mount option again, but hidden

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10c6de80580000
start commit:   ad46e8f95e93 Merge tag 'pm-6.12-rc1-2' of git://git.kernel..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12c6de80580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14c6de80580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4123da9de65c5cb5
dashboard link: https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149c5e80580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149f8d9f980000

Reported-by: syzbot+820dc3b465c69f766a57@syzkaller.appspotmail.com
Fixes: b1d63b06e839 ("bcachefs: Make read_only a mount option again, but hidden")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
