Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0734CC0015E
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 16:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjHLQRv (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 12:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjHLQRu (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 12:17:50 -0400
Received: from out-68.mta1.migadu.com (out-68.mta1.migadu.com [95.215.58.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5918910DE
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 09:17:53 -0700 (PDT)
Date:   Sat, 12 Aug 2023 12:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691857071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+iT3BEB/hKCOuDB+0M0F9PfOCKSBlQrkOfo9VB5SDYY=;
        b=s2+n4+4lfFJI1JEv1QAj7Z5Ol71PnKsLLXNidpg9x8UyDuYxVU/uC40f0HWv/hIgT0rcMz
        IUuRdrWIMZhPaCcHgl100bJjMRFgtPGxpXoyj4CVkCvidWQYSDhMs/XWjbf51dbigAajuj
        78qYJ2q+lVjrqIgO88wYe6lmqrlrXq0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/4] bcachefs: Add btree_trans* to inode_set_fn
Message-ID: <20230812161744.xgubcxgsti7xsbbm@moria.home.lan>
References: <20230812145017.259609-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230812145017.259609-1-joshua@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Aug 12, 2023 at 03:47:45PM +0100, Joshua Ashton wrote:
> This will be used when we need to re-hash a directory tree when setting
> flags.
> 
> It is not possible to have concurrent btree_trans on a thread.
> 
> Signed-off-by: Joshua Ashton <joshua@froggi.es>

Applied
