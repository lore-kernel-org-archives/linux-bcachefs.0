Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9181F1A9B23
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 16:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749833310; cv=none; b=grLYpV8GLiHEh0IJNz/ysPWHjCwMZ/elUXNlLPwmSwAWHdOV1IINB3BxKeji+A1gxSxkCQzRzp02uLla6x2NKr6asx4jStiS/WJotVMdLKEfWBqnoEarB/uvuqF0ZZ7LS8E72mL/CNYqYp3RWN7aoAe8fDHD2gGSPOINUjIgwhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749833310; c=relaxed/simple;
	bh=Rp7vJTlMPsaoen5NOBgjQfwezWAotk4TV69xzCO7TNQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MjSSbbT7Smsw45VjkGQRMZf6g2WFOdD17Djk9pB873DuGbsDQQ+xoXDcVQGOMpwnpQyDycmeuGVzQcAYh/Abn9vwf8ArA7PXq4hmQMyVap2xMBPOA2OhAQqI7grtO9GrmOgJV5wNfi3IKi4uxx+HhoOxlor96flUXQRN4gDwHig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-875b64cccd6so411183739f.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 09:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749833308; x=1750438108;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nUBlTmct8R22pPkzLTix51atGwB3+I8WO1dU4QJBzjk=;
        b=M9xWcOaNr4P9lL3MQTzeZDXnXmffnLx1f0CjNdTfT/9r3sXg6Pmps6EAML3mcSrKZP
         ffkCPhvPIvTiXQrkMKUpshiaj5sxIG0VVu3avGDC7S2WeAtexzX6STzTxu76H2VxDizX
         U/Pv4liofFVXYZkW5rwdO+fpj/aVItTq+7g+uE3+ngYvjcXIgsIigKXagb7t7z6FrOkd
         /prxPJfXKWTk03K9MpvHgDFXl6rd6Z1ymRs7W/u2julBm+ojeaRAIu0IDeXHKPZ1bkNM
         oznUvR8VvphRRrCz2VwvkyhzephrDV3Fkbfblbo0HBy+hiWL63bYFeLt2ZhC98e7UZxL
         1tpA==
X-Forwarded-Encrypted: i=1; AJvYcCXXVoMj0OdjfwW7qHXajTaTVRpWP5+Sw1VofXpEbtcSHfQ69yRpP1U2QMQ2eJnHZuuho8fd/TsEfUZ5bzGL1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz05CFKyc8s7QU1XUbCIDXPeEzB1JKhc5q/Q2RMN3UlruHoMzV4
	AhvS5TqX3rm43/9tcwYikML7LKAcnjie9I6GOo70qn+TYLACldYbmziJD4vMWzaKobaP7fl978G
	9xs5YcLm4p+gSb7tQjjyTsNYKmx80GNxPeUGTRdWqk9tuBFPqZnZ/bbQd40c=
X-Google-Smtp-Source: AGHT+IE2fqAVde6MrvtCnAC4SuVWHIlQw+FwU8+kzEz67aL6Ahlu7EHoBf2WFhN3lVy9ywM1JHWJdwsJrKUwldbDSiIRDuDdovku
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2b:b0:3dd:d746:25eb with SMTP id
 e9e14a558f8ab-3de07cd170amr3843025ab.16.1749833307733; Fri, 13 Jun 2025
 09:48:27 -0700 (PDT)
Date: Fri, 13 Jun 2025 09:48:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684c565b.a00a0220.279073.0014.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel NULL pointer
 dereference in bch2_btree_update_start
From: syzbot <syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    19272b37aa4f Linux 6.16-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11a7f682580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8409c4d4e51ac27
dashboard link: https://syzkaller.appspot.com/bug?extid=2f3859bd28f20fa682e6
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/92d22b0c6493/disk-19272b37.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3fb0142bb63a/vmlinux-19272b37.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3d5f3836ae42/Image-19272b37.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Mem abort info:
  ESR = 0x0000000086000006
  EC = 0x21: IABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x06: level 2 translation fault
user pgtable: 4k pages, 48-bit VAs, pgdp=000000014106a000
[0000000000000000] pgd=0800000128c8b403, p4d=0800000128c8b403, pud=0800000132b39403, pmd=0000000000000000
Internal error: Oops: 0000000086000006 [#1]  SMP
Modules linked in:
CPU: 1 UID: 0 PID: 7230 Comm: syz.5.20 Not tainted 6.16.0-rc1-syzkaller-g19272b37aa4f #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : 0x0
lr : mempool_alloc_noprof+0x150/0x3f4 mm/mempool.c:402
sp : ffff80009dc06c80
x29: ffff80009dc06d80 x28: 0000000000000000 x27: 1fffe0001ee507df
x26: 0000000000092800 x25: ffff700013b80d9c x24: ffff0000f7283ef0
x23: 0000000000092c40 x22: ffff0000f7283ef8 x21: 0000000000000400
x20: 1fffe0001ee507de x19: ffff0000f7283ea0 x18: 00000000ffffffff
x17: ffff800093215000 x16: ffff80008051b344 x15: ffff800092d9eb80
x14: ffff0000c4812910 x13: ffff800093014c08 x12: ffff0000c4812930
x11: 0000000000008004 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff800080b774a8 x6 : 0000000000000000
x5 : 0000000000000020 x4 : ffff80009dc06a20 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000092800
Call trace:
 0x0 (P)
 bch2_btree_update_start+0x488/0x1398 fs/bcachefs/btree_update_interior.c:1212
 bch2_btree_node_rewrite+0x190/0xd34 fs/bcachefs/btree_update_interior.c:2226
 bch2_move_btree+0x538/0xa8c fs/bcachefs/move.c:1145
 bch2_scan_old_btree_nodes+0x80/0x21c fs/bcachefs/move.c:1266
 bch2_data_job+0x570/0x7cc fs/bcachefs/move.c:1404
 bch2_data_thread+0xb4/0x1cc fs/bcachefs/chardev.c:315
 kthread+0x5fc/0x75c kernel/kthread.c:464
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:847
Code: ???????? ???????? ???????? ???????? (????????) 
---[ end trace 0000000000000000 ]---


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
