Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00501946C8
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Oct 2025 00:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760834023; cv=none; b=DYRpVwXlMIPUWvGOmf3I0VEVHNHjNPt94YclKzWHvZlxOpgXr12d64pMgS4JSMjBUKmj4q4tO5RwataWnGklYQRGyb40ZxyuTx3iIpG5AuHXu1qiUySdNByPNvcaaNdFwVGJ0DJcV5UyPKTX8HgugRBspwSU7WDUCRfYnMmS/Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760834023; c=relaxed/simple;
	bh=Wfl+rTgwnOjYSQ3lWV53W+c63majBaNms3KBXgOsS+Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=IHuAJZGjrqnH8QDXdsNodhxgEn3GHIfxa32R9Lo+Gd7VRiUxMp2gYnvkbyhcQS8yre8UQDMTYuCJIV7qCYQ1ADiXbRKSJhfLHnvo3YL4seryJW/dMZwfKFCHYT2gJM9G9arsa/7rwfZSIOtJPO/n/Ngi3z/6D8Fivsgv+udAqE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-430db5635d6so785395ab.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 18 Oct 2025 17:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760834021; x=1761438821;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oCiy/9hhji+8zwsJi2fPYZ/jWkaCbphJgMzzajfP1bM=;
        b=q/MtR4lTswHXkiZfEP9qNlSNlnIujtjKPVWT3nNAonXRIMGEtUUBLgnV8FqZXGE+gx
         +RF+5FG9JTHD5zmnxQYCa9z4h6AuP+fUQelHvrcKJq4f1NmRgrmxykI1Ax/MRLVfhvtt
         Bw/Q/I7ccGUQEMU9/HpH/uWDtejNIp+NBQBpBdts6hcjNjbuqErDLEv8+GHTna5B3HWa
         YOwbF0EaFqlYAaDPu5MtMYNRNoc0+p3pH9Fs+uGv0ErBjaEjU8ChrBJh255U0jqi2FOb
         6rwMizIIwPVZzf1s26RXq7yfOc1mj2C2ui0dlRK7tiUj5taLczcxkaeyVj93y35pKdSI
         EajA==
X-Forwarded-Encrypted: i=1; AJvYcCXDkVPHgd3OP+2n6QewoB5LShCwIPGSgq4gzNCVDuCx2GKwjP5EYcyGAM1T+LvUrsDVcogeYYHOMMg70nR4fg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyeni15xIsokuchGhOlkLryYT0U0TSyZMeLwBrwtteqQoPaqGe8
	oVO3R5SpU5emZpvgn8IwYIBgzr10gdDotFAnIpO8lzhnJNucJ656ofLG16zIwykRSwbNltqwqp3
	8wZCWyJnK3SsdAV6qJyzTvvfi6d86lR/tmPdqbmewQQCJfPkG2PxYT5X3X+Q=
X-Google-Smtp-Source: AGHT+IERXWmS2tXn4BGh//q6P9LQOl6kGfWPsMvduZ5bCztQN974AL0QORihYfKgFQ3Uxk/2k7VP6YoUcefZDq9oJgKd/Htpw10e
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2195:b0:430:aea6:833f with SMTP id
 e9e14a558f8ab-430c525c688mr127344745ab.8.1760834020857; Sat, 18 Oct 2025
 17:33:40 -0700 (PDT)
Date: Sat, 18 Oct 2025 17:33:40 -0700
In-Reply-To: <68b976e8.050a0220.192772.0004.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f431e4.a70a0220.205af.000e.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_recovery_pass_want_ratelimit
From: syzbot <syzbot+3bf8b0169d7fcc0ebcd5@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    bf45a62baffc Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=172ae492580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd2356106f507975
dashboard link: https://syzkaller.appspot.com/bug?extid=3bf8b0169d7fcc0ebcd5
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124fda14580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14fb3de2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f0d4874557e9/disk-bf45a62b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0bf44a13b5b2/vmlinux-bf45a62b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/18db8bc9907c/Image-bf45a62b.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0638961e34c6/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3bf8b0169d7fcc0ebcd5@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6755 at fs/bcachefs/recovery_passes.c:174 bch2_recovery_pass_want_ratelimit+0x1c0/0x270 fs/bcachefs/recovery_passes.c:174
Modules linked in:
CPU: 1 UID: 0 PID: 6755 Comm: bch-copygc/loop Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : bch2_recovery_pass_want_ratelimit+0x1c0/0x270 fs/bcachefs/recovery_passes.c:174
lr : bch2_recovery_pass_want_ratelimit+0x1c0/0x270 fs/bcachefs/recovery_passes.c:174
sp : ffff8000a1a76af0
x29: ffff8000a1a76af0 x28: ffff0000f69b8028 x27: ffff0000d4bfe198
x26: 1ffff0001434ed70 x25: dfff800000000000 x24: 0000000000000001
x23: ffff8000a1a76c00 x22: dfff800000000000 x21: 0000000000000000
x20: ffff0000ecf80000 x19: 000000000000000e x18: 00000000ffffffff
x17: ffff80008280dad8 x16: ffff80008052b264 x15: 0000000000000001
x14: 1fffe00018c07b0b x13: 0000000000000000 x12: 0000000000000000
x11: 1ffff0001434ed95 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000c8658000 x7 : 2020202020202020 x6 : 696d206874697720
x5 : ffff0000c603d85d x4 : ffff0000c603d85b x3 : 0000000000000002
x2 : ffff8000a1a76b84 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 bch2_recovery_pass_want_ratelimit+0x1c0/0x270 fs/bcachefs/recovery_passes.c:174 (P)
 recovery_pass_needs_set+0xa0/0x468 fs/bcachefs/recovery_passes.c:302
 bch2_run_explicit_recovery_pass+0x4c/0xec fs/bcachefs/recovery_passes.c:416
 bch2_check_bucket_backpointer_mismatch+0x34c/0x3a0 fs/bcachefs/backpointers.c:1220
 __bch2_move_data_phys+0x684/0x144c fs/bcachefs/move.c:1011
 bch2_evacuate_bucket+0x220/0x34c fs/bcachefs/move.c:1082
 bch2_copygc+0x2d80/0x3570 fs/bcachefs/movinggc.c:234
 bch2_copygc_thread+0x898/0xd8c fs/bcachefs/movinggc.c:409
 kthread+0x5fc/0x75c kernel/kthread.c:463
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844
irq event stamp: 236
hardirqs last  enabled at (235): [<ffff800080c664d0>] kasan_quarantine_put+0x1a0/0x1c8 mm/kasan/quarantine.c:234
hardirqs last disabled at (236): [<ffff80008b05ee64>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:434
softirqs last  enabled at (0): [<ffff8000803ba294>] copy_process+0x1134/0x31ec kernel/fork.c:2119
softirqs last disabled at (0): [<0000000000000000>] 0x0
---[ end trace 0000000000000000 ]---
bc


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
