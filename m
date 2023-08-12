Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EDAC001B0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 21:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjHLVxE (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 17:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjHLVxE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 17:53:04 -0400
Received: from out-76.mta1.migadu.com (out-76.mta1.migadu.com [95.215.58.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB4418E
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:53:06 -0700 (PDT)
Date:   Sat, 12 Aug 2023 17:53:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691877183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vxYwu9uE2o97W8qYgh9JULZKpKmHUaNrlF+HzXSKIIM=;
        b=MWVZXNjrt++Q+qcHXMoMh4L90m+cd7roZc4sCeeC+uGXPHJBHvLAXVEFaVsDZNLwjY9rAe
        GEYBBzU3UK1np3JoQ+3W2ogQCcJQj3YeBxszZskcmz/BF7vuer686MpqBVKpc21zle3pXJ
        8KRjyrcD7BRGnYf9tjV5JsN98xlhSxI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [v2 2/3] bcachefs: Optimize bch2_dirent_name_bytes
Message-ID: <20230812215301.q5btp5a42um5mdtl@moria.home.lan>
References: <20230812212647.490829-1-joshua@froggi.es>
 <20230812212647.490829-3-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230812212647.490829-3-joshua@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Aug 12, 2023 at 10:26:30PM +0100, Joshua Ashton wrote:
> Avoids doing a full strnlen for getting the length of the name of a
> dirent entry.
> 
> Given the fact that the name of dirents is stored at the end of the
> bkey's value, and we know the length of that in u64s, we can find the
> last u64 and figure out how many NUL bytes are at the end of the string.
> 
> On little endian systems this ends up being the leading zeros of the
> last u64, whereas on big endian systems this ends up being the trailing
> zeros of the last u64.
> We can take that value in bits and divide it by 8 to get the number of
> NUL bytes at the end.
> 
> There is no endian-fixup or other compatibility here as this is string
> data interpreted as a u64.
> 
> Signed-off-by: Joshua Ashton <joshua@froggi.es>

Applied
