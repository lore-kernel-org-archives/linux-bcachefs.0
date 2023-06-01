Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A795EC77B7E
	for <linux-bcachefs@archiver.kernel.org>; Thu,  1 Jun 2023 17:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjFARx7 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 1 Jun 2023 13:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjFARx6 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 1 Jun 2023 13:53:58 -0400
Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829FE18C
        for <linux-bcachefs@vger.kernel.org>; Thu,  1 Jun 2023 10:53:57 -0700 (PDT)
Date:   Thu, 1 Jun 2023 13:53:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685642035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J3DmRiG+N/ipm5aqjmc6HICQWlnAntrnwWB/Z2c5TEM=;
        b=vIaIChrwYlze5FGCkN8xsuj5dPwi6DuUqA3/adW7De0PnI72UwAQeKxV8Gre5UDQei+G7B
        icFz4be3ivPiXAjjuWz0kx39AtbJlCpXE7G14XKQXj/IIfhrYJJxIM8W/kzsMHyB3Mm41h
        ++I3vqfAh9dIEbzVlxLmjE+DjR7uPVE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix NULL pointer dereference in
 try_alloc_bucket
Message-ID: <ZHjbL1o1KZt1385/@moria.home.lan>
References: <alpine.LRH.2.21.2305300803220.12797@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2305300803220.12797@file01.intranet.prod.int.rdu2.redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 30, 2023 at 08:15:41AM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 29 May 2023, Mikulas Patocka wrote:
> 
> > The oops happens in set_btree_iter_dontneed and it is caused by the fact 
> > that iter->path is NULL. The code in try_alloc_bucket is buggy because it 
> > sets "struct btree_iter iter = { NULL };" and then jumps to the "err" 
> > label that tries to dereference values in "iter".
> 
> Here I'm sending a patch for it.
> 
> 
> 
> +		set_btree_iter_dontneed(&iter);
>  	bch2_trans_iter_exit(trans, &iter);

I need to look at this code a bit more, perhaps we'll want to move the
check into set_btree_iter_dontneed(), since iter_exit() is safe to call
on an uninitialized-but-zeroed iterator
