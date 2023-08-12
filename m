Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EB7C001E0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 16:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjHLQXc (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 12:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjHLQXb (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 12:23:31 -0400
Received: from out-126.mta1.migadu.com (out-126.mta1.migadu.com [95.215.58.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9681BEC
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 09:23:34 -0700 (PDT)
Date:   Sat, 12 Aug 2023 12:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691857413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bL7HdQ1G7zuOUcZ2vWo5+BCM9uiBnRQCH5O6tSI0eMk=;
        b=ZKCwvFRSxGQ0rDVb/watbd3Ssb4CCDZi0v9JplGtm9GkDou2PZcx9PLd6o8GfRqCXeUEjN
        MbrNjNNeEUPnkvcd6qmtoU6sjqXgQCaRLV+VGbTMjIp1OKOQC+eNhXjKGwN0SVxVKMcEWi
        R5m6iE1YGvVXoiabxDykrh/fdoyrMmA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/4] bcachefs: Optimize bch2_dirent_name_bytes
Message-ID: <20230812162330.6i6jybtasalh3asw@moria.home.lan>
References: <20230812145017.259609-1-joshua@froggi.es>
 <20230812145017.259609-2-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230812145017.259609-2-joshua@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Aug 12, 2023 at 03:47:46PM +0100, Joshua Ashton wrote:
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

This needs a bit more analysis:

If we ever screwed up and created dirents where there was a nul before
the last u64, this is going to change how those dirents are interpreted
- we'll now be returning longer dirents, but with an embedded nul.

Fortunately, bch2_dirent_invalid() checks for this, so we're good there.

But, your change does break the check in bch2_dirent_invalid(); we still
do need to check somehow that there aren't any embedded nuls. Can you
fix that too?
