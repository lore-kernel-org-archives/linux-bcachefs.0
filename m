Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED8213665A
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Dec 2024 07:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735284244; cv=none; b=cYY3UZS4oz4xrUAPf46lgTbSEjHlth+vevbBCJgl9SCf/7SW/AXje7GEcCw1LENqqE2bzcuTUPl3vSQxgwccfl9TjJnyJFCc8KcQ8FQ9PBBlNv/xTGPd1P1Rk60jASBY6Dp7s7GDGf83Rf7RLzxF1IyAOddhdVQm+swRpAuM4is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735284244; c=relaxed/simple;
	bh=kllnVHsz+lQZuxdQTxzx0EV8f1PHlRW7TVP/H89FzDk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tAaU3Gq65OXWo/DyedDK3MiF7OiBEdAfAkWnQQb2UNXPzCJhyG3Sq5otCbyErKvMaRSKbS5nPPVPs321nvj/3kJTsZoFaG1NiAKYFv26Lv8Fe64/jwvluMOaMCxeveU9AOQSIdrPtN3A62NJkcqixf+2QHnmcHx4VSDSwzTaG4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a9cc5c246bso64724845ab.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Dec 2024 23:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735284242; x=1735889042;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=duegXDTdihK6o7qV6vPHN4TznoI6Wx56i9s8tISzxC0=;
        b=ZxaxcqEeVyE4umoWt6baD9l1ehRQI3fjkBp2LJWT99AW9HnxyYk4EPdnaPcuqxwRsX
         7VUnBIRlHXR4oSxRqscpm8inJ3gRnuHfPahoAUss/fbAG+XQInHhunezee2Q5rTQKRU0
         6liILk3TiR/oQrzx0Ysmh1gwnTlmag92M3g7dQ/wSFOI7u1cSGgipnrMo9VsTJ++dnAG
         BCf2R3dOwbleL7TM0ALzNgOL3GzStz4CI3u5cwmuK46jrfzOdZcIBui5m6tRHTmEv7Gs
         Vkfd6GCSA9DepNbcVCx8vvR7WDBnjRIHrxbMm6rWBxUZrr4jpA9Rq88L+cGtdt7iwauU
         326w==
X-Forwarded-Encrypted: i=1; AJvYcCU0gBht3QWc1ifqOyqCWVqwwia8icOxU8u4BMJtVPrmnGbW5RYyriQfuDygQeH4ZBo+HKdhfrSnRCYtcYH65Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzksE/QMoXqNdg5bKwqhEriEvEVTZ0Zsnv2CtPz9PkKbt8X6UgN
	HDaHUN2G8QZMpLZoglz2uypOCYgj0iR9dRFsN9RjuEbcEzHCM1fxtwC1uxag2MIBa8rh3/KtfTe
	ka6FdB75yELA/ms+UX2OcwzlbZYCrUKzf6ouiCG+k3nwa8IJpOT5twL0=
X-Google-Smtp-Source: AGHT+IFFjnjAaB0K3Nq7Wh2z6Gfk3OGnhf38hMgCZCF3YlmoFo4A+ysrrE8pdKNTS4jyZA8q9js4UODYvSH2HRNRXBR0B67Y+L5G
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20ca:b0:3a7:8270:4050 with SMTP id
 e9e14a558f8ab-3c2d514fafdmr232544465ab.18.1735284242134; Thu, 26 Dec 2024
 23:24:02 -0800 (PST)
Date: Thu, 26 Dec 2024 23:24:02 -0800
In-Reply-To: <676cfb0b.050a0220.2f3838.042a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676e5612.050a0220.226966.0095.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bkey_unpack_pos (2)
From: syzbot <syzbot+c5e7a66b3b23ae65d44f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15093adf980000
start commit:   d6ef8b40d075 Merge tag 'sound-6.13-rc5' of git://git.kerne..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17093adf980000
console output: https://syzkaller.appspot.com/x/log.txt?x=13093adf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c4096b0d467a682
dashboard link: https://syzkaller.appspot.com/bug?extid=c5e7a66b3b23ae65d44f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1679a0b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127712f8580000

Reported-by: syzbot+c5e7a66b3b23ae65d44f@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
