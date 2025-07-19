Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5A42557A
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752950824; cv=none; b=FgKTMcnRkwmPiBvVgomYl2ALH0ffNWVwyTLXSOUeBZGhVKNPP5EPn/q8imi8YOPW1P5j8X6uQxlxFUOKV39M5E+IY8aMRBS9gNFE/tyI5rtbbTc+8PqR7nF/2wlImiNJ4FBWaNzkzfRBKIxS0GZkEPNf90x9Vvc4fchSwJiIsYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752950824; c=relaxed/simple;
	bh=GZz4R4rWf9RTfmBIOUlTYRCCGPL5BNmvOxvYedjCamk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=HwKIzpoQnAHv5BIIA5VqFYj2VBd7ZrL+wWvn4Lq5r+QlT49UKf7l92IX0yUAyiFDA81kgyKvGj9B5OqEkjWF4lriTbDnU5GWh5DgL2fwLK0pzcLOg1Misi5V9o7fXQY07Aej+++fkwyZO//Sxwhf6+WsI5KKW+gYRPbDL6wRf6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ddcfea00afso44341065ab.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 11:47:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752950822; x=1753555622;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cF+BgT1Z16QR2JRNCljkE/P7XL0rVlwz4FN/WduuFNY=;
        b=NVU1sc+u8GgLN4jN3UN9+lrf8ypHwd3Y+vFillegtS5yM55xOuccCgfxZf/FDj+sqy
         6WtgwguGslwUsUCoQC3JEhGyfyuIbBNMr4FHMgiorC+Vd6+7UdltgepvETVdA/u1gsP0
         vFbMLfft8WLBYlw7YF1XaquadVbLa1ejMuQbT0XDJR7sSrenZ4Q6Un0SRVlEHgtYdmWW
         cgOZFsWFrI5hfpV4tQdCNuZdrkixByEdeOfmps9bqxlQJfqDTr7ENa/bX1HB7xM9ZnwL
         A8BeVP7n4LdBHlvWjMsYyf6frTrBDf5jniRI/tsjalpbJitNo2lK8rObVRq2S2JYNyvJ
         8d4w==
X-Forwarded-Encrypted: i=1; AJvYcCVp05lqeMFpBDw99vKlEGLs1UARw0gASFRsl7IpRjPHd9XxAqiYm4fdHTTvyZqGB/3emsBMWtfeiZrFGGVFoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlUxi0ydH0vDgwjSiO2kMPoxssLdkvYOV47jfsYPPf9Gn3gg/u
	A3xnJ4WZyXxzilYvzQrO37AJjI7LqulRhk21RxzHTKN/wHOlSEvoaUKGMW1Kb8Y+3PnoAUV6q2j
	0E5kpXLocCaIBd1iSRGo5IIOU8crNVaig2HKL78Gd3iBJG0CuQqqAVlUzM5U=
X-Google-Smtp-Source: AGHT+IE4wY8WbjFLG2VMamX4ClAgvD3mpyfH3Aooa+6LA5O04vsuQAw0QKyXI1Blv30efQyTEDuSidivYEUzZx8bKQD8cDwSH/UJ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c247:0:b0:3e2:a749:252e with SMTP id
 e9e14a558f8ab-3e2a749281fmr15522145ab.4.1752950822520; Sat, 19 Jul 2025
 11:47:02 -0700 (PDT)
Date: Sat, 19 Jul 2025 11:47:02 -0700
In-Reply-To: <n2gwogdq44vxgvjdefktzbhfny2ezktepblcsj2q3z7t4dgbtv@6uafqubd7qr2>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687be826.a70a0220.693ce.0093.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Write in bch2_get_next_dev
From: syzbot <syzbot+2b98caf09c41174a9697@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
kernel panic: btree_update_nodes_written leaked btree_trans

Kernel panic - not syncing: btree_update_nodes_written leaked btree_trans
CPU: 0 UID: 0 PID: 7134 Comm: syz.4.31 Not tainted 6.16.0-rc6-syzkaller-gcbdeb0ffd5bf #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x99/0x250 lib/dump_stack.c:120
 panic+0x2db/0x790 kernel/panic.c:382
 bch2_fs_btree_iter_exit+0x475/0x490 fs/bcachefs/btree_iter.c:3732
 __bch2_fs_free fs/bcachefs/super.c:640 [inline]
 bch2_fs_release+0x2ab/0x830 fs/bcachefs/super.c:690
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22b/0x480 lib/kobject.c:737
 bch2_fs_get_tree+0xb76/0x1540 fs/bcachefs/fs.c:2578
 vfs_get_tree+0x92/0x2b0 fs/super.c:1804
 do_new_mount+0x24a/0xa40 fs/namespace.c:3902
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f59aa99014a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f59ab804e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f59ab804ef0 RCX: 00007f59aa99014a
RDX: 00002000000000c0 RSI: 0000200000000080 RDI: 00007f59ab804eb0
RBP: 00002000000000c0 R08: 00007f59ab804ef0 R09: 0000000000818001
R10: 0000000000818001 R11: 0000000000000246 R12: 0000200000000080
R13: 00007f59ab804eb0 R14: 000000000000596b R15: 0000200000000000
 </TASK>
Kernel Offset: disabled


Tested on:

commit:         cbdeb0ff bcachefs: Fix UAF by journal write path
git tree:       git://evilpiepirate.org/bcachefs.git for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1627f8f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37de60b3108b6d8f
dashboard link: https://syzkaller.appspot.com/bug?extid=2b98caf09c41174a9697
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
