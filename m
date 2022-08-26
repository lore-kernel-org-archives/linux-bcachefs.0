Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84A7ECAAA3
	for <linux-bcachefs@archiver.kernel.org>; Fri, 26 Aug 2022 15:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241548AbiHZPVf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 26 Aug 2022 11:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244045AbiHZPVQ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 26 Aug 2022 11:21:16 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCFE8E99D
        for <linux-bcachefs@vger.kernel.org>; Fri, 26 Aug 2022 08:15:02 -0700 (PDT)
Date:   Fri, 26 Aug 2022 11:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661526900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sz1MYj27/6c/zyB6ifGQv0RxrzHfiKpgXxJdGUSsOi0=;
        b=jUrYXGVhilYoDnjhXcirdD9ylSHLh5bkcOOduDmpG8ygpUERqmb2S8JRJ3xCA19vgZREfo
        EmDV2/31z8mdCAgc25nq40XNw5KD2omyksKRbnaRaZK75wkusfaV9C3XoVB/Qv3ZKUHS37
        y+X3osYDMvqoiP9kgHfYExshs4i7OKY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc:     "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Which git to test against? Which branch?
Message-ID: <20220826151457.pxkcrbuaodg2o6xx@moria.home.lan>
References: <590771559.530.1660788437769@mail.carlthompson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <590771559.530.1660788437769@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Aug 17, 2022 at 07:07:17PM -0700, Carl E. Thompson wrote:
> Sorry for the basic questions. I have compiled bcachefs from the master branch
> of the evilpiepirate.org git repository and I've experienced some issues so I
> want to make sure I'm using the expected code before reporting bugs.
> 
> Should I be using the github git repository instead? Are they the same?

They are the same, the github repository is a mirror.

> Should I be using the "master" branch or would either the "bcachefs-testing"
> or "bcachefs-5.17" branches be more appropriate for bug reporting?

Master branch.

> Should I post potential bugs and other issues to this list for discussion
> before opening an issue on github? If github is the way to start what should I
> be using this list for (if anything)?

Github is what we've been using - this list is a welcome place for other
questions and discussions, though.

Cheers,
Kent
