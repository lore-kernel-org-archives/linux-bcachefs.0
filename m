Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EB6C76188
	for <linux-bcachefs@archiver.kernel.org>; Wed,  5 Apr 2023 06:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbjDEGjc (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 5 Apr 2023 02:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbjDEGjb (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 5 Apr 2023 02:39:31 -0400
Received: from out-25.mta0.migadu.com (out-25.mta0.migadu.com [IPv6:2001:41d0:1004:224b::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846211FE7
        for <linux-bcachefs@vger.kernel.org>; Tue,  4 Apr 2023 23:39:29 -0700 (PDT)
Date:   Wed, 5 Apr 2023 02:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680676765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SAVJZT9rAVSdhL+yeI9eZiUHXMrSO6W9wAQU181TK38=;
        b=FVFcLnoHWi35sQtKZE7ajQlrmk6MnYOqvEzYL7DI8p/as5DhTvQ8Ui+Wk6F7VU/5PFUS6m
        FHpkVCHuXaZJLkVyW90nniCXC4376iwi7mjpY7/40R5XuEGLuybZC5waf8D/saTZ9hczVH
        34WV7PGE+TYBF5xoVlixKLxh0gB+9p4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     cee1 <fykcee1@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Questions about struct btree
Message-ID: <ZC0XmlhMK1bEE2lq@moria.home.lan>
References: <CAGXxSxWrf8gy6zTeEGbqGxYSxfA5y9grqouUa9KYgwTuWF05dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXxSxWrf8gy6zTeEGbqGxYSxfA5y9grqouUa9KYgwTuWF05dg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Apr 03, 2023 at 11:35:02PM +0800, cee1 wrote:
> Hi all,
> 
> Curious about the details described by the heading comments of bcachefs.h.
> 
> Some questions:
> a) struct btree::aux_data
>   a.1) The aux_data is NOT stored on disk. It will be created for each
> bset runtime, am I right?

Correct. 

>   a.2) bch2_compile_bkey_format() write some info to aux_data, what
> does that info mean?

It's a dynamically generated unpack function.

> b) struct btree::set
> How many effective bsets (or btree_node / btree_node_entry) referenced
> by btree::set?
> Two? one for written, one for in-memory?

Up to three, decreasing in size geometrically.

> c) What are bch_vals ?
> bch_val is BCH_REPLICAS_MAX number pointers, which are offsets --
> pointing to BCH_REPLICAS_MAX number extents, am I right?

bch_val is an empty type, a placeholder for whatever the actual value
type is - you may be referrinc to bch_extent.
