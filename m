Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B347D1A0BE3
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Dec 2024 12:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733834420; cv=none; b=cGSktu4Ocs67lr+q/yBQvcslHVtNky9jKDTFw/zA5QFgEc6D/KyzM5niplyT6H9HOGqUcfLnZLlxI+yzURg0eMStUqVCnUhe2LDU0adfvp9Ps/PWHPbUJZdVoBn5zFyLoKRQhUMkaYQhT4kWnXh5PwQE3jXY0yVc/juw4xhiS6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733834420; c=relaxed/simple;
	bh=aPEiK4h81moaoq8fm/waZ+gSyU1MKBjxVk9bA20FZDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTOXlpHXVeKgSAQsoTSnJTLkbCeCU+B0tCL40TNjy/n7Q0FemN+zM44ohlerOctRkUBheqGfWf3AsFv76zyCYqSmaH4kI3QtCXQ/yYUm1nLrU8du2dgE0IE930cmq3K0ULkq0D5K+1LfsOq0xcSHBO6hac2LYAUrJ7vnI0L5hCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tnMhpc6a; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tnMhpc6a"
Date: Tue, 10 Dec 2024 07:40:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733834412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZcKuJfhX/Ve5UPNSYYBlcC61G/qM8OOE7m7h/NqoP64=;
	b=tnMhpc6aviml/dMEm+3MILIlN8t8FtLRPRqyubeTu9IR05BO2GS/UrzKhjTreAYbpN9aKo
	Zg4QB9SiE9nr/lY3pthbYeF18JZAxW8TEZm5QIgxxacR59exy4RktwiF1O/TfBwceuz7GQ
	pwn59T8kkWD4LNAVEH4BA7IIzURY8vA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: arm64: stacktrace: unwind exception boundaries
Message-ID: <rxc57eg65sg4iayhj7gc7yl24w524lviedxnydl2mggqnatglq@iairj2ci7ioj>
References: <36kx57aw46vwykgckr5cm4fafhw54tjuj4cqljrdnpfwvjl7if@a7znuhpfu54o>
 <zbwbgkuvvciezpmigcp6gaahfxwm7cwhpzus7gtbfnbzsjb2n3@kfbdppbd74o4>
 <Z1bWaGCvUrwrj2fZ@J2N7QTR9R3>
 <Z1gll87-TkAqFwUz@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1gll87-TkAqFwUz@J2N7QTR9R3>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 10, 2024 at 11:27:19AM +0000, Mark Rutland wrote:
> On Mon, Dec 09, 2024 at 11:37:12AM +0000, Mark Rutland wrote:
> > Hi Kent,
> > 
> > On Thu, Dec 05, 2024 at 01:04:59PM -0500, Kent Overstreet wrote:
> > > On 6.13-rc1, I'm now seeing a ton of test failures due to this warning -
> > > what gives?
> > 
> > Sorry about this; I just sent what I *thought* was a fix for this:
> > 
> >   https://lore.kernel.org/linux-arm-kernel/20241209110351.1876804-1-mark.rutland@arm.com/
> > 
> > ... but re-reading the below I see you're actually hitting a different
> > issue.
> > 
> > > 00104 ========= TEST   generic/017
> > > 00104        run fstests generic/017 at 2024-12-05 11:47:43
> > > 00104 spectre-v4 mitigation disabled by command-line option
> > > 00106 bcachefs (vdc): starting version 1.13: inode_has_child_snapshots
> > > 00106 bcachefs (vdc): initializing new filesystem
> > > 00106 bcachefs (vdc): going read-write
> > > 00106 bcachefs (vdc): marking superblocks
> > > 00106 bcachefs (vdc): initializing freespace
> > > 00106 bcachefs (vdc): done initializing freespace
> > > 00106 bcachefs (vdc): reading snapshots table
> > > 00106 bcachefs (vdc): reading snapshots done
> > > 00106 bcachefs (vdc): done starting filesystem
> > > 00200 ------------[ cut here ]------------
> > > 00200 WARNING: CPU: 8 PID: 12571 at arch/arm64/kernel/stacktrace.c:223 arch_stack_walk+0x2c0/0x388
> > 
> > Looking at v6.13-rc1, that's the warning in
> > kunwind_next_frame_record_meta() for when the frame_record_meta::type is
> > not a valid value, which likely implies one of the following:
> > 
> > (a) The logic to identify a frame_record_meta is wrong.
> > 
> > (b) The entry logic has failed to initilialize pt_regs::stackframe::meta
> >     on an entry path somehow.
> > 
> > (c) The stack has been corrupted, and some frame record has been
> >     clobbered to look like a frame_record_meta.
> 
> Looking some more, I see that bch2_btree_transactions_read() is trying
> to unwind other tasks, and I believe what's happening here is that the
> unwindee isn't actually blocked for the duration of the unwind, leading
> to the unwinder encountering junk and consequently producing the
> warning.
> 
> As a test case, it's possible to trigger similar with a few parallel
> instances of:
> 
> 	while true; do cat /proc/*/stack > /dev/null
> 
> The only thing we can do on the arm64 side is remove the WARN_ON_ONCE(),
> which'll get rid of the splat. It seems we've never been unlucky enough
> to hit a stale fgraph entry, or that would've blown up also.
> 
> Regardless of the way arm64 behaves here, the unwind performed by
> bch2_btree_transactions_read() is going to contain garbage unless the
> task is pinned in a blocked state. AFAICT the way
> btree_trans::locking_wait::task is used is here is racy, and there's no
> guarantee that the unwindee is actually blocked.

Occasionally returning garbage is completely fine, as long as the
interface is otherwise safe. This is debug info; it's important that it
be available and we can't impose additional synchronization for it.
