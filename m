Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF8A25B0AB
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Aug 2026 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322859; cv=none; b=KaZtFJsnAkeJ8IJFpiJnkPrsv4wwDLSSJ7FwKyyX8MTdGFiu/rz54yAA+IDisi5PmQCyMNOrrn+aEeF+JpdkQK3dYUQOSGc7ugETkNiFclUcuXMu9VnGBCVrE4y5UW7uZ/qb7S3AShu68+EiuT/A1710wgdrNy2RVXPAgADnidc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322859; c=relaxed/simple;
	bh=4bilg/d5aoLFVLAA2AwVISL7ybb9aIJnEyl4Cm+Kcm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/w/P/88SEHJpZTeij+tZk+N4ubxOhO0XqIBpcShWXhB/f46vUATImXVN6hKl9U/2/TKXd61fyKGj+djuAdqFtExBJAa9bGdg2H/m4hB4Ic5Bmk/wJFrRnv09TumPnXpA83DPSvtNHmT3RfbNdfCucc5RV2zBNuWYsbIjWd0xRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=Qd/4V++v; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="Qd/4V++v"
Received: from localhost (unknown [138.124.86.62])
	by mail.ispras.ru (Postfix) with ESMTPSA id 27C544077932;
	Fri, 21 Aug 2026 14:27:14 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 27C544077932
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1787322434;
	bh=Rek2LEnFB8OrSp/gDDS6w0fhWHw+CvzIZmv+p4doWig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qd/4V++vZieZh7ppoBobtX0w7Gs/LOUfmKH0qtNL2WZ7bEidFNePIPki2xPm6kbt+
	 SKiIdZcrKxOiDNH2Z5v34wQEBC58jqgUHemnXcL8C98YVeS0RTarj0BjJJpbZtmCgV
	 6zU0iM7WzGNKPm8GqRiMo7Mv46wbrL0LnvFVdgSk=
Date: Fri, 21 Aug 2026 17:27:13 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcachefs@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [lvc-project] [PATCH] bcachefs: fix memory leak in
 bch2_setattr_nonsize_trans()
Message-ID: <20260821171723-5951ecd4452cd3a8a43e56ef-pchelkin@ispras>
References: <20260820160818.444997-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260820160818.444997-1-dmantipov@yandex.ru>

On Thu, 20. Aug 19:08, Dmitry Antipov wrote:
> Local fuzzing of 6.12.103 has found the following memory leak:
> 
> unreferenced object 0xffff888105f40700 (size 64):
>   comm "syz.0.17", pid 10384, jiffies 4294952060
>   hex dump (first 32 bytes):
>     01 00 00 00 80 88 ff ff 0c 00 00 00 ad 04 74 01  ..............t.
>     00 00 b0 7f 10 f7 00 00 04 00 00 00 01 00 07 00  ................
>   backtrace (crc 8943d909):
>     kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
>     slab_post_alloc_hook mm/slub.c:4166 [inline]
>     slab_alloc_node mm/slub.c:4211 [inline]
>     __do_kmalloc_node mm/slub.c:4345 [inline]
>     __kmalloc_node_track_caller_noprof+0x1ee/0x3d0 mm/slub.c:4365
>     kmemdup_noprof+0x2b/0x70 mm/util.c:133
>     kmemdup_noprof include/linux/fortify-string.h:753 [inline]
>     posix_acl_clone fs/posix_acl.c:232 [inline]
>     __posix_acl_chmod+0x78/0x500 fs/posix_acl.c:583
>     bch2_acl_chmod+0x523/0x800 fs/bcachefs/acl.c:430
>     bch2_setattr_nonsize+0xbb8/0xfc0 fs/bcachefs/fs.c:1063
>     notify_change+0xb2b/0xe30 fs/attr.c:503
>     chmod_common+0x1a7/0x2f0 fs/open.c:651
>     do_fchmodat+0x91/0x130 fs/open.c:697
>     __do_sys_fchmodat fs/open.c:716 [inline]
>     __se_sys_fchmodat fs/open.c:713 [inline]
>     __x64_sys_fchmodat+0x7d/0x90 fs/open.c:713
>     do_syscall_x64 arch/x86/entry/common.c:47 [inline]
>     do_syscall_64+0xbe/0x1a0 arch/x86/entry/common.c:78
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Fix this by using 'posix_acl_release()' to balance refcounting
> of the corresponding 'struct posix_acl' object.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Please clarify why there is a refcounting problem.  What is the root
cause?
