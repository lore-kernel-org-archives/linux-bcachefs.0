Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF691C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 23:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjHLXes (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 19:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjHLXer (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 19:34:47 -0400
Received: from out-117.mta1.migadu.com (out-117.mta1.migadu.com [IPv6:2001:41d0:203:375::75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DA5171F
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 16:34:49 -0700 (PDT)
Date:   Sat, 12 Aug 2023 19:34:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691883287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a2hNqupa5UANpVrXtgUOTFrVTv6RA7H08yVTk1/U6No=;
        b=WbFc/dYDwqEQkZwdD2hRW+yxKBIkU0oLv8baWtkLSvM+kP9GnvJUWKVG626zqZLpN4bM3+
        o86oad3A55ZMVvQ7eaTKg4bktSeKKjQq+OwoUevYw+q+vQ+xvPrUAJVdaUs9qd2xvLafQB
        yHD96Ji62LUzL52ZIE37tQ1evF0lCDE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org,
        =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [v2 3/3] bcachefs: Implement casefolding
Message-ID: <20230812233445.nmo6p5w5oap2ynof@moria.home.lan>
References: <20230812212647.490829-1-joshua@froggi.es>
 <20230812212647.490829-4-joshua@froggi.es>
 <20230812224506.nplzn2chz63xbiyb@moria.home.lan>
 <c72eb610-5c52-4aa7-9643-e783daf00978@froggi.es>
 <20230812230252.amixsrv4zp3uyjpc@moria.home.lan>
 <e338f5aa-72a0-4a9f-b0f0-b29d1dd516f3@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e338f5aa-72a0-4a9f-b0f0-b29d1dd516f3@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Aug 13, 2023 at 12:04:27AM +0100, Joshua Ashton wrote:
> Are you sure? That would make moving files between directories potentially
> fail when going from regular -> casefolded which seems very wrong...
> 
> The whole reason for the fallback is so that this situation doesn't happen
> because it seems like it would break basically every userspace application.

Yeah let's just reduce BCH_NAME_MAX like we were talking about then.
This is the time to do it if we're going to, before merging.
