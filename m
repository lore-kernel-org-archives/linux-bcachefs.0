Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96743FE51
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 Feb 2024 21:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706824392; cv=none; b=Hz4rPoeNWpuB9FfORyNqy53ugEGD9F3GKp9Wn47gJh7C/XcK5H62wEOCFqhI5nE+mbSvSunWTrngbhXAvnQfuAeLiO3re3jKBDkPCjo0U3XRvdNufzKRrEST09pW+68J4Kz+sCCp0o87igBS089s3FtScgYpCEWx1bfMDUGJySY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706824392; c=relaxed/simple;
	bh=l+SoXBZLPTnCAjkxAAaLilBYw6lZ6Uv46aecDUIIURY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=BAIQoIAbj63+qqAy4dcIx9nkj7o/OmM4yOczhrIeehDrp11rMBynxxM8zRCPqIWwAu7YwG4mhIn0V6qA8ZzM9HLH7pQcdAoxzcwU3LDs+ikgF5qAJy4u3f19uzf/STHP4eZjrRlRvOdqERp+wa6LFPz3yX2+p+oSiKoYTMc+9yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MICTwjqL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MICTwjqL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706824389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=vbeOqtk8vHRLpOg9NigOuzOBoOmJmW/4BrpQv9aZ2NA=;
	b=MICTwjqLZzA0oQndErZmaOt3fjC0ogJLo6VOkHkZg1bwsuXatXnKQcdMCJAF03l3O9DmGI
	QKZqwdcb+DCnuu3QqjAD13Qjvl8FfCS5vvrYCGN+BUK0D6yYRv7C/mWPCYPyULQsoHVmRO
	+yyZwARaRpWQrSztk3eipfDq0N7tSQg=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-0TC3mKIfMoWzRFyIEjUbNA-1; Thu, 01 Feb 2024 16:53:08 -0500
X-MC-Unique: 0TC3mKIfMoWzRFyIEjUbNA-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-214cbff137cso1330615fac.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 01 Feb 2024 13:53:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706824387; x=1707429187;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vbeOqtk8vHRLpOg9NigOuzOBoOmJmW/4BrpQv9aZ2NA=;
        b=MXi15giBPxjr7Wx1KcaiARXH0pNqgP26ps4D2gO2O/509YZ3mtkEGg207fp6YPY39t
         tXj4niCv3zZviIs4GgXr3/QKxE+c9FdhLn+WxhDZpa/UEGtjGbZZ/0PNABvgjwlNf1bv
         A0UdoNanzL3EB+WzOAwyaDc7xfkOqL/FZwae9XpItzxc8gOI7UNi71w6Hir4/Pw9pZmY
         rdrTaZ2dLm7kwQyJ6+lZY2fTpun+32lle8/k2E8Ohw1ZecYQtgvmkCV58nwZWnHMVMYJ
         CY4JW4OG58Z0kMRK3uwYe9aAY/XWd/d7kjeqUJU5I3UVi+DgdOTP93mj8LzMnrmYVw28
         V01A==
X-Gm-Message-State: AOJu0YyRaTmSxQnmNc3oD2xzTvpQ2lAkWwJIMlvbsKzvtbqb3Z5W/267
	PIS7Hns6N6r4rYZyS2OagZoM3veBIeMyMqrDt+Jymgmt0sZyTXHglkMBLtGPJom0Fxb4HkECmPS
	mVFoZVYJfyXevkd0esdfTa1jO8tFbzIVO7VYr/DZjPAAwK7ObgDjg7G2S+yu//mxgPyQzMwrc1f
	TyUWimlG38nwyiJcFwQb+MHkigpsJ8gZ/8IMEABtJLvC5H97SOig==
X-Received: by 2002:a05:6870:d8d3:b0:210:d5a5:7d41 with SMTP id of19-20020a056870d8d300b00210d5a57d41mr7159412oac.45.1706824387506;
        Thu, 01 Feb 2024 13:53:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFWN6rPT/uVV3wxf3JOxgm/HASQScU3d5IkGGnuyPL4aKryPRNIJjsylWG1GPq4uaXmciMvcUzPh/OwrNBgpUo=
X-Received: by 2002:a05:6870:d8d3:b0:210:d5a5:7d41 with SMTP id
 of19-20020a056870d8d300b00210d5a57d41mr7159393oac.45.1706824387140; Thu, 01
 Feb 2024 13:53:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Tony Asleson <tasleson@redhat.com>
Date: Thu, 1 Feb 2024 15:52:56 -0600
Message-ID: <CAPmdA5YK_RuKpAtnfFrfcgZZReR2p1Q+A_DOMnFFrYm1QvrYnQ@mail.gmail.com>
Subject: kernel oops on bcachefs umount, 6.7 kernel
To: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fedora 39 with 6.7 kernel with bcachefs support

Steps
1. I created the bcachefs (using locally compiled git repo
f15633cce1b79e708e9debc21c7b8772df7c7a29)
# bcachefs format --replicas=2 /dev/sd[bcdej]
2. mounted FS and wrote some files to it
3. I removed one of the virtual disk drives from the VM, (/dev/sdj)
while the VM was running
4. I wrote some more data to bcachefs FS
5. unmounted the bcachefs FS

Got the following oops

....
[90806.970165] bcachefs (sdj): error writing journal entry 429: I/O
[90808.112301] bcachefs (sdj): error writing journal entry 430: I/O
[90808.122558] kworker/1:1H: attempt to access beyond end of device
               sdj: rw=137217, sector=18584, nr_sectors = 16 limit=0
[90808.122565] bcachefs (sdj): error writing journal entry 430: I/O
[90809.200254] bcachefs (sdj): error writing journal entry 431: I/O
[90810.287776] bcachefs (sdj): error writing journal entry 432: I/O
[90810.298269] kworker/1:1H: attempt to access beyond end of device
               sdj: rw=137217, sector=18600, nr_sectors = 16 limit=0
[90810.298274] bcachefs (sdj): error writing journal entry 432: I/O
[90811.439700] bcachefs (sdj): error writing journal entry 433: I/O
[90811.450090] kworker/1:1H: attempt to access beyond end of device
               sdj: rw=137217, sector=18616, nr_sectors = 16 limit=0
[90811.450094] bcachefs (sdj): error writing journal entry 433: I/O
[90812.528102] bcachefs (sdj): error writing journal entry 434: I/O
[90812.538847] kworker/1:1H: attempt to access beyond end of device
               sdj: rw=137217, sector=18632, nr_sectors = 16 limit=0
[90812.538854] bcachefs (sdj): error writing journal entry 434: I/O
[90813.616108] bcachefs (sdj): error writing journal entry 435: I/O
[90813.627032] kworker/1:1H: attempt to access beyond end of device
               sdj: rw=137217, sector=18648, nr_sectors = 16 limit=0
[90813.627043] bcachefs (sdj): error writing journal entry 435: I/O
[90814.768088] bcachefs (sdj): error writing journal entry 436: I/O
[90816.112053] bcachefs (sdj): error writing journal entry 437: I/O
[90816.114579] kworker/1:1H: attempt to access beyond end of device
               sdj: rw=137217, sector=18664, nr_sectors = 16 limit=0
[90816.114584] bcachefs (sdj): error writing journal entry 437: I/O
[90817.264105] bcachefs (sdj): error writing journal entry 438: I/O
[90817.276368] kworker/2:0H: attempt to access beyond end of device
               sdj: rw=137217, sector=18680, nr_sectors = 16 limit=0
[90817.276373] bcachefs (sdj): error writing journal entry 438: I/O
[90849.997509] bcachefs (sdj): error writing journal entry 439: I/O
[90850.010057] kworker/1:1H: attempt to access beyond end of device
               sdj: rw=137217, sector=18696, nr_sectors = 8 limit=0
[90850.010062] bcachefs (sdj): error writing journal entry 439: I/O
[90850.012743] umount: attempt to access beyond end of device
               sdj: rw=6144, sector=8, nr_sectors = 8 limit=0
[90850.012747] bcachefs (sdj): superblock read error: I/O
[90850.013664] ------------[ cut here ]------------
[90850.013666] kernfs: can not remove 'bcachefs', no directory
[90850.013671] WARNING: CPU: 4 PID: 6892 at fs/kernfs/dir.c:1662
kernfs_remove_by_name_ns+0xba/0xc0
[90850.013678] Modules linked in: binfmt_misc bcachefs lz4hc_compress
lz4_compress bcache nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill
ip_set nf_tables nfnetlink vfat fat snd_pcm snd_timer intel_rapl_msr
snd intel_rapl_common soundcore hv_netvsc hv_utils pcspkr hv_balloon
joydev fuse loop zram xfs crct10dif_pclmul crc32_pclmul crc32c_intel
polyval_clmulni serio_raw hv_storvsc polyval_generic scsi_transport_fc
hyperv_drm hyperv_keyboard hid_hyperv ghash_clmulni_intel sha512_ssse3
hv_vmbus sha256_ssse3 sha1_ssse3
[90850.013725] CPU: 4 PID: 6892 Comm: umount Not tainted 6.7.0 #4
[90850.013727] Hardware name: Microsoft Corporation Virtual
Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 04/06/2022
[90850.013728] RIP: 0010:kernfs_remove_by_name_ns+0xba/0xc0
[90850.013731] Code: bc 00 48 89 ef e8 26 a4 c5 ff 5b b8 fe ff ff ff
5d 41 5c 41 5d e9 b1 7c bc 00 0f 0b eb a6 48 c7 c7 20 cf 8e ac e8 66
3e bd ff <0f> 0b eb dc 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
90 90
[90850.013733] RSP: 0018:ffffbd6c4cbb7de0 EFLAGS: 00010286
[90850.013734] RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
[90850.013736] RDX: 0000000000000002 RSI: 0000000000000027 RDI: 00000000ffffffff
[90850.013737] RBP: ffff9b2d65fc0000 R08: 0000000000000000 R09: ffffbd6c4cbb7c68
[90850.013738] R10: 0000000000000003 R11: ffffffffad3443e8 R12: ffffffffc0c910fb
[90850.013739] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[90850.013740] FS:  00007fe8fbdb6800(0000) GS:ffff9b3427b00000(0000)
knlGS:0000000000000000
[90850.013742] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[90850.013743] CR2: 00007ffd7b335f98 CR3: 00000000d6512004 CR4: 0000000000370ef0
[90850.013746] Call Trace:
[90850.013748]  <TASK>
[90850.013749]  ? kernfs_remove_by_name_ns+0xba/0xc0
[90850.013751]  ? __warn+0x7d/0x130
[90850.013757]  ? kernfs_remove_by_name_ns+0xba/0xc0
[90850.013759]  ? report_bug+0x18d/0x1c0
[90850.013763]  ? srso_alias_return_thunk+0x5/0xfbef5
[90850.013765]  ? console_unlock+0x74/0x120
[90850.013769]  ? handle_bug+0x3c/0x80
[90850.013772]  ? exc_invalid_op+0x13/0x60
[90850.013774]  ? asm_exc_invalid_op+0x16/0x20
[90850.013780]  ? kernfs_remove_by_name_ns+0xba/0xc0
[90850.013783]  __bch2_fs_stop+0xc6/0x280 [bcachefs]
[90850.013819]  generic_shutdown_super+0x7c/0x110
[90850.013824]  bch2_kill_sb+0x12/0x20 [bcachefs]
[90850.013857]  deactivate_locked_super+0x2f/0xb0
[90850.013860]  cleanup_mnt+0xba/0x150
[90850.013863]  task_work_run+0x59/0x90
[90850.013867]  exit_to_user_mode_prepare+0x1e3/0x1f0
[90850.013871]  syscall_exit_to_user_mode+0x17/0x40
[90850.013874]  do_syscall_64+0x6c/0xe0
[90850.013876]  ? srso_alias_return_thunk+0x5/0xfbef5
[90850.013878]  ? syscall_exit_to_user_mode+0x27/0x40
[90850.013880]  ? srso_alias_return_thunk+0x5/0xfbef5
[90850.013882]  ? do_syscall_64+0x6c/0xe0
[90850.013883]  ? srso_alias_return_thunk+0x5/0xfbef5
[90850.013885]  ? exc_page_fault+0x7b/0x180
[90850.013887]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[90850.013890] RIP: 0033:0x7fe8fbfd652b
[90850.013899] Code: c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 f3
0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 d1 18 0c 00
f7 d8
[90850.013900] RSP: 002b:00007ffd7b337748 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[90850.013902] RAX: 0000000000000000 RBX: 000055d8e3eab690 RCX: 00007fe8fbfd652b
[90850.013903] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000055d8e3eb0010
[90850.013904] RBP: 00007ffd7b337820 R08: 000055d8e3ea6010 R09: 0000000000000007
[90850.013905] R10: 0000000000000000 R11: 0000000000000246 R12: 000055d8e3eab790
[90850.013906] R13: 0000000000000000 R14: 000055d8e3eb0010 R15: 000055d8e3eaffd0
[90850.013910]  </TASK>
[90850.013911] ---[ end trace 0000000000000000 ]---

Please CC as I'm not subscribed to this mailing list
-Tony

