Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41DDC4332F
	for <linux-bcachefs@archiver.kernel.org>; Fri,  3 Nov 2023 15:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjKCPSa (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 3 Nov 2023 11:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjKCPS3 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 3 Nov 2023 11:18:29 -0400
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13A91B2
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 08:18:23 -0700 (PDT)
Date:   Fri, 3 Nov 2023 11:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1699024701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yig9TLqmrEGPGtGxiqPVMpxyPcsgv5Il544h4WaYoXU=;
        b=YT9peC+r+hYBV4EvWktFXBLuZENTyhZi6bXME+Z2DWBVmyX+ftFVHcbYjEDmMprEkTakBp
        WcLEsIhTbVkJk9/zGag3SazNMQybhrXcnZZgbakqpIAgXL3wDkv27btFIP+AE8U1AOX8CR
        E2AYObko9auypR8ipD1DVoUqPTRpxvw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/3] bcachefs: writeback and byte-order misc fixes
Message-ID: <20231103151818.whnx5qhiolouexpb@moria.home.lan>
References: <20231103130938.8925-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103130938.8925-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Nov 03, 2023 at 09:09:35AM -0400, Brian Foster wrote:
> Hi all,
> 
> This series is a repost of a handful of patches that happened to have
> fallen through the cracks. Patch 1 relates back to the discussion[1] on
> increasing the writeback bio size limit. We can't safely do that until
> the bounce path can be enhanced to handle larger sizes, but we can at
> least fix the writeback code to completely fill the bio. Patches 2-3 are
> a couple more byte order fixes that were uncovered by swapping an
> on-disk filesystem between big and little endian machines. As of these
> two, I've not encountered any further byte-order issues via this sort of
> test.
> 
> All three of these patches have been soaking in my test branch [2] for
> quite some time. Thoughts, reviews, flames appreciated.
> 
> Brian
> 
> [1] https://lore.kernel.org/linux-bcachefs/20230927112338.262207-3-bfoster@redhat.com/
> [2] https://evilpiepirate.org/~testdashboard/ci?branch=bfoster
> 
> Brian Foster (3):
>   bcachefs: allow writeback to fill bio completely
>   bcachefs: byte order swap bch_alloc_v4.fragmentation_lru field
>   bcachefs: use swab40 for bch_backpointer.bucket_offset bitfield

These will all go out in the next pull request.
