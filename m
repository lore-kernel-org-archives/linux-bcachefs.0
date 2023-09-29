Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DEAE71D4A
	for <linux-bcachefs@archiver.kernel.org>; Fri, 29 Sep 2023 15:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjI2PRb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 29 Sep 2023 11:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbjI2PRb (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 29 Sep 2023 11:17:31 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C73494
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Sep 2023 08:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
        t=1696000645; bh=ux9IvD2Wsm+baVov2jYz+P/vMrfR2gwXA7pAijgiwpA=;
        h=Date:From:To:Subject:From;
        b=i7lmsqgj/ji9VU7CPM25cIBRk6t4yMwLB32nxUEOZqCCvJrbLTuktqO3Gz4dpvnjD
         bbECEkK8gwX6RC3AWK5ZgPNfjZT9aXj3zZLRPX80vwTPw0I+4+Nas5HyniuxrsLJvi
         wasPblZFT3xg6dbi7PUeO/e3Z41F8dpldGHkU62g=
Date:   Fri, 29 Sep 2023 17:17:24 +0200
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To:     linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>
Subject: bcachefs-tools for members v2
Message-ID: <063cc43e-0c7f-4bb1-ad8f-7ca05a62c1cf@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi,

I'd like to extend libblkid/util-linux to handle the new members v2
format. We are using the superblock members to calculate the overall
filesystem size and per-device UUIDs.

While I found the kernel part, I did not so for the userspace part.
Could you give me a hint?

Also it would be great to know when the new members v2 layout is
considered stable.

Thanks,
Thomas
