Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F347EC77B75
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 19:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbjEITa5 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 15:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjEITaz (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 15:30:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77582E52;
        Tue,  9 May 2023 12:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=81U+OLWJnYZ6VJEmSLsNheFHx8FU2WbVb94P7PW+Gls=; b=UPKn+10qq/Rvvn2XYPYVuy1pV+
        QdbIifmXF0AdccZNcz06BVFkL6lW+8iqR7498eWBcpU44ZvOkHUMTiVe3Tk6qs6NlacW+lmClQ6mi
        23r1+Tcb8NFSI0KJ9av+eKdFebp3OZ0crJN1zAjf1oj2JkN5ToiD9OhS7GpqebpWha8qaLwr4ik5v
        km1z8PSlky38Iup2WqJvKCzE1Br2z51Pt689I3Xww2+tRqud6ZdUTwGMj2cl9BAmQKVK62CajP4ST
        MEVtOa563p0S0aiROb4quhYNgmSndmNMZ9c5/Ae+BOM5yuxkQe/TUVVLKLCTuyxUcDySWUu0PBdvF
        j6yXvUsg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pwT2m-00FXwe-J3; Tue, 09 May 2023 19:30:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 981B4300786;
        Tue,  9 May 2023 21:30:39 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 78A7021F9F5C2; Tue,  9 May 2023 21:30:39 +0200 (CEST)
Date:   Tue, 9 May 2023 21:30:39 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 02/32] locking/lockdep: lock_class_is_held()
Message-ID: <20230509193039.GB2148518@hirez.programming.kicks-ass.net>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-3-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509165657.1735798-3-kent.overstreet@linux.dev>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 09, 2023 at 12:56:27PM -0400, Kent Overstreet wrote:
> From: Kent Overstreet <kent.overstreet@gmail.com>
> 
> This patch adds lock_class_is_held(), which can be used to assert that a
> particular type of lock is not held.

How is lock_is_held_type() not sufficient? Which is what's used to
implement lockdep_assert_held*().

