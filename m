Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B795919F12C
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 19:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727121571; cv=none; b=XR7YKj5c6oQdoHyhZYefimR3Rj5gW2c83ckKZyLBIfSsY8iP0sZUUPQ8TmanKLGkGdVTMmgXg0p16YSoFbeOU0cKpGWSIOTaMsEaamdYUoPqEBcB6XQ3Pa4gpQUJ0jhwe8zoMfqLN7Oewh9wjvtRoeXW4Vq7RmWFxtomCqIMgbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727121571; c=relaxed/simple;
	bh=iN8VZdNjVW7gVT3cZWqGRh51C5qiyPGE8ewySpWctYQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BP5ZhzllubZuzMXeo3iu3DMQFADK6QM1GkSdzVr6t2BBjcSS6l6+blXrZKiZuRFZcAsVPdsIBDdKObBHl6cuFolcwKbJ82moOdkOiYgaCDJh4O4jGWn5v2C2oQl+YG9ZaUu+fIWLtC53LmO3ha9FVBhZZtpMopXIdH+DSSQqpqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a0ce3a623eso25129145ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 12:59:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727121569; x=1727726369;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZjtxCZpUkQ/JcPtPTfReJPCZGsodfYvdyG2tK2qdgGc=;
        b=C560bsFyMbaiZg1fzRe+hXSwooZRiDm38N8u4TfD/LOS2xp19ScIWLwUKkBnitLdi5
         DrTpVD1XbHPqtKzpcQba6ydYGiRYt0cVTaGuqlL5O7sW3Edxbam8yoFzq81j3EzF4eE9
         gPLbcUPhxJzS3rqQS3m6iaOKyuzq5XQE9AgpALnonqNTgmNPk3FRXgRfdAu/r7y0WqnA
         HYbZ9Z0SxDS/sLbaViUdYSc0ZE3jJqO8JV14Ytg4ERt0R3KacKzeTEtUV/7gMylQmAtm
         TTkJ/elsfMwuSWedd+yiEOXQMZVUGVb9cpYZiOFHgyCLXXvZeQMR0MvNngLbtQGhk6Xv
         LHLA==
X-Forwarded-Encrypted: i=1; AJvYcCUDGe7meRni2pIpe7NxsgSVDeJ5vR9CtxURwFGHBzt/fH4ujYwHrKNuLi5NC5/9diKJXz6crCeTwWsstd0NMg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxO7PqQDO1bwVjZEvu9nHb+v1aUwiVsiv5wsYFUbENP8VvmiVSO
	XZdCuBJ0wKddW6WEPwS56hfxj6/5mFSCQ4KuySckpf16KL5TxI+u00+GfkKN93nw4+/im7uiIvf
	A/hkes3KJhF4R8VPNv68+ygWhccFSIvVs+yulrIPCRQsM2qzQVIcfyG0=
X-Google-Smtp-Source: AGHT+IH3niFCyAlqZrO6ZPINAS4zUN1ij2xXUIfLselfs42CuwAHSK7Ho/TD7+HciIsKL2T0Lc2sJcoMxZsqCKR59vL4w6eYmpqf
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1786:b0:3a0:985b:ddb4 with SMTP id
 e9e14a558f8ab-3a0c9cd0b18mr94273955ab.2.1727121568854; Mon, 23 Sep 2024
 12:59:28 -0700 (PDT)
Date: Mon, 23 Sep 2024 12:59:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f1c8a0.050a0220.c23dd.0016.GAE@google.com>
Subject: [syzbot] [bcachefs?] [mm?] INFO: task hung in bch2_read_iter
From: syzbot <syzbot+9f1acdfd9f63909c2abe@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0434dbe32053 Merge tag 'linux_kselftest-next-6.11-rc1' of ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1022e159980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b8bd5292e033239
dashboard link: https://syzkaller.appspot.com/bug?extid=9f1acdfd9f63909c2abe
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3766752b5090/disk-0434dbe3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e3608abc3f91/vmlinux-0434dbe3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c133560ad498/bzImage-0434dbe3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9f1acdfd9f63909c2abe@syzkaller.appspotmail.com

INFO: task syz.2.440:10220 blocked for more than 143 seconds.
      Not tainted 6.10.0-syzkaller-02711-g0434dbe32053 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.440       state:D stack:24336 pid:10220 tgid:10176 ppid:9432   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x17ae/0x4a10 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6621
 __bch2_two_state_lock+0x171/0x200 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:56 [inline]
 bch2_read_iter+0x2e4/0x1430 fs/bcachefs/fs-io-direct.c:207
 __kernel_read+0x532/0x9f0 fs/read_write.c:434
 integrity_kernel_read+0xb0/0x100 security/integrity/iint.c:28
 ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:480 [inline]
 ima_calc_file_shash security/integrity/ima/ima_crypto.c:511 [inline]
 ima_calc_file_hash+0xaef/0x1b30 security/integrity/ima/ima_crypto.c:568
 ima_collect_measurement+0x526/0xb20 security/integrity/ima/ima_api.c:293
 process_measurement+0x1357/0x1fb0 security/integrity/ima/ima_main.c:372
 ima_file_check+0xf2/0x170 security/integrity/ima/ima_main.c:572
 security_file_post_open+0x6d/0xa0 security/security.c:3008
 do_open fs/namei.c:3729 [inline]
 path_openat+0x2b91/0x3470 fs/namei.c:3886
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_open fs/open.c:1439 [inline]
 __se_sys_open fs/open.c:1435 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1435
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3e8bd75a19
RSP: 002b:00007f3e8cb35048 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f3e8bf04038 RCX: 00007f3e8bd75a19
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000200000c0
RBP: 00007f3e8bde4e49 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000006e R14: 00007f3e8bf04038 R15: 00007ffdb5607118
 </TASK>

Showing all locks held in the system:
2 locks held by kworker/u8:1/12:
 #0: ffff8880b953e718 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:560
 #1: ffff8880b9528948 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x441/0x770 kernel/sched/psi.c:989
1 lock held by khungtaskd/30:
 #0: ffffffff8e335fe0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:327 [inline]
 #0: ffffffff8e335fe0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:839 [inline]
 #0: ffffffff8e335fe0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6613
3 locks held by kworker/u8:4/62:
2 locks held by getty/4845:
 #0: ffff88802af9c0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f162f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6b5/0x1e10 drivers/tty/n_tty.c:2211
1 lock held by syz.2.440/10220:
 #0: ffff88802dca25b8 (&ima_iint_mutex_key[depth]){+.+.}-{3:3}, at: process_measurement+0x7ac/0x1fb0 security/integrity/ima/ima_main.c:269
3 locks held by syz.2.440/10221:
 #0: ffff888052178ac8 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x24e/0x310 fs/file.c:1191
 #1: ffff888023750420 (sb_writers#24){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2876 [inline]
 #1: ffff888023750420 (sb_writers#24){.+.+}-{0:0}, at: vfs_write+0x227/0xc90 fs/read_write.c:586
 #2: ffff888076fdf748 (&sb->s_type->i_mutex_key#30){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
 #2: ffff888076fdf748 (&sb->s_type->i_mutex_key#30){+.+.}-{3:3}, at: bch2_direct_write+0x243/0x3050 fs/bcachefs/fs-io-direct.c:598
2 locks held by bch-copygc/loop/10212:
1 lock held by syz-executor/10857:
 #0: ffffffff8e33b3b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:328 [inline]
 #0: ffffffff8e33b3b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:958
1 lock held by syz-executor/11676:
 #0: ffffffff8e33b3b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:296 [inline]
 #0: ffffffff8e33b3b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x381/0x830 kernel/rcu/tree_exp.h:958

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 30 Comm: khungtaskd Not tainted 6.10.0-syzkaller-02711-g0434dbe32053 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xfde/0x1020 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 10944 Comm: syz-executor Not tainted 6.10.0-syzkaller-02711-g0434dbe32053 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
RIP: 0010:check_preemption_disabled+0x4/0x120 lib/smp_processor_id.c:13
Code: 8c 48 c7 c6 80 62 1f 8c eb 1c 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 41 57 41 56 <41> 54 53 48 83 ec 10 65 48 8b 04 25 28 00 00 00 48 89 44 24 08 65
RSP: 0018:ffffc900046d7688 EFLAGS: 00000046
RAX: 0000000000000001 RBX: 0000000000000001 RCX: ffff88802885da00
RDX: ffff88802885da00 RSI: ffffffff8bcadaa0 RDI: ffffffff8c1f62a0
RBP: 0000000000000001 R08: ffffffff81d9769c R09: 1ffff92000226010
R10: dffffc0000000000 R11: fffff52000226011 R12: 0000000000000046
R13: ffff88802885da00 R14: 00000000ffffffff R15: ffffffff8e40b5d8
FS:  000055558fbb3500(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4317ad2c78 CR3: 000000002ea96000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 lockdep_recursion_finish kernel/locking/lockdep.c:466 [inline]
 lock_is_held_type+0x101/0x190 kernel/locking/lockdep.c:5825
 lock_is_held include/linux/lockdep.h:231 [inline]
 pcpu_reintegrate_chunk mm/percpu.c:580 [inline]
 pcpu_alloc_noprof+0x816/0x16e0 mm/percpu.c:1836
 xt_percpu_counter_alloc+0x150/0x1f0 net/netfilter/x_tables.c:1931
 find_check_entry net/ipv4/netfilter/ip_tables.c:526 [inline]
 translate_table+0x12ec/0x2260 net/ipv4/netfilter/ip_tables.c:716
 do_replace net/ipv4/netfilter/ip_tables.c:1137 [inline]
 do_ipt_set_ctl+0xe3d/0x1250 net/ipv4/netfilter/ip_tables.c:1635
 nf_setsockopt+0x295/0x2c0 net/netfilter/nf_sockopt.c:101
 do_sock_setsockopt+0x3af/0x720 net/socket.c:2324
 __sys_setsockopt+0x1ae/0x250 net/socket.c:2347
 __do_sys_setsockopt net/socket.c:2356 [inline]
 __se_sys_setsockopt net/socket.c:2353 [inline]
 __x64_sys_setsockopt+0xb5/0xd0 net/socket.c:2353
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f431797780a
Code: ff ff ff c3 0f 1f 40 00 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 c7 c2 a8 ff ff ff f7
RSP: 002b:00007ffc9e46ff28 EFLAGS: 00000202 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007ffc9e46ffb0 RCX: 00007f431797780a
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000408 R09: 00007ffc9e470367
R10: 00007f4317ad2c20 R11: 0000000000000202 R12: 00007f4317ad2bc0
R13: 00007ffc9e46ff4c R14: 0000000000000000 R15: 00007f4317ad4000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
