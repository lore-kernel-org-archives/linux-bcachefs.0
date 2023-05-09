Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34720C77B75
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 16:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbjEIQ7k (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 12:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbjEIQ6X (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 12:58:23 -0400
Received: from out-21.mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537CC5FEF
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 09:57:32 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683651450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4+qUD9R+DcetQOvg5f3GpMxzPZzmlaA8sue3bNTAfVo=;
        b=ENkhviM7etnE84ZkD+4vtkRiiNspqxA/lNrO4RXNZ8yeN8c2YKqtbDxJAr9NJIhBYV8UsZ
        z6ktImL6+6VKYmFBJ10zEUcmqyFXw/Yt2IsylmWIqyAO9H8c6nRJDKPTxx9R8kf0Vj47zL
        WpWU+qb0j2vNs8POnr1oLPMdpMcv0Nc=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 21/32] hlist-bl: add hlist_bl_fake()
Date:   Tue,  9 May 2023 12:56:46 -0400
Message-Id: <20230509165657.1735798-22-kent.overstreet@linux.dev>
In-Reply-To: <20230509165657.1735798-1-kent.overstreet@linux.dev>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

in preparation for switching the VFS inode cache over the hlist_bl
lists, we nee dto be able to fake a list node that looks like it is
hased for correct operation of filesystems that don't directly use
the VFS indoe cache.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/list_bl.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index ae1b541446..8ee2bf5af1 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -143,6 +143,28 @@ static inline void hlist_bl_del_init(struct hlist_bl_node *n)
 	}
 }
 
+/**
+ * hlist_bl_add_fake - create a fake list consisting of a single headless node
+ * @n: Node to make a fake list out of
+ *
+ * This makes @n appear to be its own predecessor on a headless hlist.
+ * The point of this is to allow things like hlist_bl_del() to work correctly
+ * in cases where there is no list.
+ */
+static inline void hlist_bl_add_fake(struct hlist_bl_node *n)
+{
+	n->pprev = &n->next;
+}
+
+/**
+ * hlist_fake: Is this node a fake hlist_bl?
+ * @h: Node to check for being a self-referential fake hlist.
+ */
+static inline bool hlist_bl_fake(struct hlist_bl_node *n)
+{
+	return n->pprev == &n->next;
+}
+
 static inline void hlist_bl_lock(struct hlist_bl_head *b)
 {
 	bit_spin_lock(0, (unsigned long *)b);
-- 
2.40.1

