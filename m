Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F021D6DDC
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Dec 2024 20:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733083388; cv=none; b=WlHQZWh0K8bwKiT4c3snljWCQRG93sByzvhmMTv+nUCQfRFycVz3gyRwAJj1qVvTZW63AX9HheahNA1odpbXIUxo8oQBknokP9R0pKg39Fg0OJQ+JB1Fa9Oc4vwHr9KHyvMI2gwIP/nNA8QlLUO4dmrtsNMWr/ZbD4UAaCrmMhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733083388; c=relaxed/simple;
	bh=dSsObhGUS8r1GhwLvZW7tZZh6u1pc/CKc749V17IzvY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=SvzehMyBb51GJB8EjRS2NmNQVGvl+ujsYzXj4zT4WogGlIoEKS0ySd4Zcr55G/NUaH+qBFPCYVvpbFUyI9gG3aAcF+QdlR0t65BssEXMHaQNkSoyU9iynvsKOXSe+1+gz00UDiZ47q7gYuV3uGVaPDF2i3bVG/Lvw2KgKSJt0bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a794990ef3so39036115ab.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 01 Dec 2024 12:03:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733083385; x=1733688185;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OaPPX1s8VAm+XGS2IFc62d3wok0VBUCA33fGXk3UaTo=;
        b=hgcBO84GJizhvYg+DUNb+cQ9Vd53DSAXzrHPKlUlyRL3ehHMb5crkHH3KoKyOtOUgr
         pJEqISqrtZszSvSD0zSbmFXend0AOei3NR90Or1FcI7OizzYoLHqCI7NfX0lSXjqbj9Z
         3T8q/e78O033MCS1cissTrUIBoDwPKVPqNtOwOGMco1rV4fAk7GWf+WFNV6pcKuoLq7G
         LNmlk+QfYAfZhp8X9LgFr1KPk1qwxuj88bTWy27/Fl6807ZThOHvw0H/jnCR0IFH+dKF
         5VGFvn4eXU63vX4cPVfPzphz9gbR1js9aesgTzR6F/rqpc+hJttCWFrA2GILAsNIb3pX
         HZ3A==
X-Forwarded-Encrypted: i=1; AJvYcCXmogLVm+YJX3j7y5GyBcmEd7huoCSB7PbwNa1g4Ng7iv+tHVa7G5w2Rv7yjKzCyQfJvZy8j5y2ZGcSNgT7XA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe8BhWo7vMqc/DBf6G7UYDETZiscXCFcmjYeqjD8J44R0KtjwQ
	69EDTkKLIA1qlkWPO5mJT48/9ZsrsRj9O/Da8wNoZeshC5OSthV8HWWcgOxldQuyQrD1KkYFpu2
	0oQERvwlIlDbnQuFld78RCKE3UNZxJ17+VYNkTEHYY81IZ2xKa/732u0=
X-Google-Smtp-Source: AGHT+IG1BsJDeDY+txAfsLEoO3aZBCIBBviJggagFT7PDbeJHoJDMx+EKxelgiGE9E+lChmAz9PfQRqFKHPAiGfA12SlL2xiBjhn
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca07:0:b0:3a7:ca83:3f9 with SMTP id
 e9e14a558f8ab-3a7cbd14e14mr125608935ab.4.1733083385204; Sun, 01 Dec 2024
 12:03:05 -0800 (PST)
Date: Sun, 01 Dec 2024 12:03:05 -0800
In-Reply-To: <6716e2ac.050a0220.1e4b4d.0064.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674cc0f9.050a0220.48a03.0012.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING: locking bug in rcu_pending_exit
From: syzbot <syzbot+8d7226784b8fcb4c9d04@syzkaller.appspotmail.com>
To: anton.ivanov@cambridgegreys.com, axboe@kernel.dk, bp@alien8.de, 
	dave.hansen@linux.intel.com, hch@lst.de, hpa@zytor.com, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, martin.petersen@oracle.com, mingo@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 5db755fbb1a0de4a4cfd5d5edfaa19853b9c56e6
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri May 31 07:47:56 2024 +0000

    ubd: refactor the interrupt handler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1739bf78580000
start commit:   2ba9f676d0a2 Merge tag 'drm-next-2024-11-29' of https://gi..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14b9bf78580000
console output: https://syzkaller.appspot.com/x/log.txt?x=10b9bf78580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a857d0dac7fee57c
dashboard link: https://syzkaller.appspot.com/bug?extid=8d7226784b8fcb4c9d04
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1037f9e8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=155d1d30580000

Reported-by: syzbot+8d7226784b8fcb4c9d04@syzkaller.appspotmail.com
Fixes: 5db755fbb1a0 ("ubd: refactor the interrupt handler")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
