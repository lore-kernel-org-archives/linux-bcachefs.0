Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B975B2E03F3
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Jul 2025 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985681; cv=none; b=Whz9s/8GRHtUuA+6w/HoTZxTmERvLUJUDT6IPwnNIHXrLkhS1yqzM1BgM6fgz22jEDfAeAvu6aiHc2BYrKxt3ypehVOSUaoB7Zv+cB8AeLOCIchJ/jm/QKP6JVcOsHtRF/bQAJ5kJbPdBVOBgNaTikCQswb4AAV/zTbHiOvCjWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985681; c=relaxed/simple;
	bh=RAC4lkyCT94lJKUcYXGhhrLxEIDl7mURTZoH/fpq5aA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Dug5RLUZJgy+FpnntyipXuBYOeRmptIkgHWBQJpbxQdwUtVXpKVU0hN1hiJRAKRQ2kKvRYjJs7lxsHS6KAz8slhX4ZVeXnQkhkbPdZcRKqWvhW6mhstKJ7sGVPpM8Fm0EGrrLImHq1zOGNx7NPfM+XsudRsoSEcFb0zFmXk4u8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3e134cebaf0so83219095ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 08 Jul 2025 07:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751985679; x=1752590479;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GOJ7cnqu863cfxPuedZyeOrCi4+XOq+8YjwTOkl1m74=;
        b=NjUA9AZqTp2qHZ1fKSA4J7EAj4k9BevpdLxfYiTeRNz68QDJ1iFzGKsmnAhj1xVqvL
         wIkJuuEToPZWOMC5MZqKf8o4wPvHRo+mQwTKA53IKL2JLgIMqKvm6ib3beyIHcRdqGJT
         0IAOs9TImhDBV+UO9wNswN2J7KprKMbtHCu/gLqgr/oWd0q6nkOudW66PyYJHyEaGg5e
         FuUEvS7Rk0XgTZ8aXvobll9poKuLCMEJ6ZiWXcTFrXjOq/dJQS8LxYqWnCDDSzAHQ/mY
         2ssomn4tsQLUAOH5kbWMFoBHTo3bGZF67unXl0qBFssJTQgq7rh8MFQGTDopZF+kJayF
         LZwA==
X-Forwarded-Encrypted: i=1; AJvYcCWDjUpf6fA6fKnSz9x+3VEsvyv9QjDhU9QzW7SdpOCccuyrq7E7SZXN1XOoLR2/tHgx0YlVVIwOwnaSrqtwMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxyN1Es/ChokN+mK0rr7VV+hL1KEfInd7rkWFffmnj+9afHKEmM
	3H9ZClONoYqal9X4CcyCytGLgMLe480TUZVXK2acZX3HFyqTijQkToGwl3vpYpZZr5zUSQCdmfb
	zY545kFErVu7ydPN8iXR7tQIk5fLDWOFhFLT2s3AZeKqYDUHUuuOO4jRe4eE=
X-Google-Smtp-Source: AGHT+IGuK2ubWa2cSZ6UkMR3FqVitg8fw1qCi57+p3dMm2jTiZUKa71Nj4hmG+ai1WLSmzRKq+fRc5PaWE0l/DpEHxgiiILkUC/d
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3193:b0:3dd:920f:d28e with SMTP id
 e9e14a558f8ab-3e154e4bdebmr34068345ab.13.1751985678980; Tue, 08 Jul 2025
 07:41:18 -0700 (PDT)
Date: Tue, 08 Jul 2025 07:41:18 -0700
In-Reply-To: <686d2569.050a0220.1ffab7.000e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686d2e0e.050a0220.1ffab7.0010.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_copygc
From: syzbot <syzbot+3168625f36f4a539237e@syzkaller.appspotmail.com>
To: anna.luese@v-bien.de, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    7482bb149b9f Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=12bf4a8c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c06e3e2454512b3
dashboard link: https://syzkaller.appspot.com/bug?extid=3168625f36f4a539237e
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f63f70580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16bf4a8c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f623d741d651/disk-7482bb14.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/483e23ae71b1/vmlinux-7482bb14.xz
kernel image: https://storage.googleapis.com/syzbot-assets/79b5baaa1b50/Image-7482bb14.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f9688b789a98/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3168625f36f4a539237e@syzkaller.appspotmail.com

bcachefs (loop1): Detected missing backpointers in bucket 34, now have 1/128 with missing
Unable to handle kernel paging request at virtual address ffff60021a145c30
KASAN: probably wild-memory-access in range [0xffff0010d0a2e180-0xffff0010d0a2e187]
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000207144000
[ffff60021a145c30] pgd=0000000000000000, p4d=000000023397b003, pud=0000000000000000
Internal error: Oops: 0000000096000005 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6717 Comm: bch-copygc/loop Not tainted 6.16.0-rc4-syzkaller-g7482bb149b9f #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : generic_test_bit include/asm-generic/bitops/generic-non-atomic.h:128 [inline]
pc : bch2_bucket_bitmap_test fs/bcachefs/backpointers.h:194 [inline]
pc : bch2_bucket_is_movable fs/bcachefs/movinggc.c:78 [inline]
pc : bch2_copygc_get_buckets fs/bcachefs/movinggc.c:157 [inline]
pc : bch2_copygc+0xab4/0x3460 fs/bcachefs/movinggc.c:221
lr : rcu_read_unlock include/linux/rcupdate.h:873 [inline]
lr : class_rcu_destructor include/linux/rcupdate.h:1155 [inline]
lr : bch2_dev_tryget_noerror fs/bcachefs/sb-members.h:241 [inline]
lr : bch2_dev_tryget fs/bcachefs/sb-members.h:245 [inline]
lr : bch2_bucket_is_movable fs/bcachefs/movinggc.c:74 [inline]
lr : bch2_copygc_get_buckets fs/bcachefs/movinggc.c:157 [inline]
lr : bch2_copygc+0xa7c/0x3460 fs/bcachefs/movinggc.c:221
sp : ffff80009e0c74c0
x29: ffff80009e0c7920 x28: 0000008000000022 x27: ffff80009e0c76c8
x26: dfff800000000000 x25: ffff80009e0c7cf8 x24: 0000000000000000
x23: ffff0000f5890000 x22: 0000000000000000 x21: ffff0000f2d00000
x20: ffff0010d0a2e180
 x19: ffff0000df09cc28 x18: 00000000ffffffff
x17: ffff800093363000 x16: ffff80008aefcb18 x15: 0000000000000001
x14: 1fffe0001eb12008 x13: 0000000000000000 x12: 0000000000000000
x11: ffff60001eb12009 x10: 0000000000ff0100 x9 : 0000001000000000
x8 : 1fffe0021a145c30 x7 : ffff800082a0df54 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff800082a0edd4
x2 : 0000000000000001 x1 : 0000000000000080 x0 : ffff0000cc76bd00
Call trace:
 generic_test_bit include/asm-generic/bitops/generic-non-atomic.h:128 [inline] (P)
 bch2_bucket_bitmap_test fs/bcachefs/backpointers.h:194 [inline] (P)
 bch2_bucket_is_movable fs/bcachefs/movinggc.c:78 [inline] (P)
 bch2_copygc_get_buckets fs/bcachefs/movinggc.c:157 [inline] (P)
 bch2_copygc+0xab4/0x3460 fs/bcachefs/movinggc.c:221 (P)
 bch2_copygc_thread+0x898/0xd8c fs/bcachefs/movinggc.c:409
 kthread+0x5fc/0x75c kernel/kthread.c:464
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:847
Code: d343fd29 927da529 8b090114 d343fe88 (387a6908) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	d343fd29 	lsr	x9, x9, #3
   4:	927da529 	and	x9, x9, #0x1ffffffffff8
   8:	8b090114 	add	x20, x8, x9
   c:	d343fe88 	lsr	x8, x20, #3
* 10:	387a6908 	ldrb	w8, [x8, x26] <-- trapping instruction


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
