Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF24C4332F
	for <linux-bcachefs@archiver.kernel.org>; Sun,  5 Nov 2023 12:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjKEMoz (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 07:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjKEMoz (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 07:44:55 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9992CDB
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 04:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
        t=1699188291; bh=EGNVA88Cy+BhUQRoLhVay+f0GB30mOMRXtX7c+++8vQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBBhaSCynigGjHahKdNXqn1EBQZkPTXvwZxEbVrN++BI3VOAuuFNvPCs3P2wdVthB
         SWlXdVmDZSW+X8gGiGk2QoYC3uf3JmL3LL9Mpz5tRljSsm403s5W68QaBYPeZWv1os
         wQw8VfBnBY+/yyHgO8WYT9MA+Ve2i2z5rtKqvmS4=
Date:   Sun, 5 Nov 2023 13:44:50 +0100
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To:     Mateusz Guzik <mjguzik@gmail.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <abd832ca-c37b-4b4a-af77-2a90b660dfb6@t-8ch.de>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 2023-11-05 13:38:49+0100, Mateusz Guzik wrote:
[..]

> Side note: mkfs.bcachefs warns about xfs being on the volume, but is
> perfectly happy to format an existing bcachefs partition -- perhaps
> this should also ask if it was intended?

mkfs.bcachefs uses libblkid to detect existing filesystems.
libblkid/util-linux only gained bcachefs support in version 2.39.

Furthermore some as-of-now unreleased fixes may be needed for proper
detection of larger superblocks.

Thomas
