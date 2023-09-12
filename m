Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FC0CA0ED4
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Sep 2023 13:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbjILNxA (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 12 Sep 2023 09:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbjILNw4 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 12 Sep 2023 09:52:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD5EE10D8
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Sep 2023 06:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694526725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mCauJ2JPTDHGJ7v9BUNHMOumUIcgKDrRn67wyDy6PRA=;
        b=gEkdnT6D+QUbhQJOV37VeuOo27Mfwk1sAWssvHWVEYS07i/2v0LUz7k87xf0P9iNMsMEf4
        OrVEyHKYyc8/ZqKL+Q2rIXJwsF4FwMxTzUTmfTNs6V2fspJLX0b1eF7l9DN5oxMnLz3koD
        6IkkHNzuvYLY/U4/KHCS3pDH8Z7Kki4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-uB1sbAk_MCuS1QQhQLCv6w-1; Tue, 12 Sep 2023 09:52:04 -0400
X-MC-Unique: uB1sbAk_MCuS1QQhQLCv6w-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-64aa2ddc31aso63680596d6.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Sep 2023 06:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694526723; x=1695131523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCauJ2JPTDHGJ7v9BUNHMOumUIcgKDrRn67wyDy6PRA=;
        b=bIfOQDxG6aW2jdm4wqOSp7TiggUCWRLWDTPNgeqRASg+JBQJEIye2+jHGWOrpHJfxR
         DBd0MlZ9Q5A3vdYSUET2S0h6LfvVRGk9XjlZAe/0lGT8EISo96CNa318mKF0AFzLKit0
         QEJ4O2q5V4Y4wlEQ3e/v3VXGqrN3kSjLq9N18VsdhYdJMnk8LD/8/BHZ1pYQDiVGx47j
         9S3BOZFWTZB45ivddcV6XwJAs0ZWMrpm6jF5FD2QiyXOCKwcud/NijGp2FnDyLsUHMpD
         ma72q5ZDthvEMuXKz+DvCEDMDxTFUe+2FPQC/9N1B/kc/WhGd9xMjRYCOF9tA9td7y0D
         +OPw==
X-Gm-Message-State: AOJu0YwcqGhukJVaooWQ4LOebkPL4EUtCo3ebG+j4d4ZDBWNZkWjZxY+
        XULSRwausldkpbLQ39jaxAwMg1QMoep8ezzqvaWzk8mwAeistaSnEY5dqJYDWlFd/EqKi3mpgCi
        AxglciQ4WC9okwar6ML0FAzc09d3kECyJ2uY=
X-Received: by 2002:a0c:f281:0:b0:63d:476:8e4 with SMTP id k1-20020a0cf281000000b0063d047608e4mr13459705qvl.50.1694526723597;
        Tue, 12 Sep 2023 06:52:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbEYIIXQlbfDizxk38O/h9eWWo0H+rtkEr9WqVOJ+ABPRY+TNVVqtxTvFXuysc1xZDmxHfWw==
X-Received: by 2002:a0c:f281:0:b0:63d:476:8e4 with SMTP id k1-20020a0cf281000000b0063d047608e4mr13459693qvl.50.1694526723383;
        Tue, 12 Sep 2023 06:52:03 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id z17-20020a0c8f11000000b0064f378f89a7sm3717053qvd.73.2023.09.12.06.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 06:52:03 -0700 (PDT)
Date:   Tue, 12 Sep 2023 09:52:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5][next] bcachefs: remove redundant initialization of
 pointer dst
Message-ID: <ZQBtDxCcTGv/KAo0@bfoster>
References: <20230912123744.3929609-1-colin.i.king@gmail.com>
 <20230912123744.3929609-3-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912123744.3929609-3-colin.i.king@gmail.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 12, 2023 at 01:37:41PM +0100, Colin Ian King wrote:
> The pointer dst is being initialized with a value that is never read,
> it is being re-assigned later on when it is used in a while-loop
> The initialization is redundant and can be removed.
> 
> Cleans up clang-scan build warning:
> fs/bcachefs/disk_groups.c:186:30: warning: Value stored to 'dst' during
> its initialization is never read [deadcode.DeadStores]
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  fs/bcachefs/disk_groups.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/disk_groups.c b/fs/bcachefs/disk_groups.c
> index f36472c4a781..9fa8d7d49f3e 100644
> --- a/fs/bcachefs/disk_groups.c
> +++ b/fs/bcachefs/disk_groups.c
> @@ -183,8 +183,7 @@ int bch2_sb_disk_groups_to_cpu(struct bch_fs *c)
>  
>  	for (i = 0; i < c->disk_sb.sb->nr_devices; i++) {
>  		struct bch_member *m = mi->members + i;
> -		struct bch_disk_group_cpu *dst =
> -			&cpu_g->entries[BCH_MEMBER_GROUP(m)];
> +		struct bch_disk_group_cpu *dst;

Nit: kind of seems like this variable could just be lifted to the top of
the function given that it's used in two loops, but the patch seems fine
to me either way.

Brian

>  
>  		if (!bch2_member_exists(m))
>  			continue;
> -- 
> 2.39.2
> 

