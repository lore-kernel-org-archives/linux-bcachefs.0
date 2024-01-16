Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E8A1CA82
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l3e7uenZ"
Date: Tue, 16 Jan 2024 11:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705423060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7EH+Z4niZBu0M42WxF8l9OI07xa0HO36eVs1K7xOdWI=;
	b=l3e7uenZn/lqulVMlu9Po1dXLvritg9F7gkIthnopl7VaRu38mLYkUthIsWnLaf8mKppfH
	wnVKjomp/AOup29DCYyWuTIcznRbVjKXOHfxlUIg9TUBFCmJKA2A8DRhiUfSi9NDz6xL9r
	GQCB3fcZyAHM9+zCkKwgTK8HvDCP8Jk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] general protection fault, probably for non-canonical
 address 0x280766500040001: 0000 [#1] PREEMPT SMP PTI
Message-ID: <bcmdk4y5rgiq27yg2mu45yulgx6gsiwac4zirw4wrsyjg6li2t@hgog4yapugnq>
References: <ZaahtMNCEd42G3EP@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaahtMNCEd42G3EP@bfoster>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 16, 2024 at 10:33:08AM -0500, Brian Foster wrote:
> Hi Kent,
> 
> JFYI, I'm seeing the following splat pretty reliably via generic/361 on
> an 80xcpu test box. The CI doesn't seem to produce this failure for
> whatever reason. This bisects down to commit 023f9ac9f70f ("bcachefs:
> Delete dio read alignment check"), before which the test still fails but
> the kernel doesn't explode.

Ahh, that probably needs to be a 512 byte alignment check; since the
block layer alternates units between bytes and 512 byte sectors things
will get very confused if the IO wasn't 512 byte aligned.

> 
> Brian
> 
> --- 8< ---
> 
> general protection fault, probably for non-canonical address 0x280766500040001: 0000 [#1] PREEMPT SMP PTI
> CPU: 15 PID: 1078 Comm: kworker/15:1H Tainted: G           OE      6.7.0-rc7+ #68 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
> Workqueue: events_highpri __bch2_read_endio [bcachefs]
> RIP: 0010:bio_copy_data_iter+0x186/0x260
> Code: 29 f6 48 c1 f9 06 48 c1 fe 06 48 c1 e1 0c 48 c1 e6 0c 48 01 e9 48 01 ee 48 01 d9 4c 01 d6 83 fa 08 0f 82 b0 fe ff ff 48 8b 06 <48> 89 01 89 d0 48 8b 7c 06 f8 48 89 7c 01 f8 48 8d 79 08 48 83 e7 
> RSP: 0018:ffffa31644a63d38 EFLAGS: 00010212
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0280766500040001
> RDX: 0000000000000c00 RSI: ffff8d462b83d400 RDI: ffff8d460fc9edd0
> RBP: ffff8d4500000000 R08: ffffa31644a63dc0 R09: ffffa31644a63dd4
> R10: 0000000000000400 R11: 0000000000000c00 R12: ffff8d462beb9aa8
> R13: ffff8d460fc9ed38 R14: fffffc5e80000000 R15: 0000000000001000
> FS:  0000000000000000(0000) GS:ffff8d64fdd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7255016120 CR3: 000000012534e003 CR4: 0000000000770ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554 
> Call Trace:
>  <TASK>
>  ? die_addr+0x32/0x80
>  ? exc_general_protection+0x19b/0x450
>  ? asm_exc_general_protection+0x22/0x30
>  ? bio_copy_data_iter+0x186/0x260
>  __bch2_read_endio+0x83d/0x920 [bcachefs]
>  ? process_one_work+0x192/0x4d0
>  ? process_one_work+0x1fc/0x4d0
>  process_one_work+0x1fc/0x4d0
>  worker_thread+0x1dd/0x3d0
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0x100/0x130
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x2d/0x50
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1b/0x30
>  </TASK>
> Modules linked in: bcachefs(OE) lz4_compress(E) lz4hc_compress(E) nft_fib_inet(E) nft_fib_ipv4(E) nft_fib_ipv6(E) nft_fib(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) rfkill(E) ip_set(E) nf_tables(E) nfnetlink(E) sunrpc(E) intel_rapl_msr(E) intel_rapl_common(E) intel_uncore_frequency_common(E) isst_if_common(E) kvm_intel(E) kvm(E) iTCO_wdt(E) intel_pmc_bxt(E) iTCO_vendor_support(E) irqbypass(E) virtio_balloon(E) rapl(E) pktcdvd(E) i2c_i801(E) pcspkr(E) i2c_smbus(E) lpc_ich(E) joydev(E) loop(E) zram(E) crct10dif_pclmul(E) crc32_pclmul(E) crc32c_intel(E) virtiofs(E) virtio_net(E) net_failover(E) ghash_clmulni_intel(E) virtio_console(E) failover(E) fuse(E) virtio_blk(E) serio_raw(E) btrfs(E) xor(E) zstd_compress(E) raid6_pq(E) qemu_fw_cfg(E) 
> Unloaded tainted modules: bcachefs(E):3 intel_uncore_frequency(E):1 isst_if_mbox_msr(E):1 [last unloaded: bcachefs(OE)]
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bio_copy_data_iter+0x186/0x260
> Code: 29 f6 48 c1 f9 06 48 c1 fe 06 48 c1 e1 0c 48 c1 e6 0c 48 01 e9 48 01 ee 48 01 d9 4c 01 d6 83 fa 08 0f 82 b0 fe ff ff 48 8b 06 <48> 89 01 89 d0 48 8b 7c 06 f8 48 89 7c 01 f8 48 8d 79 08 48 83 e7 
> RSP: 0018:ffffa31644a63d38 EFLAGS: 00010212
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0280766500040001
> RDX: 0000000000000c00 RSI: ffff8d462b83d400 RDI: ffff8d460fc9edd0
> RBP: ffff8d4500000000 R08: ffffa31644a63dc0 R09: ffffa31644a63dd4
> R10: 0000000000000400 R11: 0000000000000c00 R12: ffff8d462beb9aa8
> R13: ffff8d460fc9ed38 R14: fffffc5e80000000 R15: 0000000000001000
> FS:  0000000000000000(0000) GS:ffff8d64fdd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7255016120 CR3: 000000012534e003 CR4: 0000000000770ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554 
> 
