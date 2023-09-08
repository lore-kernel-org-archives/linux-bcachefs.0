Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA285EE57E0
	for <linux-bcachefs@archiver.kernel.org>; Fri,  8 Sep 2023 08:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjIHIGl (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 8 Sep 2023 04:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjIHIGk (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 8 Sep 2023 04:06:40 -0400
Received: from out-225.mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F8B19B0
        for <linux-bcachefs@vger.kernel.org>; Fri,  8 Sep 2023 01:06:36 -0700 (PDT)
Date:   Fri, 8 Sep 2023 04:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694160394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fQpAaXuRUlyI0q/mJ4d9glR7H0xCewQSHcFhTliiVis=;
        b=jnkZdQmWigtnb0ZGqR1JBKde9VRLCILsYnMZi8HEAjCl3U7K9eDERlbNkuYNNOxjGmXC7G
        iCLaaHBXJevMePPl1rQziNhb2sBikYMpTVCdgopnu+ivsJJkvfoPhPMoiGj+1/Eew0oJrO
        sjjAsWGTLMPjf9ZvW3M9oxe7hGX42Zg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Colin Gillespie <colin@cgillespie.xyz>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/2] revoke invalidated encryption keys
Message-ID: <20230908080630.iym7ugxukcrlr26p@moria.home.lan>
References: <20230908072751.25406-2-colin@cgillespie.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230908072751.25406-2-colin@cgillespie.xyz>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 08, 2023 at 05:27:50PM +1000, Colin Gillespie wrote:
> I found that mounting a filesystem after changing its passphrase with
> bcachefs set-passphrase would hang indefinitely. It appears the old key
> is being used, but the mount process can't tell that it's invalid.
> 
> Instead of relying on the user to call bcachefs unlock, this patch
> revokes the invalid key, causing further operations to fail.
> 
> Colin Gillespie (2):
>   cmd_set_passphrase: revoke the invalidated key
>   cmd_mount: request passphrase if the existing key is revoked
> 
>  cmd_key.c              |  1 +
>  libbcachefs/checksum.c | 18 ++++++++++++++++++
>  libbcachefs/checksum.h |  1 +
>  rust-src/src/key.rs    |  7 ++++---
>  4 files changed, 24 insertions(+), 3 deletions(-)

Thanks! Applied
