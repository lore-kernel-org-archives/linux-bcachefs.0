Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120E41A238D
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 09:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735551682; cv=none; b=hk9+4UJ22z/3gml+uxLzAkdbjwz4jPBv9y2jFNuW6wIIqdhYO+BllXt+1y/23dk8A9hcMM0tSBueRwz7meYu5e0JkC1EltB38VCfKyzf5TPVWd2oeETD6B0kfBTcEIoR9qoFBiq8ley6asFc13ujBU2o42FyoK1DdaSAHn9nVWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735551682; c=relaxed/simple;
	bh=zoVmrfD1W7yqja76bRI9yTYmcAvPjagCi+638zx66LQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=mJbxm26fHRzNIdLaD6mbya7WgxLA/pq4+sIP5+tvpgjJCWIKA0U3Tyn9ORonzu9xoSpeG2QivE5fJM76qbiAdIzIiLVEKvskB1AIRX09c/zC/lc0jIGQG9UwNQAjTYysiCJ2PIa0TmwgeZq/VgBxfIubSorfe3F/l5dhi+vYGY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a7e39b48a2so190838445ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 01:41:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735551680; x=1736156480;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ip5q7j2K3bKCq3h+6xlHxt/ENukrx4+9CDImryopbPA=;
        b=DYcZ6HvwxOoNO2NfGARfhSbn765lXlciO5QQSfrJzD28FopZvLvDPZjV4AhTyKQ5GE
         rttrBsnqNRe0HFalVO+KAMvuL2HYh0K/+YnwYEQpLvVN9MwDckdCM173EhhR2EfFl8fU
         tU2ytU2RYANSHS43HFgxE+Du6c+1GyHQs/8QmYJNXEE2Z/P/by4ZJ4MQlj5ooL1nmJYj
         CU6c3djLiqtEG/oa3WXfgDWbrSnZZNLKN0MvCFP5WviOpZsm+AlgHmfcGmwtq3qJbFHL
         U7SMy1GRrIzjRnU44A5ue/2TbrB1JyCys6zi3cdSzA9K7hmotZmjkAiavHSdvRBkT8Bq
         AKkg==
X-Forwarded-Encrypted: i=1; AJvYcCURP1nBYa37c6HJpKowoy+G24Z/B5Js0+g/OZPfD57cIAdnS57hUkZF+MsRyEHyE2gOaUBNvUquGGLVie6tZw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9NlWSPOvDqH9I2EB4nFkC9C8trrcwumYI7MTo8M8jVUitVYWP
	hSG2lTDWc56YhpL9rdqW0LHNV3jqOo1In6r+C9jj8z0k4mY9KiCCLDL5ZuDGy6LcEu0Y0wnz6oa
	NqFgCFBLeKINJgxgzZ9oLMt10xkcVtM1xgMIa6F6UP4/GLg3M9kvPvLQ=
X-Google-Smtp-Source: AGHT+IEAnrzlpySBUJnaxK2vyLaygjG7wolrT9+EtAo78lE7C85nn7u46DtVEqdSYk7OXEhfCc3+CHw/+O6x9I+EBlgscjx6deLP
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cf:b0:3a4:eca2:95f1 with SMTP id
 e9e14a558f8ab-3c2d25669d8mr348485335ab.6.1735551680258; Mon, 30 Dec 2024
 01:41:20 -0800 (PST)
Date: Mon, 30 Dec 2024 01:41:20 -0800
In-Reply-To: <675be8a8.050a0220.1a2d0d.0003.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67726ac0.050a0220.2f3838.04bd.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_xattr_validate
From: syzbot <syzbot+983249082bd062b1c4ef@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    4099a71718b0 Merge tag 'sched-urgent-2024-12-29' of git://..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12886af8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9048090d7bb0d06
dashboard link: https://syzkaller.appspot.com/bug?extid=983249082bd062b1c4ef
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1300550f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15d8aac4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/62835b60de83/disk-4099a717.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9262b999e6be/vmlinux-4099a717.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3fc8cec4d596/bzImage-4099a717.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/dad89746421f/mount_3.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+983249082bd062b1c4ef@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_xattr_validate+0x3bb/0x720 fs/bcachefs/xattr.c:81
 bch2_xattr_validate+0x3bb/0x720 fs/bcachefs/xattr.c:81
 bch2_bkey_val_validate+0x2b5/0x440 fs/bcachefs/bkey_methods.c:143
 bset_key_validate fs/bcachefs/btree_io.c:841 [inline]
 validate_bset_keys+0x1531/0x2080 fs/bcachefs/btree_io.c:910
 validate_bset_for_write+0x142/0x290 fs/bcachefs/btree_io.c:1942
 __bch2_btree_node_write+0x53df/0x6830 fs/bcachefs/btree_io.c:2152
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
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
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
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
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4253
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4270
 __do_kmalloc_node mm/slub.c:4286 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4304
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

CPU: 0 UID: 0 PID: 5809 Comm: bch-reclaim/loo Not tainted 6.13.0-rc4-syzkaller-00110-g4099a71718b0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
