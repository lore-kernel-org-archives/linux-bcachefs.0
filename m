Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F02F229B1F
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Mar 2025 14:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741615510; cv=none; b=qPj1iMr7t9IprL0Qq+eiKpnACVDxWPGliJo8Z6OmlevBVFYA0zsRIBBjjlI4wXGfdMNq66V8sH01lgh41P/jMXNcyZVuSCX9J5fPWb6Z6WLe6gKT1/uHIfp1GSIyYyOkLO/IcboCeNp620dtqud0apJCyE66QUFzbJFAqCrI28E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741615510; c=relaxed/simple;
	bh=gXBrYCoCcrkWmsP7+K4nV7uUoW+IqEsQV3WmXOQ5P2A=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=C/lkdu3bZNpbZozyDLLTOshGF0KzITLqHKNZ80HfIJwHmlDb1qtaauxHVTCyAzuVw3hAb9lCs8EyO8SXir3gtLaHD8J4MTS5yoDpOQRcLbC6nku9+xKJU8iS97Usy1XGtvDMBnN1lEbaM+5ZQdlQCa4aK8Wc1ShiIQP+9L3ebTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d43621bb7eso38552525ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Mar 2025 07:05:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741615508; x=1742220308;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AaDrDkpXTwrG6aVIZuXOhK/+8GmMdBih6elTHPJ7xwo=;
        b=kUeRvDjxMcZb1gWO+R4yeiHuUcm/fXKzTiid6Ja8SFxE3m14ynhhanm3cIUxnYCEvw
         4t3YCuKYUJ6S3HFuUljlzWUJRMG5GAptzcvfLOQIDi/p/k/vlJBXDsSvpwbubE7zBt9b
         Nv4UrVlWbdN1l3witzczcLeKth4uwW32IVdPS1fSnONUiEtBKkL1ZP+Ds4mGrGY9Xtsh
         vKMk7DaVGBv5HW41XF2Ht1DzCk/CLUcMMKSWPMNn5gW2OdrNedyZGpXl3Ahj/ir7CfaU
         FtcKCQB56kE0Tp/Y5LQB/sApXPNcx4NKaeXJRpPogg3e7LMenVBYR1u5NJuxQZQWv7wx
         yn9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVrQLRObwrfhbd59mRuj0APgQKmqhB2uKC9wQFNxIFqEObkSQ3oX/g8fXpH2dqxu/B8DSKR4747HaZ8PTIk7w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7qPBsxNTGrHwkdggGpk87p9wHW6CPngn2lAikfHhPv7zoyIwb
	Ar6lYwzowLA3loQRE5v+J9hXYNXcs1ujRga6lMNGQ0IS21E5SknuZ9ac6ApszBuY3dwmNfW8DiI
	kfWFw3U5bnYOlEzyw9axlZ2+jrDFSBx+KYHi08vMBwQt0168n4a5K4Hc=
X-Google-Smtp-Source: AGHT+IFcfu7iZ9iAI/dbmeiES7ZqK7CGYDHtmKqtojBc/d+p7jhFfL9oM0l6REB/F23N9BxkhMQ6AEjSytGRFKCCgcKMcAdb5ta/
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3a85:b0:3d4:44:958a with SMTP id
 e9e14a558f8ab-3d44ae9eb36mr107656265ab.3.1741615507153; Mon, 10 Mar 2025
 07:05:07 -0700 (PDT)
Date: Mon, 10 Mar 2025 07:05:07 -0700
In-Reply-To: <6735aa91.050a0220.2a2fcc.0062.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67cef193.050a0220.3d01d1.0010.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __journal_res_get (2)
From: syzbot <syzbot+53bb24d476ef8368a7f0@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit fb8c835b18d48dac953a5d755a8e90b0d8fb9c29
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 12 02:50:48 2024 +0000

    bcachefs: bch2_journal_meta() takes ref on c->writes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1487d074580000
start commit:   bcde95ce32b6 Merge tag 'devicetree-fixes-for-6.13-1' of gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=53bb24d476ef8368a7f0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ff98c4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ff98c4580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: bch2_journal_meta() takes ref on c->writes

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
