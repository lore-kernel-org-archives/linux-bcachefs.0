Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48455C433FE
	for <linux-bcachefs@archiver.kernel.org>; Sat,  5 Nov 2022 08:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiKEIqK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 5 Nov 2022 04:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKEIqJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 5 Nov 2022 04:46:09 -0400
X-Greylist: delayed 1110 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Nov 2022 01:46:07 PDT
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364512250D
        for <linux-bcachefs@vger.kernel.org>; Sat,  5 Nov 2022 01:46:07 -0700 (PDT)
X-ASG-Debug-ID: 1667636854-15c435322debc90001-qsCQDO
Received: from [192.168.177.53] (213.219.188.14.adsl.dyn.edpnet.net [213.219.188.14]) by relay-b03.edpnet.be with ESMTP id Co7B3W94FBJWme29 for <linux-bcachefs@vger.kernel.org>; Sat, 05 Nov 2022 09:27:34 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Apparent-Source-IP: 213.219.188.14
Message-ID: <dce51eec-b23b-828f-6425-0bf09049de8c@kabelmail.de>
Date:   Sat, 5 Nov 2022 09:27:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Content-Language: en-US, nl-BE
To:     linux-bcachefs@vger.kernel.org
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: [PATCH] cleanup btree_interior_update_work
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ASG-Orig-Subj: [PATCH] cleanup btree_interior_update_work
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Start-Time: 1667636854
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1300
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.101919
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

I accidentally saw it, and thought reorganising a bit may be useful here.
It's not worth a separate commit, but if you're preparing one...
eliminating a if() statement is always a good idea within a mutex lock,
especially for devices with no branch predictor (embedded arm devices?).

Janpieter Sollie

diff --git a/libbcachefs/btree_update_interior.c b/libbcachefs/btree_update_interior.c
index 5ce91ae..7cd8177 100644
--- a/libbcachefs/btree_update_interior.c
+++ b/libbcachefs/btree_update_interior.c
@@ -782,11 +782,9 @@static void btree_interior_update_work(struct work_struct *work)
                mutex_lock(&c->btree_interior_update_lock);
                as = list_first_entry_or_null(&c->btree_interior_updates_unwritten,
                                              struct btree_update, unwritten_list);
-               if (as && !as->nodes_written)
-                       as = NULL;
                mutex_unlock(&c->btree_interior_update_lock);

-               if (!as)
+if (!as || !as->nodes_written)
                        break;

                btree_update_nodes_written(as);
