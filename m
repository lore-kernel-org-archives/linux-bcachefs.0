Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3230BC4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 14:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjKBOlO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Nov 2023 10:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjKBOlN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Nov 2023 10:41:13 -0400
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5162712D
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Nov 2023 07:41:07 -0700 (PDT)
Date:   Thu, 2 Nov 2023 10:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698936065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NemcznI6CFrmauqtmhmnzLISxGf7uTBeCQziTwhtJLI=;
        b=BeVU7LvhdEdPeElUN5uoUxotOp+poRCy/go2yMsDNRRsn7VTRPd116X2Q+j5C3d6QHfmNN
        JpueY/16EFSzieivA+qpGKAefbZgcUHuyOyPq93L0nkJo88nDeVdn6vdy+PzseMmYkm2dP
        oUQab49gMJ2nvHfdvuXKGtG5b6oWZMI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Hannu Krosing <hannuk@google.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: A question on bcachefs as a Cluster File System
Message-ID: <20231102144102.o5vfyhq6x2nhm7x3@moria.home.lan>
References: <CAMT0RQRwBLBBp7ufmk3mrAaVAQxPKxiGEK5t+qvE+ftRnfyvmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMT0RQRwBLBBp7ufmk3mrAaVAQxPKxiGEK5t+qvE+ftRnfyvmA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Nov 02, 2023 at 01:48:25PM +0100, Hannu Krosing wrote:
> What is the current thinking around using bacachefs as a cluster file
> system (CFS)?
> 
> By CFS I mean a file system which can be mounted concurrently from
> many hosts or VMs.
> 
> At high level it looks like it should be something quite easy to
> accommodate, bcachefs having grown out of caching work and the main
> difference between CFS and non-cluster FS being the ability to
> guarantee cache coherency.
> 
> So what are your thoughts on this, assuming that bcachefs is runnning
> on a storage that is already available for all the hosts/VMs, what is
> missing and how hard would it be to get there ?
> 
> I did not find anything about CFS support in the
> https://bcachefs.org/FAQ/ or other pages.

No, bcachefs would not be a good basis for a traditional shared storage
cluster filesystem.

Shared nothing, OTOH...
