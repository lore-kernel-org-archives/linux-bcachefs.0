Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6102827473
	for <linux-bcachefs@vger.kernel.org>; Thu, 23 May 2024 08:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716452206; cv=none; b=gOglJuAOoqV+emRkAgSnXRXGvfdWSvFBZYkxhKcctkWRYuFbAvZjpPn3thiSOQt7ihB8ekv0yf7UvYDNZr0t4FCF749AECo0rbYsNrhrNbgVx/9EgiBePHihF4MzkLyjVuL5WxtqMpwj9Uz6jSpMvl5CFTsSCBGzjbPe4R1PSnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716452206; c=relaxed/simple;
	bh=iVB6R+9lup4O53ru9mlVbwoJET6l2j4XPo+Am1zi2Vo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=muib1QvISO+/kVwecYhcCJ5YOZWtcNo4nMACNBkDh8JPK4oFTSf7PoZSAeShw9p84kMCJEVw8Df5tLjoIfG0XJyudQ8oCWynBF0RJXmF7xfKrL6b7TRO4X14AGssw0FgUi5oCkbTZWZTgv1Su01qOXJalhegc+fnYFCAC2tfSMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IVZdZR1h; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IVZdZR1h"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6a04bae512aso20251016d6.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 23 May 2024 01:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716452202; x=1717057002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTaESpYY+wl1YLZy1AQipksxU7lItUKGkm8Z12GjNmY=;
        b=IVZdZR1hPCWVnuVCMf0b728T53316TyF0u6PIwR3gAhqhVmWL1/K/7iDqMyL3s89qy
         N5Ts2k7MWcFBjmhcJaSp15YJzfnolJ0RNab/y/p+Sl5pAJh0uWb9v+87Nw4Qj/uyxjFb
         +c46pVITa9LqLjL9TBJoc62rhKG5eI+fFpe+JpKfnYXrudJ/AUYB0UzGkqvyTkJN14Eu
         jXX4QgVcy/E5upbzC015JQXM6AnBlvyXzjEr3VQaIhYrtptrJ3sq/+tlmLDFWEuNoKOl
         yJqGnLKTYtRoeOpIGQpZDUMXBzuxSe+V+0fwC4+vbul9xaZbcoMJRWHbP3Tu2jPbhxOm
         F34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716452202; x=1717057002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LTaESpYY+wl1YLZy1AQipksxU7lItUKGkm8Z12GjNmY=;
        b=l1uNvl5XMSpDK0t5oxzr6q0Uxg9oj2FDuX0TtO5E3dlB7AoLD+Kws43FF8Fcv2FJNq
         D84iYsj64nqUc2dQzrGlbDdhrHs7ZGyeA0h7axeIhC5u8+ttpJ2f4UWC6wXv7UHCtTa6
         m65hq+iQpbV8mwHUxlVGaknyRxhwOOEVpkqB+pt0VwR5++Xf/nD2z0FV1U58p9JQ7T96
         msIZKh4CVfFuoHsrW3OZbpi9wJ5W0HDJA2iTk9WLOCaJfEM4N7TLtDzKC3RT0gmYp45x
         qlxwONkU9sGLnKf8/h55a1r2xoipvsO3kHvmg1XQxZ2fLMQlratYioPTUNJej83tLKgw
         5ehg==
X-Forwarded-Encrypted: i=1; AJvYcCU7eR6TkHccvWWjIAc+6l6rUMiEWeNYjg0qnts83PatVW9CzZkVoF/QALjR51VBeFSLcN7Ag32SJlFYpqXGIPG50luxa35wYF9cIVoMY+s=
X-Gm-Message-State: AOJu0Yx/x33DDZGc048XW3Ml2TEAnWNkQikPxT787UliWMD4jkMVIiiu
	GqxnqglqG52125EpNAdR4r8Q4XFMDX+4BCBglulUPf8n5LrEe13SW2E7DlKNDz0r4zPdU8T+CqN
	le8Cty0TCSBXbzWtfEuVGCgiyAv8zolnPDCpb
X-Google-Smtp-Source: AGHT+IHQ3gshivlAYHl6QnLWGwSD/PBeni0Jz3oqtj1hucG6MOjHlL2K4xa1KPFbNlbdcW+IxPYVBKQtm5DMHibaBPM=
X-Received: by 2002:a05:6214:418e:b0:69b:12a0:295c with SMTP id
 6a1803df08f44-6ab80907055mr48174716d6.57.1716452202083; Thu, 23 May 2024
 01:16:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000009f9447061833d477@google.com> <jgtxdyooy6zyettrj53qi7s7z5fs5zpnwdjm7eqpihwo32lxzx@v2234ezsba4d>
In-Reply-To: <jgtxdyooy6zyettrj53qi7s7z5fs5zpnwdjm7eqpihwo32lxzx@v2234ezsba4d>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 23 May 2024 10:15:59 +0200
Message-ID: <CAG_fn=WmDCOXxAzaEJtDYuEY4b3Nq99Z7=1-tmwTx9Ox7BG0AA@mail.gmail.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_extent_update_i_size_sectors
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: syzbot <syzbot+eceea46e8838baeeba67@syzkaller.appspotmail.com>, 
	bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 1:49=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> This (and a few others I've looked at) look more likely to be bugs in
> KMSAN, not bcachefs.

Yeah, this is possible if we are missing some initialization.

>
> here, the supposedly uninitialized key was read in from disk, so the key
> couldn't possibly have been legitimately marked uninitialized.

Am I right that the key is supposed to be initialized before the first
call of memcpy_u64s_small() (the _lower_ "Uninit was stored to memory
at:" stack trace)?
Do you have an idea what code performed the actual load of the data from di=
sk?
If that load was done by some assembly routine, we could've easily
missed that - in that case we'll need to annotate it to fix the false
positives.

>
> All the suspicious KMSAN splats I'm looking at involve bkeys, but I'm
> not seeing any other common factors besides that.
>
> On Sat, May 11, 2024 at 01:52:29PM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    dccb07f2914c Merge tag 'for-6.9-rc7-tag' of git://git.k=
ern..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D14c66e24980=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D617171361dd=
3cd47
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Deceea46e8838b=
aeeba67
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for D=
ebian) 2.40
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/fdbc7be30633/d=
isk-dccb07f2.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/a9e4c11aa835/vmli=
nux-dccb07f2.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/43c3a343ea93=
/bzImage-dccb07f2.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+eceea46e8838baeeba67@syzkaller.appspotmail.com
> >
> > bcachefs (loop0): snapshots_read... done
> > bcachefs (loop0): journal_replay... done
> > bcachefs (loop0): resume_logged_ops... done
> > bcachefs (loop0): going read-write
> > bcachefs (loop0): done starting filesystem
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > BUG: KMSAN: uninit-value in bch2_extent_update_i_size_sectors+0x140f/0x=
17d0 fs/bcachefs/io_write.c:237
> >  bch2_extent_update_i_size_sectors+0x140f/0x17d0 fs/bcachefs/io_write.c=
:237
> >  bch2_extent_update+0x4f5/0xac0 fs/bcachefs/io_write.c:314
> >  bch2_write_index_default fs/bcachefs/io_write.c:366 [inline]
> >  __bch2_write_index+0x1653/0x2bd0 fs/bcachefs/io_write.c:520
> >  bch2_write_data_inline fs/bcachefs/io_write.c:1538 [inline]
> >  bch2_write+0x1a13/0x1b40 fs/bcachefs/io_write.c:1606
> >  closure_queue include/linux/closure.h:257 [inline]
> >  closure_call include/linux/closure.h:390 [inline]
> >  bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:468 [inline]
> >  bch2_writepages+0x24a/0x3c0 fs/bcachefs/fs-io-buffered.c:660
> >  do_writepages+0x427/0xc30 mm/page-writeback.c:2612
> >  filemap_fdatawrite_wbc+0x1d8/0x270 mm/filemap.c:397
> >  __filemap_fdatawrite_range+0xe3/0x120 mm/filemap.c:430
> >  sync_file_range+0x316/0x450 fs/sync.c:292
> >  ksys_sync_file_range fs/sync.c:364 [inline]
> >  __do_sys_sync_file_range fs/sync.c:373 [inline]
> >  __se_sys_sync_file_range fs/sync.c:370 [inline]
> >  __x64_sys_sync_file_range+0x15a/0x2a0 fs/sync.c:370
> >  x64_sys_call+0xc90/0x3b50 arch/x86/include/generated/asm/syscalls_64.h=
:278
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Uninit was stored to memory at:
> >  memcpy_u64s_small fs/bcachefs/util.h:511 [inline]
> >  bkey_reassemble fs/bcachefs/bkey.h:505 [inline]
> >  __bch2_bkey_make_mut_noupdate fs/bcachefs/btree_update.h:225 [inline]
> >  __bch2_bkey_get_mut_noupdate fs/bcachefs/btree_update.h:282 [inline]
> >  bch2_bkey_get_mut_noupdate fs/bcachefs/btree_update.h:293 [inline]
> >  bch2_extent_update_i_size_sectors+0x9a9/0x17d0 fs/bcachefs/io_write.c:=
219
> >  bch2_extent_update+0x4f5/0xac0 fs/bcachefs/io_write.c:314
> >  bch2_write_index_default fs/bcachefs/io_write.c:366 [inline]
> >  __bch2_write_index+0x1653/0x2bd0 fs/bcachefs/io_write.c:520
> >  bch2_write_data_inline fs/bcachefs/io_write.c:1538 [inline]
> >  bch2_write+0x1a13/0x1b40 fs/bcachefs/io_write.c:1606
> >  closure_queue include/linux/closure.h:257 [inline]
> >  closure_call include/linux/closure.h:390 [inline]
> >  bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:468 [inline]
> >  bch2_writepages+0x24a/0x3c0 fs/bcachefs/fs-io-buffered.c:660
> >  do_writepages+0x427/0xc30 mm/page-writeback.c:2612
> >  filemap_fdatawrite_wbc+0x1d8/0x270 mm/filemap.c:397
> >  __filemap_fdatawrite_range+0xe3/0x120 mm/filemap.c:430
> >  sync_file_range+0x316/0x450 fs/sync.c:292
> >  ksys_sync_file_range fs/sync.c:364 [inline]
> >  __do_sys_sync_file_range fs/sync.c:373 [inline]
> >  __se_sys_sync_file_range fs/sync.c:370 [inline]
> >  __x64_sys_sync_file_range+0x15a/0x2a0 fs/sync.c:370
> >  x64_sys_call+0xc90/0x3b50 arch/x86/include/generated/asm/syscalls_64.h=
:278
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Uninit was stored to memory at:
> >  memcpy_u64s_small fs/bcachefs/util.h:511 [inline]
> >  bkey_reassemble fs/bcachefs/bkey.h:505 [inline]
> >  btree_key_cache_fill fs/bcachefs/btree_key_cache.c:454 [inline]
> >  bch2_btree_path_traverse_cached_slowpath+0x5f02/0x79f0 fs/bcachefs/btr=
ee_key_cache.c:530
> >  bch2_btree_path_traverse_cached+0xd1a/0x1140
> >  bch2_btree_path_traverse_one+0x737/0x5290 fs/bcachefs/btree_iter.c:115=
5
> >  bch2_btree_path_traverse fs/bcachefs/btree_iter.h:225 [inline]
> >  bch2_btree_iter_peek_slot+0x128c/0x3840 fs/bcachefs/btree_iter.c:2473
> >  __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:549 [inline]
> >  __bch2_bkey_get_mut_noupdate fs/bcachefs/btree_update.h:278 [inline]
> >  bch2_bkey_get_mut_noupdate fs/bcachefs/btree_update.h:293 [inline]
> >  bch2_extent_update_i_size_sectors+0x404/0x17d0 fs/bcachefs/io_write.c:=
219
> >  bch2_extent_update+0x4f5/0xac0 fs/bcachefs/io_write.c:314
> >  bch2_write_index_default fs/bcachefs/io_write.c:366 [inline]
> >  __bch2_write_index+0x1653/0x2bd0 fs/bcachefs/io_write.c:520
> >  bch2_write_data_inline fs/bcachefs/io_write.c:1538 [inline]
> >  bch2_write+0x1a13/0x1b40 fs/bcachefs/io_write.c:1606
> >  closure_queue include/linux/closure.h:257 [inline]
> >  closure_call include/linux/closure.h:390 [inline]
> >  bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:468 [inline]
> >  bch2_writepages+0x24a/0x3c0 fs/bcachefs/fs-io-buffered.c:660
> >  do_writepages+0x427/0xc30 mm/page-writeback.c:2612
> >  filemap_fdatawrite_wbc+0x1d8/0x270 mm/filemap.c:397
> >  __filemap_fdatawrite_range+0xe3/0x120 mm/filemap.c:430
> >  sync_file_range+0x316/0x450 fs/sync.c:292
> >  ksys_sync_file_range fs/sync.c:364 [inline]
> >  __do_sys_sync_file_range fs/sync.c:373 [inline]
> >  __se_sys_sync_file_range fs/sync.c:370 [inline]
> >  __x64_sys_sync_file_range+0x15a/0x2a0 fs/sync.c:370
> >  x64_sys_call+0xc90/0x3b50 arch/x86/include/generated/asm/syscalls_64.h=
:278
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Uninit was created at:
> >  __kmalloc_large_node+0x231/0x370 mm/slub.c:3927
> >  __do_kmalloc_node mm/slub.c:3960 [inline]
> >  __kmalloc_node+0xb10/0x10c0 mm/slub.c:3979
> >  kmalloc_node include/linux/slab.h:648 [inline]
> >  kvmalloc_node+0xc0/0x2d0 mm/util.c:634
> >  kvmalloc include/linux/slab.h:766 [inline]
> >  btree_bounce_alloc fs/bcachefs/btree_io.c:118 [inline]
> >  bch2_btree_node_read_done+0x4e68/0x75e0 fs/bcachefs/btree_io.c:1185
> >  btree_node_read_work+0x8a5/0x1eb0 fs/bcachefs/btree_io.c:1324
> >  bch2_btree_node_read+0x3d42/0x4b50
> >  __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
> >  bch2_btree_root_read+0xa6c/0x13d0 fs/bcachefs/btree_io.c:1772
> >  read_btree_roots+0x454/0xee0 fs/bcachefs/recovery.c:457
> >  bch2_fs_recovery+0x7adb/0x9310 fs/bcachefs/recovery.c:785
> >  bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
> >  bch2_fs_open+0x135f/0x1670 fs/bcachefs/super.c:2102
> >  bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1903
> >  legacy_get_tree+0x114/0x290 fs/fs_context.c:662
> >  vfs_get_tree+0xa7/0x570 fs/super.c:1779
> >  do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
> >  path_mount+0x742/0x1f20 fs/namespace.c:3679
> >  do_mount fs/namespace.c:3692 [inline]
> >  __do_sys_mount fs/namespace.c:3898 [inline]
> >  __se_sys_mount+0x725/0x810 fs/namespace.c:3875
> >  __x64_sys_mount+0xe4/0x150 fs/namespace.c:3875
> >  x64_sys_call+0x2bf4/0x3b50 arch/x86/include/generated/asm/syscalls_64.=
h:166
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > CPU: 1 PID: 6218 Comm: syz-executor.0 Not tainted 6.9.0-rc7-syzkaller-0=
0012-gdccb07f2914c #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 03/27/2024
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup



--
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
