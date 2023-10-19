Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CA3CDB465
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 03:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjJSD7W (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 23:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjJSD7W (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 23:59:22 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F77109
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 20:59:20 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-40675f06f1fso1560155e9.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 20:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697687958; x=1698292758; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=smCHlXCkAD5hWJULmagEeYYRYq/DhsZe/rrV+7VwmIg=;
        b=nwA0sazY7pucbjFlxmKf+ivuGorDXlGR3mAPPRhSW2/G+GnF3lDVboIPIIRg3sHcVA
         xz8aARCXCDPps7Utd8qiRE3HWM2xDdgXdY6LTHqRCN+cvXOFHGZneRwkQ2kJNPo/GC/b
         MTU8KGbpjdpyhVzDL7WaINdK5rB6N8B+OSNcmBuCmCsQtGSQhD/4A9j0aj7CT8Wy2pBJ
         rKXCd+XCAgIHtM/pRrogWknuPSNCWBJPmdhgK+87lU2tDLqcu/iviRKQtnWMz+sukC6W
         F1bqOsit5NA+VN7NFUuKSL08i+JztFERn/mJaJuATi3o7vLdDSkAMjoop5Jhe0DLmn+u
         4lWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697687958; x=1698292758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smCHlXCkAD5hWJULmagEeYYRYq/DhsZe/rrV+7VwmIg=;
        b=XnXWtJ8RlzB/uOIIJqifDBkxGM25QYGWfiJEL4kEZYC3mEy6CHAYDmo5id2LdvxMfp
         4SqvaUii1pF3MsXv4tnPvmBMj8K2EdgYGgj3WewbOcHN5c98HzC4JV65EAt3bKPl4kW5
         UniDyJOx4HlYEQIz0SPstZrJy3q/riL5GR5q7Lk54mwOLgJxUkXvtwl9CndyU2vI/c3Z
         4A9UlLQnX/CoegGaLIZv+rJwoaumUPnqqJ4Rb2zprJHALu6LM738LZTsYZfEzFpiyFzX
         wvkyYWpLzwqOLuo4vknltkTl4powmMLEvrp6f1ZUlOLwqSmUDRrJ9u5pSECkTHkCcucF
         t5Ng==
X-Gm-Message-State: AOJu0Yxbrlnn84griwn4zSv8sOKDyCABHLqB6saFRbvUSGBUFCSWNlEb
        2it6S6XqcW01N2iK2JnYamZlSQ==
X-Google-Smtp-Source: AGHT+IEJSwNWE2k5xa1QdmewxLYmNWRcqfiCu2G7T8tIBY21HSDdFa5wqmxksS6JCrBscOGJs3lCew==
X-Received: by 2002:adf:c041:0:b0:31f:fc9a:a03 with SMTP id c1-20020adfc041000000b0031ffc9a0a03mr506847wrf.20.1697687958001;
        Wed, 18 Oct 2023 20:59:18 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j20-20020a05600c1c1400b003fefb94ccc9sm3153658wms.11.2023.10.18.20.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 20:59:17 -0700 (PDT)
Date:   Thu, 19 Oct 2023 06:59:14 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error check on
 bch2_btree_node_mem_alloc()
Message-ID: <d8433264-90e1-44d9-931c-d6ffc76ccca9@kadam.mountain>
References: <19cb1451-4cf4-46e7-b7c1-74a9b14e859a@moroto.mountain>
 <20231019011942.wq5l7ebvfss5nn4y@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019011942.wq5l7ebvfss5nn4y@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 18, 2023 at 09:19:42PM -0400, Kent Overstreet wrote:
> On Fri, Oct 13, 2023 at 10:17:21AM +0300, Dan Carpenter wrote:
> > Hello Kent Overstreet,
> > 
> > The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
> > (linux-next), leads to the following Smatch static checker warning:
> > 
> > 	fs/bcachefs/btree_update_interior.c:2265 bch2_btree_node_update_key()
> > 	error: 'new_hash' dereferencing possible ERR_PTR()
> > 
> > fs/bcachefs/btree_update_interior.c
> >     2227 int bch2_btree_node_update_key(struct btree_trans *trans, struct btree_iter *iter,
> >     2228                                struct btree *b, struct bkey_i *new_key,
> >     2229                                unsigned commit_flags, bool skip_triggers)
> >     2230 {
> >     2231         struct bch_fs *c = trans->c;
> >     2232         struct btree *new_hash = NULL;
> >     2233         struct btree_path *path = iter->path;
> >     2234         struct closure cl;
> >     2235         int ret = 0;
> >     2236 
> >     2237         ret = bch2_btree_path_upgrade(trans, path, b->c.level + 1);
> >     2238         if (ret)
> >     2239                 return ret;
> >     2240 
> >     2241         closure_init_stack(&cl);
> >     2242 
> >     2243         /*
> >     2244          * check btree_ptr_hash_val() after @b is locked by
> >     2245          * btree_iter_traverse():
> >     2246          */
> >     2247         if (btree_ptr_hash_val(new_key) != b->hash_val) {
> >     2248                 ret = bch2_btree_cache_cannibalize_lock(c, &cl);
> >     2249                 if (ret) {
> >     2250                         ret = drop_locks_do(trans, (closure_sync(&cl), 0));
> >     2251                         if (ret)
> >     2252                                 return ret;
> >     2253                 }
> >     2254 
> >     2255                 new_hash = bch2_btree_node_mem_alloc(trans, false);
> > 
> > This allocation can fail and it returns an error pointer?
> 
> It doesn't fail when we hold the cannibalize lock. I can add an
> assertion that documents that if it'll stop smatch from complaining...

Nah.  It won't stop Smatch from complaining unless it has a panic().
Smatch ignores assertions which only trigger a warning.

Just leave it.  Generally the policy with Smatch is to only report
warnings once and search lore for this email if it's a false positive.

regards,
dan carpenter
