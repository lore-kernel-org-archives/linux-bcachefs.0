Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3764B1DE2AD
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Apr 2025 19:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916704; cv=none; b=GLXkqukT48hOAJ/TGpycunVK3mJZeVFd9DiaHaBLF07HBP8zpVra7h8U+yjj+ULp+yMzm+lsZPYT74kz3YWLqrX0ytKDdXRpRyRT2yfHfOFFafQwDGxGd33HpPdOcaSjYG9M4m2+nUvfJZtiXqTEmAHzSlVg3MdmFTS45PAZzYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916704; c=relaxed/simple;
	bh=Lp/x4hsyjk1lrQeZ1Kgo1pqlXATJ3hoYx3Qb6KavKlg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=p3E1xrf5RWT19sWePqlM4RSB1XCw9Ug89RvJ7XPu2iWwu/OZ7FREFac9I/azrVb+z9x3RwjkCYB+oq/SJlCdlj02uNKgkt+bqFbp29MTylFCiUQBnaOxgBZDnABqRejWiCyWS2VM9pDVMw5NV/vwAAvDjkh//ojudev2O8RxECA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d6c613bd79so12617275ab.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 17 Apr 2025 12:05:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744916702; x=1745521502;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KDqIhlkWTqThWDXFkLVbvNGoVB1KtUo6BHvjxJ84as0=;
        b=bflux2b7hN4JVJFeR70h8cAc1RamGXq4afEoSp+SUWDrAHyuFXPn+qpLu9S3v/K9ZB
         sK4v1q/90g6yYbU3uXUrIwsaEyydvLlPc/9eWgTboSvfu7fA0c7dAsdoYiDDD0ooey+i
         tXj+j+4Axf7erqV9aADX/wQuX+4hhXYdeNPsKHiHpk3kLjCfLzq+ZhNw8c0/TSBHTURE
         3n+j5uBTcaBaTz7rKfGfsHmeUh7CPmaxeIpy0nK4UYzgTnQbO34cFkQggN3lI6eDjU9/
         JZDAgspvz9XI22SKQzsN4cKUfRVFZStSG7idbg0WGxW21qIOOhdMl/I3jerS5TNicjSa
         LtWA==
X-Forwarded-Encrypted: i=1; AJvYcCWikGCNp9JmLXwYLcW2q/Jq9k0KpJjjDwEo6ghzPaGxb90oPny7GUsM9jDd1R6rRmYCY1SEJbmya/MOQRSQBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbDCrmCvGfzdfR94ED7e+obnYMkSshVkby4sQ003H9/GMMUnSe
	Lk6ROimL3/AlUg0I6ddwUAhiRFFxlyqDAgwuwEaU699HtZWHqMKveCn5/f51hbKC6qaTaa4Gs2i
	0Us3dKi4T6a+GepRuIwnMoWi0QSq8xRXabVmh2XscLdYMniZoJ4dVN0w=
X-Google-Smtp-Source: AGHT+IGMy3JS/eMvnnBxJwZNSXj4+Ok3tvc14TB9u694TsHVxHKohoNEk0XUuZ8ts04fZXTAk2+3+VT6CLq/z8y1+ILRfSTHA3Ub
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c0b:b0:3d8:2178:5c79 with SMTP id
 e9e14a558f8ab-3d88ed9561bmr3343255ab.7.1744916702351; Thu, 17 Apr 2025
 12:05:02 -0700 (PDT)
Date: Thu, 17 Apr 2025 12:05:02 -0700
In-Reply-To: <679ff200.050a0220.163cdc.0032.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <680150de.050a0220.297747.0000.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_node_iter_init
From: syzbot <syzbot+7b8a2c442d5a4859b680@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.cz, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 3a04334d6282d08fbdd6201e374db17d31927ba3
Author: Alan Huang <mmpgouride@gmail.com>
Date:   Fri Mar 7 16:58:27 2025 +0000

    bcachefs: Fix b->written overflow

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=125aba3f980000
start commit:   6537cfb395f3 Merge tag 'sound-6.14-rc4' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=6cc40dfe827ffb85
dashboard link: https://syzkaller.appspot.com/bug?extid=7b8a2c442d5a4859b680
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1055c7f8580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Fix b->written overflow

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
