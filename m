Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8355BC001DE
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 15:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjHMPKk (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 11:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjHMPKj (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 11:10:39 -0400
Received: from out-104.mta1.migadu.com (out-104.mta1.migadu.com [95.215.58.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60456E54
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 08:10:40 -0700 (PDT)
Date:   Sun, 13 Aug 2023 11:10:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691939438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+B8OZhHtQaCRqkQG4EU3Rg55USI5Vc3c65VQHUhJFH8=;
        b=V6t7C1DzA7lTPJfaW1Dy4I96U6R50xgNrKUZFc5e1hgrseRWYkMvIvdoQBkKR9fjlRH2Mo
        jukkQToIG0P6PE/nQQyd5m7VLADRKmQGiIHW4FSn6g4O6x93DOYSxgiVCvv3H18nbhvf9L
        V1Ku791cvg8devcdblgODDEBpNKyiMc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Lower BCH_NAME_MAX to 512
Message-ID: <20230813151034.rgzwbyhwwqudjuk6@moria.home.lan>
References: <20230812235947.557433-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230812235947.557433-1-joshua@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Aug 13, 2023 at 12:59:17AM +0100, Joshua Ashton wrote:
> To ensure we aren't shooting ourselves in the foot after merge for
> potentially doing future revisions for dirent or for storing multiple
> names for casefolding, limit this to 512 for now.

Any time you're changing something - always grep to see how it's used:

bch2_dirent_invalid():

        if (d_name.len > BCH_NAME_MAX) {                                                                                                                                                                                                                                                 
                prt_printf(err, "dirent name too big (%u > %u)",                                                                                                                                                                                                                         
                       d_name.len, BCH_NAME_MAX);                                                                                                                                                                                                                                        
                return -BCH_ERR_invalid_bkey;                                                                                                                                                                                                                                            
        }

We'll need to either delete that check, or only run it for new keys
(flags & BKEY_INVALID_COMMIT), we don't want to be deleting existing
dirents

> 
> Previously this define was linked to the max size a d_name in
> bch_dirent could be.
> 
> Signed-off-by: Joshua Ashton <joshua@froggi.es>
> ---
>  fs/bcachefs/bcachefs_format.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> index 5ec218ee3569..23bae622309c 100644
> --- a/fs/bcachefs/bcachefs_format.h
> +++ b/fs/bcachefs/bcachefs_format.h
> @@ -916,9 +916,7 @@ struct bch_dirent {
>  #define DT_SUBVOL	16
>  #define BCH_DT_MAX	17
>  
> -#define BCH_NAME_MAX	((unsigned) (U8_MAX * sizeof(__u64) -		\
> -			 sizeof(struct bkey) -				\
> -			 offsetof(struct bch_dirent, d_name)))
> +#define BCH_NAME_MAX	512
>  
>  /* Xattrs */
>  
> -- 
> 2.41.0
> 
