Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9351862
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Dec 2024 04:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735014785; cv=none; b=PbvoBo1cmXimvFG3BA3H2s1mwnnYlnGnU/2fQdKz3UbH7LwstXtJRcfZkxhs/0pH+TDm+a0H5yH24S6k/+O6NpwKlRC2TeYcuCw/hYRiNikivX6KodelqrcQDgriT7Bf4biwnCcrvxsXrDL7YheiFytIGrp78+XM7rJBFquAD8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735014785; c=relaxed/simple;
	bh=D3WGT1hTOb/+xXF3NKtoinpNdoj8OLS08yvcRyaP1HU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=GDt0LPJjnXafQLiJiyRRhEoHm3WWEmQopSKk32jibxZbrLB5OZzAAQqLnvilwSWw+rU0Liq1NW9JR0y4pxjsFIPvLPBY4VecdQiy1ArpiW3eGG7rLbiEJIeSPAxBGvUsLnW8XnvYsugC7WAV4gsN5T00zjSDYoqN8qiGg6LKuZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-849d26dd331so100353839f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Dec 2024 20:33:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735014783; x=1735619583;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=56DwQ+Xrpq47aH6wUSE5EKbR3a2epe605w7GKNmWpqM=;
        b=mMM+s4gtLwcHdP8ZCbMCnvWlUGmisehHPp+A+I4RuTo8n2BH9DoUHoPrhHOXM1tlq8
         Kh4ei3yy0A+YwWrtu9zlirrz3yLlHYhWhwb8iwdtPxHr6usNM+1PtzJwqHubaSuyWq0w
         DKvFiO6zD2LED3HFujM/xSVQQ2Sspe5/s4HWkU7/3G9k0vp6+ePJJ5Ruj/R3KQed15vk
         GutuQqiZmrxWthHit7QiG+037OuSlcfwOcsE/b5N5W2nWg2rwLE67iG338IaEQ03vK9G
         XW7rwhKij20jfW1GbP9D+Nrx0x3iw5Sbn8kPNt9odF5xvuzUzA2LPcqQBg088MdlWz2G
         yfoA==
X-Forwarded-Encrypted: i=1; AJvYcCXni3jF/CU/R/32J6qiHuyKuffvlobOXjIcs/Q9dyMl8qgw3F/9igIxFlomI4BN06/2v7YW/DHZda+NPz4Q2A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdo/lZMoTI9nlUmfCIt5vYwKEhqmfGaUov66bQOTdVDQxSU0+v
	4SM8smqf10Pxm4lsCA/pbxi63OLeNpUFocd/6Qydeqmxa9lXo7Mi0qv4aJXe3+Sj6iFlTRc+3N7
	LXQpknwfNOZzWXrnYsQ+0nohCKGo9xQtAgz2pE+qjaMql8o4kbTIhwEY=
X-Google-Smtp-Source: AGHT+IHMsAmOJ47N8kqyKOZdjPbDTzNyaNTIpn0WZ2biAK+nGH4kL6Oyb9oNaVH+iKKqZSEoLoUbR1lTC9AAPzu1Bfs+xnFTFJp3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:15d3:b0:83a:ac2a:922 with SMTP id
 ca18e2360f4ac-8499ec26c8cmr1058611839f.7.1735014782902; Mon, 23 Dec 2024
 20:33:02 -0800 (PST)
Date: Mon, 23 Dec 2024 20:33:02 -0800
In-Reply-To: <6766dfca.050a0220.25abdd.0130.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676a397e.050a0220.226966.004e.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_level_init (3)
From: syzbot <syzbot+5824b2660896028cfe7f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 2d02bfb01b2743da06748ba396ff7da4425488ef
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri Jan 5 19:17:57 2024 +0000

    bcachefs: improve validate_bset_keys()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11ffd4c4580000
start commit:   4bbf9020becb Linux 6.13-rc4
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13ffd4c4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15ffd4c4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c4096b0d467a682
dashboard link: https://syzkaller.appspot.com/bug?extid=5824b2660896028cfe7f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d5dfe8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=179d8adf980000

Reported-by: syzbot+5824b2660896028cfe7f@syzkaller.appspotmail.com
Fixes: 2d02bfb01b27 ("bcachefs: improve validate_bset_keys()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
