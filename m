Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFE8C6FD1F
	for <linux-bcachefs@archiver.kernel.org>; Sun, 19 Mar 2023 11:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCSLBr (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 19 Mar 2023 07:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjCSLBg (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 19 Mar 2023 07:01:36 -0400
X-Greylist: delayed 551 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Mar 2023 04:00:59 PDT
Received: from mr6.vodafonemail.de (mr6.vodafonemail.de [145.253.228.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A23323308
        for <linux-bcachefs@vger.kernel.org>; Sun, 19 Mar 2023 04:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arcor.de;
        s=vfde-mb-mr2-21dec; t=1679223106;
        bh=BUe31WDzP4YcBIB+GBBOl+Qs2ryAnDh5G3LcAwzEMe8=;
        h=Message-ID:Date:User-Agent:Content-Language:To:From:Subject:
         Content-Type:From;
        b=DxLthwPNV1q4326GG3RG6qXY/W+vfUBIfePAKfL9vHBI7XfFD4tiMVPYXaPmZT774
         R2j/ZGXYO79imTB0V2VbF7tLHIiujOHBCEvPIlD2tzXGHgNXwL+Yg7H726RSAvZXN7
         8Ui2dg4jIw54/CeHLTb5SAp/7HyLHqo/BmB+Mfjs=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mr6.vodafonemail.de (Postfix) with ESMTPS id 4PfZS24YS9z1y4P
        for <linux-bcachefs@vger.kernel.org>; Sun, 19 Mar 2023 10:51:46 +0000 (UTC)
Received: from [192.168.1.8] (ip1f12f8bd.dynamic.kabel-deutschland.de [31.18.248.189])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 4PfZRy2y0qzHnHZ
        for <linux-bcachefs@vger.kernel.org>; Sun, 19 Mar 2023 10:51:39 +0000 (UTC)
Message-ID: <831516c6-3560-62e8-7bb7-67d97f64e9da@arcor.de>
Date:   Sun, 19 Mar 2023 11:51:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: de-DE, en-US
To:     linux-bcachefs@vger.kernel.org
From:   =?UTF-8?Q?Dr=2e-Ing=2e_Heiko_M=c3=bcnkel?= <heiko.muenkel@arcor.de>
Subject: User documentation for bcachefs?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 454
X-purgate-ID: 155817::1679223102-97FFE4F5-98D7D128/0/0
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello,

I would like to use an SSD as a cache for a hard disk connected via USB. 
Currently I use btrfs on the hard disk to be able to use the snapshot 
feature.

If I understand it correctly, I could use the bcachefs filesystem for 
both (cache and snapshots) while also occasionally attaching the drive 
to another PC without any problems.

Is this correct?

Where can I find user documentation for bcachefs?


Thanks a lot,

Heiko

