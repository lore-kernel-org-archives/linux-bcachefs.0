Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2921F5E6
	for <linux-bcachefs@vger.kernel.org>; Sun,  5 Oct 2025 16:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759682885; cv=none; b=p+Cxj3TaUFfZCxJ5vb065AbDhTWxznB0MHkMSgTxM7cgwEnFSbVcZiBLSEjG2+GZFS2mhxl4YnMFRlCxtwOwpSbWSREKDMcHBhzXwq85Kf3jyAtsgO3UDCMvEwAQvrol3iNkRrGQlg5azLlICBiwZEmjw0EC/RlCvznAgnwJOeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759682885; c=relaxed/simple;
	bh=Sre91qC2hboHCxnN7N+ijsfJWRIunEMcehjobPut6dc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=EHnuiJRr7epBmGog0gTttcxOSHc6AYtY5MHO+apGpzyjSa/Aroy4HDsmeBWkfFI6v/Jkkt72zJ0mtSabQ3eaJ2OD6DIVDNgR9Wl04sUXKM4MtZbo2nC+6uX/9E/fxTWMGTKwZbsTkjc3Put8DWzqawndNSWX48K+aaOFXQvbINU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-930db3a16c0so977594839f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 Oct 2025 09:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759682882; x=1760287682;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8oXb7PF+VeA+usHOd3dH0gngexRPKDP4LVXG0n28u+o=;
        b=mzZ8LDMbajpR7JfrF2c2nEiPfAeFfPa3l2OXkzbZmL+vW0P+W5WrRH6W4MinzQpfI8
         C7kb2GytdYqXz5F4mKz9ezJarL57IuxZLRPHYxJYhSs4rybvuUNBTnCZ5og7SAWi5Z6A
         Ch7QsI12XakqQ/UPHU0u6+yIKQMnNCgUOKLQwRZcsM1p+jV4m7U4fwOQ2qtSgfKaaYNa
         3DkadE7Adisg4gmbhpci8addLl9AhZK8rc24tAHOQ1O3qykaCtJaDhtx66OUMmNDJpGY
         /xh5kJXAQ8Gs9HwWXSyDgGXm8GwnjEUCfRcvfCT+PkMqJAVuUYcDESDkBZEL/2Ti6h6s
         iZ+g==
X-Forwarded-Encrypted: i=1; AJvYcCX2uM4t/SJx9F0NGBgP7OuAq0oD2XTgzcylK6feTApR0dg2oo7JlYQWhri3txWw3hj3S4TgfAWkp1IMBxocdg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuhI9hOmraApj3r1/gBDHPdDLZ7GmBsFei4tsnW7Ktv097yJ4M
	urzC6z4L193gG31kSZ72jUg+pPZYP1q3D12/tZCsIovHS75BgYWEZBJC/yekkaji38YJaWsZB4+
	VRzcTye21ni8QX8fRA2kF8TukhWnyRf0KtAqflrWMf7qsQoD670fgUCYde00=
X-Google-Smtp-Source: AGHT+IEkCQ7HwtZExjkd+Qb0S8VnzVA/aRBL8f4/dZs9rBJbdo+yNWOfdu0Z6aWhrqDD2nC3xGGDlDmQTEMg1zstTjBzTHL4ivgo
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156f:b0:42e:70fd:f5a1 with SMTP id
 e9e14a558f8ab-42e7acfbb59mr158073015ab.3.1759682882528; Sun, 05 Oct 2025
 09:48:02 -0700 (PDT)
Date: Sun, 05 Oct 2025 09:48:02 -0700
In-Reply-To: <CANNWa05YhQ9Ycr13e3SOYgD=cms5iskSENUwXUgk0T8zkMy97Q@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e2a142.a00a0220.2ba410.0017.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_level_init (4)
From: syzbot <syzbot+55c84106264e92ea9ada@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssrane_b23@ee.vjti.ac.in, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+55c84106264e92ea9ada@syzkaller.appspotmail.com
Tested-by: syzbot+55c84106264e92ea9ada@syzkaller.appspotmail.com

Tested on:

commit:         6093a688 Merge tag 'char-misc-6.18-rc1' of git://git.k..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=16ea2458580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2b03b8b7809165e
dashboard link: https://syzkaller.appspot.com/bug?extid=55c84106264e92ea9ada
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
