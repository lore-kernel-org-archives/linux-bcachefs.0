Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBD8A50
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Nov 2024 12:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730638265; cv=none; b=blVe+b7Hp4F3Ec/aS5FKoxzqbvvC2AqiPxUJKgclJEmjOUNHqePHt6+OnAsgncHNT3zVvy9zErcG3/PqW2reMq5bO5OgZL60qhRmIbnO163h5uqihxG5nPn/i7AriQXVGbh7pfkj9OTNrE8peYQjA6sVLabz62jBAujEh7dq5rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730638265; c=relaxed/simple;
	bh=piSZz+R1LDNqFSNj+rGYl92ubdi+Zin3YdppkW59UaE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nW4nCc+0kIak4qlqMeA4bN0jcuDS6ftC4LALRjOaTOCz5twodXVomgfuXZnFjwJh8IJuyB2Q+XGpNOgh/008LH2NJMTRL4w5I/LWwESrOhU+OFYzxR2e9kEiArtPRNGIcqUIGOhbW666iYhYHfL2iQaN4B5bpdUG+Q59eYwNxns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3da2d46b9so34967155ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 03 Nov 2024 04:51:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730638263; x=1731243063;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8sXV6nkrq6f/dVfYK9hV+cScjwRuISgxlc87bQs+qBg=;
        b=UDYAmIz7p6Le1xKHjVeQG0EfAYcJFAGMW4Rw9j6z2xiR5lSKlv5/i5QSubOe7ZlDwd
         4IbVHs1EJiRrnxr2nN/a+W3xh1J9GR1qTGlcAwtbDorQ81gFGo99Kx5eWmTuHng6YZVY
         U1KvUvZw69cPW7MK8CaFDhBmIEM8+DtWQOpydyJ0/7O95cCWBVOo5hwvd6IaHSfbvg96
         TqRGVMjAt4395djAatfEF6rw7+9116Bo67uS8lyMK5qhj8NwJi6oA1xWJPSaMTUlw9tD
         numj+hzudbFpo2GEm4OAuWjGp7wZ0Z6YNf9BH98TKugO+5r3NYqpZNUIEuJO1DIXHygT
         ycKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUipiaWvLjCG37/MFjwpgLg5yVz/tmBWplQ7qrbbuCySSOmW/sR+kNgj67figRoPA/YdePaTsC3cdbDkPzBw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrbQ/o9TDyN6YRZAfiM97KhEhCIwRncQQRRSiYfO2309TEWEhP
	F7Ute3KKBHTMatevJB6z5mtYXDYZcs5FMnKXUnYK/b4jELb3obIKO2xdDMtWabPwFUNXceFGa3v
	n48Utjl9uFqle/zNqy5z2meNzpnmUuGLEu5VuorbjxPXBi1Byeu1Tadg=
X-Google-Smtp-Source: AGHT+IGkx2KgTzybM+bFBWKiD5r1fwAdvmhysNfVCoSTb8wnFdVW8TYs63cylzjJ62wGzV5+o+fKXu1/RMQlNA3GUbARMg3gtKAe
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1528:b0:3a3:b593:83a4 with SMTP id
 e9e14a558f8ab-3a4ed295bb6mr270904355ab.14.1730638262900; Sun, 03 Nov 2024
 04:51:02 -0800 (PST)
Date: Sun, 03 Nov 2024 04:51:02 -0800
In-Reply-To: <6718dc39.050a0220.1e4b4d.0088.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672771b6.050a0220.3c8d68.0a4f.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_level_init (2)
From: syzbot <syzbot+eff0acb9087ee995577a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit bf4baaa087e2be0279991f1dbf9acaa7a4c9148c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 5 21:37:02 2024 +0000

    bcachefs: Fix lockdep splat in bch2_accounting_read

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16cd6b40580000
start commit:   3e5e6c9900c3 Merge tag 'nfsd-6.12-3' of git://git.kernel.o..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15cd6b40580000
console output: https://syzkaller.appspot.com/x/log.txt?x=11cd6b40580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f527353e21e067e8
dashboard link: https://syzkaller.appspot.com/bug?extid=eff0acb9087ee995577a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e5ab40580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1760e987980000

Reported-by: syzbot+eff0acb9087ee995577a@syzkaller.appspotmail.com
Fixes: bf4baaa087e2 ("bcachefs: Fix lockdep splat in bch2_accounting_read")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
