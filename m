Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDFF1AED5C;
	Tue, 18 Feb 2025 11:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739878878; cv=none; b=RtI4tfGn0QRN1yTkAGK2PwPhiZGh1OkuocecJjtrHvolF7qgWtplxnQ5UMA7rcHT5tDsV3wOAPI2hWy45Bihk1ak8CNd4RoVQ/AuxfUo7wGtNymvC28gKHdza2lSxct7YPVkEVizL2J0ULaXfIx6sHLePTNkYLH0zGAs3t7dLrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739878878; c=relaxed/simple;
	bh=wF8rXvzN2yvfBgACuiO5axNOTcqJ+PdAG+r1ZQvjVUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ejmpqHTFWpGiXE4KpXt96PirQKRA9QD7YqcSYlBKXHo8cwcOMjF7l6mT7Px2mxSpn4A+HvmLKoeP6YS/PHXtmDDfv0N9OHu1m0sHeEkbnwKYgbL/IGDnqO7bVvddPsCD1dyDCg1s7efIQTaJwc99yrNRBS87YKf2RGq4ePZctw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DZLU75sp; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZLU75sp"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-546267ed92fso1646265e87.2;
        Tue, 18 Feb 2025 03:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739878874; x=1740483674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zkRhz6gX6MLEeIL6pMAG4TwyhUjxdr2UTt5I4grD+Dc=;
        b=DZLU75spzw7pM7Tje+Xk01cP23ygESy476YzWccZm6cleKnWdakBo8CQ9DMYoFd0Yz
         PrW5oIIuk1v4Tkxp2V+isc04Vykv+siwfXGSbiKO3tDU1mpfEHlALrrUJM2K5EXKO+Gp
         4blY+tldFAgcYmRssmc093TSEMFQlAjsfX3LbeY5Nr0AE3/gCZxAyKnHut26Vh9R44si
         bMXOUUXvzdKEw1CyB0c99R86gHGCwG1iV7qfNrwowmVqQOl1Qr5kGz8w3bPnk45Mw2Tk
         MNgfQjg39iW5ic/HJu1FhNAyc7MnJEkW/9urwY8uDgkXcnlQHDMFGoMdoYwF009ZF7gP
         bEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739878874; x=1740483674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zkRhz6gX6MLEeIL6pMAG4TwyhUjxdr2UTt5I4grD+Dc=;
        b=sluu7rPAkmlcJPja/Sm4RwnsP9iNEstQIYeWWlGv2uNc22jb3lLOsawpfM9QkXCN3+
         ygLuLmgePZ3f5RUs0G4i0iVXc/BU83NQAyYSMTmBmNdrJujr/dmYtR3nuHrj9llZcIZ1
         K839yyHX5Dcfw+W5EbaCaYDD2mjHqP5JTvKw/mjYhzVsvsdiGpWwY10x3vFGFW5MnW/q
         oyKF0iv7Jytyi4SGYrMm6iFsc+MLLRP8op3zg2mRdn8jPCoMq0UzGJ58aAfiLOYi4Kkm
         VMtr7Pu1Ip8AfeR0CgfAWu08m+aY+ApHpsoJLhAySrrJBZoNZe0D1Nq42ekPY+W9IlPE
         ++Yg==
X-Forwarded-Encrypted: i=1; AJvYcCWaIvnNjtRsdq1qvw+vBBQHgX+ZL9+cAYBlRZmrIXjiZdbe4SO5uoisUEShnDz7cTZH/7HKFvVSdDd2qsZDrg==@vger.kernel.org, AJvYcCXI57g8pAM/NXNN7n/iCOvEPdT+vz5bt5kiswskRcHTMMgwbctA7eYtWIg/Ji3s6G4RhCmUKLCQ0BV/brMD@vger.kernel.org
X-Gm-Message-State: AOJu0YwVwbKtYWsmJ+p67FpRpY4oM6Z1UKaNQC7tGFAsJ3vwgPkM8zSD
	H/Y673Y7LTi9E3qpWpX4ybPBypG1hcBTvBL4ySbBN1Mb57Jm/qbUaiw6Dxa+wjytla3ny/asFUv
	IHAEuqBy6VqCsIfM+XDXtf2GHOrQ=
X-Gm-Gg: ASbGncuTTLTVd68SlCgxBuD7A1KmpfVPVbemv1qesysFRr5kzFaWbaAATlR2N/aY7Ip
	i/MTXy9KS4BH9Rqiawt0Xylrp5Hr/BTvLr1NPpgFw14veYsvOiLAkegWuWTCbeiSHzojdVU2h
X-Google-Smtp-Source: AGHT+IGf4ANLxy5KQQuY+Wbv1CB1BHfHQsZz/lDGDTtONoXmNg2q/oI/TCf+rvuDA1oJCA6DyZcKA4jogZXi2QHu1GM=
X-Received: by 2002:a05:6512:308d:b0:545:1db5:f224 with SMTP id
 2adb3069b0e04-5452fe26543mr2582500e87.11.1739878873716; Tue, 18 Feb 2025
 03:41:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <675d01e9.050a0220.37aaf.00be.GAE@google.com> <67af8747.050a0220.21dd3.004c.GAE@google.com>
 <20250214152358.7ba29d10229e2155c0899774@linux-foundation.org>
 <CAMgjq7DQm+nwTWMdWQ66WW84O6YnhRQvZEjaY3EeXZ5-iKXo-A@mail.gmail.com>
 <CAMgjq7AqZaRuu+udJd7MyU2n3eF7wKX8bjDugFrdHYd2Lq=EXQ@mail.gmail.com> <751557A5-5417-497D-95FF-62E7CFCCDC59@gmail.com>
In-Reply-To: <751557A5-5417-497D-95FF-62E7CFCCDC59@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 18 Feb 2025 19:40:57 +0800
X-Gm-Features: AWEUYZl-n6u-EOjdwmIjdS9USIOkjoSfEwMG28SkMsxrFVmfCq0SfOMnmQUsVQA
Message-ID: <CAMgjq7D_gf6Kcp3e0wLDCboHUHXpjzMsFagC83gqmAn_dvuejQ@mail.gmail.com>
Subject: Re: [syzbot] [mm?] [bcachefs?] WARNING in lock_list_lru_of_memcg
To: Alan Huang <mmpgouride@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kent.overstreet@linux.dev, 
	syzbot <syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com>, 
	chengming.zhou@linux.dev, hannes@cmpxchg.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, sashal@kernel.org, 
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com, willy@infradead.org, 
	yuzhao@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025 at 2:09=E2=80=AFAM Alan Huang <mmpgouride@gmail.com> w=
rote:
>
> On Feb 18, 2025, at 01:12, Kairui Song <ryncsn@gmail.com> wrote:
> >
> > On Mon, Feb 17, 2025 at 12:13=E2=80=AFAM Kairui Song <ryncsn@gmail.com>=
 wrote:
> >>
> >> On Sat, Feb 15, 2025 at 7:24=E2=80=AFAM Andrew Morton <akpm@linux-foun=
dation.org> wrote:
> >>>
> >>> On Fri, 14 Feb 2025 10:11:19 -0800 syzbot <syzbot+38a0cbd267eff2d286f=
f@syzkaller.appspotmail.com> wrote:
> >>>
> >>>> syzbot has found a reproducer for the following issue on:
> >>>
> >>> Thanks.  I doubt if bcachefs is implicated in this?
> >>>
> >>>> HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of htt=
ps://g..
> >>>> git tree:       upstream
> >>>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D148019a4=
580000
> >>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc776e555=
cfbdb82d
> >>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D38a0cbd267=
eff2d286ff
> >>>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils fo=
r Debian) 2.40
> >>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12328b=
f8580000
> >>>>
> >>>> Downloadable assets:
> >>>> disk image (non-bootable): https://storage.googleapis.com/syzbot-ass=
ets/7feb34a89c2a/non_bootable_disk-128c8f96.raw.xz
> >>>> vmlinux: https://storage.googleapis.com/syzbot-assets/a97f78ac821e/v=
mlinux-128c8f96.xz
> >>>> kernel image: https://storage.googleapis.com/syzbot-assets/f451cf16f=
c9f/bzImage-128c8f96.xz
> >>>> mounted in repro: https://storage.googleapis.com/syzbot-assets/a7da7=
83f97cf/mount_3.gz
> >>>>
> >>>> IMPORTANT: if you fix the issue, please add the following tag to the=
 commit:
> >>>> Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
> >>>>
> >>>> ------------[ cut here ]------------
> >>>> WARNING: CPU: 0 PID: 5459 at mm/list_lru.c:96 lock_list_lru_of_memcg=
+0x39e/0x4d0 mm/list_lru.c:96
> >>>
> >>>        VM_WARN_ON(!css_is_dying(&memcg->css));
> >>
> >> I'm checking this, when last time this was triggered, it was caused by
> >> a list_lru user did not initialize the memcg list_lru properly before
> >> list_lru reclaim started, and fixed by:
> >> https://lore.kernel.org/all/20241222122936.67501-1-ryncsn@gmail.com/T/
> >>
> >> This shouldn't be a big issue, maybe there are leaks that will be
> >> fixed upon reparenting, and this new added sanity check might be too
> >> lenient, I'm not 100% sure though.
> >>
> >> Unfortunately I couldn't reproduce the issue locally with the
> >> reproducer yet. will keep the test running and see if it can hit this
> >> WARN_ON.
> >
> > So far I am still unable to trigger this VM_WARN_ON using the
> > reproducer, and I'm seeing many other random crashes.
> >
> > But after I changed the .config a bit adding more debug configs
> > (SLAB_FREELIST_HARDENED, DEBUG_PAGEALLOC), following crash showed up
> > and will be triggered immediately after I start the test:
> >
> > [ T1242] BUG: unable to handle page fault for address: ffff888054c60000
> > [ T1242] #PF: supervisor read access in kernel mode
> > [ T1242] #PF: error_code(0x0000) - not-present page
> > [ T1242] PGD 19e01067 P4D 19e01067 PUD 19e04067 PMD 7fc5c067 PTE
> > 800fffffab39f060
> > [ T1242] Oops: Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN PTI
> > [ T1242] CPU: 1 UID: 0 PID: 1242 Comm: kworker/1:1H Not tainted
> > 6.14.0-rc2-00185-g128c8f96eb86 #2
> > [ T1242] Hardware name: Red Hat KVM/RHEL-AV, BIOS
> > 1.16.0-4.module+el8.8.0+664+0a3d6c83 04/01/2014
> > [ T1242] Workqueue: bcachefs_btree_read_complete btree_node_read_work
> > [ T1242] RIP: 0010:validate_bset_keys+0xae3/0x14f0
> > [ T6058] bcachefs (loop2): empty btree root xattrs
> > [ T1242] Code: 49 39 df 0f 87 fc 09 00 00 e8 79 54 a8 fd 41 0f b7 c6
> > 48 8b 4c 24 68 48 8d 04 c1 4c 29 f8 48 c1 e8 03 89 c1 48 89 de 4c 89
> > ff <f3> 48 a5 48 8b bc 24 c8 00 00 08
> > [ T1242] RSP: 0018:ffffc900070a72c0 EFLAGS: 00010206
> > [ T1242] RAX: 000000000000ec0f RBX: ffff888054c20110 RCX: 0000000000006=
c31
> > [ T1242] RDX: 0000000000000000 RSI: ffff888054c60000 RDI: ffff888054c5f=
f90
> > [ T1242] RBP: ffffc900070a7570 R08: ffff888065e001af R09: 1ffff1100cbc0=
035
> > [ T1242] R10: dffffc0000000000 R11: ffffed100cbc0036 R12: ffff888054c20=
09e
> > [ T1242] R13: dffffc0000000000 R14: 000000000000ec0f R15: ffff888054c20=
0a0
> > [ T1242] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000)
> > knlGS:0000000000000000
> > [ T1242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ T1242] CR2: ffff888054c60000 CR3: 000000006cea6000 CR4: 0000000000000=
6f0
> > [ T1242] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000=
000
> > [ T1242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000=
400
> > [ T1242] Call Trace:
> > [ T1242]  <TASK>
> > [ T1242]  bch2_btree_node_read_done+0x1d20/0x53a0
> > [ T1242]  btree_node_read_work+0x54d/0xdc0
> > [ T1242]  process_scheduled_works+0xaf8/0x17f0
> > [ T1242]  worker_thread+0x89d/0xd60
> > [ T1242]  kthread+0x722/0x890
> > [ T1242]  ret_from_fork+0x4e/0x80
> > [ T1242]  ret_from_fork_asm+0x1a/0x30
> > [ T1242]  </TASK>
> > [ T1242] Modules linked in:
> > [ T1242] ---[ end trace 0000000000000000 ]---
> > [ T1242] RIP: 0010:validate_bset_keys+0xae3/0x14f0
> > [ T1242] Code: 49 39 df 0f 87 fc 09 00 00 e8 79 54 a8 fd 41 0f b7 c6
> > 48 8b 4c 24 68 48 8d 04 c1 4c 29 f8 48 c1 e8 03 89 c1 48 89 de 4c 89
> > ff <f3> 48 a5 48 8b bc 24 c8 00 00 08
> > [ T1242] RSP: 0018:ffffc900070a72c0 EFLAGS: 00010206
> > [ T1242] RAX: 000000000000ec0f RBX: ffff888054c20110 RCX: 0000000000006=
c31
> > [ T1242] RDX: 0000000000000000 RSI: ffff888054c60000 RDI: ffff888054c5f=
f90
> > [ T1242] RBP: ffffc900070a7570 R08: ffff888065e001af R09: 1ffff1100cbc0=
035
> > [ T1242] R10: dffffc0000000000 R11: ffffed100cbc0036 R12: ffff888054c20=
09e
> > [ T1242] R13: dffffc0000000000 R14: 000000000000ec0f R15: ffff888054c20=
0a0
> > [ T1242] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000)
> > knlGS:0000000000000000
> > [ T1242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ T1242] CR2: ffff888054c60000 CR3: 000000006cea6000 CR4: 0000000000000=
6f0
> > [ T1242] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000=
000
> > [ T1242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000=
400
> > [ T1242] Kernel panic - not syncing: Fatal exception
> > [ T1242] Kernel Offset: disabled
> > [ T1242] Rebooting in 86400 seconds..
> >
> > It's caused by the memmove_u64s_down in validate_bset_keys of
> > fs/bcachefs/btree_io.c:
> > -> memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(i) - (u64 *=
) k);
>
>
> Might need this.
>
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index e71b278672b6..fb53174cb735 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -997,7 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, struc=
t btree *b,
>                 }
>  got_good_key:
>                 le16_add_cpu(&i->u64s, -next_good_key);
> -               memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(=
i) - (u64 *) k);
> +               memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(=
i) - (u64 *) bkey_p_next(k));
>                 set_btree_node_need_rewrite(b);
>         }
>  fsck_err:
>

Thanks, but this didn't fix everything. I think the problem is more
complex, syzbot seems to be trying to mount damaged bcachefs (on
purpose I think), so the vstruct_end(i) is already returning an offset
that is out of border.

I retriggered it and print some more debug info: i->_data is
ffff88806d5c00a0, i->u64s is 60928, and the faulting address is
ffff88806d600000.
