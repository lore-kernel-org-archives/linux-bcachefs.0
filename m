Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F401CEB64D9
	for <linux-bcachefs@archiver.kernel.org>; Mon, 10 Jul 2023 16:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjGJQlb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 10 Jul 2023 12:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGJQla (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 10 Jul 2023 12:41:30 -0400
Received: from out-47.mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27C212B
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jul 2023 09:41:28 -0700 (PDT)
Date:   Mon, 10 Jul 2023 12:41:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689007286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=fE9HLq2D3bbcbrtonmy8SYvKYdr7dPe99IuPrx6LP38=;
        b=e7zsj30rYoqhF3z41bTAN0V6otomQbkRWoyoAq92Lvq6sttnzLnW6NqAopHVsjeAjWHEAQ
        ulJMa1Xwuy/HK4VQ8IYBqiGdAfnic0HXo1zOFipyIaMAW9Pwn+QrEUhAMuL/KDtibsWmDL
        GuFVaXpP+eMlA21Vb9Y1w7Mcin1z4jo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [biweekly bcachefs cabal]
Message-ID: <20230710164123.za3fdhb5lozwwq6y@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Cabal meeting is tomorrow at 1 pm eastern.

We'll be talking about upstreaming, gathering input and deciding what
still needs to be worked on - shoot me an email if you'd like an invite.

Cheers,
Kent
