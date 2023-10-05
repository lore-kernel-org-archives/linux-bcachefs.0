Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31638E92719
	for <linux-bcachefs@archiver.kernel.org>; Thu,  5 Oct 2023 14:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbjJEOng (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236709AbjJEOki (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 5 Oct 2023 10:40:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C86E2DE6E
        for <linux-bcachefs@vger.kernel.org>; Thu,  5 Oct 2023 07:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696515030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5vb2hJxwNALK0ItKBrSQxuAZCeV02gpmdBWkQg3vwNs=;
        b=f+9UiVRRmX5Dm1SfQ3+pOvFW2BX0FryJGy5PQqGKYB8YRfxxGa9D+ufvMwzZFhzSfNzVCr
        RNA8ihqH9RCAdU8tAQ58lQMfIL6kPNrI2dDA1iBnGwDZvxHgsVxJT9LPdsQasaSuZs/Jfr
        1Thv19h1E0xYIiCQH83vrGX+k/ClM7A=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-dyOBP8aqOhCoh69q52_2ng-1; Thu, 05 Oct 2023 08:08:43 -0400
X-MC-Unique: dyOBP8aqOhCoh69q52_2ng-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1dcdb642868so1324053fac.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 05 Oct 2023 05:08:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696507722; x=1697112522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5vb2hJxwNALK0ItKBrSQxuAZCeV02gpmdBWkQg3vwNs=;
        b=ZvXC4+Qx+V3g6WPKrsBpk91EnnAB3/jVFuVk3/kazg1cYFa1qQw5CjIXJ3H0UTdX8u
         iNyQBKP6OfFPCrnvllVsb3+PtI0CslckQ4SurVUGVw0hfWMWlQc76d9ghGZqsJmz6Jge
         Wan8ySTrf2BVL0bY2IUHED0bd2cJ5qQMIt7RrB2ZdXzdzQeLnc5gfgh8wVWuMXfq1TBH
         LjUN+06iTQeL44xpjemZdTGQ6xYIcdtRBtFn8xsvQDN8hon11wloOoklTEZf/gmahzPe
         7exCnJveSSN/m94tfhZZqIxk2MKcEPGvGij9ByZrFeZesSmsgxnM1dNvGZysZM20ncSB
         34cw==
X-Gm-Message-State: AOJu0YxgXa5ONryIa3KRu3frH5penzHtFFJMwbqHRX5XKvJk7MlbTyPM
        As4w1nYle+7jF8RLygO5jXq3b+rMpEEAsteBR60NLxtLYnqqwL/DI+tAq6SEv6rvwPAKVXhMgmv
        P5y/pqJUcGDqE7h65ouccChvTXBSylvI68aU=
X-Received: by 2002:a05:6870:31cd:b0:1bb:583a:db4a with SMTP id x13-20020a05687031cd00b001bb583adb4amr5648225oac.44.1696507722480;
        Thu, 05 Oct 2023 05:08:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlVzvkaGp66pHg11s+DjVKpK1U4zUytQRnNDD6fm7TMLdBw8lYi1FuciqL0IBF8B/oLwXbwA==
X-Received: by 2002:a05:6870:31cd:b0:1bb:583a:db4a with SMTP id x13-20020a05687031cd00b001bb583adb4amr5648208oac.44.1696507722222;
        Thu, 05 Oct 2023 05:08:42 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id h8-20020a05620a13e800b007757868e75csm429739qkl.117.2023.10.05.05.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 05:08:41 -0700 (PDT)
Date:   Thu, 5 Oct 2023 08:08:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 20/89] bcachefs: convert to new timestamp accessors
Message-ID: <ZR6nWs/kFcw0+0ib@bfoster>
References: <20231004185221.80802-1-jlayton@kernel.org>
 <20231004185347.80880-1-jlayton@kernel.org>
 <20231004185347.80880-18-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004185347.80880-18-jlayton@kernel.org>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 04, 2023 at 02:52:05PM -0400, Jeff Layton wrote:
> Convert to using the new inode timestamp accessor functions.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---

Acked-by: Brian Foster <bfoster@redhat.com>

>  fs/bcachefs/fs.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index 09137a20449b..1fbaad27d07b 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -66,9 +66,9 @@ void bch2_inode_update_after_write(struct btree_trans *trans,
>  	inode->v.i_mode	= bi->bi_mode;
>  
>  	if (fields & ATTR_ATIME)
> -		inode->v.i_atime = bch2_time_to_timespec(c, bi->bi_atime);
> +		inode_set_atime_to_ts(&inode->v, bch2_time_to_timespec(c, bi->bi_atime));
>  	if (fields & ATTR_MTIME)
> -		inode->v.i_mtime = bch2_time_to_timespec(c, bi->bi_mtime);
> +		inode_set_mtime_to_ts(&inode->v, bch2_time_to_timespec(c, bi->bi_mtime));
>  	if (fields & ATTR_CTIME)
>  		inode_set_ctime_to_ts(&inode->v, bch2_time_to_timespec(c, bi->bi_ctime));
>  
> @@ -753,8 +753,8 @@ static int bch2_getattr(struct mnt_idmap *idmap,
>  	stat->gid	= inode->v.i_gid;
>  	stat->rdev	= inode->v.i_rdev;
>  	stat->size	= i_size_read(&inode->v);
> -	stat->atime	= inode->v.i_atime;
> -	stat->mtime	= inode->v.i_mtime;
> +	stat->atime	= inode_get_atime(&inode->v);
> +	stat->mtime	= inode_get_mtime(&inode->v);
>  	stat->ctime	= inode_get_ctime(&inode->v);
>  	stat->blksize	= block_bytes(c);
>  	stat->blocks	= inode->v.i_blocks;
> @@ -1418,8 +1418,8 @@ static int inode_update_times_fn(struct btree_trans *trans,
>  {
>  	struct bch_fs *c = inode->v.i_sb->s_fs_info;
>  
> -	bi->bi_atime	= timespec_to_bch2_time(c, inode->v.i_atime);
> -	bi->bi_mtime	= timespec_to_bch2_time(c, inode->v.i_mtime);
> +	bi->bi_atime	= timespec_to_bch2_time(c, inode_get_atime(&inode->v));
> +	bi->bi_mtime	= timespec_to_bch2_time(c, inode_get_mtime(&inode->v));
>  	bi->bi_ctime	= timespec_to_bch2_time(c, inode_get_ctime(&inode->v));
>  
>  	return 0;
> -- 
> 2.41.0
> 

