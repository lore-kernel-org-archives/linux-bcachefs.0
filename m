Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4096EC001DE
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 21:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbjGLVMW (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 17:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjGLVLw (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 17:11:52 -0400
Received: from out-57.mta1.migadu.com (out-57.mta1.migadu.com [IPv6:2001:41d0:203:375::39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA30D1FCD
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 14:11:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689196297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R1CKn2DNdt+nUP3OEYLc0FEKerxTzeneNiYGijAjw4w=;
        b=iMqu0obzSgUxk8RiueeHDbBtL62R5JTfm/Rvt3yepO0VtiMBp2l9Pe+w+ub+Aw7y5oxkGP
        x1hANWCxxV7ZCUopFQ47MI2eh+jhp8aajnfxmeDl+kcmMOlLXZSm6g7U++/vMuDWbKwC4e
        saeHq0eVtW/Fnowq3D8gC5RqnLQVeX0=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christopher James Halse Rogers <raof@ubuntu.com>,
        Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 08/20] stacktrace: Export stack_trace_save_tsk
Date:   Wed, 12 Jul 2023 17:11:03 -0400
Message-Id: <20230712211115.2174650-9-kent.overstreet@linux.dev>
In-Reply-To: <20230712211115.2174650-1-kent.overstreet@linux.dev>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: Christopher James Halse Rogers <raof@ubuntu.com>

The bcachefs module wants it, and there doesn't seem to be any
reason it shouldn't be exported like the other functions.

Signed-off-by: Christopher James Halse Rogers <raof@ubuntu.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 kernel/stacktrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 9ed5ce9894..4f65824879 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -151,6 +151,7 @@ unsigned int stack_trace_save_tsk(struct task_struct *tsk, unsigned long *store,
 	put_task_stack(tsk);
 	return c.len;
 }
+EXPORT_SYMBOL_GPL(stack_trace_save_tsk);
 
 /**
  * stack_trace_save_regs - Save a stack trace based on pt_regs into a storage array
@@ -301,6 +302,7 @@ unsigned int stack_trace_save_tsk(struct task_struct *task,
 	save_stack_trace_tsk(task, &trace);
 	return trace.nr_entries;
 }
+EXPORT_SYMBOL_GPL(stack_trace_save_tsk);
 
 /**
  * stack_trace_save_regs - Save a stack trace based on pt_regs into a storage array
-- 
2.40.1

