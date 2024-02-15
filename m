Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D97E135A7D
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708016069; cv=none; b=JkSe8Z4sMDfQ3zOBCH0e7n6sRecIkPKTqPudah3Xmp+jCU9q2Z/inBqpHRh8VniyyW7Wlb2k8sCDpJvPdtHfuCFXHAGXMaFt/23gBYDBSBg+yOamGKMNRGnd3JTazVjhOoVOMd/z9A/w52gpoXOqlVSjwk1HC+aesjUAztLVMJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708016069; c=relaxed/simple;
	bh=pKmkmQYvDtH14ogUV3CxiYaijYTYsJV+1R2/gHp8mNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCwDUDxSm4aWz4RuwbjTdyjGREOMNGnO74O3DaS29bCigXgGGTXNWgMH7IQ/E1KMWSULKNFnH/rrVV0gq4qMdzgKBkGEhstbmngxz3s+Xvbx2X0rFbnpaCJt2PpiNkdTWUuGzY5M9rHtYk9JI2G5P5/2jLL33nc9vJWj4Wog4Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=STZP06ij; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STZP06ij"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708016066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cy2r2DEV8jxfxwJOwctAJV9YGNcipYjA1gOnyH3MDrQ=;
	b=STZP06ijcs6WI925tiw/QAkt/V+jLWhm0EtkDcCYOL5p1V1Kx6M++exvaP65o8TjY1kMka
	bbUv0vqhZx0dW03NGcXdSamEJkLeEyqA6mjOSWiUe8z+7+ra250l04+xIiSwx1LvDIIzdM
	lU11MByhGYBCggFilDHy5UEfhDZx+Pc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-tUdq89DUOVqNVjxyF7rURg-1; Thu, 15 Feb 2024 11:54:23 -0500
X-MC-Unique: tUdq89DUOVqNVjxyF7rURg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0826F185A782;
	Thu, 15 Feb 2024 16:54:23 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.56])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD0F2492BC6;
	Thu, 15 Feb 2024 16:54:22 +0000 (UTC)
Date: Thu, 15 Feb 2024 11:55:59 -0500
From: Brian Foster <bfoster@redhat.com>
To: Tony Asleson <tasleson@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: kernel oops on bcachefs umount, 6.7 kernel
Message-ID: <Zc5CH7rzhzbrLzyV@bfoster>
References: <CAPmdA5YK_RuKpAtnfFrfcgZZReR2p1Q+A_DOMnFFrYm1QvrYnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPmdA5YK_RuKpAtnfFrfcgZZReR2p1Q+A_DOMnFFrYm1QvrYnQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

cc linux-block

On Thu, Feb 01, 2024 at 03:52:56PM -0600, Tony Asleson wrote:
> Fedora 39 with 6.7 kernel with bcachefs support
> 
> Steps
> 1. I created the bcachefs (using locally compiled git repo
> f15633cce1b79e708e9debc21c7b8772df7c7a29)
> # bcachefs format --replicas=2 /dev/sd[bcdej]
> 2. mounted FS and wrote some files to it
> 3. I removed one of the virtual disk drives from the VM, (/dev/sdj)
> while the VM was running
> 4. I wrote some more data to bcachefs FS
> 5. unmounted the bcachefs FS
> 
> Got the following oops
> 
> ....
> [90806.970165] bcachefs (sdj): error writing journal entry 429: I/O
...
> [90850.012743] umount: attempt to access beyond end of device
>                sdj: rw=6144, sector=8, nr_sectors = 8 limit=0
> [90850.012747] bcachefs (sdj): superblock read error: I/O
> [90850.013664] ------------[ cut here ]------------
> [90850.013666] kernfs: can not remove 'bcachefs', no directory
> [90850.013671] WARNING: CPU: 4 PID: 6892 at fs/kernfs/dir.c:1662
> kernfs_remove_by_name_ns+0xba/0xc0

Hi Tony,

Firstly note that this is a warning, not necessarily an oops or crash.
That aside, I am able to reproduce this pretty easily running a similar
test as above on one of my local VMs.

It looks like the cause of this is that bcachefs creates a
/sys/block/<dev>/bcachefs symlink on each block device associated with
the mount. We attempt to remove the link at unmount time, but the async
device removal has caused the sysfs parent dir to disappear and so the
removal codepath warns about a NULL parent dir/node.

It looks like the warning could be avoided in bcachefs by checking for
whether the parent dir/node still exists at cleanup time, but I'm not
familiar enough with kobj management to say whether that's the
right/best solution. It also looks a little odd to me to see a
/sys/block/<dev>/bcachefs dir when I've not seen any other fs or driver
do such a thing in the block sysfs dir(s).

Any thoughts on this from the block subsystem folks? Is it reasonable to
leave this link around and just fix the removal check, or is another
behavior preferred? Thanks.

Brian


> [90850.013678] Modules linked in: binfmt_misc bcachefs lz4hc_compress
> lz4_compress bcache nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
> nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
> nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill
> ip_set nf_tables nfnetlink vfat fat snd_pcm snd_timer intel_rapl_msr
> snd intel_rapl_common soundcore hv_netvsc hv_utils pcspkr hv_balloon
> joydev fuse loop zram xfs crct10dif_pclmul crc32_pclmul crc32c_intel
> polyval_clmulni serio_raw hv_storvsc polyval_generic scsi_transport_fc
> hyperv_drm hyperv_keyboard hid_hyperv ghash_clmulni_intel sha512_ssse3
> hv_vmbus sha256_ssse3 sha1_ssse3
> [90850.013725] CPU: 4 PID: 6892 Comm: umount Not tainted 6.7.0 #4
> [90850.013727] Hardware name: Microsoft Corporation Virtual
> Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 04/06/2022
> [90850.013728] RIP: 0010:kernfs_remove_by_name_ns+0xba/0xc0
> [90850.013731] Code: bc 00 48 89 ef e8 26 a4 c5 ff 5b b8 fe ff ff ff
> 5d 41 5c 41 5d e9 b1 7c bc 00 0f 0b eb a6 48 c7 c7 20 cf 8e ac e8 66
> 3e bd ff <0f> 0b eb dc 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
> 90 90
> [90850.013733] RSP: 0018:ffffbd6c4cbb7de0 EFLAGS: 00010286
> [90850.013734] RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
> [90850.013736] RDX: 0000000000000002 RSI: 0000000000000027 RDI: 00000000ffffffff
> [90850.013737] RBP: ffff9b2d65fc0000 R08: 0000000000000000 R09: ffffbd6c4cbb7c68
> [90850.013738] R10: 0000000000000003 R11: ffffffffad3443e8 R12: ffffffffc0c910fb
> [90850.013739] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [90850.013740] FS:  00007fe8fbdb6800(0000) GS:ffff9b3427b00000(0000)
> knlGS:0000000000000000
> [90850.013742] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [90850.013743] CR2: 00007ffd7b335f98 CR3: 00000000d6512004 CR4: 0000000000370ef0
> [90850.013746] Call Trace:
> [90850.013748]  <TASK>
> [90850.013749]  ? kernfs_remove_by_name_ns+0xba/0xc0
> [90850.013751]  ? __warn+0x7d/0x130
> [90850.013757]  ? kernfs_remove_by_name_ns+0xba/0xc0
> [90850.013759]  ? report_bug+0x18d/0x1c0
> [90850.013763]  ? srso_alias_return_thunk+0x5/0xfbef5
> [90850.013765]  ? console_unlock+0x74/0x120
> [90850.013769]  ? handle_bug+0x3c/0x80
> [90850.013772]  ? exc_invalid_op+0x13/0x60
> [90850.013774]  ? asm_exc_invalid_op+0x16/0x20
> [90850.013780]  ? kernfs_remove_by_name_ns+0xba/0xc0
> [90850.013783]  __bch2_fs_stop+0xc6/0x280 [bcachefs]
> [90850.013819]  generic_shutdown_super+0x7c/0x110
> [90850.013824]  bch2_kill_sb+0x12/0x20 [bcachefs]
> [90850.013857]  deactivate_locked_super+0x2f/0xb0
> [90850.013860]  cleanup_mnt+0xba/0x150
> [90850.013863]  task_work_run+0x59/0x90
> [90850.013867]  exit_to_user_mode_prepare+0x1e3/0x1f0
> [90850.013871]  syscall_exit_to_user_mode+0x17/0x40
> [90850.013874]  do_syscall_64+0x6c/0xe0
> [90850.013876]  ? srso_alias_return_thunk+0x5/0xfbef5
> [90850.013878]  ? syscall_exit_to_user_mode+0x27/0x40
> [90850.013880]  ? srso_alias_return_thunk+0x5/0xfbef5
> [90850.013882]  ? do_syscall_64+0x6c/0xe0
> [90850.013883]  ? srso_alias_return_thunk+0x5/0xfbef5
> [90850.013885]  ? exc_page_fault+0x7b/0x180
> [90850.013887]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
> [90850.013890] RIP: 0033:0x7fe8fbfd652b
> [90850.013899] Code: c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 f3
> 0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 d1 18 0c 00
> f7 d8
> [90850.013900] RSP: 002b:00007ffd7b337748 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000a6
> [90850.013902] RAX: 0000000000000000 RBX: 000055d8e3eab690 RCX: 00007fe8fbfd652b
> [90850.013903] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000055d8e3eb0010
> [90850.013904] RBP: 00007ffd7b337820 R08: 000055d8e3ea6010 R09: 0000000000000007
> [90850.013905] R10: 0000000000000000 R11: 0000000000000246 R12: 000055d8e3eab790
> [90850.013906] R13: 0000000000000000 R14: 000055d8e3eb0010 R15: 000055d8e3eaffd0
> [90850.013910]  </TASK>
> [90850.013911] ---[ end trace 0000000000000000 ]---
> 
> Please CC as I'm not subscribed to this mailing list
> -Tony
> 
> 

