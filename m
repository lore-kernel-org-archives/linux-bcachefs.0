Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071E63BBEA
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Jun 2024 18:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717699266; cv=none; b=EqfEJ7Z1XrjfL3dId3QwpI20xoEVLnFS3TzA2qMbWJyzq/4MfFTgELzbel4eJ2+e3xifAPyOW/ybWXWOzq7izuFyDX48Vay2kF+oSSouizxoRVvgzpuA5AOFo5RMLcEfm5AF71Hup8g7QJl49g304jMNIaftMj35MvzBlh8DvP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717699266; c=relaxed/simple;
	bh=/BCyzg3l3cXaht8f7ttEEZYpkmnXii/Q/Rh2jOtrMPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZLduahEG1dFBGpEf2/LWaUzKSSloUzEJGV9uGQIb3sSkqoQ75nV776zeENhY58UnKUXA7HcL1w98l05ov+67Dhd7/31SQONlTR5nIQ/k5RHw2yJPqi+vOwsdV5HttiPJ0ZFbmYzqtXLQhitReGb4PUSuFl5sssTkLcZpoOcgKIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jdgnzKa9; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jdgnzKa9"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a66e9eac48fso150699566b.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Jun 2024 11:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717699263; x=1718304063; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PsUzN02Q3GPgeGZWxGrZEmjJwQaMH4/ZhMSZbtnAEe4=;
        b=jdgnzKa9waK6rmqBRy7wJcHqlaabbK/WOsT/NcvIjNm/Cj9LRp+Z0byLq11gA9kbxK
         iIE2pZkTecBPZaBKw5Ew/t1Mkleu7F3MHIqn6P6y198xERXYLzeIULFYWpmhJ+5NIme2
         n8iipNyk4vjLJFTs3A/LZ/rs1PbUbCRMdxtULkLdoj27pzQ7SDGi+j+cXJWt+e9TIKss
         7YJXIaXXUHbRT8lTCdZM5hrtboqeL4wxBWKbFu+LJz4WlKl+ktDKGdT9YrmqLq+BpTNb
         PG0WX3339cBiZEMmGxJu9XoWSboAnw676Ix02FnejagyXabLK6kYui3ezRV5kdfKFqsZ
         FVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717699263; x=1718304063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PsUzN02Q3GPgeGZWxGrZEmjJwQaMH4/ZhMSZbtnAEe4=;
        b=NgcsyK2GUiK2VCX7b3rvlT9jgwJqNris4qWJ4kzhzaD7zWitI33Zk7vlJude4PD1JF
         6e5XryYoKwtEF0dA63917BnJTiGc+ccdPb+J2H0m2ZOsHV7L5XoupWkTKrfyXVPasL2O
         ocsbiBNv9I0K3VZANpU2LTjHm47B8uAdh0W0m73YdgOeS4oyQDxzq/0dixdFbuKyZypf
         XDrxqhaZSWUPHWsLT96d0RHEbAId1IPT/amrPl837UChkvAptJUwePJ1fGg/wV9voRgc
         lxYBUrid7T/2lwbm399E5Ac76RejTFv8Iy3hLWLN7wuxentX8krDokujj4SQQFeF+ZRD
         A6DA==
X-Gm-Message-State: AOJu0Yz8MjMrrlQPRI0N7lP7bxFtuyoefNZqQlWUWNa2zVjah9x2uSx9
	5Ym4f1vKNKR/adKHxP99r7u6Sm9SIPmPy8xUeG6hO45730aJCJNGz3iMggdG55MUZKEWe4MLNFU
	qib+7pCNGwwSgAoqVaXtdKX64BLJXPC2F
X-Google-Smtp-Source: AGHT+IGA+0LNTVM6Zjno/WpHIwubE0ha5NHdsnTdRMfna2RVV+2C2DyGENHfoO/4lbzkvMbKjr0yQ3wNA1bvrhjwmp4=
X-Received: by 2002:a17:906:24d7:b0:a68:c7dc:baec with SMTP id
 a640c23a62f3a-a6cd7a7a654mr29509866b.39.1717699263122; Thu, 06 Jun 2024
 11:41:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
In-Reply-To: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 6 Jun 2024 20:40:50 +0200
Message-ID: <CAGudoHE1WhSSrqKbtCVhdxbPnmjGeb45mUw+gQ_ZEgMsfADu+g@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

So I tried out bcachefs again and it once more fails to complete
parallel creation of 20 mln files -- processes doing the work use cpu
time in the kernel indefinitely.

I'm at 2df0193e62cf887f373995fb8a91068562784adc master (fresh state).

For reasons I don't see I don't get any debug output, so I check what
happens with perf top instead.

Got this:
createtree  1268 [002]   563.063427:      31873   cycles:
        ffffffffb0ed976c check_preemption_disabled+0x2c ([kernel.kallsyms])
        ffffffffb0ed8574 lock_is_held_type+0x64 ([kernel.kallsyms])
        ffffffffb0523d4d bch2_btree_key_cache_scan+0x63d ([kernel.kallsyms]=
)
        ffffffffb006d396 do_shrink_slab+0x176 ([kernel.kallsyms])
        ffffffffb006dd81 shrink_slab+0xd1 ([kernel.kallsyms])
        ffffffffb006946d shrink_node+0x32d ([kernel.kallsyms])
        ffffffffb006b571 do_try_to_free_pages+0xc1 ([kernel.kallsyms])
        ffffffffb006be74 try_to_free_pages+0xf4 ([kernel.kallsyms])
        ffffffffb00d51f9 __alloc_pages_slowpath.constprop.0+0x309
([kernel.kallsyms])
        ffffffffb00d611f __alloc_pages_noprof+0x37f ([kernel.kallsyms])
        ffffffffb00de654 allocate_slab+0x3e4 ([kernel.kallsyms])
        ffffffffb00df283 ___slab_alloc.isra.0+0xb83 ([kernel.kallsyms])
        ffffffffb00df80a __slab_alloc.isra.0+0x4a ([kernel.kallsyms])
        ffffffffb00e0993 kmem_cache_alloc_noprof+0x293 ([kernel.kallsyms])
        ffffffffb0570c8d __bch2_new_inode+0x1d ([kernel.kallsyms])
        ffffffffb057569a __bch2_create+0x8a ([kernel.kallsyms])
        ffffffffb0575c96 bch2_create+0x26 ([kernel.kallsyms])
        ffffffffb016a2e0 lookup_open.isra.0+0x5a0 ([kernel.kallsyms])
        ffffffffb0170894 path_openat+0x304 ([kernel.kallsyms])
        ffffffffb017129c do_filp_open+0xac ([kernel.kallsyms])
        ffffffffb0153a91 do_sys_openat2+0x91 ([kernel.kallsyms])
        ffffffffb0153f03 __x64_sys_openat+0x53 ([kernel.kallsyms])
        ffffffffb0ed09b9 do_syscall_64+0x69 ([kernel.kallsyms])
        ffffffffb1000117 entry_SYSCALL_64_after_hwframe+0x76 ([kernel.kalls=
yms])
                   f7f01 __GI___libc_open+0x51
(/usr/lib/x86_64-linux-gnu/libc.so.6)
        342f3439332f3032 [unknown] ([unknown])

the bcachefs thing is fs/bcachefs/btree_key_cache.c:871

ext4 and btrfs did not have any trouble. Read the old e-mail below for
repro instructions.


On Sun, Nov 5, 2023 at 1:38=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> wr=
ote:
>
> Setup is a 24 core vm + 24G of ram, running debian 12 with top of
> master as of writing this e-mail, commit being:
> commit 1c41041124bd14dd6610da256a3da4e5b74ce6b1 (HEAD -> master,
> origin/master, origin/HEAD)
> Merge: b8cc56d0414e 9fd00df05e81
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Nov 4 16:25:36 2023 -1000
>
>     Merge tag 'i3c/for-6.7' of
> git://git.kernel.org/pub/scm/linux/kernel/git/i3c/linux
>
> I ran into it when trying to poke around at the fine-grained inode hash p=
atch.
>
> Reproduction instructions are here: https://people.freebsd.org/~mjg/fstre=
e.tgz
>
> Running it destabilizes the system after few minutes, for example
> hanging my ssh connection (interestingly running stuff over a serial
> port works fine). hung task detector reports a kernel thread and one
> of the workers, traces at the end of the e-mail.
>
> I can create trees just fine if I limit it to one worker at a time.
> However, traversing them (again 20 workers, each with a dedicated
> tree) once more runs into trouble.
>
> There are no issues when running this against xfs and ext4.
>
> Side note: mkfs.bcachefs warns about xfs being on the volume, but is
> perfectly happy to format an existing bcachefs partition -- perhaps
> this should also ask if it was intended?
>
> traces:
> INFO: task kworker/u48:0:11 blocked for more than 120 seconds.
>       Not tainted 6.6.0+ #386
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u48:0   state:D stack:0     pid:11    tgid:11    ppid:2
>    flags:0x00004000
> Workqueue: btree_update btree_interior_update_work
> Call Trace:
>  <TASK>
>  __schedule+0x3b0/0xaf0
>  ? bch2_path_get+0x5e/0x560
>  ? __pfx_bch2_six_check_for_deadlock+0x10/0x10
>  schedule+0x2e/0xd0
>  six_lock_slowpath.constprop.0+0x10b/0x2e0
>  btree_interior_update_work+0x8a3/0x9e0
>  ? btree_interior_update_work+0x842/0x9e0
>  process_one_work+0x165/0x330
>  worker_thread+0x2f1/0x410
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0xe1/0x110
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x2d/0x50
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1b/0x30
>  </TASK>
>
> INFO: task createtree:3024 blocked for more than 120 seconds.
>       Not tainted 6.6.0+ #386
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:createtree      state:D stack:0     pid:3024  tgid:3024
> ppid:3011   flags:0x00000002
> Call Trace:
>  <TASK>
>  __schedule+0x3b0/0xaf0
>  ? __pfx_bch2_six_check_for_deadlock+0x10/0x10
>  schedule+0x2e/0xd0
>  six_lock_slowpath.constprop.0+0x10b/0x2e0
>  bch2_btree_node_get+0x33d/0x4c0
>  ? bch2_dirent_create+0x238/0x3e0
>  bch2_btree_path_traverse_one+0x212/0x8c0
>  ? bch2_btree_path_traverse_one+0xb2/0x8c0
>  ? bch2_dirent_create+0x238/0x3e0
>  bch2_btree_iter_peek_slot+0x106/0x6d0
>  ? btree_path_get_locks.constprop.0+0x3a/0x150
>  ? bch2_path_get+0x404/0x560
>  ? bch2_dirent_hash+0xd6/0x150
>  ? bch2_dirent_create+0xf6/0x3e0
>  bch2_dirent_create+0x238/0x3e0
>  ? bch2_create_trans+0x4d0/0x6c0
>  bch2_create_trans+0x518/0x6c0
>  ? chacha_block_generic+0x6f/0xb0
>  __bch2_create+0x1be/0x4e0
>  ? bch2_trans_iter_init_outlined+0x112/0x180
>  ? d_splice_alias+0x8e/0x2b0
>  ? bch2_create+0x26/0x60
>  bch2_create+0x26/0x60
>  path_openat+0xe9f/0x11d0
>  do_filp_open+0xb4/0x160
>  ? kmem_cache_alloc+0x15c/0x2b0
>  ? _raw_spin_unlock+0xa/0x30
>  do_sys_openat2+0x91/0xc0
>  __x64_sys_openat+0x6a/0xa0
>  do_syscall_64+0x32/0xf0
>  entry_SYSCALL_64_after_hwframe+0x6e/0x76
> RIP: 0033:0x7fe7b1bdfe01
> RSP: 002b:00007ffee4ae0ea0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 0000000000000042 RCX: 00007fe7b1bdfe01
> RDX: 0000000000000042 RSI: 00007ffee4ae0f30 RDI: 00000000ffffff9c
> RBP: 00007ffee4ae0f30 R08: 0000000000000000 R09: 0000000000000064
> R10: 00000000000001ff R11: 0000000000000202 R12: 0000000000000263
> R13: 00000000000003e8 R14: 00007ffee4ae267c R15: 000055b2c0e97010
>  </TASK>
>
> --
> Mateusz Guzik <mjguzik gmail.com>



--=20
Mateusz Guzik <mjguzik gmail.com>
