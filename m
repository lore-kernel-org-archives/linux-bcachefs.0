Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A37253B7B
	for <linux-bcachefs@vger.kernel.org>; Wed, 19 Mar 2025 09:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742377205; cv=none; b=JrQcaMj/COdPlxS7WKfqUp07HSiyNIQW3/eRqxee7vwt0wnzSU/27EF4lOBF7g7YRnDpX/1Gv5H3/Lkec1qEwgwrLUm4fU0/qs/TM4rYjdHVvAZsUM8kyNzXKd7gAFyueq3u7heAL/fo3lQVdIP7daEuZNQxMN2uwTTLISv1yzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742377205; c=relaxed/simple;
	bh=MUIdGfHqdt7bgez4R5hVp0jGJaNO3W5wLDchdmLq48M=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=PWU5TrtRm+Yp+6mSME4Lq/DbzUT0zhO5n4QAC6xt09UPWkGz5mC/Jg3tMuG3SfvVMcc8sQI6evojInbQFtaBeIKTpNDjzCWaZccpCOKs23xvFYDqb40VcINRTWw9IVveHV1jZptOItzgNKPEjwUwme4tXye2yyz+hTVEn6NLnuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d458e61faaso5133035ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Mar 2025 02:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742377203; x=1742982003;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kjBe+XHI3ciJhsIHuXrQ+GA2Y7SNLmT3NwnpfP+m5c0=;
        b=B7j2VAIWMJva84OYIeJ3y4HPAGvz0igbBNAKQx4LIn4K3leokTRxyl+MnwjbDrb2RX
         9EtBwK6YjVjVeCKS3c+JnjEToPC0EySDYnNxdeb64OsRlE6rYhWIGddv+ZCgTM8hHvNU
         M6l5Z3x9WwGHCsAkeBlo2IudaGs9wmf0nWkUK6LEaGXqoqXmuGYhfmIGjKAbECf4m4nN
         u7C0XIlOwWyEUNWRYPHwEiaZ6qoxzyqVsRHG8wcrGAY0vLxMjh9io4jCv6LuDmSl17H0
         Rm4P+EOFqAiDXcSa5OgziOGgtG64HT1nD8R46hCsGtt/u9U6VKQiYeyNQwlxvoSatjrI
         NVAw==
X-Forwarded-Encrypted: i=1; AJvYcCXYkxOZIYhBdjrlfGvkqQ08G2CjOeb8ai3wWet4zRPcAFPj0jdJm6qPPCbC5rFJL2JiNlwdCRA+CiNpi/iZEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGdiiAd8N1MegRlve9LBkyOMRF22cp/Fd2QqBCDpJ4I/Sw41ve
	cQmwWZzdnCrOo9Sn3iJbE91TZtXulOZq5SNH2Z3JTS4YjRSyV1tBXr5xov47wG5IMImXKCLP/nY
	qsX+LZxJREXMGThkUMQ6lssESaRO+3/DZXAVeFgNnvAomaOxkaAg1W2I=
X-Google-Smtp-Source: AGHT+IGEbYzJWOz86GSJH3d+H/uesMTKCNrZ4yEyh/GDkdwj2Kg7c34kkrPiiVjmgyRe5xz43NyJttqmOUCx3cgB3iWPOfUr81YW
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3388:b0:3d0:26a5:b2c with SMTP id
 e9e14a558f8ab-3d586ec873cmr16492115ab.8.1742377203511; Wed, 19 Mar 2025
 02:40:03 -0700 (PDT)
Date: Wed, 19 Mar 2025 02:40:03 -0700
In-Reply-To: <67afa09f.050a0220.21dd3.0054.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67da90f3.050a0220.2ca2c6.0194.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] [kernfs?] UBSAN: shift-out-of-bounds in radix_tree_delete_item
From: syzbot <syzbot+b581c7106aa616bb522c@syzkaller.appspotmail.com>
To: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	gregkh@linuxfoundation.org, horms@kernel.org, kent.overstreet@linux.dev, 
	kuba@kernel.org, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mmpgouride@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 3a04334d6282d08fbdd6201e374db17d31927ba3
Author: Alan Huang <mmpgouride@gmail.com>
Date:   Fri Mar 7 16:58:27 2025 +0000

    bcachefs: Fix b->written overflow

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176e8e98580000
start commit:   09fbf3d50205 Merge tag 'tomoyo-pr-20250211' of git://git.c..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=c516b1c112a81e77
dashboard link: https://syzkaller.appspot.com/bug?extid=b581c7106aa616bb522c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e449b0580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Fix b->written overflow

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
