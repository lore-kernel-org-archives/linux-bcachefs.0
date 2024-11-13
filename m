Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BDE1FAC53
	for <linux-bcachefs@vger.kernel.org>; Wed, 13 Nov 2024 19:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731526403; cv=none; b=uDSMJp5WMLcC+VSwN9PYZsvNLGE6gZ5rfXT0U+9qYbWE/K0QSzmhgkGcwFeVj6GYTLPbE0xEqg6vhdgqovfkTY/JGi+0r+zL7WFo+TfxBS8/idUqtXJ0DfK4eyw5osr/rWRg8Z9v8jTWWy7D387XIaj6KsNsupGHSGNSP2RMiOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731526403; c=relaxed/simple;
	bh=ZJE0GUxdAVCypxAwEExtd13KRtJMASPgSHmHF6AfHzg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=sZCFTyU0DnLuq7wD7Xg7/Z8YIUjp+PMqdcXfaegupdCk/ft0PImachv6HlT1gtaKKzEdQod6NEThdn206P+Oq83IiI6vcmfxzqxZN2Pbaz6bFUVgQ0YQ86PokyNsUNu2/dZYtWcVHfv8GDX/25bh2SpOyKMZdA32nWuRZGT8blA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a71d04c76dso4368405ab.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Nov 2024 11:33:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731526401; x=1732131201;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u2safgi8aMicA072PLr7GkrEgEA4UDp3nCMTFfOzvbo=;
        b=OMlHc1Lgurvizy9KYueaJTOsAhig/exXTU+/XPTqStezuK7feKsmXm5TV8QY5+VNZl
         O3LUUTQVp+mGlaBIVFeEeE8/G4OXRiTJnrxKvQqsWfOMTXVuFFyQXPbIPk9oZcE0e4LM
         CyyibZ8DI0dnmefCvHXVRYpytuCEZp6w3tFcqEqaujqaOUe7SRYO+T/T02AkrvpwUpHQ
         D7TWtqXB924x/0g/j7YY8gnCip4Qt439jLZZE4e7Ok7NcAq5r0HD4TdlH99G6Au3yXrL
         K+RIAuxvDV/+0Uo2mwHGUkRjr2S4Fzi7MIAEj5UN1G3bD5K7G1uZIujYS9i/xIXlSCXu
         04zQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdaoJ2f2NJtuMT5sWb/ESfqAhg6E6LgyTK/o6XMUgejGrid6Y87FqQemMcExOr67ym+fX8L9yq/agMkI0F0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZMxqy9LDo+dM4qYBitmpJRkM2503cQeS6d+I6GaJhYkzPS4d/
	42xEtdgwumjDf5aJwEuC0O6cJ6+/DU4ibWgM73X5XLXAalSrDNaq/sZ306LbXSPS1NrBFFZZhDE
	NCKajiaujl87RvyLT/HZ6UWiwdIw/yreJSFmyLcNkANsrpkJ5B3sXaN0=
X-Google-Smtp-Source: AGHT+IHWYDdzYSyP+VS8GdciSojK8iOsYuwPsU1Vnwk19yANwntp4F7SJy6HTJAYpqIjM8AtupXPJrM482mmD4arW1OXioDLi1N7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174f:b0:3a7:1ca7:a2e0 with SMTP id
 e9e14a558f8ab-3a71ca7a427mr20145525ab.20.1731526401023; Wed, 13 Nov 2024
 11:33:21 -0800 (PST)
Date: Wed, 13 Nov 2024 11:33:20 -0800
In-Reply-To: <66fe516e.050a0220.28a3b.020a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6734ff00.050a0220.2a2fcc.005b.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_btree_node_write
From: syzbot <syzbot+dedbd67513939979f84f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    f1b785f4c787 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15d821a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=dedbd67513939979f84f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d821a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=153be4c0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-f1b785f4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3d6bd514fd25/vmlinux-f1b785f4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bf9273b213e1/bzImage-f1b785f4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7f0f16a23dd2/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dedbd67513939979f84f@syzkaller.appspotmail.com

bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): set_fs_needs_rebalance... done
bcachefs (loop0): scanning for old btree nodes: min_version 0.24: unwritten_extents
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_io.c:2104!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5310 Comm: syz-executor317 Not tainted 6.12.0-rc7-syzkaller-00042-gf1b785f4c787 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bch2_btree_node_write+0x43d8/0x4400 fs/bcachefs/btree_io.c:2104
Code: fd 90 0f 0b e8 89 0b 7d fd 90 0f 0b e8 81 0b 7d fd 90 0f 0b e8 79 0b 7d fd 90 0f 0b e8 71 0b 7d fd 90 0f 0b e8 69 0b 7d fd 90 <0f> 0b e8 61 0b 7d fd 90 0f 0b e8 59 0b 7d fd 90 0f 0b e8 51 0b 7d
RSP: 0018:ffffc9000d1a6ac0 EFLAGS: 00010293
RAX: ffffffff8417dea7 RBX: 00000000000001f9 RCX: ffff888000faa440
RDX: 0000000000000000 RSI: 0000000000000202 RDI: 00000000000001f9
RBP: ffffc9000d1a6da0 R08: ffffffff8417bda8 R09: 0000000000000000
R10: ffffc9000d1a6860 R11: fffff52001a34d0e R12: dffffc0000000000
R13: ffff88803f1f409e R14: 0000000000000202 R15: 00000000000001f9
FS:  00005555859f8380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556936678098 CR3: 000000004351e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_node_write+0x63/0x1f0 fs/bcachefs/btree_io.c:2288
 bch2_btree_node_rewrite+0xcac/0x1280 fs/bcachefs/btree_update_interior.c:2179
 bch2_move_btree+0x7af/0xde0 fs/bcachefs/move.c:865
 bch2_scan_old_btree_nodes+0x14b/0x3c0 fs/bcachefs/move.c:995
 bch2_fs_recovery+0x34f5/0x39d0 fs/bcachefs/recovery.c:974
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2dd0470dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffecee7d928 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffecee7d940 RCX: 00007f2dd0470dea
RDX: 0000000020000140 RSI: 0000000020000100 RDI: 00007ffecee7d940
RBP: 0000000000000004 R08: 00007ffecee7d980 R09: 000000000000591b
R10: 000000000020000a R11: 0000000000000282 R12: 000000000020000a
R13: 00007ffecee7d980 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_btree_node_write+0x43d8/0x4400 fs/bcachefs/btree_io.c:2104
Code: fd 90 0f 0b e8 89 0b 7d fd 90 0f 0b e8 81 0b 7d fd 90 0f 0b e8 79 0b 7d fd 90 0f 0b e8 71 0b 7d fd 90 0f 0b e8 69 0b 7d fd 90 <0f> 0b e8 61 0b 7d fd 90 0f 0b e8 59 0b 7d fd 90 0f 0b e8 51 0b 7d
RSP: 0018:ffffc9000d1a6ac0 EFLAGS: 00010293
RAX: ffffffff8417dea7 RBX: 00000000000001f9 RCX: ffff888000faa440
RDX: 0000000000000000 RSI: 0000000000000202 RDI: 00000000000001f9
RBP: ffffc9000d1a6da0 R08: ffffffff8417bda8 R09: 0000000000000000
R10: ffffc9000d1a6860 R11: fffff52001a34d0e R12: dffffc0000000000
R13: ffff88803f1f409e R14: 0000000000000202 R15: 00000000000001f9
FS:  00005555859f8380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556936678098 CR3: 000000004351e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
