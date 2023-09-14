Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B1EEE0213
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 00:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbjINAB2 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Sep 2023 20:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbjINAB2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Sep 2023 20:01:28 -0400
Received: from out-230.mta0.migadu.com (out-230.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DEACE4
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 17:01:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694649682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7V/75YsHRAvFqtDz9Sm5Y3H3QzD8ohISD1gCsWY/c/I=;
        b=FO1T9tBV+zwuOkhm2oCjJDtzcxxobP3syHxI09ioWhJDYonSLAigNZjJNmJJKbYLMWmMCd
        e6+rJrGFIju0jiefWsBhQsAKuST2qn+aoJljYxqNo4cWaoHTnWoSCQulYAEYYfKfG2Ff8j
        6aCIslqCkc4GtC6zQpHOML9tx97E6+Q=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc: Export kvm_guest static key, for bcachefs six locks
Date:   Wed, 13 Sep 2023 20:01:15 -0400
Message-Id: <20230914000115.1035594-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bcachefs's six locks need kvm_guest, via
 ower_on_cpu() ->  vcpu_is_preempted() -> is_kvm_guest()

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/kernel/firmware.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/firmware.c b/arch/powerpc/kernel/firmware.c
index 20328f72f9f2..8987eee33dc8 100644
--- a/arch/powerpc/kernel/firmware.c
+++ b/arch/powerpc/kernel/firmware.c
@@ -23,6 +23,8 @@ EXPORT_SYMBOL_GPL(powerpc_firmware_features);
 
 #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
 DEFINE_STATIC_KEY_FALSE(kvm_guest);
+EXPORT_SYMBOL_GPL(kvm_guest);
+
 int __init check_kvm_guest(void)
 {
 	struct device_node *hyper_node;
-- 
2.40.1

