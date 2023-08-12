Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F75C001E0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 23:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjHLXC7 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 19:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjHLXC6 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 19:02:58 -0400
Received: from out-116.mta1.migadu.com (out-116.mta1.migadu.com [IPv6:2001:41d0:203:375::74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E69110E3
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 16:02:59 -0700 (PDT)
Date:   Sat, 12 Aug 2023 19:02:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691881377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BYmtvXzEQu/oce+S195wf9MNgk6bbxcTUDpEE7Y86vA=;
        b=Kvf1/JLQm4jU/2Kiiro86FJTxKILAlMVvzhra0eGWxh7hOIUP5bwgQIvASuWO1UgW6bWRM
        FNzlLIjifMDuGKOPWzLRguKlKhKA9Q0kVUia3E3OPs6crIpER0utiWZHMw6UAMWLcARoqJ
        arSb2euQCgAMY8qg+a7HSifcmwAf6a8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org,
        =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [v2 3/3] bcachefs: Implement casefolding
Message-ID: <20230812230252.amixsrv4zp3uyjpc@moria.home.lan>
References: <20230812212647.490829-1-joshua@froggi.es>
 <20230812212647.490829-4-joshua@froggi.es>
 <20230812224506.nplzn2chz63xbiyb@moria.home.lan>
 <c72eb610-5c52-4aa7-9643-e783daf00978@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c72eb610-5c52-4aa7-9643-e783daf00978@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Aug 12, 2023 at 11:54:46PM +0100, Joshua Ashton wrote:
> There is the edgecase of it being too big to cache the casefolding in the
> dirent. That's what I mean by that.

Yeah, let's just not allow dirents that are that long.
