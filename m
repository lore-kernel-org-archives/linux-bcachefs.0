Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7ABC4332F
	for <linux-bcachefs@archiver.kernel.org>; Fri, 30 Dec 2022 03:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiL3DTM (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 29 Dec 2022 22:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiL3DTL (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 29 Dec 2022 22:19:11 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D73113F9B
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 Dec 2022 19:19:04 -0800 (PST)
Date:   Thu, 29 Dec 2022 22:18:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672370342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5vyqxFB0oo6cjR2ho4GkK+p0lxbXqPfWC7/vPDOH5Ec=;
        b=ePykq4ShB4e5n5IPVI1T1hP1UX54H/VsAhp6o4+pRW35l7lyIEPTR/+pKjS5O8qd+rxde3
        C14sM6nGem+GFFkMzKYKJjYEwTBYzLkVIZ73EQ9twk7eNbr/6KlKZUvT24xpXt1R3XpTC7
        4ryPdwiEAI02M/eXkr15QOGTPW3UC8s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Eric Wheeler <bcachefs@lists.ewheeler.net>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y65Yo/3VCJ/lVUbO@moria.home.lan>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
 <Y5wYjUhTAzhSIvM3@moria.home.lan>
 <Y6CGUZhqs5ABBIbO@bfoster>
 <Y6EWZ3IODBa0e0lT@moria.home.lan>
 <1bfa9aed-44c1-8217-9d6a-a594524ab0a0@ewheeler.net>
 <Y63/ygc7d4S97JtM@moria.home.lan>
 <461e41da-708b-8b10-8b96-341f4188a34@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461e41da-708b-8b10-8b96-341f4188a34@ewheeler.net>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Dec 29, 2022 at 02:26:03PM -0800, Eric Wheeler wrote:
> That would be great!

Certainly would be. Going to be awhile with current resources, though.
