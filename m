Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AC8EEAA6A
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 19:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjINT5A (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 15:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjINT47 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 15:56:59 -0400
Received: from out-222.mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6EB26BC
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 12:56:55 -0700 (PDT)
Date:   Thu, 14 Sep 2023 15:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694721413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QITDjsMnjKIvtkYa/t78kY9pn1slW4IpkgX70YPc/xw=;
        b=Fn7J/6R3rely2M82bxr9+f8eJIzcnjJqMXkBwyMsxdlcOsDwOh6z+y1R3SC9MzzUV/1oEa
        o5sNi+F8vfnnMM2Mfnf0iY9Bh7hlZ91VomLRyAjB1I5mJ/GWk1yHb4LA8IylAHhS8LubVZ
        V/3CUg/wTGt1e0XC5G4809ZwOMBaWIo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3] bcachefs: chardev: fix an integer overflow (32 bit
 only)
Message-ID: <20230914195650.gur5rhf4qihyi7mz@moria.home.lan>
References: <6f3b0d3e-d20e-47fc-a3e5-4ad4c03d58b8@moroto.mountain>
 <9ab0a914-3170-4728-92b2-09eebb0dbdbb@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ab0a914-3170-4728-92b2-09eebb0dbdbb@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 14, 2023 at 05:59:10PM +0300, Dan Carpenter wrote:
> On 32 bit systems, "sizeof(*arg) + replica_entries_bytes" can have an
> integer overflow leading to memory corruption.  Use size_add() to
> prevent this.

Thanks, applied
