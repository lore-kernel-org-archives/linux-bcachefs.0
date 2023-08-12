Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19383C0015E
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 21:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjHLVIg (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 17:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjHLVIg (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 17:08:36 -0400
Received: from out-91.mta0.migadu.com (out-91.mta0.migadu.com [91.218.175.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDD61720
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:08:38 -0700 (PDT)
Date:   Sat, 12 Aug 2023 17:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691874515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1eaM9Ujbos99cyrU1uB877mFFJPMvCQ+OsuRoTMN5V4=;
        b=FecZxpFFVUspz1h+6lEkNxYH+mFj66mNpl3thjCM4xhpqPfgbWzeAvhS2Fn62tRWDvL9+k
        VVZAJjBUeu0Te/Tgl0QRezhv7lI8LaKex1qM0vYQDagvS7K0jGwCgieg3Xx++1AX8rUd0g
        JJBrlGpPBPd0pSWa5faVmeMzH1XwCl0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] bcachefs: six locks: Fix missing barrier on
 wait->lock_acquired
Message-ID: <20230812210830.qomi2jacnkc6ogfo@moria.home.lan>
References: <20230812192720.2703874-1-kent.overstreet@linux.dev>
 <ZNfkaqfGwM8fIG7q@boqun-archlinux>
 <ZNfykqAGhT6RT8BH@boqun-archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNfykqAGhT6RT8BH@boqun-archlinux>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Aug 12, 2023 at 01:58:58PM -0700, Boqun Feng wrote:
> Given the whole percpu counters for readers thing is similar to
> percpu_rw_semaphore, I took a look at percpu_rwsem and wonder there is
> a path to combine that with SIX lock. And that makes me realize another
> fix may be needed here, considering the following case:
> 
> 	Task A					Task B
> 	======					======
> 	__six_lock_wakeup():
> 	  task = w->task;
> 	  ...
> 	  smp_store_release(&w->locked_acquire, true);
> 	  					six_lock_slowpath():
> 						  while (1) {
> 						    if (smp_load_acquire(->lock_acquired))
> 						      break;
> 						  }
> 
> 						six_unlock();
> 						do_exit(); // Task B ends its life :(
> 
> 	  wake_up_process(task); // @task is a dangling task pointer!!!
> 
> Looks like get_task_struct() and put_task_struct() are needed here:
> similar to percpu_rwsem_wake_function().

yeah, looks like you're right. Shame about adding more atomics here,
maybe we can convert task->ref to a percpu refcount at some point.
