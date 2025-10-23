Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3492C267B9B
	for <linux-bcachefs@vger.kernel.org>; Thu, 23 Oct 2025 07:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761205568; cv=none; b=ZG5Ls+dbt1y57mAW4PR8SPwU0Cl2tU2ejffBP07+CWly4ZftWNzHrRBl78iFhFxr0GXWaqIznCxKPgz/JC6PkN8HW5Zg+KK6+sJ61GMKHAx6/hOJ3+kZvKJJTqIJY5JPVa6mPt0htUCbIn/3+F8AfYaCnUwP5blkQmcjx0+6jiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761205568; c=relaxed/simple;
	bh=mVYOyb4mY/R3I0qazG+bSTyVgEhsMGMLoq+Ene2X1fY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Drd0Zq0Fp5htvgGB883ZjaLR2VOz0FksQ2ti5WFTeVtSajrNZqjRtu9zuxyYINkwCtPrxtnJLUXCvvbXUJle8rHX9B5uHzXB4Zocs7UqPG0LnTI6uyVy79fLUDUznjlL4aR6ZCx1wMEXPpaFf70ihreVsacFfjimKefaQlFa7tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-430d7ace0ddso6261565ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 23 Oct 2025 00:46:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761205564; x=1761810364;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vmip/qhiz3V5Zxb68MSXXPM2oLCrw5vCeq6I1ybLO98=;
        b=MFRmZI1pioVQz7feN/HK2UX5ZatvIMAbavUoyDThWkxHoT4c+gU65vsQdnlcL/aFUm
         4+sbiSBhcxCm+L+d4PZdsZEYB/fd4Rqgxmq0ZBb266frr6CNiUAZg/yQg6mQBCQ4ea+B
         yI4+IzJqc5VeBBiFW1nnDLQp5Q7s+ulcwVyHO0uAb8DfWLUz++tGxyk1+pR84Bxf4Q4U
         +i6fz5ldVcUpxsMjvCtMXDYooIMm7HoWSR0dG0p76+kaKcUfXe2s19nLjimiu5mMQcbH
         PkuAaZZMVdNmm7O2j2m5I2VskLaDOfTU6TLpEXZMm0m30NmU9Bk49KDOmTlWUH5Uv0In
         C0xA==
X-Forwarded-Encrypted: i=1; AJvYcCVOL1Ovww38+co4YpKH9DOSVlyUwDRj5F5+wRPbz/fi2y21JmZMMmgeV1Zp3FGNkLyaTRxVxmsEQbabh68IdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyybBfOI9MoORS3Q+Dchr2MTNF3nV4MIcM2hRtJfizsnbosBveP
	tQpmOE5dVoDDB1NgrxHxzTdfkfubBaNI6czBHwxL8dOr1Rq498CZ906fIsn7BWYe4f2oXbSSAV2
	xgGmHLafAnBo5fu7XASEwPey92PvzLB/5UP3J9ngTVvhMf4QHgGP5Oqsfd3I=
X-Google-Smtp-Source: AGHT+IGFSi+RsBvebwACUQDHXq40Hp+o//RQg9v658Uxu7DuNy5dS+FeudBx/77QPaZQM9AVHoaI07JH+8LL1nutmY8FokAdfSsM
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3:b0:431:d093:758d with SMTP id
 e9e14a558f8ab-431d0937867mr104690445ab.22.1761205564359; Thu, 23 Oct 2025
 00:46:04 -0700 (PDT)
Date: Thu, 23 Oct 2025 00:46:04 -0700
In-Reply-To: <6744873b.050a0220.1286eb.0000.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f9dd3c.a70a0220.3bf6c6.0034.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: global-out-of-bounds Read in rcu_pending_exit
From: syzbot <syzbot+e733ab672a1b6724c27f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15440258580000
start commit:   87a132e73910 Merge tag 'mm-hotfixes-stable-2025-02-19-17-4..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7bde34acd8f53b1
dashboard link: https://syzkaller.appspot.com/bug?extid=e733ab672a1b6724c27f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d8aba4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e1dae4580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
