Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3FAC433DB
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 Feb 2021 10:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2859064E6C
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 Feb 2021 10:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhBIKOl convert rfc822-to-8bit (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 Feb 2021 05:14:41 -0500
Received: from relay-b01.edpnet.be ([212.71.1.221]:47602 "EHLO
        relay-b01.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhBIKGz (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 Feb 2021 05:06:55 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2021 05:06:54 EST
X-ASG-Debug-ID: 1612864252-15c4343996d2ff0001-qsCQDO
Received: from [192.168.177.53] (94.105.113.28.dyn.edpnet.net [94.105.113.28]) by relay-b01.edpnet.be with ESMTP id sbOVIV62kQr9de2M for <linux-bcachefs@vger.kernel.org>; Tue, 09 Feb 2021 10:50:53 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 94.105.113.28.dyn.edpnet.net[94.105.113.28]
X-Barracuda-Apparent-Source-IP: 94.105.113.28
To:     linux-bcachefs@vger.kernel.org
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: debugging: how long do I need to keep data for other devs?
Message-ID: <cda37b74-eca0-4589-bc75-9e4bc7f181df@kabelmail.de>
X-ASG-Orig-Subj: debugging: how long do I need to keep data for other devs?
Date:   Tue, 9 Feb 2021 10:51:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Barracuda-Connect: 94.105.113.28.dyn.edpnet.net[94.105.113.28]
X-Barracuda-Start-Time: 1612864253
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 635
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.87858
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi,

I am involved in 2 bcachefs bugs on github: #189 and #190.
Both errors make the data unreadable.
I have 3 bcachefs filesystems,
1 not moved to alloc_v2 and all devices present,
1 never moved to alloc_v2 but 1 foreground/promote device missing
1 moved to alloc_v2 and 1 foreground/promote device missing
Like any good IT guy, I create backups of my data.
but, for how long is it useful to keep the "broken" filesystem for repair? When can I simply
reformat the fs and revert to backup?

I know I could do it immediately - but this erases the faulty setup which needs to be examined

kind regards,


Janpieter


