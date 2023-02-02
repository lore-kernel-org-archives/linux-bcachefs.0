Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB1BC05027
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Feb 2023 22:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbjBBWj2 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbjBBWj2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Feb 2023 17:39:28 -0500
Received: from out-219.mta0.migadu.com (out-219.mta0.migadu.com [IPv6:2001:41d0:1004:224b::db])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1025D170E
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Feb 2023 14:39:27 -0800 (PST)
Date:   Thu, 2 Feb 2023 17:39:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675377565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rGfzgr8CunvMyj4fUOvu5IhE82oypVBj04LQkga8toc=;
        b=wsNjBNnYRtiiihvKs00g6fG64sH+GrzBik2aW/O9UiwNMqk8zuGoO6BvwpyIdFxJsPMKf7
        oPQbxTC5q9LTfMypXJZ52zrZfXDU52rdnNU/695HJPcj+CoDbWemJhNYbYG0FrV24eHpWK
        B+Nh3A3ZFF9/loLrj3tHm2JLfT+T1L0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Freezing (was: Re: fstests generic/441 -- occasional bcachefs
 failure)
Message-ID: <Y9w7lApSDjof07cc@moria.home.lan>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9p4ihwzFs0OP6to@moria.home.lan>
 <Y9vbv7TFyu+stccD@bfoster>
 <Y9vuQHtYOhAOqPF1@moria.home.lan>
 <Y9wXRmo6zYAQCOx1@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9wXRmo6zYAQCOx1@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Feb 02, 2023 at 03:04:22PM -0500, Brian Foster wrote:
> I need to use GitLab for other things so I managed to create a project
> cloning your repo there and pushed a testing branch with both of those
> commits. I think it should be accessible here:
> 
> https://gitlab.com/bfoster2/bcachefs.git bf-bcachefs-testing

You've been added:
https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

If results don't show up right away it's because I just rewrote the CI's
configuration file handling - generally only takes ~20 minutes though.
