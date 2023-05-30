Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E4CC7EE23
	for <linux-bcachefs@archiver.kernel.org>; Tue, 30 May 2023 23:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbjE3X3K (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 30 May 2023 19:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjE3X3J (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 30 May 2023 19:29:09 -0400
Received: from out-16.mta0.migadu.com (out-16.mta0.migadu.com [IPv6:2001:41d0:1004:224b::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3DCEC
        for <linux-bcachefs@vger.kernel.org>; Tue, 30 May 2023 16:29:07 -0700 (PDT)
Date:   Tue, 30 May 2023 19:29:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685489345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k2Y6uTug4R4ft1vRqhDpkURpq1KMyuLKH+ZJv9XQeqE=;
        b=Fyvy/KtY3G333rnLx0LhSyFsdIu6zcpMbvpMmf2GPI5h98SCfVz1WH4+pc3s2/d+rZJytq
        SlYpFI3qMHt4DGDMZ4GW8vPLb7Rd2EkAczOG8E0cFf96OWZFxrXBtM9izgbd70p0DS5S8z
        Ed5dbXONtnCfcAkX6d1eSo0rweLgQ04=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: fuzzing bcachefs with dm-flakey
Message-ID: <ZHaGvAvFB3wWPY17@moria.home.lan>
References: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
 <ZHUcmeYrUmtytdDU@moria.home.lan>
 <alpine.LRH.2.21.2305300809350.13307@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2305300809350.13307@file01.intranet.prod.int.rdu2.redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 30, 2023 at 05:00:39PM -0400, Mikulas Patocka wrote:
> I'd like to know how do you want to do coverage analysis? By instrumenting 
> each branch and creating a test case that tests that the branch goes both 
> ways?

Documentation/dev-tools/gcov.rst. The compiler instruments each branch
and then the results are available in debugfs, then the lcov tool
produces annotated source code as html output.

> I know that people who write spacecraft-grade software do such tests, but 
> I can't quite imagine how would that work in a filesystem.
> 
> "grep -w if fs/bcachefs/*.[ch] | wc -l" shows that there are 5828 
> conditions. That's one condition for every 15.5 lines.

Most of which are covered by existing tests - but by running the
existing tests with code coverage analylis we can see which branches the
tests aren't hitting, and then we add fault injection points for those.

With fault injection we can improve test coverage a lot without needing
to write any new tests (or simple ones, for e.g. init/mount errors) 
