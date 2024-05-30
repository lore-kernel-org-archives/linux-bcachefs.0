Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967E414AAD
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 May 2024 08:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717058790; cv=none; b=jRhKdtmTkqylKeKEaZ9sW5/gqyeS8JoO8w+8YQ6jgZLlTSDRbFQOYlgmA+GbtDOSt4OSBPN+qzDfA2FxrqDwH+U9Ry84yV93RLELoqHsgh23+MxYSe2s8pjCLYOyZ7iaHMwAHkvTHZZm7uNEQNnw8rHAqdpK289ZwBoU7IXHTxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717058790; c=relaxed/simple;
	bh=5+LHasuOIYiWmSTZWOGMNCpGQ1ATSwQT4Ficzma0FdI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=guNdkg34/YRfcyt7wS4jS2jHrcQtPbZGNf1CsXcOe1B3sUs8xfSasioiOVcZhDB3bRiimzys2MQwzOznLBPG8SQX2COY4L+YP4rdEFUfdz6jrvD0H+QJCWFOQHWqBsPxGIrgWtu1a1OJYRCYJG7GZNGrwrtlBM8IbTg7AuDM7VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3737b6fc28fso8309555ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 30 May 2024 01:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717058788; x=1717663588;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AOHiZgHlaOGjmg5s/A045cvtq4Ms3VgIs/iP1UczQ2M=;
        b=GEt6oXYPr6KjgInG3D1F5+EipkxDQhMRmZlkhqPVIRxEw5vSwVwb0pwoymBHna5CxG
         f/5FkyucUAGkjeR8Sx7e563i4jVWWCzQ+V+s8l1b/2zdM70jNHhT4iPRNNEroePfAuui
         Z4ypfdRiXbF1T9ieFQJrRWOBUs2LDqCP0LuetKQmFnLS0CjRsW3YFYeFgSp9vY+FFeXO
         W+51hsNDxtH+MzL7ob2qshlYpdNai1fWfvBjBrpnZnWGcbmOVUzxsyQQu7C5NAnBjZkL
         ywXog17wQYrN370xKBRV6puDC8R2vHsC+sjm5WpsSIQ3SCDqPlXpO5trTEE6j+OtAA/x
         fPBg==
X-Forwarded-Encrypted: i=1; AJvYcCV6OhNYqZ7zbLAqlDW0vu4cljHfL9c2BRO+BgwW6TYlgvTl3KEZfCBAGTaLGdQIggS/HTKW0MY/3QxNW9cHYGmRO6jCxVmX1sYafa+jjXQ=
X-Gm-Message-State: AOJu0YyZbyTjnwPT1v2xqET9V35uDjaKhNFn2A7DjwDCgRqRIGqVxJTS
	JoJ+OT7d+g/IdRK8MCXG3QsFlPzfYWuqpKVKhElN6eH6dsBEQVfZYx5/m85xDEfqn3SRt7M+bNH
	jNANKVFI9Z3ojYUA46lOQg12xKXy0Y5QZNXWv9WU1T40mgyili5D46Ew=
X-Google-Smtp-Source: AGHT+IH/7Gn/EX/fKTucYomipSI4I2HjJ27JxZ+EGJ/hoUiolaqsTpBPvWYk/ZYLUteUaJLTJlGiKtHEdkDUHNE2hIs207l6chVc
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b0e:b0:371:a225:45b5 with SMTP id
 e9e14a558f8ab-3747e1ee036mr604125ab.1.1717058787873; Thu, 30 May 2024
 01:46:27 -0700 (PDT)
Date: Thu, 30 May 2024 01:46:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c2dac0619a7e77c@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_inode_flush_nocow_writes_async
From: syzbot <syzbot+917694e2e9db5284865f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    101b7a97143a Merge tag 'acpi-6.10-rc1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14d948f2980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ac2f8c387a23814
dashboard link: https://syzkaller.appspot.com/bug?extid=917694e2e9db5284865f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4f673334a91c/disk-101b7a97.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8e6db59f4091/vmlinux-101b7a97.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7e5782387c9d/bzImage-101b7a97.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+917694e2e9db5284865f@syzkaller.appspotmail.com

bcachefs (loop0): snapshots_read... done
bcachefs (loop0): journal_replay... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): going read-write
bcachefs (loop0): done starting filesystem
=====================================================
BUG: KMSAN: uninit-value in find_first_bit include/linux/find.h:207 [inline]
BUG: KMSAN: uninit-value in bch2_inode_flush_nocow_writes_async+0x6bd/0x6f0 fs/bcachefs/fs-io.c:64
 find_first_bit include/linux/find.h:207 [inline]
 bch2_inode_flush_nocow_writes_async+0x6bd/0x6f0 fs/bcachefs/fs-io.c:64
 bch2_inode_flush_nocow_writes fs/bcachefs/fs-io.c:99 [inline]
 bch2_flush_inode+0x3d4/0x480 fs/bcachefs/fs-io.c:186
 bch2_fsync+0x1d1/0x2a0 fs/bcachefs/fs-io.c:203
 vfs_fsync_range+0x20d/0x270 fs/sync.c:188
 generic_write_sync include/linux/fs.h:2811 [inline]
 bch2_buffered_write fs/bcachefs/fs-io-buffered.c:1136 [inline]
 bch2_write_iter+0xe59/0x5b30 fs/bcachefs/fs-io-buffered.c:1144
 do_iter_readv_writev+0x7e6/0x960
 vfs_writev+0x574/0x1450 fs/read_write.c:971
 do_pwritev fs/read_write.c:1072 [inline]
 __do_compat_sys_pwritev2 fs/read_write.c:1218 [inline]
 __se_compat_sys_pwritev2+0x2a8/0x490 fs/read_write.c:1210
 __ia32_compat_sys_pwritev2+0x11d/0x1a0 fs/read_write.c:1210
 ia32_sys_call+0x918/0x40a0 arch/x86/include/generated/asm/syscalls_32.h:380
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb4/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3877 [inline]
 slab_alloc_node mm/slub.c:3918 [inline]
 kmem_cache_alloc+0x5b9/0xc20 mm/slub.c:3925
 bch2_alloc_inode+0x56/0x280 fs/bcachefs/fs.c:1497
 alloc_inode+0x86/0x460 fs/inode.c:261
 new_inode_pseudo fs/inode.c:1007 [inline]
 new_inode+0x38/0x4f0 fs/inode.c:1033
 bch2_new_inode+0xc8/0x290 fs/bcachefs/fs.c:224
 bch2_lookup_trans fs/bcachefs/fs.c:408 [inline]
 bch2_lookup+0x1993/0x1fc0 fs/bcachefs/fs.c:437
 lookup_open fs/namei.c:3483 [inline]
 open_last_lookups fs/namei.c:3574 [inline]
 path_openat+0x27a9/0x5b00 fs/namei.c:3804
 do_filp_open+0x20e/0x590 fs/namei.c:3834
 do_sys_openat2+0x1bf/0x2f0 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_compat_sys_openat fs/open.c:1481 [inline]
 __se_compat_sys_openat fs/open.c:1479 [inline]
 __ia32_compat_sys_openat+0x298/0x300 fs/open.c:1479
 ia32_sys_call+0x38e1/0x40a0 arch/x86/include/generated/asm/syscalls_32.h:296
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb4/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

CPU: 0 PID: 15357 Comm: syz-executor.0 Not tainted 6.9.0-syzkaller-02339-g101b7a97143a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
=====================================================


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
