Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABAC1E9B3D
	for <linux-bcachefs@vger.kernel.org>; Sun,  2 Nov 2025 22:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762121045; cv=none; b=E9ZeLp6VTri8AfbgeNxbLW73kK1YZqA4CG6WkXl6VA06qCvtaexkpkDmb+z/ZeeRxTA/7Ss/1dl9Q3zSDjhQV3DW81TJDFGq53ZZftBUx0nQOC3W1r4Vlqx6f7ihjFY3agqnihK+J9muKs/bZl+AuuLxMmDcARcrmy/9O76HCHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762121045; c=relaxed/simple;
	bh=AO+iFmYMA226N7iYyxx7Hp+iP+wh/OF1WZVixG/5Lys=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Y3wPCAkl7y/D1I9oUeX7o8peH6PAl+7/4wuQVtQzboOl37083znmoK49s4tm1AlOqfkeTIQpEo3JUNq0u/OdaTC04R+/Uz7jnh6SJZ56MesIGoEp7/mD9QOWe3lsmb9xGk31IgvCA/xAJwWderJQGGKLksCaD206N41vzoCJG4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4333035774fso3588595ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 02 Nov 2025 14:04:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762121043; x=1762725843;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CQVwdv4eWaYvaHTFkMJxPuK+gjott87AxWNHFjmTT5s=;
        b=bUOFmnpWi9xMtcleiouyvJY7MixTAfoXpNm4dvqa7gZtRlw+/6w0A1bRW3rSdcCoMr
         WIRPNgJFZNw/haBAjoMxFxElzNDlAEOGLmmr+Z53FctafujHmtn1vA47DvFNq2ZPtoyV
         i7Ew7jURwZqWP+n6alQWkjhe+Q5o/43WHWF7Fh39ak/sF2/Up5WBx3U3hjXJLmvgySNq
         gSQJHcebq56lTKn7je5/CZ+jXY41SrNly/jQJPWuBsj+YbiCMwDP4WUfgtqkG8RzHfW5
         l/zq6WUMxCQd99Dyk0furptdlSOzwe28Q3LLSKohGGAdEv0KHlTHa1uFbiUqkPcSq85a
         x3oQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWK2JZH6RTm0Gd/MUANbmDPnlFw1KvdiAr+XRQiXNeDdyAYqWNfRiniY56vNzAk1Xi45StJPnzQnmNaae4oA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJZLVWi3qJjyjiMXXOXCW9Y6gYDMljuHHCDqDw5IqrHD9IGMRv
	SxCKbs5CHKhGVTkbb+Y8jR8IztAUTE1YBXGEqA2R8IOSElUfk1l+P4mHp8EHWmNOmBNdgYdUzWM
	cLUEwNMfx83q0DrdDqMfLOiyM32KjnQhJZGlOkh/qfEHGCSX6c7ztLYovelM=
X-Google-Smtp-Source: AGHT+IEjXK0QkI+rrPxBrgxfc6cLoylG6k/U84Pa8d7z5Q4Vs/iJfDP8oHvMlgTOENA7qqiv7frDPv9TdDWWXhTgRyu05GFz52KI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2707:b0:433:2943:3a78 with SMTP id
 e9e14a558f8ab-43329433c4fmr37972075ab.31.1762121043382; Sun, 02 Nov 2025
 14:04:03 -0800 (PST)
Date: Sun, 02 Nov 2025 14:04:03 -0800
In-Reply-To: <68a7eee8.a00a0220.33401d.0167.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6907d553.050a0220.29fc44.002b.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_mark_pagecache_reserved
 (3)
From: syzbot <syzbot+baf59efef8862c9ba260@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1295a012580000
start commit:   8d561baae505 Merge tag 'x86_urgent_for_v6.17_rc2' of git:/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=98e114f4eb77e551
dashboard link: https://syzkaller.appspot.com/bug?extid=baf59efef8862c9ba260
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172f1ba2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a79234580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
