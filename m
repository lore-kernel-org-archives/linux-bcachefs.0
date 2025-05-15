Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CFB235347
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 May 2025 07:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747293211; cv=none; b=PmCMNYxjcqFySELf3o4lh+uFxr5tiiew9DDMgnnh2jgLKopYRykYLovBeo6rGe99pKRHARZgiP9APR1GxW8kB6xOkDsKGbz3icUsR1KWaI+zhu3mM2jDyvBOnFS0MSKxDKHCYa11Z7Oy2Tzw7UiYBnngz2zof8SAR/ZmsE31ePQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747293211; c=relaxed/simple;
	bh=4X3/N8Ul9GhA6qfiVWAVcFWniMB+FG66txQrDtVbadY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RHg1z6RIEUSFGHziz93ZU+n7jlBpylBGDj814mv74JyX2wAzFcdXbgZ2bxFj+FUVNDnRyBH4pkvxJXYxXHWebRRr9gVs9ADE+JU7pWlv1ViujaIt4E1KqjVazXtoIYhF23Dm/+4oPvYhgnLW++Y0kZxku9cXfUCasq5FRT1h83o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d6c613bd79so5720665ab.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 15 May 2025 00:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747293209; x=1747898009;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TthY6yORRV+VtmuQO3M9lxiRMH2UuN6eFEG2uEzomO4=;
        b=fuMfvfoBYt2rBfyo10LzQtu5ahfZZy/DQn+wCsUEWgh/gX12h7PjAtmNWGKxEdziMe
         8sBNIkPJB1wHmjXkpBiZKamCsxGysn7/YtfS3FvHTId6MgGHqA5iGJGU+4BRNwLHmNIc
         focC5puTptFFRM9Ecn3K+289Z5p28DIsEWsg4tOcM8c7+pIlQaRvuYvw0ROzet2hRe/+
         +MLvAQkzpqy8ZEKvw/k2rDgIKBaoh5MpWaTM/IYc0RiaE4FLxgJ19mijvr+bwE3QnHg/
         jHKJbzW/65owFPgIJyQ9R0xeHBDs1jB9gnVTllBHzPQDIDAbeUk8omjl0bn2dYFOx5Bs
         bXNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKxR+Obs907PaPYqMHeVDuelmmIXLZI+O/waXkFhpQBZVhYl8kDoJE99+vJaolk6+0fvF+3uHT+T1NNGrnlw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzTNepCcoiVTm/OWgysy7JzbXtml1cRCaF9AspYR6EdPA+DmjdA
	dD0vX4uGNmnRjRqT1ZcMup2VuyQnpwKQiAgy+X3ywwrcQneBdVBPZyV0CPAWMPHwoZT3HcSvCEO
	oecnOJQOUod+uIEwcYLgIVfRqds5EhFzZlZHtlJgGy+XByy2wqwZe6f8=
X-Google-Smtp-Source: AGHT+IE1cqJ2gNgid8HqCfIET195dsXoT9KmMWM6nY2n3EWKhopYjWuZ+Lwz1snCevCr0lxUmfVJ69JEdi4O4nvQW+b30yKSPR8Z
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cdaf:0:b0:3d0:47cf:869c with SMTP id
 e9e14a558f8ab-3db79688f45mr11325075ab.19.1747293208928; Thu, 15 May 2025
 00:13:28 -0700 (PDT)
Date: Thu, 15 May 2025 00:13:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68259418.050a0220.14a71a.0105.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in srcu_gp_start_if_needed
From: syzbot <syzbot+a08f8023365819890eae@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c32f8dc5aaf9 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=138c1cf4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea4635ffd6ad5b4a
dashboard link: https://syzkaller.appspot.com/bug?extid=a08f8023365819890eae
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1537d768580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b921498959d4/disk-c32f8dc5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/04e6ad946c4b/vmlinux-c32f8dc5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d4f0d8db50ee/Image-c32f8dc5.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/761fa2621022/mount_18.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a08f8023365819890eae@syzkaller.appspotmail.com

bcachefs (loop2): going read-write
bcachefs (loop2): marking 
bcachefs (loop2): marking superblocks
------------[ cut here ]------------
WARNING: CPU: 0 PID: 7109 at kernel/rcu/srcutree.c:1325 __srcu_read_unlock kernel/rcu/srcutree.c:-1 [inline]
WARNING: CPU: 0 PID: 7109 at kernel/rcu/srcutree.c:1325 __srcu_read_unlock_nmisafe include/linux/srcu.h:119 [inline]
WARNING: CPU: 0 PID: 7109 at kernel/rcu/srcutree.c:1325 srcu_gp_start_if_needed+0xeac/0x10d0 kernel/rcu/srcutree.c:1347
Modules linked in:
CPU: 0 UID: 0 PID: 7109 Comm: syz.2.84 Not tainted 6.15.0-rc5-syzkaller-gc32f8dc5aaf9 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : srcu_gp_start_if_needed+0xeac/0x10d0 kernel/rcu/srcutree.c:-1
lr : srcu_gp_start_if_needed+0x574/0x10d0 kernel/rcu/srcutree.c:1325
sp : ffff80009b646250
x29: ffff80009b6462e0 x28: fffffdffbf7750c0 x27: 00000000000000c0
x26: dfff800000000000 x25: fffffffffffffe77 x24: ffff0000ed1d5b88
x23: ffff0000c8961980 x22: 0000000000000000 x21: fffffffffffffe74
x20: ffff0000f9784250 x19: fffffdffbf775080 x18: 0000000000000000
x17: 0000000000000000 x16: ffff80008adb421c x15: ffff7000136c8c34
x14: 1ffff000136c8c34 x13: 0000000000000004 x12: ffffffffffffffff
x11: 0000000087094fda x10: 0000000000000003 x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff80008059d5f8 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff80008ae837c0
x2 : 0000000000000008 x1 : fffffffffffffe74 x0 : 0000000000000000
Call trace:
 __srcu_read_unlock kernel/rcu/srcutree.c:-1 [inline] (P)
 __srcu_read_unlock_nmisafe include/linux/srcu.h:119 [inline] (P)
 srcu_gp_start_if_needed+0xeac/0x10d0 kernel/rcu/srcutree.c:1347 (P)
 __call_srcu kernel/rcu/srcutree.c:1389 [inline]
 call_srcu+0xc8/0xe0 kernel/rcu/srcutree.c:1416
 __call_rcu+0x38/0x60 fs/bcachefs/rcu_pending.c:76
 __rcu_pending_enqueue fs/bcachefs/rcu_pending.c:497 [inline]
 rcu_pending_enqueue+0x70c/0x840 fs/bcachefs/rcu_pending.c:531
 bkey_cached_free+0xb8/0x1c4 fs/bcachefs/btree_key_cache.c:115
 bch2_btree_key_cache_drop+0x10c/0x5c8 fs/bcachefs/btree_key_cache.c:619
 bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:772 [inline]
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:844 [inline]
 __bch2_trans_commit+0x4ac8/0x62d0 fs/bcachefs/btree_trans_commit.c:1050
 bch2_trans_commit fs/bcachefs/btree_update.h:195 [inline]
 bch2_trans_mark_metadata_bucket+0x328/0xe14 fs/bcachefs/buckets.c:1052
 bch2_trans_mark_metadata_sectors fs/bcachefs/buckets.c:1069 [inline]
 __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1109 [inline]
 bch2_trans_mark_dev_sb+0x318/0x67c fs/bcachefs/buckets.c:1137
 bch2_trans_mark_dev_sbs_flags+0x6f4/0x754 fs/bcachefs/buckets.c:1147
 bch2_trans_mark_dev_sbs+0x24/0x34 fs/bcachefs/buckets.c:1159
 bch2_fs_initialize+0x8cc/0x10ac fs/bcachefs/recovery.c:1153
 bch2_fs_start+0x5a0/0x908 fs/bcachefs/super.c:1092
 bch2_fs_get_tree+0xa0c/0xf30 fs/bcachefs/fs.c:2570
 vfs_get_tree+0x90/0x28c fs/super.c:1759
 do_new_mount+0x228/0x814 fs/namespace.c:3884
 path_mount+0x5b4/0xde0 fs/namespace.c:4211
 do_mount fs/namespace.c:4224 [inline]
 __do_sys_mount fs/namespace.c:4435 [inline]
 __se_sys_mount fs/namespace.c:4412 [inline]
 __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4412
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
irq event stamp: 71278
hardirqs last  enabled at (71277): [<ffff800080c25df0>] kasan_quarantine_put+0x1a0/0x1c8 mm/kasan/quarantine.c:234
hardirqs last disabled at (71278): [<ffff8000829dbf38>] __rcu_pending_enqueue fs/bcachefs/rcu_pending.c:432 [inline]
hardirqs last disabled at (71278): [<ffff8000829dbf38>] rcu_pending_enqueue+0xc8/0x840 fs/bcachefs/rcu_pending.c:531
softirqs last  enabled at (71066): [<ffff8000803cbf1c>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (71066): [<ffff8000803cbf1c>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (70993): [<ffff800080020efc>] __do_softirq+0x14/0x20 kernel/softirq.c:613
---[ end trace 0000000000000000 ]---
bcachefs (loop2): initializing freespace
bcachefs (loop2): done initializing freespace
bcachefs (loop2): reading snapshots table
bcachefs (loop2): reading snapshots done
bcachefs (loop2): done starting filesystem


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
