Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7ED1CDFAC
	for <linux-bcachefs@vger.kernel.org>; Wed,  1 Oct 2025 10:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759314546; cv=none; b=s9vJb89s2uaNL/Hc0P0PiOpVRbi0XTjz0gqLNIm1SUrQCC3X+hXxU98S+qAswaL1k76s8ZDyaQSWZ/riFb1sKjByhcot/yWtPu74c0MrdnASIQrAV+QZrfBvwzbK0DSFD8aIlEVWFPdYNqPYTLGLlRZaRVqhSVY7H6MjeDhIV0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759314546; c=relaxed/simple;
	bh=0w5Ejz96Ybf8/rKVL7gHnTjvZQUXMEJzLSIqRSsnZuI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dvnYi1kWp/9HX19vMpSN+mbv3F86k+GBFgOUgUNqLSEM5LVnGIPxGONZBK2a5V2zh70OXi2kDDb6ESCUvyjdMfUTk/IQm1af1p6MefAHDXXkrTICTPZY7rtITaPZQbg4OP/YRmULsqxtzT2bspEkCFAbUOZbcCs95hp5hg1eNPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42571c700d2so163935615ab.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 01 Oct 2025 03:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759314543; x=1759919343;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5WjQ2mLjMG7t3g8nMDgxxMGGjQ62WQJO9DMnoIMetg4=;
        b=xQIHoyD8k2YgAzfAucZgDHfXnMNjCveSApmtgseoR4S8TZuKXtxpJmZKyQwSFg4hOf
         2hq5aBHxb1KCLEHjDw08oWRMki2EMv8UWJLj6Q5wPHQzsjKIELxBvgzKFI1m4JwdAN0i
         tadlGHZX6UYSGdpvApZ+eTOdU3sAA5Qd4cSi/QolRHg7g4MGA78LNs+OBqLoT+m1Jlnp
         RB5HUaYkzNQ3iFHSXfxFIcA2UOKZSPlZqJtK7B1dUU640wXL1rfhCfuHawYyiFdJJLJ3
         7CWPWvVTOwY/8Xg11EaB70mz6s33a6UscY7O3SCM0Qu6iC0pZ67GVelZFyOAPNY537gB
         m55A==
X-Forwarded-Encrypted: i=1; AJvYcCUXgHwtFpoUzRSg2FhFHeGEFdygLHowxR6nrGFOyWk2bIV2VfQBywhtCh9ZL3bD02JP8v0ZG5XJ9BrWiaCKAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxI3N0CmNPq0mKKgi5quly9lSqZ72DVhJMaXAuVMAicPczSeWHK
	RZhW1PD2KyBKi8xRzBHzuQPqcwSeniiEEJnL0ja7aJScH3ObJBSkeqFV0hD35Ck6wtvDAszS9TA
	I7hFXp0hrdu4EKEz7VSc//v3sPiACSdwscSDdHoILWyKN/IHzDyAC1gzr7Z0=
X-Google-Smtp-Source: AGHT+IFI0FmOdK6CA8b6ROYKwPm3x42fTwrV/th9wSzTiqaQAQGYZG4D9ms3yhD6PIPQ2LOcbnWoOIJzLVikWU2n5MWKRVW++H1O
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1947:b0:426:3ab1:74bb with SMTP id
 e9e14a558f8ab-42d8160ebcfmr42420275ab.18.1759314543500; Wed, 01 Oct 2025
 03:29:03 -0700 (PDT)
Date: Wed, 01 Oct 2025 03:29:03 -0700
In-Reply-To: <689ff5f6.050a0220.e29e5.0031.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dd026f.a00a0220.102ee.0058.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_direct_write (2)
From: syzbot <syzbot+d5daa7d9e8e8d49ec379@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=129e85cd980000
start commit:   ee94b00c1a64 Merge tag 'block-6.17-20250815' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=98e114f4eb77e551
dashboard link: https://syzkaller.appspot.com/bug?extid=d5daa7d9e8e8d49ec379
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12bc53a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16bc53a2580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
