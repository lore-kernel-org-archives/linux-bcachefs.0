Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A133EE645B
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbjIOM5B (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbjIOM5B (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:57:01 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44361173A
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:56:56 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-404773f2501so13294075e9.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694782614; x=1695387414; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=isV9BzyeN0kaKHMrGJWFcCOeyr3uO6Or6Oet6p9WJUE=;
        b=aKcNBM3svwOB1yP9TOQuX3g1BuAyR9Aa8Ou55rYun9nGq5BstROkvROQ7CoVh4wDB7
         cZqxqGkDU1ztxEu1pLxX+VorbI+nPZovrszydYMlBE1vUk6YkYBUG6peSNuDfx9dci0b
         npyeiySxuKxgDYHHyq5yGQMDZV1kMsNrvoaiCT7pvOKKCtrxGC75EFq7fYveMuXToghP
         d7USzSn4LMpTXN0sh6ipfKLhYQaQnen1S48Cq6xo3tnx8dSzhju3bq82An31JZGka0vX
         by3+cE22Wg1Q20UUIMn3W+dezItVe4IphPSOI28GeWqfC/LeN3U3tpsYXQxPsh3aP/TB
         yDFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694782614; x=1695387414;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=isV9BzyeN0kaKHMrGJWFcCOeyr3uO6Or6Oet6p9WJUE=;
        b=Z1FgDfmLjM2exkyUi/NvqNEEZwsroVvIlVEWfIEia6Vo8NwFFmbQfqpSwRy4zz2OET
         f5T/w0cEtKFt9JLqn6oMqq9LAfQAA0XoMn2YPrJfnu+zEf4sjnWBbSNqZx8QEmV1P3nL
         dmCTHIk9gUtumVAUtVtyBa0NOCMSJLX9jBYxTGcxvq1Lxg2Ky/EwwAvSJchObHOVk2Ns
         d0Xku0WD6wGfHElVV4t06feYxcXbFIJgTv2NQcD2650dz4J3GWMtofW/RHX1Y8q3Vfi8
         lcLq8G++jdGOxtMd8WLyq8zF+RQvIjP2TxfhG4hvLCwtjPgTesMoZWK9b2d+qBJrQruZ
         CKjQ==
X-Gm-Message-State: AOJu0YzxQVifBcFd+7kNzYW9iveIFuBUpNJtzymgM7ecsniJQO0QHXpA
        4jaIF6ZebiQEDHy5KjPcMJaPEMJ6CLqbsMNEvJo=
X-Google-Smtp-Source: AGHT+IEUmRWFsvXSrTfSr2igsR5PY6PfBjsZSRpafYy9jjdSBfiZLSU5SkR12KzhMZMvEk7Qgx1PvQ==
X-Received: by 2002:a1c:ed0d:0:b0:3f8:fc2a:c7eb with SMTP id l13-20020a1ced0d000000b003f8fc2ac7ebmr1569795wmh.5.1694782614628;
        Fri, 15 Sep 2023 05:56:54 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l13-20020a7bc44d000000b00401c595fcc7sm7407892wmi.11.2023.09.15.05.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 05:56:54 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:56:51 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: error pointer vs NULL in
 bch2_chacha_encrypt_key()
Message-ID: <f268a6ef-edd4-403d-9486-0147cc35032b@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
(linux-next), leads to the following Smatch static checker warning:

	fs/bcachefs/checksum.c:162 bch2_chacha_encrypt_key()
	warn: 'chacha20' is an error pointer or valid

fs/bcachefs/checksum.c
    155 int bch2_chacha_encrypt_key(struct bch_key *key, struct nonce nonce,
    156                             void *buf, size_t len)
    157 {
    158         struct crypto_sync_skcipher *chacha20 =
    159                 crypto_alloc_sync_skcipher("chacha20", 0, 0);
    160         int ret;
    161 
--> 162         if (!chacha20) {

Should be if (IS_ERR(chacha20)) {

    163                 pr_err("error requesting chacha20 module: %li", PTR_ERR(chacha20));
    164                 return PTR_ERR(chacha20);
    165         }
    166 
    167         ret = crypto_skcipher_setkey(&chacha20->base,
    168                                      (void *) key, sizeof(*key));
    169         if (ret) {
    170                 pr_err("crypto_skcipher_setkey() error: %i", ret);
    171                 goto err;
    172         }
    173 
    174         ret = do_encrypt(chacha20, nonce, buf, len);
    175 err:
    176         crypto_free_sync_skcipher(chacha20);
    177         return ret;
    178 }

regards,
dan carpenter
