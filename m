Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD98ECAAA3
	for <linux-bcachefs@archiver.kernel.org>; Fri, 26 Aug 2022 15:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344548AbiHZPUS (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 26 Aug 2022 11:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344590AbiHZPT6 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 26 Aug 2022 11:19:58 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E4AE3960
        for <linux-bcachefs@vger.kernel.org>; Fri, 26 Aug 2022 08:13:48 -0700 (PDT)
Date:   Fri, 26 Aug 2022 11:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661526826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3PXMjE+u2jjFb3Dsin/71lEgNpSgpdRIFAQQu1hfUjg=;
        b=GG0Lvx4Uq6PvwCYQBxxWkNiwqdmNp4UE/a6uFUMhgY6xXbSse9fpLW4CIPdhvsEDaMxQ+T
        6WyrB7Ql8Li9jWmzpSuU2UieGrTP4BZZbJRvDJGcsJVrU7JLqsaa5jUU5XUOs71hmNmf5Y
        9YtsZw6oYZKYNy9VgvOmY/SioAPeI5c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc:     "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Proper mailing list for bcachefs feedback?
Message-ID: <20220826151343.dbmn5fhnmiy7bxui@moria.home.lan>
References: <1733356543.470.1660771839141@mail.carlthompson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1733356543.470.1660771839141@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Aug 17, 2022 at 02:30:39PM -0700, Carl E. Thompson wrote:
> Hello,
> 
>      I have started evaluating bcachefs and I will have quite a bit of
>      feedback on some minor and perhaps not so minor issues. Is this the
>      proper mailing list for that? I notice there doesn't seem to be much
>      traffic on this list so I'm not sure if there is another I should be
>      using.

This is the proper mailing list. Most activity is on IRC though - you're welcome
to come join us there, as well: irc.oftc.net# bcache
