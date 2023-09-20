Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899D1CE79A9
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 01:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjITBqQ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 21:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjITBqP (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 21:46:15 -0400
Received: from out-211.mta1.migadu.com (out-211.mta1.migadu.com [95.215.58.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43C7B3
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 18:46:09 -0700 (PDT)
Date:   Tue, 19 Sep 2023 21:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695174367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uNGnkQJXN3HGPp3San9QE4DN1eptxL5dFwUC/Aj5854=;
        b=S46bqU0lyI+8D9Qln2xW0ObiMMoqkvJYwaH7jIYBqPd9hTjgtKOS5QaMprIWDkpkQd7cRx
        xPud5wdH+YPvlu6BK7HKA4MsP0m87L87UrOG8HU7XcU/Y5VhuaWbmPJWHidSuYZj/A0Z3m
        opDoe0veXi5x/qK/r/lFZF9++p4HZUA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     kent.overstreet@gmail.com, Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error code in
 bch2_fs_encryption_init()
Message-ID: <20230920014603.swnpnrnmvucoph2l@moria.home.lan>
References: <af3d7194-4828-4fbb-ac66-35698de7d911@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3d7194-4828-4fbb-ac66-35698de7d911@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 03:58:08PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
> (linux-next), leads to the following Smatch static checker warning:
> 
> 	fs/bcachefs/checksum.c:736 bch2_fs_encryption_init()
> 	warn: missing error code here? 'bch2_sb_get_crypt()' failed. 'ret' = '0'
> 
> fs/bcachefs/checksum.c
>     721 int bch2_fs_encryption_init(struct bch_fs *c)
>     722 {
>     723         struct bch_sb_field_crypt *crypt;
>     724         struct bch_key key;
>     725         int ret = 0;
>     726 
>     727         c->sha256 = crypto_alloc_shash("sha256", 0, 0);
>     728         ret = PTR_ERR_OR_ZERO(c->sha256);
>     729         if (ret) {
>     730                 bch_err(c, "error requesting sha256 module: %s", bch2_err_str(ret));
>     731                 goto out;
>     732         }
>     733 
>     734         crypt = bch2_sb_get_crypt(c->disk_sb.sb);
>     735         if (!crypt)
> --> 736                 goto out;
> 
> ret = -ENOMEM;?

Not a bug - if there's no crypt section, the filesystem doesn't have
encryption enabled.
