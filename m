Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B26CC49EA6
	for <linux-bcachefs@archiver.kernel.org>; Fri, 25 Jun 2021 02:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B9D560FEA
	for <linux-bcachefs@archiver.kernel.org>; Fri, 25 Jun 2021 02:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhFYC2v (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 24 Jun 2021 22:28:51 -0400
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17405 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhFYC2v (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 24 Jun 2021 22:28:51 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2021 22:28:51 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1624587085; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Yjx5PUw4bhmIyEZ3myG9l96yxq7XzcmzaRlu/ObjP4hHzh2FdRH9PrqQ3S4nlk6Mrr4CpgdoyUJz+JmeLlm+6MAJTYbtcTHJEyESl4Nj5VTojtDS7enz+2FGPy6G5dym2iND8hDjUD0qKgFztBk+9eeT+5UGnm/WsAT0TdvpYfU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1624587085; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=WjptaI765Z/Ik3t/sks5yEtYFjs/tmqrnFRJ7MQajio=; 
        b=Gt3PCaosk0OZ8ubeNhdszn/52EAjJNC8DSvx7OYOfcghOCTDebnIRsSeG0wgxDdgxEz2YayQ7+PV98bveZY+7k0iPdnf1i0yeO9ZuF2QJSorTwHS2RaSzomtC+x8x4eC7Vg4Hy54jOrKilj0FqhdHAOR+rd2RX2Uwce9hqeR3kQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=dan@dlrobertson.com;
        dmarc=pass header.from=<dan@dlrobertson.com>
Received: from gothmog.test (pool-108-51-207-71.washdc.fios.verizon.net [108.51.207.71]) by mx.zohomail.com
        with SMTPS id 1624587083834237.41416655693115; Thu, 24 Jun 2021 19:11:23 -0700 (PDT)
From:   Dan Robertson <dan@dlrobertson.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 0/1] generic/103: increase reserved bytes for bcachefs
Date:   Thu, 24 Jun 2021 22:11:17 -0400
Message-Id: <20210625021118.28813-1-dan@dlrobertson.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

After some testing it seems that generic/103 fails intermittently due to
a split leaf that can be hit in fallocate. Since the bcachefs node sizes
are larger on bcachefs than some other filesystems the reserved size
needs to be bumped up a bit when FSTYP is bcachefs.

On a system that generic/103 failed semi-regularly on, I can now it
in a loop without hitting a failure.

Dan Robertson (1):
  generic/103: increase reserved bytes for bcachefs

 tests/generic/103 | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

