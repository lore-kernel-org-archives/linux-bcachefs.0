Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52BDEB64DC
	for <linux-bcachefs@archiver.kernel.org>; Thu, 29 Jun 2023 14:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjF2ORx (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 29 Jun 2023 10:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjF2OR3 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 29 Jun 2023 10:17:29 -0400
Received: from out-44.mta0.migadu.com (out-44.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946D43ABA
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 Jun 2023 07:17:26 -0700 (PDT)
Date:   Thu, 29 Jun 2023 10:17:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688048244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DKrnz+W/nASeTvI2m5rihq8Vu8AaDzfBpZEnQuUWDrg=;
        b=Cv/UrAiTJ2JYxWCoo+8oIugJpJagLZXRwKwRPcfKPfQzSzPqlyqWrW1XnoQKw71wlOtjC1
        onHU6QvrbYaYPObQc7+ZiDEoqDDxF49+whR7haigl85l6lkXZNI3odL7YRIf8AdQse/IOr
        ayXZHgPluajhNzj7ih50S1uEqtopDUY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] bcachefs
Message-ID: <20230629141719.4pwvpd4q5fow6zwu@moria.home.lan>
References: <e1570c46-68da-22b7-5322-f34f3c2958d9@kernel.dk>
 <2e635579-37ba-ddfc-a2ab-e6c080ab4971@kernel.dk>
 <20230628221342.4j3gr3zscnsu366p@moria.home.lan>
 <d697ec27-8008-2eb6-0950-f612a602dcf5@kernel.dk>
 <20230628225514.n3xtlgmjkgapgnrd@moria.home.lan>
 <1e2134f1-f48b-1459-a38e-eac9597cd64a@kernel.dk>
 <20230628235018.ttvtzpfe42fri4yq@moria.home.lan>
 <ZJzXs6C8G2SL10vq@dread.disaster.area>
 <d6546c44-04db-cbca-1523-a914670a607f@kernel.dk>
 <20230629-fragen-dennoch-fb5265aaba23@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230629-fragen-dennoch-fb5265aaba23@brauner>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Jun 29, 2023 at 01:18:11PM +0200, Christian Brauner wrote:
> There seems to be a wild misconception here which frankly is very
> concering. Afaik, it is absolutely not the case that an fput() from an
> exiting task ends up in delayed_work(). But I'm happy to be convinced
> otherwise.

I already explained the real issue - it's fput() from an AIO completion,
because that has no association with task it was done on behalf of.
