Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035CD218D70
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Nov 2024 22:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017705; cv=none; b=sKCEenyYLucMcxjOePEZ/L3LUNW8cmGlhnMf2s6PjJMGOi86sLX4kmSejAdxqkhsAMqrtAN7suqvg+QIqaeXYnTT8jir2kgAxmvMJLDySYJUyd9l3SeQrtqdEauKn6DslsGRXTwqlXjl6iYNzYVrb3ZNzefSSj2ogN907LBgMb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017705; c=relaxed/simple;
	bh=Ck8FtwaaahcHdlfqlCHDFbpCs6WlWl/68pm3qng1nKY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=cuVp2n1OUG47h6SQOcetnJpY1ysuwfouZrxctPJo4Hj/ipfWBtm3p9sDPNvfpERNBLddwJLAY/I4eQyyIGYWPDbsqmFZ42VEZKwT/O+Ozeu/b958XJb6Xhm+UyZNlmJjnVtWh/2YgfdI0y0n5XeowoZNl1bgLEOOWMXhPtPONhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83abf9b6bfaso158135439f.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 07 Nov 2024 14:15:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731017703; x=1731622503;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=80lg74MIOgAgDmVT8cJ8GU2h+nNuXRom2bkxV8sK6uY=;
        b=SFufBMEQXEOgOrjPat3VCBHaEoD0GzLx113/bVHIJsAOX1GOcLmzegT+H2AUrv84v2
         YS2na8qlbyJMG93LZNtQrJs8vvtHaTH1seRqDh3hk8nqCmaRctQS1kdY3BzT1sROcubc
         Iz0HctafIrRvHR5ynaCl7b+D8VQbhrxTLyb5WrjPbTt44FFG2VGE/tUIkH+jb+wMgf30
         69xFURpJZdeq6iHFa6x2qkofh4X87KI42i9dypVJJ+wVb7SBMiFgahUBQG4n4L8SeXJX
         NPXh7xVuhbMCXJQ8riaWRSfMMx1fQfNPbOBDrHwHN6dlun8ky2eMwDS5Je0P+sTNqHQs
         8bOA==
X-Forwarded-Encrypted: i=1; AJvYcCWNQjQYJCLqD8WAT9s48L/3FYNFpSZrQvMKXtizljP4mM/fmcGMOd0eH2J9O2cJjCc1FgKuMWruPZd3Wj/uxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxucI7BuFxYwxip4B0JkzDt/zw4IwsT98toyHb87u0kO48n+dQ/
	vp66hWICnY8UOUe5e9w2tS6GkP2peIH6S2Z9EHKaCQAJjau1HYm/3/sIkYj2F647lmcwbjvRPqm
	csXk31K15RzIu0Ruh70iHQHN016277G3AJGAo0P5O+PU7Hia5EfonHug=
X-Google-Smtp-Source: AGHT+IGHveAvyf9VQNMuaUeANYUoqVyEiqCBjuig3ttka+FXKr64NKcDsnzYcYyNFpL0+xAUIVSp18csP2T4NcfLfgptxT73HWsI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1f03:b0:3a5:e532:799d with SMTP id
 e9e14a558f8ab-3a6f19e86dcmr9853475ab.3.1731017703225; Thu, 07 Nov 2024
 14:15:03 -0800 (PST)
Date: Thu, 07 Nov 2024 14:15:03 -0800
In-Reply-To: <671b3f3e.050a0220.2eb763.00d4.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672d3be7.050a0220.0db4.01af.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] general protection fault in bch2_btree_path_traverse_one
From: syzbot <syzbot+e22007d6acb9c87c2362@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit bf4baaa087e2be0279991f1dbf9acaa7a4c9148c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 5 21:37:02 2024 +0000

    bcachefs: Fix lockdep splat in bch2_accounting_read

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1102fd5f980000
start commit:   ff7afaeca1a1 Merge tag 'nfs-for-6.12-3' of git://git.linux..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1302fd5f980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1502fd5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=921b01cbfd887a9b
dashboard link: https://syzkaller.appspot.com/bug?extid=e22007d6acb9c87c2362
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d9ae30580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13003f40580000

Reported-by: syzbot+e22007d6acb9c87c2362@syzkaller.appspotmail.com
Fixes: bf4baaa087e2 ("bcachefs: Fix lockdep splat in bch2_accounting_read")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
