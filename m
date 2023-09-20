Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A95C9CE79A9
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 01:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjITB4o (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 21:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjITB4l (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 21:56:41 -0400
Received: from out-230.mta1.migadu.com (out-230.mta1.migadu.com [IPv6:2001:41d0:203:375::e6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B914BE
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 18:56:34 -0700 (PDT)
Date:   Tue, 19 Sep 2023 21:56:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695174992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oI1CPR9xywIqO+ssQl25/WQALk/BafVAqRvOLRynWtw=;
        b=IUb7eSf+WIhtqHxu2PL8rsvgz5+3lz0Efo9BTqtdoxapeabb7xy33ERzmvL0YF9oB3oNu9
        bhlG7jzOeUH2sBi1D8AxUihY4JfTu9xlzvG620yU6IF+dKIF1Uq0GoxW+lhBoLiJDlqxOQ
        7ERPsIZqO3N5U/PawYId2ZOg7WjBFfg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     kent.overstreet@gmail.com, Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: error pointer vs NULL in
 bch2_chacha_encrypt_key()
Message-ID: <20230920015630.ksipyuddgec35ber@moria.home.lan>
References: <f268a6ef-edd4-403d-9486-0147cc35032b@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f268a6ef-edd4-403d-9486-0147cc35032b@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 03:56:51PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
> (linux-next), leads to the following Smatch static checker warning:
> 
> 	fs/bcachefs/checksum.c:162 bch2_chacha_encrypt_key()
> 	warn: 'chacha20' is an error pointer or valid
> 
> fs/bcachefs/checksum.c
>     155 int bch2_chacha_encrypt_key(struct bch_key *key, struct nonce nonce,
>     156                             void *buf, size_t len)
>     157 {
>     158         struct crypto_sync_skcipher *chacha20 =
>     159                 crypto_alloc_sync_skcipher("chacha20", 0, 0);
>     160         int ret;
>     161 
> --> 162         if (!chacha20) {
> 
> Should be if (IS_ERR(chacha20)) {
> 
>     163                 pr_err("error requesting chacha20 module: %li", PTR_ERR(chacha20));
>     164                 return PTR_ERR(chacha20);
>     165         }
>     166 
>     167         ret = crypto_skcipher_setkey(&chacha20->base,
>     168                                      (void *) key, sizeof(*key));
>     169         if (ret) {
>     170                 pr_err("crypto_skcipher_setkey() error: %i", ret);
>     171                 goto err;
>     172         }
>     173 
>     174         ret = do_encrypt(chacha20, nonce, buf, len);
>     175 err:
>     176         crypto_free_sync_skcipher(chacha20);
>     177         return ret;
>     178 }
> 
> regards,
> dan carpenter

thanks, fixed
