Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0F61D953C
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Jun 2024 13:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718632348; cv=none; b=ZYooVQxTjJNZHPatwOYqWAqQNp9mXOfhrL50xokhLqelksLB8bYrEWceixkQa/DB4TqN6EFMUIdyanLiFK8IY8N9lKyBK/90+AElzwFzVbwQPGfeFEDppUxUumMLIDxT/5B+p2JhRkEZkJZfwIgI9UFyAhDh5D1cXr/cko/lVWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718632348; c=relaxed/simple;
	bh=D5NFlVKvsla0CFXHFhlYZw7O0GmQQMdgyUVVhv0MRmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XnztQpbZJUrNxOZEmwJIjqZoLeX47ksJsXStLCQCa5XJA5XGqy7cA7EYxgZQocsCHRfQkILgOQJRJRc+0Uvar8n3kohRBa4vA+AEQDCNeFw7RJjqEVrDyNa5FYvhiqvX3sGlOuQe7Ldu+XH+/OD5by8c6i++NpKPlyAg9lZM55c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=alxVZG1o; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="alxVZG1o"
X-Envelope-To: syzbot+4366624c0b5aac4906cf@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718632344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3k/usp52ePqKVYe9MgAAGG7ZoIU/7jmDZL73Z+Os58E=;
	b=alxVZG1oxUVWK8F6CnSUKoSqrtMQ25rd1nOvYVJDAZXdxXbJerIRgvTT3JTd4RQFXiWAaV
	szi+uP8pfo6rFTvH9UtHGopiwPmm3d/ObJM/rMeYcFnRd1zcbXyG1J1hOYiImby53AS1Bo
	e23J/UK84fldiQTIBnk4SB3iSVdGBx8=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Mon, 17 Jun 2024 09:52:22 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+4366624c0b5aac4906cf@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_fs_read_write_early
Message-ID: <ffslrsipnjz2ta2i2lm3wnnrnxtjryvjqce6mlxntnqy7ieg2n@nhbpnfxzwar2>
References: <00000000000053e574061ad89521@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000053e574061ad89521@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 14, 2024 at 05:16:20AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1689a256980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b8786f381e62940f
> dashboard link: https://syzkaller.appspot.com/bug?extid=4366624c0b5aac4906cf
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110cda0e980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164f91fe980000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-2ccbdf43.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c40c1cd990d2/vmlinux-2ccbdf43.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a2a94050804e/bzImage-2ccbdf43.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/a79f654b4644/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4366624c0b5aac4906cf@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 10 at fs/bcachefs/super.c:525 bch2_fs_read_write_early+0x8a/0xa0 fs/bcachefs/super.c:525
> Modules linked in:
> CPU: 0 PID: 10 Comm: kworker/0:1 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Workqueue: bcachefs_write_ref bch2_delete_dead_snapshots_work
> RIP: 0010:bch2_fs_read_write_early+0x8a/0xa0 fs/bcachefs/super.c:525
> Code: ac b8 76 fd 48 8d bb 78 02 00 00 be ff ff ff ff e8 0b cd d0 06 31 ff 89 c5 89 c6 e8 90 b3 76 fd 85 ed 75 c7 e8 87 b8 76 fd 90 <0f> 0b 90 eb bc 48 c7 c7 58 a2 e4 8f e8 c5 8b d2 fd eb 9b 0f 1f 00
> RSP: 0018:ffffc900000d7910 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888041080000 RCX: ffffffff84172cc0
> RDX: ffff888017e90000 RSI: ffffffff84172cc9 RDI: 0000000000000005
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 1ffffffff272c7ee R12: ffff8880410801a8
> R13: ffff888041080ae0 R14: 0000000000000001 R15: ffff88801f971800
> FS:  0000000000000000(0000) GS:ffff88806b000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555581085788 CR3: 0000000025a9e000 CR4: 0000000000350ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  bch2_delete_dead_snapshots+0xfdc/0x4e50 fs/bcachefs/snapshot.c:1569
>  bch2_delete_dead_snapshots_work+0x20/0x160 fs/bcachefs/snapshot.c:1690
>  process_one_work+0x9fb/0x1b60 kernel/workqueue.c:3231
>  process_scheduled_works kernel/workqueue.c:3312 [inline]
>  worker_thread+0x6c8/0xf70 kernel/workqueue.c:3393
>  kthread+0x2c1/0x3a0 kernel/kthread.c:389
>  ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
#syz fix: bcachefs: delete_dead_snapshots() doesn't need to go RW
