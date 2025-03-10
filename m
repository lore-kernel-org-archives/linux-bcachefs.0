Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CA8F9CB
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Mar 2025 08:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594564; cv=none; b=Em+dWAoBZ1+Kp9MdArYjEi5+RaYoeJMiMhx0lBNPRCIrBKCSlp01fiZ4H4WMCHOaUcnrjmtyxTIs0qE7u9b2Q6RjdBscmCTCXO9BRihpUmJmGTPXORqQ5alFf53+7dCMXiV+uLKqA2/c89bLkoQ1fuz/H12g4j/sHCeNzUSHL3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594564; c=relaxed/simple;
	bh=JTF1lZEOEkNPM9MrYB2hrKVjp4XeMgvXRmaOZv8Jd8Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=agzwP4ZxLXNx6KsL0fYIQVNYWwDf7qgrE4zKCwqVi5R3TJUKPRB+yqd7O26Q0f7ZFd6hezHSDGQ0FeJxAods38CGaYOxObq5jSvbiGdWSdHe+Z88hj5f6JzAT86UqaHGw4BCEIxEHiXoHLqSPmq2zrJHwZcSE3aKKbFupFjQTEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-84cdae60616so329129439f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Mar 2025 01:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741594562; x=1742199362;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=22y5blgPG/7lHh8Yv1Qxh3X8BqbkqE0oG9zwwdSyRpc=;
        b=haqs2F1I6PiOCKlwKXOeKSCAtQqMEmP/FWUGX130JyomIQCL/do645Vq6+o/zkfPeJ
         ia1OhQJniDTvw0mLTC32le3oGyU/j/9wp0l7MP2V2uFfbAOK/KkZFc3l1jm7U0aV1/JJ
         s+fradV38Xm1nOuXkRAj64r/+1AyyjNNxxTBDzsat+zixUfcitsnw42NS8OPL1NbZ2+L
         ++cr/ABHotcq9gfSpAkGFTxm2j8T7Zqb2Wx0hhy+50AKeZVe3vxeoEwzAiDumQmdVZPG
         RuzjuTIadHxBdchc40KYZsDeVErjmweFU6wcpi00CWqPaxQcCMofCYGKhXQ3eGYrhzDz
         Wbow==
X-Forwarded-Encrypted: i=1; AJvYcCX4+PfOgVmk0M9TSenNwMVqVtaxVPHiVvwSWrV75mlB6r4r5Yr0TTSswjuFZ2vPPQA2L9bcSh/rNCpVep+khA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy83FI3Z0eZOTk2prZd37ODTki0dIxoiiiwQgNzHeWxHLGDHi3D
	Q9IJftbcG8algxO4noNa6eWG9Ye4/ZvpcKtu2nM2NVdZ52UduWpg8FiP2I6soJn4iDFfIw7e6hx
	9XkCmK9OPQYNhDIwr4ju16KuxjOhx9bEjp0WdACUeHcXkBoGTwo3n42w=
X-Google-Smtp-Source: AGHT+IFN0yQHYbThJi2b8lhndx403095CWT60RxPFOrDTXJSjATNNhBCFXSWA7A8o55d1zQEIdoDw1HchtFAFGxO9e6Nl+uQ3feh
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b07:b0:3d4:36da:19a9 with SMTP id
 e9e14a558f8ab-3d44196ffc2mr143152735ab.15.1741594562162; Mon, 10 Mar 2025
 01:16:02 -0700 (PDT)
Date: Mon, 10 Mar 2025 01:16:02 -0700
In-Reply-To: <67b1f949.050a0220.173698.000c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ce9fc2.050a0220.e1a89.01f2.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in get_partial_node (2)
From: syzbot <syzbot+725322cc4ff5c53abfac@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, axboe@kernel.dk, frederic@kernel.org, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 14152654805256d760315ec24e414363bfa19a06
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Nov 25 05:21:27 2024 +0000

    bcachefs: Bad btree roots are now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1688a7a8580000
start commit:   b7c90e3e717a Merge tag 'x86-urgent-2025-03-08' of git://gi..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1588a7a8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1188a7a8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=523d3ff8e053340a
dashboard link: https://syzkaller.appspot.com/bug?extid=725322cc4ff5c53abfac
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137c1fa0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12e0fa54580000

Reported-by: syzbot+725322cc4ff5c53abfac@syzkaller.appspotmail.com
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
