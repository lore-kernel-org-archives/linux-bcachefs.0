Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B771CC433EF
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 Nov 2021 22:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CE5361178
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 Nov 2021 22:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhKIWHU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 Nov 2021 17:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKIWHU (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 Nov 2021 17:07:20 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA70C061764
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 Nov 2021 14:04:33 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id o17so327164qtk.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 09 Nov 2021 14:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ehjDEpt3IQuPO8l1Ich2ykvdhPJgbgL8sY2QJyYJMxE=;
        b=eub+0Ttcxa+iXFG9v3lbilKS1cZ2XNxgdcCTVROeslBvSUMeittNPBnU85OlC7UlBQ
         /XxWgE+MdPOWpw4N6/SqN/pMe+vyI8d6GwwWyIpi61xyF2Lr7dSAIuSR/AVyHhSBOLe+
         5whE26ab5R5FKE1wT/brmIzIpWoHp+Vyt4wNDm1BpDxjrPU/9EpYpwVsDHXEkE8Zekvk
         3bN1JT/OdzXGOMQfugogU4+cM70WMSl6+kKBDy5H9SXUKMixS+vuiCo5xL6ja+7Nfxj8
         AbJGGD+86mrrCakHW7UR1PXVlZGiABjWF5YVrP6LUZzVJffC4vBHXMiaGvpg6DZEp7/1
         5bRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ehjDEpt3IQuPO8l1Ich2ykvdhPJgbgL8sY2QJyYJMxE=;
        b=XeouHLr0KKqc5DYQPqColOwBeFbRxYJdIlpsyJ7wAwzEgjfPF7Eqs0DIZcP/GRba/C
         j9qX9hHA93ic5dghADDqNAuOAchjpmiEuj/5AojVWu9/eP65A9PO6e3cWB1DNF1z0iRM
         GXhCuK5232WWM8Ixuq0cTrZYRxVVJ9eopiC0RNcvNGsRysWpMHQcg9m/YMgspfxBKI99
         xiA2eMtDROguhXNqynQCvA1wqhaj1VrgdZSeuhEppxiNzXDjcATAGqNrmd3uIFEZd2Vo
         o3T4TTZcn5dZC5JeP68U+a36Omh1Zgh4/361aqm8yb6g3pHUGRNjhINtJCny5WLh/BVU
         ui7Q==
X-Gm-Message-State: AOAM532dOsoze7u8PzbbR7VkxmQBwdh2CcJoXgYi5d1kc7m6cdPA36DF
        HIGXaDwXVo+WXAAfJmo/IQ==
X-Google-Smtp-Source: ABdhPJwv5RGqjJyCWOl2qDG3vEandvNgP8C2rvy/pna0Mps6xJXRikaf4xa2dIk5FxGfO+OB+EoLzQ==
X-Received: by 2002:ac8:594f:: with SMTP id 15mr12036958qtz.354.1636495472590;
        Tue, 09 Nov 2021 14:04:32 -0800 (PST)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id y8sm13618470qtx.0.2021.11.09.14.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 14:04:31 -0800 (PST)
Date:   Tue, 9 Nov 2021 17:04:30 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     hch@lst.de
Cc:     ming.lei@redhat.com, colyli@suse.de, linux-bcachefs@vger.kernel.org
Subject: bug in bcachefs -> bio_copy_data_iter
Message-ID: <YYrwbksSPdtITbEs@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hey Christoph, got a strange one.

I've got a user that's reporting a bug where we deref a bad ptr in bio_copy_data
-> memcpy, and reverting your patch "block: rewrite bio_copy_data_iter to use
bvec_kmap_local and memcpy_to_bvec" seems to make it go away.

I haven't figured out what's different yet between the two versions (your patch
looks like it should be functionally equivalent), but clearly I'm missing
something... wonder if there might be some relation to the bug you guys hit in
bcache with bvec_virt.

Any ideas?

[  395.978225] BUG: unable to handle page fault for address: ffff9b0b8e600000
[  395.979503] #PF: supervisor read access in kernel mode
[  395.980720] #PF: error_code(0x0000) - not-present page
[  395.981953] PGD 182c01067 P4D 182c01067 PUD 182c05067 PMD 26df23067 PTE 800ffffdb19ff060
[  395.983227] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
[  395.984422] CPU: 3 PID: 10 Comm: kworker/u8:1 Not tainted 5.15.1-00987-g97f33a3143f5 #5
[  395.985700] Hardware name: MSI MS-7982/B150M PRO-VDH (MS-7982), BIOS 3.H0 07/10/2018
[  395.986939] Workqueue: writeback wb_workfn (flush-bcachefs-2)
[  395.988196] RIP: 0010:memcpy_erms (arch/x86/lib/memcpy_64.S:55)
[ 395.989495] Code: cc cc cc cc eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
All code
========
   0:	cc                   	int3
   1:	cc                   	int3
   2:	cc                   	int3
   3:	cc                   	int3
   4:	eb 1e                	jmp    0x24
   6:	0f 1f 00             	nopl   (%rax)
   9:	48 89 f8             	mov    %rdi,%rax
   c:	48 89 d1             	mov    %rdx,%rcx
   f:	48 c1 e9 03          	shr    $0x3,%rcx
  13:	83 e2 07             	and    $0x7,%edx
  16:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  19:	89 d1                	mov    %edx,%ecx
  1b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  1d:	c3                   	ret
  1e:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  24:	48 89 f8             	mov    %rdi,%rax
  27:	48 89 d1             	mov    %rdx,%rcx
  2a:*	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)		<-- trapping instruction
  2c:	c3                   	ret
  2d:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  34:	48 89 f8             	mov    %rdi,%rax
  37:	48 83 fa 20          	cmp    $0x20,%rdx
  3b:	72 7e                	jb     0xbb
  3d:	40 38 fe             	cmp    %dil,%sil

Code starting with the faulting instruction
===========================================
   0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
   2:	c3                   	ret
   3:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   a:	48 89 f8             	mov    %rdi,%rax
   d:	48 83 fa 20          	cmp    $0x20,%rdx
  11:	72 7e                	jb     0x91
  13:	40 38 fe             	cmp    %dil,%sil
[  395.990872] RSP: 0018:ffffad9b800ab760 EFLAGS: 00010286
[  395.992275] RAX: ffff9b0b1b21c000 RBX: 0000000000000200 RCX: 0000000000000e00
[  395.993705] RDX: 0000000000001000 RSI: ffff9b0b8e600000 RDI: ffff9b0b1b21c200
[  395.995042] RBP: ffff9b0a4306c300 R08: 0000000000000e00 R09: 0000000000001000
[  395.996436] R10: 0000000000000200 R11: 0000000000000200 R12: ffff9b0b44b54030
[  395.997880] R13: ffffad9b800ab7a0 R14: ffffad9b800ab7b8 R15: 0000000000001000
[  395.999307] FS:  0000000000000000(0000) GS:ffff9b0ba4f80000(0000) knlGS:0000000000000000
[  396.000697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  396.002065] CR2: ffff9b0b8e600000 CR3: 0000000182210004 CR4: 00000000003706e0
[  396.003544] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  396.004997] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  396.006414] Call Trace:
[  396.007814] bio_copy_data_iter (./include/linux/bio.h:158 block/bio.c:1297)
[  396.009208] bio_copy_data (block/bio.c:1317)
[  396.010536] __bch2_write (fs/bcachefs/io.c:969 fs/bcachefs/io.c:1150)
[  396.011920] ? bch2_writepage_do_io (./include/linux/closure.h:229 fs/bcachefs/fs-io.c:1103)
[  396.013293] bch2_writepage_do_io (./include/linux/closure.h:229 fs/bcachefs/fs-io.c:1103)
[  396.014801] __bch2_writepage (fs/bcachefs/fs-io.c:1246)
[  396.016232] ? __mod_memcg_lruvec_state (mm/memcontrol.c:681)
[  396.017649] write_cache_pages (mm/page-writeback.c:2255)
[  396.019106] ? bch2_page_reservation_get.constprop.0 (fs/bcachefs/fs-io.c:1141)
[  396.020546] bch2_writepages (fs/bcachefs/fs-io.c:1283)
[  396.022013] ? update_load_avg (kernel/sched/fair.c:3619 kernel/sched/fair.c:3856)
[  396.023473] do_writepages (mm/page-writeback.c:2364)
[  396.024943] ? enqueue_task_fair (kernel/sched/fair.c:5626)
[  396.026408] ? psi_task_change (kernel/sched/psi.c:755 kernel/sched/psi.c:817)
[  396.027864] __writeback_single_inode (fs/fs-writeback.c:1616)
[  396.029287] writeback_sb_inodes (fs/fs-writeback.c:1883)
[  396.030724] __writeback_inodes_wb (fs/fs-writeback.c:1951)
[  396.032194] wb_writeback (fs/fs-writeback.c:2055)
[  396.033679] wb_workfn (fs/fs-writeback.c:2209 fs/fs-writeback.c:2237)
[  396.035115] ? __schedule (kernel/sched/core.c:6295)
[  396.036607] process_one_work (kernel/workqueue.c:2297)
[  396.038075] worker_thread (./include/linux/list.h:282 kernel/workqueue.c:2445)
[  396.039552] ? rescuer_thread (kernel/workqueue.c:2387)
[  396.041035] kthread (kernel/kthread.c:319)
[  396.042535] ? set_kthread_struct (kernel/kthread.c:272)
[  396.043967] ret_from_fork (arch/x86/entry/entry_64.S:295)
