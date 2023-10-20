Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283DFCDB474
	for <linux-bcachefs@archiver.kernel.org>; Fri, 20 Oct 2023 09:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376523AbjJTJEB (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 20 Oct 2023 05:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376543AbjJTJEA (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 20 Oct 2023 05:04:00 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9642CAB
        for <linux-bcachefs@vger.kernel.org>; Fri, 20 Oct 2023 02:03:58 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-53df747cfe5so782248a12.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 20 Oct 2023 02:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1697792636; x=1698397436; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zigtOv58tnPGQKfdXDSWHrJFKEE0VZ4YQ+LEHnNYUQs=;
        b=ojywdxiW4KMVFFptOcQiYs5mhG2Dss2kfr18p5RC3yhAsfQu2f/4wKy3epn7p51mV1
         P6D10pUCR2BXsS9B2sch/w+dmEWkcqtRP8Fldb6pTh4T4nYxnZG+0pKzmkAF1gxicZ0a
         fHvHyMr/v9MQtneJsPMTIvfggOyzyXUJlm+SM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697792636; x=1698397436;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zigtOv58tnPGQKfdXDSWHrJFKEE0VZ4YQ+LEHnNYUQs=;
        b=G416e6Zi3BvDZCr63zu9Dq+GN9GJPEZTQInFk8qpmQ0WCHExxrvKPr3DEt3WEFsjEu
         EweWu/4CsWyqL6ukOiuI/aRaiim7xudzwkfV7koJt786FF7g3cwCmmFZEGOn67Sl0eO0
         ElBRX9J7iyE123m6CKkmOF0LnRI84L+p2UwutqW2jbDPDlz5StbwYd2Bl5sBwb+oOUxb
         6XQXe7cvSbw6Y6cKY5TVTKyUvhNOx+AH6NbLxJ1jyWYLBNoj4+9G1jqaX+/BZYE08B6h
         BNEaG2ZoERxJbQZZgjt2WB9T5LEULQopuN6JZ8vS5NVDmEy8UdDFq4cADT07PxmstPd4
         +yGg==
X-Gm-Message-State: AOJu0Yy5vGBC8EL+9tSsLJvxHOytfYEffnTETipBfyFAkepYiNOFvdjQ
        UwtiaEjKj2Zj4GPTO0ozK7Xel2/nen4+NrtxGzuvRNQMyDq8yqLmHso=
X-Google-Smtp-Source: AGHT+IFvRL/PHDiOCao/qBCulTDPP5BmLLiK3V40dxLUElDxWepD+8nUQRXC3c8JPbllh3WgafYWehsA5yP+QnjRyfY=
X-Received: by 2002:a05:6402:190d:b0:53e:6da7:72ba with SMTP id
 e13-20020a056402190d00b0053e6da772bamr1286874edz.38.1697792636500; Fri, 20
 Oct 2023 02:03:56 -0700 (PDT)
MIME-Version: 1.0
From:   Daniel J Blueman <daniel@quora.org>
Date:   Fri, 20 Oct 2023 17:03:45 +0800
Message-ID: <CAMVG2sss9S45sCRnV+0nQ2jcd+XTMqYXNZ0FObodhD9kFUhwyg@mail.gmail.com>
Subject: bcachefs KASAN SLAB out of bounds
To:     linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent et al,

Booting bcachefs/master (SHA a180af9d) with a stock Ubuntu 23.04
config plus CONFIG_KASAN=CONFIG_KASAN_VMALLOC=y, I have identified a
minimal and consistent reproducer [1] triggering a KASAN report after
~90s of the fio workload [2].

The report shows a SLAB out of bounds access in connection from IO
uring submission queue entries [3].

I confirmed the report isn't emitted when using ext4 in place of
bcachefs; let me know if you'd like further testing on it.

Thanks,
  Daniel

-- [1]

modprobe brd rd_nr=1 rd_size=1048576
bcachefs format /dev/ram0
mount -t bcachefs /dev/ram0 /mnt
fio workload.fio

-- [2] workload.fio

[global]
group_reporting
ioengine=io_uring
directory=/mnt
size=16m
time_based
runtime=48h
iodepth=256
verify_async=8
bs=4k-64k
norandommap
random_distribution=zipf:0.5
ioengine=io_uring
numjobs=16
rw=randrw

[job1]
direct=1

[job2]
direct=0

-- [3]

BUG: KASAN: slab-out-of-bounds in io_req_local_work_add+0xf0/0x2a0
Read of size 4 at addr ffff888138305218 by task iou-wrk-2702/3275

CPU: 38 PID: 3275 Comm: iou-wrk-2702 Not tainted 6.5.0+ #1
Hardware name: Supermicro AS -3014TS-i/H12SSL-i, BIOS 2.5 09/08/2022
Call Trace:
 <TASK>
 dump_stack_lvl+0x48/0x70
 print_report+0xd2/0x660
 ? __virt_addr_valid+0x103/0x180
 ? srso_alias_return_thunk+0x5/0x7f
 ? kasan_complete_mode_report_info+0x40/0x230
 ? io_req_local_work_add+0xf0/0x2a0
 kasan_report+0xd0/0x120
 ? io_req_local_work_add+0xf0/0x2a0
 __asan_load4+0x8e/0xd0
 io_req_local_work_add+0xf0/0x2a0
 ? __pfx_io_req_local_work_add+0x10/0x10
 io_req_complete_post+0x88/0x120
 io_issue_sqe+0x363/0x6b0
 io_wq_submit_work+0x10c/0x4d0
 io_worker_handle_work+0x494/0xa60
 io_wq_worker+0x3d5/0x660
 ? __pfx_io_wq_worker+0x10/0x10
 ? srso_alias_return_thunk+0x5/0x7f
 ? __kasan_check_write+0x14/0x30
 ? srso_alias_return_thunk+0x5/0x7f
 ? _raw_spin_lock_irq+0x8b/0x100
 ? __pfx__raw_spin_lock_irq+0x10/0x10
 ? srso_alias_return_thunk+0x5/0x7f
 ? __kasan_check_write+0x14/0x30
 ? srso_alias_return_thunk+0x5/0x7f
 ? srso_alias_return_thunk+0x5/0x7f
 ? calculate_sigpending+0x5a/0x70
 ? __pfx_io_wq_worker+0x10/0x10
 ret_from_fork+0x47/0x80
 ? __pfx_io_wq_worker+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
RIP: 0033:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 002b:0000000000000000 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000000 RBX: 00007f752ea36718 RCX: 000055792b721268
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000006
RBP: 00007f752ea36718 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000001
R13: 000055792d883950 R14: 00000000000532ed R15: 000055792d915740
 </TASK>

Allocated by task 2702:
 kasan_save_stack+0x38/0x70
 kasan_set_track+0x25/0x40
 kasan_save_alloc_info+0x1e/0x40
 __kasan_slab_alloc+0x9d/0xa0
 slab_post_alloc_hook+0x5f/0xe0
 kmem_cache_alloc_bulk+0x264/0x3e0
 __io_alloc_req_refill+0x1d8/0x370
 io_submit_sqes+0x549/0xb80
 __do_sys_io_uring_enter+0x968/0x1330
 __x64_sys_io_uring_enter+0x7f/0xa0
 do_syscall_64+0x5b/0x90
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

The buggy address belongs to the object at ffff888138305180
which belongs to the cache io_kiocb of size 224
The buggy address is located 152 bytes inside of        allocated
224-byte region [ffff888138305180, ffff888138305260)

The buggy address belongs to the physical page:
page:00000000f168c2d3 refcount:1 mapcount:0 mapping:0000000000000000
index:0xffff8881383048c0 pfn:0x138304
head:00000000f168c2d3 order:2 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff8881cfb7e001
flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
page_type: 0xffffffff()
raw: 0017ffffc0010200 ffff888126f670c0 dead000000000122 0000000000000000
raw: ffff8881383048c0 000000008033002b 00000001ffffffff ffff8881cfb7e001
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888138305100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888138305180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888138305200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
              ^
 ffff888138305280: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
 ffff888138305300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
-- 
Daniel J Blueman
