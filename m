Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905E8C125
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 May 2024 12:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716121604; cv=none; b=ZCsUJI8cf6OEX7CS6RVruJxozsO4l7j9PXMkVVFUIYUg0ikz35M0mQh9kAjAW7DHs+YNXH7Pf4i18Q9buF+UCkwC4P12VlewJOEUi8xMKF1esx+dYrlVqNvMGrpHl60Al09rkx84QOIRHWSjppv3L9mQTVsWcZQchFiizYAcMZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716121604; c=relaxed/simple;
	bh=cGdBtV/F2D27aeaQYcpi0FcbJcjDkkvaWkndSOhklIM=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=insFi+5bcFNKl237cxcTC3iE06YTlG2kyDBKcLbxxwHZfvLMCdgFFc0fh2HmFbC+3mbGFGsO9AmP7J3mAndLr2J7Q2ky098mwXyWzBKUd7ET66ItEeByDWvxPb4lCmJ/K/bt1LE+BBy1zlg751bK3MkOjh0a3l1XxORQ/KqKUdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=F6Z3M/Cs; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="F6Z3M/Cs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1716121594; x=1716380794;
	bh=cGdBtV/F2D27aeaQYcpi0FcbJcjDkkvaWkndSOhklIM=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=F6Z3M/CsBhrL0+OK18R//jj6D+uHetSmQv+DT8MFV9ckB/Y6sqYnCXHy8pX0AYNH3
	 3EYZqHWSKRFzWstaCunijujkkDYLjNDCN967Ydk1l8am0F5VWqyXIWlT0dxlqaJiVI
	 HNUQGbW9n/ej+iqyBfvnFqeeRUXrvYd9wJ8i2QdyXaXCv59LosMhgd8NDqAUtnQTmg
	 dsgbR/YbUJeMnDE1hwnlaezInZFldLmQZx4nCC02KcAfyAzKv1RAeETZ09OYxS92sc
	 55vS2eTA/JnhSBFvoca7KSa9NVwEEAYvZjx+Pu2yqao3++2ijzosW395gJTx3IPGiH
	 TPwlxPCO2Uz0w==
Date: Sun, 19 May 2024 12:26:31 +0000
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
From: RlndVt <RlndVt@protonmail.com>
Subject: [bcachefs] Stack-trace at fs/bcachefs/btree_iter.c:2825 bch2_trans_srcu_unlock+0x116/0x120
Message-ID: <gUWINkhdQo_PMB51THavPfA3ro8y3Xpj62Xpm2bBreMiP9U7R44oxZVKj1h4MGfdGatzKw_J6AMA7tnd5f6I5hp4cXbIFCypdlZtK8Xb_gA=@protonmail.com>
Feedback-ID: 63185315:user:proton
X-Pm-Message-ID: 702824540ed504732ff865562c95f117090cd714
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Kent,

My system is reporting the following stack-trace. I am not noticing anythin=
g odd. I believe it happened at unmount; however the following mount report=
s a clean unmount. fsck doesn't report any problem.

Let me know if I can provide more info.

Regards,
Roland

May 19 10:34:38 cleop.domain.name kernel: ------------[ cut here ]---------=
---May 19 10:34:38 cleop.domain.name kernel: btree trans held srcu lock (de=
laying memory reclaim) for 25 seconds
May 19 10:34:38 cleop.domain.name kernel: WARNING: CPU: 5 PID: 7396 at fs/b=
cachefs/btree_iter.c:2825 bch2_trans_srcu_unlock+0x116/0x120 [bcachefs]
May 19 10:34:38 cleop.domain.name kernel: Modules linked in: bcachefs lz4hc=
_compress lz4_compress rpcrdma rdma_cm iw_cm ib_cm ib_core nf_conntrack_net=
bios_ns nf_conntrack_broadcast nft_fib>
May 19 10:34:38 cleop.domain.name kernel: =C2=A0kvm_intel snd_hwdep iTCO_wd=
t intel_pmc_bxt iTCO_vendor_support snd_pcm mei_hdcp ee1004 mei_pxp snd_tim=
er kvm eeepc_wmi asus_wmi irqbypass rapl le>
May 19 10:34:38 cleop.domain.name kernel: CPU: 5 PID: 7396 Comm: bch-rebala=
nce/b Not tainted 6.8.9-300.fc40.x86_64 #1
May 19 10:34:38 cleop.domain.name kernel: Hardware name: ASUS System Produc=
t Name/PRIME B460I-PLUS, BIOS 1301 07/13/2021
May 19 10:34:38 cleop.domain.name kernel: RIP: 0010:bch2_trans_srcu_unlock+=
0x116/0x120 [bcachefs]
May 19 10:34:38 cleop.domain.name kernel: Code: dc 86 d5 48 c7 c7 f8 a0 d0 =
c1 48 b9 cf f7 53 e3 a5 9b c4 20 48 29 d0 48 c1 e8 03 48 f7 e1 48 89 d6 48 =
c1 ee 04 e8 9a e9 58 d3 <0f> 0b eb 8b >
May 19 10:34:38 cleop.domain.name kernel: RSP: 0018:ffffad5c40947d70 EFLAGS=
: 00010282
May 19 10:34:38 cleop.domain.name kernel: RAX: 0000000000000000 RBX: ffff98=
53e5694000 RCX: 0000000000000027
May 19 10:34:38 cleop.domain.name kernel: RDX: ffff9862aeca18c8 RSI: 000000=
0000000001 RDI: ffff9862aeca18c0
May 19 10:34:38 cleop.domain.name kernel: RBP: ffff9853d2d00000 R08: 000000=
0000000000 R09: 73646e6f63657320
May 19 10:34:38 cleop.domain.name kernel: R10: ffffffffc1d0a13c R11: 000000=
0000000000 R12: ffff9853d2d00000
May 19 10:34:38 cleop.domain.name kernel: R13: ffffad5c40947e98 R14: ffff98=
53d2d00000 R15: ffffffffc1c37950
May 19 10:34:38 cleop.domain.name kernel: FS: =C2=A00000000000000000(0000) =
GS:ffff9862aec80000(0000) knlGS:0000000000000000
May 19 10:34:38 cleop.domain.name kernel: CS: =C2=A00010 DS: 0000 ES: 0000 =
CR0: 0000000080050033
May 19 10:34:38 cleop.domain.name kernel: CR2: 000055f5330599e0 CR3: 000000=
0d12428002 CR4: 00000000003706f0
May 19 10:34:38 cleop.domain.name kernel: Call Trace:
May 19 10:34:38 cleop.domain.name kernel: =C2=A0<TASK>
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? bch2_trans_srcu_unlock+0x=
116/0x120 [bcachefs]
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? __warn+0x81/0x130
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? bch2_trans_srcu_unlock+0x=
116/0x120 [bcachefs]
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? report_bug+0x16f/0x1a0
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? handle_bug+0x3c/0x80
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? exc_invalid_op+0x17/0x70
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? asm_exc_invalid_op+0x1a/0=
x20
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? __pfx_bch2_rebalance_thre=
ad+0x10/0x10 [bcachefs]
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? bch2_trans_srcu_unlock+0x=
116/0x120 [bcachefs]
May 19 10:34:38 cleop.domain.name kernel: =C2=A0bch2_moving_ctxt_flush_all+=
0x5c/0x140 [bcachefs]
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? mutex_lock+0x12/0x30
May 19 10:34:38 cleop.domain.name kernel: =C2=A0bch2_moving_ctxt_exit+0x1f/=
0xb0 [bcachefs]
May 19 10:34:38 cleop.domain.name kernel: =C2=A0bch2_rebalance_thread+0x7b/=
0xb0 [bcachefs]
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? bch2_rebalance_thread+0x5=
c/0xb0 [bcachefs]
May 19 10:34:38 cleop.domain.name kernel: =C2=A0kthread+0xe5/0x120
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? __pfx_kthread+0x10/0x10
May 19 10:34:38 cleop.domain.name kernel: =C2=A0ret_from_fork+0x31/0x50
May 19 10:34:38 cleop.domain.name kernel: =C2=A0? __pfx_kthread+0x10/0x10
May 19 10:34:38 cleop.domain.name kernel: =C2=A0ret_from_fork_asm+0x1b/0x30
May 19 10:34:38 cleop.domain.name kernel: =C2=A0</TASK>
May 19 10:34:38 cleop.domain.name kernel: ---[ end trace 0000000000000000 ]=
---
