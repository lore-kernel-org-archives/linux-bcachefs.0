Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87DF2288F2;
	Mon, 17 Feb 2025 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739812347; cv=none; b=GJ4xNLgykZB8cjOGk4OTC6lKMq9ApvncfuoMfmYxNJUphZGkYlFdIcf1bvLQuzrd7OucctjLShQ+NB84ugenvvMZOkYsNdHR5utXvYfm24oGXxOEadxZA9SpuyH7ZeB7wchJBp10BLUk/+ZwuUzLHstRQ1svnxf37crbnZea+0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739812347; c=relaxed/simple;
	bh=LVOQlz5VRkih/xMybEkYpUEaER1BzHL5Ayhs0FOll6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EbOhz6CG1KKe6JVARNo4zDMk39Ie1xl2J/Tqs1enwudQKco/hL/LvtnkACxhdA2ahxWG2ob5FjQO06hBB013XPfVMU8dKNv6tudbwxueYQj0VpMCxpejqwV13NmLyrsP6CADRfhhXGqRtcp9rFEVsVwNgq0Hka+/vZjrKSHrx2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E/XJYMfn; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/XJYMfn"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-307325f2436so37489171fa.0;
        Mon, 17 Feb 2025 09:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739812344; x=1740417144; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbNIFLkQGKx8gMtazppTvQVDaVLm+keOHDU+VX7GYjs=;
        b=E/XJYMfnEUsUJkZrbzLqNYL6psM+WQl4ZwadjayA98MHeYVZmX600eAknQT5UMo6uj
         PRoEYFoTKDggZAJ08M/Zr5i4+dPgT5j0TcA7EH/kK1qLBpCMJvdDgBTx78lOCjzBVWN9
         QNEZzI81cQE/4qaR28ZVgoTk/RAXACnmdEwwWmB5UiTrUD8Q8WEaHa490wJ6Z36Y9XIr
         hW6VjDHylMqdZAz19CzJCvshwe1JaslYEFL7NYC5PnEN80gutCQ3yBUCewv8mM3DNNFL
         xbYGQRL/nO4kp3jS5jdJt6bBGNTka7TYDn+34/TSP2v5X1H7GJ66m7hWQTEMyPDYdWm3
         PMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739812344; x=1740417144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jbNIFLkQGKx8gMtazppTvQVDaVLm+keOHDU+VX7GYjs=;
        b=VUpJjyNCgrUC48LgX7UX595UgkwFi/h5ao/LlnALrn68E82vtIUM3n1ggxqkVBVUke
         IKbb1H7wYGfByEQBFOxpCzmpyY0WyIdJ7sdsg9YSOVzzLQLd7PDjdzMHIt37lpnsOX7p
         jVafbBHmK04DXD5TolUfQuXYqpm23xlD2LakY+EHVs2uZfjyYfhnSwpJTtkcpRbQ4hs/
         x8WkCg3NpPdzHmX+jTbsdVDon4d/VK8+fKCSNHQPbKg7ZMtjBlrirSIzFo+lVYLcl8GI
         DdQqK9Z0YA0W8Kbuvp7DbCJPcoVx81FGR20NKs7BkWcwL/X4lp8GYQuCmJrGK/WvigYF
         dhKg==
X-Forwarded-Encrypted: i=1; AJvYcCWJyjcwwSe5novt8wLZsrDCdIQ/n5bryky0GF/9ScguLS/fvzEXknGcMBI5H2ZMVHxKguqc4TwrxCBXzp9P@vger.kernel.org, AJvYcCWVJsGrA6bKGcYh3yqtmoYsEq6ARp4KlxfxjMzfF/9NjE3QAGfBHdPQgOjJk8r4W37wOLYG4LaKv06DtBMNEQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfQuZJb8WzmN+1MP8lJHS57afEJvRt2GujZWLmYHLvHcygZRXo
	0k9QXUvDeJV1KbVf6L7TDeNb1Uuhppu0rEL/7U0K3yrCxqRUw98Pj2lMdw/Eqy+Si+g/1O522eV
	3FOtGwuH69IvOxuPsPjEPir8as9Y=
X-Gm-Gg: ASbGnctx6jWio8KO8ojBoe6P2QID84G8RFyd+qMPeAsynccWN8H5sT8WXDWhFUoOhsj
	X5sTR7DIDi35mnKe8adUATVoEoG/r3zDPgVwq9HFfT0U9X1wZPBUZREpTJxBjM5dd8hlmPQCB
X-Google-Smtp-Source: AGHT+IHjy4r+IzmE9EhuRmSMzfEdSQ8U3VGlqITFFstaR8PRZDd3RbzoZ6F7x5rkaVJbCaO78HffFEzUZo9jbKIUiWg=
X-Received: by 2002:a2e:9f54:0:b0:308:f860:7c1 with SMTP id
 38308e7fff4ca-30927b1b22amr29120861fa.30.1739812342599; Mon, 17 Feb 2025
 09:12:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <675d01e9.050a0220.37aaf.00be.GAE@google.com> <67af8747.050a0220.21dd3.004c.GAE@google.com>
 <20250214152358.7ba29d10229e2155c0899774@linux-foundation.org> <CAMgjq7DQm+nwTWMdWQ66WW84O6YnhRQvZEjaY3EeXZ5-iKXo-A@mail.gmail.com>
In-Reply-To: <CAMgjq7DQm+nwTWMdWQ66WW84O6YnhRQvZEjaY3EeXZ5-iKXo-A@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 18 Feb 2025 01:12:04 +0800
X-Gm-Features: AWEUYZlr5OT-vFG04O05Y9RY-JrYRxb2uhKVomssed7apCq-exWeAz-LivZSVcg
Message-ID: <CAMgjq7AqZaRuu+udJd7MyU2n3eF7wKX8bjDugFrdHYd2Lq=EXQ@mail.gmail.com>
Subject: Re: [syzbot] [mm?] [bcachefs?] WARNING in lock_list_lru_of_memcg
To: Andrew Morton <akpm@linux-foundation.org>, kent.overstreet@linux.dev
Cc: syzbot <syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com>, 
	chengming.zhou@linux.dev, hannes@cmpxchg.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, sashal@kernel.org, 
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com, willy@infradead.org, 
	yuzhao@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 12:13=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Sat, Feb 15, 2025 at 7:24=E2=80=AFAM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Fri, 14 Feb 2025 10:11:19 -0800 syzbot <syzbot+38a0cbd267eff2d286ff@=
syzkaller.appspotmail.com> wrote:
> >
> > > syzbot has found a reproducer for the following issue on:
> >
> > Thanks.  I doubt if bcachefs is implicated in this?
> >
> > > HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of http=
s://g..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D148019a45=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc776e555c=
fbdb82d
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D38a0cbd267e=
ff2d286ff
> > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for=
 Debian) 2.40
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12328bf=
8580000
> > >
> > > Downloadable assets:
> > > disk image (non-bootable): https://storage.googleapis.com/syzbot-asse=
ts/7feb34a89c2a/non_bootable_disk-128c8f96.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/a97f78ac821e/vm=
linux-128c8f96.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/f451cf16fc=
9f/bzImage-128c8f96.xz
> > > mounted in repro: https://storage.googleapis.com/syzbot-assets/a7da78=
3f97cf/mount_3.gz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 5459 at mm/list_lru.c:96 lock_list_lru_of_memcg+=
0x39e/0x4d0 mm/list_lru.c:96
> >
> >         VM_WARN_ON(!css_is_dying(&memcg->css));
>
> I'm checking this, when last time this was triggered, it was caused by
> a list_lru user did not initialize the memcg list_lru properly before
> list_lru reclaim started, and fixed by:
> https://lore.kernel.org/all/20241222122936.67501-1-ryncsn@gmail.com/T/
>
> This shouldn't be a big issue, maybe there are leaks that will be
> fixed upon reparenting, and this new added sanity check might be too
> lenient, I'm not 100% sure though.
>
> Unfortunately I couldn't reproduce the issue locally with the
> reproducer yet. will keep the test running and see if it can hit this
> WARN_ON.

So far I am still unable to trigger this VM_WARN_ON using the
reproducer, and I'm seeing many other random crashes.

But after I changed the .config a bit adding more debug configs
(SLAB_FREELIST_HARDENED, DEBUG_PAGEALLOC), following crash showed up
and will be triggered immediately after I start the test:

[ T1242] BUG: unable to handle page fault for address: ffff888054c60000
[ T1242] #PF: supervisor read access in kernel mode
[ T1242] #PF: error_code(0x0000) - not-present page
[ T1242] PGD 19e01067 P4D 19e01067 PUD 19e04067 PMD 7fc5c067 PTE
800fffffab39f060
[ T1242] Oops: Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN PTI
[ T1242] CPU: 1 UID: 0 PID: 1242 Comm: kworker/1:1H Not tainted
6.14.0-rc2-00185-g128c8f96eb86 #2
[ T1242] Hardware name: Red Hat KVM/RHEL-AV, BIOS
1.16.0-4.module+el8.8.0+664+0a3d6c83 04/01/2014
[ T1242] Workqueue: bcachefs_btree_read_complete btree_node_read_work
[ T1242] RIP: 0010:validate_bset_keys+0xae3/0x14f0
[ T6058] bcachefs (loop2): empty btree root xattrs
[ T1242] Code: 49 39 df 0f 87 fc 09 00 00 e8 79 54 a8 fd 41 0f b7 c6
48 8b 4c 24 68 48 8d 04 c1 4c 29 f8 48 c1 e8 03 89 c1 48 89 de 4c 89
ff <f3> 48 a5 48 8b bc 24 c8 00 00 08
[ T1242] RSP: 0018:ffffc900070a72c0 EFLAGS: 00010206
[ T1242] RAX: 000000000000ec0f RBX: ffff888054c20110 RCX: 0000000000006c31
[ T1242] RDX: 0000000000000000 RSI: ffff888054c60000 RDI: ffff888054c5ff90
[ T1242] RBP: ffffc900070a7570 R08: ffff888065e001af R09: 1ffff1100cbc0035
[ T1242] R10: dffffc0000000000 R11: ffffed100cbc0036 R12: ffff888054c2009e
[ T1242] R13: dffffc0000000000 R14: 000000000000ec0f R15: ffff888054c200a0
[ T1242] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000)
knlGS:0000000000000000
[ T1242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ T1242] CR2: ffff888054c60000 CR3: 000000006cea6000 CR4: 00000000000006f0
[ T1242] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ T1242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ T1242] Call Trace:
[ T1242]  <TASK>
[ T1242]  bch2_btree_node_read_done+0x1d20/0x53a0
[ T1242]  btree_node_read_work+0x54d/0xdc0
[ T1242]  process_scheduled_works+0xaf8/0x17f0
[ T1242]  worker_thread+0x89d/0xd60
[ T1242]  kthread+0x722/0x890
[ T1242]  ret_from_fork+0x4e/0x80
[ T1242]  ret_from_fork_asm+0x1a/0x30
[ T1242]  </TASK>
[ T1242] Modules linked in:
[ T1242] ---[ end trace 0000000000000000 ]---
[ T1242] RIP: 0010:validate_bset_keys+0xae3/0x14f0
[ T1242] Code: 49 39 df 0f 87 fc 09 00 00 e8 79 54 a8 fd 41 0f b7 c6
48 8b 4c 24 68 48 8d 04 c1 4c 29 f8 48 c1 e8 03 89 c1 48 89 de 4c 89
ff <f3> 48 a5 48 8b bc 24 c8 00 00 08
[ T1242] RSP: 0018:ffffc900070a72c0 EFLAGS: 00010206
[ T1242] RAX: 000000000000ec0f RBX: ffff888054c20110 RCX: 0000000000006c31
[ T1242] RDX: 0000000000000000 RSI: ffff888054c60000 RDI: ffff888054c5ff90
[ T1242] RBP: ffffc900070a7570 R08: ffff888065e001af R09: 1ffff1100cbc0035
[ T1242] R10: dffffc0000000000 R11: ffffed100cbc0036 R12: ffff888054c2009e
[ T1242] R13: dffffc0000000000 R14: 000000000000ec0f R15: ffff888054c200a0
[ T1242] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000)
knlGS:0000000000000000
[ T1242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ T1242] CR2: ffff888054c60000 CR3: 000000006cea6000 CR4: 00000000000006f0
[ T1242] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ T1242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ T1242] Kernel panic - not syncing: Fatal exception
[ T1242] Kernel Offset: disabled
[ T1242] Rebooting in 86400 seconds..

It's caused by the memmove_u64s_down in validate_bset_keys of
fs/bcachefs/btree_io.c:
-> memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(i) - (u64 *) k)=
;

The bkey_p_next(k) is RSI: ffff888054c60000 and it's causing an out of
border access.
(u64 *) vstruct_end(i) - (u64 *) k is RCX: 0000000000006c31, if added
to RDI this should cause an out of border write as well.

This seems to indicate there is an out of border memory modification?
And maybe it corrupted other subsystems? The slight change to .config
changed the layout so it's causing a fault, maybe previously this just
went on silently.
I don't know much about bcachefs, will be grateful if bcachefs people
could help have a look.
