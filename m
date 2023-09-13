Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D37CA5537
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Sep 2023 10:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbjIMKrb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Sep 2023 06:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjIMKrb (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Sep 2023 06:47:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5308119AC
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 03:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694602000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+0qvkYwtrcO7faarFMzFVDao1vw9b8jVL6GtDEUP0I=;
        b=WTj01NCVWSGr4hCEntOAiPsOv6ibY7Q0x0ch/m/587cYcMxE5lBpzpJaJ1MljkCgtDORqg
        6+GrNcfcd8q3wzA8ZSef8CH3sAeko44OL/mlgAqPdl53qkWD/BR/ms1vXNWFjY9y4HrMVR
        ghcLuav+fiyCJNjSxEwVvWoCwQb7YOQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-I4CegdItMfWYDNR1LSiIgw-1; Wed, 13 Sep 2023 06:46:39 -0400
X-MC-Unique: I4CegdItMfWYDNR1LSiIgw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-411f95b1a31so69932871cf.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 03:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694601998; x=1695206798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+0qvkYwtrcO7faarFMzFVDao1vw9b8jVL6GtDEUP0I=;
        b=SE0GEt8k1+FYhGcbD9wVxuDtKN2daFxdFqjxfvucOpo3btz4sr40NhxdZjwAf01BWy
         viiWBmNDJgLP99GhjteMoZ8XP3woNn51lhGMnn8G5AuFHWHl4uTtsPIahMoKGEFVSKG4
         oaxsV1INlfYhyBCGseYWB0JOGAhSsHUT5A9ltzHaVP1uDoTW/jGkOLZFYpLrfISJZlw1
         lsL4bB22PcyGXbrfXb+Aas+suyZgbTNwVEHVM7eUpGcMC0tFO8I9xF9t6jXpbxeN2ufp
         u5j6dmd+lDDaip/BxkDdgW7WZ5Pqp37qjuxvK4zxywgbmlh+pQPw2AduVCQ1Yw7NyEy1
         9Mww==
X-Gm-Message-State: AOJu0YzAn7fA3tCTp7ngL8QpVuaDFQWxFNflxCtL71DoFDbzeLrHh1dM
        i550NN28OdcJVRyRLL/9drNcmuqEVQTQ0AHtgNqUkJzWbpLlagZhAhCWFWMtvdnTLKm015iDD1q
        2otX0p2iUdcjpoAb0f+cgGDP5z1U=
X-Received: by 2002:ac8:5b4b:0:b0:410:aa40:e8f7 with SMTP id n11-20020ac85b4b000000b00410aa40e8f7mr2169643qtw.33.1694601998664;
        Wed, 13 Sep 2023 03:46:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9nyWwUy1CH3HJQRTdKOYwxVUjUhlXskTR/aVLu8Suwo13+Oim4pqSh5PsL8p6XGj5kL9c/Q==
X-Received: by 2002:ac8:5b4b:0:b0:410:aa40:e8f7 with SMTP id n11-20020ac85b4b000000b00410aa40e8f7mr2169630qtw.33.1694601998388;
        Wed, 13 Sep 2023 03:46:38 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id h20-20020a05622a171400b00411fcc18cc1sm3905003qtk.64.2023.09.13.03.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 03:46:38 -0700 (PDT)
Date:   Wed, 13 Sep 2023 06:46:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] bcachefs: Remove unneeded semicolon
Message-ID: <ZQGTGV0LRqkKBF6p@bfoster>
References: <20230913005756.6827-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913005756.6827-1-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Sep 13, 2023 at 08:57:56AM +0800, Yang Li wrote:
> ./fs/bcachefs/btree_gc.c:1249:2-3: Unneeded semicolon
> ./fs/bcachefs/btree_gc.c:1521:2-3: Unneeded semicolon
> ./fs/bcachefs/btree_gc.c:1575:2-3: Unneeded semicolon
> ./fs/bcachefs/counters.c:46:2-3: Unneeded semicolon
> 
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---

What produces these warnings? It would be help to add a sentence or two
of such context in the commit log.. even just a "XYZ reports the
following: ..."

Nit aside, patch seems fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/bcachefs/btree_gc.c | 6 +++---
>  fs/bcachefs/counters.c | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
> index dac2eb76c985..56c671638c43 100644
> --- a/fs/bcachefs/btree_gc.c
> +++ b/fs/bcachefs/btree_gc.c
> @@ -1246,7 +1246,7 @@ static int bch2_gc_done(struct bch_fs *c,
>  			copy_dev_field(d[i].sectors,	"%s sectors", bch2_data_types[i]);
>  			copy_dev_field(d[i].fragmented,	"%s fragmented", bch2_data_types[i]);
>  		}
> -	};
> +	}
>  
>  	{
>  		unsigned nr = fs_usage_u64s(c);
> @@ -1518,7 +1518,7 @@ static int bch2_gc_alloc_start(struct bch_fs *c, bool metadata_only)
>  		buckets->first_bucket	= ca->mi.first_bucket;
>  		buckets->nbuckets	= ca->mi.nbuckets;
>  		rcu_assign_pointer(ca->buckets_gc, buckets);
> -	};
> +	}
>  
>  	bch2_trans_init(&trans, c, 0, 0);
>  
> @@ -1572,7 +1572,7 @@ static void bch2_gc_alloc_reset(struct bch_fs *c, bool metadata_only)
>  			g->dirty_sectors = 0;
>  			g->cached_sectors = 0;
>  		}
> -	};
> +	}
>  }
>  
>  static int bch2_gc_write_reflink_key(struct btree_trans *trans,
> diff --git a/fs/bcachefs/counters.c b/fs/bcachefs/counters.c
> index 442a9b806a3c..26eb3d82b1cb 100644
> --- a/fs/bcachefs/counters.c
> +++ b/fs/bcachefs/counters.c
> @@ -43,7 +43,7 @@ static void bch2_sb_counters_to_text(struct printbuf *out, struct bch_sb *sb,
>  		prt_tab(out);
>  		prt_printf(out, "%llu", le64_to_cpu(ctrs->d[i]));
>  		prt_newline(out);
> -	};
> +	}
>  };
>  
>  int bch2_sb_counters_to_cpu(struct bch_fs *c)
> -- 
> 2.20.1.7.g153144c
> 

