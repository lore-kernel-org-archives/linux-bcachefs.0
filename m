Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CE0CE79A8
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Sep 2023 20:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbjISU5J (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjISU5J (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 16:57:09 -0400
Received: from out-210.mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D85BD
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 13:57:03 -0700 (PDT)
Date:   Tue, 19 Sep 2023 16:56:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695157022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dTpO4tlHIuGsiuUWm9ky6Gr4+CoAEp7SbHQ3sHZZidM=;
        b=wVl/aP7ab35cUBMAP3opepIvr+Ayn5II/0IFvc/NJt5XLMPoyg3o6U1z/H2Ind3LSduvTM
        NGQ8I1CoGf6g5O88R9bGP9k/AYE6dNwadITpt8k7/oUJ6EzX/2Cw0K16bLPW06RLrwqEm4
        n29iPQ4+itPoOAmcadUyGHA0LfrmqJQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: sleeping in atomic
Message-ID: <20230919205659.v7ofsxjm2h7gkcgw@moria.home.lan>
References: <cf328a38-b2a6-4cae-8ec0-fb17551623c0@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf328a38-b2a6-4cae-8ec0-fb17551623c0@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 03:57:34PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch 93a640e2570b: "bcachefs: GFP_NOIO -> GFP_NOFS" from May 28,
> 2023 (linux-next), leads to the following Smatch static checker
> warning:

So the smatch warnings are pretty hard for me to deal with - it appears
you're testing each individual commit, which is what _I_ normally like
to do, except in this case there's no way I'm applying all the fixes to
individual commits in a 3k commit branch.

And, dealing with the back-and-forth of going through emails is also a
bit much, I'm going to need to get smatch integrated into my CI.

But...

smatch doesn't build on debian.

Can we get that fixed?
