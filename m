Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E878D15D5B6
	for <linux-bcachefs@vger.kernel.org>; Sat, 25 Oct 2025 03:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761364505; cv=none; b=iefbybfD+kTQK0zZTPnomaqngFUXfTj0ZHPebAwtk1X3EjkKDPp3oAnkXioqAdGbpGDtpP4ROaqL81L0eqTk1Q4E2TlcABnN+TwmgYX9tWjgK9gu5f9MFsbQcEfrBMY4m5NKlAnG1J6JtUsnc4iy0LWHnMemFqki235HUvTDyd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761364505; c=relaxed/simple;
	bh=GozhVZz+keDKXfjsd581/mSEuZr+tIyyNf/VDrajBFk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=F02K7ylwGeX6hM+y0dmfx6neC0b2T+ZiETmnZeUV172u1hSZnnsw5/4mQGj3U878kKdMrNFrz3hQvGeE0d9j1dDo+BfpM4Mgx3wCg+tYVfr/XQqmIZDQfo0tH82gKoGdb89qICBdHO2qp8NO8iAKLe6zyfaQvZmN3076UL9acq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-430bee303f7so86240485ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 24 Oct 2025 20:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761364503; x=1761969303;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xsK/UEPrxyL8ddqjyjxOlZ12wWlgjW3iRxcvD9/hb+I=;
        b=iNsmBdoU59jAYg1Lp79GsMzlaOfpZQMXZ40trkOxCxTubbBGwq9VQ4r0oLkOPWTdrH
         4LIH5K4O9U6+a7v668tyhCX8lJAix5g6dnUumw+1sAcuOOZEgn4KDg/XA6IUBpu+oK14
         zpvfs+S5pZmUaxSSYUqwvsuW1upbgi6Jn6BUBZ/Z8BnrnwLG8LKQSxBXFPRtLIloYqcj
         Z70qjFd5eeIE7KFmZSsgLUQfLO6JRijF+d8z7ToFBPsfBZjxKQ95XfizQI2tCfCrH1B+
         JyBhGrI+o1nXJBi8xeOxyovvMFdb1XZQ1o/em2xSgjJFKTjo3dyDd+pZGFsa9dHZ7+tj
         bt4Q==
X-Forwarded-Encrypted: i=1; AJvYcCW3P146wdOPC5VvgHxCqCQ+m/uLsyvMzVXPqzjQuMK7Tx391WqDOi16xgsIdoMRUfwNqf9X4SyTDlgl2wgWbg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv7d4bvQlPz6PXUmQaspteMQw57oN7gLReP/5ujBwtY9Z5p13P
	9GeVdFX4t+8Q3GRePYBKesktNlejpH0UaVb+DcvBhg6Afl0jnIKgHw1xEKPWZV+Ldnuo6sfUbhP
	eyZkjRAKAjm9NO1pF/eqRoP1JUuUHmfPHIec485aLNFhzEmJhtIW3grg282Q=
X-Google-Smtp-Source: AGHT+IGzzZxvx2blyet6QS8+aYudqnU6FpQQC2PjUXM2s7i7zy6JZAQ81ys+7rd80A/m9wwGcwClwlS+WNbVlIynkce4/rwTfAGm
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a29:b0:423:fcd6:5488 with SMTP id
 e9e14a558f8ab-430c5223fe8mr472889155ab.12.1761364503205; Fri, 24 Oct 2025
 20:55:03 -0700 (PDT)
Date: Fri, 24 Oct 2025 20:55:03 -0700
In-Reply-To: <68cb3c24.050a0220.50883.0029.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fc4a17.a70a0220.3bf6c6.01af.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_seek_pagecache_hole (3)
From: syzbot <syzbot+cb91f22d8a581fc19edf@syzkaller.appspotmail.com>
To: =syzbot@syzkaller.appspotmail.com, kartikey406@gmail.com, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ba53e2580000
start commit:   5aca7966d2a7 Merge tag 'perf-tools-fixes-for-v6.17-2025-09..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5b21423ca3f0a96
dashboard link: https://syzkaller.appspot.com/bug?extid=cb91f22d8a581fc19edf
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10052e42580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
