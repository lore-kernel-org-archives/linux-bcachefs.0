Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2767FCE79A9
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 02:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjITC16 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 22:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbjITC1u (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 22:27:50 -0400
Received: from out-223.mta1.migadu.com (out-223.mta1.migadu.com [IPv6:2001:41d0:203:375::df])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D83CFD
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 19:27:27 -0700 (PDT)
Date:   Tue, 19 Sep 2023 22:27:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695176845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r5j44zYTWxmG39NG6QUyCfd6xciwhVPYkfZYvKMs9SY=;
        b=i+7K8EhOULX3ynzuIQVxj708xa3oB7NHjt0vd31o1WcvSnYA5jTm6/cxZUyiDPHwrA/Wkk
        KPlllsgmxzAiI6irHrY2al+TE27zAiBmVi7NmI0N+QFmBJJBdi9lZPLcUuPNgCH0u07WJq
        LGB0fBfNc9liZQeuDqFgJAX+vx07ef0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: Add an ioctl for resizing journal on a
 device
Message-ID: <20230920022722.pmtrokocdaqrkkow@moria.home.lan>
References: <3b879f4f-2fe4-4e0f-aeeb-1d5a62d0a1ce@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b879f4f-2fe4-4e0f-aeeb-1d5a62d0a1ce@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 14, 2023 at 06:03:08PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch f9e4304e0562: "bcachefs: Add an ioctl for resizing journal
> on a device" from Nov 16, 2020 (linux-next), leads to the following
> (unpublished) Smatch static checker warning:
> 
> 	fs/bcachefs/chardev.c:624 bch2_ioctl_disk_resize_journal()
> 	warn: truncating user data 'arg.nbuckets' '0-u64max'
> 
> fs/bcachefs/chardev.c
>     607 static long bch2_ioctl_disk_resize_journal(struct bch_fs *c,
>     608                                    struct bch_ioctl_disk_resize_journal arg)
>     609 {
>     610         struct bch_dev *ca;
>     611         int ret;
>     612 
>     613         if (!capable(CAP_SYS_ADMIN))
>     614                 return -EPERM;
>     615 
>     616         if ((arg.flags & ~BCH_BY_INDEX) ||
>     617             arg.pad)
>     618                 return -EINVAL;
>     619 
>     620         ca = bch2_device_lookup(c, arg.dev, arg.flags);
>     621         if (IS_ERR(ca))
>     622                 return PTR_ERR(ca);
>     623 
> --> 624         ret = bch2_set_nr_journal_buckets(c, ca, arg.nbuckets);
> 
> This is harmless.  arg.nbuckets is a u64 and bch2_set_nr_journal_buckets()
> takes a u32.  However this u32 vs u64 inconsistency with ->nbuckets is
> not just here but also in other places.  (struct journal_device)->nr is
> a u32 for example.  It would be better if it were consistent everywhere.

applying this fix

From 1c0cfb0abe14594347fa0639fe728f068be92deb Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Tue, 19 Sep 2023 22:26:18 -0400
Subject: [PATCH] bcachefs: bch2_ioctl_disk_resize_journal(): check for integer
 truncation

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 51d671267741..e8b6733e7f71 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -627,6 +627,9 @@ static long bch2_ioctl_disk_resize_journal(struct bch_fs *c,
 	    arg.pad)
 		return -EINVAL;
 
+	if (arg.nbuckets > U32_MAX)
+		return -EINVAL;
+
 	ca = bch2_device_lookup(c, arg.dev, arg.flags);
 	if (IS_ERR(ca))
 		return PTR_ERR(ca);
