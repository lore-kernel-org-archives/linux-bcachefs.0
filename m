Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECDDC8CE;
	Sun,  6 Apr 2025 18:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743963133; cv=none; b=GeQDRu+n6ffqheLpBhZ3fuf9HHLhO/v+0MCfI86OSP/Lz0ZC2Kd7prWZo/8+yLylTB5fWp+uiWBhnFr6GKuwg+RCRBk/fiNXV6NTVvrGbqXj/WYhjRz+GjOZpdM1Ocj5SsPoCXcOxv/uHJqyGGjaTzupf8gHF6qEQScu0igwjLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743963133; c=relaxed/simple;
	bh=tvV2oRM/rS6bVFrXnLMjh6B5ciDVVHSlXYorfr6JHVo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=J5tNdnlpLK0w8NmpzhcU+Py6GSfZjgmBcx/1O2QMGLOKtI+xo0Ow0sjjWeh/IXyXUdjzsRW05shZXCeb/nkfJQHrIPMWTrQW3oNQknyWAu837ZdQpYMLRpxCmBTkZIQmEhYruhW8LV2TSC57vwA7ZlkWG1/2HECqV22L2baOycs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mtDX/uct; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mtDX/uct"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-736e52948ebso4106573b3a.1;
        Sun, 06 Apr 2025 11:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743963130; x=1744567930; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZzD9YjEtiBZ22iWV0MViGv+GznTup5SZN76xmbZXoo=;
        b=mtDX/uct8sr0gqnmYggdzkmSPx8TP2LGibuxRP1jtiqS8JuNVOive5uukjIsb/K7W3
         FxX0jTMFZlA3sAe407QinpIsjrxceSpukLbjekmjlsJGbUR+4Z6HS+4IFOJU7PIy4ys8
         BpkK4C3rUIPyF+a63GYxPk4SewzC8kwSMolAUGc3sjuzWQUdzDRcy1dA0W3uC8BBmCAf
         4buW+MYDMQWMSuMGPOFCP53WNtzvVZe+hBt3452sZLVlgs9ho8ruubsaKBF+a4fgpYyh
         J57RhT8hiSHy150mvNuf8u+5I+DVLrS994huFrj4yLjbVH6D/o9hq3ZU1fheqRTRkdhu
         tWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743963130; x=1744567930;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZzD9YjEtiBZ22iWV0MViGv+GznTup5SZN76xmbZXoo=;
        b=IhzBpWGQEBKdhEDiDqfJ+6cLFW9Y55n+Imis++B8E4komqwarzQQx/Ku2gY+8zGVeM
         DU9O/dJBgWMa0Hw1KfaLJXhyOsd+oEOFGHbdn8GfnLXyhNPG8I/w3d9f34SLt9gmPll5
         JPf8MfbgQhANqxt+aKeIygeor6xDsAb7HqhebrDXQVLEK7euvA07Y7U72gEzknA6xryd
         NwBHZbpqUlwrSmSLDVMeH/30kiB18w8qiA+3qfpSHWu+hAiLIsWnRv7cQKWnjA/spJ7a
         Baf24aBsIXrTbsAWU0iuZ+GeUmoMf189ABINeUjISElRxFR8gjq3iVSJVqF/Mon4R+/f
         iZMw==
X-Forwarded-Encrypted: i=1; AJvYcCXeXIU5LL6bfppGw+pkgQBybGb+iOkPS6AUu0etiFgcwZsBujLnnkTTQ4XkFUbV4CICJ33KvF9QgJ1YcmUx@vger.kernel.org, AJvYcCXnYsvbo3pVx6LH9mJhjkVndYM1RzgtvLx8zbLA09nTFq8pnWEfr9BsSJR9cSctaM8YMSLCWbrl/OIA0+8ZPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzeHgMuZmseUk57yPh6zNQN280AS21D4WOiAIsd4HUGurxv1oDS
	VCR2ixbYXQW4jLOppbip9k4/SJpdSTgYnAfo8A343R9WbP/eYx/MimVRhH7E
X-Gm-Gg: ASbGncsnwmM7pd8aj2PRRYmz1dsIuT1dSyoCOGoBdsJbWy9gOBn4ifHYo8h1orzpXJz
	WaHL2fExGPKmsoqkCautYfFlefnDv/oGbJswNI9OwIAxSMB/fJNDowL3TtIlVBGZQQv8N2TC93+
	UyttomWvJK3GF0QDFeBFAstqk1KFNXaDIGQwTEuabMhDbqdmAACk5YKRjWlDAFqj5mzW4HYOmHA
	ea3ScJx8eliAbWMZxfQRD0Jzvr/+zABfBlMhBd0HWxBa4R0wMid04unspbfDNkZXOnCQhuCHP+7
	I0dx5Lke4+AAQpeHpAQv522QCeuPgs9U29NCU/I=
X-Google-Smtp-Source: AGHT+IHJe5kffPlPA1sJdwCoo/UI2WoQtQ5FkUMwtSKUFpfYyaohh/eFju8J+oC3RdSKa4/nE03xag==
X-Received: by 2002:a05:6a20:9d8e:b0:1f3:4661:d19e with SMTP id adf61e73a8af0-20107ea69a6mr14864344637.9.1743963130567;
        Sun, 06 Apr 2025 11:12:10 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af9bc3fd405sm5854696a12.60.2025.04.06.11.12.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Apr 2025 11:12:10 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_fs_read_only_work
 (2)
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <67f2bf20.050a0220.0a13.0270.GAE@google.com>
Date: Mon, 7 Apr 2025 02:11:54 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <777BAF56-3BB9-4602-806D-7EF157183BA5@gmail.com>
References: <67f2bf20.050a0220.0a13.0270.GAE@google.com>
To: syzbot <syzbot+674ccd0645d379ed5f80@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Apr 7, 2025, at 01:51, syzbot =
<syzbot+674ccd0645d379ed5f80@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    a2392f333575 drm/panthor: Clean up FW version =
information ..
> git tree:       =
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git =
for-kernelci
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D17077c3f980000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D8cceedf2e27e877d
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D674ccd0645d379ed5f80
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> userspace arch: arm64
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D10fd894c580000
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/7df8ceab3279/disk-a2392f33.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/42c5af403371/vmlinux-a2392f33=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/73599b849e20/Image-a2392f33.g=
z.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/fd7871ac7900/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+674ccd0645d379ed5f80@syzkaller.appspotmail.com
>=20
> INFO: task kworker/1:4:6586 blocked for more than 143 seconds.
>      Not tainted 6.14.0-rc7-syzkaller-ga2392f333575 #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
> task:kworker/1:4     state:D stack:0     pid:6586  tgid:6586  ppid:2   =
   task_flags:0x4208060 flags:0x00000008
> Workqueue: events_long bch2_fs_read_only_work
> Call trace:
> __switch_to+0x414/0x788 arch/arm64/kernel/process.c:701 (T)
> context_switch kernel/sched/core.c:5378 [inline]
> __schedule+0x1360/0x257c kernel/sched/core.c:6765
> __schedule_loop kernel/sched/core.c:6842 [inline]
> schedule+0xbc/0x238 kernel/sched/core.c:6857
> schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6914
> rwsem_down_write_slowpath+0xd10/0x14c8 kernel/locking/rwsem.c:1176
> __down_write_common kernel/locking/rwsem.c:1304 [inline]
> __down_write kernel/locking/rwsem.c:1313 [inline]
> down_write+0xb4/0xc0 kernel/locking/rwsem.c:1578

state_lock

> bch2_fs_read_only_work+0x28/0x48 fs/bcachefs/super.c:393
> process_one_work+0x810/0x1638 kernel/workqueue.c:3238
> process_scheduled_works kernel/workqueue.c:3319 [inline]
> worker_thread+0x97c/0xeec kernel/workqueue.c:3400
> kthread+0x65c/0x7b0 kernel/kthread.c:464
> ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> INFO: task syz.0.388:10111 blocked for more than 143 seconds.
>      Not tainted 6.14.0-rc7-syzkaller-ga2392f333575 #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
> task:syz.0.388       state:D stack:0     pid:10111 tgid:10110 =
ppid:6583   task_flags:0x400140 flags:0x0000000d
> Call trace:
> __switch_to+0x414/0x788 arch/arm64/kernel/process.c:701 (T)
> context_switch kernel/sched/core.c:5378 [inline]
> __schedule+0x1360/0x257c kernel/sched/core.c:6765
> __schedule_loop kernel/sched/core.c:6842 [inline]
> schedule+0xbc/0x238 kernel/sched/core.c:6857
> __closure_sync+0x198/0x29c lib/closure.c:146
> closure_sync include/linux/closure.h:195 [inline]

sync with state_lock held
=20
> bch2_journal_flush_pins+0x1e0/0x348 fs/bcachefs/journal_reclaim.c:911
> bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
> bch2_journal_replay+0x1c28/0x1f64 fs/bcachefs/recovery.c:442
> bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:226
> bch2_run_recovery_passes+0x260/0x92c fs/bcachefs/recovery_passes.c:291
> bch2_fs_recovery+0x20e0/0x32ec fs/bcachefs/recovery.c:936
> bch2_fs_start+0x32c/0x570 fs/bcachefs/super.c:1041
> bch2_fs_get_tree+0xa50/0x11d4 fs/bcachefs/fs.c:2203
> vfs_get_tree+0x90/0x28c fs/super.c:1814
> do_new_mount+0x278/0x900 fs/namespace.c:3560
> path_mount+0x590/0xe04 fs/namespace.c:3887
> do_mount fs/namespace.c:3900 [inline]
> __do_sys_mount fs/namespace.c:4111 [inline]
> __se_sys_mount fs/namespace.c:4088 [inline]
> __arm64_sys_mount+0x4f4/0x5d0 fs/namespace.c:4088
> __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
> invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
> el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
> do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
> el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
> el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
> el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
>=20
> Showing all locks held in the system:
> 1 lock held by khungtaskd/32:
> #0: ffff80008ff22620 (rcu_read_lock){....}-{1:3}, at: =
rcu_lock_acquire+0xc/0x44 include/linux/rcupdate.h:336
> 1 lock held by udevd/6081:
> 2 locks held by getty/6220:
> #0: ffff0000d74fa0a0 (&tty->ldisc_sem){++++}-{0:0}, at: =
ldsem_down_read+0x3c/0x4c drivers/tty/tty_ldsem.c:340
> #1: ffff80009bf4e2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: =
n_tty_read+0x41c/0x1228 drivers/tty/n_tty.c:2211
> 3 locks held by kworker/1:4/6586:
> #0: ffff0000c0029548 ((wq_completion)events_long){+.+.}-{0:0}, at: =
process_one_work+0x674/0x1638 kernel/workqueue.c:3212
> #1: ffff80009f6b7ba0 =
((work_completion)(&c->read_only_work)){+.+.}-{0:0}, at: =
process_one_work+0x708/0x1638 kernel/workqueue.c:3212
> #2: ffff0000e7500278 (&c->state_lock){+.+.}-{4:4}, at: =
bch2_fs_read_only_work+0x28/0x48 fs/bcachefs/super.c:393
> 1 lock held by syz.0.388/10111:
> #0: ffff0000e7500278 (&c->state_lock){+.+.}-{4:4}, at: =
bch2_fs_start+0x50/0x570 fs/bcachefs/super.c:1010
> 2 locks held by kworker/1:5/11232:
> #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: =
raw_spin_rq_lock_nested kernel/sched/core.c:598 [inline]
> #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock =
kernel/sched/sched.h:1521 [inline]
> #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: rq_lock =
kernel/sched/sched.h:1852 [inline]
> #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: =
__schedule+0x2e0/0x257c kernel/sched/core.c:6688
> #1: ffff0001b375d408 (&per_cpu_ptr(group->pcpu, =
cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x394/0x5e8 =
kernel/sched/psi.c:987
> 2 locks held by syz.3.1147/16990:
> 2 locks held by syz.4.1148/16993:
> #0: ffff0000fc500920 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_alloc =
fs/bcachefs/super.c:833 [inline]
> #0: ffff0000fc500920 (&c->sb_lock){+.+.}-{4:4}, at: =
bch2_fs_open+0x1238/0x299c fs/bcachefs/super.c:2065
> #1: ffff0000fc5049b0 (&c->mark_lock){++++}-{0:0}, at: =
bch2_sb_replicas_to_cpu_replicas+0x198/0x290 fs/bcachefs/replicas.c:600
> 3 locks held by syz.5.1149/17000:
> 2 locks held by syz.2.1150/17009:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before =
testing.
>=20
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>=20
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>=20
> If you want to undo deduplication, reply with:
> #syz undup
>=20

