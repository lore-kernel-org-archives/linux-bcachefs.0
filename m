Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA01C7EE29
	for <linux-bcachefs@archiver.kernel.org>; Fri,  9 Jun 2023 20:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjFIU63 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjFIU60 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 9 Jun 2023 16:58:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8F635B0
        for <linux-bcachefs@vger.kernel.org>; Fri,  9 Jun 2023 13:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686344251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YRWAxWtLa8sVDkpC/yUUut28G8oap18QNpE8UHzdaio=;
        b=eUz90YYvJGY7ABsnyJqoSuEVSJphXqgQ3UzP05//jWc0qTy75GJzz0Xt42ZNL8HLX8AfvC
        URM1U4fUv7vQb0FM/jVHW8vFkUBAcq1l9gnx8gy/E96sxd4kKx9+5dQ571DnMF5IzoNvMP
        q5XcpwXwFJi+Ek/AbCw2RvnZc8vxybI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-7pvheUS7NMenBLh1B5L8AQ-1; Fri, 09 Jun 2023 16:57:28 -0400
X-MC-Unique: 7pvheUS7NMenBLh1B5L8AQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8BBA101B04E;
        Fri,  9 Jun 2023 20:57:27 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1AF7492B0B;
        Fri,  9 Jun 2023 20:57:27 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
        id ACFC030C0502; Fri,  9 Jun 2023 20:57:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id A9E133F7CF;
        Fri,  9 Jun 2023 22:57:27 +0200 (CEST)
Date:   Fri, 9 Jun 2023 22:57:27 +0200 (CEST)
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
cc:     linux-bcachefs@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: fuzzing bcachefs with dm-flakey
In-Reply-To: <ZHaGvAvFB3wWPY17@moria.home.lan>
Message-ID: <e0ad5e2c-48d0-0fe-a2d3-afcfa5f51d1e@redhat.com>
References: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com> <ZHUcmeYrUmtytdDU@moria.home.lan> <alpine.LRH.2.21.2305300809350.13307@file01.intranet.prod.int.rdu2.redhat.com> <ZHaGvAvFB3wWPY17@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On Tue, 30 May 2023, Kent Overstreet wrote:

> On Tue, May 30, 2023 at 05:00:39PM -0400, Mikulas Patocka wrote:
> > I'd like to know how do you want to do coverage analysis? By instrumenting 
> > each branch and creating a test case that tests that the branch goes both 
> > ways?
> 
> Documentation/dev-tools/gcov.rst. The compiler instruments each branch
> and then the results are available in debugfs, then the lcov tool
> produces annotated source code as html output.
> 
> > I know that people who write spacecraft-grade software do such tests, but 
> > I can't quite imagine how would that work in a filesystem.
> > 
> > "grep -w if fs/bcachefs/*.[ch] | wc -l" shows that there are 5828 
> > conditions. That's one condition for every 15.5 lines.
> 
> Most of which are covered by existing tests - but by running the
> existing tests with code coverage analylis we can see which branches the
> tests aren't hitting, and then we add fault injection points for those.
> 
> With fault injection we can improve test coverage a lot without needing
> to write any new tests (or simple ones, for e.g. init/mount errors) 

I compiled the kernel with gcov, I ran "xfstests-dev" on bcachefs and gcov 
shows that there is 56% coverage on "fs/bcachefs/*.o".

So, we have 2564 "if" branches (of total 5828) that were not tested. What 
are you going to do about them? Will you create a filesystem image for 
each branch that triggers it? Or, will you add 2564 fault-injection points 
to the source code?

It seems like extreme amount of work.

Mikulas

