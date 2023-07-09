Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FCFEB64DC
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 20:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjGIUIK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 16:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjGIUIJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 16:08:09 -0400
Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [IPv6:2001:41d0:203:375::c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B937D1
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 13:08:08 -0700 (PDT)
Date:   Sun, 9 Jul 2023 16:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688933285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C2rLWo3qXwrkajVNFpM6cadOxC2jV3HihzHHSdapsPI=;
        b=eNNrVNQ+rivGeB96kJ3NscjVYHSun7P/SqzKAGtLL60ROQejA4ypvmx8t2fnIlwusAutPR
        BrFOaU7bK2VIplb5FuY6ACyMvd28S+sT86CMf3PC890OZHBfK/NMDpWXSftFiJlDcXJzOF
        09ei8mK5FSjkJ09DbyQMrfy87/p70jo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Cc:     linux-bcachefs@vger.kernel.org, bfoster@redhat.com,
        sandeen@redhat.com
Subject: Re: [PATCH 10/10] bcachefs: bcachefs_metadata_version_major_minor
Message-ID: <20230709200801.6k5ymhq46nnltznj@moria.home.lan>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
 <20230709171551.2349961-11-kent.overstreet@linux.dev>
 <4f717f9c-babe-467d-9b56-7e36fa5e2342@t-8ch.de>
 <20230709183122.y5qw53k43kuzxmic@moria.home.lan>
 <6bfa02f4-380c-48e9-911f-dfbb533736ca@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bfa02f4-380c-48e9-911f-dfbb533736ca@t-8ch.de>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Jul 09, 2023 at 09:29:00PM +0200, Thomas Weißschuh wrote:
> On 2023-07-09 14:31:22-0400, Kent Overstreet wrote:
> > Minor releases are going to be much more common than major releases:
> > thus, I'm using 10 bits for the minor number and 6 bits for the major.
> 
> Sounds good. But can this be reflected in the definition of
> BCH_VERSION_MINOR?
> Currently it only supports 8 bits.
> 
> Something like:
> 
> #define BCH_VERSION_MINOR(_v)		((__u16) ((_v) & 0x03ff))

Ah, good catch. Changing it to:
#define BCH_VERSION_MAJOR(_v)           ((__u16) ((_v) >> 10))                                                                                                                                                                                                                           
#define BCH_VERSION_MINOR(_v)           ((__u16) ((_v) & ~(~0U << 10)))
