Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BE523DE95;
	Tue, 10 Dec 2024 11:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733830051; cv=none; b=EYrjZICt2kNl9ymcKYnAQDj4gLnp26TwAT60FIrXmNu4YHs2tTTk6Up+aic2znZZbFdZbI7PRxM9pbWolSi3ZpRG1yPa2mZIhtA9Q+FQQDfgcfzBNwXFir0p6BVeJuAIdFjRM4QaByjQ/gG1QtCqqjBBZAtsiHb9TyuooU53o9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733830051; c=relaxed/simple;
	bh=9G0siJyNxPJJfTZWz18ibOXVTW/s4Amh7tT5c9+w8fE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bU48TKKYMOERosQim8Je2gK0XzxwJj/3hPi4/+2UCLVJPp4h8rIRB59FhfajGmHVNAw7DqtQWVQ+YFyAlB961joPX1VmWjiQX9r3IN9oFbpAkmNXg5nnbkTwS3sGuOpM9L2jE4lwUCAYy1ubmOdlr7jSZ+WoChGhnZuUUxJsSyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1667113E;
	Tue, 10 Dec 2024 03:27:55 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFC0F3F5A1;
	Tue, 10 Dec 2024 03:27:26 -0800 (PST)
Date: Tue, 10 Dec 2024 11:27:19 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: arm64: stacktrace: unwind exception boundaries
Message-ID: <Z1gll87-TkAqFwUz@J2N7QTR9R3>
References: <36kx57aw46vwykgckr5cm4fafhw54tjuj4cqljrdnpfwvjl7if@a7znuhpfu54o>
 <zbwbgkuvvciezpmigcp6gaahfxwm7cwhpzus7gtbfnbzsjb2n3@kfbdppbd74o4>
 <Z1bWaGCvUrwrj2fZ@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1bWaGCvUrwrj2fZ@J2N7QTR9R3>

On Mon, Dec 09, 2024 at 11:37:12AM +0000, Mark Rutland wrote:
> Hi Kent,
> 
> On Thu, Dec 05, 2024 at 01:04:59PM -0500, Kent Overstreet wrote:
> > On 6.13-rc1, I'm now seeing a ton of test failures due to this warning -
> > what gives?
> 
> Sorry about this; I just sent what I *thought* was a fix for this:
> 
>   https://lore.kernel.org/linux-arm-kernel/20241209110351.1876804-1-mark.rutland@arm.com/
> 
> ... but re-reading the below I see you're actually hitting a different
> issue.
> 
> > 00104 ========= TEST   generic/017
> > 00104        run fstests generic/017 at 2024-12-05 11:47:43
> > 00104 spectre-v4 mitigation disabled by command-line option
> > 00106 bcachefs (vdc): starting version 1.13: inode_has_child_snapshots
> > 00106 bcachefs (vdc): initializing new filesystem
> > 00106 bcachefs (vdc): going read-write
> > 00106 bcachefs (vdc): marking superblocks
> > 00106 bcachefs (vdc): initializing freespace
> > 00106 bcachefs (vdc): done initializing freespace
> > 00106 bcachefs (vdc): reading snapshots table
> > 00106 bcachefs (vdc): reading snapshots done
> > 00106 bcachefs (vdc): done starting filesystem
> > 00200 ------------[ cut here ]------------
> > 00200 WARNING: CPU: 8 PID: 12571 at arch/arm64/kernel/stacktrace.c:223 arch_stack_walk+0x2c0/0x388
> 
> Looking at v6.13-rc1, that's the warning in
> kunwind_next_frame_record_meta() for when the frame_record_meta::type is
> not a valid value, which likely implies one of the following:
> 
> (a) The logic to identify a frame_record_meta is wrong.
> 
> (b) The entry logic has failed to initilialize pt_regs::stackframe::meta
>     on an entry path somehow.
> 
> (c) The stack has been corrupted, and some frame record has been
>     clobbered to look like a frame_record_meta.

Looking some more, I see that bch2_btree_transactions_read() is trying
to unwind other tasks, and I believe what's happening here is that the
unwindee isn't actually blocked for the duration of the unwind, leading
to the unwinder encountering junk and consequently producing the
warning.

As a test case, it's possible to trigger similar with a few parallel
instances of:

	while true; do cat /proc/*/stack > /dev/null

The only thing we can do on the arm64 side is remove the WARN_ON_ONCE(),
which'll get rid of the splat. It seems we've never been unlucky enough
to hit a stale fgraph entry, or that would've blown up also.

Regardless of the way arm64 behaves here, the unwind performed by
bch2_btree_transactions_read() is going to contain garbage unless the
task is pinned in a blocked state. AFAICT the way
btree_trans::locking_wait::task is used is here is racy, and there's no
guarantee that the unwindee is actually blocked.

Mark.
