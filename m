Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADA61684A8
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 04:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727409607; cv=none; b=RUONQQ1U7jvivzYFLnrVVCsgrVBclkAR+g/pAXsUV09+TrmmyW80Pc11SqjZw7Cnvqg5UADKnIPI347xON/a2RTf2dgNOxRI0dTx4jhcxIx/jdqblK0i9bCFTv8co1GFpU+XDMWBQSjxJphoLcD1A2xEHNbpKic/0iI6ePqr2/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727409607; c=relaxed/simple;
	bh=RYy8CyEWcBSdrHr/r+lzZm8SfWgstJs2rf1y0S3C5qU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=QsAn8Sn6rMVUcG+iVyB9c/9WSwqz++Xu68SyWZXVErUJomLZpiCyCXblzimb8uPor8ixBP0qyNVQK0SmFWehxCmekyYWSa9eOgK6Zv3MHdJy/c2Y1vD46ld6IG2kmtJ3+VSMho8UlzTz8Ge2ceDbQ1FmD1+krHbSHMNPLgAyHYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a1a6d8bb03so22583155ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 21:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727409605; x=1728014405;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HEAFg3AScnvZ001p+VbgHZ3C1WnEaWn3zSkKleAo5Fk=;
        b=PmeQQMZbkf4tZ6l3kmZsV5VvHqy2lbsZeVwJjgB9kvhxPn9xTy6+ZcuMsoHXCCf2g0
         R4bl9IwqpagkTlRWhi2Lvx+vJqBZ8QWOrqCfbpABggmx4h73StBHlM9OORJUccywIvNC
         SkXRfg7UBvCJohyYSE3BFl6bzcRuUAOpvlR10UBcwYg/C7NNnES4YQr/RPQbe+nHZk0n
         yFl48bY2W8bE01DHO1ep7d1WQbG95ArvRTZQ6uPlS2h/Q4e9THtXC4DbEunr8oCx9a6X
         FLA/K9SW3FT/7iIhFgjwDxC2J8p1OlsAeQ/lH/0/yy2+CoaZsVW4n+K5JdNbDfB5+ZM3
         e9DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoa5Z0bCMr1wdJyxJfxNLZNXv4y864uzTLwg6PW9hrTR88hnRX4rd+poKTGlu+er3V1akYdmRAQIA2sj998g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd9hLMXveYMe4f3RUmgITZU5EIjsqi01VvJ2bBiBNC8ecFAim2
	SeTae3RVwSfUP8uWwSmr5mZEYm+AAa7jkXfadcJ65p9Ua0DgQ2/RwyDtkWXMRwhGOLjAOATSzKR
	7cTK6E+yyp2sGQz+Ztc9ZpiL1syMOP23pj19eO3hlNyI64xDdlK3VpoA=
X-Google-Smtp-Source: AGHT+IEhQltlpxmQQfXE9prJplXAErwRePVQ8P3vB0aYsuhg6BUT+HwvO8Bdx8qPF8DrOCRSSXoJm6WnoZ5QEzgvzPUsvwGP+sU/
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a08:b0:3a0:92b1:ec3c with SMTP id
 e9e14a558f8ab-3a345161e57mr15643585ab.4.1727409605322; Thu, 26 Sep 2024
 21:00:05 -0700 (PDT)
Date: Thu, 26 Sep 2024 21:00:05 -0700
In-Reply-To: <ff3f13ee-2356-4731-8534-5813800f3757@126.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f62dc5.050a0220.46d20.000b.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_stripe_to_text
From: syzbot <syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	zhaomzhao@126.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
BUG: Bad rss-counter state

BUG: Bad rss-counter state mm:ffff8880121d0980 type:MM_SWAPENTS val:2


Tested on:

commit:         1ec6d097 Merge tag 's390-6.12-1' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=136e4507980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6265dd30e362bb47
dashboard link: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13564507980000

