Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70617C4167B
	for <linux-bcachefs@archiver.kernel.org>; Tue, 13 Dec 2022 23:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbiLMXcY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 13 Dec 2022 18:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbiLMXcX (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 13 Dec 2022 18:32:23 -0500
Received: from out-207.mta0.migadu.com (out-207.mta0.migadu.com [IPv6:2001:41d0:1004:224b::cf])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98953E7A
        for <linux-bcachefs@vger.kernel.org>; Tue, 13 Dec 2022 15:32:22 -0800 (PST)
Date:   Tue, 13 Dec 2022 18:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670974340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RGoyMmyRJj4zFm3tLcZotGvUnMaNs0s1lTCcjgoTQmA=;
        b=gnmU8xfVjfQU9rddfCUwvehjT0Aic/XiuOGDlRwFkZaYDGK9E1ROFYs+Ei40hh8WQL4cLm
        rY82L4Ivw+5QjDevJenxuevWI+24qkHd3i6koMShy24JjfmtkL0qD8YllBOmDOG7IBDKDX
        qoLd5sUSTA5PM+FEXT2ys1cao9pzlSY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] trace_printk() broken?
Message-ID: <Y5kLgQh3NVMmUr8W@moria.home.lan>
References: <Y5d/B88BOu6qOE5X@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5d/B88BOu6qOE5X@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Dec 12, 2022 at 02:20:39PM -0500, Brian Foster wrote:
> Hi,
> 
> While poking around the bcachefs tree I ran into a problem where
> trace_printk() seems to be broken. I suspect this has something to do
> with the printbuf bits as it works once I back out some of those
> changes.
> 
> What I observe is that a smaller printk with a fixed string seems to
> work as expected, but once I add some variable args the message string
> seems to get chewed up. This results in wonky formatting when reading
> /sys/kernel/debug/tracing/trace and a read of the corresponding
> trace_pipe file seems to spin in a livelock.

I recently noticed it was broken too, but different symptoms - I wasn't getting
any output at all. Thanks for the reminder, I'll have a look soon.
