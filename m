Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC41731D72C
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Sep 2025 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757090347; cv=none; b=JFcxJ8N8XeLbaWERdmSDRF1kX6sQUkLi917gCclsoGqK97G27SzJppkJlges+ciiwMoKkpHtGS9WK319GhGJFsGkIfzKoA49k2lhoX1d4t8BdvUEziShmrk6X2uFo17BVlTzA4ibNMJHg4oINpjIjpAVVQaMPxG4s7LJ+JeZiaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757090347; c=relaxed/simple;
	bh=/FFeZI7QdUkhcuzbEYE5FKUgrVEK1ZE2ssX+lyyiL2Y=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NKBhb+sdp7vYMXxKadICPgyzed1AFXfofL6uzLyy9Gb2FMEGeZ9MrtYBi+s8uKKhpMDHKbUh8F5J6hvEAMp2X33rGnkzNtxvmSQhOp84pie6iRc3el4FtpzbkmJ7JlwIq/D08eoKbCDqsCBv0vDzhyG28h6FWzZTSgYGrJdyCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3f2b8187ec9so54280395ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 05 Sep 2025 09:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757090345; x=1757695145;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3xjY4OL/WtLFThU2GJmksldyVS+4jgC0MSLxl8k1vWc=;
        b=Nd8wQovDji4hGUU7B+dtZhSioRWqTt+CHxrMJCmgmDEJnnGu2weaFhwkbtQkZVgzXq
         2giEwBO+45P+cHPQ96Yo0/4xOvdscLpUIyzD+Ti2dA6eeHK74wU8N4WskYnBUdbxucqt
         zQCD8aHoAN8uUdRxRHKuCDAfATCHXcSFsEFC9x2cUZ+hEm7/MSaeJLkbc8xppW7HFn6D
         4/0zapCyWX0TZa06zhxXNVLddqiGnbPX8Dzj0BMRKdaDoCaLMlqz58cmuBvvj2yBskR+
         k3ADcUMSTgteNVOPKE+Suuu194UOL6kZzkd18HNGxzxsTJLbW6lxxggs2wQi2oZ9ahPl
         wuLA==
X-Forwarded-Encrypted: i=1; AJvYcCVA7qfareuZskShHPb02a0LGirVno/6sF7pcfwBS4kw4LeohUrYntUV16PdbqKF+HTN5QA29DyHwnAPPZEJBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2TvN2Emu4uWfZUfwEXew9o67ae25KTQx0mO5McHZebE1t2FFg
	xoeQTLpgy86Bp83tm/K6bDpHMoahMqgSASGrurl4ixUHUeGu8DHY1qpDszZ+ZgM2J+3VzJUfT73
	ESGKHiQXV4Q3t60dk/Ae5M49ZwrpLsYMhgkXItAFvOZf0m0uDV5ip8z1GQwA=
X-Google-Smtp-Source: AGHT+IGNstnM/s2sSf9/8RpanNHE1iJ0lbodvD0nHxbzVnhf3Kkd8ZCCBfzyCTWdxuDM9LneEO8NOl5MaeCmbg9emOy++9kyK7t7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4f:0:b0:3f9:8e24:4ca2 with SMTP id
 e9e14a558f8ab-3f98e246731mr26316375ab.22.1757090344926; Fri, 05 Sep 2025
 09:39:04 -0700 (PDT)
Date: Fri, 05 Sep 2025 09:39:04 -0700
In-Reply-To: <68bad556.a00a0220.eb3d.0013.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bb1228.050a0220.192772.0194.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_level_init (4)
From: syzbot <syzbot+55c84106264e92ea9ada@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit f11ca2ab18e369a662c2f60d53b8bea46c54e312
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Nov 28 03:29:54 2024 +0000

    bcachefs: Guard against backpointers to unknown btrees

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1663c962580000
start commit:   d69eb204c255 Merge tag 'net-6.17-rc5' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1563c962580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1163c962580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd9738e00c1bbfb4
dashboard link: https://syzkaller.appspot.com/bug?extid=55c84106264e92ea9ada
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1788c962580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b0887c580000

Reported-by: syzbot+55c84106264e92ea9ada@syzkaller.appspotmail.com
Fixes: f11ca2ab18e3 ("bcachefs: Guard against backpointers to unknown btrees")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
