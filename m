Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023AA1DF759
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Jul 2025 23:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751758324; cv=none; b=N3IVps1mv0uCdVPsgm49v0P/OEfToAUtn2Bh0ymW0qotPg7QDW1ypKaNyfGg93u4oFPwrrPSfO7DydqJksJEZCaJStlogrBxME3sYaz9F2ufYRs0LRGQZiBpIh2dkaRsAkfvyIx6++nD9+dS2KWEu1pqTa1i/W+BzB9RbbFDxlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751758324; c=relaxed/simple;
	bh=Em9yf18A68eCC8P9oxRjSvOyVdLPOXhh1D9CXnveERg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Jd5pG+Bc8Tdgf2vFS5Nkqm6nR5QA7FZIvsxlZCV7HKrYv/CBX9QGRg6u+KdZKDL4mW+0qJo6R8HOYKFDCsCN40yIre0gr8XjsX6MzVjt6lcGU4Oqiq8Air5Rgx5uGnoJP79ST68UW1OwfTTf6VdWrIwTQz1d2ZiJhXsGIMTDZ7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-87326a81ceaso248067239f.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 05 Jul 2025 16:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751758322; x=1752363122;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UVZ14MoJza4vU2EiVLINHt7Z8gTvw6jQpGGYiyy39sY=;
        b=Xrvkho7PsamEOMf2k8Sk5Y/8LA0+5NJjPi4oOT0lFo1ghx+BcPpzk04xM/oEJKl7pc
         leHUIrq/b6sXs1iD3ODHUANLX/Zw6N1mwoXaR7K4oHFNvOL4kvx1MehUzgK3R9cxGGzC
         vJtNMAepYbqydgmLLHu97yqaBuqCDI/SP9S+N6kJPKPWz26cD8ED/+hfobvEDM5sObQo
         2qCiqjniTrO8G/jV9xSh38fL39/LwojfGMVIYrNHjZ0KpNGFSsFxY0t0cnYY+gUHV9s6
         NK//XvVTgiUeYefLvqdMVFnG+g0y6SHjKhw66tLVCY+ZDe7aXNRH2sZp9JpAFPTu1NOX
         0h+g==
X-Forwarded-Encrypted: i=1; AJvYcCW2iQjUJOEPL7XX87MELdYtd8/8OYdCEQybJFCP18DF2A2TZNDW4GnA9pYuP4KiCHLc8/XqvtK82vKwLQWegg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyM3yZgZuaHs2OLsQbsUgYtPxen3JqJX5+aemtdKmRy3Ozvhsn
	LbIcqT5mPIqMglZiGk+LFy1ElNC9xLCLy9X9XL9QDXq5YBIEdT/zaDctrKGhjiS/YrSIBwTHSJI
	S7j6vwMGfOUR2qxZ6/vSC5Ea/mosuXdT4s3KPPtCyH1V6HY+/xOSWDQ+5fPk=
X-Google-Smtp-Source: AGHT+IGlmyTk8yAgnn2pPtO/Zu9wAZCxjMrgHMjacxEYVyRgm2IRPvdh7sAOC7olTGBj6HsnZDgEshZ4dkf1B+hJxy5tNNvT4dsb
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198d:b0:3dd:f1bb:c75a with SMTP id
 e9e14a558f8ab-3e13485a02emr61796395ab.8.1751758322137; Sat, 05 Jul 2025
 16:32:02 -0700 (PDT)
Date: Sat, 05 Jul 2025 16:32:02 -0700
In-Reply-To: <686611ef.a70a0220.5d25f.0833.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6869b5f2.a00a0220.c7b3.0050.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __btree_trans_update_by_path
From: syzbot <syzbot+8deb6ff4415db67a9f18@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 0803fa689bb9eb8d01867808b886a26e76ff1690
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Jun 26 23:52:42 2025 +0000

    bcachefs: -o fix_errors may now be used without -o fsck

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=161ca582580000
start commit:   50c8770a42fa Add linux-next specific files for 20250702
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=151ca582580000
console output: https://syzkaller.appspot.com/x/log.txt?x=111ca582580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d831c9dfe03f77ec
dashboard link: https://syzkaller.appspot.com/bug?extid=8deb6ff4415db67a9f18
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1311d3d4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1770f982580000

Reported-by: syzbot+8deb6ff4415db67a9f18@syzkaller.appspotmail.com
Fixes: 0803fa689bb9 ("bcachefs: -o fix_errors may now be used without -o fsck")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
