Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43EF10A3E
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Jun 2025 01:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750470604; cv=none; b=WWE4nzF9q3axd4m25UnWdx114inC3VhSTumsYHXEf+XofFSmq9izTJT8GCIstWJbfw0Qu38i/UfhxnQQepSF6m7RS7zEA6smTb8zirF50/n/eFSjCFllK6d03PzeYqqTGVeEXNtK5+T4bNaSzfTCnstL4D5mOpZrk84JG6GCaOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750470604; c=relaxed/simple;
	bh=/sxYexQ+58dkjFennMReNmcOGzMTMGYGFx6L+JikHA8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=hZBgw6PlA6GKQz6oso/qj/LgJVsDh4+x0mAng5dUmiSaw1iIcZUulLcgpmcyFaSUcnD26keqHMQm1DPD1jWwN7jxzJSfso8oP9aAHAeFF/G2bGGNi+D9Nf866Otu/gm37jJ00WHLXDThdNR41angBs9uvg9FoLCYPan7Zx8/d+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ddc0a6d4bdso27623615ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 20 Jun 2025 18:50:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750470602; x=1751075402;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vRMMmdlDx1Nx9RYKLwiUmguyu2r/kk1t9Vx+YhjJB+M=;
        b=YBbS/8lc5IdpEAk3bLjbsg5NZZpvpaGeUfUV4qBUzSKd9xSGBSvqYznwSaBmauznoI
         rsLkLuQlO3sHZpZIbhStmTfMxbu/9QJelOdo7Z8jLN5n7ujJKwqRvLQK76pBI3ScKyYr
         wqjn1ceA+Y7wEGEDEdaPSOF//ZZqHyT9nxaHCgfj9fG9l89pPCWbGLE6hEzi9VRUuXng
         KfxqDLCXI0CXEi4teBsubiYVNK13tOR3n/Is+zjavHvJLa7U45Gg+Vc0A6rc9j2mF34R
         Vvk95Kqv15ZBPmK3D3nTSSN7GExx2/kwfWgx5TGY0fAZJNrpLLDAvZcZTIHdc9niQxHa
         MUdw==
X-Forwarded-Encrypted: i=1; AJvYcCXc3/0sxkiIHdA6XmzWEoAo6wC7B5SEYG7l53gjnrmrtrZbrEXWA+7QtqTiQ2+tm4iZDgkDkICtKHPMv4h5Ww==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLZ/ssrvEY1ae6vEfnhk5FBpZxaHB4Pp9bT8I04EIuNqKlpC+A
	s63AJZAymsqkFIPt/ciixSIWqLzQrYZgoseM2bYVu8pv8yBa3+xgS0FjSdGH5TPJAVMTWEO5kYk
	Sw87r+oIEkJjj3a1rN5GsZrqtbqFkPRsbEBc2W61JTpoy3BrN8vbS/cp83JY=
X-Google-Smtp-Source: AGHT+IExPTz/TzN6V5eviaV1lQBhH7Own0NZuZKCXjy5BaTddYMoA6CTovIN3EB34VgXECbEagv9d7pAY+IIwZ1r77ZGiUVH9TkR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1749:b0:3dc:90fc:282d with SMTP id
 e9e14a558f8ab-3de38cb1f1amr54420815ab.16.1750470601859; Fri, 20 Jun 2025
 18:50:01 -0700 (PDT)
Date: Fri, 20 Jun 2025 18:50:01 -0700
In-Reply-To: <675cb812.050a0220.37aaf.00b6.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68560fc9.a00a0220.137b3.005c.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_page_fault
From: syzbot <syzbot+32415e0466b02533303c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 8b1f46bff38f075b8d4071e7ac1edecb441fd53c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun Dec 29 00:57:04 2024 +0000

    bcachefs: Dropped superblock write is no longer a fatal error

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=140d530c580000
start commit:   9afe652958c3 Merge tag 'x86_urgent_for_6.16-rc3' of git://..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=160d530c580000
console output: https://syzkaller.appspot.com/x/log.txt?x=120d530c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a237c32900fc479
dashboard link: https://syzkaller.appspot.com/bug?extid=32415e0466b02533303c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130d790c580000

Reported-by: syzbot+32415e0466b02533303c@syzkaller.appspotmail.com
Fixes: 8b1f46bff38f ("bcachefs: Dropped superblock write is no longer a fatal error")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
