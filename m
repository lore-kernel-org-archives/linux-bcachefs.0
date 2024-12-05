Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE47A22F380
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Dec 2024 21:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733433565; cv=none; b=L3PN6CvEzwoPMESFic8e6lBBllNPcbrC/+x9QGaOOhYPx1Zf1XaYp3ltamvMSI2JfOJ2ps1ejXo668OiGuPmQOBlwiFUWPYgjZ4sulDH34jZK2BKXW/Q9NdjTKkWxSQ1r825MvdoxJl6eu3Mm8+3Y4vwZdmsD2ib2N/X60Ugcuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733433565; c=relaxed/simple;
	bh=lTydSs3N8k/WGISKjbB+TmQQBWkqsaB3kyB85esiDpo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=g8hqEF6V6TkKiF3eCyEA0I1bGNAN3dSQn8MJTIRXXKzbr5CQtRz9W15iKAU5pMg89tlKqLy+LWJp9jG672y6BGlsVYUBiMC9FUN7D4P9KgOvRetZkeQIpdzq/DwyWCaJ8ScD/YUJ4nYGLpGOyp2M7pgX3y2QvA/n1c0Y9ubUDFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a7e0d7b804so14934255ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 05 Dec 2024 13:19:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733433563; x=1734038363;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RSlSnNAswxLIxQTsFsywEgyI+8J5OzwwMvrrJaH872Y=;
        b=Sqd4cWd4pVKda1aDfYHWTmsfOr4fYWIR7N9rqVcOvriyqoUBOAs1bOxKCyRm3+E7/y
         D7wacaVYaQuTRZrDOhyQ8yItsStsZbCZkMsK27yCN4uXhXIE+3rITqJJY4CgYHfn00dE
         nOeueTg/HHrsxiDZ7NbFq3FtQMb/v5XkCFojO8pBsT0ct99S9FBUv0Xv9eTsY/qBfXCJ
         b/c5NXVs7gEVMRvlJCyH3hqpK9v0l8dFdSUJCuRHhsG1nBVpvWVbuT5PEvV/lWpksDKH
         YGMlZpjK0kXqsNhIYfMsFyZLsnzCBZIF2t1e9KWvKmraSHZ5Ptw6thQeU5lMxAdES2ca
         sjmA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ+o0/QhrFEViUmr6bbg/21b+VRi5xYpjah7t6W6e6jQppfVuW7dz+gu7vAQ0GfVIIvqZCUyrDgGpH3PjEsA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxB5sUqoMkEEz6SaPMtwo1PhIqD3EANu9zzjORI43XG286TVWBJ
	cru/grSV3Y38AVwZTqmu7ued7HVvG6/nXn2Dx0o00wtsC0pQxRhTycfb0BA4UPI6/r+gPSM5VBF
	jHRPouVBtH0/aYWmAsTPTXBtUeDEZXmfDz1SiHI+ud+u1WOa3BCZqjz0=
X-Google-Smtp-Source: AGHT+IFHdQk4upgCQHsvHJnwda36u0eYNiyM6fPM3d7Rd28cvKnu73b1Ed5zCfHCEgSrAD3UVbyPUxiDhaTN1BSJQLuWsWLe9KGF
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d8b:b0:3a7:e8df:3fde with SMTP id
 e9e14a558f8ab-3a811dd1e4dmr9498395ab.9.1733433562936; Thu, 05 Dec 2024
 13:19:22 -0800 (PST)
Date: Thu, 05 Dec 2024 13:19:22 -0800
In-Reply-To: <6749f2ee.050a0220.253251.00bb.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675218da.050a0220.b4160.01e7.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_bkey_val_validate
From: syzbot <syzbot+09c915024af5057b77da@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    feffde684ac2 Merge tag 'for-6.13-rc1-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1625ade8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=96ee18b6611821ab
dashboard link: https://syzkaller.appspot.com/bug?extid=09c915024af5057b77da
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a390f8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1125ade8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b31883c9ce49/disk-feffde68.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cd0fe66ddb61/vmlinux-feffde68.xz
kernel image: https://storage.googleapis.com/syzbot-assets/88e3455fb342/bzImage-feffde68.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/01cd3582aecd/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+09c915024af5057b77da@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_backpointer_validate+0x63a/0x8f0 fs/bcachefs/backpointers.c:57
 bch2_backpointer_validate+0x63a/0x8f0 fs/bcachefs/backpointers.c:57
 bch2_bkey_val_validate+0x2b5/0x440 fs/bcachefs/bkey_methods.c:143
 bset_key_validate fs/bcachefs/btree_io.c:841 [inline]
 validate_bset_keys+0x1531/0x2080 fs/bcachefs/btree_io.c:910
 validate_bset_for_write+0x142/0x290 fs/bcachefs/btree_io.c:1942
 __bch2_btree_node_write+0x53df/0x6830 fs/bcachefs/btree_io.c:2152
 bch2_btree_node_write+0x256/0x2e0 fs/bcachefs/btree_io.c:2296
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush1+0x38/0x60 fs/bcachefs/btree_trans_commit.c:266
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0xda8/0x1670 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:740
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:47 [inline]
 bch2_sort_keys_keep_unwritten_whiteouts+0x12d5/0x19d0 fs/bcachefs/bkey_sort.c:187
 __bch2_btree_node_write+0x3ae8/0x6830 fs/bcachefs/btree_io.c:2095
 bch2_btree_node_write+0x256/0x2e0 fs/bcachefs/btree_io.c:2296
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush1+0x38/0x60 fs/bcachefs/btree_trans_commit.c:266
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0xda8/0x1670 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:740
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4238
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4255
 __do_kmalloc_node mm/slub.c:4271 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4289
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_bounce_alloc fs/bcachefs/btree_io.c:124 [inline]
 btree_node_sort+0x78a/0x1d30 fs/bcachefs/btree_io.c:323
 bch2_btree_post_write_cleanup+0x1b0/0xf20 fs/bcachefs/btree_io.c:2248
 bch2_btree_node_write+0x21c/0x2e0 fs/bcachefs/btree_io.c:2289
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:261
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0xda8/0x1670 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:740
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

CPU: 0 UID: 0 PID: 5790 Comm: bch-reclaim/loo Not tainted 6.13.0-rc1-syzkaller-00025-gfeffde684ac2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
