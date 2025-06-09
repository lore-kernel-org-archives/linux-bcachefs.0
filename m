Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506DC1C5D5A;
	Mon,  9 Jun 2025 08:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749458141; cv=none; b=qSTOlQaO/XH99VsYzBScwv3muNwLJxkrtHLQe4WgDJM1zu0rS5wGFkg8azO5MhDLSiQ7t+8QEVg5D2gJJOCjjzYKmTBYO6npe8MWDYnWHhFgm0UHMvQsuquZtzFMOxuiInuwgRRCAAreEbaqZ+F1MYzpErAWUQwXt8OUZR0OAMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749458141; c=relaxed/simple;
	bh=6qC7Gvl+cvb6pFeGa9K2/BB2Ne9eqvcdaosw99/IOeU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gitwwQvhEnUhxHQIGe8XsPssJgI8iFvW1XraMFV9JiUDuEBqwFlqQCnBgxdYeXPrMJw6LlKmkQ85MovtTxe5UDifnhC3a5q/lv6jk6uQkA/r0H7VBl0MNdIAHh0YBNs4+bpIw+8pdr6wsIY9kXbi32T6rIhly+Tms5pHGPmjA9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yuj6b9Sx; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yuj6b9Sx"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5535652f42cso4099747e87.2;
        Mon, 09 Jun 2025 01:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749458137; x=1750062937; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cvLItu/HN16OmhCmeDXPcs+GyozsakyZwX/mIV9qLzE=;
        b=Yuj6b9Sx8kCEOVevJsj08DSzojDt6bjWs3fa1LGbrBAhlO9gcjcjAAy6cgMDsMjOuU
         BLnVu58Mr1/4kZlaYJPY3Urw1hMHfADOScsd25vwFmnqD2ZvOqV39ueEgn+Ns1y345oS
         Uul3J6YG+d3hlbaOXocdCRP4zi2AFmDTOymOu12fKedUZhevd881cbY9XjgA/InoUcMA
         wdsAehgn3/+UAbjSfEe53mdsi2CJgXZR5d9LkTBPQBztzVievDgylfXQUl1pMVzmjmVx
         uea67KlkUq6Qyqut9ILCJHnbsDhAxZ2Lk0o2DkrdMjlWwOs1NwWCIEo/X5qSFE+CAGOZ
         mFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749458137; x=1750062937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cvLItu/HN16OmhCmeDXPcs+GyozsakyZwX/mIV9qLzE=;
        b=DyLYW/1btwA3F0Wjev8zFHKf3VBDXZyuz8YINRK4KzRn5VuYhMA/DyLdEgC7OlBuGg
         9f1y9w/vhV1gp6iWJHixheH1D70JKHizQyt49kkkBkrcsf2niVV+QoSOj3qHW4YHcnTo
         OrKIlG9Kap1TKreZ9sAlEReGK2zpan2LAfLuMqGWyPXMAeQcHb9WXAOF4jKrLluvVaCV
         YIS815qITYKRo3eM7A++/nQkiSCPwSSqbJ6zik0Rydi1G7rCqzu7OEBpErMEbXkAPiys
         NVTHQMeyec5ehUGfi5YtSRD7zww1AvTYWVGZVF2hLfipuQBqt/mrqub3rzTE4j74OFsF
         5fDw==
X-Forwarded-Encrypted: i=1; AJvYcCU6iOv8y6cAZAaZLPCG3AExrgk74TR6hiVRxymIXTb02mlYM8CUvxL7ST3BHmW0XMTwRO2e@vger.kernel.org, AJvYcCWaeJA/H6y+szrkhu8fJ8l/mGWl/fz544waZVKNLnQpzCZOa7BgEpUVffkyyZ9cSm5bRmwQkB4kiWLrxhYp9A==@vger.kernel.org, AJvYcCXguChd1rTYFZ70a53r4gyC/MJHNGHgb9M89MosP7uHyZeKsYkXAx13c83VoTqQa4W/+g2b97ZfDh1fPU21@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3CnfU73pCGk9vH+UPR+axAnlngZrbfAFtCum+Az3i2hsVl8DU
	GRPGIMSQ3CPdIp/IZ94kolhayRJi2PPyngAYCWxI9X8d0ViKECS/LdAM
X-Gm-Gg: ASbGncuxrblHfgOQwpJVof/cGhFK1RwHlASsunelkXhEYUIn6s9x2RNDsqCJiZARwRi
	7S5+uqMsxK5w3dGzZwQL0X/K7fyMsWqJoSvoz2CPjr0+jPJOlGzvXFF065TIJclYnQQvTEXU4Pr
	E28UDqEeruVd28YgPO7+Sltw2NxjbnBHNmjRY/5dNaZMRO+G0s8KdGMMiwvt7dLkvjlsi0eYxfO
	N1u2fPdBx/EIlIRX1vXfnrJwxeMGcjXWehn5/n9tI4cvKsRH9j5+WJZkbb4EIxzQlKdH6mE/E/4
	yU1B0US01xtecYOkZv0nnlO45HaYz/uRwbCleoc=
X-Google-Smtp-Source: AGHT+IH83g0g5KOdIh+DOMRgYfTX58Wy6XYREYf5FT1ympEvV1siDhuPiiGn7oIc311L5D9GAuWq9w==
X-Received: by 2002:ac2:4184:0:b0:553:64ac:4670 with SMTP id 2adb3069b0e04-55366c3596cmr2570205e87.54.1749458136968;
        Mon, 09 Jun 2025 01:35:36 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-553677316bfsm1035468e87.209.2025.06.09.01.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 01:35:36 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 9 Jun 2025 10:35:34 +0200
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, josh@joshtriplett.org,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, rcu@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [rcu?] [bcachefs?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
Message-ID: <aEac1veMLffwOdv8@pc636>
References: <67a2b20a.050a0220.50516.0003.GAE@google.com>
 <9694d40a-072e-47c2-a950-3b258bbe04f5@paulmck-laptop>
 <jzknqese5idob37wxgclq7ptxnsd66qbqkxtjpjormymsrwv2j@xjum5exljlh6>
 <aEXVKNVLI3VQInSc@pc636>
 <602bb1be-f4a4-4194-803f-856e95711870@paulmck-laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <602bb1be-f4a4-4194-803f-856e95711870@paulmck-laptop>

On Sun, Jun 08, 2025 at 05:25:05PM -0700, Paul E. McKenney wrote:
> On Sun, Jun 08, 2025 at 08:23:36PM +0200, Uladzislau Rezki wrote:
> > On Sun, Jun 08, 2025 at 11:26:28AM -0400, Kent Overstreet wrote:
> > > On Wed, Feb 05, 2025 at 06:56:19AM -0800, Paul E. McKenney wrote:
> > > > On Tue, Feb 04, 2025 at 04:34:18PM -0800, syzbot wrote:
> > > > > Hello,
> > > > > 
> > > > > syzbot found the following issue on:
> > > > > 
> > > > > HEAD commit:    0de63bb7d919 Merge tag 'pull-fix' of git://git.kernel.org/..
> > > > > git tree:       upstream
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=10faf5f8580000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
> > > > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b69d18580000
> > > > > 
> > > > > Downloadable assets:
> > > > > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0de63bb7.raw.xz
> > > > > vmlinux: https://storage.googleapis.com/syzbot-assets/1142009a30a7/vmlinux-0de63bb7.xz
> > > > > kernel image: https://storage.googleapis.com/syzbot-assets/5d9e46a8998d/bzImage-0de63bb7.xz
> > > > > mounted in repro: https://storage.googleapis.com/syzbot-assets/526692501242/mount_0.gz
> > > > > 
> > > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > > Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> > > > > 
> > > > >  slab radix_tree_node start ffff88803bf382c0 pointer offset 24 size 576
> > > > > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > > > > #PF: supervisor instruction fetch in kernel mode
> > > > > #PF: error_code(0x0010) - not-present page
> > > > > PGD 0 P4D 0 
> > > > > Oops: Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
> > > > > CPU: 0 UID: 0 PID: 5705 Comm: syz-executor Not tainted 6.14.0-rc1-syzkaller-00020-g0de63bb7d919 #0
> > > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > > > > RIP: 0010:0x0
> > > > > Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> > > > > RSP: 0018:ffffc90000007bd8 EFLAGS: 00010246
> > > > > RAX: dffffc0000000000 RBX: 1ffff110077e705c RCX: 23438dd059a4b100
> > > > > RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88803bf382d8
> > > > > RBP: ffffc90000007e10 R08: ffffffff819f146c R09: 1ffff11003f8519a
> > > > > R10: dffffc0000000000 R11: 0000000000000000 R12: ffffffff81a6d507
> > > > > R13: ffff88803bf382e0 R14: 0000000000000000 R15: ffff88803bf382d8
> > > > > FS:  0000555567992500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
> > > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > CR2: ffffffffffffffd6 CR3: 000000004da38000 CR4: 0000000000352ef0
> > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > > Call Trace:
> > > > >  <IRQ>
> > > > >  rcu_do_batch kernel/rcu/tree.c:2546 [inline]
> > > > 
> > > > The usual way that this happens is that someone clobbers the rcu_head
> > > > structure of something that has been passed to call_rcu().  The most
> > > > popular way of clobbering this structure is to pass the same something to
> > > > call_rcu() twice in a row, but other creative arrangements are possible.
> > > > 
> > > > Building your kernel with CONFIG_DEBUG_OBJECTS_RCU_HEAD=y can usually
> > > > spot invoking call_rcu() twice in a row.
> > > 
> > > I don't think it's that - syzbot's .config already has that enabled.
> > > KASAN, too.
> > > 
> > > And the only place we do call_rcu() is from rcu_pending.c, where we've
> > > got a rearming rcu callback - but we track whether it's outstanding, and
> > > we do all relevant operations with a lock held.
> > > 
> > > And we only use rcu_pending.c with SRCU, not regular RCU.
> > > 
> > > We do use kfree_rcu() in a few places (all boring, I expect), but that
> > > doesn't (generally?) use the rcu callback list.
> > >
> > Right, kvfree_rcu() does not intersect with regular callbacks, it has
> > its own path. 
> > 
> > It looks like the problem is here:
> > 
> > <snip>
> >   f = rhp->func;
> >   debug_rcu_head_callback(rhp);
> >   WRITE_ONCE(rhp->func, (rcu_callback_t)0L);
> >   f(rhp);
> > <snip>
> > 
> > we do not check if callback, "f", is a NULL. If it is, the kernel bug
> > is triggered right away. For example:
> > 
> > call_rcu(&rh, NULL);
> > 
> > @Paul, do you think it makes sense to narrow callers which apparently
> > pass NULL as a callback? To me it seems the case of this bug. But we
> > do not know the source.
> > 
> > It would give at least a stack-trace of caller which passes a NULL.
> 
> Adding a check for NULL func passed to __call_rcu_common(), you mean?
> 
Yes. Currently there is no any check. So passing a NULL just triggers
kernel panic.

>
> That wouldn't hurt, and would either (as you say) catch the culprit
> or show that the problem is elsewhere.
> 
I can add it then and send out the patch if no objections.

--
Uladzislau Rezki
