Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3807DC4332F
	for <linux-bcachefs@archiver.kernel.org>; Sun,  5 Nov 2023 12:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjKEMiz (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 07:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjKEMiy (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 07:38:54 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840BADB
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 04:38:50 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id 46e09a7af769-6d2de704f53so2386400a34.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 Nov 2023 04:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699187930; x=1699792730; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=udgCyAP4G+MLvR5CfqMoLceKV1DadMm3yWsolKchKlU=;
        b=NBOLbmbo6bevBblPJ1O+IdLAxUCTtttP7dQ8yZYsp0pULZLhwI3ZiDCS0wYssOrb0j
         q+1+JCHh3QMBE0e203T0JXG2AKWtOb86MvmAm1WoAsV83CZmATWIZKTv2YOOAT4yc686
         krRQn6Js7i0wquaqgdwLy7BQ8zGAe3Vax7cw92h0rrOSaV9i+jm2MPzmvKTt9GVqkxmW
         927O08BGWmoVTsp1LDfH3DcF0MCrRRboOt9ckXpoiOx0AMxFdN+uUyea0l78Y2wYZHDR
         mBMyOS2uws5PpXwlKB8AxBEsrjIXa9P8gEcvnAtotvDEm+f0F0TYomenlsQdJhyw5XQx
         u4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699187930; x=1699792730;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=udgCyAP4G+MLvR5CfqMoLceKV1DadMm3yWsolKchKlU=;
        b=B1SRJqkb1wI54lc6TOPiuLRWu7mu/LCmXppOEjC6ILwWFUh6XD3EBgDR3u4QRzaZpq
         89sxGtnrRqkhf67tK4+TV9jEunl8smGjsq6Dt31lvs7MmiSXgFm8B6pTdl+f6QLsrJUL
         8P2eAgjvGHCJpKPPW9n98sVY374Ac7Bd/7cHx6gKtQlI0keuqt9NzfXVuMWjuJpeUQNi
         lTJWV/uI+XezqJTUIrOEuL7dGVwGJwLXMX5z2mhKSXtF/V8TuhFRHzHgrj4JrPdGZUIa
         XxFbF/ikjATtbPAvdvitifh737Lqt0KC4uVBAkqtsCRW5c04YuAAtXzmuqr+s4UBRQXR
         ywLw==
X-Gm-Message-State: AOJu0Yx4GRENcve2Lf1yXnIGeLAZMCJEIpGD/KtxXood86zeo/ovBFGE
        /DJtJLjeymYP0Xt8kAv6umHuXj/e+c/f1ukxvwY=
X-Google-Smtp-Source: AGHT+IHwvorllkn0g3paXrPT2aGcckUqKXnJBqWyDg1uDpkKvZReXpZk9fPPGMULF4rJsRlfvmh/NcKFXba00sb9T0A=
X-Received: by 2002:a05:6830:4103:b0:6bf:1f5f:ed18 with SMTP id
 w3-20020a056830410300b006bf1f5fed18mr32725595ott.1.1699187929797; Sun, 05 Nov
 2023 04:38:49 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:7f8f:0:b0:4f0:1250:dd51 with HTTP; Sun, 5 Nov 2023
 04:38:49 -0800 (PST)
From:   Mateusz Guzik <mjguzik@gmail.com>
Date:   Sun, 5 Nov 2023 13:38:49 +0100
Message-ID: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
Subject: long stalls when creating 20 directory trees of 1 million inodes in parallel
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Setup is a 24 core vm + 24G of ram, running debian 12 with top of
master as of writing this e-mail, commit being:
commit 1c41041124bd14dd6610da256a3da4e5b74ce6b1 (HEAD -> master,
origin/master, origin/HEAD)
Merge: b8cc56d0414e 9fd00df05e81
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Nov 4 16:25:36 2023 -1000

    Merge tag 'i3c/for-6.7' of
git://git.kernel.org/pub/scm/linux/kernel/git/i3c/linux

I ran into it when trying to poke around at the fine-grained inode hash patch.

Reproduction instructions are here: https://people.freebsd.org/~mjg/fstree.tgz

Running it destabilizes the system after few minutes, for example
hanging my ssh connection (interestingly running stuff over a serial
port works fine). hung task detector reports a kernel thread and one
of the workers, traces at the end of the e-mail.

I can create trees just fine if I limit it to one worker at a time.
However, traversing them (again 20 workers, each with a dedicated
tree) once more runs into trouble.

There are no issues when running this against xfs and ext4.

Side note: mkfs.bcachefs warns about xfs being on the volume, but is
perfectly happy to format an existing bcachefs partition -- perhaps
this should also ask if it was intended?

traces:
INFO: task kworker/u48:0:11 blocked for more than 120 seconds.
      Not tainted 6.6.0+ #386
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u48:0   state:D stack:0     pid:11    tgid:11    ppid:2
   flags:0x00004000
Workqueue: btree_update btree_interior_update_work
Call Trace:
 <TASK>
 __schedule+0x3b0/0xaf0
 ? bch2_path_get+0x5e/0x560
 ? __pfx_bch2_six_check_for_deadlock+0x10/0x10
 schedule+0x2e/0xd0
 six_lock_slowpath.constprop.0+0x10b/0x2e0
 btree_interior_update_work+0x8a3/0x9e0
 ? btree_interior_update_work+0x842/0x9e0
 process_one_work+0x165/0x330
 worker_thread+0x2f1/0x410
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xe1/0x110
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2d/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>

INFO: task createtree:3024 blocked for more than 120 seconds.
      Not tainted 6.6.0+ #386
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:createtree      state:D stack:0     pid:3024  tgid:3024
ppid:3011   flags:0x00000002
Call Trace:
 <TASK>
 __schedule+0x3b0/0xaf0
 ? __pfx_bch2_six_check_for_deadlock+0x10/0x10
 schedule+0x2e/0xd0
 six_lock_slowpath.constprop.0+0x10b/0x2e0
 bch2_btree_node_get+0x33d/0x4c0
 ? bch2_dirent_create+0x238/0x3e0
 bch2_btree_path_traverse_one+0x212/0x8c0
 ? bch2_btree_path_traverse_one+0xb2/0x8c0
 ? bch2_dirent_create+0x238/0x3e0
 bch2_btree_iter_peek_slot+0x106/0x6d0
 ? btree_path_get_locks.constprop.0+0x3a/0x150
 ? bch2_path_get+0x404/0x560
 ? bch2_dirent_hash+0xd6/0x150
 ? bch2_dirent_create+0xf6/0x3e0
 bch2_dirent_create+0x238/0x3e0
 ? bch2_create_trans+0x4d0/0x6c0
 bch2_create_trans+0x518/0x6c0
 ? chacha_block_generic+0x6f/0xb0
 __bch2_create+0x1be/0x4e0
 ? bch2_trans_iter_init_outlined+0x112/0x180
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
RIP: 0033:0x7fe7b1bdfe01
RSP: 002b:00007ffee4ae0ea0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000042 RCX: 00007fe7b1bdfe01
RDX: 0000000000000042 RSI: 00007ffee4ae0f30 RDI: 00000000ffffff9c
RBP: 00007ffee4ae0f30 R08: 0000000000000000 R09: 0000000000000064
R10: 00000000000001ff R11: 0000000000000202 R12: 0000000000000263
R13: 00000000000003e8 R14: 00007ffee4ae267c R15: 000055b2c0e97010
 </TASK>

-- 
Mateusz Guzik <mjguzik gmail.com>
