Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7CEC4332F
	for <linux-bcachefs@archiver.kernel.org>; Sun,  5 Nov 2023 19:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjKET57 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 14:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjKET56 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 14:57:58 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF33DD
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 11:57:54 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6d261cb07dcso2352543a34.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 Nov 2023 11:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699214274; x=1699819074; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YZPAk6iyhT1Dhmz+MdKUJ89K+opb912pEsWnYIv8/w8=;
        b=BwsPvU5wcFV2CXpm9NXvRrxCft9lvbOYgUxk8Z9C4aqzgl3q5z1xf4TkL7zCwNog9Z
         1kMJAd3RM1vSJ48sauQtRUYUqzRocgkWFaQ7k0ayrZwoEmfjriLMqKtdnF96uD8NhlUT
         0+zeG7IXMcqE3p/HXybZrVtwy4nlj5W8LzGYoeOKAbCbBRLGK2fmIIh2mK5scMddp00q
         8v4Zt6VNs/jJXPUk6QSHDVI5h7JZKRnDYMW2asQeE0lZwSNTUEZrmYDDxnIIlU33LKm2
         E1rw08Ey+hbc3tNUajVqu5sV5Ap7Anztoz4jYz6MvlhDvI9nHKxhNxlvcnyexGv1yxcD
         +1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699214274; x=1699819074;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YZPAk6iyhT1Dhmz+MdKUJ89K+opb912pEsWnYIv8/w8=;
        b=FOQWm1gWSAJAWSlGN9s+lCeiC7JWfMWHJJK0FSQAl7eEjMCIjUvkqKNMg0oHy2TkXj
         D/52CdNQfts7aSjrdbm1xsMSntXngzLjHX5Qm6Po0CsLTFhsT9dHKjTcF6mJA5r6wxQe
         a+23P1X7vC8LOtQigVXeHg6KtqTqriVTaXgOsMDIeg+CtFVp/LAHhMpqCz+v1FL9Ok3t
         rPaQikZt51o4OzMn58xx5NrtC8+GbyTcTE+Gdin3GS0bYGHnjGqBmYiAMSt3N5n6lQyh
         +uMuMXVwDTPtkWENl9l51q2LatHYpa9+SA4F9w9k00F/FKQuy3nTN23QY9q67oJwyPzD
         EuCA==
X-Gm-Message-State: AOJu0YxU8Xz/fH0N3RoH3RU8ufQfDjAqgvlqwr1aa7sM1TQKpgmZYvpr
        y3xN40AdWAt3Q4YzVJ8JV+DWqlcjHe5IYq9KOfU=
X-Google-Smtp-Source: AGHT+IHd+JwGc/drNAzG9lvlDXXpKZ2kzSQB/VTJAmG/4eXwrTBCQ7F1oXmxQEzIftsWhhibUl4cpFJLMvSnnjl5llk=
X-Received: by 2002:a05:6830:310f:b0:6d2:e1fc:f387 with SMTP id
 b15-20020a056830310f00b006d2e1fcf387mr28743397ots.4.1699214273809; Sun, 05
 Nov 2023 11:57:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:7f8f:0:b0:4f0:1250:dd51 with HTTP; Sun, 5 Nov 2023
 11:57:53 -0800 (PST)
In-Reply-To: <20231105162630.q25p2vz2egh7jb43@moria.home.lan>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <20231105162630.q25p2vz2egh7jb43@moria.home.lan>
From:   Mateusz Guzik <mjguzik@gmail.com>
Date:   Sun, 5 Nov 2023 20:57:53 +0100
Message-ID: <CAGudoHFSpfiJYKf1RtEp1H80vne+JpiSonorwD4N5YoAM8Sn3w@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> On Sun, Nov 05, 2023 at 01:38:49PM +0100, Mateusz Guzik wrote:
>> Setup is a 24 core vm + 24G of ram, running debian 12 with top of
>> master as of writing this e-mail, commit being:
>> commit 1c41041124bd14dd6610da256a3da4e5b74ce6b1 (HEAD -> master,
>> origin/master, origin/HEAD)
>> Merge: b8cc56d0414e 9fd00df05e81
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Sat Nov 4 16:25:36 2023 -1000
>>
>>     Merge tag 'i3c/for-6.7' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/i3c/linux
>>
>> I ran into it when trying to poke around at the fine-grained inode hash
>> patch.
>>
>> Reproduction instructions are here:
>> https://people.freebsd.org/~mjg/fstree.tgz
>>
>> Running it destabilizes the system after few minutes, for example
>> hanging my ssh connection (interestingly running stuff over a serial
>> port works fine). hung task detector reports a kernel thread and one
>> of the workers, traces at the end of the e-mail.
>>
>> I can create trees just fine if I limit it to one worker at a time.
>> However, traversing them (again 20 workers, each with a dedicated
>> tree) once more runs into trouble.
>>
>> There are no issues when running this against xfs and ext4.
>>
>> Side note: mkfs.bcachefs warns about xfs being on the volume, but is
>> perfectly happy to format an existing bcachefs partition -- perhaps
>> this should also ask if it was intended?
>>
>> traces:
>> INFO: task kworker/u48:0:11 blocked for more than 120 seconds.
>>       Not tainted 6.6.0+ #386
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:kworker/u48:0   state:D stack:0     pid:11    tgid:11    ppid:2
>>    flags:0x00004000
>> Workqueue: btree_update btree_interior_update_work
>> Call Trace:
>>  <TASK>
>>  __schedule+0x3b0/0xaf0
>>  ? bch2_path_get+0x5e/0x560
>>  ? __pfx_bch2_six_check_for_deadlock+0x10/0x10
>>  schedule+0x2e/0xd0
>>  six_lock_slowpath.constprop.0+0x10b/0x2e0
>>  btree_interior_update_work+0x8a3/0x9e0
>>  ? btree_interior_update_work+0x842/0x9e0
>>  process_one_work+0x165/0x330
>>  worker_thread+0x2f1/0x410
>>  ? __pfx_worker_thread+0x10/0x10
>>  kthread+0xe1/0x110
>>  ? __pfx_kthread+0x10/0x10
>>  ret_from_fork+0x2d/0x50
>>  ? __pfx_kthread+0x10/0x10
>>  ret_from_fork_asm+0x1b/0x30
>>  </TASK>
>>
>> INFO: task createtree:3024 blocked for more than 120 seconds.
>>       Not tainted 6.6.0+ #386
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:createtree      state:D stack:0     pid:3024  tgid:3024
>> ppid:3011   flags:0x00000002
>> Call Trace:
>>  <TASK>
>>  __schedule+0x3b0/0xaf0
>>  ? __pfx_bch2_six_check_for_deadlock+0x10/0x10
>>  schedule+0x2e/0xd0
>>  six_lock_slowpath.constprop.0+0x10b/0x2e0
>>  bch2_btree_node_get+0x33d/0x4c0
>>  ? bch2_dirent_create+0x238/0x3e0
>>  bch2_btree_path_traverse_one+0x212/0x8c0
>>  ? bch2_btree_path_traverse_one+0xb2/0x8c0
>>  ? bch2_dirent_create+0x238/0x3e0
>>  bch2_btree_iter_peek_slot+0x106/0x6d0
>>  ? btree_path_get_locks.constprop.0+0x3a/0x150
>>  ? bch2_path_get+0x404/0x560
>>  ? bch2_dirent_hash+0xd6/0x150
>>  ? bch2_dirent_create+0xf6/0x3e0
>>  bch2_dirent_create+0x238/0x3e0
>>  ? bch2_create_trans+0x4d0/0x6c0
>>  bch2_create_trans+0x518/0x6c0
>>  ? chacha_block_generic+0x6f/0xb0
>>  __bch2_create+0x1be/0x4e0
>>  ? bch2_trans_iter_init_outlined+0x112/0x180
>>  ? d_splice_alias+0x8e/0x2b0
>>  ? bch2_create+0x26/0x60
>>  bch2_create+0x26/0x60
>>  path_openat+0xe9f/0x11d0
>>  do_filp_open+0xb4/0x160
>>  ? kmem_cache_alloc+0x15c/0x2b0
>>  ? _raw_spin_unlock+0xa/0x30
>>  do_sys_openat2+0x91/0xc0
>>  __x64_sys_openat+0x6a/0xa0
>>  do_syscall_64+0x32/0xf0
>>  entry_SYSCALL_64_after_hwframe+0x6e/0x76
>> RIP: 0033:0x7fe7b1bdfe01
>> RSP: 002b:00007ffee4ae0ea0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
>> RAX: ffffffffffffffda RBX: 0000000000000042 RCX: 00007fe7b1bdfe01
>> RDX: 0000000000000042 RSI: 00007ffee4ae0f30 RDI: 00000000ffffff9c
>> RBP: 00007ffee4ae0f30 R08: 0000000000000000 R09: 0000000000000064
>> R10: 00000000000001ff R11: 0000000000000202 R12: 0000000000000263
>> R13: 00000000000003e8 R14: 00007ffee4ae267c R15: 000055b2c0e97010
>>  </TASK>
>>
> Can you check btree_transactions in debugfs?
>

hung task:
INFO: task createtree:3841 blocked for more than 120 seconds.
      Not tainted 6.6.0+ #389
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
task:createtree      state:D stack:0     pid:3841  tgid:3841
ppid:3802   flags:0x00000002
Call Trace:
 <TASK>
 __schedule+0x3b0/0xaf0
 ? __pfx_bch2_six_check_for_deadlock+0x10/0x10
 schedule+0x2e/0xd0
 six_lock_slowpath.constprop.0+0x10b/0x2e0
 btree_node_lock.constprop.0+0x144/0x1a0
 bch2_btree_node_get+0xb8/0x470
 ? bch2_dirent_create+0x23c/0x3e0
 bch2_btree_path_traverse_one+0x2fe/0xa00
 ? bch2_btree_path_traverse_one+0x167/0xa00
 ? bch2_dirent_create+0x23c/0x3e0
 bch2_btree_iter_peek_slot+0x139/0x790
 ? btree_path_get_locks.constprop.0+0xd3/0x260
 ? bch2_path_get+0x547/0x5f0
 ? bch2_dirent_create+0xf6/0x3e0
 bch2_dirent_create+0x23c/0x3e0
 ? bch2_dirent_create+0xf6/0x3e0
 ? bch2_create_trans+0x4d0/0x6c0
 bch2_create_trans+0x518/0x6c0
 ? chacha_block_generic+0x6f/0xb0
 ? bch2_inode_peek_nowarn.isra.0+0xb1/0x120
 ? bch2_inode_create+0xb6/0x3a0
 __bch2_create+0x1be/0x4e0
 ? d_splice_alias+0x8e/0x2b0
 ? bch2_create+0x26/0x60
 bch2_create+0x26/0x60
 path_openat+0xe9f/0x11d0
 do_filp_open+0xb4/0x160
 ? kmem_cache_alloc+0x15c/0x2b0
 ? _raw_spin_unlock+0xa/0x30
 do_sys_openat2+0x91/0xc0
 __x64_sys_openat+0x6a/0xa0
 do_syscall_64+0x32/0xf0
 entry_SYSCALL_64_after_hwframe+0x6e/0x76
RIP: 0033:0x7f335f77fe01
RSP: 002b:00007ffec817ba30 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000042 RCX: 00007f335f77fe01
RDX: 0000000000000042 RSI: 00007ffec817bac0 RDI: 00000000ffffff9c
RBP: 00007ffec817bac0 R08: 0000000000000000 R09: 0000000000000064
R10: 00000000000001ff R11: 0000000000000202 R12: 000000000000023e
R13: 00000000000003e8 R14: 00007ffec817d67c R15: 00005555d1e1e010
 </TASK>

transactions:

923 bch2_copygc_thread
backtrace:
  [<0>] bch2_kthread_io_clock_wait+0xc6/0x140
  [<0>] bch2_copygc_thread+0x24d/0x370
  [<0>] kthread+0xe1/0x110
  [<0>] ret_from_fork+0x2d/0x50
  [<0>] ret_from_fork_asm+0x1b/0x30

3805 __bch2_create
  path 0 b l=0 subvolumes:0:1:0
    r l=0       ff4007690c378000 b l=0 subvolumes:SPOS_MAX locks 6:0:0
held by pid 0
  path 1 c l=0 inodes:0:67696035:U32_MAX
    w l=0       ff40076874a5b700 c l=0 inodes:0:67696035:U32_MAX locks
0:1:1 held by pid 3805
  path 2 b l=0 inodes:0:67696805:0
    i l=0       ff40076861b2e600 b l=0 inodes:0:134218005:U32_MAX
locks 0:2:1 held by pid 3805
  path 3 c l=0 inodes:0:67696805:U32_MAX
    i l=0       ff4007691e8597b8 c l=0 inodes:0:67696805:U32_MAX locks
0:1:0 held by pid 3805
  path 4 b l=0 inodes:0:67696806:U32_MAX
    w l=0       ff40076861b2e600 b l=0 inodes:0:134218005:U32_MAX
locks 0:2:1 held by pid 3805
  path 5 c l=0 inodes:0:67696806:U32_MAX
    w l=0       ff4007691e8587e8 c l=0 inodes:0:67696806:U32_MAX locks
0:1:1 held by pid 3805
  path 6 b l=0 dirents:67696035:5610894439833744094:U32_MAX
    w l=0       ff4007685ef9f200 b l=0
dirents:134217917:2787225780226683893:U32_MAX locks 0:1:1 held by pid
3805
  path 7 c l=0 inodes:0:134217728:U32_MAX
    i l=0       ff4007699b4992b0 c l=0 inodes:0:134217728:U32_MAX
locks 0:1:0 held by pid 3805
backtrace:

3807 __bch2_create
  path 0 b l=0 subvolumes:0:1:0
    r l=0       ff4007690c378000 b l=0 subvolumes:SPOS_MAX locks 6:0:0
held by pid 0
  path 1 c l=0 inodes:0:805879636:U32_MAX
    w l=0       ff40076876671648 c l=0 inodes:0:805879636:U32_MAX
locks 0:1:1 held by pid 3807
  path 2 b l=0 inodes:0:805879771:0
    i l=0       ff4007683e267a00 b l=0 inodes:0:872415843:U32_MAX
locks 0:2:1 held by pid 3807
  path 3 c l=0 inodes:0:805879771:U32_MAX
    i l=0       ff4007691298d870 c l=0 inodes:0:805879771:U32_MAX
locks 0:1:0 held by pid 3807
  path 4 b l=0 inodes:0:805879772:U32_MAX
    w l=0       ff4007683e267a00 b l=0 inodes:0:872415843:U32_MAX
locks 0:2:1 held by pid 3807
  path 5 c l=0 inodes:0:805879772:U32_MAX
    w l=0       ff4007691298c958 c l=0 inodes:0:805879772:U32_MAX
locks 0:1:1 held by pid 3807
  path 6 b l=0 dirents:805879636:877646214245309706:U32_MAX
    w l=0       ff4007683e260a00 b l=0
dirents:872415232:213834028349939920:U32_MAX locks 0:1:1 held by pid
3807
  path 7 c l=0 inodes:0:872415232:U32_MAX
    i l=0       ff40076903cdc000 c l=0 inodes:0:872415232:U32_MAX
locks 0:1:0 held by pid 3807
backtrace:
  [<0>] bch2_btree_key_cache_scan+0x33/0x450
  [<0>] do_shrink_slab+0x13c/0x360
  [<0>] shrink_slab+0xc9/0x3c0
  [<0>] shrink_node+0x363/0xb70
  [<0>] do_try_to_free_pages+0xd5/0x5b0
  [<0>] try_to_free_pages+0xdd/0x200
  [<0>] __alloc_pages_slowpath.constprop.0+0x2e4/0xd50
  [<0>] __alloc_pages+0x305/0x330
  [<0>] alloc_pages_mpol+0x91/0x1e0
  [<0>] allocate_slab+0x2d1/0x4d0
  [<0>] ___slab_alloc.constprop.0+0x42a/0x6c0
  [<0>] __kmem_cache_alloc_node+0x113/0x270
  [<0>] __kmalloc_node_track_caller+0x4d/0x150
  [<0>] krealloc+0x5d/0xc0
  [<0>] __bch2_trans_commit+0x1d59/0x1f30
  [<0>] __bch2_create+0x288/0x4e0
  [<0>] bch2_create+0x26/0x60
  [<0>] path_openat+0xe9f/0x11d0
  [<0>] do_filp_open+0xb4/0x160
  [<0>] do_sys_openat2+0x91/0xc0
  [<0>] __x64_sys_openat+0x6a/0xa0
  [<0>] do_syscall_64+0x32/0xf0
  [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

3815 __bch2_create
  path 0 b l=0 subvolumes:0:1:0
    r l=0       ff4007690c378000 b l=0 subvolumes:SPOS_MAX locks 6:0:0
held by pid 0
  path 1 c l=0 inodes:0:134779563:U32_MAX
    w l=0       ff400768743cc450 c l=0 inodes:0:134779563:U32_MAX
locks 0:1:1 held by pid 3815
  path 2 b l=0 inodes:0:134780450:0
    i l=0       ff40076838843200 b l=0 inodes:0:201326931:U32_MAX
locks 0:2:1 held by pid 3815
  path 3 c l=0 inodes:0:134780450:U32_MAX
    i l=0       ff400768767a71f8 c l=0 inodes:0:134780450:U32_MAX
locks 0:1:0 held by pid 3815
  path 4 b l=0 inodes:0:134780451:U32_MAX
    w l=0       ff40076838843200 b l=0 inodes:0:201326931:U32_MAX
locks 0:2:1 held by pid 3815
  path 5 c l=0 inodes:0:134780451:U32_MAX
    w l=0       ff400768767a7928 c l=0 inodes:0:134780451:U32_MAX
locks 0:1:1 held by pid 3815
  path 6 b l=0 dirents:134779563:8468006616558241370:U32_MAX
    w l=0       ff4007681e617000 b l=0
dirents:201326594:5145034495449797692:U32_MAX locks 0:1:1 held by pid
3815
  path 7 c l=0 inodes:0:201326592:U32_MAX
    i l=0       ff400769035d39e0 c l=0 inodes:0:201326592:U32_MAX
locks 0:1:0 held by pid 3815
backtrace:
  [<0>] bch2_btree_key_cache_scan+0x33/0x450
  [<0>] do_shrink_slab+0x13c/0x360
  [<0>] shrink_slab+0xc9/0x3c0
  [<0>] shrink_node+0x363/0xb70
  [<0>] do_try_to_free_pages+0xd5/0x5b0
  [<0>] try_to_free_pages+0xdd/0x200
  [<0>] __alloc_pages_slowpath.constprop.0+0x2e4/0xd50
  [<0>] __alloc_pages+0x305/0x330
  [<0>] alloc_pages_mpol+0x91/0x1e0
  [<0>] allocate_slab+0x2d1/0x4d0
  [<0>] ___slab_alloc.constprop.0+0x42a/0x6c0
  [<0>] __kmem_cache_alloc_node+0x113/0x270
  [<0>] __kmalloc_node_track_caller+0x4d/0x150
  [<0>] krealloc+0x5d/0xc0
  [<0>] __bch2_trans_commit+0x1d59/0x1f30
  [<0>] __bch2_create+0x288/0x4e0
  [<0>] bch2_create+0x26/0x60
  [<0>] path_openat+0xe9f/0x11d0
  [<0>] do_filp_open+0xb4/0x160
  [<0>] do_sys_openat2+0x91/0xc0
  [<0>] __x64_sys_openat+0x6a/0xa0
  [<0>] do_syscall_64+0x32/0xf0
  [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

3819 __bch2_create
  path 0 b l=0 subvolumes:0:1:0
    r l=0       ff4007690c378000 b l=0 subvolumes:SPOS_MAX locks 6:0:0
held by pid 0
  path 1 c l=0 inodes:0:537704719:U32_MAX
    w l=0       ff40076875d29088 c l=0 inodes:0:537704719:U32_MAX
locks 0:1:1 held by pid 3819
  path 2 b l=0 inodes:0:1141166113:0
    i l=0       ff40076867209a00 b l=0 inodes:0:1207960124:U32_MAX
locks 0:2:1 held by pid 3819
  path 3 c l=0 inodes:0:1141166113:U32_MAX
    i l=0       ff4007691e9d1700 c l=0 inodes:0:1141166113:U32_MAX
locks 0:1:0 held by pid 3819
  path 4 b l=0 inodes:0:1141166114:U32_MAX
    w l=0       ff40076867209a00 b l=0 inodes:0:1207960124:U32_MAX
locks 0:2:1 held by pid 3819
  path 5 c l=0 inodes:0:1141166114:U32_MAX
    w l=0       ff4007691e9d08a0 c l=0 inodes:0:1141166114:U32_MAX
locks 0:1:1 held by pid 3819
  path 6 b l=0 dirents:537704719:3071545244931752885:U32_MAX
    w l=0       ff4007684c020000 b l=0
dirents:603981467:2975299895752606202:U32_MAX locks 0:1:1 held by pid
3819
  path 7 c l=0 inodes:0:1207959552:U32_MAX
    i l=0       ff40076963046228 c l=0 inodes:0:1207959552:U32_MAX
locks 0:1:0 held by pid 3819
backtrace:

3821 __bch2_create
  path 0 b l=0 subvolumes:0:1:0
    r l=0       ff4007690c378000 b l=0 subvolumes:SPOS_MAX locks 6:0:0
held by pid 0
  path 1 c l=0 inodes:0:1409508344:U32_MAX
    w l=0       ff4007687376efd0 c l=0 inodes:0:1409508344:U32_MAX
locks 0:1:1 held by pid 3821
  path 2 b l=0 inodes:0:1409508831:0
    i l=0       ff4007680b23ac00 b l=0 inodes:0:1476395492:U32_MAX
locks 0:2:1 held by pid 3821
  path 3 c l=0 inodes:0:1409508831:U32_MAX
    i l=0       ff40076966a05e30 c l=0 inodes:0:1409508831:U32_MAX
locks 0:1:0 held by pid 3821
  path 4 b l=0 inodes:0:1409508832:U32_MAX
    w l=0       ff4007680b23ac00 b l=0 inodes:0:1476395492:U32_MAX
locks 0:2:1 held by pid 3821
  path 5 c l=0 inodes:0:1409508832:U32_MAX
    w l=0       ff40076966a05cc0 c l=0 inodes:0:1409508832:U32_MAX
locks 0:1:1 held by pid 3821
  path 6 b l=0 dirents:1409508344:2653941493857063939:U32_MAX
    w l=0       ff4007680b23b400 b l=0
dirents:1476395008:4023447886801610889:U32_MAX locks 0:1:1 held by pid
3821
  path 7 c l=0 inodes:0:1476395008:U32_MAX
    i l=0       ff400769adefbb50 c l=0 inodes:0:1476395008:U32_MAX
locks 0:1:0 held by pid 3821
backtrace:
  [<0>] bch2_btree_key_cache_scan+0x33/0x450
  [<0>] do_shrink_slab+0x13c/0x360
  [<0>] shrink_slab+0xc9/0x3c0
  [<0>] shrink_node+0x363/0xb70
  [<0>] do_try_to_free_pages+0xd5/0x5b0
  [<0>] try_to_free_pages+0xdd/0x200
  [<0>] __alloc_pages_slowpath.constprop.0+0x2e4/0xd50
  [<0>] __alloc_pages+0x305/0x330
  [<0>] alloc_pages_mpol+0x91/0x1e0
  [<0>] allocate_slab+0x2d1/0x4d0
  [<0>] ___slab_alloc.constprop.0+0x42a/0x6c0
  [<0>] __kmem_cache_alloc_node+0x113/0x270
  [<0>] __kmalloc_node_track_caller+0x4d/0x150
  [<0>] krealloc+0x5d/0xc0
  [<0>] __bch2_trans_commit+0x1d59/0x1f30
  [<0>] __bch2_create+0x288/0x4e0
  [<0>] bch2_create+0x26/0x60
  [<0>] path_openat+0xe9f/0x11d0
  [<0>] do_filp_open+0xb4/0x160
  [<0>] do_sys_openat2+0x91/0xc0
  [<0>] __x64_sys_openat+0x6a/0xa0
  [<0>] do_syscall_64+0x32/0xf0
  [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

3841 __bch2_create
  path 0 b l=0 subvolumes:0:1:0
    r l=0       ff4007690c378000 b l=0 subvolumes:SPOS_MAX locks 6:0:0
held by pid 0
  path 1 c l=0 inodes:0:537704011:U32_MAX
    i l=0       ff4007687586e958 c l=0 inodes:0:537704011:U32_MAX
locks 0:1:0 held by pid 3841
  path 2 b l=0 inodes:0:537705127:0
    i l=0       ff40076857791800 b l=0 inodes:0:603979964:U32_MAX
locks 0:2:0 held by pid 3841
  path 3 c l=0 inodes:0:537705127:U32_MAX
    i l=0       ff40076875d48cf0 c l=0 inodes:0:537705127:U32_MAX
locks 0:1:0 held by pid 3841
  path 4 b l=0 inodes:0:537705128:U32_MAX
    i l=0       ff40076857791800 b l=0 inodes:0:603979964:U32_MAX
locks 0:2:0 held by pid 3841
  path 5 c l=0 inodes:0:603979776:U32_MAX
    i l=0       ff400769429de170 c l=0 inodes:0:603979776:U32_MAX
locks 0:1:0 held by pid 3841
  blocked for 212622652us on
    i           ff4007684c020000 b l=0
dirents:603981467:2975299895752606202:U32_MAX locks 0:1:1 held by pid
3819
backtrace:
  [<0>] six_lock_slowpath.constprop.0+0x10b/0x2e0
  [<0>] btree_node_lock.constprop.0+0x144/0x1a0
  [<0>] bch2_btree_node_get+0xb8/0x470
  [<0>] bch2_btree_path_traverse_one+0x2fe/0xa00
  [<0>] bch2_btree_iter_peek_slot+0x139/0x790
  [<0>] bch2_dirent_create+0x23c/0x3e0
  [<0>] bch2_create_trans+0x518/0x6c0
  [<0>] __bch2_create+0x1be/0x4e0
  [<0>] bch2_create+0x26/0x60
  [<0>] path_openat+0xe9f/0x11d0
  [<0>] do_filp_open+0xb4/0x160
  [<0>] do_sys_openat2+0x91/0xc0
  [<0>] __x64_sys_openat+0x6a/0xa0
  [<0>] do_syscall_64+0x32/0xf0
  [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

-- 
Mateusz Guzik <mjguzik gmail.com>
