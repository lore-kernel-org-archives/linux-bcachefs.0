Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C10DCE79A8
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 01:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjITBur (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 21:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjITBuq (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 21:50:46 -0400
Received: from out-229.mta1.migadu.com (out-229.mta1.migadu.com [95.215.58.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EFDB3
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 18:50:41 -0700 (PDT)
Date:   Tue, 19 Sep 2023 21:50:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695174639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DcYvlWjsp4BhHjmP4yyhvwvEazEdgf41QJpRbZ5WZ98=;
        b=ABv0yBR1eyXSEaWvPhYEAojBuVxZE3NdEctUC3dc024sWa5zrUaLHqmOJmEOakD3YYFL1W
        IO92332ebV6E44/FNbWv687L0Q8b01xr4BljYTIOHqa1vZJwKwohYmTwlQtWjo8JBHpXtU
        kkyf1jgwFTz3hSLrUYJmy0svqNecFhI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error codes in
 journal_entry_blacklist_v2_validate()
Message-ID: <20230920015037.wdr6bhwcmzuyhw3n@moria.home.lan>
References: <3cd4ecca-6002-4722-9f0e-0efc93ccb8d3@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cd4ecca-6002-4722-9f0e-0efc93ccb8d3@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 03:57:43PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch b3dc2344548f: "bcachefs: reserve space in journal for fs
> usage entries" from Jan 24, 2019 (linux-next), leads to the following
> Smatch static checker warning:
> 
> 	fs/bcachefs/journal_io.c:468 journal_entry_blacklist_v2_validate()
> 	warn: missing error code here? 'journal_entry_err_on()' failed. 'ret' = '0'
> 
> fs/bcachefs/journal_io.c
>     455 static int journal_entry_blacklist_v2_validate(struct bch_fs *c,
>     456                                 struct jset *jset,
>     457                                 struct jset_entry *entry,
>     458                                 unsigned version, int big_endian,
>     459                                 enum bkey_invalid_flags flags)
>     460 {
>     461         struct jset_entry_blacklist_v2 *bl_entry;
>     462         int ret = 0;
>     463 
>     464         if (journal_entry_err_on(le16_to_cpu(entry->u64s) != 2,
>     465                                  c, version, jset, entry,
>     466                 "invalid journal seq blacklist entry: bad size")) {
>     467                 journal_entry_null_range(entry, vstruct_next(entry));
> --> 468                 goto out;
> 
> Should these error
> 
>     469         }
>     470 
>     471         bl_entry = container_of(entry, struct jset_entry_blacklist_v2, entry);
>     472 
>     473         if (journal_entry_err_on(le64_to_cpu(bl_entry->start) >
>     474                                  le64_to_cpu(bl_entry->end),
>     475                                  c, version, jset, entry,
>     476                 "invalid journal seq blacklist entry: start > end")) {
>     477                 journal_entry_null_range(entry, vstruct_next(entry));
> 
> paths set an error code?

No. When we detect a fsck error, there are three possible ways we might
continue:
 - we might continue without fixing the error
 - we might abort, and return an error
 - we might fix the error

fsck_err_on(), journal_entry_err_on(), etc. return true if we wish to
fix the error, they call "goto fsck_err" if we want to abort with an
error code.
