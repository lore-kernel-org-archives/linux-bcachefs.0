Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915A918021
	for <linux-bcachefs@vger.kernel.org>; Wed,  3 Jan 2024 06:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quora.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="do8YzzDK"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-555f581aed9so2840336a12.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 02 Jan 2024 22:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1704263841; x=1704868641; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7I8QG7pTugzBNDKDX+hNAfW7KfE7VoDHE1KCNen8wuc=;
        b=do8YzzDKWLFeXlAHypRmkVtp7ztLPHaJyng6pENkiTqJ6WhURshroxNeYyAnZtoZvD
         1FzX0yGaB3+NvZDRw0V55nFyyr1AdtqU6CIPdpR58S1ArS4rnx9FzopmLBhY7rVR7ch+
         /zZrUSO0nJJe8P9VaTOF5EZ682lRhO7RENR/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704263841; x=1704868641;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7I8QG7pTugzBNDKDX+hNAfW7KfE7VoDHE1KCNen8wuc=;
        b=dBwFhka4pjS09stTcXZkIOHhBOMFFPBZNLddtXHvYAooJaaixxxhrqUynrWFB6aAbA
         uH7oSWV/+8lm8AhEIIpDL6JvXnZTsWrj+LyjYRR5efxuq2Jqj3KpkIuIqAMy1pTrxkTn
         0Tkp7Z1D+zpo29vHAmJuBJ47/5d0u98CiF4C6t2PmJFo1vCL/gjWT4TuVasxKhQZlPNj
         v15V6rayx+yB1sQ+8I5IOppqXGeFLdGJtWj9cXZRi1cWe8x6OjhCM5ku7y4XtWG2VfoG
         W8kJ1q2A8Irn+vUowU/ya1DOB27KUfwdYOeA4/AVfNewtTMwPues/Jig8Xr182JOTdEB
         QFmg==
X-Gm-Message-State: AOJu0Yw5z0Lqu9MOH0GIZ1B8TTBgTN/+g4Qyar6VvAChdnRFb0GjnAnL
	ZUNvllbaKcGBlqNHrTvZqQyYJ0fPNriiZHAo4dyP39kYug3oE0vJs9A/0mzX
X-Google-Smtp-Source: AGHT+IFcocP1CnWbDDWzhCAMXSm+QPEVrqJ3AcpXyjEgdWaQG+t9lB6oj4Nf/D9huxeakntqGG0QUY3iO6nLNP3OsvE=
X-Received: by 2002:a17:906:73c3:b0:a28:9620:de08 with SMTP id
 n3-20020a17090673c300b00a289620de08mr145933ejl.108.1704263840173; Tue, 02 Jan
 2024 22:37:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Daniel J Blueman <daniel@quora.org>
Date: Wed, 3 Jan 2024 14:37:08 +0800
Message-ID: <CAMVG2stQo_6aJ7U1FuHQDp-82DiGa2adjdBV7X7GDK8Q5qJ5DA@mail.gmail.com>
Subject: bcachefs-testing BUG
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Kent et al,

On bcachefs-testing SHA 67503f8d4fc, I was able to trigger a BUG macro
at fs/bcachefs/extents.c:570 [1].

You'll need a "modprobe brd rd_size=536870912 rd_nr=8" before the
commands listed, however I wasn't able to reproduce this due to two
factors - existing filesystem state from previous runs, and a
background process corrupting some disk blocks on the first device.
The latter will also affect state in the former of course.

I'll later figure out how to provide determinism in these areas for
reproducibility. Let me know if this testing is useful and if I should
be on master or downstream.

Thanks,
  Dan

-- [1]

[156782.713112] bcachefs-gym: bcachefs format -f
--data_checksum=crc32c --inodes_32bit --root_reserve_percent=19
--wide_macs --encrypted --no_passphrase --compression=zstd
--promote_target=/dev/ram0 /dev/ram5 /dev/ram7 /dev/ram6 /dev/ram2
/dev/ram3 /dev/ram4 /dev/ram1 /dev/ram0
[156782.781351] bcachefs-gym: mount -t bcachefs
/dev/ram5:/dev/ram7:/dev/ram6:/dev/ram2:/dev/ram3:/dev/ram4:/dev/ram1:/dev/ram0
/mnt
[156782.841391] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de):
mounting version 1.4: member_seq
opts=compression=zstd,promote_target=/dev/ram0,root_reserve_percent=19,wide_macs
[156782.870101] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de):
initializing new filesystem
[156782.880254] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de): going
read-write
[156782.888094] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de):
marking superblocks
[156783.679818] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de):
initializing freespace
[156783.825910] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de): done
initializing freespace
[156783.834916] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de):
reading snapshots table
[156783.843157] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de):
reading snapshots done
[156783.852416] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de): done
starting filesystem
[156783.861971] bcachefs-gym: fio --group_reporting
--ioengine=io_uring --directory=/mnt --size=16m --time_based
--runtime=60s --iodepth=256 --verify_async=8 --bs=4k-64k --norandommap
--random_distribution=zipf:0.5 --numjobs=16 --rw=randrw --name=A
--direct=1 --name=B --direct=0
[156793.867573] bcachefs-gym: bcachefs device -f resize-journal
/dev/ram7 267181234
[156796.992560] bcachefs-gym: bcachefs device -f offline /dev/ram4
[156797.003619] bcachefs (ram4): Cannot offline required disk
[156800.100446] bcachefs-gym: bcachefs device -f offline /dev/ram0
[156800.103824] bcachefs (ram0): Cannot offline required disk
[156803.208368] bcachefs-gym: bcachefs device -f resize /dev/ram7
[156806.392207] bcachefs-gym: bcachefs device -f remove --force
--force-metadata /dev/ram7
[156806.405561] __bch2_read_extent: 6 callbacks suppressed
[156806.405565] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de inum
134217728 offset 13406208): no device to read from
[156806.414845] bcachefs (ram7): bch2_dev_remove(): error dropping data EINVAL
[156806.416951] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de inum
603979778 offset 385024): no device to read from
[156806.416975] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de inum
603979778 offset 385024): no device to read from
[156806.429373] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de inum
603979779 offset 9453568): no device to read from
[156806.458307] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de inum
201326592 offset 12673024): no device to read from
[156806.459432] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de inum
603979779 offset 9453568): no device to read from
[156806.478769] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de inum
201326593 offset 7372800): no device to read from
[156806.503158] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de inum
201326593 offset 7372800): no device to read from
[156806.504230] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de inum
402653193 offset 6692864): no device to read from
[156806.525101] bcachefs (17fcffb4-6bd7-4bd1-9c3b-ce3ce58228de inum
402653193 offset 6692864): no device to read from
[156809.538433] bcachefs-gym: bcachefs device -f set-state /dev/ram6
[156812.602193] bcachefs-gym: bcachefs device -f resize /dev/ram4
[156815.696899] bcachefs-gym: bcachefs device -f remove --force
--force-metadata /dev/ram3
[156815.721618] bcachefs (ram3): bch2_dev_remove(): error dropping data EINVAL
[156818.781780] bcachefs-gym: bcachefs device -f resize /dev/ram2
[156821.886354] bcachefs-gym: bcachefs device -f add /mnt /dev/ram6
[156824.957281] bcachefs-gym: bcachefs device -f add /mnt /dev/ram7
[156828.033592] bcachefs-gym: bcachefs device -f online /dev/ram5
[156831.105825] bcachefs-gym: bcachefs device -f evacuate /dev/ram0
[156831.116465] bcachefs (ram0): ro
[156835.209153] bcachefs-gym: bcachefs device -f resize /dev/ram6
[156838.305626] bcachefs-gym: bcachefs device -f offline /dev/ram6
[156838.316381] bcachefs (ram6): Cannot offline required disk
[156841.381028] bcachefs-gym: bcachefs device -f set-state /dev/ram3
[156843.600834] ------------[ cut here ]------------
[156843.611985] kernel BUG at fs/bcachefs/extents.c:570!
[156843.617278] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[156843.622813] CPU: 37 PID: 1419263 Comm: kworker/u99:11 Not tainted
6.7.0-rc7+ #27
[156843.630507] Hardware name: Supermicro AS -3014TS-i/H12SSL-i, BIOS
2.5 09/08/2022
[156843.638204] Workqueue: bcachefs bch2_write_point_do_index_updates
[156843.644618] RIP: 0010:bch2_extent_crc_append
(fs/bcachefs/extents.c:570 (discriminator 1))
[156843.650242] Code: e0 2c 49 09 c4 48 b8 00 00 00 00 00 00 ff ff 49
23 45 00 49 09 c4 0f b7 45 30 4d 89 65 00 66 41 89 45 06 e9 d7 fd ff
ff 0f 0b <0f> 0b 48 c7 c7 80 e8 d1 b4 89 44 24 0c 48 89 74 24 10 e8 12
7a 32
All code
========
   0:    e0 2c                    loopne 0x2e
   2:    49 09 c4                 or     %rax,%r12
   5:    48 b8 00 00 00 00 00     movabs $0xffff000000000000,%rax
   c:    00 ff ff
   f:    49 23 45 00              and    0x0(%r13),%rax
  13:    49 09 c4                 or     %rax,%r12
  16:    0f b7 45 30              movzwl 0x30(%rbp),%eax
  1a:    4d 89 65 00              mov    %r12,0x0(%r13)
  1e:    66 41 89 45 06           mov    %ax,0x6(%r13)
  23:    e9 d7 fd ff ff           jmp    0xfffffffffffffdff
  28:    0f 0b                    ud2
  2a:*    0f 0b                    ud2        <-- trapping instruction
  2c:    48 c7 c7 80 e8 d1 b4     mov    $0xffffffffb4d1e880,%rdi
  33:    89 44 24 0c              mov    %eax,0xc(%rsp)
  37:    48 89 74 24 10           mov    %rsi,0x10(%rsp)
  3c:    e8                       .byte 0xe8
  3d:    12 7a 32                 adc    0x32(%rdx),%bh

Code starting with the faulting instruction
===========================================
   0:    0f 0b                    ud2
   2:    48 c7 c7 80 e8 d1 b4     mov    $0xffffffffb4d1e880,%rdi
   9:    89 44 24 0c              mov    %eax,0xc(%rsp)
   d:    48 89 74 24 10           mov    %rsi,0x10(%rsp)
  12:    e8                       .byte 0xe8
  13:    12 7a 32                 adc    0x32(%rdx),%bh
[156843.669567] RSP: 0018:ffffc9003099b860 EFLAGS: 00010206
[156843.675124] RAX: 0000000000000018 RBX: 00000000002e0000 RCX:
01020000084fa683
[156843.682586] RDX: 0000000000000003 RSI: 0000000000000004 RDI:
0000000000000000
[156843.690057] RBP: ffffc9003099b8c8 R08: 0000001800000018 R09:
0000000000000504
[156843.697526] R10: 46b80660880ccf27 R11: 0000000000000040 R12:
54020000002e0178
[156843.704996] R13: ffff889096a1f8d0 R14: ffff889096a1f800 R15:
0002000000000000
[156843.712449] FS:  0000000000000000(0000) GS:ffff88bf4ea80000(0000)
knlGS:0000000000000000
[156843.720864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[156843.726933] CR2: 00007ff3d576c920 CR3: 0000001191a56006 CR4:
0000000000770ef0
[156843.734392] PKRU: 55555554
[156843.737427] Call Trace:
[156843.740201]  <TASK>
[156843.742626] ? show_regs (arch/x86/kernel/dumpstack.c:479)
[156843.746352] ? die (arch/x86/kernel/dumpstack.c:421
arch/x86/kernel/dumpstack.c:434 arch/x86/kernel/dumpstack.c:447)
[156843.749562] ? do_trap (arch/x86/kernel/traps.c:112
arch/x86/kernel/traps.c:153)
[156843.753106] ? do_error_trap (./arch/x86/include/asm/traps.h:59
arch/x86/kernel/traps.c:174)
[156843.757245] ? bch2_extent_crc_append (fs/bcachefs/extents.c:570
(discriminator 1))
[156843.762258] ? exc_invalid_op (arch/x86/kernel/traps.c:265)
[156843.766397] ? bch2_extent_crc_append (fs/bcachefs/extents.c:570
(discriminator 1))
[156843.771408] ? asm_exc_invalid_op (./arch/x86/include/asm/idtentry.h:568)
[156843.775902] ? bch2_extent_crc_append (fs/bcachefs/extents.c:570
(discriminator 1))
[156843.780919] bch2_extent_ptr_decoded_append
(fs/bcachefs/extents.c:735 (discriminator 2))
[156843.786464] __bch2_data_update_index_update
(./arch/x86/include/asm/bitops.h:251 fs/bcachefs/extents.h:55
fs/bcachefs/extents.h:64 fs/bcachefs/data_update.c:218)
[156843.792258] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:181)
[156843.797363] ? __bch2_data_update_index_update
(./arch/x86/include/asm/bitops.h:251 fs/bcachefs/extents.h:55
fs/bcachefs/extents.h:64 fs/bcachefs/data_update.c:218)
[156843.803334] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:181)
[156843.808439] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:181)
[156843.813534] ? lock_release (./include/trace/events/lock.h:69
(discriminator 2) kernel/locking/lockdep.c:5765 (discriminator 2))
[156843.817685] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:181)
[156843.822796] ? _raw_spin_unlock_irqrestore
(./arch/x86/include/asm/paravirt.h:700
./arch/x86/include/asm/irqflags.h:135
./include/linux/spinlock_api_smp.h:151 kernel/locking/spinlock.c:194)
[156843.828071] ? mempool_free_slab (mm/mempool.c:526)
[156843.832483] ? __bch2_data_update_index_update
(fs/bcachefs/data_update.c:121)
[156843.838373] bch2_data_update_index_update
(fs/bcachefs/data_update.c:339 (discriminator 2))
[156843.843643] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:181)
[156843.848747] ? bch2_data_update_index_update
(fs/bcachefs/data_update.c:339 (discriminator 2))
[156843.854191] __bch2_write_index (fs/bcachefs/io_write.c:523
(discriminator 1))
[156843.858603] bch2_write_point_do_index_updates (fs/bcachefs/io_write.c:633)
[156843.864323] ? process_one_work (kernel/workqueue.c:2600)
[156843.868818] process_one_work (kernel/workqueue.c:2632)
[156843.873138] worker_thread (kernel/workqueue.c:2694 (discriminator
2) kernel/workqueue.c:2781 (discriminator 2))
[156843.877193] ? __pfx_worker_thread (kernel/workqueue.c:2727)
[156843.881767] kthread (kernel/kthread.c:388)
[156843.885303] ? __pfx_kthread (kernel/kthread.c:341)
[156843.889349] ret_from_fork (arch/x86/kernel/process.c:153)
[156843.893222] ? __pfx_kthread (kernel/kthread.c:341)
[156843.897270] ret_from_fork_asm (arch/x86/entry/entry_64.S:250)
[156843.901487]  </TASK>
[156843.903952] Modules linked in: brd ipmi_ssif cfg80211 binfmt_misc
intel_rapl_msr intel_rapl_common amd64_edac edac_mce_amd kvm_amd kvm
irqbypass wmi_bmof rapl nls_iso8859_1 ccp ptdma i2c_piix4 k10temp
acpi_ipmi ipmi_si ipmi_devintf input_leds joydev ipmi_msghandler
mac_hid dm_multipath msr efi_pstore dmi_sysfs ip_tables x_tables
autofs4 rndis_host cdc_ether usbnet mii hid_generic usbhid hid btrfs
blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx raid1 raid0 multipath linear crct10dif_pclmul
crc32_pclmul ast polyval_clmulni i2c_algo_bit polyval_generic
drm_shmem_helper ghash_clmulni_intel sha512_ssse3 drm_kms_helper
sha256_ssse3 sha1_ssse3 nvme ahci drm tg3 libahci xhci_pci nvme_core
xhci_pci_renesas wmi aesni_intel crypto_simd cryptd [last unloaded:
brd]
[156843.975780] ---[ end trace 0000000000000000 ]---
[156844.122942] RIP: 0010:bch2_extent_crc_append
(fs/bcachefs/extents.c:570 (discriminator 1))
[156844.128574] Code: e0 2c 49 09 c4 48 b8 00 00 00 00 00 00 ff ff 49
23 45 00 49 09 c4 0f b7 45 30 4d 89 65 00 66 41 89 45 06 e9 d7 fd ff
ff 0f 0b <0f> 0b 48 c7 c7 80 e8 d1 b4 89 44 24 0c 48 89 74 24 10 e8 12
7a 32
All code
========
   0:    e0 2c                    loopne 0x2e
   2:    49 09 c4                 or     %rax,%r12
   5:    48 b8 00 00 00 00 00     movabs $0xffff000000000000,%rax
   c:    00 ff ff
   f:    49 23 45 00              and    0x0(%r13),%rax
  13:    49 09 c4                 or     %rax,%r12
  16:    0f b7 45 30              movzwl 0x30(%rbp),%eax
  1a:    4d 89 65 00              mov    %r12,0x0(%r13)
  1e:    66 41 89 45 06           mov    %ax,0x6(%r13)
  23:    e9 d7 fd ff ff           jmp    0xfffffffffffffdff
  28:    0f 0b                    ud2
  2a:*    0f 0b                    ud2        <-- trapping instruction
  2c:    48 c7 c7 80 e8 d1 b4     mov    $0xffffffffb4d1e880,%rdi
  33:    89 44 24 0c              mov    %eax,0xc(%rsp)
  37:    48 89 74 24 10           mov    %rsi,0x10(%rsp)
  3c:    e8                       .byte 0xe8
  3d:    12 7a 32                 adc    0x32(%rdx),%bh

Code starting with the faulting instruction
===========================================
   0:    0f 0b                    ud2
   2:    48 c7 c7 80 e8 d1 b4     mov    $0xffffffffb4d1e880,%rdi
   9:    89 44 24 0c              mov    %eax,0xc(%rsp)
   d:    48 89 74 24 10           mov    %rsi,0x10(%rsp)
  12:    e8                       .byte 0xe8
  13:    12 7a 32                 adc    0x32(%rdx),%bh
[156844.147875] RSP: 0018:ffffc9003099b860 EFLAGS: 00010206
[156844.153433] RAX: 0000000000000018 RBX: 00000000002e0000 RCX:
01020000084fa683
[156844.160906] RDX: 0000000000000003 RSI: 0000000000000004 RDI:
0000000000000000
[156844.168381] RBP: ffffc9003099b8c8 R08: 0000001800000018 R09:
0000000000000504
[156844.175851] R10: 46b80660880ccf27 R11: 0000000000000040 R12:
54020000002e0178
[156844.183336] R13: ffff889096a1f8d0 R14: ffff889096a1f800 R15:
0002000000000000
[156844.190818] FS:  0000000000000000(0000) GS:ffff88bf4ea80000(0000)
knlGS:0000000000000000
[156844.199252] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[156844.205351] CR2: 00007ff3d576c920 CR3: 0000001191a56006 CR4:
0000000000770ef0
[156844.212839] PKRU: 55555554
[156844.452880] bcachefs-gym: bcachefs device evacuate /dev/ram4
[156845.095135] ------------[ cut here ]------------
[156845.106230] kernel BUG at fs/bcachefs/extents.c:570!
[156845.111552] invalid opcode: 0000 [#2] PREEMPT SMP NOPTI
[156845.117119] CPU: 20 PID: 1520535 Comm: kworker/u100:9 Tainted: G
   D            6.7.0-rc7+ #27
[156845.126329] Hardware name: Supermicro AS -3014TS-i/H12SSL-i, BIOS
2.5 09/08/2022
[156845.134070] Workqueue: bcachefs bch2_write_point_do_index_updates
[156845.140518] RIP: 0010:bch2_extent_crc_append
(fs/bcachefs/extents.c:570 (discriminator 1))
[156845.146185] Code: e0 2c 49 09 c4 48 b8 00 00 00 00 00 00 ff ff 49
23 45 00 49 09 c4 0f b7 45 30 4d 89 65 00 66 41 89 45 06 e9 d7 fd ff
ff 0f 0b <0f> 0b 48 c7 c7 80 e8 d1 b4 89 44 24 0c 48 89 74 24 10 e8 12
7a 32
All code
========
   0:    e0 2c                    loopne 0x2e
   2:    49 09 c4                 or     %rax,%r12
   5:    48 b8 00 00 00 00 00     movabs $0xffff000000000000,%rax
   c:    00 ff ff
   f:    49 23 45 00              and    0x0(%r13),%rax
  13:    49 09 c4                 or     %rax,%r12
  16:    0f b7 45 30              movzwl 0x30(%rbp),%eax
  1a:    4d 89 65 00              mov    %r12,0x0(%r13)
  1e:    66 41 89 45 06           mov    %ax,0x6(%r13)
  23:    e9 d7 fd ff ff           jmp    0xfffffffffffffdff
  28:    0f 0b                    ud2
  2a:*    0f 0b                    ud2        <-- trapping instruction
  2c:    48 c7 c7 80 e8 d1 b4     mov    $0xffffffffb4d1e880,%rdi
  33:    89 44 24 0c              mov    %eax,0xc(%rsp)
  37:    48 89 74 24 10           mov    %rsi,0x10(%rsp)
  3c:    e8                       .byte 0xe8
  3d:    12 7a 32                 adc    0x32(%rdx),%bh

Code starting with the faulting instruction
===========================================
   0:    0f 0b                    ud2
   2:    48 c7 c7 80 e8 d1 b4     mov    $0xffffffffb4d1e880,%rdi
   9:    89 44 24 0c              mov    %eax,0xc(%rsp)
   d:    48 89 74 24 10           mov    %rsi,0x10(%rsp)
  12:    e8                       .byte 0xe8
  13:    12 7a 32                 adc    0x32(%rdx),%bh
[156845.165581] RSP: 0018:ffffc9002bb03860 EFLAGS: 00010206
[156845.171177] RAX: 0000000000000018 RBX: 00000000004e0000 RCX:
020400000821fd03
[156845.178685] RDX: 0000000000000003 RSI: 0000000000000004 RDI:
0000000000000000
[156845.186206] RBP: ffffc9002bb038c8 R08: 0000002800000028 R09:
0000000000000504
[156845.193712] R10: 322aa91121ec5930 R11: 0000000000000018 R12:
5400c000004e0278
[156845.201244] R13: ffff888138f060d0 R14: ffff888138f06000 R15:
0000c00000000000
[156845.208756] FS:  0000000000000000(0000) GS:ffff88bf4e200000(0000)
knlGS:0000000000000000
[156845.217223] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[156845.223350] CR2: 00007f503e134f08 CR3: 0000001191a56004 CR4:
0000000000770ef0
[156845.230865] PKRU: 55555554
[156845.233960] Call Trace:
[156845.236793]  <TASK>
[156845.239282] ? show_regs (arch/x86/kernel/dumpstack.c:479)
[156845.243069] ? die (arch/x86/kernel/dumpstack.c:421
arch/x86/kernel/dumpstack.c:434 arch/x86/kernel/dumpstack.c:447)
[156845.246334] ? do_trap (arch/x86/kernel/traps.c:112
arch/x86/kernel/traps.c:153)
[156845.249951] ? do_error_trap (./arch/x86/include/asm/traps.h:59
arch/x86/kernel/traps.c:174)
[156845.254194] ? bch2_extent_crc_append (fs/bcachefs/extents.c:570
(discriminator 1))
[156845.259277] ? exc_invalid_op (arch/x86/kernel/traps.c:265)
[156845.263486] ? bch2_extent_crc_append (fs/bcachefs/extents.c:570
(discriminator 1))
[156845.268556] ? asm_exc_invalid_op (./arch/x86/include/asm/idtentry.h:568)
[156845.273112] ? bch2_extent_crc_append (fs/bcachefs/extents.c:570
(discriminator 1))
[156845.278178] bch2_extent_ptr_decoded_append
(fs/bcachefs/extents.c:735 (discriminator 2))
[156845.283769] __bch2_data_update_index_update
(./arch/x86/include/asm/bitops.h:251 fs/bcachefs/extents.h:55
fs/bcachefs/extents.h:64 fs/bcachefs/data_update.c:218)
[156845.289607] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:181)
[156845.294746] ? __bch2_data_update_index_update
(./arch/x86/include/asm/bitops.h:251 fs/bcachefs/extents.h:55
fs/bcachefs/extents.h:64 fs/bcachefs/data_update.c:218)
[156845.300752] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:181)
[156845.305882] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:181)
[156845.311004] ? lock_release (./include/trace/events/lock.h:69
(discriminator 2) kernel/locking/lockdep.c:5765 (discriminator 2))
[156845.315169] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:181)
[156845.320290] ? _raw_spin_unlock_irqrestore
(./arch/x86/include/asm/paravirt.h:700
./arch/x86/include/asm/irqflags.h:135
./include/linux/spinlock_api_smp.h:151 kernel/locking/spinlock.c:194)
[156845.325580] ? mempool_free_slab (mm/mempool.c:526)
[156845.330004] ? __bch2_data_update_index_update
(fs/bcachefs/data_update.c:121)
[156845.335919] bch2_data_update_index_update
(fs/bcachefs/data_update.c:339 (discriminator 2))
[156845.341197] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:181)
[156845.346303] ? bch2_data_update_index_update
(fs/bcachefs/data_update.c:339 (discriminator 2))
[156845.351755] __bch2_write_index (fs/bcachefs/io_write.c:523
(discriminator 1))
[156845.356167] bch2_write_point_do_index_updates (fs/bcachefs/io_write.c:633)
[156845.361878] ? process_one_work (kernel/workqueue.c:2600)
[156845.366409] process_one_work (kernel/workqueue.c:2632)
[156845.370728] worker_thread (kernel/workqueue.c:2694 (discriminator
2) kernel/workqueue.c:2781 (discriminator 2))
[156845.374781] ? __pfx_worker_thread (kernel/workqueue.c:2727)
[156845.379373] kthread (kernel/kthread.c:388)
[156845.382900] ? __pfx_kthread (kernel/kthread.c:341)
[156845.386949] ret_from_fork (arch/x86/kernel/process.c:153)
[156845.390839] ? __pfx_kthread (kernel/kthread.c:341)
[156845.394888] ret_from_fork_asm (arch/x86/entry/entry_64.S:250)
[156845.399129]  </TASK>
[156845.401592] Modules linked in: brd ipmi_ssif cfg80211 binfmt_misc
intel_rapl_msr intel_rapl_common amd64_edac edac_mce_amd kvm_amd kvm
irqbypass wmi_bmof rapl nls_iso8859_1 ccp ptdma i2c_piix4 k10temp
acpi_ipmi ipmi_si ipmi_devintf input_leds joydev ipmi_msghandler
mac_hid dm_multipath msr efi_pstore dmi_sysfs ip_tables x_tables
autofs4 rndis_host cdc_ether usbnet mii hid_generic usbhid hid btrfs
blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx raid1 raid0 multipath linear crct10dif_pclmul
crc32_pclmul ast polyval_clmulni i2c_algo_bit polyval_generic
drm_shmem_helper ghash_clmulni_intel sha512_ssse3 drm_kms_helper
sha256_ssse3 sha1_ssse3 nvme ahci drm tg3 libahci xhci_pci nvme_core
xhci_pci_renesas wmi aesni_intel crypto_simd cryptd [last unloaded:
brd]
[156845.473453] ---[ end trace 0000000000000000 ]---
[156845.620905] RIP: 0010:bch2_extent_crc_append
(fs/bcachefs/extents.c:570 (discriminator 1))
[156845.626525] Code: e0 2c 49 09 c4 48 b8 00 00 00 00 00 00 ff ff 49
23 45 00 49 09 c4 0f b7 45 30 4d 89 65 00 66 41 89 45 06 e9 d7 fd ff
ff 0f 0b <0f> 0b 48 c7 c7 80 e8 d1 b4 89 44 24 0c 48 89 74 24 10 e8 12
7a 32
All code
========
   0:    e0 2c                    loopne 0x2e
   2:    49 09 c4                 or     %rax,%r12
   5:    48 b8 00 00 00 00 00     movabs $0xffff000000000000,%rax
   c:    00 ff ff
   f:    49 23 45 00              and    0x0(%r13),%rax
  13:    49 09 c4                 or     %rax,%r12
  16:    0f b7 45 30              movzwl 0x30(%rbp),%eax
  1a:    4d 89 65 00              mov    %r12,0x0(%r13)
  1e:    66 41 89 45 06           mov    %ax,0x6(%r13)
  23:    e9 d7 fd ff ff           jmp    0xfffffffffffffdff
  28:    0f 0b                    ud2
  2a:*    0f 0b                    ud2        <-- trapping instruction
  2c:    48 c7 c7 80 e8 d1 b4     mov    $0xffffffffb4d1e880,%rdi
  33:    89 44 24 0c              mov    %eax,0xc(%rsp)
  37:    48 89 74 24 10           mov    %rsi,0x10(%rsp)
  3c:    e8                       .byte 0xe8
  3d:    12 7a 32                 adc    0x32(%rdx),%bh

Code starting with the faulting instruction
===========================================
   0:    0f 0b                    ud2
   2:    48 c7 c7 80 e8 d1 b4     mov    $0xffffffffb4d1e880,%rdi
   9:    89 44 24 0c              mov    %eax,0xc(%rsp)
   d:    48 89 74 24 10           mov    %rsi,0x10(%rsp)
  12:    e8                       .byte 0xe8
  13:    12 7a 32                 adc    0x32(%rdx),%bh
[156845.645823] RSP: 0018:ffffc9003099b860 EFLAGS: 00010206
[156845.651410] RAX: 0000000000000018 RBX: 00000000002e0000 RCX:
01020000084fa683
[156845.658875] RDX: 0000000000000003 RSI: 0000000000000004 RDI:
0000000000000000
[156845.666369] RBP: ffffc9003099b8c8 R08: 0000001800000018 R09:
0000000000000504
[156845.673840] R10: 46b80660880ccf27 R11: 0000000000000040 R12:
54020000002e0178
[156845.681352] R13: ffff889096a1f8d0 R14: ffff889096a1f800 R15:
0002000000000000
[156845.688841] FS:  0000000000000000(0000) GS:ffff88bf4e200000(0000)
knlGS:0000000000000000
[156845.697277] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[156845.703371] CR2: 00007f503e134f08 CR3: 0000001191a56004 CR4:
0000000000770ef0
[156845.710857] PKRU: 55555554
--
Daniel J Blueman
