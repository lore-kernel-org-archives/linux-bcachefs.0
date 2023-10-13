Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632F6CDB47E
	for <linux-bcachefs@archiver.kernel.org>; Fri, 13 Oct 2023 07:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjJMHR3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 13 Oct 2023 03:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjJMHR2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 13 Oct 2023 03:17:28 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8362B8
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Oct 2023 00:17:26 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-3248ac76acbso1515645f8f.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Oct 2023 00:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697181445; x=1697786245; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n0UALoQRjg10sDaH8TZ3PLWRoWaPT3Pac8+hajunjwI=;
        b=iQgFuEDGJHnN5ZzEdG6EtmUvHOAcQQC1vFhBiWh0SggykksIjr5NaGceOv85x/nKlK
         5x4eSd+UPXtFdSxlQ839h91GVBIsFbhP90wW3aywDNszKW0lkEHzfhx4fhq3uP8ZlAXC
         PmaZKrmbQvwagxAfinJVbl9bQKDsq0dOIKlBSisJxGsuHTbf5h5TvrfxakYFftztcQVJ
         6PkfvEv2DicrW4p6L7zSSXhmJKlr2+X3hH67oY3te7zj4OvKeUX31fUyWDkfEu9P69qs
         6wgH82CKxOiE5O9Fr82DZ//+TiKBx/HkAHifMNOODXS35Pyyn9cQwuY5o8lWE5UYFm7y
         ehHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697181445; x=1697786245;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n0UALoQRjg10sDaH8TZ3PLWRoWaPT3Pac8+hajunjwI=;
        b=s8s8gIp8Ch5LHM9ekKrKiqpcRTZf7WfB2wSbyoDdJjcgMllrzYjxs4u0hf0NwXZJsD
         wsJ8VfNvv0nYNs85234GB1KQn9Bz9Vkw2VINoXbmVEbYzwQTgkmnllkHb8kwqqOBDMoc
         AkW+OTsAVIc68+S2cLiXNTNKAT4gx3AURkW/jr4j8vVMpxvr049wkSO0RPTX9MK9seLy
         wd6KYpbVnYpH5du73JSotYzKVcPBayePW4Frl63/26GTlGviAi8Ao8MiFeXF1SCYajqX
         1/rt7YV6fqaYQyWFwTRaGelsZ3TROZK/nEUsqpNlUOrtxPKit3uuEkT5rpem7sAz65no
         o6YQ==
X-Gm-Message-State: AOJu0YzrrYW0B1BdxAFlPlWrnjpwcfNxl2a2MKG1412zJeI+G92nN9L2
        CUbE81M/+opml4iRUqFCDLmpADXcnMhX7SpY7GE=
X-Google-Smtp-Source: AGHT+IFKDhiAOK3DLNNYw2FOm3sDMDZA9bo2REekEY6BOblX6LPRrA8tmdKC5kNqcNQujIVTvHrM9A==
X-Received: by 2002:a5d:5686:0:b0:321:6833:b930 with SMTP id f6-20020a5d5686000000b003216833b930mr22707610wrv.16.1697181445264;
        Fri, 13 Oct 2023 00:17:25 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m8-20020adfa3c8000000b0032d7fde2d3csm7933556wrb.79.2023.10.13.00.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Oct 2023 00:17:25 -0700 (PDT)
Date:   Fri, 13 Oct 2023 10:17:21 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: missing error check on
 bch2_btree_node_mem_alloc()
Message-ID: <19cb1451-4cf4-46e7-b7c1-74a9b14e859a@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
(linux-next), leads to the following Smatch static checker warning:

	fs/bcachefs/btree_update_interior.c:2265 bch2_btree_node_update_key()
	error: 'new_hash' dereferencing possible ERR_PTR()

fs/bcachefs/btree_update_interior.c
    2227 int bch2_btree_node_update_key(struct btree_trans *trans, struct btree_iter *iter,
    2228                                struct btree *b, struct bkey_i *new_key,
    2229                                unsigned commit_flags, bool skip_triggers)
    2230 {
    2231         struct bch_fs *c = trans->c;
    2232         struct btree *new_hash = NULL;
    2233         struct btree_path *path = iter->path;
    2234         struct closure cl;
    2235         int ret = 0;
    2236 
    2237         ret = bch2_btree_path_upgrade(trans, path, b->c.level + 1);
    2238         if (ret)
    2239                 return ret;
    2240 
    2241         closure_init_stack(&cl);
    2242 
    2243         /*
    2244          * check btree_ptr_hash_val() after @b is locked by
    2245          * btree_iter_traverse():
    2246          */
    2247         if (btree_ptr_hash_val(new_key) != b->hash_val) {
    2248                 ret = bch2_btree_cache_cannibalize_lock(c, &cl);
    2249                 if (ret) {
    2250                         ret = drop_locks_do(trans, (closure_sync(&cl), 0));
    2251                         if (ret)
    2252                                 return ret;
    2253                 }
    2254 
    2255                 new_hash = bch2_btree_node_mem_alloc(trans, false);

This allocation can fail and it returns an error pointer?

    2256         }
    2257 
    2258         path->intent_ref++;
    2259         ret = __bch2_btree_node_update_key(trans, iter, b, new_hash, new_key,
    2260                                            commit_flags, skip_triggers);
    2261         --path->intent_ref;
    2262 
    2263         if (new_hash) {
    2264                 mutex_lock(&c->btree_cache.lock);
--> 2265                 list_move(&new_hash->list, &c->btree_cache.freeable);
    2266                 mutex_unlock(&c->btree_cache.lock);
    2267 
    2268                 six_unlock_write(&new_hash->c.lock);
    2269                 six_unlock_intent(&new_hash->c.lock);
    2270         }
    2271         closure_sync(&cl);
    2272         bch2_btree_cache_cannibalize_unlock(c);
    2273         return ret;
    2274 }

regards,
dan carpenter
