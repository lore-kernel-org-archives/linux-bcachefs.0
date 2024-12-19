Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955A8221472
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Dec 2024 09:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734601508; cv=none; b=QRm+U5z11/5vzKa3hWr9zXP178FmHDmowwXbw+u6/2ElhG7pAV4J69pE6IYiX0gKPU5DrUg5wLj8v1OXcs45Fw34o0vEPyVsHJ/M/+4jtP1ISPPgYTyLpMGRXvUcLMv8O1YotEvt0KxIXlPPgZN9dIi8sb3JF+hq6Oi4y3+JW1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734601508; c=relaxed/simple;
	bh=zy+N/Un3QowHDOpKtXomr5vDa/TSb9QVhP7bTfil0ak=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Vz8aVkpZqgoGRbl2xbmQ5Jqk87VSGkjS1+Hjccy1oxBBEBvQt1PeDN7JgLuPEd6C1ZOgOHiX+RcnUXga1c1BCFtK491b6/ehlDqu7g/0/o0eivaDWHoO0s3ZlOY0/dB1a8l3yBlcXBYtq81ZSUGrM7QiIx9FGcPc1DAXxbFSs3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a91a13f63fso4966705ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Dec 2024 01:45:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734601505; x=1735206305;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WbNvaUjNt6urmtmdVNb6UbfmUAW+zIbHx3hi/xowHdg=;
        b=QImC9ZnJVm6qpjWK9Daw3OgGO47HmspeBKCrhUoWx+3SQbhADQ85+zt8NNdwRKnOo9
         8uN1rRNdLiFLL8Wu1TPmmRnIqRNNODDGqBQULLfAuGi3Va42Ke7GhVkocIe2jm6wGNbW
         a2hBOVnEjXQNQIgvGs47+OfihsyfOOnzu8sU2H8n6SgpAmKCpUdtZWf2Vs8tGWhQu/h6
         AFEhliF6wmp+WX7xH4GbHKBBdkHVDga+QBVbYY+j2BKU5qok80Gkb+ZUDnPjjfVi7wGp
         FuZWUNParQ76q5KMu6SIVPfjzze9+m3uL6FmLOC7ortTQyLEHJcyoAd1qONAx/Jk9yVu
         LKhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCbfnWkGGR/sNtu5MAARWSs+Ec+w1BC0Ztsgx2EP/uytFWODsCQ5i/hHtZ/7XcUxzj0InNLmyuFUsvXN/P4g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwunhK4ZsezLEFs8T4kpnj7JhJRFqheqcs9BdHJoWifISmNEa4s
	lWhC9x1GedWqNjxlTWAB6fcXtIuvEOpioZT/xmsAmIDg0xTwz+wwSQnG1a+zlBK16Nkpy9o/wYE
	9DZn09U068LgjB4B1mlA5J16y5XW+QA4jNzeppWKJMlLrzwkhak7yBic=
X-Google-Smtp-Source: AGHT+IH9qlQONexJmsXL0BdMoibF1h/5hqRw2Wf5MSV/I2iMc70W2JHkvLHPBBf9TQ5xZJoZWt1StSibZODqqHeOoNUmBK02kRum
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3dc9:b0:3a7:c5b1:a55f with SMTP id
 e9e14a558f8ab-3bdbb35827cmr56345605ab.0.1734601505694; Thu, 19 Dec 2024
 01:45:05 -0800 (PST)
Date: Thu, 19 Dec 2024 01:45:05 -0800
In-Reply-To: <675ff6b3.050a0220.37aaf.0125.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6763eb21.050a0220.15da49.000b.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in bkey_packed_valid
From: syzbot <syzbot+5970f72a85a751ab7556@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=130722df980000
start commit:   aef25be35d23 hexagon: Disable constant extender optimizati..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=108722df980000
console output: https://syzkaller.appspot.com/x/log.txt?x=170722df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=5970f72a85a751ab7556
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c06f44580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ba37e8580000

Reported-by: syzbot+5970f72a85a751ab7556@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
