Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC3214EC7E
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 12:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718367383; cv=none; b=mHZDoNTKiscvDcCEi2G2Z6JvQL35K0QhHLo5QvAHnzPP3yWYvMVnOFQnUGUONwYEKt3LogLcWtIwc4yx3Kt0Y8B/T95EInZw5TVTiSLYf4jro7J4ea5GLRqrFScIWHTyjGEQAxN8gdoO2z6wKg8nxMah7GFfMQy1bTLxpbgbH7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718367383; c=relaxed/simple;
	bh=U8YWLxmPHt5Hzr/gUvcjRRL+ThBnjct/4VL62UVYJeo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Nw9LdbeLIyCo2RvRVTQZ7A8A+u3bP5DWy23E5FcL+xUaX22R7qa5tkJLpSTtP0MdIo3DMxb5JdI6JwdGe2ZPh41nPdJAJ+vNv3qB1Nltmlc8wA9uzUT+3FdXmnfXkEeVdKZhX04Q1sLtVggunzaHOaGh5+xibo54RQuJY/F1bo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7e8e5d55441so194276739f.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 05:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718367381; x=1718972181;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y+dI/iBtYvYG57frDDmvIwI4ngnHcMQbLtHXu3/qXnA=;
        b=fuGkL0MqCdZy0N9C0jUWY7/lTjbT1rBIFy5YBSkqW077BrzbZOH95NMiDXVvB7FhIY
         MH4LktlohU3WKz+g1eIW5CnmwHraXRnY65zIjsMSsOITjuI9ty1x8ttMZf7MdSdm3+44
         2GUBcQoXTejh0wWq21xH36TmC2LQddS5gMWS8XZuIz1XVV9DKkkFbnxxRAP9botM/zT1
         idSgSf0SK26z0jDc4FyfDlBKEhV7nuxSqEcV5QjvN4zHGWZS1dwKZpXyiVA9wohUsZB5
         jB6qdjpf6KICgdZbCb0dhw2MqX0SDipaCz8NruLm6XeYJD6KTeFFouz+hPi8OXNrgdYq
         SE+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWCwvcRKeluaybP5aSqefZhi7UBbyJtTU7Q+1qi3NdTBv1dzsffA/0PKyOi1PMnwYE7J4Cb3BWMYVexH0jrHtc5Qk3YxdfUxtvCobdC0jc=
X-Gm-Message-State: AOJu0Yz8HHdcJ38AypNoOEQfa8Rgm8nN8D/VJzym30/Jj2lVkJt1lCJC
	dj6wE3EwjQrDGq7N712jCmVu9W1gdaC6nTCS54CHsrD7dy/ibwA/RVtkqSCjIiYXi4R1egaaUZC
	27H1cDxTbGuRsNAI4ZQqkgOByf2NIqvhpmILz7P47T4bsI87NMfQLtaU=
X-Google-Smtp-Source: AGHT+IHD+LQvL5CaBGJGu/9sgUT8gCJ5Ym9xdoCgM/kAwzi9aM1Uw6yhF96jJSrvTq8cL1NHa96B5wGdYw/a0Crk7p+qJwtlewwk
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a85:b0:36c:5520:9597 with SMTP id
 e9e14a558f8ab-375e10df572mr1037025ab.6.1718367380815; Fri, 14 Jun 2024
 05:16:20 -0700 (PDT)
Date: Fri, 14 Jun 2024 05:16:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000053e574061ad89521@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_fs_read_write_early
From: syzbot <syzbot+4366624c0b5aac4906cf@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1689a256980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8786f381e62940f
dashboard link: https://syzkaller.appspot.com/bug?extid=4366624c0b5aac4906cf
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110cda0e980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164f91fe980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-2ccbdf43.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c40c1cd990d2/vmlinux-2ccbdf43.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a2a94050804e/bzImage-2ccbdf43.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a79f654b4644/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4366624c0b5aac4906cf@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 10 at fs/bcachefs/super.c:525 bch2_fs_read_write_early+0x8a/0xa0 fs/bcachefs/super.c:525
Modules linked in:
CPU: 0 PID: 10 Comm: kworker/0:1 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: bcachefs_write_ref bch2_delete_dead_snapshots_work
RIP: 0010:bch2_fs_read_write_early+0x8a/0xa0 fs/bcachefs/super.c:525
Code: ac b8 76 fd 48 8d bb 78 02 00 00 be ff ff ff ff e8 0b cd d0 06 31 ff 89 c5 89 c6 e8 90 b3 76 fd 85 ed 75 c7 e8 87 b8 76 fd 90 <0f> 0b 90 eb bc 48 c7 c7 58 a2 e4 8f e8 c5 8b d2 fd eb 9b 0f 1f 00
RSP: 0018:ffffc900000d7910 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888041080000 RCX: ffffffff84172cc0
RDX: ffff888017e90000 RSI: ffffffff84172cc9 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 1ffffffff272c7ee R12: ffff8880410801a8
R13: ffff888041080ae0 R14: 0000000000000001 R15: ffff88801f971800
FS:  0000000000000000(0000) GS:ffff88806b000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555581085788 CR3: 0000000025a9e000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_delete_dead_snapshots+0xfdc/0x4e50 fs/bcachefs/snapshot.c:1569
 bch2_delete_dead_snapshots_work+0x20/0x160 fs/bcachefs/snapshot.c:1690
 process_one_work+0x9fb/0x1b60 kernel/workqueue.c:3231
 process_scheduled_works kernel/workqueue.c:3312 [inline]
 worker_thread+0x6c8/0xf70 kernel/workqueue.c:3393
 kthread+0x2c1/0x3a0 kernel/kthread.c:389
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


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
