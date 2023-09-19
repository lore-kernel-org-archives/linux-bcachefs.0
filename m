Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F591CE79A8
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Sep 2023 21:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbjISVMU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 17:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbjISVMT (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 17:12:19 -0400
Received: from out-224.mta1.migadu.com (out-224.mta1.migadu.com [IPv6:2001:41d0:203:375::e0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D70BD;
        Tue, 19 Sep 2023 14:12:13 -0700 (PDT)
Date:   Tue, 19 Sep 2023 17:12:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695157932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bav2djDV+PM9kbIF64GnzTmiTMErRPGs9jWlEecCNjQ=;
        b=g03OTHbpAfTpO3anyFgIqLlQfQLr+DVnsJdhCS/txdr8Lz5G4T5F+D1fdbbwYyjQMGAqsC
        T6igs98VQv8/dTAhCFM79PN3yZWFHTW2XYfDAIy7HQwfLK7e8musnGcbu+Ki2SOmIp9URk
        Si4GWyYnhE6SBa+vqLJwow1tup8Kf4I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] bcachefs: debug: Fix copy_to_user() error code in
 flush_buf()
Message-ID: <20230919211209.5zc422kjdquql35e@moria.home.lan>
References: <3036fd4e-5d22-44f2-9f51-6eb137452984@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3036fd4e-5d22-44f2-9f51-6eb137452984@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 03:56:26PM +0300, Dan Carpenter wrote:
> The copy_to_user() function returns the number of bytes remaining to
> be copied but we want to return -EFAULT to the user.
> 
> Fixes: e0750d947352 ("bcachefs: Initial commit")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  fs/bcachefs/debug.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
> index 404148bd348a..e65c0ab0c9ad 100644
> --- a/fs/bcachefs/debug.c
> +++ b/fs/bcachefs/debug.c
> @@ -319,10 +319,9 @@ static ssize_t flush_buf(struct dump_iter *i)
>  {
>  	if (i->buf.pos) {
>  		size_t bytes = min_t(size_t, i->buf.pos, i->size);
> -		int err = copy_to_user(i->ubuf, i->buf.buf, bytes);
>  
> -		if (err)
> -			return err;
> +		if (copy_to_user(i->ubuf, i->buf.buf, bytes))
> +			return -EFAULT;
>  
>  		i->ret	 += bytes;
>  		i->ubuf	 += bytes;
> -- 
> 2.39.2
> 

Applying this fix instead:

From 60a714b71846c3ea95ccad6699658890b24969c2 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Tue, 19 Sep 2023 17:09:22 -0400
Subject: [PATCH] bcachefs: Fix copy_to_user() usage in flush_buf()

copy_to_user() returns the number of bytes successfully copied - not an
errcode.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
index 404148bd348a..2c365bf25aca 100644
--- a/fs/bcachefs/debug.c
+++ b/fs/bcachefs/debug.c
@@ -319,16 +319,19 @@ static ssize_t flush_buf(struct dump_iter *i)
 {
 	if (i->buf.pos) {
 		size_t bytes = min_t(size_t, i->buf.pos, i->size);
-		int err = copy_to_user(i->ubuf, i->buf.buf, bytes);
+		int copied = copy_to_user(i->ubuf, i->buf.buf, bytes);
 
 		if (err)
 			return err;
 
-		i->ret	 += bytes;
-		i->ubuf	 += bytes;
-		i->size	 -= bytes;
-		i->buf.pos -= bytes;
-		memmove(i->buf.buf, i->buf.buf + bytes, i->buf.pos);
+		i->ret	 += copied;
+		i->ubuf	 += copied;
+		i->size	 -= copied;
+		i->buf.pos -= copied;
+		memmove(i->buf.buf, i->buf.buf + copied, i->buf.pos);
+
+		if (copied != bytes)
+			return -EFAULT;
 	}
 
 	return i->size ? 0 : i->ret;
