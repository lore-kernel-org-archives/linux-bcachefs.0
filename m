Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2C9EB64DD
	for <linux-bcachefs@archiver.kernel.org>; Tue, 25 Jul 2023 03:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjGYDhk (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 24 Jul 2023 23:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjGYDhJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 24 Jul 2023 23:37:09 -0400
Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339DE1BD2
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Jul 2023 20:36:48 -0700 (PDT)
Date:   Mon, 24 Jul 2023 23:36:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690256207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xh0TlrzZ5bfgK2nyAl1ZyRxGknINozAiM0/0qp2g5lU=;
        b=XyRXOTljgpwfsAoEX1A5swVob7gNllrDOgnt7gylPxjqgTkD39tA6E935dAHX0CN+ziin1
        VMoVj/Z7fswRroKFkTOIonlms9k5c4HpN1rX5GApBAobjFV/GCuYeToCMUQhHVS7dj5qJM
        8nyKCoo1uSXPoah8TJlKQAji1Vwr2OQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 19/20] lib/generic-radix-tree.c: Add a missing include
Message-ID: <20230725033644.tihlrd5xbsmklosi@moria.home.lan>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
 <20230712211115.2174650-20-kent.overstreet@linux.dev>
 <ZL87ppG5/rGdGxeB@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZL87ppG5/rGdGxeB@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Jul 25, 2023 at 04:04:06AM +0100, Matthew Wilcox wrote:
> On Wed, Jul 12, 2023 at 05:11:14PM -0400, Kent Overstreet wrote:
> > From: Kent Overstreet <kent.overstreet@gmail.com>
> > 
> > We now need linux/limits.h for SIZE_MAX.
> 
> I think this should be squashed into the previous commit

No objection...
