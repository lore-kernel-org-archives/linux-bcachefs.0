Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB2BC433EF
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Oct 2021 09:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7D1361078
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Oct 2021 09:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhJLJNl (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 12 Oct 2021 05:13:41 -0400
Received: from cdw.me.uk ([91.203.57.136]:46457 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhJLJNk (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 12 Oct 2021 05:13:40 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1maDow-0003x9-IC; Tue, 12 Oct 2021 10:11:38 +0100
Date:   Tue, 12 Oct 2021 10:11:38 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: [PATCH] [ktest] Test simple drive replacement on a replicated fs
Message-ID: <20211012091138.GB11670@arachsys.com>
References: <20211012090745.GA11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012090745.GA11670@arachsys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This currently fails because metadata doesn't get copied to the
replacement device, although the data content of the filesystem
does get replicated during the data rereplicate step.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 tests/bcachefs/replication.ktest | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tests/bcachefs/replication.ktest b/tests/bcachefs/replication.ktest
index 7057fa7..569b984 100644
--- a/tests/bcachefs/replication.ktest
+++ b/tests/bcachefs/replication.ktest
@@ -629,3 +629,17 @@ test_replicas_gc()
 
     bcachefs fsck /dev/sd[bcdef]
 }
+
+# Fails
+test_replace_replica()
+{
+    bcachefs format --errors=panic --replicas=2 /dev/sd[bc]
+    mount -t bcachefs -o degraded /dev/sdb /mnt
+
+    bcachefs device add -f /mnt /dev/sdd
+    bcachefs data rereplicate /mnt
+    umount /mnt
+
+    mount -t bcachefs -o degraded /dev/sdd /mnt
+    umount /mnt
+}
