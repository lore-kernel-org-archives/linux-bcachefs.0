Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFD4EE645B
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbjIOM6T (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbjIOM6T (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:58:19 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811B5E7
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:58:13 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-402c46c49f4so22844665e9.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694782692; x=1695387492; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l/3ESBqFrHXt2RRcvjUCF+tuVlFlNMc+NyMcxyBLILc=;
        b=ljoLEpmyzaXrjnpkBvThmauYXUKPmyP+0dGhOvAHU4Jfwg00thheEwjrw17E5E7BHo
         4s3x+Ji3ngbg6X+lbcvjTodo4gAhygdw2gfkQMTg2wNKm88zJ7CRdB5Kkf8P9VTm62Zl
         7MuT+zav+2Almh8JjSJo8EtURYDhONsd/OzwIDOOPsSIZp8EKAd6nORftsDIz0dfyn7w
         x4WWCUHJMiXc6CB9NR7EPT3OXYcmeMnMcVcdAhjQ5OXHNIbet5TILEmlPqqziXWS07gW
         gHtD+xNo+0L/+ZQdARmxzNTKZASB8lKzMzQmrcnMlsQGLZeLM3nINxq3XOKHYKocpeDr
         nJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694782692; x=1695387492;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l/3ESBqFrHXt2RRcvjUCF+tuVlFlNMc+NyMcxyBLILc=;
        b=qxMgkqjW5JqT5xZYzRRoMcU+kwEHmxyXt+8R6Mra9HYKyebAFWIuurbkZnD2AF7OKO
         j0MF7P9unTTJQ/fGvMtBlPCfnUqzqrBnhgqMmTT3HpfnLIM7k57M3NRaQBTAgro8BvtS
         lFDFNjkpOUV8XUOdRT7rbriHSj0kqpwDgPoyjLqssJO0QVzJr7gmM3atKm2MIyLDhU3m
         AZJ/o6x5d1HBx0wksUtbTrYZ4MfI3bktCvC3fNs/r8EWSzDPyi5VFrWqBrMNgXWGhjtH
         CLjaIYsK/d6mAOCPq4e5JkNgEvgFqzoUwB9wGRi5BpdyukFMWzX502Mo9JP9UL4ZSrck
         seSw==
X-Gm-Message-State: AOJu0YwWHyGz8XOEvgq6K9tvN+3HeCtjKbs0oawT82SPVMaW3IyMOvXe
        ZqVLkmxUDSsBuyE9wrd4JXWHLw==
X-Google-Smtp-Source: AGHT+IG9v+t1qeM6KxWdSexyZeX/R1qUjqDCRzxTilzrmOGNzXHXW3hIAAObZtkltfLuBGuCp5F9fg==
X-Received: by 2002:a05:600c:3647:b0:401:cc0f:f866 with SMTP id y7-20020a05600c364700b00401cc0ff866mr1505990wmq.12.1694782691918;
        Fri, 15 Sep 2023 05:58:11 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id p3-20020a05600c204300b003fefaf299b6sm4607453wmg.38.2023.09.15.05.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 05:58:11 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:58:08 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: missing error code in
 bch2_fs_encryption_init()
Message-ID: <af3d7194-4828-4fbb-ac66-35698de7d911@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
(linux-next), leads to the following Smatch static checker warning:

	fs/bcachefs/checksum.c:736 bch2_fs_encryption_init()
	warn: missing error code here? 'bch2_sb_get_crypt()' failed. 'ret' = '0'

fs/bcachefs/checksum.c
    721 int bch2_fs_encryption_init(struct bch_fs *c)
    722 {
    723         struct bch_sb_field_crypt *crypt;
    724         struct bch_key key;
    725         int ret = 0;
    726 
    727         c->sha256 = crypto_alloc_shash("sha256", 0, 0);
    728         ret = PTR_ERR_OR_ZERO(c->sha256);
    729         if (ret) {
    730                 bch_err(c, "error requesting sha256 module: %s", bch2_err_str(ret));
    731                 goto out;
    732         }
    733 
    734         crypt = bch2_sb_get_crypt(c->disk_sb.sb);
    735         if (!crypt)
--> 736                 goto out;

ret = -ENOMEM;?

    37 
    738         ret = bch2_alloc_ciphers(c);
    739         if (ret)
    740                 goto out;
    741 
    742         ret = bch2_decrypt_sb_key(c, crypt, &key);
    743         if (ret)
    744                 goto out;
    745 
    746         ret = crypto_skcipher_setkey(&c->chacha20->base,
    747                         (void *) &key.key, sizeof(key.key));
    748         if (ret)
    749                 goto out;
    750 out:
    751         memzero_explicit(&key, sizeof(key));
    752         return ret;
    753 }

regards,
dan carpenter
