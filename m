Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FD3C433ED
	for <linux-bcachefs@archiver.kernel.org>; Mon, 26 Apr 2021 08:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A6E0611B0
	for <linux-bcachefs@archiver.kernel.org>; Mon, 26 Apr 2021 08:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhDZI4a (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 26 Apr 2021 04:56:30 -0400
Received: from e246-2.smtp-out.eu-west-3.amazonses.com ([23.251.246.2]:53555
        "EHLO e246-2.smtp-out.eu-west-3.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232114AbhDZI42 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 26 Apr 2021 04:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=axzmos4la3w74ngtxsngrtzf6xjixqeg; d=brouillet.org; t=1619427345;
        h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=8GLbkYGbm8iEHa0vluBOXPEDtFaoudW/iX4LKEVnQ3s=;
        b=DUsnJ1e05mvVIi3gnSojfzunsJaHPHvfdFbPu5Lf0fQ6rlXj/8F+0bWtPrZM9zLg
        1dTHV/9Xsn6h/a+qpjow6AABs8Uj0et1zBONIkQ/DEuwdWYpbidQRQV41jVvI7F7VsZ
        JTxo+mZv6QGiyPJxXmXx21xU5CsiQBHKs1g9GSRo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=2xmcwjqtfc53o6h4t73lgyi3w3u43rzi; d=amazonses.com; t=1619427345;
        h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=8GLbkYGbm8iEHa0vluBOXPEDtFaoudW/iX4LKEVnQ3s=;
        b=hXHDTdI4pvtF0NdBjLsR0oUYz7om3awUTEsc9RaHoWtPc6BGpy5ej/N2dqAPCSyf
        ItB8wIOx39/ygE7aLvzWlrY/YNCGF1AC9VPV22Ak3TWsadI2O69J9oxY51rHdKQGelE
        NnYWZUCEnT2HSZgTTQF2bsL0eSnt9M8ID1oRyuKI=
From:   Marcel Brouillet <marcel@brouillet.org>
Subject: Bcachefs interest. Good or not for my use case ? documentation ?
To:     linux-bcachefs@vger.kernel.org
Message-ID: <011301790d64451a-bf3403eb-a24e-407f-9d9a-eede6ffbc18c-000000@eu-west-3.amazonses.com>
Date:   Mon, 26 Apr 2021 08:55:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr
Feedback-ID: 1.eu-west-3.q74FiVNfnmtxEeagwsOORWMbwqlfbKRSWCmVFkPqYFw=:AmazonSES
X-SES-Outgoing: 2021.04.26-23.251.246.2
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello,

I'm trying this email list, and I hope this isn't considered rude 
posting here.

==> I am interested in Bcachefs for personal use. I have found (and 
sponsor) the Patreon page. I am having a hard time understanding if this 
is for me, or if I should stick with FS types that are shipped with 
Ubuntu. It's hard to understand what all it's features are and if they 
are adequate for my usage.

The documentation that I found so far is https://bcachefs.org/ and 
https://www.patreon.com/bcachefs but it's not easy for me to grasp the 
benefits over the hassle of experimental.

==>_My usage is : for personal use, build a raid storage space for all 
my media (pictures, sound) and files (administration, legal, scans), on 
the following hardware:

- two 5Tb 2.5" HDD Sata
- one 1Tb SSD
- some external USB3 5Tb HDD and/or cloud storage (I plan on using rsync 
or similar, possibly storing md5sum of each file in xattr)

==> My understanding is that using Bcachefs

  *

    + I become one additional tester of the software. Do you need that?

  *

    + I can dedicate a partition of the SSD to cache R/W to the HDD
    RAID. Will I see the difference for 5Mb pictures rarely accessed (at
    CPU-timescale)? I'm not running a high I/O server, it's for desktop use…

  *

    - It will be a pain for me to compile it in the kernel. I'm running
    vanilla Ubuntu. I found this :
    https://www.rwardrup.com/bcachefs-on-ubuntu-20-04/. I noticed
    automount doesn't work.

  *

    - physical storage format is not finalized. Is there a risk I loose
    everything, do I need to compile updates regularly? what happens
    when physical format changes?…

  *

    - if anything goes wrong, I can't just plug the HDDs on another system.

  *

    - isn't there a strain of the SSD that, at some point, will kill it?
    If it dies, and my system is on it (on an ext4 partition) I loose
    access to my data until I rebuild a system with Bcachefs kernel support.

  *

    - would it make sense to have the external HDD be part of the RAID,
    so to automate syncing on the backup drive ?


I'm also fine with vanilla ext4 with software Raid-1 and rsync. What 
would you recommend ? Irrespective of me using it or not, I like to 
continue sponsoring the development, with my modest income.


Best,

Marcel (Paris, France)

