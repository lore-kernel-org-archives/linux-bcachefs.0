Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC904204F
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 May 2024 10:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715424846; cv=none; b=pHmoBW5No6ALShgSDBMmON94HMojhzzN08vyxdru10D12q0JHqDVWqfll5+VhK4ii7vxmTH5IaWtMMH1yGjuEayLwHC413QUK9jqb2Qm+XKYQ17djiaqdj4ET3jEq41zA8rxtMivIpe1WsRxY3P/EbvptxpBT9H/R4kSb+Ws4qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715424846; c=relaxed/simple;
	bh=zb349U9QPT2D10/jxISpwmT3+Euyi+U2Pa4hgTHoEm4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Mv0u6Ncf3a/k7AI/dpq7MRi6+C7+Nc80I6kjW5UCkJMwUzYJnuWrzt8hdVlv6ByYxwTBZG3HXqs00oIcaMMFIzLzqyvM8Qv/Q5jJ4CtRxJXEVtn5kqWISp5Rwyt3yYbibbm6DClwjiAqoBwwKr3vQSia/OXetJWiVRpflVm3cA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7e17a8bed9eso259806339f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 11 May 2024 03:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715424844; x=1716029644;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KISKyqi/eiZaHE3ia0a9T8f1/amBnbC/bDbbjPBZ1os=;
        b=NjNBhOcAcGaTeIb9USS17lG3eeUR4zSI6ZCnhrCl015kzRe7Ue1K2QTLzf6qF0n8If
         PkPs/2DivjkKXLO7oskyZfp4kVK1TldqCDQpq+CHLqH1PwGiOmweLGEf++0coAhpb4pf
         TmX29GmJgK9w+ZXGG5AeKn4NRc2f71xmQzVgg+RG+9+f/soCJmJJfkpvOHuVYgV1l2IQ
         eyGQyCXvuC/iJuKia1IPqgiVvhqpskMNix51mN+v3AFbAAHKxmpPV3xqLpAWeO7R4Wi2
         HLb17dwiN186JiNu0nTU5/TAI3bzRWkIf0b8SBt4tXMorgPcReexPbk0DaRvQu/d1T94
         2M5A==
X-Forwarded-Encrypted: i=1; AJvYcCXNeasZE14FDsgHBGCZ57GnNuQlqw5hDKn5m7UUvk71r3lUDidwAP/cSkYd8pgT9jch83zmbCTtkSiXL3E/92niH3usfpzVEvFyGiyZOfk=
X-Gm-Message-State: AOJu0YzoP7VWOuxcaJc40DXaC+dPYj3wZk5Up7l9JPgtEp4HFvbNeZaL
	s+o+4niDHXJzvmQaVRuOVCP4OU8HIbhvw9oPlcItbspatuovjbXw9Gw/bUrWJ55D3o6FGnZpLLC
	8BmE7K0rwUhfJbkAcxPeO6Iv9e7oAQD5eg/UAv+sRBbZrQOE9E7oHkk4=
X-Google-Smtp-Source: AGHT+IEUc3VD15+b4Lcg217hTyTdseP2djSh0eM1/oo92Ok0Sb9LIay4074m/vXQoBrhF/WIlEnCr5yTBcR0TD2m6n0XUa+LSIjR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:608c:b0:7de:3f44:a6fe with SMTP id
 ca18e2360f4ac-7e1b519cfb4mr17149439f.1.1715424844008; Sat, 11 May 2024
 03:54:04 -0700 (PDT)
Date: Sat, 11 May 2024 03:54:03 -0700
In-Reply-To: <00000000000090ebe40618212a25@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000077652906182b783f@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_prt_printf
From: syzbot <syzbot+4e41a25632658c77b441@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit f39055220f6f98a180e3503fe05bbf9921c425c8
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon May 6 02:28:00 2024 +0000

    bcachefs: Add missing validation for superblock section clean

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17a16504980000
start commit:   75fa778d74b7 Add linux-next specific files for 20240510
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14616504980000
console output: https://syzkaller.appspot.com/x/log.txt?x=10616504980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccdd3ebd6715749a
dashboard link: https://syzkaller.appspot.com/bug?extid=4e41a25632658c77b441
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f5ec3f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126cdfc0980000

Reported-by: syzbot+4e41a25632658c77b441@syzkaller.appspotmail.com
Fixes: f39055220f6f ("bcachefs: Add missing validation for superblock section clean")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
