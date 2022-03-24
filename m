Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D77C433EF
	for <linux-bcachefs@archiver.kernel.org>; Thu, 24 Mar 2022 06:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347302AbiCXGrk (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 24 Mar 2022 02:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242282AbiCXGrk (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 24 Mar 2022 02:47:40 -0400
X-Greylist: delayed 1098 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Mar 2022 23:46:07 PDT
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C9D90273
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Mar 2022 23:46:07 -0700 (PDT)
X-ASG-Debug-ID: 1648103266-15c435186c1c9ba30001-qsCQDO
Received: from [192.168.177.53] (213.219.188.222.adsl.dyn.edpnet.net [213.219.188.222]) by relay-b03.edpnet.be with ESMTP id aHpd2GPJlB7AEyiM for <linux-bcachefs@vger.kernel.org>; Thu, 24 Mar 2022 07:27:46 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.188.222.adsl.dyn.edpnet.net[213.219.188.222]
X-Barracuda-Apparent-Source-IP: 213.219.188.222
Message-ID: <b3eddb73-abb9-49aa-af43-7c90efd602b7@kabelmail.de>
Date:   Thu, 24 Mar 2022 07:27:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Content-Language: en-US
To:     linux-bcachefs@vger.kernel.org
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: migration to livetree failed: journal corrupt
Content-Type: text/plain; charset=UTF-8
X-ASG-Orig-Subj: migration to livetree failed: journal corrupt
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: 213.219.188.222.adsl.dyn.edpnet.net[213.219.188.222]
X-Barracuda-Start-Time: 1648103266
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 432
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.96868
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Something failed while moving a large (24tb, 4tb allocated) multi-tiered filesystem to livetree
structure,
it immediately goes read-only.
After doing bcachefs fscheck, it hung at going read-write,
so I retried with --realloc-btree.
This time, it complained about journal corruption.
Is there any way I can safely drop the contents of the journal? The filesystem contents have not
changed since its last reboot.

Janpieter
