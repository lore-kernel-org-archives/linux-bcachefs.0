Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE11153BC3
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 06:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717743058; cv=none; b=sQlE76p1hNEkx7Dg1QQIFHFaODoKq+3eqlC2HyPPjLuhuXy9CrZxLS5P9UIX/cUDeLe70M4hvqovpAck6gmVFHHlE9bgsR4YLOecFl50O19vpilmlvuvPH7Yd8x0YN3fkXFxhSWzVnrmwLapAi9JHID4Tl176mvISdsYxyQeu+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717743058; c=relaxed/simple;
	bh=yrXMskjIxGrSj7/9fGyh8VSJ+Fk6ZLl29H0SeGbbEN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SwqjJLJaXwm9xCaDQx/2//eImrWDtgZCI85KS9809rM7E8WqmJzNbnW7mGAV3dLQfu2SjLJ00bgawOH/YV+4FDZ5Gie+hAOcKTX4QG+8MG3r1zD3M4gk23UJcaC7YSTeWR6fq3nt/uhkjvPcuvpA9Jp4iYbu75CXU2EM75jex3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W21Yvcyr; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W21Yvcyr"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-57a5bcfb2d3so1025967a12.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Jun 2024 23:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717743054; x=1718347854; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tkhVz6lv6JM5BEIdXQcbikYH5nlKEcPnyRteWtRQR4A=;
        b=W21Yvcyrvj96d6Vg4aCO5twcwrRU/sEVvdhhvMeGpH8HWNUZepXGsxGgzZpgDM3vpA
         nemhymq9o7sDObFkjp+UQVTj0Lzzmj1LEjfvSqrW1l3qz4xFE6G9lstCeTLgmzm85blE
         +wZeIu0cg6vBPYbiBOp/9W+kXtluV6YAWgE6l/gzRQSB1m68+qbvEpebbVZ+GdM6BQgo
         CW5axr44rXfEJuQ0w4kOFakLBWj2DwGmo6VtZsqIzNwsGhBBpNqXYdY+ICzQ4AGNbPzm
         SckOpFiF9SURyRmMn3ug+6nkrXhzmuQ5iW/a/EZ7JTU1y7SA462btjWg7GNovSwfuAoA
         Iwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717743054; x=1718347854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tkhVz6lv6JM5BEIdXQcbikYH5nlKEcPnyRteWtRQR4A=;
        b=pdzbxu3NtlA/tvCona3rYUvfeucKqBbmg0I1zlXQX5aM/bAhA+k1oAFY+RPqsBeubD
         ywqkIM7lyws9VPnN+VYa7RFo1Pf1Q+H4Lj1Cp80HUV6J0urbGyDEhx9u/Lsj927HH0l1
         XZyHERUTzVX3CKgDBMyE+VSUoTz1Rxm8b0QH62Ko0aIPqKOUSSoGPuiAVy6boH3fKw+g
         drJr5P15vVqqpCOE5vrTW1chAcmBfifNK8T6t7O5vM3B6sbcVa7UWfIG9Lhu0uorPBs0
         Rg75Qrht2gH/KnJPuFruzoAfqCqsU05wlqvVMX09btzjUCXA5DlDeqKnSpakKk+XizfG
         Bfhg==
X-Gm-Message-State: AOJu0YyvzMU+Y+sbGl51kDpzwV+P/khry7uHPEBcJvUyCMU/zxLqQn9c
	+eaLHkdXDs7O13//4lbBT5rqg/vJqvJ26s53uTOvgKf/hwm6A+sLGsBZehCpLCC8aOMnsoOb8io
	CYF5Bd2jTeH1nM/NCCieQcrSY4OlxGHT4
X-Google-Smtp-Source: AGHT+IGRRN7Pl49EmO8mEfX0ck4uSw+fDUzE97lgaz/rtnYfTewnwojx/4dXWZFiWw/UTS7ebp63ZXVewpLeMdDU1p4=
X-Received: by 2002:a50:9f07:0:b0:57c:5f88:7c69 with SMTP id
 4fb4d7f45d1cf-57c5f887ca8mr205407a12.38.1717743053426; Thu, 06 Jun 2024
 23:50:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <CAGudoHE1WhSSrqKbtCVhdxbPnmjGeb45mUw+gQ_ZEgMsfADu+g@mail.gmail.com> <nyu645ylcfo4go5bb7jyam7jvcohtjol2qz6n4kpcfdsaom4y6@yawhqfyzyudk>
In-Reply-To: <nyu645ylcfo4go5bb7jyam7jvcohtjol2qz6n4kpcfdsaom4y6@yawhqfyzyudk>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Jun 2024 08:50:40 +0200
Message-ID: <CAGudoHFM1c2QMtbJMFCRw1YUk4p-_0GQBn9MfyFfNdxJbZqQeg@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 2:31=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Thu, Jun 06, 2024 at 08:40:50PM +0200, Mateusz Guzik wrote:
> > So I tried out bcachefs again and it once more fails to complete
> > parallel creation of 20 mln files -- processes doing the work use cpu
> > time in the kernel indefinitely.
>
> Hey thanks for the report - can you try my branch? It's behaving
> reasonable well in my testing now
>
> https://evilpiepirate.org/git/bcachefs.git bcachefs-for-upstream

No dice, booted up top of your tree: 6.10.0-rc2-00013-gb7d8959f5ce9

Got a similar trace as before:
createtree  1174 [029]   242.750593:      39291   cycles:
        ffffffffb20d8640 debug_lockdep_rcu_enabled+0x0 ([kernel.kallsyms])
        ffffffffb1083b6a rcu_read_lock_held+0xa ([kernel.kallsyms])
        ffffffffb1723d4f bch2_btree_key_cache_scan+0x5df ([kernel.kallsyms]=
)
        ffffffffb126dc06 do_shrink_slab+0x176 ([kernel.kallsyms])
        ffffffffb126e5f1 shrink_slab+0xd1 ([kernel.kallsyms])
        ffffffffb1269cdd shrink_node+0x32d ([kernel.kallsyms])
        ffffffffb126bde1 do_try_to_free_pages+0xc1 ([kernel.kallsyms])
        ffffffffb126c6e4 try_to_free_pages+0xf4 ([kernel.kallsyms])
        ffffffffb12d5a69 __alloc_pages_slowpath.constprop.0+0x309
([kernel.kallsyms])
        ffffffffb12d698f __alloc_pages_noprof+0x37f ([kernel.kallsyms])
        ffffffffb12deec4 allocate_slab+0x3e4 ([kernel.kallsyms])
        ffffffffb12dfaf3 ___slab_alloc.isra.0+0xb83 ([kernel.kallsyms])
        ffffffffb12e007a __slab_alloc.isra.0+0x4a ([kernel.kallsyms])
        ffffffffb12e1203 kmem_cache_alloc_noprof+0x293 ([kernel.kallsyms])
        ffffffffb1770cdd __bch2_new_inode+0x1d ([kernel.kallsyms])
        ffffffffb17756fa __bch2_create+0x8a ([kernel.kallsyms])
        ffffffffb1775cf6 bch2_create+0x26 ([kernel.kallsyms])
        ffffffffb136ab30 lookup_open.isra.0+0x5a0 ([kernel.kallsyms])
        ffffffffb13710e4 path_openat+0x304 ([kernel.kallsyms])
        ffffffffb1371aec do_filp_open+0xac ([kernel.kallsyms])
        ffffffffb1354301 do_sys_openat2+0x91 ([kernel.kallsyms])
        ffffffffb1354773 __x64_sys_openat+0x53 ([kernel.kallsyms])
        ffffffffb20d09b9 do_syscall_64+0x69 ([kernel.kallsyms])
        ffffffffb2200117 entry_SYSCALL_64_after_hwframe+0x76 ([kernel.kalls=
yms])
                   f7f01 __GI___libc_open+0x51
(/usr/lib/x86_64-linux-gnu/libc.so.6)
        322f3538332f3931 [unknown] ([unknown])


Additionally some other instances of the my proc are waiting in
bch2_btree_key_cache_scan to acquire bc->lock.

createtree  1130 [002]   242.748384:      67210   cycles:
        ffffffffb104b52b mutex_spin_on_owner+0x7b ([kernel.kallsyms])
        ffffffffb20eacd1 __mutex_lock+0x751 ([kernel.kallsyms])
        ffffffffb17237a9 bch2_btree_key_cache_scan+0x39 ([kernel.kallsyms])
        ffffffffb126dc06 do_shrink_slab+0x176 ([kernel.kallsyms])
        ffffffffb126e5f1 shrink_slab+0xd1 ([kernel.kallsyms])
        ffffffffb1269cdd shrink_node+0x32d ([kernel.kallsyms])
        ffffffffb126bde1 do_try_to_free_pages+0xc1 ([kernel.kallsyms])
        ffffffffb126c6e4 try_to_free_pages+0xf4 ([kernel.kallsyms])
        ffffffffb12d5a69 __alloc_pages_slowpath.constprop.0+0x309
([kernel.kallsyms])
        ffffffffb12d698f __alloc_pages_noprof+0x37f ([kernel.kallsyms])
        ffffffffb12deec4 allocate_slab+0x3e4 ([kernel.kallsyms])
        ffffffffb12dfaf3 ___slab_alloc.isra.0+0xb83 ([kernel.kallsyms])
        ffffffffb12e007a __slab_alloc.isra.0+0x4a ([kernel.kallsyms])
        ffffffffb12e1203 kmem_cache_alloc_noprof+0x293 ([kernel.kallsyms])
        ffffffffb182d0e9 security_inode_alloc+0x29 ([kernel.kallsyms])
        ffffffffb1382e40 inode_init_always+0x2b0 ([kernel.kallsyms])
        ffffffffb1770d7c __bch2_new_inode+0xbc ([kernel.kallsyms])
        ffffffffb17756fa __bch2_create+0x8a ([kernel.kallsyms])
        ffffffffb1775cf6 bch2_create+0x26 ([kernel.kallsyms])
        ffffffffb136ab30 lookup_open.isra.0+0x5a0 ([kernel.kallsyms])
        ffffffffb13710e4 path_openat+0x304 ([kernel.kallsyms])
        ffffffffb1371aec do_filp_open+0xac ([kernel.kallsyms])
        ffffffffb1354301 do_sys_openat2+0x91 ([kernel.kallsyms])
        ffffffffb1354773 __x64_sys_openat+0x53 ([kernel.kallsyms])
        ffffffffb20d09b9 do_syscall_64+0x69 ([kernel.kallsyms])
        ffffffffb2200117 entry_SYSCALL_64_after_hwframe+0x76 ([kernel.kalls=
yms])
                   f7f01 __GI___libc_open+0x51
(/usr/lib/x86_64-linux-gnu/libc.so.6)
        38322f3839332f33 [unknown] ([unknown])



--=20
Mateusz Guzik <mjguzik gmail.com>
