Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2200C3597E
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 Jan 2025 18:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736188027; cv=none; b=Arhbg8TSncHMZECCyMQyeNCPFD7Pa2dJbBaHRAr+EPrh6r2l7KhCJ+UFIDvjer+fFFwV9+LR46oLiRSNvElXmDDAD0Ro/LJDPhpYzI0T81EamvzCmODa4VYf4CkoAjowm0Clqei8uR7RlV8UQqvUXC2MLsDEPBzKilCnLlYT6Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736188027; c=relaxed/simple;
	bh=gGOLAwP1EZ0ZTRlAE43nGbdk3D6Bn52OdYPT9LGpmX0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=gNzIKT+On53hmylSsyeiXUfI1ZJeqli3bOMQulUcBP84WCVhM91S4rFPLjw1zLVVPe9g4h8FIALLfQdpGGM6UlcXmwePf2E2Y/x76kEJ5irqaVYBqeFgFIEhuwuRtZvXkvylZl/w6ft2Il601NSnXYcokkQnxvLH4l9mm8eYZ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a81754abb7so265211835ab.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 06 Jan 2025 10:27:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736188025; x=1736792825;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kir2/JWrpSNpLip4e6OfbuVl3hBRWtvlG0BNX/+ljgA=;
        b=sbkr+ddeyE6l4B/n2FEQvmyetL1FZOnPBYa9jLNiLg7LKqcgrCAWc85tyX5pEwMZpp
         e6WJnlptnWHl/TvM0P0OU++tP7cyhlxZ80dvGGkUwt7VY2GZttQaL74QJ6exgeqnMmt5
         Hh+AOVTxK4Gi4ndVcV9GnhJLSKRD9p9rw29SJFJlCWeii3CdtCPqklBv1TfbFafnt9Y6
         8/JM5t/hiCi4Bmwc3Yfx85vO0IMzsfPdLezKe46EszLTHPJBX9wBrUwRJm4BWL8l/B/1
         1q2agp5pfLdZWBgVSN7LOCutO5DHTXiLQNkz+kKr+4OT7FNIRcB1GOXZ7/On/ai3ktEg
         ZkUg==
X-Forwarded-Encrypted: i=1; AJvYcCUprM0rCd6G/BRZrrdwnI5QKqojAS9WMnaKdtrWUGKFP7+6MkmarSRzF95gzTcErgkbHVPHgjWc4MLnnESDVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRePzEs5DyLffJuCNQA/Vx+SiEjwRfrh2EkgsL9ok3El9lyQPv
	/fuyxngnWKeB83TkrxeBahgz2qxs6Enlc4Qg9ACq06DvdDjc/WJ+JJ2GfT5safNmmvnX906Dsl+
	G8Nqo2qWv/f6CUbaDp0oRhF2QhthXnSsgXKBqXf3Bb5yc7l74TnDYL9I=
X-Google-Smtp-Source: AGHT+IHopIVVaA93y2kP4vMQY0/8Wg41WrZbGIkG1bKaRIk3gWynhz6d+V9nMdThtxayZsNdKlyzsJJBRE2ep0zvNnCPkZMoMuYa
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20e4:b0:3a7:1f72:ad3c with SMTP id
 e9e14a558f8ab-3c2d514ff8cmr434222755ab.19.1736188025328; Mon, 06 Jan 2025
 10:27:05 -0800 (PST)
Date: Mon, 06 Jan 2025 10:27:05 -0800
In-Reply-To: <6717a66e.050a0220.10f4f4.0127.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677c2079.050a0220.a40f5.0012.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in __closure_sync_timeout
From: syzbot <syzbot+43d0c6eb00a26a41ec60@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit bcf77a05fb3d6210026483703bcacb22ed961c99
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri Nov 8 05:25:18 2024 +0000

    bcachefs: Fix hidden btree errors when reading roots

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13b69edf980000
start commit:   2d5404caa8c7 Linux 6.12-rc7
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=1503500c6f615d24
dashboard link: https://syzkaller.appspot.com/bug?extid=43d0c6eb00a26a41ec60
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153bd8c0580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Fix hidden btree errors when reading roots

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
