Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF190CE79A8
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Sep 2023 21:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbjISV0r (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 17:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjISV0q (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 17:26:46 -0400
Received: from out-225.mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03ADAD
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 14:26:40 -0700 (PDT)
Date:   Tue, 19 Sep 2023 17:26:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695158799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mfVGUVz/CROi4KRS1KnJ6sVBEbP4RCSUtW7cX5HZx5M=;
        b=CFQnKhzSxyHsARd4/52vVNGVxEmhMUwdjCnFekiUnLKZcFLFVv18/JkboHS+HjNZC8mSSC
        vwP6GyvOlD9l+kP82wK+s3IfTKbNQfQqX5mc9HV3ID2bXDfGEj7aVrzjn7gvUilHsQq0Q9
        tGJpjGRK1buPGZ99pB/5qBbpGxnbNhA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs-tools: fix endian problems between bit
 spinlocks and futexes
Message-ID: <20230919212636.nzfbhpcrambibab6@moria.home.lan>
References: <20230919142611.36445-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230919142611.36445-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 19, 2023 at 10:26:11AM -0400, Brian Foster wrote:
> bcachefs format on a big-endian (s390x) machine crashes down in the
> rhashtable code imported from the kernel. The reason this occurs
> lies within the rht_lock() -> bit_spin_lock() code, the latter of
> which casts bitmaps down to 32-bits to satisfy the requirements of
> the futex interface.
> 
> The specific problem here is that a 64 -> 32 bit cast doesn't refer
> to the lower 8 bytes on a big endian machine, which means setting
> bit number 0 in the 32-bit map actually corresponds to bit 32 in the
> 64-bit map. The rhashtable code specifically uses bit zero of the
> bucket pointer for exclusion and uses native bitops elsewhere (i.e.
> __rht_ptr()) to identify NULL pointers. If bit 32 of the pointer is
> set by the locking code instead of bit 0, an otherwise NULL pointer
> looks like a non-NULL value and results in a segfault.
> 
> The bit spinlock code imported by the kernel is originally intended
> to work with unsigned long. The kernel code is able to throttle the
> cpu directly when under lock contention, while the userspace
> implementation relies on the futex primitives to emulate reliable
> blocking. Since the futex interface introduces the 32-bit
> requirement, isolate the associated userspace hack to that
> particular code.
> 
> Restore the native bitmap behavior of the bit spinlock code to
> address the rhashtable problem described above. Since this is not
> compatible with the futex interface, create a futex wrapper
> specifically to convert the native bitmap type to a 32-bit virtual
> address and mask value for the purposes of waiting/waking when under
> lock contention.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Good find :)

Thanks, applied
