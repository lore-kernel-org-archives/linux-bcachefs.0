Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43564EB64DA
	for <linux-bcachefs@archiver.kernel.org>; Thu, 20 Jul 2023 22:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjGTW1s (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 20 Jul 2023 18:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjGTW1s (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 20 Jul 2023 18:27:48 -0400
Received: from out-40.mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D694A114
        for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jul 2023 15:27:46 -0700 (PDT)
Date:   Thu, 20 Jul 2023 18:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689892065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3dIX/xOuvYeIp/nU0G34LvH/0CpHz862zXeSciMfRmo=;
        b=DdZ2CRVu/MkT7HtnyNZqWSAOlbYnRWOhihEctybv4SP9RfyhpJ5QvLRmFlt8bMT3gKoz6b
        6NFlVm7LV0/fsZEA+2vnIWfMtc2GsSxGfaT3UGyBVprHabZJwxU1np3XYi/Bl5GyZ5hLrO
        qupkAdULmXJjbLRv8Jif++6gD2auUl8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Brian Foster as a reviewer for bcachefs
Message-ID: <20230720222741.obhk7ta2gdvpidp5@moria.home.lan>
References: <20230720130033.5730-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720130033.5730-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Jul 20, 2023 at 09:00:33AM -0400, Brian Foster wrote:
> Brian has been playing with bcachefs for several months now and has
> offerred to commit time to patch review.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Applied :)
