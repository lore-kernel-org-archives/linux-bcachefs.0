Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11E814C583
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715599289; cv=none; b=CUseyXBtXMniaSJiibhuKZQ+2eCZn38N2RscdvyKyOpeG8kMysmn0VTjNKKXhlxrl+Q3TuWRDkCoalVWe6Kekv4U1c8iLqQRHSC46QMfDXAIHynFz3/u7vP9kDNShNiIYlb4Paj85v5rGVjKHZ+PGQPmQ1sVuBwJTWm22RMs1mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715599289; c=relaxed/simple;
	bh=2i1G4Ryfk4/25gD4w2Kl5pRFKJemnMRohe9Xr7JIAW0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ng3WuUEbAEGZoIQs7EO/pWg0Bv7jPqKmCmFzXtNf99ldenkOsgwuqIqS9wrwyYAr3sL7gfEP+5uzY49GAZKdINPF3rqbf/A254+0up+yn43QKAPOimCu0LJGRsOHcyMvTfsM0umHNjZtGUUM8DxL2O3f2d+4T9NIwUFHWBx6wNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7e17a8bed9eso427917339f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 04:21:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715599287; x=1716204087;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZFWNnaWE3XhlFsEY4Xi1pIV03wkj6KtbYqnhCD2A6iQ=;
        b=SEgk/sTigXZTRWUkxCK2239SYR6z2oQOKGyB3WrFr1D9WT679BXI5mRjKijaFrRV23
         Hx39Pn0eO/ORTFOmKb9F+cC0crTR4hNnq83hMS4zPcQ+IDNI1AWnLv//+D5nN7f7PsAF
         1zGleXcFkLDKIJqoeDWzAbCrXij3NelxmekJXP2C5KTlK3rWqQGDRgBx9ncXPkZam7UL
         wHJfcg6FbOR4v8hDiUXDp7o9HqYldODyGlpIVDfIiEtSL7+k/1DnHOA8yC7GAUWU4X7h
         MMNWoDs5cHr9rvSs9QQ3p/kSpTK21yy+xS3a2Q4eg96qzlFuGUb9dVLiWfLYtT6AzODy
         ZqaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXG3Vs0xS2rgoew87Sl2M+rX6X1MDrpr7lHonLo4emnYFJ8sYV7XzpeFkdXLkGQ0h6BugN0/2btNiza0a/J+l6UMWTFvvTDbFBs+ATJW8=
X-Gm-Message-State: AOJu0YxE9xZKG3IgQqd4ozDLBrWiBISqjWmT+11Xo6YZqWirE6bhzKyl
	CDwghWjGIt9FF0e7wQmEkqEyGSoGeC5V2dgXInTMRR2Q/Jf+cZYiqew1a4F8m8Oq8/xV+T9bKJt
	5UZECK0h8lUnsesscsmVaFLnTsbS1KjSPD+NqfP1xTg7q/yjqJL20C1w=
X-Google-Smtp-Source: AGHT+IEMZz0TpEVuwJCFFtYBcVKkxPDRiJYvde9XiMABTeUdnHR09RfBSBwYKXPSIsMTzGNPNdABz8knfiXwCLQFzBcz4NPXYQrS
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8625:b0:488:7bb2:c9f6 with SMTP id
 8926c6da1cb9f-48958c02450mr961209173.3.1715599287003; Mon, 13 May 2024
 04:21:27 -0700 (PDT)
Date: Mon, 13 May 2024 04:21:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000143d6f0618541652@google.com>
Subject: [syzbot] [bcachefs?] [rcu?] WARNING: lock held when returning to user
 space in srcu_lock_acquire
From: syzbot <syzbot+d797fe78808e968d6c84@syzkaller.appspotmail.com>
To: jiangshanlai@gmail.com, josh@joshtriplett.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mathieu.desnoyers@efficios.com, paulmck@kernel.org, rcu@vger.kernel.org, 
	rostedt@goodmis.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1c9135d29e9e Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=14ffaa6c980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d2d53e64c7e6a4f
dashboard link: https://syzkaller.appspot.com/bug?extid=d797fe78808e968d6c84
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1705e85c980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11612d04980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/52dd1b4921ab/disk-1c9135d2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1a4f1788dc25/vmlinux-1c9135d2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b8d8ebd42a80/Image-1c9135d2.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0471560e01b3/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d797fe78808e968d6c84@syzkaller.appspotmail.com

 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
================================================
WARNING: lock held when returning to user space!
6.9.0-rc7-syzkaller-g1c9135d29e9e #0 Not tainted
------------------------------------------------
syz-executor367/6238 is leaving the kernel with locks still held!
1 lock held by syz-executor367/6238:
 #0: ffff0000dcc84250 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire+0x18/0x54 include/linux/srcu.h:115


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
