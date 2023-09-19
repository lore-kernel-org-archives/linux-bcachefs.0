Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B509CE79A8
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Sep 2023 20:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjISUQU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjISUQU (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 16:16:20 -0400
Received: from out-225.mta0.migadu.com (out-225.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125B393
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 13:16:14 -0700 (PDT)
Date:   Tue, 19 Sep 2023 16:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695154572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P0/VcY9yS1Cm6FJ0Vgb8u68w0w5R/Corzi2eI2xWJdg=;
        b=O1DCyMBxKasWOwcRubNor8Fbikm2Saz/SCD/0L4bwU+iX2mahXnrZEgSyMWc9ZQYAJkvDC
        4eQEaRKawQIYm6TTdUdhgJZEKCrJGQmEnMlNWRcTexcihX8DENecs3QhCVH7uAkd2U29d2
        PY+ktQpHfJ1tSrGOgWg6HzwY+pedmoA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] libbcachefs: convert sb features mask to little endian
Message-ID: <20230919201610.y63het6pjx3pkc65@moria.home.lan>
References: <20230915134025.317931-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915134025.317931-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 09:40:25AM -0400, Brian Foster wrote:
> bch_sb.features is an array of __le64. Convert the native endian format
> of the features mask appropriately. This causes a bcachefs format to
> produce an unmountable fs when run from a big endian system.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Thanks, applied
