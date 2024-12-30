Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFFE25948E;
	Mon, 30 Dec 2024 08:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735548696; cv=none; b=qPB26KAdebkZio0m/MKSbV7B7iBX5zeH527FhoYl/q9lg+48vR5ilxi2TZnYAClcHemmOBRxh89ehZiQA4DRE+K8CvRkOpjTIF1uFzL/h9xGPaXPUEYL5B1qqEAuVM9dmWjVPocq64EFlWy601jXH4kvGP6R9tYs44PMNcltjdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735548696; c=relaxed/simple;
	bh=Q4Bk3Fe1IrVNPuHCYpNij/0xsxRs733sH8jljEGGa+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Aq6v+Z0jM1SuI8dZJ9q1HZrqsHSwwc8zDcm7NtXAS707u0Cl7hAnQDDzLRwX5XGKKImypRS48pG5hlsmQ+0xWQkvSKVbXF1fjKdkyBm6CqXWIoKmNDMNbW2UYGiTrNHdFy04sYucvP/7UDxKceQ7KMp98IUtXTKhHY9/yZob/i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/v2b2wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/v2b2wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D49DC4CEDC;
	Mon, 30 Dec 2024 08:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735548696;
	bh=Q4Bk3Fe1IrVNPuHCYpNij/0xsxRs733sH8jljEGGa+o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=B/v2b2waHfkggmnI6RhIRpcsrOKY7HNFgj1R+3QjRxjOyexc4d76+E855YtY+H9b/
	 zoEQLV4Xo3QOmiX9iJTOkL6vn2Go+g5lwdsi9knIFEtNcjMhRoIXS7MbNOAOy50HAD
	 UUQwGwDmC/VpoDoLB58H/dJfbFxeIZGBI/TfBtsQekpnWVfGMR+osAW1OQhvqyZnOs
	 2jebrH/snaVKJ6bRtAEkxiGCVy9j/8q/lGiqAYpgsYwqCkd1lRpoTxGNHUt5VsUzed
	 FZN9nyMnkRlAdBWepjhreZIdluc9ce9pElecQGsBtzaDETUSzEARcSQB22y3pfv7QX
	 XTgjCYxhwAOEQ==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5401c52000dso10306701e87.3;
        Mon, 30 Dec 2024 00:51:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV/HjQglCK8el8Yk9faFcd+D+yBQ2xKEI4sVlNtdcN8xDIpA9R8I/E1NQS38R4tGDlPLua4sHYIVNs9YQLr@vger.kernel.org, AJvYcCVSAFRm8cuS20qYDDFGno3pByU5xoRc2E+EsT+k+eIduGR6ECD1irC/iwHpKBa0sIL2/RIMwrySqkQ/fJm/@vger.kernel.org, AJvYcCXnykSyIfhz0Wmai9GavWKnPS2MZENcBsAqAh32NymBJO1HibamFpGofbEF6FZD7XnhSixa6JC3fmO5QttsYA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxiAhwZW4SUGsExQFwRkuV7j7L2G4ttxFQYNNHLUPR5POIXb/SC
	6X/OUEyXgJbuv7ASUDJTpSPYMLtsFyTPiJRcXPi61Rn3B6b6QNljQT4LuZsQClIS7Ert8V6s2dS
	azukpKU0ogd4hx7gubpgp7rQxsTQ=
X-Google-Smtp-Source: AGHT+IHx2oTf3QiNiEot20X8hbQONVagxTq3SIXNTpUIw3hBwQBb/H3SaRISgn7ehol++pxBD0D0osJEvT/KW7T6Uhk=
X-Received: by 2002:a05:6512:114d:b0:53e:391c:e983 with SMTP id
 2adb3069b0e04-542295229d3mr12712049e87.3.1735548694444; Mon, 30 Dec 2024
 00:51:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADCV8srK13xwa82Sr9vNWH6ZKTKuPFw0FLcc7Zy9p78TMaxKbA@mail.gmail.com>
In-Reply-To: <CADCV8srK13xwa82Sr9vNWH6ZKTKuPFw0FLcc7Zy9p78TMaxKbA@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 30 Dec 2024 09:51:23 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGk1wcW8_75mja=Z7pnVZ6eZJJWgpHm8TK27oswQN2kFw@mail.gmail.com>
Message-ID: <CAMj1kXGk1wcW8_75mja=Z7pnVZ6eZJJWgpHm8TK27oswQN2kFw@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in poly1305_core_blocks
To: Liebes Wang <wanghaichi0403@gmail.com>, linux-bcachefs@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

(cc linux-bcachefs)



On Mon, 30 Dec 2024 at 07:28, Liebes Wang <wanghaichi0403@gmail.com> wrote:
>
> Dear Linux maintainers and reviewers:
>
> We are reporting a Linux kernel bug titled **KASAN: use-after-free Read in poly1305_core_blocks**, discovered using a modified version of Syzkaller.
>

This looks like a bcachefs problem.


> Linux version: v6.12-rc6:59b723cd2adbac2a34fc8e12c74ae26ae45bf230 (crash is also reproduced in the latest kernel version)
> The test case and kernel config is in attach.
>
> The KASAN report is (The full report is attached):
>
> BUG: KASAN: use-after-free in get_unaligned_le64 include/linux/unaligned.h:28 [inline]
> BUG: KASAN: use-after-free in poly1305_core_blocks lib/crypto/poly1305-donna64.c:64 [inline]
> BUG: KASAN: use-after-free in poly1305_core_blocks+0x404/0x480 lib/crypto/poly1305-donna64.c:32
> Read of size 8 at addr ff11000187440000 by task syz.0.5831/33784
>
> CPU: 0 UID: 0 PID: 33784 Comm: syz.0.5831 Not tainted 6.12.0-rc6 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0xca/0x120 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:377 [inline]
>  print_report+0xcb/0x620 mm/kasan/report.c:488
>  kasan_report+0xbd/0xf0 mm/kasan/report.c:601
>  get_unaligned_le64 include/linux/unaligned.h:28 [inline]
>  poly1305_core_blocks lib/crypto/poly1305-donna64.c:64 [inline]
>  poly1305_core_blocks+0x404/0x480 lib/crypto/poly1305-donna64.c:32
>  crypto_poly1305_update+0x83/0x1e0 crypto/poly1305_generic.c:93
>  bch2_checksum+0x1da/0x2a0 fs/bcachefs/checksum.c:238
>  bch2_btree_node_read_done+0xfa4/0x4e70 fs/bcachefs/btree_io.c:1101
>  btree_node_read_work+0x63e/0xf70 fs/bcachefs/btree_io.c:1327
>  bch2_btree_node_read+0x76c/0xdf0 fs/bcachefs/btree_io.c:1712
>  __bch2_btree_root_read fs/bcachefs/btree_io.c:1753 [inline]
>  bch2_btree_root_read+0x2c5/0x460 fs/bcachefs/btree_io.c:1775
>  read_btree_roots fs/bcachefs/recovery.c:523 [inline]
>  bch2_fs_recovery+0x1db7/0x3c60 fs/bcachefs/recovery.c:853
>  bch2_fs_start+0x2d8/0x610 fs/bcachefs/super.c:1036
>  bch2_fs_get_tree+0xfda/0x15d0 fs/bcachefs/fs.c:2170
>  vfs_get_tree+0x94/0x380 fs/super.c:1814
>  do_new_mount fs/namespace.c:3507 [inline]
>  path_mount+0x6b2/0x1eb0 fs/namespace.c:3834
>  do_mount fs/namespace.c:3847 [inline]
>  __do_sys_mount fs/namespace.c:4057 [inline]
>  __se_sys_mount fs/namespace.c:4034 [inline]
>  __x64_sys_mount+0x283/0x300 fs/namespace.c:4034
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xc1/0x1d0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Feel free to reach out if additional information or clarifications are needed. We hope this report aids in identifying and fixing the bug.
>
> Best regards,
>
> Haichi Wang
>
> Tianjin University
