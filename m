Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF27E7E644
	for <linux-bcachefs@archiver.kernel.org>; Tue, 26 Sep 2023 16:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbjIZQNs (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 26 Sep 2023 12:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjIZQNr (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 26 Sep 2023 12:13:47 -0400
Received: from out-194.mta1.migadu.com (out-194.mta1.migadu.com [IPv6:2001:41d0:203:375::c2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F84A11F
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Sep 2023 09:13:40 -0700 (PDT)
Date:   Tue, 26 Sep 2023 12:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695744816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nLhP71PCJ3FOTBKxbEWsoFNPDYs/wyKvtCPWc8eVZug=;
        b=wIfWbEOxBctVXn7ALVxyju+saBE8niAde5vl4cNUL8NMKWvqVJqeTSZ+XvetT894+BgPX5
        DkAt3n+sMw9Rk6JB4pCuT1R11BjV6j9zQxpUvE7Ml11SWrIyXmZcivR/akBkg58f3h5V87
        aKQuclMtU/Lin6Uwq9azDD1RCtNj5Gk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: sleeping in atomic
Message-ID: <20230926161333.kkkbyx2jotssbqvm@moria.home.lan>
References: <cf328a38-b2a6-4cae-8ec0-fb17551623c0@moroto.mountain>
 <20230919205659.v7ofsxjm2h7gkcgw@moria.home.lan>
 <128ed1f9-fda3-48b0-b46d-e2a13982a880@kadam.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <128ed1f9-fda3-48b0-b46d-e2a13982a880@kadam.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 26, 2023 at 05:41:37PM +0300, Dan Carpenter wrote:
> On Tue, Sep 19, 2023 at 04:56:59PM -0400, Kent Overstreet wrote:
> > On Fri, Sep 15, 2023 at 03:57:34PM +0300, Dan Carpenter wrote:
> > > Hello Kent Overstreet,
> > > 
> > > The patch 93a640e2570b: "bcachefs: GFP_NOIO -> GFP_NOFS" from May 28,
> > > 2023 (linux-next), leads to the following Smatch static checker
> > > warning:
> > 
> > So the smatch warnings are pretty hard for me to deal with - it appears
> > you're testing each individual commit, which is what _I_ normally like
> > to do, except in this case there's no way I'm applying all the fixes to
> > individual commits in a 3k commit branch.
> > 
> > And, dealing with the back-and-forth of going through emails is also a
> > bit much, I'm going to need to get smatch integrated into my CI.
> > 
> > But...
> > 
> > smatch doesn't build on debian.
> > 
> > Can we get that fixed?
> 
> It should.  I'm using it on Debian.  This should be a complete list of
> the required packages.  Let me know if that's not complete.
> 
> apt-get install gcc make sqlite3 libsqlite3-dev libdbd-sqlite3-perl libssl-dev libtry-tiny-perl

What of the llvm dependency? I could only get it to build when I
disabled that, is that dependency important?

It also consistently segfaults on the bcachefs code.
