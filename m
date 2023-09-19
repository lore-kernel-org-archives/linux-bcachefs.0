Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206B9CE79AA
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Sep 2023 20:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbjISU6e (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbjISU6c (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 16:58:32 -0400
Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDCABD
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 13:58:26 -0700 (PDT)
Date:   Tue, 19 Sep 2023 16:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695157105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lqrmcPQ2of4Ptk7zUeEdABkiPd53QpePr/YEOy1rQT4=;
        b=BhZ2bUvkvRH/Z5KgPRaC+udLiCbI/RMtQ7VK7y6Z4FagyFYhHyJpNGvSlqAuB4cMDs3ZVP
        V72KnRbpK+nVGR0EV9CnvdtUDTuW5qFl43tKelhGSiSPiL5P1+uV2b0arM1qvh59lc53Gr
        fDewLgAXLnsouTS52SvqtcZkS0olYPo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: acl: Add missing check in bch2_acl_chmod()
Message-ID: <20230919205822.frhzrhtvm45ikzzi@moria.home.lan>
References: <ce3a4798-f467-4776-939b-b094c365cc5c@moroto.mountain>
 <0a0dea2c-23c5-49cb-996c-aa764bdf939e@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a0dea2c-23c5-49cb-996c-aa764bdf939e@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 03:56:07PM +0300, Dan Carpenter wrote:
> The "ret = bkey_err(k);" assignment was accidentally left out so the
> call to bch2_btree_iter_peek_slot() is not checked for errors.
> 
> Fixes: 53306e096d91 ("bcachefs: Always check for transaction restarts")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Thanks, applied
