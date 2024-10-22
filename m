Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5858C13E41A;
	Tue, 22 Oct 2024 20:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729628492; cv=none; b=OXhd+mv9+ayh1WV6YChNDuHheyUk+xuwdbjjnhOze53pL+n4JgMugIvdRZMyL2aZcOVFbAvAhfL+PXpUQ2SNNncdm9884WSN85Tagxu7VaSCy0aq1KlegT3Hgqcszbi9lHgoma09C93ZQ0Czg2P53ZpRL6auYcBC9QyoC+QnDQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729628492; c=relaxed/simple;
	bh=Bb4tE5HNy/3Q9LupdWC/qtV3X2KPMD0LdQD8kno5cqQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AO0qA4qq8oMOsebf/iL4OC21RfGM/nxm/HYJWM3vw0FDBVb5Ast8iWQ61l8NPxYmIF5GcfJT3Vu5covX2eqcX0zPQ+Dgq7gpTf3fBqG+vuVnRFHd2EWvDpQ+5DXNLzWyauGWLPPmqjiJEg2mn+M4/t/MubLgcBVK92xx8WDSWPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=XWr8RoUk; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="XWr8RoUk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1729628488; x=1729887688;
	bh=7TAwg2NhjgC2rD2Ah41EmrFWH8kOz2HRpf/iGmgs2SE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=XWr8RoUkWoKS/rcp6d/VoKQQI+xLAJPc3bQAkmmZr3qZyHP4p8Kq8DkGtDVCrvgoQ
	 8CjhBGKwBi86UpsqVEwpU81AkdDPv/QiVyEPs78weqCoj7UQr1i0//IqKQ4NYs2HHJ
	 qtfiLfDHgkJqNYbbMF9dGzctdheUsoBeCsID69/SJR7BP9JTXti9AOtrLESgYeYGnS
	 Vz6dI0LHqLd5TA402dAGUOuZcV7QHfwoqXsOTeAhmAVWiynnB25JCwC6vA9G1eCJCx
	 4IB1+JshIGLr1E91ezStRK7OXXtgG5pgSEkxpONQ3Hs5jVtCRLrq2ImBshzkN1og2K
	 Ro+bPxy7WSCrQ==
Date: Tue, 22 Oct 2024 20:21:24 +0000
To: syzbot <syzbot+47f334396d741f9cb1ce@syzkaller.appspotmail.com>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_journal_key_insert_take
Message-ID: <HzGVLZXHcn_UkULYJTtpdjJTmVWHsXHFOUSQ54FrsFFxO6-jL6ZBUR99YbWPqEpJKYVGnr3ofRAsCuKVG3eeB29-WGiPP68MfUr1thNAmjE=@proton.me>
In-Reply-To: <6716521b.050a0220.1e4b4d.0059.GAE@google.com>
References: <6716521b.050a0220.1e4b4d.0059.GAE@google.com>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 8c65888c2f230d8ff27f6c928231d32e4abe6c6c
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Monday, October 21st, 2024 at 3:07 PM, syzbot <syzbot+47f334396d741f9cb1=
ce@syzkaller.appspotmail.com> wrote:

> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit: 15e7d45e786a Add linux-next specific files for 20241016
> git tree: linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D10a5c24058000=
0
> kernel config: https://syzkaller.appspot.com/x/.config?x=3Dc36416f1c54640=
c0
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D47f334396d741f9=
cb1ce
> compiler: Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2=
.40
> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=3D11044487980000
> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=3D12815830580000
>=20
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/cf2ad43c81cc/dis=
k-15e7d45e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c85347a66a1c/vmlinu=
x-15e7d45e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/648cf8e59c13/b=
zImage-15e7d45e.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/6ba77e840d=
2c/mount_0.gz
>=20
> The issue was bisected to:
>=20
> commit d59f4aba096298347f0e0e5402843bb8505edc2d
> Author: Kent Overstreet kent.overstreet@linux.dev
>=20
> Date: Sat Oct 12 02:53:09 2024 +0000
>=20
> bcachefs: -o norecovery now bails out of recovery earlier
>=20
> bisection log: https://syzkaller.appspot.com/x/bisect.txt?x=3D1580c487980=
000
> final oops: https://syzkaller.appspot.com/x/report.txt?x=3D1780c487980000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1380c48798000=
0
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+47f334396d741f9cb1ce@syzkaller.appspotmail.com
> Fixes: d59f4aba0962 ("bcachefs: -o norecovery now bails out of recovery e=
arlier")
>=20
> ------------[ cut here ]------------
> kernel BUG at fs/bcachefs/btree_journal_iter.c:190!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> CPU: 1 UID: 0 PID: 1169 Comm: kworker/1:2 Not tainted 6.12.0-rc3-next-202=
41016-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 09/13/2024
> Workqueue: bcachefs_write_ref bch2_delete_dead_snapshots_work (bcachefs-d=
elete-dead-snapshots/)
> RIP: 0010:bch2_journal_key_insert_take+0x180f/0x1830 fs/bcachefs/btree_jo=
urnal_iter.c:190
> Code: f1 fc ff ff e8 d2 51 78 fd 90 0f 0b e8 ca 51 78 fd 90 0f 0b e8 c2 5=
1 78 fd 90 0f 0b e8 ba 51 78 fd 90 0f 0b e8 b2 51 78 fd 90 <0f> 0b e8 4a a1=
 af 07 e8 a5 51 78 fd 90 0f 0b e8 9d 51 78 fd 90 0f
>=20
> RSP: 0018:ffffc9000430edc0 EFLAGS: 00010293
> RAX: ffffffff841c909e RBX: 0000000000000040 RCX: ffff8880272b8000
> RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000000
> RBP: ffffc9000430ef30 R08: ffffffff841c7a8e R09: 1ffff1100de80035
> R10: dffffc0000000000 R11: ffffed100de80036 R12: 0000000000000000
> R13: ffff88806f400000 R14: dffffc0000000000 R15: ffff88806f44b310
> FS: 0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:00000000000000=
00
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000559ab32ac530 CR3: 00000000744be000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
>=20
> bch2_journal_key_insert+0xb3/0x130 fs/bcachefs/btree_journal_iter.c:260
> do_bch2_trans_commit_to_journal_replay+0x111/0x420 fs/bcachefs/btree_tran=
s_commit.c:1003
> __bch2_trans_commit+0x15d9/0x9420 fs/bcachefs/btree_trans_commit.c:1039
> bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
> bch2_delete_dead_snapshots+0x19b6/0x5ae0 fs/bcachefs/snapshot.c:1655
> bch2_delete_dead_snapshots_work+0x34/0x40 fs/bcachefs/snapshot.c:1730
> process_one_work kernel/workqueue.c:3229 [inline]
> process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
> worker_thread+0x870/0xd30 kernel/workqueue.c:3391
> kthread+0x2f0/0x390 kernel/kthread.c:389
> ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> </TASK>
>=20
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bch2_journal_key_insert_take+0x180f/0x1830 fs/bcachefs/btree_jo=
urnal_iter.c:190
> Cod
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
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

Seems this BUG is no longer being triggered. Output with 6.12-rc5:
```
executing program
[   22.799942] loop0: detected capacity change from 0 to 32768
[   22.835885] bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=
=3Dmetadata_checksum=3Dnone,data_checksum=3Dns
[   22.837429] bcachefs (loop0): recovering from clean shutdown, journal se=
q 10
[   22.843604] bcachefs (loop0): check_topology... done
[   22.844050] bcachefs (loop0): accounting_read... done
[   22.849861] bcachefs (loop0): alloc_read... done
[   22.850282] bcachefs (loop0): stripes_read... done
[   22.850738] bcachefs (loop0): snapshots_read... done
[   22.851370] bcachefs (loop0): check_allocations...
[   22.852430] btree ptr not marked in member info btree allocated bitmap
[   22.852441]   u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ac6214=
1f8dc7e261 written 24 min_key POS_MIN dg
[   22.854503] bcachefs (loop0): Unable to continue, halting
[   22.854977] bcachefs (loop0): bch2_gc_mark_key(): error fsck_errors_not_=
fixed
[   22.855673] bcachefs (loop0): bch2_gc_btree(): error fsck_errors_not_fix=
ed
[   22.856268] bcachefs (loop0): bch2_gc_btrees(): error fsck_errors_not_fi=
xed
[   22.857042] bcachefs (loop0): bch2_check_allocations(): error fsck_error=
s_not_fixed
[   22.857904] bcachefs (loop0): bch2_fs_recovery(): error fsck_errors_not_=
fixed
[   22.858378] bcachefs (loop0): bch2_fs_start(): error starting filesystem=
 fsck_errors_not_fixed
[   22.858933] bcachefs (loop0): shutting down
[   22.863434] bcachefs (loop0): shutdown complete
[   23.256941] bcachefs: bch2_fs_get_tree() error: fsck_errors_not_fixed
[   23.270355] repro.elf (193) used greatest stack depth: 25792 bytes left
```



