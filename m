Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBC2CDB465
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 18:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346538AbjJSSi0 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 19 Oct 2023 14:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346542AbjJSSiW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 19 Oct 2023 14:38:22 -0400
Received: from out-196.mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B991124
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 11:38:09 -0700 (PDT)
Date:   Thu, 19 Oct 2023 14:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697740687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3UZ6Os9aNh/k1ImYJ08SB8j0cuHam6YLM/xBWvPzRAU=;
        b=VlL0tvFitZMm1f/lG35hPr4s+4s8/dMPvGx50Fb5vEy+O1VcOA/MCKzxpTuUa7/z3jiikx
        knPVe2ShfM85RHly/hpQLBUXUmg2gx9Jif79b+8OKqnJdfY+w9Rt88E4qOmzHPaxd8LMvH
        QiqW8Lpqfh/FIuX8vSKcrFXttRyXcpY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: update alloc cursor in early bucket allocator
Message-ID: <20231019183803.njsjs4sz7p4zpyfc@moria.home.lan>
References: <20231019132746.279256-1-bfoster@redhat.com>
 <20231019153019.jl73n6ipif7zwc5b@moria.home.lan>
 <ZTFl3jJJi2CoDdJB@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTFl3jJJi2CoDdJB@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Oct 19, 2023 at 01:22:38PM -0400, Brian Foster wrote:
> BTW, should this code be protected from no free space situations at a
> higher level, or should we consider a max retry count or something? I
> want to be cautious about things like prospective livelocks
> (particularly if this path is less common) if this retry was effectively
> dead code due to not updating alloc_cursor.

It should be limiting itself to a single retry already: on retry, we set
alloc_cursor = alloc_start, so we won't retry again. Just make sure that
still works :)
