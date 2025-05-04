Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5903913AA53
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 May 2025 08:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746346879; cv=none; b=WSlwGW02fGaX9IJYPHxDq3Kwz4SRQCtEbRIhSFZRWqVunN/WO1W3RpU5YUjVIq254CdN8KTfGY//56U1mJUaIkTpaNl9bEhiInWoGeVOL6jEV+0REkZl376eZwL5vj3Ei3P+txHSiokpYlpQNGUtvh1GCWdAos1ca7yzikCvo+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746346879; c=relaxed/simple;
	bh=UBqmqxQDFQVAhq1THIbzxRMxBE2RWxahNMN7UF1kB+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AOep+TzOAXQuTJKtWNx3D6L7q+DINF+vbATSuW7NsxFTtNArF/VQkzwuTIieu1R+5M5LM7PpMvynEFZ5q3NEM3h+EEq1Pt1L6FqaJADJm1pjWChmapnTkr7CpFRR9FjUBueu4tmmRWt5gF2FceaXctokOt0NbocduErY1fq31S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wrqnmQk7; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wrqnmQk7"
Date: Sun, 4 May 2025 04:21:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746346872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p8vZUcGYBSHunxd2ayPnmRz/JOdyMUpRArYpyHpJ8fA=;
	b=wrqnmQk7Xczcc2eUR8eHrB1/BS9w9+giklnrGN0JaCho6WVNMuXh7xLB0G6+2loC3qvDaU
	abbpatK5sXXTSyOUHYKmYyMw3STqoKPVwXpI3CkEQnh4Mg/ocFKFNsiM3jgRloSO9yEx+l
	kY47dJ/366IY4NXYRTKbMtYvY2J2CW4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kim Reivanen <reivanen@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs bug while doing on disk format upgrade
Message-ID: <uwthlt5fm7pvnj7ujqwbgytacut4awnvnxz46vweufg64lgq26@2jzyvgbmvttr>
References: <CANjCnDWdn=k3b8JU3FX7YGDBkscA2tSW_GWdrbqeVvdVB6vMvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANjCnDWdn=k3b8JU3FX7YGDBkscA2tSW_GWdrbqeVvdVB6vMvg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

Please send these to the list, and not my personal mailbox, so that
other people can see them.

These write buffer flush SRCU warnings just started popping up, and we
don't yet have the full story on what's going on.

I have full systemwide latency tracing tracing that would be perfect for
debugging this - if you're able to reproduce these warnings, I'll stick
it in a branch for you.

Unfortunately the code isn't upstreamable yet, and that's going to take
a fair amount of work, so if we want to debug this in the meantime it'll
take people building custom kernels.

On Sun, May 04, 2025 at 11:16:32AM +0300, Kim Reivanen wrote:
> Hello, the upgrade stopped for a long time and then printed this in dmesg:
> 
> [1142639.686858] bcachefs (8a494f34-c298-475b-bc59-fe1bc2b595bf):
> extents_to_backpointers:
> 46%, done 9215/19934 nodes, at extents:738219082:888:U32_MAX
> [1142640.275749] ------------[ cut here ]------------
> [1142640.275753] btree trans held srcu lock (delaying memory reclaim) for
> 10 seconds
> [1142640.275765] WARNING: CPU: 2 PID: 1754855 at
> fs/bcachefs/btree_iter.c:3200 bch2_trans_srcu_unlock+0x124/0x130 [bcachefs]
> [1142640.275814] Modules linked in: bcachefs lz4hc_compress lz4_compress
> cdc_acm tls nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject
> act_csum cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 nf_tables bridge stp llc qrtr rfkill nct6775 nct6775
> _core hwmon_vid vfat squashfs fat amd_atl intel_rapl_msr intel_rapl_common
> snd_usb_audio snd_usbmidi_lib snd_ump kvm_amd snd_hda_codec_realtek
> snd_rawmidi ccp snd_hda_codec_generic snd_seq_device joydev mousedev mc
> snd_hda_scodec_component snd_hda_codec_hdmi kvm snd_hda_intel snd_int
> el_dspcfg snd_intel_sdw_acpi ee1004 polyval_clmulni snd_hda_codec
> polyval_generic ghash_clmulni_intel sha512_ssse3 sha256_ssse3 sha1_ssse3
> snd_hda_core raid1 aesni_intel snd_hwdep sp5100_tco r8169 crypto_simd
> snd_pcm cryptd realtek wmi_bmof rapl k10temp mdio_devres i2c_piix4 snd_time
> r pcspkr snd i2c_smbus soundcore libphy md_mod mac_hid uinput i2c_dev
> crypto_user loop dm_mod nfnetlink ip_tables x_tables amdgpu amdxcp
> i2c_algo_bit drm_ttm_helper ttm drm_exec
> [1142640.275934]  gpu_sched drm_suballoc_helper video hid_generic
> drm_panel_backlight_quirks drm_buddy nvme drm_display_helper cec nvme_core
> usbhid nvme_auth wmi
> [1142640.275952] CPU: 2 UID: 0 PID: 1754855 Comm: bch-reclaim/8a4 Tainted:
> G S      W          6.14.0-1-MANJARO #1
> e818560d30570314bac00668f2c5615e29b49856
> [1142640.275957] Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
> [1142640.275959] Hardware name: Micro-Star International Co., Ltd.
> MS-7C37/X570-A PRO (MS-7C37), BIOS H.G0 03/16/2022
> [1142640.275961] RIP: 0010:bch2_trans_srcu_unlock+0x124/0x130 [bcachefs]
> [1142640.276000] Code: 8c f0 d2 48 c7 c7 70 3a 08 c2 48 b9 cf f7 53 e3 a5
> 9b c4 20 48 29 d0 48 c1 e8 03 48 f7 e1 48 89 d6 48 c1 ee 04 e8 3c a6 e4 d0
> <0f> 0b eb a3 0f 0b eb b1 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90
> [1142640.276002] RSP: 0018:ffffb344c1823b80 EFLAGS: 00010286
> [1142640.276006] RAX: 0000000000000000 RBX: ffff9c7d1fb60000 RCX:
> 0000000000000027
> [1142640.276008] RDX: ffff9c7f5ed218c8 RSI: 0000000000000001 RDI:
> ffff9c7f5ed218c0
> [1142640.276010] RBP: ffff9c7b8fec0000 R08: 0000000000000000 R09:
> ffffb344c1823a00
> [1142640.276011] R10: ffffffff94eb44a8 R11: 0000000000000003 R12:
> ffff9c7b8fee7000
> [1142640.276013] R13: ffff9c7d1fb60000 R14: ffff9c7b8fec0000 R15:
> ffff9c7b8fec39a8
> [1142640.276015] FS:  0000000000000000(0000) GS:ffff9c7f5ed00000(0000)
> knlGS:0000000000000000
> [1142640.276018] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1142640.276020] CR2: 00007d1d1fee6000 CR3: 000000011f8ae000 CR4:
> 0000000000350ef0
> [1142640.276022] Call Trace:
> [1142640.276025]  <TASK>
> [1142640.276027]  ? bch2_trans_srcu_unlock+0x124/0x130 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276065]  ? __warn.cold+0x93/0xf6
> [1142640.276069]  ? bch2_trans_srcu_unlock+0x124/0x130 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276108]  ? report_bug+0xff/0x140
> [1142640.276113]  ? handle_bug+0x58/0x90
> [1142640.276117]  ? exc_invalid_op+0x17/0x70
> [1142640.276120]  ? asm_exc_invalid_op+0x1a/0x20
> [1142640.276127]  ? bch2_trans_srcu_unlock+0x124/0x130 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276165]  bch2_trans_begin+0x535/0x780 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276202]  ? bch2_trans_begin+0x81/0x780 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276238]  ? srso_return_thunk+0x5/0x5f
> [1142640.276242]  ? finish_task_switch.isra.0+0x99/0x2e0
> [1142640.276248]  bch2_btree_write_buffer_flush_locked+0x93/0xec0 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276297]  btree_write_buffer_flush_seq+0xef/0x1b0 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276337]  ? __pfx_bch2_btree_write_buffer_journal_flush+0x10/0x10
> [bcachefs b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276373]  bch2_btree_write_buffer_journal_flush+0x51/0xa0 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276410]  journal_flush_pins.constprop.0+0x180/0x330 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276465]  __bch2_journal_reclaim+0x1e4/0x380 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276512]  bch2_journal_reclaim_thread+0x6e/0x150 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276554]  ? __pfx_bch2_journal_reclaim_thread+0x10/0x10 [bcachefs
> b43ca9103c4d656d163209b11c8a332d2e5ec467]
> [1142640.276593]  kthread+0xef/0x230
> [1142640.276597]  ? __pfx_kthread+0x10/0x10
> [1142640.276601]  ret_from_fork+0x34/0x50
> [1142640.276604]  ? __pfx_kthread+0x10/0x10
> [1142640.276608]  ret_from_fork_asm+0x1a/0x30
> [1142640.276615]  </TASK>
> [1142640.276617] ---[ end trace 0000000000000000 ]---
