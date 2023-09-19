Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20EACE79A8
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Sep 2023 21:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjISVFA (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 17:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjISVE7 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 17:04:59 -0400
Received: from out-226.mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAA3BF
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 14:04:54 -0700 (PDT)
Date:   Tue, 19 Sep 2023 17:04:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695157492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cs7FoPlziD0fCfVc7+uUoqWQB3Wso2F7TD40bXXppxk=;
        b=pRFUD91bvmlFZq2fDjXyppd/M/JsZ6Ky4hRgMHQc1IMS7177dUsnfcCIsF8LUoEHQ8auX2
        +W7Iv7SVnAQlXG5MGXK+LAotjXXQceoX7zbKZDKIqRckHe+N7eSNcN2LbiVY1q4KcQAWzO
        Kg9g3cN9KQTE9xGqByCJ2jI5kkXGAC8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] bcachefs: snapshot: Add missing assignment in
 bch2_delete_dead_snapshots()
Message-ID: <20230919210448.ruhwcevlvrnidlrl@moria.home.lan>
References: <2e12e803-5268-4ed7-885d-c813e9b876ac@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e12e803-5268-4ed7-885d-c813e9b876ac@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 03:56:37PM +0300, Dan Carpenter wrote:
> This code accidentally left out the "ret = " assignment so the errors
> from for_each_btree_key2() are not checked.
> 
> Fixes: 53534482a250 ("bcachefs: for_each_btree_key2()")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Thanks, applied
