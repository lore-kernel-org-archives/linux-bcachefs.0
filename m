Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9EDEB64DA
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 21:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbjGLVNs (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 17:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbjGLVMp (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 17:12:45 -0400
Received: from out-11.mta1.migadu.com (out-11.mta1.migadu.com [IPv6:2001:41d0:203:375::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A882D68
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 14:11:57 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689196300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/zrRAhLqNEKhRrIoVgPZyeRn+CDbvH7B3D4IIgSyFSc=;
        b=H2CyNxWGCE3tivzrg2wKis0Fi1baP6oPMbzsQ9Vph9f3q/hlsngS4aMYt/197qAIh8IcH1
        5SfVqNPTjdnhOXSN3oB7KxOEWArW+m2E5FnG/AzvN/yw14BF1ZU23+aXp6Tp2TfMzTqyX9
        aeXA4uTnJ/+mhn5UXz88dfILMGDoxTM=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH 11/20] locking/osq: Export osq_(lock|unlock)
Date:   Wed, 12 Jul 2023 17:11:06 -0400
Message-Id: <20230712211115.2174650-12-kent.overstreet@linux.dev>
In-Reply-To: <20230712211115.2174650-1-kent.overstreet@linux.dev>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

These are used by bcachefs's six locks.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/locking/osq_lock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index d5610ad52b..b752ec5cc6 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -203,6 +203,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
 
 	return false;
 }
+EXPORT_SYMBOL_GPL(osq_lock);
 
 void osq_unlock(struct optimistic_spin_queue *lock)
 {
@@ -230,3 +231,4 @@ void osq_unlock(struct optimistic_spin_queue *lock)
 	if (next)
 		WRITE_ONCE(next->locked, 1);
 }
+EXPORT_SYMBOL_GPL(osq_unlock);
-- 
2.40.1

