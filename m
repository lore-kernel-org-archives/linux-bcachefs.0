Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DC7CDB484
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 01:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjJSBTt (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 21:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjJSBTt (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 21:19:49 -0400
Received: from out-193.mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C2E112
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 18:19:47 -0700 (PDT)
Date:   Wed, 18 Oct 2023 21:19:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697678385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O4J4URPEzNz9ELKlU/Uggnhvl2OTHuVFslqxjREdy64=;
        b=o0husCpFLYEgqbgu2kuV2eMikiQ44Gw9JhrdcVHIhaQF79rqffHkQbyFCC64gE3LofN/fk
        TJNVkBFrUMyZ5yafjUnk6Y0Tl+OfLeQeQYA0YYFyfRKh9VTIEJkIJ2H2Kh+9vNKAz6oX9Y
        4jKFoPvXoaR5q4D7GUJ71sR1JmKv1b4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error check on
 bch2_btree_node_mem_alloc()
Message-ID: <20231019011942.wq5l7ebvfss5nn4y@moria.home.lan>
References: <19cb1451-4cf4-46e7-b7c1-74a9b14e859a@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19cb1451-4cf4-46e7-b7c1-74a9b14e859a@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Oct 13, 2023 at 10:17:21AM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
> (linux-next), leads to the following Smatch static checker warning:
> 
> 	fs/bcachefs/btree_update_interior.c:2265 bch2_btree_node_update_key()
> 	error: 'new_hash' dereferencing possible ERR_PTR()
> 
> fs/bcachefs/btree_update_interior.c
>     2227 int bch2_btree_node_update_key(struct btree_trans *trans, struct btree_iter *iter,
>     2228                                struct btree *b, struct bkey_i *new_key,
>     2229                                unsigned commit_flags, bool skip_triggers)
>     2230 {
>     2231         struct bch_fs *c = trans->c;
>     2232         struct btree *new_hash = NULL;
>     2233         struct btree_path *path = iter->path;
>     2234         struct closure cl;
>     2235         int ret = 0;
>     2236 
>     2237         ret = bch2_btree_path_upgrade(trans, path, b->c.level + 1);
>     2238         if (ret)
>     2239                 return ret;
>     2240 
>     2241         closure_init_stack(&cl);
>     2242 
>     2243         /*
>     2244          * check btree_ptr_hash_val() after @b is locked by
>     2245          * btree_iter_traverse():
>     2246          */
>     2247         if (btree_ptr_hash_val(new_key) != b->hash_val) {
>     2248                 ret = bch2_btree_cache_cannibalize_lock(c, &cl);
>     2249                 if (ret) {
>     2250                         ret = drop_locks_do(trans, (closure_sync(&cl), 0));
>     2251                         if (ret)
>     2252                                 return ret;
>     2253                 }
>     2254 
>     2255                 new_hash = bch2_btree_node_mem_alloc(trans, false);
> 
> This allocation can fail and it returns an error pointer?

It doesn't fail when we hold the cannibalize lock. I can add an
assertion that documents that if it'll stop smatch from complaining...
