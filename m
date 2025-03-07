Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A8921ABD9
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 17:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741368484; cv=none; b=p9N1uGDZnZkSnBzl3Y8g86VflkDABL3OO0hZI9Z3En1Sx7b4kYPO79bjRresJS1tHSqeb4NlGrYJok+tznX8EErXdM9nU/FuUfEhfxCR8wE7blxYSuMy7rNYnTKEyR3tzvCh5nSAM5qoqObmMaBRTjNxeHbTTKY9/PUXvoW7LQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741368484; c=relaxed/simple;
	bh=upJQ5mjymofgpXkz41INvuAsthQFAND/YR305XX1Jlg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=RRziKK2uPolXHg5LB89RvstIi3ps0SqnwRy5BO/eZgWgrVXooOcuU95ADs7t45jfCfbs6syjA/PBz8dO8T1C4xHD2JtsN6xA1ldayxl+Z0sxDCoHnEj5LDEmRPEuCkaiP/fZmBi+6yfhG38dAWFkxzDLWUJhfadAZEhlmyeYi/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ce843b51c3so41632205ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Mar 2025 09:28:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741368481; x=1741973281;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KiVJKCgKzBlcHXwJoqOsA0A8HPvoZj8TKdObe42sP98=;
        b=jF47ouOyQdEHz4DQ/G4OfvrQtkeLDVLU4jQ/BOPnfdt5eyxXRXLKTjbh6w7NTCb9Jd
         8YW4F69yxAOvuV6ZsMn8RRdJVBdF10/pRR+OaQTfJdxNPYMWuSr6lBbduA7p4AcqHE6D
         n927McUfe9tGHITaPUYAnm8n7RwWfsf6WL+oYdTVrH8SwoFCl4UvSmkbJQRz9VuA+rMy
         UFvhC0ogVDXuK31TQmD+KzbXqDfHrcrk1r7IK3hqItc1ImH4fLffHbgl04sV9bcEQIdJ
         4G3eivHBIK852mLi6j6jrwsVWhuKFOP+erp71WpTAJwyI97oSQTpoVzOpfR9QJi+Q3vA
         2/lQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFUJ7KHHmdyaPJK2XX/u7PPnQ9WyOE0JO0k5SP54kCRJ0KhwPvVkWKpOzEOJwdRJL0SQbX4JIwPSzgupw/zQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YweBFyiQ/D/zSO2c1M3WtrOrQKlxEMy+p1exgQg1RwXCccZNPJn
	9PdqPyIER0Uh7lh6tZKV/84cvj3n4opRsNMc0LMsfOTiAnVCU/Kz4CnOIwzoIYeqJH4hYP+eSFe
	PvMaFTRXzD37nRZBS7VdsIgzX5Twxyrj4YFjqaeSSWzPQM1BsPQLgYOA=
X-Google-Smtp-Source: AGHT+IF6wDU9ZKWQ//+3hPY1GgjgX/QLT4u1UJyPfYraBrReiPZDYyOP7z+VuKE2DTqKQ1xfke8tVU6gVUM1gVkS9bmM3wzhvvJZ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180d:b0:3d4:3aba:954a with SMTP id
 e9e14a558f8ab-3d4419fef78mr57414785ab.15.1741368481737; Fri, 07 Mar 2025
 09:28:01 -0800 (PST)
Date: Fri, 07 Mar 2025 09:28:01 -0800
In-Reply-To: <67972800-CD21-4A3E-B4E5-0FDFD7B83D44@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67cb2ca1.050a0220.15b4b9.0084.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in __bch2_bkey_unpack_key
From: syzbot <syzbot+b9d9de2aa46b1bbe575a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in bch2_trans_put

------------[ cut here ]------------
btree trans held srcu lock (delaying memory reclaim) for 11 seconds
WARNING: CPU: 0 PID: 37 at fs/bcachefs/btree_iter.c:3202 check_srcu_held_too_long fs/bcachefs/btree_iter.c:3200 [inline]
WARNING: CPU: 0 PID: 37 at fs/bcachefs/btree_iter.c:3202 bch2_trans_put+0xe36/0x1020 fs/bcachefs/btree_iter.c:3457
Modules linked in:
CPU: 0 UID: 0 PID: 37 Comm: kworker/0:1H Not tainted 6.14.0-rc1-syzkaller-g47e4e14a59ec #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bcachefs_btree_io btree_node_write_work
RIP: 0010:check_srcu_held_too_long fs/bcachefs/btree_iter.c:3200 [inline]
RIP: 0010:bch2_trans_put+0xe36/0x1020 fs/bcachefs/btree_iter.c:3457
Code: 1c 24 48 c1 eb 02 48 b9 c3 f5 28 5c 8f c2 f5 28 48 89 d8 48 f7 e1 48 c1 ea 02 48 c7 c7 40 3f 72 8c 48 89 d6 e8 6b 71 32 fd 90 <0f> 0b 90 90 e9 63 f8 ff ff e8 fc a9 72 fd 90 0f 0b 90 e9 a6 f8 ff
RSP: 0018:ffffc90000587910 EFLAGS: 00010246
RAX: f68e1852cb63db00 RBX: 0000000000000121 RCX: ffff88801e220000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 00000000ffffce37 R08: ffffffff81817d12 R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: ffff88804f04c088
R13: 1ffff11009e09811 R14: ffff88804f04c042 R15: 1ffff11009e09808
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd96e77d538 CR3: 0000000012314000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 btree_node_write_work+0xa91/0xbb0 fs/bcachefs/btree_io.c:2098
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3317
 worker_thread+0x870/0xd30 kernel/workqueue.c:3398
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


Tested on:

commit:         47e4e14a bcachefs: Fix b->written overflow
git tree:       https://github.com/alanskind/bcachefs
console output: https://syzkaller.appspot.com/x/log.txt?x=16b843a8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a4389e017863e2
dashboard link: https://syzkaller.appspot.com/bug?extid=b9d9de2aa46b1bbe575a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
