Return-Path: <SRS0=HjF4=EB=vger.kernel.org=linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC043C2D0A3
	for <linux-bcachefs@archiver.kernel.org>; Mon, 26 Oct 2020 09:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8426622242
	for <linux-bcachefs@archiver.kernel.org>; Mon, 26 Oct 2020 09:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="DtG/rNFU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772504AbgJZJCt (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 26 Oct 2020 05:02:49 -0400
Received: from mout.gmx.net ([212.227.17.21]:44069 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1772481AbgJZJCt (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 26 Oct 2020 05:02:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1603702967;
        bh=Ky/qty1I8m2zBGVxWWBoezbgNTwSDDAB89RcxTIxJ34=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=DtG/rNFUEs6cFzsPmjTXDBoObhhc81OYI7sNhZZzBGmUYTmh0OeZkLrChswQYxMX5
         t1RmC3KiUfTsjLausbPYZyh5kOHMhK5wVp45CBSMRSZQTwUHGOepq0eW8v7jEtsL5O
         dsAi1xxqowqQTylj3fl9CP1q3rzRt4+dSGm0JE0s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MkYXm-1k72Ij1H5y-00m62K for
 <linux-bcachefs@vger.kernel.org>; Mon, 26 Oct 2020 10:02:47 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     linux-bcachefs@vger.kernel.org
Subject: Status update - erasure coding
Date:   Mon, 26 Oct 2020 10:02:46 +0100
Message-ID: <16038636.kxRvFxecPm@t460-skr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:lG40v9Lhbn+vRwlKSWIRKz5fm0ffmg1Zaofrj367h0+xgadN0k5
 7p8jiFlTDdVvBPRe1xJsRfi07rqrS7xyrpwv9Ofa70VytLHaJ7V2KGSG20OWJt0cpp6onGk
 x9/inNliI2PuOZkwgsdlAo0bODF/65oc4P5tzumHmeQ1YsxDmgSa6KUEoFVqFQ3gb9sGjfb
 Vq6+QCWra1SwLVZBJom9A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+G94bGK52Qg=:O+yo81NMWGdGxcfaJKsAp0
 1gWvgsf+8s2ojxCDkAOgvSGhESaQjrubFqrMcSDQSbvq+Jp2zAzUUAnoZMGsQGAsf6r42kyli
 Mt9DZfya+AaSoCk+DN9Ns9ZAUHbe5ByLGM8EZS7YJfmW1jZ+LKJES3lYAwr2ICIIxyu+0MQqs
 KRMzPbCv7SmTdSwRZLXNUHllSRARWnUOCLpeYSDDM4auBI1AWSeAuGHUUd6nHAKvWC7tQWiD4
 II9YzcXmehuWOWdiuv0/XxEjKciwdsWRc7i4peY4m9CdqUGA9N81d+0if3mKlDKHKDzWI+nxS
 5CX6AMNr3ITEsvltCrqS/uRo5Frr61IQY+DoDxnzykXG7viuUKli2csuEGwZ/U6iqnTk4F2rS
 roaEc/OxPUA0hHdLmUntQtqjtAEp0oUW7eS68PEXvQK8jU0+R7ykNwBs4GZyAO22bn6Th7L89
 hUKsVfTn4sRjVANTIQQ9qKjqyJFmcFpN3Cll4zy7aWVaZFOXr//ddlJKnVBk05H9wqlfmZZfq
 kA/tT71DHkY2A1On9qch3MS1i3/AhIAHQ7NzY8re902RN/+H2XgylRHgW6zmGTzGGtUgHtdOo
 47l1n0P6Bg81wLy38bZ7lPTnU6FxT9GYjldVWwhRmwJehpbXGFSRK9ahodZgueCfWpqM/cWYu
 QBHlOGLHeC6hKR+xSr9sfNNg1kbwYD1ELz5MBjmRkF1axmUDul1OYAc9xjdincMt7KELJl+NO
 N8pOpVDTXVTK498Dx5KLOPOl2hT4N0YOtowlMAqXxsUryDMBeEjyriWdvvBtLjU1MEr8bXkND
 82hJhy6HmUhk1CnZChtv8dslLPOjephlcQrSZ7Lz1Mg0bSAQBUmRhVGjHOtsP5/bEbI9gxQ2I
 5HNnXnYzEXeVZ2XfZhdg==
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello,

some news about bcachefs, I quote from patreon[1]

"Erasure coding is ready for wider testing!
I just finished reworking disk space accounting for parity blocks - they're broken out from user data now, so bcachefs fs usage will show you that overhead. And I've been fixing bugs; there shouldn't be any gaping holes, and I don't expect it to catch on fire or eat data at this point. But there will definitely bugs and performance issues to find and fix.
That's the main news, aside from a whole bunch of bug fixing. Xfstests runs are looking cleaner and cleaner, and the bug reports I've been getting are less and less serious - things are looking good!"

best regards
Stefan

[1] https://www.patreon.com/posts/status-update-43089832


