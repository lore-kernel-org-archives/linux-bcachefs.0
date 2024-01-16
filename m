Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0891A581
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 11:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Zu04g9GR"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2cddb0ee311so7431841fa.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 03:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1705403151; x=1706007951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w7aTREyWhwnUgzKoAEJalUbgXBHPKN40xUbLk3dhV6g=;
        b=Zu04g9GRWM0rlREtfo7LNQM1imEJITr/2Lr8YjvT3dVqWwAbSaK5uL4w3rPLlibUJQ
         ayy0/V0eUsdIN7aGpAml2ojgBc4LbthhaYRSgYqNrKjtEoOeAdKeNihRIRWJlhNPhH7u
         NaGOGgMaVXOrITr2IU+fNJrlu/22arXmOCU5q1U2rdx+R5XW36cT1tZK/bPeyguK3xfC
         Yo/vEmgQv6TUkf0VxGSmHLQYi7e/4e6KKC4/PpqU5pSVWi6ESMjQkLMzjFMXn8tGMNok
         FpDUfZjto3/5PJcoyJ5BzBazTtPLktUi/JoD8nzzIu66GaOAHl93Xjs/s6mwBEURKUQd
         xKIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705403151; x=1706007951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w7aTREyWhwnUgzKoAEJalUbgXBHPKN40xUbLk3dhV6g=;
        b=loQJCFOC0JaQuwx9G7z/iApVCaXFHYfyUTOtbP+D7ZI1GZwnA69VkHY4jn5e2z70Rb
         /aIoecpoVvyfHdW2ONTQjl/AtjJec3yDZjd6Tdi2pHSzJnLurTb3qhgdnTLYa3+O5tiH
         6XhGOWFDwKR5QaPLSks/ia0QzjCVcy28lJ/EboMg1wEWvk9c9hdOcd3ZEG2KMg5lD3WN
         p8I+YkGEWJ3R2qDTpyUIAC0/ckdn3WamXC8rkV42OUZBcvXH0fbNcQlvfVKdRi2rYqck
         jlvgWOiMaaA6YP8sGm4qn2b/CXkEiWJmxIwtKxlYP/kmJJkyd3nCHaV8KX1uHZAAEPN9
         Wg1Q==
X-Gm-Message-State: AOJu0YxL/ivvnQMfgchbRkrQxEEqoFA/K1E5x2GW44RHHSaZq089swMV
	P9+ofauKwUpGBRFvzvjGO7nOhn8EVL9PXKHUJpN22QasM2w=
X-Google-Smtp-Source: AGHT+IEMrt9SRYnjFz0c2E/8guJTxtdR17nWNa7cHt6TVORhulxSskk7HD/8PVKt5oY6BT/r8LTqfw==
X-Received: by 2002:a2e:880d:0:b0:2cc:de09:eea9 with SMTP id x13-20020a2e880d000000b002ccde09eea9mr1598304ljh.144.1705403150697;
        Tue, 16 Jan 2024 03:05:50 -0800 (PST)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id fk22-20020a056a003a9600b006dabe67bb85sm8963885pfb.216.2024.01.16.03.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 03:05:50 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-bcachefs@vger.kernel.org
Cc: l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] bcachefs: kvfree bch_fs::snapshots in bch2_fs_snapshots_exit
Date: Tue, 16 Jan 2024 19:05:37 +0800
Message-ID: <20240116110537.1124476-1-glass.su@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bch_fs::snapshots is allocated by kvzalloc in __snapshot_t_mut.
It should be freed by kvfree not kfree.
Or umount will triger:

[  406.829178 ] BUG: unable to handle page fault for address: ffffe7b487148008
[  406.830676 ] #PF: supervisor read access in kernel mode
[  406.831643 ] #PF: error_code(0x0000) - not-present page
[  406.832487 ] PGD 0 P4D 0
[  406.832898 ] Oops: 0000 [#1] PREEMPT SMP PTI
[  406.833512 ] CPU: 2 PID: 1754 Comm: umount Kdump: loaded Tainted: G           OE      6.7.0-rc7-custom+ #90
[  406.834746 ] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
[  406.835796 ] RIP: 0010:kfree+0x62/0x140
[  406.836197 ] Code: 80 48 01 d8 0f 82 e9 00 00 00 48 c7 c2 00 00 00 80 48 2b 15 78 9f 1f 01 48 01 d0 48 c1 e8 0c 48 c1 e0 06 48 03 05 56 9f 1f 01 <48> 8b 50 08 48 89 c7 f6 c2 01 0f 85 b0 00 00 00 66 90 48 8b 07 f6
[  406.837810 ] RSP: 0018:ffffb9d641607e48 EFLAGS: 00010286
[  406.838213 ] RAX: ffffe7b487148000 RBX: ffffb9d645200000 RCX: ffffb9d641607dc4
[  406.838738 ] RDX: 000065bb00000000 RSI: ffffffffc0d88b84 RDI: ffffb9d645200000
[  406.839217 ] RBP: ffff9a4625d00068 R08: 0000000000000001 R09: 0000000000000001
[  406.839650 ] R10: 0000000000000001 R11: 000000000000001f R12: ffff9a4625d4da80
[  406.840055 ] R13: ffff9a4625d00000 R14: ffffffffc0e2eb20 R15: 0000000000000000
[  406.840451 ] FS:  00007f0a264ffb80(0000) GS:ffff9a4e2d500000(0000) knlGS:0000000000000000
[  406.840851 ] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  406.841125 ] CR2: ffffe7b487148008 CR3: 000000018c4d2000 CR4: 00000000000006f0
[  406.841464 ] Call Trace:
[  406.841583 ]  <TASK>
[  406.841682 ]  ? __die+0x1f/0x70
[  406.841828 ]  ? page_fault_oops+0x159/0x470
[  406.842014 ]  ? fixup_exception+0x22/0x310
[  406.842198 ]  ? exc_page_fault+0x1ed/0x200
[  406.842382 ]  ? asm_exc_page_fault+0x22/0x30
[  406.842574 ]  ? bch2_fs_release+0x54/0x280 [bcachefs]
[  406.842842 ]  ? kfree+0x62/0x140
[  406.842988 ]  ? kfree+0x104/0x140
[  406.843138 ]  bch2_fs_release+0x54/0x280 [bcachefs]
[  406.843390 ]  kobject_put+0xb7/0x170
[  406.843552 ]  deactivate_locked_super+0x2f/0xa0
[  406.843756 ]  cleanup_mnt+0xba/0x150
[  406.843917 ]  task_work_run+0x59/0xa0
[  406.844083 ]  exit_to_user_mode_prepare+0x197/0x1a0
[  406.844302 ]  syscall_exit_to_user_mode+0x16/0x40
[  406.844510 ]  do_syscall_64+0x4e/0xf0
[  406.844675 ]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[  406.844907 ] RIP: 0033:0x7f0a2664e4fb

Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/bcachefs/snapshot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 56af937523ff..cdcff4e5ae5c 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -1681,5 +1681,5 @@ int bch2_snapshots_read(struct bch_fs *c)
 
 void bch2_fs_snapshots_exit(struct bch_fs *c)
 {
-	kfree(rcu_dereference_protected(c->snapshots, true));
+	kvfree(rcu_dereference_protected(c->snapshots, true));
 }
-- 
2.43.0

