Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A5035951
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 12:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739450705; cv=none; b=nzzHVS5/YuZtb8EKIUWrqyHr0ELixIxzdvk0FEZWvF4tmLJfPnuew8YoMZL0xIU63Bu/x40FNAErAM63XrHq6+9nmXQ/OLe4JJEV5MitBKkate8wltLag4L2SzcPS2Y4QdEBhTV+CnmRtstliUnu7ntEF18810eezneleoYR0LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739450705; c=relaxed/simple;
	bh=aiadqV5OXz7ZPf8k4d2xDgotBdLfSupe/8euZgfx4ew=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=k111ppjwKc9PrHVzjq8mO5s6G56S8nbOpN6e6zujfuqxHdinvuCCAOIZdUFNGvrZnLYlWx8t7XnkKPlnUntOIdnufN+x6NsfNm4bnuBunGMX0XaAzzrySJmncmKdliRKOO42j7BTyeVEJLVpQdTad57VlI+a+wuZERlvB4m6bV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ce7b6225aeso14915445ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 04:45:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739450703; x=1740055503;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LI/x3ZGBPy0s4byJ94RDIT6h2pDqBH26o+IuPkflehQ=;
        b=bAXSgzMlyT/EaGkSgAKDy4XU1FTuBISh2Zx5bQb1Wkp1qYLfFKnjYQhAzFNZOy0Ukf
         BJ9innROSH9PgyDMUzW+PGLVp+R6FbKz4cpLlVUdIch1q7eguZdgalYNA2qHgF2Et1MB
         9QKT9qKwpI8AkuPWyw1C3gc0vczHy8KZKSQzGdbKeMV5t+smL3f1PScoguYG35XQpv6N
         ZoYtgHwm4SODujHHhTZwY1dEKLH2wedg2fkWyWTbRbDZMFuQ0jLRm0hWjXnOTiibDNnR
         dHrveYIZ2bw7v1BpKyIC1MkLQpTxo2AHZflh64NCjKtya4Xv37HLa7SlsjizajPr0xdZ
         hDyw==
X-Forwarded-Encrypted: i=1; AJvYcCWtJIbMvYny9ilmTEhJWDelxirqY7ag21ZG4SWbd0Em8+6VIrCUAy9Ea6jeCvrp+RzBfLxqysfgozQxiNCwlw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjU+kF66nGah65WX9aQbe+p8YujbxteTHVoz2uc0dpIBiefN5A
	CeMo7HqP66V1mIOKhpgTi3bdi+W0HoeKJiV6ogiKQqVd6Gb6YcLnZyj2NxzqadhYmBDK24O4LXR
	ro1dn6lwWPr2TGCjkdhPo9S0aePIOLFB6Dl/YkIfcrMOfz3GyMTthz4k=
X-Google-Smtp-Source: AGHT+IGjC4kAlffaX4GfaHYA96tZu2Kx/fqUuTl2QaXnE0hxbiorpmGhy/oRJqNO7vltj5kUWoUYYfc6lRX0EY29b1fsT9D/YYWu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17cc:b0:3ce:78ab:dcd1 with SMTP id
 e9e14a558f8ab-3d17bff6a07mr69682595ab.19.1739450703005; Thu, 13 Feb 2025
 04:45:03 -0800 (PST)
Date: Thu, 13 Feb 2025 04:45:02 -0800
In-Reply-To: <66f02282.050a0220.1b7b75.0003.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ade94e.050a0220.110943.005d.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_quota_check_limit
From: syzbot <syzbot+8364d1e040a88ed5657d@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=104621a4580000
start commit:   4dc1d1bec898 Merge tag 'mfd-fixes-6.14' of git://git.kerne..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=124621a4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=144621a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c516b1c112a81e77
dashboard link: https://syzkaller.appspot.com/bug?extid=8364d1e040a88ed5657d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f34aa4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134bbbdf980000

Reported-by: syzbot+8364d1e040a88ed5657d@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
