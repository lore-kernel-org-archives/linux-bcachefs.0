Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE57FC4332F
	for <linux-bcachefs@archiver.kernel.org>; Fri,  3 Nov 2023 07:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343969AbjKCHQI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 3 Nov 2023 03:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343965AbjKCHQH (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 3 Nov 2023 03:16:07 -0400
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [IPv6:2001:41d0:203:375::bc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14491184
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 00:16:01 -0700 (PDT)
Date:   Fri, 3 Nov 2023 03:15:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698995758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hpVF05lznDqDx6f1+ea6T4Jp10EfIGdgeBzLRI3fFVk=;
        b=rqWI9lg+57oFBlVY9KB6duYdaOIhQNyobFpHFTwi+FAZZge9Xuox/4TripKYHOgXg6U6Lb
        SFtB2XuGEEQTs2ocniYlqxQBJaN8ohlboDzZ3VkIlcHxQY/uS8X5qbPpNoJDrfMk6DYWJI
        Ecf/imZiSCuNjbcDntarbi0X88S2Myk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] bcachefs: add a missing tab to bch2_dev_exists()
Message-ID: <20231103071554.ivjvexzgkj5xlpxz@moria.home.lan>
References: <b5297f95-ee72-4160-8824-e62fd12f6aad@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5297f95-ee72-4160-8824-e62fd12f6aad@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Nov 03, 2023 at 09:34:33AM +0300, Dan Carpenter wrote:
> This line needs to be indented another tab.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  fs/bcachefs/sb-members.h | 2 +-
>  1 file changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/bcachefs/sb-members.h b/fs/bcachefs/sb-members.h
> index 1583e80afcbf..10072088c299 100644
> --- a/fs/bcachefs/sb-members.h
> +++ b/fs/bcachefs/sb-members.h
> @@ -190,7 +190,7 @@ static inline bool bch2_dev_exists(struct bch_sb *sb,
>  				   unsigned dev)
>  {
>  	if (dev < sb->nr_devices) {
> -	struct bch_member m = bch2_sb_member_get(sb, dev);
> +		struct bch_member m = bch2_sb_member_get(sb, dev);
>  		return bch2_member_exists(&m);
>  	}
>  	return false;
> -- 
> 2.42.0
> 

already in my tree
