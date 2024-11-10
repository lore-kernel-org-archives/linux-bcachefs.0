Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDD422615
	for <linux-bcachefs@vger.kernel.org>; Sun, 10 Nov 2024 06:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731219485; cv=none; b=q/eXs55j0lObSEN30XcJYAfHjaM2qyUxdEPvtfKKR5qU71ufKJTIRCv1zkrou5JmB4B0JlfP7F5CWGtIyC1BUEcAHrAHcQXAm1r4OpSGQbUZmH7laITKfLFQMZskWR/vbeW7CfbIc+WpXGYKk4wen+w7iDlBBTfCN0phPNMfVT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731219485; c=relaxed/simple;
	bh=KWOI66JQQP/ayOoVlGtWxSFXiH4FX1Q70Hu3L1EpNYI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=srAUg6aQaRIRnzAvOF2STuloXlRfgtDV+P/nBVhZbfcc9x3zEIOyWXypnUQ4mAKoWJB9UroaZnNjULMkyHsiHT9fWN4m5Dt29ZBVMb/jO+HtoNl6uqIx54ohgCB5ubKZ5+G6qEg4bGYCVMoz1XRGCL3xkIT4oDd8Bv8FlJ23C2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a6b37c6dd4so39260795ab.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 09 Nov 2024 22:18:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731219483; x=1731824283;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DmVSamYap7bWAl0AY12tAxA0maGZ1hHK0hufdhFGjLU=;
        b=w487hP5eW/oT3qW3Z56Enbq8ZtTjENiNcxAQ3vLVoRUrRlHONeRGrARYqV4ILDRrVF
         Al1q7pb/yTE9we4yMoElKPZOip+8K/iUmUVxTA9XeAzBK5ne5/PwsENhXMYQDwEn+0HW
         iC8Z51ZWp4/L2+YZ5pEK3r/Fn8Q5XS0IsCwmpkC4c7zYdRpk+JS3vY3LbLJAfC1rO78X
         aRuGzNLCh8Ihzh9WxqIBrZl+Puga/f8h/Dtnhzo4XIayxzDUxC2l3LXLuyq1UtIjxMjf
         kZWKvQ72IbvtiyIfCwkMpHqV/PhNIANHYgIqxBPKMHrcTY2nllzgVyF7B0XfT/IAax/y
         WeQg==
X-Forwarded-Encrypted: i=1; AJvYcCUwnUCNjXfXXkD4zhdhy/2ItnTSK3zeLo+wdx/QpAFnAQAq4a3cWdgVH4BVQWRITwxuI7BsYP4PZETSNmB8OA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTH3jS9vxOu7vzQrMgJPFsrn3GwhuGC5UH8eLfrXHGqLR3Z9eH
	JDpMTTilJhWf4pVR5y5LZv8erY1znJU9ElSlmd5p6W904yuqq6JgJT+Z6BIZ8KiidHsah9AWvRi
	3qY/+fVXDGtoSmXvr+Z1rQP1G68Dm82HhzWgzg7/DrTeZciWppoODc5A=
X-Google-Smtp-Source: AGHT+IHjupTuEsTnX+tP2nwlOkt6mS/4MismK/7jA277Jm3b9F3KvqXc5bFBzGMkCjIQZo/IV5YFEiPZzXIrjEfB3zVYUJNEF621
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:190e:b0:39b:330b:bb25 with SMTP id
 e9e14a558f8ab-3a6f19e2863mr89407075ab.12.1731219482905; Sat, 09 Nov 2024
 22:18:02 -0800 (PST)
Date: Sat, 09 Nov 2024 22:18:02 -0800
In-Reply-To: <CAHiZj8gWz_yvnv_euDoeBYOx7uPvG=F2S6F24oSSo3urFw8dKw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6730501a.050a0220.320e73.031e.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_copygc
From: syzbot <syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, surajsonawane0215@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KMSAN: uninit-value in bch2_copygc

=====================================================
BUG: KMSAN: uninit-value in rht_ptr_rcu include/linux/rhashtable.h:376 [inline]
BUG: KMSAN: uninit-value in __rhashtable_lookup include/linux/rhashtable.h:613 [inline]
BUG: KMSAN: uninit-value in rhashtable_lookup include/linux/rhashtable.h:652 [inline]
BUG: KMSAN: uninit-value in rhashtable_lookup_fast include/linux/rhashtable.h:678 [inline]
BUG: KMSAN: uninit-value in bucket_in_flight fs/bcachefs/movinggc.c:144 [inline]
BUG: KMSAN: uninit-value in bch2_copygc_get_buckets fs/bcachefs/movinggc.c:170 [inline]
BUG: KMSAN: uninit-value in bch2_copygc+0x1d3f/0x58f0 fs/bcachefs/movinggc.c:221
 rht_ptr_rcu include/linux/rhashtable.h:376 [inline]
 __rhashtable_lookup include/linux/rhashtable.h:613 [inline]
 rhashtable_lookup include/linux/rhashtable.h:652 [inline]
 rhashtable_lookup_fast include/linux/rhashtable.h:678 [inline]
 bucket_in_flight fs/bcachefs/movinggc.c:144 [inline]
 bch2_copygc_get_buckets fs/bcachefs/movinggc.c:170 [inline]
 bch2_copygc+0x1d3f/0x58f0 fs/bcachefs/movinggc.c:221
 bch2_copygc_thread+0x7f7/0xfa0 fs/bcachefs/movinggc.c:381
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Local variable b205.i created at:
 bch2_copygc_get_buckets fs/bcachefs/movinggc.c:170 [inline]
 bch2_copygc+0x15b3/0x58f0 fs/bcachefs/movinggc.c:221
 bch2_copygc_thread+0x7f7/0xfa0 fs/bcachefs/movinggc.c:381

CPU: 1 UID: 0 PID: 6677 Comm: bch-copygc/loop Not tainted 6.12.0-rc6-syzkaller-00279-gde2f378f2b77-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
=====================================================
Kernel panic - not syncing: kmsan.panic set ...
CPU: 1 UID: 0 PID: 6677 Comm: bch-copygc/loop Tainted: G    B              6.12.0-rc6-syzkaller-00279-gde2f378f2b77-dirty #0
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x216/0x2d0 lib/dump_stack.c:120
 dump_stack+0x1e/0x30 lib/dump_stack.c:129
 panic+0x4e2/0xcf0 kernel/panic.c:354
 kmsan_report+0x2c7/0x2d0 mm/kmsan/report.c:218
 __msan_warning+0x95/0x120 mm/kmsan/instrumentation.c:318
 rht_ptr_rcu include/linux/rhashtable.h:376 [inline]
 __rhashtable_lookup include/linux/rhashtable.h:613 [inline]
 rhashtable_lookup include/linux/rhashtable.h:652 [inline]
 rhashtable_lookup_fast include/linux/rhashtable.h:678 [inline]
 bucket_in_flight fs/bcachefs/movinggc.c:144 [inline]
 bch2_copygc_get_buckets fs/bcachefs/movinggc.c:170 [inline]
 bch2_copygc+0x1d3f/0x58f0 fs/bcachefs/movinggc.c:221
 bch2_copygc_thread+0x7f7/0xfa0 fs/bcachefs/movinggc.c:381
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


Tested on:

commit:         de2f378f Merge tag 'nfsd-6.12-4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1302635f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e4580d62ee1893a5
dashboard link: https://syzkaller.appspot.com/bug?extid=8689d10f1894eedf774d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14131ea7980000

