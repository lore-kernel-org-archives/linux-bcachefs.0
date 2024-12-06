Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213261D8E12
	for <linux-bcachefs@vger.kernel.org>; Fri,  6 Dec 2024 06:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733465464; cv=none; b=iOtDtUmcp8sciNz/7YJELA+qakvXDtIXKEHuqh3HP++3ehwV6jLqA46BltB9q1Z/NPtJmeHCwiviiwvYSiJ+0ekpv0gWdKBktN4jrJBCpLeBJMN1GKmBqVlU3+66xahecbUEdPDn4luRFyL8ySyidf/usFLkRajr0+6Mb7lOwAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733465464; c=relaxed/simple;
	bh=MBjj0dAZQ91LM+GKalVQvPREwDV2EQw40XbSGHtwPQo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=r5UPp7iXjQPmGXiaT01YeQtIyIVLkpx7n28nFsSc9EQSeyajR+27rX+XP+QOe+rXJ97M05j4mbfMwIA9ssw3f8wrfRcf5r7ktg3+A2dcAjdEX2ccdrv1Vf06Ogum67JJLBkdNiT3h4mNf3FUNsROQthBuXHxhn/tmgbFPQg33lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a78589df29so14510755ab.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 05 Dec 2024 22:11:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733465462; x=1734070262;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hynB85QWUaqXvuaUinrYxAjUZnOP2rZjkeD3Kjfiybk=;
        b=U+/2W6xSlMi7HRZ4kC/H80N4qdOBVQImvC42mEDC1oG/ttZ3Y4Cx6CNzwJvVcHdo7T
         eYKn/lUkBQKpoBwHpiwgEUzPcddzTJBAaBwYiYlr/BsJIOpxpdsoYl9220PV3nRi9el5
         8ltP6z8Cmfx42cnhCcFKFNqSYjYfl7SPH3tKV8iU7b17BStHdYt7uNMd+KuiqgzhvYJO
         nk7t8VuqX57t+f1PkSjest6Ig0E8rzUMlY9Gke8+T7rzNZufa8J5ZNuMeUzieAS09HTg
         rsP+XJTbNbcfcek4iTnuZPe28Am049fOeVrPUdJ4W9knrM9iL31W/GF/Hw4+4+U6VGxJ
         wZQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjbsILI4r4RVl0BiFGtCJd149ZLEgkVfNxKiIP2b6b0ubUIH2adzfbCd7eyaYOqVFbQYSWUSrhztZEa5dqCg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYC93kl2wYtyUyXo9sbeXDDDWib/qwbTcWcE9xVDaxhL43AHRP
	L2YCqopiBEIR3G4HQ1c8pkFosJhBah3RG7f0nKaZ5MWpACSphto5IOmiTIeDcw949vJUJy3stXj
	dqmxcHKWm2ZyM7zHROff1IBsMVB+7gIBUMsmmH1rVXjOcEd2t/aClFgo=
X-Google-Smtp-Source: AGHT+IGkrPW2Nt1unJm5MKaU2EXZuiH4r5vIyjQNPX7z78aZdvL2K0aGwDFUJKoapWNJTeWsv95bwsnVpEXu0I/cPxHbjdt2fbk8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1447:b0:3a7:635e:d365 with SMTP id
 e9e14a558f8ab-3a811dc1d84mr25280065ab.6.1733465462263; Thu, 05 Dec 2024
 22:11:02 -0800 (PST)
Date: Thu, 05 Dec 2024 22:11:02 -0800
In-Reply-To: <6751e9fb.050a0220.b4160.01e2.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67529576.050a0220.a30f1.0131.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in check_extent_overbig
From: syzbot <syzbot+fbc1f6040dd365cce0d8@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit bf4baaa087e2be0279991f1dbf9acaa7a4c9148c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 5 21:37:02 2024 +0000

    bcachefs: Fix lockdep splat in bch2_accounting_read

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1147e8df980000
start commit:   feffde684ac2 Merge tag 'for-6.13-rc1-tag' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1347e8df980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1547e8df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91c852e3d1d7c1a6
dashboard link: https://syzkaller.appspot.com/bug?extid=fbc1f6040dd365cce0d8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16804020580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ed1330580000

Reported-by: syzbot+fbc1f6040dd365cce0d8@syzkaller.appspotmail.com
Fixes: bf4baaa087e2 ("bcachefs: Fix lockdep splat in bch2_accounting_read")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
