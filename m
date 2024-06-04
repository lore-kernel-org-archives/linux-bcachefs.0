Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDB81A28B
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Jun 2024 01:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717464443; cv=none; b=lfKlVInN/nYBt+XYGZX5FkadRw4Z7Czjy6AYScGsIhcPG6gpnlY28icYV9Zv+bhd49Vd1H5CD5q2JCJX2pudSTKkLkK1GFmYTJCeHpaZxWXeWrS5hS3FhV20cj4bKC9egrZrdQ9qRwPc5ESJp3nJvH8BlJtHM8KuCP2hTKjSSlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717464443; c=relaxed/simple;
	bh=dCj7UMmcrF1gqcSGhPGYnE1TQwFMDvMXYW9Ip+LTP3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WUu20sIvpstYGZzv/m2wrz27KvPTf3hqdC0Jq+YF0IfuNFp7YQCR0+qEQmT08AT2+jAdQ1raojminEkHH+JOb7JBeI/RvTqIaRDFkCzqWxRpsmEY4SnYUe2ieT7+5Jl+n/djSYKP9y6UrwFRe1yeihq2dj+/LAOXe/VufKRUt+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VtXt05H1Wz2Cjkf;
	Tue,  4 Jun 2024 09:23:36 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id E233A140230;
	Tue,  4 Jun 2024 09:27:16 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 4 Jun 2024 09:27:16 +0800
Message-ID: <366f46a1-b35b-4c75-bcad-b15e420e6236@huawei.com>
Date: Tue, 4 Jun 2024 09:27:16 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: memcpy failed when __bch2_accounting_mem_mod_slowpath
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>, Brian Foster
	<bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>
References: <2d978ffc-ed7b-4039-a713-c885dc8f4d00@huawei.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <2d978ffc-ed7b-4039-a713-c885dc8f4d00@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/6/4 9:22, Hongbo Li wrote:
> I found the following issue on:
> 
> HEAD commit: 587f7f5a4765a76f9ea05159963d14f8967cb45b(cmd_list_journal: 
> open with noexcl, so we can work on mounted filesystems)
> 
> git tree: master
> git repo: https://github.com/koverstreet/bcachefs-tools.git
> util-linux: 2.37.2

Update git info:

- For bcachefs:
HEAD commit: fb33234c7540e8f1f91413e3c6f25c7fd5801636(bcachefs: 
Eytzinger accumulation for accounting keys)
git tree: master
git repo: https://github.com/koverstreet/bcachefs.git

- For bcachefs-tools:
HEAD commit: 587f7f5a4765a76f9ea05159963d14f8967cb45b(cmd_list_journal: 
open with noexcl, so we can work on mounted filesystems)
git tree: master
git repo: https://github.com/koverstreet/bcachefs-tools.git

- For mount:
util-linux: 2.37.2



Thanks,
Hongbo

> 
> IMPORTANT: If someone fix this issue, please kindly add the following 
> tag to the commit:
> 
> Reported-by: Hongbo Li <lihongbo22@huawei.com>
> 
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): mounting version 1.9: 
> disk_accounting_v2
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): initializing new filesystem
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): going read-write
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): marking superblocks
> [Tue Jun  4 09:16:44 2024] ------------[ cut here ]------------
> [Tue Jun  4 09:16:44 2024] memcpy: detected field-spanning write (size 
> 4) of single field "r" at fs/bcachefs/disk_accounting.c:185 (size 3)
> [Tue Jun  4 09:16:44 2024] WARNING: CPU: 6 PID: 11 at 
> fs/bcachefs/disk_accounting.c:185 
> __bch2_accounting_mem_mod_slowpath+0x39f/0x3d0
> [Tue Jun  4 09:16:44 2024] Modules linked in: loop nft_fib_inet 
> nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 
> nf_reject_ipv6 nft_reject nft_ct nft_chain_nat ip6table_nat 
> ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat 
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw 
> iptable_security rfkill ip_set nf_tables nfnetlink ip6table_filter 
> ip6_tables iptable_filter ip_tables intel_rapl_msr intel_rapl_common 
> nfit libnvdimm kvm_intel ppdev kvm rapl joydev bochs drm_vram_helper sg 
> drm_ttm_helper parport_pc parport ttm drm_kms_helper i2c_piix4 pcspkr 
> drm fuse ext4 mbcache jbd2 sr_mod cdrom ata_generic ata_piix 
> crct10dif_pclmul crc32_pclmul virtio_net crc32c_intel net_failover 
> ghash_clmulni_intel failover serio_raw libata sha512_ssse3 virtio_blk 
> virtio_console dimlib dm_mirror dm_region_hash dm_log dm_mod
> [Tue Jun  4 09:16:44 2024] CPU: 6 PID: 11 Comm: kworker/u32:0 Kdump: 
> loaded Not tainted 6.10.0-rc2+ #4
> [Tue Jun  4 09:16:44 2024] Hardware name: QEMU Standard PC (i440FX + 
> PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [Tue Jun  4 09:16:44 2024] Workqueue: btree_update 
> btree_interior_update_work
> [Tue Jun  4 09:16:44 2024] RIP: 
> 0010:__bch2_accounting_mem_mod_slowpath+0x39f/0x3d0
> [Tue Jun  4 09:16:44 2024] Code: 01 00 0f 85 11 ff ff ff b9 03 00 00 00 
> 48 c7 c2 e0 af 99 ad 4c 89 f6 48 c7 c7 e8 d7 95 ad c6 05 58 d0 d6 01 01 
> e8 81 92 b4 ff <0f> 0b e9 e8 fe ff ff 8b 06 41 89 01 42 8b 44 36 fc 43 
> 89 44 31 fc
> [Tue Jun  4 09:16:44 2024] RSP: 0018:ff765b4d40063bb8 EFLAGS: 00010282
> [Tue Jun  4 09:16:44 2024] RAX: 0000000000000000 RBX: ff4cd701434d88b8 
> RCX: 0000000000000027
> [Tue Jun  4 09:16:44 2024] RDX: ff4cd7103fd20bc8 RSI: 0000000000000001 
> RDI: ff4cd7103fd20bc0
> [Tue Jun  4 09:16:44 2024] RBP: ff765b4d40063c50 R08: 0000000000000000 
> R09: ff765b4d40063a70
> [Tue Jun  4 09:16:44 2024] R10: ff765b4d40063a68 R11: ffffffffae3d5728 
> R12: ff4cd70186f80000
> [Tue Jun  4 09:16:44 2024] R13: 0000000000000000 R14: 0000000000000004 
> R15: ff4cd701434d88b8
> [Tue Jun  4 09:16:44 2024] FS:  0000000000000000(0000) 
> GS:ff4cd7103fd00000(0000) knlGS:0000000000000000
> [Tue Jun  4 09:16:44 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 
> 0000000080050033
> [Tue Jun  4 09:16:44 2024] CR2: 00005606add87000 CR3: 0000000a9fa1a002 
> CR4: 0000000000771ef0
> [Tue Jun  4 09:16:44 2024] DR0: 0000000000000000 DR1: 0000000000000000 
> DR2: 0000000000000000
> [Tue Jun  4 09:16:44 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff0 
> DR7: 0000000000000400
> [Tue Jun  4 09:16:44 2024] PKRU: 55555554
> [Tue Jun  4 09:16:44 2024] Call Trace:
> [Tue Jun  4 09:16:44 2024]  <TASK>
> [Tue Jun  4 09:16:44 2024]  ? __warn+0x83/0x130
> [Tue Jun  4 09:16:44 2024]  ? 
> __bch2_accounting_mem_mod_slowpath+0x39f/0x3d0
> [Tue Jun  4 09:16:44 2024]  ? __report_bug+0xea/0x100
> [Tue Jun  4 09:16:44 2024]  ? report_bug+0x24/0x70
> [Tue Jun  4 09:16:44 2024]  ? handle_bug+0x3c/0x70
> [Tue Jun  4 09:16:44 2024]  ? exc_invalid_op+0x18/0x70
> [Tue Jun  4 09:16:44 2024]  ? asm_exc_invalid_op+0x1a/0x20
> [Tue Jun  4 09:16:44 2024]  ? 
> __bch2_accounting_mem_mod_slowpath+0x39f/0x3d0
> [Tue Jun  4 09:16:44 2024]  ? 
> __bch2_accounting_mem_mod_slowpath+0x39f/0x3d0
> [Tue Jun  4 09:16:44 2024]  ? _raw_spin_unlock_irq+0xe/0x30
> [Tue Jun  4 09:16:44 2024]  ? rcu_sync_enter+0x8c/0x100
> [Tue Jun  4 09:16:44 2024]  ? bch2_printbuf_exit+0x20/0x30
> [Tue Jun  4 09:16:44 2024]  bch2_accounting_mem_mod_slowpath+0x6b/0x100
> [Tue Jun  4 09:16:44 2024] 
> bch2_trans_commit_write_locked.constprop.0+0x3e0/0xb00
> [Tue Jun  4 09:16:44 2024]  do_bch2_trans_commit.isra.0+0xfa/0x550
> [Tue Jun  4 09:16:44 2024]  __bch2_trans_commit+0x380/0x880
> [Tue Jun  4 09:16:44 2024]  btree_update_nodes_written+0x525/0x850
> [Tue Jun  4 09:16:44 2024]  ? btree_update_nodes_written+0x116/0x850
> [Tue Jun  4 09:16:44 2024]  btree_interior_update_work+0x55/0x60
> [Tue Jun  4 09:16:44 2024]  process_one_work+0x184/0x3b0
> [Tue Jun  4 09:16:44 2024]  worker_thread+0x2f9/0x380
> [Tue Jun  4 09:16:44 2024]  ? __pfx_worker_thread+0x10/0x10
> [Tue Jun  4 09:16:44 2024]  kthread+0xd0/0x100
> [Tue Jun  4 09:16:44 2024]  ? __pfx_kthread+0x10/0x10
> [Tue Jun  4 09:16:44 2024]  ret_from_fork+0x31/0x50
> [Tue Jun  4 09:16:44 2024]  ? __pfx_kthread+0x10/0x10
> [Tue Jun  4 09:16:44 2024]  ret_from_fork_asm+0x1a/0x30
> [Tue Jun  4 09:16:44 2024]  </TASK>
> [Tue Jun  4 09:16:44 2024] ---[ end trace 0000000000000000 ]---
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): initializing freespace
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): done initializing freespace
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): reading snapshots table
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): reading snapshots done
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): done starting filesystem
> 
> 
> 
> It can be reproduced by:
> 
> reboot
> bcachefs format $BCACHEFS_DEV
> mount -t bcachefs $BCACHEFS_DEV /mnt/bcachefs
> 
> 
> Thanks,
> Hongbo
