Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F30C25B08
	for <linux-bcachefs@archiver.kernel.org>; Thu, 18 Aug 2022 02:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239815AbiHRCHU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 17 Aug 2022 22:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbiHRCHS (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 17 Aug 2022 22:07:18 -0400
Received: from smtp.carlthompson.net (bifrost.carlthompson.net [45.77.7.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD5E95AF5
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 Aug 2022 19:07:18 -0700 (PDT)
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
        (Authenticated sender: cet@carlthompson.net)
        by smtp.carlthompson.net (Postfix) with ESMTPSA id C52415E7C
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 Aug 2022 19:07:17 -0700 (PDT)
Date:   Wed, 17 Aug 2022 19:07:17 -0700 (PDT)
From:   "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To:     "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <590771559.530.1660788437769@mail.carlthompson.net>
Subject: Which git to test against? Which branch?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev9
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Sorry for the basic questions. I have compiled bcachefs from the master branch of the evilpiepirate.org git repository and I've experienced some issues so I want to make sure I'm using the expected code before reporting bugs.

Should I be using the github git repository instead? Are they the same?

Should I be using the "master" branch or would either the "bcachefs-testing" or "bcachefs-5.17" branches be more appropriate for bug reporting?

Should I post potential bugs and other issues to this list for discussion before opening an issue on github? If github is the way to start what should I be using this list for (if anything)?

Thanks for guidance,
Carl
