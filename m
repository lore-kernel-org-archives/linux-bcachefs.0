Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083F2C001DF
	for <linux-bcachefs@archiver.kernel.org>; Mon, 24 Jul 2023 17:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjGXRM2 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjGXRM1 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 24 Jul 2023 13:12:27 -0400
Received: from out-22.mta1.migadu.com (out-22.mta1.migadu.com [IPv6:2001:41d0:203:375::16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EEE1B5
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Jul 2023 10:12:26 -0700 (PDT)
Date:   Mon, 24 Jul 2023 13:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690218744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VKSf0oZWYPnjPRt9gJl7F0xlMmr74HTsGzCMo7Ce264=;
        b=W52ixk3T6SnPvO4uvIgowf9EYtwJoAfgssjcL2sMW7Z5ItaNsTBL7vPhMcU/7k6ZmoyrEI
        zFMrr2RegQKwKLlz969P7QDrYkj6Z8wLTTAVugfAuM1MRgugRFFTkZ7XW7TfK4nv0zmvFE
        fzIYZju3l7fzY2K0/rVu//FwqWE/V4o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Christian Brauner <brauner@kernel.org>
Cc:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [biweekly bcachefs cabal]
Message-ID: <20230724171219.ok74izghpoxgtfak@moria.home.lan>
References: <20230710164123.za3fdhb5lozwwq6y@moria.home.lan>
 <20230711-glotz-unmotiviert-83ba8323579c@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711-glotz-unmotiviert-83ba8323579c@brauner>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Jul 11, 2023 at 09:30:57AM +0200, Christian Brauner wrote:
> On Mon, Jul 10, 2023 at 12:41:23PM -0400, Kent Overstreet wrote:
> > Cabal meeting is tomorrow at 1 pm eastern.
> > 
> > We'll be talking about upstreaming, gathering input and deciding what
> > still needs to be worked on - shoot me an email if you'd like an invite.
> 
> I can't make it tomorrow but I'll attend the next one.

Hey, checking in - are you coming to the meeting? It's happening right
now
