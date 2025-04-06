Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF70EACD;
	Sun,  6 Apr 2025 02:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743907392; cv=none; b=rU6JGZPhqFbDEED1/ktU02I3tNWMy9+3PU6itkKJz9wGrtueqtAkdvEg1IrO3Cy2VAnq1vW9l/E5TxEn4GTUsxBlboVzlSP84Yk3NFiOA+FljkIkmfM5prnoobMbYa2gaFDwsWrbqIbeGYabcQNiuYOouS30VmpNI9RmblKt4Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743907392; c=relaxed/simple;
	bh=ZmbQUu1kZzJ0XG9DrLaTzSe6kJRoYKxfHJAfhUqeYPg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=NjrOns4Ku+fZVhkzo2WPnAaz84jBbok9Fe+Xc8ssiBHFpD0W0cMNcVuS79JifmDEiu/0ydSnQE1rW5snf2qJxHvNJMcXAwZRq48HOREmWMju4mtnH+Fs0ve/fXoJ2Bp/SBrXTMbRTY4lmFIzUQpQipYmn0sYR7aqQfSY31KBjcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KFce+HNq; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFce+HNq"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5262475372eso1508673e0c.2;
        Sat, 05 Apr 2025 19:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743907390; x=1744512190; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZmbQUu1kZzJ0XG9DrLaTzSe6kJRoYKxfHJAfhUqeYPg=;
        b=KFce+HNqUUpI83saQNBYtrscxXrVwe9VTzcMxkRM4rCJL3tQS6Bja1j5Xl/68P72VE
         3rJxBsmiELV0Yl3E+mdMNinAuVevBGQTFys5KjwmCbmAkod1axpy475GrJW4VdQvyxdE
         qPkGZ4Z1jDBiJTibxxYfOAzNx5evdg3GCRWQXVY9fETd9cse/pJnzgiRSvh8bnmUSyJ4
         aPUTXi/AIAIeUT6w9HxvLI3t+T14YSNe2dwjMHCvGzrb1Au3ZIozXwl/jEr5Ip0DM+05
         brJ0jc5x7lCn+HZbM7cOopN2UA/tB9CsU+YCSn7Xr6hiy/4WbDIAc6/om0JXUScPJjzL
         L6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743907390; x=1744512190;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZmbQUu1kZzJ0XG9DrLaTzSe6kJRoYKxfHJAfhUqeYPg=;
        b=JM+lwgnkTIE7H2Uy/jfpt1nZliOE/Pnk8M6lCNGwjVoEUPtJdWsYkox6o528UhOeAX
         MxOu0snYkFVbJwL/n2zVC1xTgeWPnK9Z9EkotisZj8WgwnTpAt437zRKuzUG8qSgyP2a
         32AzLmakT7o4UHz0FGbYf/vpZeeNcmObSabwFbmiKGRmeeRDw7PBda0lsnjNXpp258ur
         hyUf8olORJQyjDtOk2YOD4iFS+BnLNTEN3YCV+Pr/dD8dgMXFh3zRKXsBOlag+qJY0/V
         Nk+LK1+ePBHrmgCjGufjiG85cSEvnSnSF7Roh6AIBmaap6AsV3X+LN4GK8m/cv1g0jIo
         6vUA==
X-Forwarded-Encrypted: i=1; AJvYcCUvJUlq4Acph0F62nFWQzRV128z2bnOCvN+LG4TWoGjss1NRBhQdQI9ZCK2ob3XwW53eagcsgPRH0bzWQ7c@vger.kernel.org, AJvYcCXBBdP1RS31ox+xAwqEdqkIik2tt65b29SzS4bL573osGGp9h/im7hrHDBfdPZKl7ep+3fn68aY06NOVKiGYA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8qxEwFiFpK4g+93NhNCDh0WE6AMUAWp0QJf7o2d6iqhOLSbB5
	Jzh7fNPJmHCvnwm7Uz3+AAoQdrb5eV459GgKh78ua6VmDWc8k/ZRQi5xcELTZ4yeMb5QChJ3kEV
	0vj2Ci5tRelExHHHzeWw+LLDaig8=
X-Gm-Gg: ASbGncsmmZ277HDp67JOsMIdtssb39RP/K+4EAW/Y15EFeisvxLf3XvMk2BHk7DxPcq
	uZDQpztIro8fZMTchRh23FygRKoJE4Vnv9+OI+uq0NGOWyx5KMS2sSQojvKgozeFVh7c9n1b2oL
	1so/MgmhP+7nwqae1Sgz0SWCHvJKQ=
X-Google-Smtp-Source: AGHT+IGW4Gslde0VIbih2ZVG6n9p42dvdWH7mmAQ3PQ6Nc7lvWKCaEagJyJ8o01q+sOKkswG/5k391LXfA1JVZ57NyE=
X-Received: by 2002:a05:6122:7cd:b0:520:5a87:66eb with SMTP id
 71dfb90a1353d-52765c51e8dmr5076057e0c.3.1743907389648; Sat, 05 Apr 2025
 19:43:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Hui Guo <guohui.study@gmail.com>
Date: Sun, 6 Apr 2025 10:42:58 +0800
X-Gm-Features: ATxdqUFnlm0gWvYpm4wP3t2xJvaWpr4YHzPnVx9o5rmH6Pk3s-1IQV0IkK6eOf4
Message-ID: <CAHOo4gLPB_crF_TV3zXXNRJ7_DMaS-LGDPwnC0KeEAPA9Ofw+g@mail.gmail.com>
Subject: WARNING in bch2_dev_free
To: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hi Kernel Maintainers,
we found a crash "WARNING in bch2_dev_free" in upstream, the detailed
information is as follows:

HEAD Commit: 9f867ba24d3665d9ac9d9ef1f51844eb4479b291
kernel config: https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/main/9f867ba24d3665d9ac9d9ef1f51844eb4479b291/.config

console output:
https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/main/9f867ba24d3665d9ac9d9ef1f51844eb4479b291/0a9dd8e75f0f178fec81b7793432b6246c869988/repro.log
repro report: https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/main/9f867ba24d3665d9ac9d9ef1f51844eb4479b291/0a9dd8e75f0f178fec81b7793432b6246c869988/repro.report
syz reproducer:
https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/main/9f867ba24d3665d9ac9d9ef1f51844eb4479b291/0a9dd8e75f0f178fec81b7793432b6246c869988/repro.prog
c reproducer: https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/main/9f867ba24d3665d9ac9d9ef1f51844eb4479b291/0a9dd8e75f0f178fec81b7793432b6246c869988/repro.cprog

Please let me know if there is anything I can help with.
Best,
Hui Guo

This is the report log.
=============================================================================================
------------[ cut here ]------------
WARNING: CPU: 2 PID: 39261 at fs/bcachefs/super.c:1229
bch2_dev_free+0x27b/0x2d0
data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:1229
Modules linked in:
CPU: 2 UID: 0 PID: 39261 Comm: syz.22.217 Not tainted
6.14.0-13408-g9f867ba24d36 #1 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:bch2_dev_free+0x27b/0x2d0
data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:1229
Code: e3 02 89 de e8 76 7c 65 fd 84 db 0f 84 df fe ff ff e9 cd fe ff
ff e8 a4 81 65 fd 90 0f 0b 90 e9 e6 fd ff ff e8 96 81 65 fd 90 <0f> 0b
90 e9 b1 fd ff ff 4c 89 f7 e8 b5 44 c9 fd e9 07 fe ff ff e8
RSP: 0018:ffffc900040ef210 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff8453d31c
RDX: ffff88802a070000 RSI: ffffffff8453d56a RDI: 0000000000000001
RBP: ffff8880326c6000 R08: 00000000fffffffc R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880326c60c0
R13: ffffc900040ef368 R14: 0000000000000000 R15: 0000000000000000
FS: 00007fb1a3364640(0000) GS:ffff8880cf059000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc315791fc8 CR3: 0000000040d9c000 CR4: 0000000000350ef0
Call Trace:
<TASK>
__bch2_dev_alloc+0xa56/0xe10
data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:1398
bch2_dev_alloc+0xba/0x170
data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:1424
bch2_fs_alloc+0x1b7d/0x2430
data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:969
bch2_fs_open+0x92c/0x1110
data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:2219
bch2_fs_get_tree+0x10d0/0x1770
data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/fs.c:2172
vfs_get_tree+0x93/0x340
data/ghui/docker_data/linux_kernel/upstream/linux/fs/super.c:1759
do_new_mount data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3879
[inline]
path_mount+0x6b0/0x1eb0
data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4206
do_mount data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4219
[inline]
__do_sys_mount data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4430
[inline]
__se_sys_mount data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4407
[inline]
__x64_sys_mount+0x27b/0x300
data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4407
do_syscall_x64 data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/syscall_64.c:63
[inline]
do_syscall_64+0xcb/0x250
data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/syscall_64.c:94
entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb1a259fdfe
Code: 48 c7 c0 ff ff ff ff eb aa e8 5e 20 00 00 66 2e 0f 1f 84 00 00
00 00 00 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb1a3363da8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 000000000000fe88 RCX: 00007fb1a259fdfe
RDX: 000000002000fec0 RSI: 000000002000ff00 RDI: 00007fb1a3363e00
RBP: 00007fb1a3363e40 R08: 00007fb1a3363e40 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000002000fec0
R13: 000000002000ff00 R14: 00007fb1a3363e00 R15: 000000002000ff40
</TASK>
