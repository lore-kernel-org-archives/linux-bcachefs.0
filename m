Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D4D1ACEAC;
	Fri, 25 Apr 2025 16:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745600036; cv=none; b=U4FxPdjUy8X8eK5AuTkIej/kivdm3Te5NXrYx+kKY/uOKZuM62le8TyowUN1LtEmpROFk04BrPHzgkj77otWo0wK7FFZNdF+w+MhOHgp1T28+IXgmxowTie1znhWAvSteVvHtjwI2gfB1OZXbhk2wVoEYHVvuwSahus5qIfg3E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745600036; c=relaxed/simple;
	bh=wDDWwNorEgyf1DK+t5UlrDqvwSyCk8iGBsGGEULzKAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AxV//1c7fThcQTD8jFLUccblBGtpFmBMsnLy2zHxjoYoqq+Unta8WvgTgJDAJQhxaoy570HlfXFcxQMA+yoIfrd5798GF4wTVlsw95CB+MJJLwouqixTGDwQnPvAVqrpNo++cjM56YEMvxRfsAd31SHy0JQV07uU6of6CSEA0V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gqp3lTHb; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gqp3lTHb"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-223f4c06e9fso23384265ad.1;
        Fri, 25 Apr 2025 09:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745600034; x=1746204834; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tviy9TtMmPd+Bq9NvF3M6rtwnmthJ23vPw61LIOxPYQ=;
        b=gqp3lTHbv6IpSSj8fAuwV5nfHzhhC71cF9nPRic1yaYr3NRne5i2DC3xLEGBiGORtn
         CzDgSDgt3ndm8FBDzolap54OM0uaVA7jb+3YkWGM17kFdQSXXP7+pCgrM/dLn3ZGkJZ8
         t/cMg20BdrBpWalXayctDpDsjKmOFO5cML1TIZLCtmJsEnxBk0kiw1XnDCwdtPXW4hxx
         XLprWjGrcV5RH1gVtYuZCnui+UkQDSiq3aDolAsHzE6Chl9gk1QmpQb5vt6hpLDm+nSs
         ong/2IQfOVmZXJiKjeRBVs/FWhpD6i8Cna7huIMwI7q/hr2Y7qUkQSdfFJxvYr8oHr5e
         AyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745600034; x=1746204834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tviy9TtMmPd+Bq9NvF3M6rtwnmthJ23vPw61LIOxPYQ=;
        b=GEwbgYE/FxQqcNrk5sCGI3lqjXmSIQf/SpkxOTZIGj0MwXaZS1CPn0ee/5eRVWYCfF
         f3dPllqSSEdyWgIN4ZnppL816lmd/CU7S1qXJdZzmb6eH4jfLTI86DpJ1AGNZW2zmqfJ
         Aajcc2rBQZ3kqiaDUg9mLMVzJjD86riQjcAMjU6MJ3w9QDOGjl2iuBQHD5lvPawR7/Ay
         gGL5NFRX/Tqdm4ZLJ757VNk2k15DNLv8/m/lVS47CTdRSHZ2dSUcn/xH52XJRYGg6bF1
         Hpg76y9eX1pOuIJZkbIumKjgqPxcZpLsfFrSSwDTTB/mwIE7CpHWHPDVQrg9wu03LgSr
         vtNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGfyw6CT5PrbO22L2UtsNBk4Anb1wkGkkWpxzj83+SeKBKPlPRo+Y0Lp/YIzqQpA9kOBrilm/fpyWlSqbh@vger.kernel.org, AJvYcCWHVU1Frm7aoekfWLSzS8VDB0H1JdiO2RQ18DkAz06nLX53EiH9y9TMz94oJZ7YXhCToGBJ8Cnfwiq+61H8@vger.kernel.org, AJvYcCXAeTzGUcN/UlptOEANRKFmXYmmSOEjXeY/gGF/lnjAM2p1N2prlINhB0NIlZhVKUZQGSKCqhijSoo9sVEd3g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsOVgUODAXortOWku1qQ0FjAoIUXP1s3QdWF9u7FgaIDIPhLTm
	PQ1TxOhRePcWFXfrkJ4XviXaq/iY92kRUFAMhN9lgqE2UExq07rM
X-Gm-Gg: ASbGncsk8oeBwf3xhcbVoNQuaEmiHxsNJaWlXbLfii6yJReQKbiIhPwQIB5Xmps2ND7
	73MPNMolqKV0A7FUEY9lqSsoWskwQSaHiSedWJKAGHX8N6/6LqMcdK3M8vwvWJJ7n+irs6CUYPM
	HhBE++1zs0stEh3nv6K/RpjC5LlVbjEzY0WwkdGuQ/6UfKTlzFV5cwaowrS7K3djqnLZsFN7Tc/
	nUQcKcmVk0BrjbKJems94NzlT7fzB1kih0ubhNPA7uIn2Dmzfdw9mcHG1/KMst0cqYMq2LIBUXR
	nc26b0EiHhklOK96Sr/2rGeRjK1p2F/lGixDWjEJKZFxxH0c8nVm8Nay/g==
X-Google-Smtp-Source: AGHT+IFhCZVJG7BmsJj4QwIIMaru3w3J44H83XBqoGP5RuI4Eg0NRoO7u8y9l3uVOpUjRcEk/+KyXg==
X-Received: by 2002:a17:903:1b70:b0:223:5187:a886 with SMTP id d9443c01a7336-22dbf981445mr50244645ad.22.1745600033939;
        Fri, 25 Apr 2025 09:53:53 -0700 (PDT)
Received: from vaxr-BM6660-BM6360 ([2001:288:7001:2703:f97d:cfa2:241e:84aa])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db50ea7casm34586805ad.134.2025.04.25.09.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 09:53:53 -0700 (PDT)
Date: Sat, 26 Apr 2025 00:53:49 +0800
From: I Hsin Cheng <richard120310@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com,
	bfoster@redhat.com, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] bcachefs: Fix unit-value within btree_bounce_alloc()
Message-ID: <aAu-Heqb3malYkjI@vaxr-BM6660-BM6360>
References: <000000000000736bd406151001d7@google.com>
 <20250423163718.194316-1-richard120310@gmail.com>
 <ur4a24w2wb3euh3ej7ybeqnvmqyhzmqp2wwsjtilh6mfetv45l@qlxs3vggfq5h>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ur4a24w2wb3euh3ej7ybeqnvmqyhzmqp2wwsjtilh6mfetv45l@qlxs3vggfq5h>

On Wed, Apr 23, 2025 at 12:45:20PM -0400, Kent Overstreet wrote:
> On Thu, Apr 24, 2025 at 12:37:18AM +0800, I Hsin Cheng wrote:
> > Use "kvzalloc()" instead of "kvmalloc()" in btree_bounce_alloc() to
> > prevent uninit-value issue.
> > 
> > Reported-by: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=549710bad9c798e25b15
> > Fixes: cb6fc943b650 ("bcachefs: kill kvpmalloc()")
> > Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
> > ---
> > syzbot reported an uninit-value issue. [1]
> > 
> > Though the uninit value was detected in the context of crc32_body(), the
> > memory was actually allocated in "btree_bounce_alloc()". Use
> > "kvzalloc()" to allocate the memory can solve the issue, and I've tested
> > against syzbot. [2]
> > 
> > If there're any further tests needed to be performed, please let me
> > know. I'll be more than happy to assist you with that, thanks !
> 
> See Documentation/filesystems/bcachefs/SubmittingPatches.
>

Sure ! Thanks for the info.

> And this isn't the correct fix - the correct fix is already in Linus's
> tree.

Ahh ok, may I ask for the commit hash or title so I can learn from it ?

Best regards,
I Hsin Cheng
> 
> > 
> > [1]:
> > BUG: KMSAN: uninit-value in crc32_body lib/crc32.c:110 [inline]
> > BUG: KMSAN: uninit-value in crc32_le_generic lib/crc32.c:179 [inline]
> > BUG: KMSAN: uninit-value in __crc32c_le_base+0x43c/0xd80 lib/crc32.c:201
> >  crc32_body lib/crc32.c:110 [inline]
> >  crc32_le_generic lib/crc32.c:179 [inline]
> >  __crc32c_le_base+0x43c/0xd80 lib/crc32.c:201
> >  chksum_update+0x5b/0xd0 crypto/crc32c_generic.c:88
> >  crypto_shash_update+0x79/0xa0 crypto/shash.c:52
> >  crc32c+0xba/0x170 lib/libcrc32c.c:47
> >  bch2_checksum_update+0x106/0x1d0 fs/bcachefs/checksum.c:83
> >  bch2_checksum+0x3c5/0x7c0 fs/bcachefs/checksum.c:216
> >  __bch2_btree_node_write+0x528c/0x67c0 fs/bcachefs/btree_io.c:2151
> >  bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2288
> >  btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
> >  __btree_node_flush+0x4d0/0x640 fs/bcachefs/btree_trans_commit.c:229
> >  bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:238
> >  journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:553
> >  __bch2_journal_reclaim+0xd88/0x1610 fs/bcachefs/journal_reclaim.c:685
> >  bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:727
> >  kthread+0x3e2/0x540 kernel/kthread.c:389
> >  ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> > 
> > Uninit was stored to memory at:
> >  memcpy_u64s_small fs/bcachefs/util.h:511 [inline]
> >  bkey_p_copy fs/bcachefs/bkey.h:46 [inline]
> >  bch2_sort_keys+0x1b4d/0x2cb0 fs/bcachefs/bkey_sort.c:194
> >  __bch2_btree_node_write+0x3acd/0x67c0 fs/bcachefs/btree_io.c:2100
> >  bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2288
> >  btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
> >  __btree_node_flush+0x4d0/0x640 fs/bcachefs/btree_trans_commit.c:229
> >  bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:238
> >  journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:553
> >  __bch2_journal_reclaim+0xd88/0x1610 fs/bcachefs/journal_reclaim.c:685
> >  bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:727
> >  kthread+0x3e2/0x540 kernel/kthread.c:389
> >  ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> > 
> > Uninit was created at:
> >  __kmalloc_large_node+0x231/0x370 mm/slub.c:3994
> >  __do_kmalloc_node mm/slub.c:4027 [inline]
> >  __kmalloc_node+0xb10/0x10c0 mm/slub.c:4046
> >  kmalloc_node include/linux/slab.h:648 [inline]
> >  kvmalloc_node+0xc0/0x2d0 mm/util.c:634
> >  kvmalloc include/linux/slab.h:766 [inline]
> >  btree_bounce_alloc fs/bcachefs/btree_io.c:118 [inline]
> >  bch2_btree_node_read_done+0x4e68/0x75e0 fs/bcachefs/btree_io.c:1185
> >  btree_node_read_work+0x8a5/0x1eb0 fs/bcachefs/btree_io.c:1324
> >  bch2_btree_node_read+0x3d42/0x4b50
> >  __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
> >  bch2_btree_root_read+0xa6c/0x13d0 fs/bcachefs/btree_io.c:1772
> >  read_btree_roots+0x454/0xee0 fs/bcachefs/recovery.c:457
> >  bch2_fs_recovery+0x7b6a/0x93e0 fs/bcachefs/recovery.c:785
> >  bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
> >  bch2_fs_open+0x152a/0x15f0 fs/bcachefs/super.c:2105
> >  bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1906
> >  legacy_get_tree+0x114/0x290 fs/fs_context.c:662
> >  vfs_get_tree+0xa7/0x570 fs/super.c:1779
> >  do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
> >  path_mount+0x742/0x1f20 fs/namespace.c:3679
> >  do_mount fs/namespace.c:3692 [inline]
> >  __do_sys_mount fs/namespace.c:3898 [inline]
> >  __se_sys_mount+0x725/0x810 fs/namespace.c:3875
> >  __x64_sys_mount+0xe4/0x150 fs/namespace.c:3875
> >  x64_sys_call+0x2bf4/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:166
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > 
> > [2]:
> > https://lore.kernel.org/all/000000000000736bd406151001d7@google.com/T/#m748384a36239a7f66e63cfde949e3db6bf14d5c6
> > 
> > syzbot reply me with:
> > Hello,
> > 
> > syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> > 
> > Reported-by: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com
> > Tested-by: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com
> > 
> > Tested on:
> > 
> > commit:         614da38e Merge tag 'hid-for-linus-2024051401' of git:/..
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10be763f980000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=49342144b6a907af
> > dashboard link: https://syzkaller.appspot.com/bug?extid=549710bad9c798e25b15
> > compiler:       Debian clang version 15.0.6, Debian LLD 15.0.6
> > patch:          https://syzkaller.appspot.com/x/patch.diff?x=15b99a6f980000
> > 
> > Note: testing is done by a robot and is best-effort only.
> > 
> > Best regards,
> > I Hsin Cheng
> > ---
> >  fs/bcachefs/btree_io.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> > index debb0edc3455..dc00c5273ffe 100644
> > --- a/fs/bcachefs/btree_io.c
> > +++ b/fs/bcachefs/btree_io.c
> > @@ -115,7 +115,7 @@ static void *btree_bounce_alloc(struct bch_fs *c, size_t size,
> >  	BUG_ON(size > c->opts.btree_node_size);
> >  
> >  	*used_mempool = false;
> > -	p = kvmalloc(size, __GFP_NOWARN|GFP_NOWAIT);
> > +	p = kvzalloc(size, __GFP_NOWARN|GFP_NOWAIT);
> >  	if (!p) {
> >  		*used_mempool = true;
> >  		p = mempool_alloc(&c->btree_bounce_pool, GFP_NOFS);
> > -- 
> > 2.43.0
> > 
