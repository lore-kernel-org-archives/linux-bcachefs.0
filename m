Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77A7C77B78
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 14:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241504AbjDZOpb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 10:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241536AbjDZOpY (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 10:45:24 -0400
Received: from out-36.mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91D5769C
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 07:45:11 -0700 (PDT)
Date:   Wed, 26 Apr 2023 10:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682520310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gHE6YHjvceIX33nB/k/N6O/wgYP6SxlfHlYo22lTdQ8=;
        b=FXVYtyu0uOdQDcpS3Naqkyj3CMzNIK9e5iQ4DKm4BVP1Nm7HKQvyCdCfLj4dy1ki04UfDz
        2eaizO3S4bA03zLwRoopbWlDtcZHmSvkjTHO26aAPo15LuZ/flaKk4KYgQjb7Y34So13G4
        /Hj8CK9Y49nFz3Z5MpCxk0m0kgPgVgE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] A small compile fix
Message-ID: <ZEk49JKD/Wi+PW/W@moria.home.lan>
References: <alpine.LRH.2.21.2304260820020.428@file01.intranet.prod.int.rdu2.redhat.com>
 <ZEk2IBWDkmu5gkQ7@moria.home.lan>
 <alpine.LRH.2.21.2304261039570.7866@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2304261039570.7866@file01.intranet.prod.int.rdu2.redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Apr 26, 2023 at 10:40:27AM -0400, Mikulas Patocka wrote:
> 
> 
> On Wed, 26 Apr 2023, Kent Overstreet wrote:
> 
> > On Wed, Apr 26, 2023 at 08:31:10AM -0400, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > Here I'm sending a small compile fix for bcachefs-tools.
> > 
> > Signed-off-by?
> 
> Yes, you can add
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Mikulas

Thanks!
