Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CEBC4332F
	for <linux-bcachefs@archiver.kernel.org>; Tue, 31 Oct 2023 03:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjJaDHZ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 30 Oct 2023 23:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjJaDHX (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 30 Oct 2023 23:07:23 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9E6A6
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Oct 2023 20:07:20 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-3b40d5ea323so3202596b6e.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Oct 2023 20:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698721639; x=1699326439; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=sJUnIF3AyxptMoOeAg2//3YcmghTH0oPKkmURNIYX5o=;
        b=hm/ofdqZK/3qPhZqZ4Nbg8SbJb8y2QPRWooCMff691O/LI5LyTCpPfg+1MuoghKGbv
         /BOjqDXGjyj6heHDC2qOWYn5MdwzpNVkL76tr2PqZumhp1V2I9duFTVNgxLRyi/XkDaQ
         /gqrEKOgO1rirgiUmWByT891dksE6KRl7zVFOWFPvwR+WSJJeDZ1dZ9Rlz2NwxnWc+vb
         1uRh3VaotQ8HBtkVP09UYqhpPGhBNXPp4vUFTZzTUAwbo1+DhsGXOV8c1Ntm9UH2wV+g
         UdAqnfkfoOBqtvtfrjfNbfZ5Ez4Bb1u2YaLnZ19mwCjxH2XjNbXu6S9Euvyd5VT4mXaN
         vATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698721639; x=1699326439;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sJUnIF3AyxptMoOeAg2//3YcmghTH0oPKkmURNIYX5o=;
        b=lFdIK17M7NmVwEHrw3AYbOprr9SrPK74zqaZToNrEMnHcRxn5v+zYntdXh3SEWOlId
         tNdr8n1QIkeMdRGjenIvfsd8SpQ3uLl2w7qW1HcQ2KxWFWtdGE1SgU7CwFG3Pi6xIGvA
         0mEK/BvNgcGqExskcBFI6XcpEwIf9LfVW2TFvNU5UrnOj0VUWQdK7S+u1cXyfwus4D6f
         XM5fENhbx73uDaetnEJALvapNqlOc8ZAKm7sazXa1J47LdnYNdWFWC93Sdn3jXtTs1zL
         1ShN3+TY4zFVsktzIxin9qFz/2J2ri/tivZPSskRxCXdlY+Z9h62PgfPuR9AQxbPS3Gw
         Lzuw==
X-Gm-Message-State: AOJu0YyV4yRDfn/K8iY64exBJ0ljmGvbTDNhXx2fq9K7z0nnrh21qqEU
        lwDsBhM7r7LhCaZxiZZixyigN1WkBvY=
X-Google-Smtp-Source: AGHT+IF/6Yu4uDXFdbOdx2fI1+3GQw0TPpb3F8mWbQKEiy3kApbYer4TzM7wqbB7Q/7tCV8jb/jYAw==
X-Received: by 2002:a05:6808:482:b0:3a5:a78b:f773 with SMTP id z2-20020a056808048200b003a5a78bf773mr12194514oid.6.1698721639435;
        Mon, 30 Oct 2023 20:07:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t27-20020a63955b000000b0057412d84d25sm206453pgn.4.2023.10.30.20.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 20:07:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 30 Oct 2023 20:07:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>
Subject: odebuf and lockdep splat with bcachefs
Message-ID: <09a4c8ed-c984-4582-b5c4-0804ee4d55ec@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi,

when trying the new bcachefs in the mainline kernel, I see the
attached ODEBUG and lockdep splats.

This is simply mounting an empty bcachefs file system and
copying some files into it.

Guenter

---
...
[   11.653586] bcachefs (nvme0n1p2): fix_reflink_p... done
[   11.656803] ODEBUG: object ffff80008164bb80 is on stack ffff800081648000, but NOT annotated.
[   11.657192]
[   11.657202] ======================================================
[   11.657209] WARNING: possible circular locking dependency detected
[   11.657271] 6.6.0-03474-gcd063c8b9e1e #1 Tainted: G                 N
[   11.657281] ------------------------------------------------------
[   11.657288] bch-copygc/nvme/790 is trying to acquire lock:
[   11.657323] ffffac9250236a70 (console_owner){....}-{0:0}, at: console_flush_all+0x1b0/0x510
[   11.657507]
[   11.657507] but task is already holding lock:
[   11.657514] ffffac9251375218 (&obj_hash[i].lock){-.-.}-{2:2}, at: __debug_object_init+0xac/0x20c
[   11.657543]
[   11.657543] which lock already depends on the new lock.
[   11.657543]
[   11.657548]
[   11.657548] the existing dependency chain (in reverse order) is:
[   11.657568]
[   11.657568] -> #4 (&obj_hash[i].lock){-.-.}-{2:2}:
[   11.657628]        _raw_spin_lock_irqsave+0x60/0x88
[   11.657675]        debug_object_activate+0x108/0x290
[   11.657684]        insert_work+0x38/0xb0
[   11.657694]        __queue_work+0x1c4/0x674
[   11.657701]        queue_work_on+0xa8/0xe4
[   11.657708]        start_poll_synchronize_rcu_expedited+0x108/0x10c
[   11.657717]        rcu_init+0xb08/0xd3c
[   11.657728]        start_kernel+0x250/0x684
[   11.657735]        __primary_switched+0xbc/0xc4
[   11.657779]
[   11.657779] -> #3 (&pool->lock){-.-.}-{2:2}:
[   11.657802]        _raw_spin_lock+0x48/0x60
[   11.657821]        __queue_work+0x240/0x674
[   11.657828]        queue_work_on+0xa8/0xe4
[   11.657835]        rpm_suspend+0x4f0/0x644
[   11.657844]        rpm_idle+0x11c/0x2d4
[   11.657851]        __pm_runtime_idle+0x40/0xac
[   11.657858]        __device_attach+0xdc/0x1b0
[   11.657866]        device_initial_probe+0x14/0x20
[   11.657874]        bus_probe_device+0xb0/0xb4
[   11.657881]        device_add+0x5c8/0x784
[   11.657890]        serial_base_port_add+0x118/0x198
[   11.657899]        serial_core_register_port+0x74/0x5d4
[   11.657907]        serial_ctrl_register_port+0x10/0x1c
[   11.657915]        uart_add_one_port+0x10/0x1c
[   11.657923]        pl011_register_port+0x70/0x12c
[   11.657930]        pl011_probe+0x1ac/0x1e0
[   11.657937]        amba_probe+0x110/0x1c4
[   11.657947]        really_probe+0x148/0x2ac
[   11.657954]        __driver_probe_device+0x78/0x12c
[   11.657962]        driver_probe_device+0x3c/0x10c
[   11.657969]        __device_attach_driver+0xb8/0xf8
[   11.657977]        bus_for_each_drv+0x80/0xdc
[   11.657984]        __device_attach+0xa8/0x1b0
[   11.657991]        device_initial_probe+0x14/0x20
[   11.657998]        bus_probe_device+0xb0/0xb4
[   11.658005]        device_add+0x5c8/0x784
[   11.658015]        amba_device_add+0x40/0xac
[   11.658024]        of_platform_bus_create+0x2b4/0x378
[   11.658033]        of_platform_populate+0x50/0xfc
[   11.658039]        of_platform_default_populate_init+0xd0/0xf0
[   11.658049]        do_one_initcall+0x74/0x2f0
[   11.658056]        kernel_init_freeable+0x2a0/0x4f8
[   11.658064]        kernel_init+0x24/0x1e0
[   11.658072]        ret_from_fork+0x10/0x20
[   11.658087]
[   11.658087] -> #2 (&dev->power.lock){-...}-{2:2}:
[   11.658103]        _raw_spin_lock_irqsave+0x60/0x88
[   11.658112]        __pm_runtime_resume+0x48/0xb8
[   11.658119]        __uart_start+0x4c/0xf4
[   11.658127]        uart_write+0xec/0x2bc
[   11.658134]        n_tty_write+0x1cc/0x49c
[   11.658143]        file_tty_write.constprop.0+0x128/0x2b4
[   11.658150]        redirected_tty_write+0xbc/0xdc
[   11.658157]        vfs_write+0x220/0x2c4
[   11.658166]        ksys_write+0x68/0xf4
[   11.658173]        __arm64_sys_write+0x1c/0x28
[   11.658181]        invoke_syscall+0x48/0x114
[   11.658191]        el0_svc_common.constprop.0+0x40/0xe8
[   11.658200]        do_el0_svc+0x20/0x2c
[   11.658208]        el0_svc+0x58/0x120
[   11.658216]        el0t_64_sync_handler+0x13c/0x158
[   11.658224]        el0t_64_sync+0x190/0x194
[   11.658231]
[   11.658231] -> #1 (&port_lock_key){....}-{2:2}:
[   11.658246]        _raw_spin_lock+0x48/0x60
[   11.658254]        pl011_console_write+0x150/0x1c4
[   11.658261]        console_flush_all+0x20c/0x510
[   11.658269]        console_unlock+0x6c/0x144
[   11.658277]        vprintk_emit+0x22c/0x3bc
[   11.658285]        vprintk_default+0x38/0x44
[   11.658294]        vprintk+0xa4/0xc0
[   11.658302]        _printk+0x5c/0x84
[   11.658309]        register_console+0x1f4/0x420
[   11.658316]        serial_core_register_port+0x5a0/0x5d4
[   11.658325]        serial_ctrl_register_port+0x10/0x1c
[   11.658333]        uart_add_one_port+0x10/0x1c
[   11.658341]        pl011_register_port+0x70/0x12c
[   11.658348]        pl011_probe+0x1ac/0x1e0
[   11.658355]        amba_probe+0x110/0x1c4
[   11.658363]        really_probe+0x148/0x2ac
[   11.658370]        __driver_probe_device+0x78/0x12c
[   11.658377]        driver_probe_device+0x3c/0x10c
[   11.658385]        __device_attach_driver+0xb8/0xf8
[   11.658392]        bus_for_each_drv+0x80/0xdc
[   11.658399]        __device_attach+0xa8/0x1b0
[   11.658406]        device_initial_probe+0x14/0x20
[   11.658413]        bus_probe_device+0xb0/0xb4
[   11.658420]        device_add+0x5c8/0x784
[   11.658429]        amba_device_add+0x40/0xac
[   11.658437]        of_platform_bus_create+0x2b4/0x378
[   11.658444]        of_platform_populate+0x50/0xfc
[   11.658450]        of_platform_default_populate_init+0xd0/0xf0
[   11.658459]        do_one_initcall+0x74/0x2f0
[   11.658466]        kernel_init_freeable+0x2a0/0x4f8
[   11.658473]        kernel_init+0x24/0x1e0
[   11.658482]        ret_from_fork+0x10/0x20
[   11.658489]
[   11.658489] -> #0 (console_owner){....}-{0:0}:
[   11.658504]        __lock_acquire+0x1510/0x1ff0
[   11.658512]        lock_acquire+0x1f0/0x330
[   11.658519]        console_flush_all+0x1f8/0x510
[   11.658527]        console_unlock+0x6c/0x144
[   11.658535]        vprintk_emit+0x22c/0x3bc
[   11.658542]        vprintk_default+0x38/0x44
[   11.658550]        vprintk+0xa4/0xc0
[   11.658558]        _printk+0x5c/0x84
[   11.658565]        lookup_object_or_alloc.part.0+0x150/0x2a8
[   11.658574]        __debug_object_init+0x108/0x20c
[   11.658582]        debug_object_init+0x24/0x30
[   11.658591]        __init_work+0x34/0x40
[   11.658599]        rhashtable_init+0x10c/0x2a8
[   11.658608]        bch2_copygc_thread+0x50/0x474
[   11.658617]        kthread+0x124/0x128
[   11.658625]        ret_from_fork+0x10/0x20
[   11.658636]
[   11.658636] other info that might help us debug this:
[   11.658636]
[   11.658671] Chain exists of:
[   11.658671]   console_owner --> &pool->lock --> &obj_hash[i].lock
[   11.658671]
[   11.658709]  Possible unsafe locking scenario:
[   11.658709]
[   11.658714]        CPU0                    CPU1
[   11.658719]        ----                    ----
[   11.658727]   lock(&obj_hash[i].lock);
[   11.658743]                                lock(&pool->lock);
[   11.658759]                                lock(&obj_hash[i].lock);
[   11.658780]   lock(console_owner);
[   11.658798]
[   11.658798]  *** DEADLOCK ***
[   11.658798]
[   11.658821] 3 locks held by bch-copygc/nvme/790:
[   11.658843]  #0: ffffac9251375218 (&obj_hash[i].lock){-.-.}-{2:2}, at: __debug_object_init+0xac/0x20c
[   11.658880]  #1: ffffac9250236870 (console_lock){+.+.}-{0:0}, at: vprintk_emit+0x11c/0x3bc
[   11.658923]  #2: ffffac9250236908 (console_srcu){....}-{0:0}, at: console_flush_all+0x7c/0x510
[   11.658958]
[   11.658958] stack backtrace:
[   11.659058] CPU: 3 PID: 790 Comm: bch-copygc/nvme Tainted: G                 N 6.6.0-03474-gcd063c8b9e1e #1
[   11.659081] Hardware name: linux,dummy-virt (DT)
[   11.659202] Call trace:
[   11.659214]  dump_backtrace+0x94/0xec
[   11.659241]  show_stack+0x18/0x24
[   11.659248]  dump_stack_lvl+0x74/0xd4
[   11.659257]  dump_stack+0x18/0x24
[   11.659265]  print_circular_bug+0x290/0x370
[   11.659273]  check_noncircular+0x184/0x198
[   11.659281]  __lock_acquire+0x1510/0x1ff0
[   11.659288]  lock_acquire+0x1f0/0x330
[   11.659296]  console_flush_all+0x1f8/0x510
[   11.659304]  console_unlock+0x6c/0x144
[   11.659312]  vprintk_emit+0x22c/0x3bc
[   11.659320]  vprintk_default+0x38/0x44
[   11.659328]  vprintk+0xa4/0xc0
[   11.659336]  _printk+0x5c/0x84
[   11.659344]  lookup_object_or_alloc.part.0+0x150/0x2a8
[   11.659353]  __debug_object_init+0x108/0x20c
[   11.659362]  debug_object_init+0x24/0x30
[   11.659370]  __init_work+0x34/0x40
[   11.659379]  rhashtable_init+0x10c/0x2a8
[   11.659387]  bch2_copygc_thread+0x50/0x474
[   11.659394]  kthread+0x124/0x128
[   11.659402]  ret_from_fork+0x10/0x20
[   11.668336] ------------[ cut here ]------------
[   11.668466] WARNING: CPU: 3 PID: 790 at lib/debugobjects.c:557 lookup_object_or_alloc.part.0+0x100/0x2a8
[   11.668592] Modules linked in:
[   11.668708] CPU: 3 PID: 790 Comm: bch-copygc/nvme Tainted: G                 N 6.6.0-03474-gcd063c8b9e1e #1
[   11.668802] Hardware name: linux,dummy-virt (DT)
[   11.668890] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   11.668979] pc : lookup_object_or_alloc.part.0+0x100/0x2a8
[   11.669045] lr : lookup_object_or_alloc.part.0+0x150/0x2a8
[   11.669113] sp : ffff80008164b950
[   11.669176] x29: ffff80008164b950 x28: ffffac9250213ea8 x27: 0000000000000000
[   11.669304] x26: 0000000000000000 x25: ffff80008164bb80 x24: ffffac92513751f8
[   11.669393] x23: ffffac925131f0b0 x22: 0000000000000000 x21: ffffac924e97c620
[   11.669478] x20: ffff0f04c6942248 x19: ffff0f04dfcd17b0 x18: ffffffffffffffff
[   11.669575] x17: 2020202020202020 x16: 2020202020202020 x15: ffff80010164b577
[   11.669686] x14: 0000000000000000 x13: ffffac9250236af8 x12: 0000000000000ed9
[   11.669777] x11: 00000000000004f3 x10: ffffac925028eaf8 x9 : ffffac9250236af8
[   11.669885] x8 : 00000000ffffefff x7 : ffffac925028eaf8 x6 : 0000000000000000
[   11.669969] x5 : ffff0f04dfcc1f88 x4 : 0000000000000000 x3 : 0000000000000000
[   11.670054] x2 : 0000000000000000 x1 : ffff0f04c6f38040 x0 : 0000000000000050
[   11.670159] Call trace:
[   11.670206]  lookup_object_or_alloc.part.0+0x100/0x2a8
[   11.670265]  __debug_object_init+0x108/0x20c
[   11.670315]  debug_object_init+0x24/0x30
[   11.670362]  __init_work+0x34/0x40
[   11.670406]  rhashtable_init+0x10c/0x2a8
[   11.670452]  bch2_copygc_thread+0x50/0x474
[   11.670499]  kthread+0x124/0x128
[   11.670560]  ret_from_fork+0x10/0x20
[   11.670659] irq event stamp: 20
[   11.670705] hardirqs last  enabled at (19): [<ffffac924e046454>] get_random_u32+0x1e0/0x220
[   11.670795] hardirqs last disabled at (20): [<ffffac924e94a130>] _raw_spin_lock_irqsave+0x84/0x88
[   11.670897] softirqs last  enabled at (0): [<ffffac924d29b324>] copy_process+0x670/0x19d8
[   11.670989] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   11.671258] ---[ end trace 0000000000000000 ]---
