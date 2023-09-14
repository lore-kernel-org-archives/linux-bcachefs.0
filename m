Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64E7EEAA6B
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 19:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbjINTud (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 15:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbjINTud (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 15:50:33 -0400
Received: from out-219.mta0.migadu.com (out-219.mta0.migadu.com [IPv6:2001:41d0:1004:224b::db])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84CB26B7
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 12:50:28 -0700 (PDT)
Date:   Thu, 14 Sep 2023 15:50:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694721027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AD74dBZMPN5nTOQPZv7AwjcNbf8/Vj6LO+ov4d9eSbY=;
        b=WSCrraD+4jCwReLqWOM4epCOhkZyNPrLDG3x+QUsdFCHXkEK0Pr4mseXLBw3Q+crry7f0J
        X+0QHjFW2YA7hFVErtSLZk2pSpL8QPYFh+vp8ZfKMwELa1imBxQG9g40JCFn3Oqnfv5uWd
        Recs+W3v/o8BVM9bkHYZ/0goH3Z7hV8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-bcachefs@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: Export kvm_guest static key, for bcachefs six
 locks
Message-ID: <20230914195025.cawo5wqzcmsbrxgj@moria.home.lan>
References: <20230914000115.1035594-1-kent.overstreet@linux.dev>
 <87a5tp8p76.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5tp8p76.fsf@mail.lhotse>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 14, 2023 at 12:26:53PM +1000, Michael Ellerman wrote:
> Kent Overstreet <kent.overstreet@linux.dev> writes:
> > bcachefs's six locks need kvm_guest, via
> >  ower_on_cpu() ->  vcpu_is_preempted() -> is_kvm_guest()
> >
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > Cc: linuxppc-dev@lists.ozlabs.org
> > ---
> >  arch/powerpc/kernel/firmware.c | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> 
> I'm happy for you to take this via your tree.

Thanks!
