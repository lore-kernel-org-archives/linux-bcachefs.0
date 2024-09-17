Received: from zucker.schokokeks.org (zucker.schokokeks.org [178.63.68.96])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A1C15E5BB
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Sep 2024 12:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.68.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726576710; cv=none; b=WfPjIPmY5Iyid5wUa6Q19nTobrtKf/oOYH+/59Xwxg2l4gGpCuZocll4WYmgXv3rQAtDWyLNaI+bVdCuO3wrd+Heg8NYdkg5BfPfXvGR0v4MFw9iIjzxDS8qC7W6+njrfiz+dp3fmwCKAYhEUzjVY/gg6LR+NBbfSnDQTjqyefc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726576710; c=relaxed/simple;
	bh=maMHdFgKRcoQ+NPcKC2wvdOzKoUcI2tQfnAWxfLuQt0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=q7qISMSewQ+0OEyGaJVe0av1h1Exmpm2V9wjZ2qDbffVsQqRKhVo2d6PKnh6W5Au9/Abq8mZRM1iyxCHvyPwrlDSgVNq9jn9GMgZEcimtX+dYGveJ7FD7s6frsZfN1tTAuFUbVVrPolZ1L+4Y8hIrDFJDklHiu21sQnuw8V1MlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hboeck.de; spf=pass smtp.mailfrom=hboeck.de; dkim=pass (2048-bit key) header.d=hboeck.de header.i=@hboeck.de header.b=dM2AfCfP; arc=none smtp.client-ip=178.63.68.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hboeck.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hboeck.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hboeck.de header.i=@hboeck.de header.b="dM2AfCfP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hboeck.de; s=key1;
	t=1726576096; bh=ENaHtbk5y8ry3LcsH3z4RlaFHe737eWOkzhYclR264A=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	b=dM2AfCfPvi0W1QKZ8kU8WngmBy2qsDC7zTB4HPRgTdQlvsxxtuEbpt26iZ2q4wKxl
	 fGWd6gg5J9q2j51fimydlxmqsmiGbI3KffUKApJoEzZmm+ZRNcNhNf2Eg6PvJXhf2k
	 78qa0ns9oQ7/jcJ36IA/ghWn9LuhN30AAnhjHqubkP+l5TZHsX3GPuPeCyF7WOMRB5
	 1nJ6TyUuoap0N1Cm87EEYQ5IZh6YG0zWdncS0G7jsSQyeJxOz2ljN2kFWgmfPrZFGi
	 DECIfF8zVRJVitEBqtijxMUXy4FFzmRu7CtrhIp4A0H/v4YhqKu032TCbqNjRDKSMc
	 suVYJT2EGjXSg==
Original-Subject: mount hangs / kernel BUG on attempt to mount or fsck /
 bch2_accounting_read
Author: Hanno =?UTF-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Date: Tue, 17 Sep 2024 14:28:15 +0200
From: Hanno =?UTF-8?B?QsO2Y2s=?= <hanno@hboeck.de>
To: linux-bcachefs@vger.kernel.org
Subject: mount hangs / kernel BUG on attempt to mount or fsck /
 bch2_accounting_read
Message-ID: <20240917142815.3c1c3c95.hanno@hboeck.de>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm having trouble with a bcachefs filesystem after an update to the
latest linux kernel 6.11.

After updating to 6.11, mounting of a bcachefs partition hang during
the boot process. I booted into a rescue system and disabled
automounting of that partition.

Afterwards, I tried fsck on the device, which didn't work with
bcachefs-tools 1.9.4. I upgraded to bcachefs-tools 1.11.0.

Running fsck.bcachefs hangs at
bcachefs (vdc2): accounting_read...

Doing either an fsck or mounting the partition leads to a BUG in kernel
dmesg. I'm pasting the message below.

Any suggestions what to do next? Ideally, I'd prefer to be able to
rescue that partition. I'm not sure whether downgrading the kernel
again to a previous version is safe. (It looks like it auto-upgraded
some things during mounting/fsck, see dmesg messages below.)


-----------
[    6.496094] EXT4-fs (vda1): mounted filesystem cdeab3d8-6944-4e77-8755-5=
539092c8ca7 r/w with ordered data mode. Quota mode: none.
[   27.230827] bcachefs (vdc2): starting version 1.12: rebalance_work_acct_=
fix opts=3Dcompression=3Dzstd
[   27.230836] bcachefs (vdc2): recovering from unclean shutdown
[   27.230839] bcachefs (vdc2): superblock requires following recovery pass=
es to be run:
                 check_allocations
[   27.230846] bcachefs (vdc2): Version upgrade from 1.7: mi_btree_bitmap t=
o 1.12: rebalance_work_acct_fix incomplete
               Doing compatible version upgrade from 1.7: mi_btree_bitmap t=
o 1.12: rebalance_work_acct_fix

[   29.955367] bcachefs (vdc2): journal read done, replaying entries 234681=
6-2346816
[   29.955371] bcachefs (vdc2): dropped unflushed entries 2346817-2346825
[   29.961534] bcachefs (vdc2): accounting_read...
[   30.020918] ------------[ cut here ]------------
[   30.020920] kernel BUG at fs/bcachefs/disk_accounting.c:658!
[   30.020924] Oops: invalid opcode: 0000 [#1] SMP
[   30.021059] CPU: 14 UID: 0 PID: 1414 Comm: mount.bcachefs Tainted: G    =
            T  6.11.0 #2
[   30.021251] Tainted: [T]=3DRANDSTRUCT
[   30.021348] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.1=
6.2-debian-1.16.2-1 04/01/2014
[   30.021542] RIP: 0010:bch2_accounting_read+0x42c/0x6f2
[   30.021662] Code: 49 8b 70 04 48 8b 48 04 44 39 cf 0f 92 c2 41 39 f9 83 =
da 00 85 d2 75 0e 31 d2 48 39 f1 0f 92 c2 48 39 ce 83 da 00 ff c2 74 02 <0f=
> 0b 49 8b 17 49 89 57 18 0f b6 08 31 d2 83 e9 05 39 ca 73 0f 49
[   30.021997] RSP: 0018:ffffac0082f138a0 EFLAGS: 00010202
[   30.022105] RAX: ffff97f9cbb586f8 RBX: ffff97f98cb80000 RCX: 00000000000=
00000
[   30.022218] RDX: 0000000000000002 RSI: 0023cf400000000d RDI: 00000000000=
00000
[   30.022331] RBP: ffffac0082f139b0 R08: ffff97f9cbb58580 R09: 00000000000=
00000
[   30.022441] R10: 0000000000000002 R11: ffff97f9847fb700 R12: 00000000000=
00000
[   30.022552] R13: ffff97f9847fb700 R14: ffff97f98ba710d8 R15: ffff97f98ba=
710d8
[   30.027531] FS:  00007126c5d39c80(0000) GS:ffff97fcb0d00000(0000) knlGS:=
0000000000000000
[   30.027654] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   30.027753] CR2: 000055875a915f70 CR3: 0000000108230000 CR4: 00000000003=
50ef0
[   30.027865] Call Trace:
[   30.027934]  <TASK>
[   30.028009]  ? __die_body+0x15/0x5b
[   30.028091]  ? die+0x2f/0x48
[   30.028165]  ? do_trap+0x75/0x104
[   30.028242]  ? bch2_accounting_read+0x42c/0x6f2
[   30.028332]  ? bch2_accounting_read+0x42c/0x6f2
[   30.028422]  ? do_error_trap+0x69/0xa2
[   30.028503]  ? bch2_accounting_read+0x42c/0x6f2
[   30.028593]  ? exc_invalid_op+0x4d/0x6d
[   30.028676]  ? bch2_accounting_read+0x42c/0x6f2
[   30.028764]  ? asm_exc_invalid_op+0x1a/0x20
[   30.028851]  ? bch2_accounting_read+0x42c/0x6f2
[   30.028940]  bch2_run_recovery_pass+0x45/0x76
[   30.029028]  bch2_run_recovery_passes+0x7e/0x17c
[   30.029120]  bch2_fs_recovery+0xbfe/0xfd7
[   30.029204]  ? __bch2_print+0x85/0xac
[   30.029285]  ? bch2_printbuf_exit+0x16/0x21
[   30.029372]  ? print_mount_opts+0x11e/0x152
[   30.029458]  ? bch2_get_next_online_dev+0x20/0x79
[   30.029549]  bch2_fs_start+0x125/0x1f2
[   30.029632]  bch2_fs_get_tree+0x238/0x5d5
[   30.029716]  vfs_get_tree+0x1c/0xdb
[   30.029799]  path_mount+0x676/0x77c
[   30.029881]  do_mount+0x69/0xa1
[   30.029957]  __do_sys_mount+0x126/0x15e
[   30.030041]  do_syscall_64+0x78/0xde
[   30.030121]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[   30.030217] RIP: 0033:0x7126c5e53bee
[   30.030299] Code: 48 8b 0d 3d d2 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0a d2 0c 00 f7 d8 64 89 01 48
[   30.030574] RSP: 002b:00007ffcfa9a9678 EFLAGS: 00000297 ORIG_RAX: 000000=
00000000a5
[   30.030692] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007126c5e=
53bee
[   30.030805] RDX: 00005587649f87c0 RSI: 00005587649f5380 RDI: 00005587649=
f8f60
[   30.030921] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00006
[   30.031032] R10: 0000000000000000 R11: 0000000000000297 R12: 00000000000=
00000
[   30.031145] R13: 000000000000000a R14: 00005587649f8f60 R15: 00005587649=
f87c0
[   30.031257]  </TASK>
[   30.031341] ---[ end trace 0000000000000000 ]---
[   30.031434] RIP: 0010:bch2_accounting_read+0x42c/0x6f2
[   30.031529] Code: 49 8b 70 04 48 8b 48 04 44 39 cf 0f 92 c2 41 39 f9 83 =
da 00 85 d2 75 0e 31 d2 48 39 f1 0f 92 c2 48 39 ce 83 da 00 ff c2 74 02 <0f=
> 0b 49 8b 17 49 89 57 18 0f b6 08 31 d2 83 e9 05 39 ca 73 0f 49
[   30.031810] RSP: 0018:ffffac0082f138a0 EFLAGS: 00010202
[   30.031905] RAX: ffff97f9cbb586f8 RBX: ffff97f98cb80000 RCX: 00000000000=
00000
[   30.032021] RDX: 0000000000000002 RSI: 0023cf400000000d RDI: 00000000000=
00000
[   30.032133] RBP: ffffac0082f139b0 R08: ffff97f9cbb58580 R09: 00000000000=
00000
[   30.032247] R10: 0000000000000002 R11: ffff97f9847fb700 R12: 00000000000=
00000
[   30.032362] R13: ffff97f9847fb700 R14: ffff97f98ba710d8 R15: ffff97f98ba=
710d8
[   30.032476] FS:  00007126c5d39c80(0000) GS:ffff97fcb0d00000(0000) knlGS:=
0000000000000000
[   30.032598] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   30.032697] CR2: 000055875a915f70 CR3: 0000000108230000 CR4: 00000000003=
50ef0


--=20
Hanno B=C3=B6ck
https://hboeck.de/
