Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55333EEAA6E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 20:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjINUAl (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 16:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjINUAk (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 16:00:40 -0400
Received: from out-225.mta0.migadu.com (out-225.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E0E26BC
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 13:00:36 -0700 (PDT)
Date:   Thu, 14 Sep 2023 16:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694721635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hijr0QBjBe3+CqOO6ancHHx9JZaoWQ/nLgY6CrzFomo=;
        b=rpCHwLoDxqbKYuNJXN2s59Q+Drq8BCKz3YBbtSIV4bkLG73SX/bricczRa4V46npNDAmDA
        ZNDH2XkBaOnFxY+e1p/2Oa+TVCaY+ZFm0n1MGvPXNYY2AN29PObVdmDKIme+CTdlosl4Fz
        cpFqNMQnWBAPhKNAZC8Wc/H2vgmET7M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: Fix bch2_check_discard_freespace_key()
Message-ID: <20230914200032.expuvioeka6kuadx@moria.home.lan>
References: <a7450ee4-6cfc-4c36-a203-dccc21e0f0a5@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7450ee4-6cfc-4c36-a203-dccc21e0f0a5@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 14, 2023 at 01:13:05PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch 6489d817f5e2: "bcachefs: Fix
> bch2_check_discard_freespace_key()" from Jun 18, 2023 (linux-next),
> leads to the following Smatch static checker warning:
> 
> 	fs/bcachefs/alloc_background.c:1295 bch2_check_discard_freespace_key()
> 	error: uninitialized symbol 'ret'.
> 
> fs/bcachefs/alloc_background.c
>     1281 static int bch2_check_discard_freespace_key(struct btree_trans *trans,
>     1282                                             struct btree_iter *iter,
>     1283                                             struct bpos end)
>     1284 {
>     1285         if (!btree_id_is_extents(iter->btree_id)) {
>     1286                 return __bch2_check_discard_freespace_key(trans, iter);
>     1287         } else {
>     1288                 int ret;
>     1289 
>     1290                 while (!bkey_eq(iter->pos, end) &&
> 
> What about if bkey_eq() is at the end on the first iteration through the
> loop?

yup, just applied a fix - thanks
