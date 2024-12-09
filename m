Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 298C1216E3F;
	Mon,  9 Dec 2024 11:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733744244; cv=none; b=EeLV5cBIyfxmSRFdue2F3+AJQyMd5vG3mlEjIhHMsfngP5TOyX1zOKZ9mneT2oId4XfGtJk4EPYo+y9ng2JZeyR6obhEupWOPPuCfttDDi/342ouqC+zSnT03Nl2+bTgfNcGc+9YelNnN+ajSWrgOOi82UswtqtHs7rfrGJkjP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733744244; c=relaxed/simple;
	bh=KrHWSykGjJr/BJfQge3OT8J9egtNuBFPynnPSWHx7/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eg9wdCX4pTKOdaWXcXoCzwcTV9COCwWZOnJ6ilhU8SpGHPiKLnX2WYOp+RRGaL9POj2k17VD7X/VUA4kamfU8UeEAj1i8RJu2IR0WWCsSFJOUuh0BAptTg9Izr1KdnWLVEY4BEv7jTcFzusGHif3vX9vJ7D2xUBbj3c3mP0v+os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 553171007;
	Mon,  9 Dec 2024 03:37:48 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4941A3F5A1;
	Mon,  9 Dec 2024 03:37:19 -0800 (PST)
Date: Mon, 9 Dec 2024 11:37:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: arm64: stacktrace: unwind exception boundaries
Message-ID: <Z1bWaGCvUrwrj2fZ@J2N7QTR9R3>
References: <36kx57aw46vwykgckr5cm4fafhw54tjuj4cqljrdnpfwvjl7if@a7znuhpfu54o>
 <zbwbgkuvvciezpmigcp6gaahfxwm7cwhpzus7gtbfnbzsjb2n3@kfbdppbd74o4>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zbwbgkuvvciezpmigcp6gaahfxwm7cwhpzus7gtbfnbzsjb2n3@kfbdppbd74o4>

Hi Kent,

On Thu, Dec 05, 2024 at 01:04:59PM -0500, Kent Overstreet wrote:
> On 6.13-rc1, I'm now seeing a ton of test failures due to this warning -
> what gives?

Sorry about this; I just sent what I *thought* was a fix for this:

  https://lore.kernel.org/linux-arm-kernel/20241209110351.1876804-1-mark.rutland@arm.com/

... but re-reading the below I see you're actually hitting a different
issue.

> 00104 ========= TEST   generic/017
> 00104        run fstests generic/017 at 2024-12-05 11:47:43
> 00104 spectre-v4 mitigation disabled by command-line option
> 00106 bcachefs (vdc): starting version 1.13: inode_has_child_snapshots
> 00106 bcachefs (vdc): initializing new filesystem
> 00106 bcachefs (vdc): going read-write
> 00106 bcachefs (vdc): marking superblocks
> 00106 bcachefs (vdc): initializing freespace
> 00106 bcachefs (vdc): done initializing freespace
> 00106 bcachefs (vdc): reading snapshots table
> 00106 bcachefs (vdc): reading snapshots done
> 00106 bcachefs (vdc): done starting filesystem
> 00200 ------------[ cut here ]------------
> 00200 WARNING: CPU: 8 PID: 12571 at arch/arm64/kernel/stacktrace.c:223 arch_stack_walk+0x2c0/0x388

Looking at v6.13-rc1, that's the warning in
kunwind_next_frame_record_meta() for when the frame_record_meta::type is
not a valid value, which likely implies one of the following:

(a) The logic to identify a frame_record_meta is wrong.

(b) The entry logic has failed to initilialize pt_regs::stackframe::meta
    on an entry path somehow.

(c) The stack has been corrupted, and some frame record has been
    clobbered to look like a frame_record_meta.

The unwind will terminate at this point even if the warning is
supressed, so the backtrace from the warning itself should indicate
where the frame record was:

> 00200 Modules linked in:
> 00200 CPU: 8 UID: 0 PID: 12571 Comm: cat Not tainted 6.13.0-rc1-ktest-gdf1fce23d033 #10877
> 00200 Hardware name: linux,dummy-virt (DT)
> 00200 pstate: 80001005 (Nzcv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
> 00200 pc : arch_stack_walk+0x2c0/0x388
> 00200 lr : arch_stack_walk+0x1f4/0x388
> 00200 sp : ffffff80ca757b00
> 00200 x29: ffffff80ca757b00 x28: ffffff80d6783758 x27: 000000000000036f
> 00200 x26: ffffff80d6783780 x25: ffffff80c19de180 x24: ffffff80c273ee40
> 00200 x23: ffffffc080022708 x22: ffffffc080025828 x21: ffffff80ca757be8
> 00200 x20: ffffffc0800c98c8 x19: ffffff80d8533d10 x18: ffffffffffffffff
> 00200 x17: 0000000000000000 x16: 0000000000000000 x15: ffffffffffffffff
> 00200 x14: 0000000000000000 x13: ffffff80d6c92000 x12: 0000000000000000
> 00200 x11: 0000000000000000 x10: 000000000000000a x9 : ffffffc08086beec
> 00200 x8 : ffffff80ca757bc0 x7 : 0000000000000000 x6 : ffffff80d8533d28
> 00200 x5 : ffffff80ca757b60 x4 : ffffff80d8534000 x3 : ffffff80ca757b40
> 00200 x2 : 0000000000000018 x1 : ffffff80d8533d10 x0 : 0000000000000000
> 00200 Call trace:
> 00200  arch_stack_walk+0x2c0/0x388 (P)
> 00200  arch_stack_walk+0x1f4/0x388 (L)
> 00200  stack_trace_save_tsk+0x90/0xd8
> 00200  bch2_save_backtrace+0x68/0x160
> 00200  bch2_prt_task_backtrace+0x30/0xb8
> 00200  bch2_btree_transactions_read+0xe0/0x1f0
> 00200  full_proxy_read+0x60/0xd0
> 00200  vfs_read+0x80/0x2d8
> 00200  ksys_read+0x5c/0xf0
> 00200  __arm64_sys_read+0x20/0x30
> 00200  invoke_syscall.constprop.0+0x54/0xe8
> 00200  do_el0_svc+0x44/0xc8
> 00200  el0_svc+0x18/0x58
> 00200  el0t_64_sync_handler+0x104/0x130
> 00200  el0t_64_sync+0x154/0x158

This suggests that the bad frame_record_meta is in the entry code, in
the pt_regs. There *should* be a frame_record_meta there with type
FRAME_META_TYPE_FINAL, which suggests the probkem isn't case (a) above,
and either the entry code is failing to initialise
pt_regs::stackframe::type somehow, or that is getting corrupted later.

AFAICT, the entry code correctly initializes the frame_record_meta in
the kernel_entry assembly macro:

        /*
         * Create a metadata frame record. The unwinder will use this to
         * identify and unwind exception boundaries.
         */
        stp     xzr, xzr, [sp, #S_STACKFRAME]
        .if \el == 0
        mov     x0, #FRAME_META_TYPE_FINAL
        .else
        mov     x0, #FRAME_META_TYPE_PT_REGS
        .endif
        str     x0, [sp, #S_STACKFRAME_TYPE]
        add     x29, sp, #S_STACKFRAME

... and that's shared by *all* exceptions, so if it were wrong I'd
expect it to trigger an explosion on the very first backtrace taken
under an exception (from userspace or kernel).

Given the above, I'd suspect that maybe you're encountering stack
corruption here.

How are you reproducing this, and how consistently do you see the
failure? Is it always triggered by the same test?

The below diff will log the bad frame_record_meta::type value; if you're
able to run with that it might give an indication as to what's going on.

Mark.

---->8----
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index caef85462acb6..d1d9436c49101 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -205,13 +205,15 @@ kunwind_next_frame_record_meta(struct kunwind_state *state)
        unsigned long fp = state->common.fp;
        struct frame_record_meta *meta;
        struct stack_info *info;
+       u64 type;
 
        info = unwind_find_stack(&state->common, fp, sizeof(*meta));
        if (!info)
                return -EINVAL;
 
        meta = (struct frame_record_meta *)fp;
-       switch (READ_ONCE(meta->type)) {
+       type = READ_ONCE(meta->type);
+       switch (type) {
        case FRAME_META_TYPE_FINAL:
                if (meta == &task_pt_regs(tsk)->stackframe)
                        return -ENOENT;
@@ -220,7 +222,7 @@ kunwind_next_frame_record_meta(struct kunwind_state *state)
        case FRAME_META_TYPE_PT_REGS:
                return kunwind_next_regs_pc(state);
        default:
-               WARN_ON_ONCE(1);
+               WARN_ONCE(1, "Bad frame_record_meta::type: 0x%016llx\n", type);
                return -EINVAL;
        }
 }
 
