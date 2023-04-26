Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB377C77B60
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 14:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbjDZOdO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 10:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240647AbjDZOdN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 10:33:13 -0400
X-Greylist: delayed 82778 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Apr 2023 07:33:11 PDT
Received: from out-4.mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49378109
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 07:33:10 -0700 (PDT)
Date:   Wed, 26 Apr 2023 10:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682519588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gO2Yy91s7s3hi6gjqiFCjueYG8Bx9s/0AXJsnPArYs4=;
        b=u3DiOLwavEv33KpkY2A++adNpfjH75z/qgQ8WusVZ1vwXQtPrOKd06K2wVA2QDt8yeQ7tD
        zhKRmvv1pvldz+IpFtb8174EqMEnUkUX1FkeVhxm4tH4q+JVcLyU/tfKg4fRKh/2qoOWCz
        29YhIGCVj6Uu6qSl6x6/IJ3rhcux1Mw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] A small compile fix
Message-ID: <ZEk2IBWDkmu5gkQ7@moria.home.lan>
References: <alpine.LRH.2.21.2304260820020.428@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2304260820020.428@file01.intranet.prod.int.rdu2.redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Apr 26, 2023 at 08:31:10AM -0400, Mikulas Patocka wrote:
> Hi
> 
> Here I'm sending a small compile fix for bcachefs-tools.

Signed-off-by?
