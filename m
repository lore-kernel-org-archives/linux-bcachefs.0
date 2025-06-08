Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC8F13B58A;
	Sun,  8 Jun 2025 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749407022; cv=none; b=kv4jgtvNGK5ljUDZzHg9tO3vssCaiUBNjEPFNiUZUsfTdxEEksBMmZ040Rt50/Dm57mGQpqkeZdRfKBStGkIu1Jty5Dg7qmc1SMZLyI2qlmiYR5dsPN9TWIOEUqUwtbGGiuXwHNJdVu/Qwa6wGzW33C2xN/s4wqogRA18pkRBmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749407022; c=relaxed/simple;
	bh=JDNe7oT5jmZxHCK+hLJFyqlGVnzPX0XUp2TdGuv5uoE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OG57PezrfeINMNCaWIKL9fTyi5qIewIjNelyPZpSd1KTg1l5Tn1GGZ8GvSlID50QH8tflc29/MeBnxOWIY4U0AR/sFOcqbgHp1d2UBjMuKL+6y+hHPf2K7VZSDtw8tNV4wdqvenDrW5/DmGTHoLJj1Uluqb+qrJ81YjJlIuO8IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hFRwUwSf; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hFRwUwSf"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-32ae3e94e57so18666911fa.1;
        Sun, 08 Jun 2025 11:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749407019; x=1750011819; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U8R9ajSxF0D4ByAji1QcuYH71phyynAaen4Z3JnG7gA=;
        b=hFRwUwSf85FydiG5iASgydkkodP3J5wGEbw9CZ0ffH79fcIqhE3VhjbOj1c4iV4oqZ
         09oI18K9g8xvfShD0JwNpsFuToTtkop++OmyJOn+OVqne4ZTzVJTAgIEWAeuCBMd9JBY
         x6kfM5IOzHKfgVidhQLgSAqhPse+c3uhCCzyhbqSp/tsJomIv/d8d1kv7rTmo9P9wN/C
         qqZ9n0u97z77eVUDLCR8F51oTObnPetcYk2dF/pbSIZ0scgcJJ+PKQpTe7t80ufA1HAA
         b5fbd24Y0sv8vXDFPqP2tNSjyPoP+JeMZhmcmGGxh7hcKigBQyFu7q3nJtzzaaHsGG0I
         qGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749407019; x=1750011819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8R9ajSxF0D4ByAji1QcuYH71phyynAaen4Z3JnG7gA=;
        b=Pb+JOOd4sl7wmbLZh8pYj0X4O/y/qMZga6Tn3podrgNDAUxW7b7S2Ygi0vlZ1f5ZSB
         5mPFLQBK/RBnWhOW3wALNY6kf2b+3jHck9Lvw1wtInzUDSVM9tgUcekX+0F+A7jtPpt/
         t8QitK4YsdhhN5cGnaywnFN6RwjzCNhizNoEfkyF9HVeL5bYdnN979tULjGsMcqFJbRH
         XeB+9spUv+H9dHHdUzg599dtdAwsauKfWVujqM61G7T8n8ZL4/BFUIPea0tPd1IaSFsN
         VIOvdz03TdH+Y2KEF+cz/azacwZBZAJHfVQ/qEhtTKddiJ4swZ9AEqGrjenlyqTBwK5W
         kXkA==
X-Forwarded-Encrypted: i=1; AJvYcCUeuUlx4dPN3iRwsypWh3JgnAQMUh/oEhPaCHWZTldxntHYrcX68gArGo3XRlqRlgkAbA7slfJpxyvtp5XXPg==@vger.kernel.org, AJvYcCUzthznQmTbgyA+6t3sufZNQxtl5yiYPtNZJevPnDGSYmuCkVJYHucZ+TrQ3XlYNfQk6EO+@vger.kernel.org, AJvYcCXWbEu3lSHhLeq9e0ZZrjKzR+Ry3X/M/WBcxz85B0+yAy7cMNRmaPo3uYo7R3wOsmzEFzFSaGO7fxduDt/W@vger.kernel.org
X-Gm-Message-State: AOJu0YwA5ESNBWm1LQ5HGvmYXmjpI/9FNPH8bnnXF6bpp3PUY4d5GQdE
	GPnYG2wjhZvwdnbHImEED41Qt5rgtu95uXKj1Oxw58Q9rTnqZRpF8RlA
X-Gm-Gg: ASbGncsOX/WeRTjXKF9NTM9KmGLc8AOfdGgSo/AIweZgsKMH9q8Rtb4Fluv2kC4KcVp
	7yJ29mbBFjpspGi11dPfwWpcy0qD4lHgi1bvR+nYNFC86jHc0NCmzC4QQXx0xgVdw39jMFo8GKX
	r9A1HWm9zo3RF4d/WITkuwCqt2CV2lRbjCjhZTIcQALAxAiqtdIHewFkpElRtP1eFSafjFBMkGN
	m8AJ+QLjk1NqOiD9+1OsC3zU0CtxYNTXtj3H0Li8Ry4ao/7CbVJlkwQZpW62x27oFxDgb4/K1Fj
	taxl5unheSSULTvziFak3mU61WfE
X-Google-Smtp-Source: AGHT+IF/5R7jbUNTrFZyIpdBBQTRKrlF/vZyyTM5GqfQ/xcx9pdFblrY6i2OVwDAqjN0ePESnzCZXA==
X-Received: by 2002:a2e:2243:0:b0:32a:864a:46f1 with SMTP id 38308e7fff4ca-32adfdd91f6mr23303191fa.30.1749407018248;
        Sun, 08 Jun 2025 11:23:38 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-32ae1cad433sm7751971fa.53.2025.06.08.11.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jun 2025 11:23:37 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Sun, 8 Jun 2025 20:23:36 +0200
To: Kent Overstreet <kent.overstreet@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, josh@joshtriplett.org,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, rcu@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [rcu?] [bcachefs?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
Message-ID: <aEXVKNVLI3VQInSc@pc636>
References: <67a2b20a.050a0220.50516.0003.GAE@google.com>
 <9694d40a-072e-47c2-a950-3b258bbe04f5@paulmck-laptop>
 <jzknqese5idob37wxgclq7ptxnsd66qbqkxtjpjormymsrwv2j@xjum5exljlh6>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jzknqese5idob37wxgclq7ptxnsd66qbqkxtjpjormymsrwv2j@xjum5exljlh6>

On Sun, Jun 08, 2025 at 11:26:28AM -0400, Kent Overstreet wrote:
> On Wed, Feb 05, 2025 at 06:56:19AM -0800, Paul E. McKenney wrote:
> > On Tue, Feb 04, 2025 at 04:34:18PM -0800, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following issue on:
> > > 
> > > HEAD commit:    0de63bb7d919 Merge tag 'pull-fix' of git://git.kernel.org/..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=10faf5f8580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
> > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b69d18580000
> > > 
> > > Downloadable assets:
> > > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0de63bb7.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/1142009a30a7/vmlinux-0de63bb7.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/5d9e46a8998d/bzImage-0de63bb7.xz
> > > mounted in repro: https://storage.googleapis.com/syzbot-assets/526692501242/mount_0.gz
> > > 
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> > > 
> > >  slab radix_tree_node start ffff88803bf382c0 pointer offset 24 size 576
> > > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > > #PF: supervisor instruction fetch in kernel mode
> > > #PF: error_code(0x0010) - not-present page
> > > PGD 0 P4D 0 
> > > Oops: Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
> > > CPU: 0 UID: 0 PID: 5705 Comm: syz-executor Not tainted 6.14.0-rc1-syzkaller-00020-g0de63bb7d919 #0
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > > RIP: 0010:0x0
> > > Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> > > RSP: 0018:ffffc90000007bd8 EFLAGS: 00010246
> > > RAX: dffffc0000000000 RBX: 1ffff110077e705c RCX: 23438dd059a4b100
> > > RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88803bf382d8
> > > RBP: ffffc90000007e10 R08: ffffffff819f146c R09: 1ffff11003f8519a
> > > R10: dffffc0000000000 R11: 0000000000000000 R12: ffffffff81a6d507
> > > R13: ffff88803bf382e0 R14: 0000000000000000 R15: ffff88803bf382d8
> > > FS:  0000555567992500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: ffffffffffffffd6 CR3: 000000004da38000 CR4: 0000000000352ef0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <IRQ>
> > >  rcu_do_batch kernel/rcu/tree.c:2546 [inline]
> > 
> > The usual way that this happens is that someone clobbers the rcu_head
> > structure of something that has been passed to call_rcu().  The most
> > popular way of clobbering this structure is to pass the same something to
> > call_rcu() twice in a row, but other creative arrangements are possible.
> > 
> > Building your kernel with CONFIG_DEBUG_OBJECTS_RCU_HEAD=y can usually
> > spot invoking call_rcu() twice in a row.
> 
> I don't think it's that - syzbot's .config already has that enabled.
> KASAN, too.
> 
> And the only place we do call_rcu() is from rcu_pending.c, where we've
> got a rearming rcu callback - but we track whether it's outstanding, and
> we do all relevant operations with a lock held.
> 
> And we only use rcu_pending.c with SRCU, not regular RCU.
> 
> We do use kfree_rcu() in a few places (all boring, I expect), but that
> doesn't (generally?) use the rcu callback list.
>
Right, kvfree_rcu() does not intersect with regular callbacks, it has
its own path. 

It looks like the problem is here:

<snip>
  f = rhp->func;
  debug_rcu_head_callback(rhp);
  WRITE_ONCE(rhp->func, (rcu_callback_t)0L);
  f(rhp);
<snip>

we do not check if callback, "f", is a NULL. If it is, the kernel bug
is triggered right away. For example:

call_rcu(&rh, NULL);

@Paul, do you think it makes sense to narrow callers which apparently
pass NULL as a callback? To me it seems the case of this bug. But we
do not know the source.

It would give at least a stack-trace of caller which passes a NULL.

--
Uladzislau Rezki
