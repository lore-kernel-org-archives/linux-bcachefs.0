Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6A8268C7E
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Feb 2025 18:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739556682; cv=none; b=OhMeXGAKzgz+AoQjYVvfop6ovvJkPcmoihzZURfZXcU8n0HD4PA4EDNb8wY+vXFvjbj3d5DIRbbiXdGdjcIvJ7HNYkRGAF2mxDyDg6cvZXJBCuqcyC/tV1EUgVNai2myI0apSThHygLFDAIymzR+ANNBGt7qitpUlxkdx2kRRHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739556682; c=relaxed/simple;
	bh=wMTSRR3nLw+E5ph/idKPu0M3zjjn9ZloRQmQltBey8c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=P4XkVHoAz1RCPbkOXFusv0WjJD+FQcIHcAaD91jbTQcY83vQd6UDwnogmZl9yNaVnoaCtA/VD1txGf5EgaE18B2VYOP1w8cPzOCLkFzRuQwEx4mG2BI748lQXc7W4l4CY8r3hpL178Oc+MoHOlMf/lah87FdKNqO9yiRwS7C/5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-8556ab53713so297423939f.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Feb 2025 10:11:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739556680; x=1740161480;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OUNDXA5tzQyM8ahjKOdY1vF1qJ/6CjWQSKnc3bXlmWo=;
        b=qIAEDyP96CUGG4cRohjd0YKr+UenkQsVgViKi6AW1K4gZWHEl5I89gRrtVI+7dCmzX
         afWMuc0Cl3xvDY9blC/gIOmlPu6mH1U+PkcjaaXJQhFX+RpcxXGHbjmJeXc804CbAKie
         74dNwVhNqyDwxBmZJQMEkGkjk3aH2sAXjqOYqJOmqteiKZgPrkcM2zzgognD+v4uw2tf
         d4huHU9JFXAXkKw5MWCYMk2kQFtz9+0zm7WGHJoR9bla5g20f1ULW2VV1iNJ42OE1rT1
         8nimrYBJnzAL9scPqbdAHfN1RkCm86rGQ1QYdNh/jjQMf5hYyuyX6g96WQFskg7BN0y9
         vhAQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2+u5IxpX/HAd11aWIiYhO/9ZsOVQTjRFi9HXVrVarPXEIWrKcYfl6u6K+8BoL8+uQpydL4+jT/W/96z0ngg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLsaKjsZoQ/FzIBr5mJld/YaFjO6oBnUSsz10476pCo5Uw8r/J
	cqLh0TKrfZpltuZqrAicTW4nhoG7v21awxQSDx8UF3cm/AgdmOPSUtGJDtp1Up40m/dhocLY/i2
	AaL3G5zWVZmu0oLO5c0ECf5rAzNH8/p6asxam017mVjUsmcxvOQj+ujY=
X-Google-Smtp-Source: AGHT+IEGXMmhpIMcPBMXR3pV3ntpTw614J0LLbrDiT1df4YTP3Ugn9wIaZyPVGAZlQMx3KRo/pf0FS0DLEP2GzYAgFuG0Wrcc/ki
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1689:b0:3d0:21f0:98f3 with SMTP id
 e9e14a558f8ab-3d2809a9d26mr2839135ab.21.1739556679952; Fri, 14 Feb 2025
 10:11:19 -0800 (PST)
Date: Fri, 14 Feb 2025 10:11:19 -0800
In-Reply-To: <675d01e9.050a0220.37aaf.00be.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67af8747.050a0220.21dd3.004c.GAE@google.com>
Subject: Re: [syzbot] [mm?] [bcachefs?] WARNING in lock_list_lru_of_memcg
From: syzbot <syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chengming.zhou@linux.dev, hannes@cmpxchg.org, 
	kasong@tencent.com, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, ryncsn@gmail.com, 
	sashal@kernel.org, shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com, 
	willy@infradead.org, yuzhao@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=148019a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c776e555cfbdb82d
dashboard link: https://syzkaller.appspot.com/bug?extid=38a0cbd267eff2d286ff
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12328bf8580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-128c8f96.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a97f78ac821e/vmlinux-128c8f96.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f451cf16fc9f/bzImage-128c8f96.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a7da783f97cf/mount_3.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5459 at mm/list_lru.c:96 lock_list_lru_of_memcg+0x39e/0x4d0 mm/list_lru.c:96
Modules linked in:
CPU: 0 UID: 0 PID: 5459 Comm: syz-executor Not tainted 6.14.0-rc2-syzkaller-00185-g128c8f96eb86 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:lock_list_lru_of_memcg+0x39e/0x4d0 mm/list_lru.c:96
Code: e9 19 fe ff ff e8 72 f2 b5 ff 4c 8b 7c 24 08 45 84 f6 0f 84 40 ff ff ff e9 22 01 00 00 e8 5a f2 b5 ff eb 05 e8 53 f2 b5 ff 90 <0f> 0b 90 eb 97 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 71 fd ff ff 48
RSP: 0018:ffffc9000d70f3a0 EFLAGS: 00010293
RAX: ffffffff820bc50d RBX: 0000000000000000 RCX: ffff8880382d4880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8880351ac054 R08: ffffffff820bc49f R09: 1ffffffff2079b8e
R10: dffffc0000000000 R11: fffffbfff2079b8f R12: ffffffff820bc19e
R13: ffff88801ee9a798 R14: 0000000000000000 R15: ffff8880351ac000
FS:  000055557d70b500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff6826de40 CR3: 000000005680c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 list_lru_del+0x58/0x1f0 mm/list_lru.c:202
 list_lru_del_obj+0x17b/0x250 mm/list_lru.c:223
 d_lru_del fs/dcache.c:481 [inline]
 to_shrink_list+0x136/0x340 fs/dcache.c:904
 select_collect+0xce/0x1b0 fs/dcache.c:1472
 d_walk+0x1f5/0x750 fs/dcache.c:1295
 shrink_dcache_parent+0x144/0x3b0 fs/dcache.c:1527
 d_invalidate+0x11c/0x2d0 fs/dcache.c:1632
 proc_invalidate_siblings_dcache+0x3fb/0x6e0 fs/proc/inode.c:142
 release_task+0x168e/0x1830 kernel/exit.c:279
 wait_task_zombie kernel/exit.c:1249 [inline]
 wait_consider_task+0x1a14/0x2e60 kernel/exit.c:1476
 do_wait_thread kernel/exit.c:1539 [inline]
 __do_wait+0x1b0/0x850 kernel/exit.c:1657
 do_wait+0x1e9/0x550 kernel/exit.c:1691
 kernel_wait4+0x2a7/0x3e0 kernel/exit.c:1850
 __do_sys_wait4 kernel/exit.c:1878 [inline]
 __se_sys_wait4 kernel/exit.c:1874 [inline]
 __x64_sys_wait4+0x134/0x1e0 kernel/exit.c:1874
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f93f3983057
Code: 89 7c 24 10 48 89 4c 24 18 e8 45 1b 03 00 4c 8b 54 24 18 8b 54 24 14 41 89 c0 48 8b 74 24 08 8b 7c 24 10 b8 3d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 89 44 24 10 e8 95 1b 03 00 8b 44
RSP: 002b:00007fff6826e9b0 EFLAGS: 00000293 ORIG_RAX: 000000000000003d
RAX: ffffffffffffffda RBX: 0000000000000019 RCX: 00007f93f3983057
RDX: 0000000040000001 RSI: 00007fff6826ea1c RDI: 00000000ffffffff
RBP: 00007fff6826ea1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000001388
R13: 00000000000927c0 R14: 000000000002f011 R15: 00007fff6826ea70
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
