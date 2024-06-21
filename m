Received: from smtp.roethke.info (smtp.roethke.info [46.232.251.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347B515573E
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jun 2024 15:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.232.251.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718984667; cv=none; b=sSAVU2CGPrcuuMtbEI60nbedN3KS0XEdc9108UFUlyxHHUtnsaQgQO3AOkbyG6gkFlxRrTFzPBsz2Msoj5Mcn60OoIZyRlwjluaVDxXc2TbfB5FneqQGKrOWAGtz1ZF4DF+E5xtB0p3TI28oC2wksqSKfml/weMM7EJAT8AmYN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718984667; c=relaxed/simple;
	bh=POjxz8IYxCfxfxhqjB0K/IscQei7fr8rj5FU57KOX8c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WOBF9QK8sUQfRDDid3ph6+zHnk2AIbJP5q808y0DQSbL4MvjOYbf7BXcHTNeonoqZYT15BRvFSre0X2kdLdeWuJ+I5Q7ep+Kexo8ibjQVGQHw0M2n+QWhnJoS0FswW1mvJiAPGZwSGveQ2MKMIZDvl9iDN90dqPQeG7v6YPgupc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=roethke.info; spf=pass smtp.mailfrom=roethke.info; dkim=pass (4096-bit key) header.d=roethke.info header.i=@roethke.info header.b=FWxl3yTv; arc=none smtp.client-ip=46.232.251.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=roethke.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=roethke.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=roethke.info header.i=@roethke.info header.b="FWxl3yTv"
Received: from localhost (unknown [IPv6:2a01:41e1:1608:c00:5f2:f4d1:f5dc:243c])
	by smtp.roethke.info (Postfix) with ESMTPA id A14BC1E00045
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jun 2024 15:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=roethke.info;
	s=20200807; t=1718984325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=/WjRW52y/gaZniFQ/z07ZL1WcyQT7iaPE9mtHbmJ2+U=;
	b=FWxl3yTvtO6NGaFbwgb7zHSvJskty1NcfYCX3Yh/f4SbhWHD8qnFcdqcpdf5CUwc3Hzgat
	qdnEQtdEe7+8Ww52HUSCZM0prdmMXebWSwcpImwAmrgoT+oYI/n9t6/O+0oqoS1pa76+cX
	HYEStT4QNRVuqcZAKtggLDyJ60Tr2MfTE8hLe5QAejbxJQ2N/S6J/x5yxyZRJv2Nb66Fdv
	cnI0E7YjX2ebuTCt5T3JCB9571FXlYQ9bKhUYWZbkfr0DGSh1fTM5AUREiywYN7K8+2txE
	TYaGrHPqrKWv7nHw/wYNKmbPMGX1FT4kPGbtNdHZZXf6h17qlv+e53d6oO7FoB4i9xix/5
	9JVsqw8ETEcIl12vzXCV1ivPUPiqriD5wwnL+DbZCmowKiCJWGDg/cSmqzQ1pYvKHJEIux
	AeEe8bSlmIq2uJcvWgJ5y56FCVxPApjQfm0aveukjMR5DT36qMxoHQM0ZYcJEkBw0i8/s3
	3Zt0H89++IGygIFQTQAr7s6LcByFqEss8Dczk7wPIXdzwbnBCauLzTPmCC/YHG/UZcUH0Q
	hw7gSddDscbut2fu2KtnvQdvjP/m2/ugwOUC9poL6pK9k6aNtTZRGrVlQnuUL02QPLyB/u
	kV4WNlM+aqCfILRXjKKiJjzZCeaAjGoLTxbUgYWJO2SozBoS++34g=
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=marcel@roethke.info smtp.mailfrom=marcel@roethke.info
Date: Fri, 21 Jun 2024 17:38:42 +0200
From: Marcel =?utf-8?Q?R=C3=B6thke?= <marcel@roethke.info>
To: linux-bcachefs@vger.kernel.org
Subject: [tools] LTO breaks tools
Message-ID: <ZnWeguEIABfeP2xV@roethke.info>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

I noticed that at least the format subcommand of the bcachefs tools
breaks when compiling with LTO. By breaking I mean that it segfaults. I
think the cause is commit fc06a0ea5e552663e9e47de941fbc7e621d4ca46
between versions 1.7.0 and 1.9.0.

I noticed this first with the official archlinux package, but can
reproduce it by compiling from source with `CFLAGS=-flto=auto make`

And here is the stacktrace for completeness.
Thread 17 "btree_update" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff78d2680 (LWP 212449)]
bch2_trans_start_alloc_update (trans=0x7fffe4001000, pos=...) at libbcachefs/alloc_background.c:480
480	{
(gdb) bt
#0  bch2_trans_start_alloc_update (trans=0x7fffe4001000, pos=...) at libbcachefs/alloc_background.c:480
#1  0x000055555580249e in bch2_trigger_pointer (trans=<optimized out>, btree_id=<optimized out>, level=<optimized out>, k=..., p=..., entry=<optimized out>,
    sectors=<synthetic pointer>, flags=<optimized out>) at libbcachefs/buckets.c:572
#2  __trigger_extent (trans=<optimized out>, btree_id=<optimized out>, level=<optimized out>, k=..., flags=<optimized out>) at libbcachefs/buckets.c:724
#3  0x00005555557f6e5d in bch2_key_trigger (trans=0x7fffe4001000, btree=<optimized out>, level=<optimized out>, old=..., new=...,
    flags=(BTREE_TRIGGER_transactional | BTREE_TRIGGER_insert)) at libbcachefs/bkey_methods.h:88
#4  bch2_key_trigger_new (trans=0x7fffe4001000, btree_id=<optimized out>, level=<optimized out>, new=..., flags=BTREE_TRIGGER_transactional) at libbcachefs/bkey_methods.h:116
#5  btree_update_nodes_written_trans (trans=0x7fffe4001000, as=<optimized out>) at libbcachefs/btree_update_interior.c:658
#6  btree_update_nodes_written (as=0x555555e0a800) at libbcachefs/btree_update_interior.c:721
#7  btree_interior_update_work (work=0x7ffff7ace5d0) at libbcachefs/btree_update_interior.c:859
#8  0x00005555558957a0 in worker_thread (arg=0x555555cc0040) at linux/workqueue.c:262
#9  0x000055555588968a in kthread_start_fn (data=<optimized out>) at linux/kthread.c:25
#10 0x00007ffff7be4ded in start_thread (arg=<optimized out>) at pthread_create.c:447
#11 0x00007ffff7c680dc in clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:78
