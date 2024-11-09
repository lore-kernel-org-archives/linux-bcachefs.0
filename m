Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F46F233D6B
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Nov 2024 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731166685; cv=none; b=OfBjNiwL8ccw8K78OuJoXaAikXKAsv+6/nwxc8x/OWEbHRvA8J22pXNGJdFviMgin69EC6FeYlKOanTWmwMzxpg1fwTCaM3NY7j7u3ZQZhdm0Mjsy0t3CffXaDCIC8buq+5CWVomlkopqi6r201e/XChkh3V628jmsAN8i8e7Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731166685; c=relaxed/simple;
	bh=NUlG33GeGsq8W704Sy+P4Xlfjr9SRPlkmef62pjUBeA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=RhSyBTiyWlW0HpSaBcQ0lEPvhMbzbQeZj/dPCFL26nsek+O+DgocdTfK4n996PsdCeE2/dnrRGzz45EOfG9XBVTJfUCLrCyIWxXOqomoOOiKAIT4i6Hko4YcnlCApC8/dbRg4dI7J/SqOl1VD5wcbwZKBxGB4inAdpax53cWSG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83abb164a4fso338592939f.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 09 Nov 2024 07:38:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731166682; x=1731771482;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifLbF7tba7dV9fo+j6bMpoi+nS3nzD2LspYJkXnoP4g=;
        b=p0ztSPO2MdEtPd+Fg8TOA57gepksNOdvWeJUw0vkiUsGJ+3xWavxUVNmFEJn1WxCao
         c2LNk0naIRFnngkhcfzqloKORQHgMTQGjrZx5kMI5hwJ/NagKsGFcH9371LEBZv++ZEO
         VDbSLHGBLDb8XwdSSlyN/8rRMRxTuhpHDpjY34qzwFhlsEx0gam83mdxPWoC9RqT95q3
         na8+KNExWOgsXjmKfS+TpvNGKVeHK1w80Xb9AaIopvT4AdOds6emQS6dJkIRHhlxD8oW
         ExK8T8pRcUQ1K7D5X59Nt8D/mBSzj321X/p5PE9oaA0SqJNJdz3ViehFe/cXENYs8Lc5
         NL2g==
X-Forwarded-Encrypted: i=1; AJvYcCU+sutlHJpxbG1jfeIesz6KCuLGhtqIt+ifDwR1ECofOew4Yt9bQv24VIH2GFxa3Yor2rI0iXtCsMbuYiCPsA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsJFZa2jHsPRUfmYq+H19ZxeWWFEOW5a/JyjMcXDIvNDidz0+L
	k7D2CbKy86ztgMA1zhorJxuprKSlRjyE1RlEi5u0rclscD7KV/uC7jLYp3icBwxYjMyGWaZdvmM
	UXg3xUIAxNMdXE6BtowBMsd9wyXnusCcTnClxPRWAGX2P9LFRQDf63MY=
X-Google-Smtp-Source: AGHT+IHVpGJg8dwgI05qQUbeEvlSoSb3Afb7zGouadR/j39K13hCjjwNb3ONOUgP0ME32GwPjvG8hPDPNxr7jm2IvVGoxvGdP4Wx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e0e:b0:3a5:e250:bba1 with SMTP id
 e9e14a558f8ab-3a6f1a48f15mr68673585ab.18.1731166682623; Sat, 09 Nov 2024
 07:38:02 -0800 (PST)
Date: Sat, 09 Nov 2024 07:38:02 -0800
In-Reply-To: <CAHiZj8hLZ3es4arB89eVfspki+Un9PXBedjo_vMix81F7OdMiw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672f81da.050a0220.138bd5.0042.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_copygc
From: syzbot <syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, surajsonawane0215@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

 50.774453][    T1] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   50.781444][    T1] Bluetooth: HIDP socket layer initialized
[   50.797785][    T1] NET: Registered PF_RXRPC protocol family
[   50.804021][    T1] Key type rxrpc registered
[   50.819166][    T1] Key type rxrpc_s registered
[   50.826057][    T1] NET: Registered PF_KCM protocol family
[   50.846625][    T1] lec:lane_module_init: lec.c: initialized
[   50.853444][    T1] mpoa:atm_mpoa_init: mpc.c: initialized
[   50.859905][    T1] l2tp_core: L2TP core driver, V2.0
[   50.865318][    T1] l2tp_ppp: PPPoL2TP kernel driver, V2.0
[   50.871283][    T1] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[   50.878166][    T1] l2tp_netlink: L2TP netlink interface
[   50.885393][    T1] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[   50.892494][    T1] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2=
TPv3)
[   50.900671][    T1] NET: Registered PF_PHONET protocol family
[   50.907360][    T1] 8021q: 802.1Q VLAN Support v1.8
[   51.102849][    T1] DCCP: Activated CCID 2 (TCP-like)
[   51.108517][    T1] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   51.116104][    T1] DCCP is deprecated and scheduled to be removed in 20=
25, please contact the netdev mailing list
[   51.128488][    T1] sctp: Hash tables configured (bind 256/256)
[   51.138259][    T1] NET: Registered PF_RDS protocol family
[   51.145646][    T1] Registered RDS/infiniband transport
[   51.152112][    T1] Registered RDS/tcp transport
[   51.157009][    T1] tipc: Activated (version 2.0.0)
[   51.162932][    T1] NET: Registered PF_TIPC protocol family
[   51.172284][    T1] tipc: Started in single node mode
[   51.181079][    T1] NET: Registered PF_SMC protocol family
[   51.188572][    T1] 9pnet: Installing 9P2000 support
[   51.194814][    T1] NET: Registered PF_CAIF protocol family
[   51.210492][    T1] NET: Registered PF_IEEE802154 protocol family
[   51.217577][    T1] Key type dns_resolver registered
[   51.223062][    T1] Key type ceph registered
[   51.229158][    T1] libceph: loaded (mon/osd proto 15/24)
[   51.239598][    T1] batman_adv: B.A.T.M.A.N. advanced 2024.2 (compatibil=
ity version 15) loaded
[   51.250892][    T1] openvswitch: Open vSwitch switching datapath
[   51.264974][    T1] NET: Registered PF_VSOCK protocol family
[   51.272186][    T1] mpls_gso: MPLS GSO support
[   51.450427][    T1] IPI shorthand broadcast: enabled
[   52.943974][    T1] sched_clock: Marking stable (52920073484, 17910237)-=
>(52943420691, -5436970)
[   53.846634][    T1] registered taskstats version 1
[   54.206864][    T1] Loading compiled-in X.509 certificates
[   54.419109][    T1] Loaded X.509 cert 'Build time autogenerated kernel k=
ey: 3afbfeee723402980abb37b86a2db814127d2bc0'
[   54.616601][    T1] zswap: loaded using pool 842/z3fold
[   54.626356][    T1] Demotion targets for Node 0: null
[   54.631798][    T1] Demotion targets for Node 1: null
[   54.638926][    T1] Key type .fscrypt registered
[   54.643798][    T1] Key type fscrypt-provisioning registered
[   54.650935][    T1] kAFS: Red Hat AFS client v0.1 registering.
[   54.681984][    T1] Btrfs loaded, assert=3Don, ref-verify=3Don, zoned=3D=
yes, fsverity=3Dyes
[   54.709423][    T1] Key type encrypted registered
[   54.714433][    T1] AppArmor: AppArmor sha256 policy hashing enabled
[   54.721401][    T1] ima: No TPM chip found, activating TPM-bypass!
[   54.728680][    T1] Loading compiled-in module X.509 certificates
[   54.941142][    T1] Loaded X.509 cert 'Build time autogenerated kernel k=
ey: 3afbfeee723402980abb37b86a2db814127d2bc0'
[   54.952371][    T1] ima: Allocated hash algorithm: sha256
[   54.958585][    T1] ima: No architecture policies found
[   54.964951][    T1] evm: Initialising EVM extended attributes:
[   54.971215][    T1] evm: security.selinux (disabled)
[   54.976617][    T1] evm: security.SMACK64 (disabled)
[   54.981894][    T1] evm: security.SMACK64EXEC (disabled)
[   54.987418][    T1] evm: security.SMACK64TRANSMUTE (disabled)
[   54.993607][    T1] evm: security.SMACK64MMAP (disabled)
[   54.999295][    T1] evm: security.apparmor
[   55.003593][    T1] evm: security.ima
[   55.007621][    T1] evm: security.capability
[   55.012225][    T1] evm: HMAC attrs: 0x1
[   55.021328][    T1] PM:   Magic number: 0:225:487
[   55.029686][    T1] printk: legacy console [netcon0] enabled
[   55.035666][    T1] netconsole: network logging started
[   55.042737][    T1] gtp: GTP module loaded (pdp ctx size 128 bytes)
[   55.058912][    T1] rdma_rxe: loaded
[   55.064750][    T1] cfg80211: Loading compiled-in X.509 certificates for=
 regulatory database
[   55.085688][    T1] Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   55.106043][    T1] Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06=
c7248db18c600'
[   55.114756][    T1] clk: Disabling unused clocks
[   55.120039][    T1] ALSA device list:
[   55.123967][    T1]   #0: Dummy 1
[   55.127679][    T1]   #1: Loopback 1
[   55.131629][    T1]   #2: Virtual MIDI Card 1
[   55.142147][   T10] platform regulatory.0: Direct firmware load for regu=
latory.db failed with error -2
[   55.152179][   T10] platform regulatory.0: Falling back to sysfs fallbac=
k for: regulatory.db
[   55.162763][    T1] md: Waiting for all devices to be available before a=
utodetect
[   55.170980][    T1] md: If you don't use raid, use raid=3Dnoautodetect
[   55.177606][    T1] md: Autodetecting RAID arrays.
[   55.182740][    T1] md: autorun ...
[   55.186465][    T1] md: ... autorun DONE.
[   55.280324][    T1] EXT4-fs (sda1): mounted filesystem b4773fba-1738-4da=
0-8a90-0fe043d0a496 ro with ordered data mode. Quota mode: none.
[   55.293956][    T1] VFS: Mounted root (ext4 filesystem) readonly on devi=
ce 8:1.
[   55.306041][    T1] devtmpfs: mounted
[   55.569063][    T1] Freeing unused kernel image (initmem) memory: 37960K
[   55.582373][    T1] Write protecting the kernel read-only data: 268288k
[   55.618434][    T1] Freeing unused kernel image (rodata/data gap) memory=
: 880K
[   57.283297][    T1] x86/mm: Checked W+X mappings: passed, no W+X pages f=
ound.
[   57.293937][    T1] x86/mm: Checking user space page tables
[   58.776653][    T1] x86/mm: Checked W+X mappings: passed, no W+X pages f=
ound.
[   58.785687][    T1] Failed to set sysctl parameter 'kernel.hung_task_all=
_cpu_backtrace=3D1': parameter not found
[   58.806387][    T1] Failed to set sysctl parameter 'max_rcu_stall_to_pan=
ic=3D1': parameter not found
[   58.817807][    T1] Run /sbin/init as init process
[   60.404661][ T5117] mount (5117) used greatest stack depth: 8200 bytes l=
eft
[   60.474634][ T5118] EXT4-fs (sda1): re-mounted b4773fba-1738-4da0-8a90-0=
fe043d0a496 r/w. Quota mode: none.
mount: mounting devtmpfs on /dev failed: Device or resource busy
mount: mounting smackfs on /sys/fs/smackfs failed: No such file or director=
y
mount: mounting selinuxfs on /sys/fs/selinux failed: No such file or direct=
ory
[   60.878171][ T5122] mount (5122) used greatest stack depth: 5464 bytes l=
eft
Starting syslogd: OK
Starting acpid: OK
[   62.117568][ T5138] BUG: unable to handle page fault for address: ffffff=
fffffffee8
[   62.126177][ T5138] #PF: supervisor read access in kernel mode
[   62.132457][ T5138] #PF: error_code(0x0000) - not-present page
[   62.139539][ T5138] PGD 11676067 P4D 11676067 PUD 11678067 PMD 0=20
[   62.147018][ T5138] Oops: Oops: 0000 [#1] PREEMPT SMP PTI
[   62.155203][ T5138] CPU: 0 UID: 0 PID: 5138 Comm: acpid Not tainted 6.12=
.0-rc6-syzkaller-00272-gda4373fbcf00-dirty #0
[   62.168682][ T5138] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 10/30/2024
[   62.181817][ T5138] RIP: 0010:__netlink_lookup+0x45f/0x7f0
[   62.189763][ T5138] Code: 45 7d 94 4c 89 6d c8 49 09 c5 4c 89 ad 78 ff f=
f ff 0f 85 e9 00 00 00 44 89 7d 9c 4d 89 f4 48 8b 45 c0 49 8d bc 06 18 03 0=
0 00 <8b> 1f e8 1a 0e 1d f5 44 8b 38 44 8b 32 48 8b 45 a8 44 89 38 44 89
[   62.212248][ T5138] RSP: 0018:ffff8881177e3b68 EFLAGS: 00010246
[   62.219552][ T5138] RAX: fffffffffffffbd0 RBX: 0000000000000000 RCX: 000=
00001173e3bf0
[   62.228167][ T5138] RDX: ffff8881173e3bf0 RSI: ffff88813ffface0 RDI: fff=
ffffffffffee8
[   62.237084][ T5138] RBP: ffff8881177e3c38 R08: ffffea000000000f R09: 000=
0000000000000
[   62.246984][ T5138] R10: ffff888116fe3bf0 R11: ffffffff8d30e8f8 R12: 000=
0000000000000
[   62.258393][ T5138] R13: 0000000000000000 R14: 0000000000000000 R15: 000=
0000000000000
[   62.267127][ T5138] FS:  00007f4626133740(0000) GS:ffff88813fc00000(0000=
) knlGS:0000000000000000
[   62.277002][ T5138] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.284814][ T5138] CR2: fffffffffffffee8 CR3: 000000011b32c000 CR4: 000=
00000003526f0
[   62.294468][ T5138] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
[   62.303762][ T5138] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
[   62.314028][ T5138] Call Trace:
[   62.318350][ T5138]  <TASK>
[   62.321703][ T5138]  ? show_trace_log_lvl+0x268/0x3d0
[   62.327988][ T5138]  ? netlink_autobind+0x168/0x460
[   62.333412][ T5138]  ? __die_body+0xce/0x1a0
[   62.338610][ T5138]  ? __die+0x22a/0x290
[   62.343875][ T5138]  ? page_fault_oops+0xe58/0xfb0
[   62.350270][ T5138]  ? kernelmode_fixup_or_oops+0x1b5/0x1d0
[   62.356542][ T5138]  ? __bad_area_nosemaphore+0x17b/0x960
[   62.362639][ T5138]  ? kmsan_internal_poison_memory+0x7d/0x90
[   62.368997][ T5138]  ? kmsan_get_metadata+0x13e/0x1c0
[   62.375189][ T5138]  ? kmsan_internal_poison_memory+0x49/0x90
[   62.381820][ T5138]  ? kmem_cache_alloc_lru_noprof+0x641/0xb30
[   62.389135][ T5138]  ? __d_alloc+0x69/0x9c0
[   62.394040][ T5138]  ? spurious_kernel_fault+0xef/0xbe0
[   62.400816][ T5138]  ? bad_area_nosemaphore+0x32/0x40
[   62.406710][ T5138]  ? do_kern_addr_fault+0xe0/0x110
[   62.412293][ T5138]  ? exc_page_fault+0x549/0x700
[   62.417483][ T5138]  ? _raw_spin_unlock_irqrestore+0x3f/0x60
[   62.423634][ T5138]  ? asm_exc_page_fault+0x2b/0x30
[   62.429062][ T5138]  ? netlink_autobind+0x168/0x460
[   62.434374][ T5138]  ? __netlink_lookup+0x45f/0x7f0
[   62.439692][ T5138]  ? __netlink_lookup+0x413/0x7f0
[   62.445057][ T5138]  netlink_autobind+0x168/0x460
[   62.450229][ T5138]  netlink_bind+0x1085/0x1a60
[   62.455315][ T5138]  ? __pfx_netlink_bind+0x10/0x10
[   62.460698][ T5138]  __sys_bind+0x4de/0x690
[   62.465334][ T5138]  ? __sys_setsockopt+0x388/0x4c0
[   62.470687][ T5138]  ? kmsan_get_metadata+0x13e/0x1c0
[   62.476710][ T5138]  __x64_sys_bind+0x91/0xe0
[   62.481631][ T5138]  x64_sys_call+0x252d/0x3ba0
[   62.487065][ T5138]  do_syscall_64+0xcd/0x1e0
[   62.492096][ T5138]  ? clear_bhb_loop+0x25/0x80
[   62.497910][ T5138]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   62.506339][ T5138] RIP: 0033:0x7f462620b677
[   62.511199][ T5138] Code: 48 89 44 24 08 e8 f8 59 f9 ff 48 8b 44 24 08 4=
8 83 c4 28 c3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 b8 31 00 00 00 0=
f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 c7 0c 00 f7 d8 64 89 01 48
[   62.531331][ T5138] RSP: 002b:00007ffe1da730b8 EFLAGS: 00000246 ORIG_RAX=
: 0000000000000031
[   62.540116][ T5138] RAX: ffffffffffffffda RBX: 00007ffe1da7310c RCX: 000=
07f462620b677
[   62.548639][ T5138] RDX: 000000000000000c RSI: 00007ffe1da73110 RDI: 000=
0000000000008
[   62.557293][ T5138] RBP: 0000000000000000 R08: 0000000000000004 R09: 000=
07ffe1da73990
[   62.565706][ T5138] R10: 00007ffe1da730d4 R11: 0000000000000246 R12: 000=
07ffe1da73110
[   62.574240][ T5138] R13: 00007ffe1da74a58 R14: 0000000000000003 R15: 000=
07f462631da80
[   62.582590][ T5138]  </TASK>
[   62.585834][ T5138] Modules linked in:
[   62.590235][ T5138] CR2: fffffffffffffee8
[   62.594613][ T5138] ---[ end trace 0000000000000000 ]---
[   62.600280][ T5138] RIP: 0010:__netlink_lookup+0x45f/0x7f0
[   62.606314][ T5138] Code: 45 7d 94 4c 89 6d c8 49 09 c5 4c 89 ad 78 ff f=
f ff 0f 85 e9 00 00 00 44 89 7d 9c 4d 89 f4 48 8b 45 c0 49 8d bc 06 18 03 0=
0 00 <8b> 1f e8 1a 0e 1d f5 44 8b 38 44 8b 32 48 8b 45 a8 44 89 38 44 89
[   62.626677][ T5138] RSP: 0018:ffff8881177e3b68 EFLAGS: 00010246
[   62.633183][ T5138] RAX: fffffffffffffbd0 RBX: 0000000000000000 RCX: 000=
00001173e3bf0
[   62.641683][ T5138] RDX: ffff8881173e3bf0 RSI: ffff88813ffface0 RDI: fff=
ffffffffffee8
[   62.649931][ T5138] RBP: ffff8881177e3c38 R08: ffffea000000000f R09: 000=
0000000000000
[   62.658181][ T5138] R10: ffff888116fe3bf0 R11: ffffffff8d30e8f8 R12: 000=
0000000000000
[   62.666416][ T5138] R13: 0000000000000000 R14: 0000000000000000 R15: 000=
0000000000000
[   62.674647][ T5138] FS:  00007f4626133740(0000) GS:ffff88813fc00000(0000=
) knlGS:0000000000000000
[   62.684043][ T5138] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.690922][ T5138] CR2: fffffffffffffee8 CR3: 000000011b32c000 CR4: 000=
00000003526f0
[   62.699183][ T5138] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
[   62.707402][ T5138] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
[   62.715718][ T5138] Kernel panic - not syncing: Fatal exception
[   62.722556][ T5138] Kernel Offset: disabled
[   62.727049][ T5138] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=3D<nil>)
GO111MODULE=3D'auto'
GOARCH=3D'amd64'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFLAGS=3D''
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMODCACHE=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs-2/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.22.7'
GCCGO=3D'gccgo'
GOAMD64=3D'v1'
AR=3D'ar'
CC=3D'gcc'
CXX=3D'g++'
CGO_ENABLED=3D'1'
GOMOD=3D'/syzkaller/jobs-2/linux/gopath/src/github.com/google/syzkaller/go.=
mod'
GOWORK=3D''
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
PKG_CONFIG=3D'pkg-config'
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build3559642725=3D/tmp/go-build -gno-record-gc=
c-switches'

git status (err=3D<nil>)
HEAD detached at 509da42949
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sy=
s/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
go fmt ./sys/... >/dev/null
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D509da42949c4013fb236ebf6e25d3562d110198c -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20241104-133744'" "-tags=
=3Dsyz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-execpr=
og github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include -fpermissive -w -DGOOS_linu=
x=3D1 -DGOARCH_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"509da42949c4013fb236ebf6e25d3562d1=
10198c\"
/usr/bin/ld: /tmp/ccDyOSX3.o: in function `test_cover_filter()':
executor.cc:(.text+0x1426b): warning: the use of `tempnam' is dangerous, be=
tter use `mkstemp'
/usr/bin/ld: /tmp/ccDyOSX3.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x104): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D1342235f980000


Tested on:

commit:         da4373fb Merge tag 'thermal-6.12-rc7' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3De4580d62ee1893a=
5
dashboard link: https://syzkaller.appspot.com/bug?extid=3D8689d10f1894eedf7=
74d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D1160fd879800=
00

