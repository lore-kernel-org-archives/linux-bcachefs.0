Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4534D28DF4E;
	Tue, 10 Jun 2025 12:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749557993; cv=none; b=IhR0/LY5w/jlHeRheqV+Qx9XiFa/wYeBGy8DtZ9MQPxxo0embKRStYE9Qqp4gENZwlGpkzHjfUQx3OQi+6/uT3bEhsH+XixwsMuJVIbzCleRShB4EJ3OoB01o4qfn9OTA3xagPqnUztaVhWVm34Juxx/wBS1jOX946Q9pJiQB/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749557993; c=relaxed/simple;
	bh=Rnu9CTNBGzpHnVvOua9LbCX8fRyVu5ECQhvPkxgSVl8=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u06uJxAuHtwNSysWUKKa5huw0kj1sNBjbitfyKZNpbTJYn6eoTgMU5hfx2ol8F10CZLl4mRB8jlRPAJ43SdzOFqrTHOuRuvr8ktNkUIl+6yFuj9z8KQqsab1sLgp+VOQzpGw1w+0h1xQMlqK5yRDdAkQy2gKaeIjMMFwYvHLvik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UiRBmzPZ; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UiRBmzPZ"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5532a30ac41so5490883e87.0;
        Tue, 10 Jun 2025 05:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749557989; x=1750162789; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eQAN1VoZVMU0LFg5gjayj+lCmiFTFvo/2om6CUAJUKA=;
        b=UiRBmzPZ/s72WQgbMsmyF4AF4rUqNH1xJVHGG2Kxb1JtEBaNXGhFhfuC4JhYrTz/UN
         efDK9zgp73JJuODCYeKWJgCUlTrB6BOqP/sbG6Sj2vp1lCPp8nuJxxJCEff0WSnQ1qEc
         u9sZx0RqRS+9d4Z8Kszru0Pja1aMesAh0vt/C8vE86pIvA5ztBA7ZphzR2aMGvhOxLw8
         qily0D8K2c66payXvhPzV86+6tohUfygnwtIdBt9LfwXdkreEOL2Z0+ToTP29BGLFQDy
         h0A522dzoB1JZAmdiUB0/11hEP2L0d/X/oXiTdqPhJkmA6mEGTIfdiwDz2oawSWm/bAb
         9XTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749557989; x=1750162789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eQAN1VoZVMU0LFg5gjayj+lCmiFTFvo/2om6CUAJUKA=;
        b=XPH+wi/E7Ny6eC5T4Gy77Bqa7pYtTaJb68KfcOovuCbHLrvrdxQpnn1BhZGcQ2Yl9B
         LCcu7aMnayKtqKDCbr7w3Yxv6n1NFyCX2gyIfCwuTzbGxsBVFB1DcgpP3isYOGjChK+y
         KKhDI0T6Brerk6hJddDUQA7Bzu2JVrdJeE8lB7oHRwAJzASn8dVZ+nfKZHiyRRhgnHzl
         EshemOk9j+OVVGEEm4gLZtlwiXrKFj9982FAOCzx+Jp7LvnzAKcHNdk/qpANMGSOA4Sh
         dYlWtVFhp//5YCdUddrQEXVBvTta3WCbVsM3WBugJOQUfjxP1QEsmkBDGX6Gh4cKZ9Wp
         CaFQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5LvWRN2gs4oLlAqzUL1WWfBiO1OF756iK8CaoHhnoE7uTlimKGD0FqpNhjdr2TiNEEeWm1mzLHbMHULGmmg==@vger.kernel.org, AJvYcCVYCHkcV1GeCqFish26u2gzcexwHywvaP1kmY1CRJSxv38J/c7q9CPEB2WzulBH3+UQYgbd@vger.kernel.org, AJvYcCXHdT3vTsThdloZqeET8sOVV1gN8WORtiWkf3tLQ8ZeC1evCNQygyGI8kaGdT5NgrDihWfsWFFsyzwa0L/Z@vger.kernel.org
X-Gm-Message-State: AOJu0YzLX+2ATfpXH5gXa0YqHGEREcW8GEm3TYBju2D4eMgSB4WKTYeA
	6+YGPd+L2mGgz/XLcXrq++uXLTiBBa9WEfU/bPoM25YqlpWSZG/uChkt8iMXIQoX
X-Gm-Gg: ASbGnctApRDUUKZRlYxiGq9sDkkqZsIL/xbdLoBR+VfumRmTtXcZM7gY+i73A/nKL8D
	BvuUF1U8MCulkwZfpCTzAj59eENsiI+ra/sBcQXeIrwM88Zlb4i2yG8877tf0nR+aGu6fT9cWtl
	4lNgFWgqRsWK/D06OYqMjMVm1LHokG9TvYUFdvWpa1J3X3TBq3V8h2hFSsixAxf/YGUe1MhAYK9
	tArnRF0FaJ4PzYzORrxM7/9w669yow+/NHgy2uyyVlAm9Jm6pcLeJ2of0895SYdrSoJKH76RlPe
	EzwMzTUBMaBKRdc3kM4XT+X+9A8A9nX8pOU1srZIiSsynM5DtSi9K/tct3sv9eb8GUCk4HFF2nc
	Hc6x/5LktpsQ=
X-Google-Smtp-Source: AGHT+IEOAiThqyr/g3IbOy9bU1mIQFiH29X+QkzD7LOn1vfWuf50BiAf8qQ83WrZqQTXXFrnlRL34Q==
X-Received: by 2002:a05:6512:ba9:b0:553:29a6:3398 with SMTP id 2adb3069b0e04-55366e349b3mr4481056e87.55.1749557988857;
        Tue, 10 Jun 2025 05:19:48 -0700 (PDT)
Received: from pc636 (host-95-203-1-180.mobileonline.telia.com. [95.203.1.180])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55367722516sm1497993e87.106.2025.06.10.05.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 05:19:48 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 10 Jun 2025 14:19:45 +0200
To: Joel Fernandes <joelagnelf@nvidia.com>
Cc: paulmck@kernel.org, Uladzislau Rezki <urezki@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, josh@joshtriplett.org,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, rcu@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [rcu?] [bcachefs?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
Message-ID: <aEgi4cHN_Mg31F-y@pc636>
References: <67a2b20a.050a0220.50516.0003.GAE@google.com>
 <9694d40a-072e-47c2-a950-3b258bbe04f5@paulmck-laptop>
 <jzknqese5idob37wxgclq7ptxnsd66qbqkxtjpjormymsrwv2j@xjum5exljlh6>
 <aEXVKNVLI3VQInSc@pc636>
 <602bb1be-f4a4-4194-803f-856e95711870@paulmck-laptop>
 <aEac1veMLffwOdv8@pc636>
 <e3187e7a-cac2-46c4-9c56-3a649e122353@paulmck-laptop>
 <2f762834-d143-4b84-9ab2-8bff4688ae66@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f762834-d143-4b84-9ab2-8bff4688ae66@nvidia.com>

On Mon, Jun 09, 2025 at 10:20:58AM -0400, Joel Fernandes wrote:
> 
> 
> On 6/9/2025 5:47 AM, Paul E. McKenney wrote:
> > On Mon, Jun 09, 2025 at 10:35:34AM +0200, Uladzislau Rezki wrote:
> >> On Sun, Jun 08, 2025 at 05:25:05PM -0700, Paul E. McKenney wrote:
> >>> On Sun, Jun 08, 2025 at 08:23:36PM +0200, Uladzislau Rezki wrote:
> >>>> On Sun, Jun 08, 2025 at 11:26:28AM -0400, Kent Overstreet wrote:
> >>>>> On Wed, Feb 05, 2025 at 06:56:19AM -0800, Paul E. McKenney wrote:
> >>>>>> On Tue, Feb 04, 2025 at 04:34:18PM -0800, syzbot wrote:
> >>>>>>> Hello,
> >>>>>>>
> >>>>>>> syzbot found the following issue on:
> >>>>>>>
> >>>>>>> HEAD commit:    0de63bb7d919 Merge tag 'pull-fix' of git://git.kernel.org/..
> >>>>>>> git tree:       upstream
> >>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=10faf5f8580000
> >>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
> >>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
> >>>>>>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> >>>>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b69d18580000
> >>>>>>>
> >>>>>>> Downloadable assets:
> >>>>>>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0de63bb7.raw.xz
> >>>>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/1142009a30a7/vmlinux-0de63bb7.xz
> >>>>>>> kernel image: https://storage.googleapis.com/syzbot-assets/5d9e46a8998d/bzImage-0de63bb7.xz
> >>>>>>> mounted in repro: https://storage.googleapis.com/syzbot-assets/526692501242/mount_0.gz
> >>>>>>>
> >>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >>>>>>> Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> >>>>>>>
> >>>>>>>  slab radix_tree_node start ffff88803bf382c0 pointer offset 24 size 576
> >>>>>>> BUG: kernel NULL pointer dereference, address: 0000000000000000
> >>>>>>> #PF: supervisor instruction fetch in kernel mode
> >>>>>>> #PF: error_code(0x0010) - not-present page
> >>>>>>> PGD 0 P4D 0 
> >>>>>>> Oops: Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
> >>>>>>> CPU: 0 UID: 0 PID: 5705 Comm: syz-executor Not tainted 6.14.0-rc1-syzkaller-00020-g0de63bb7d919 #0
> >>>>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> >>>>>>> RIP: 0010:0x0
> >>>>>>> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> >>>>>>> RSP: 0018:ffffc90000007bd8 EFLAGS: 00010246
> >>>>>>> RAX: dffffc0000000000 RBX: 1ffff110077e705c RCX: 23438dd059a4b100
> >>>>>>> RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88803bf382d8
> >>>>>>> RBP: ffffc90000007e10 R08: ffffffff819f146c R09: 1ffff11003f8519a
> >>>>>>> R10: dffffc0000000000 R11: 0000000000000000 R12: ffffffff81a6d507
> >>>>>>> R13: ffff88803bf382e0 R14: 0000000000000000 R15: ffff88803bf382d8
> >>>>>>> FS:  0000555567992500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
> >>>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>>>>> CR2: ffffffffffffffd6 CR3: 000000004da38000 CR4: 0000000000352ef0
> >>>>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >>>>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >>>>>>> Call Trace:
> >>>>>>>  <IRQ>
> >>>>>>>  rcu_do_batch kernel/rcu/tree.c:2546 [inline]
> >>>>>>
> >>>>>> The usual way that this happens is that someone clobbers the rcu_head
> >>>>>> structure of something that has been passed to call_rcu().  The most
> >>>>>> popular way of clobbering this structure is to pass the same something to
> >>>>>> call_rcu() twice in a row, but other creative arrangements are possible.
> >>>>>>
> >>>>>> Building your kernel with CONFIG_DEBUG_OBJECTS_RCU_HEAD=y can usually
> >>>>>> spot invoking call_rcu() twice in a row.
> >>>>>
> >>>>> I don't think it's that - syzbot's .config already has that enabled.
> >>>>> KASAN, too.
> >>>>>
> >>>>> And the only place we do call_rcu() is from rcu_pending.c, where we've
> >>>>> got a rearming rcu callback - but we track whether it's outstanding, and
> >>>>> we do all relevant operations with a lock held.
> >>>>>
> >>>>> And we only use rcu_pending.c with SRCU, not regular RCU.
> >>>>>
> >>>>> We do use kfree_rcu() in a few places (all boring, I expect), but that
> >>>>> doesn't (generally?) use the rcu callback list.
> >>>>>
> >>>> Right, kvfree_rcu() does not intersect with regular callbacks, it has
> >>>> its own path. 
> >>>>
> >>>> It looks like the problem is here:
> >>>>
> >>>> <snip>
> >>>>   f = rhp->func;
> >>>>   debug_rcu_head_callback(rhp);
> >>>>   WRITE_ONCE(rhp->func, (rcu_callback_t)0L);
> >>>>   f(rhp);
> >>>> <snip>
> >>>>
> >>>> we do not check if callback, "f", is a NULL. If it is, the kernel bug
> >>>> is triggered right away. For example:
> >>>>
> >>>> call_rcu(&rh, NULL);
> >>>>
> >>>> @Paul, do you think it makes sense to narrow callers which apparently
> >>>> pass NULL as a callback? To me it seems the case of this bug. But we
> >>>> do not know the source.
> >>>>
> >>>> It would give at least a stack-trace of caller which passes a NULL.
> >>>
> >>> Adding a check for NULL func passed to __call_rcu_common(), you mean?
> >>>
> >> Yes. Currently there is no any check. So passing a NULL just triggers
> >> kernel panic.
> >>
> >>>
> >>> That wouldn't hurt, and would either (as you say) catch the culprit
> >>> or show that the problem is elsewhere.
> >>>
> >> I can add it then and send out the patch if no objections.
> > 
> > No objections from me!
> 
> Me neither! And I can push that into an -rc release as well once I have it
> (since it is related to a potential bug).
> 
I will prepare it and send out today.

--
Uladzislau Rezki
