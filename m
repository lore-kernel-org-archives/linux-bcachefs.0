Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9E2C433EF
	for <linux-bcachefs@archiver.kernel.org>; Mon, 11 Oct 2021 21:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81D0F60F3A
	for <linux-bcachefs@archiver.kernel.org>; Mon, 11 Oct 2021 21:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhJKVJl (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 11 Oct 2021 17:09:41 -0400
Received: from cdw.me.uk ([91.203.57.136]:43591 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235137AbhJKVJl (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 11 Oct 2021 17:09:41 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1ma2WI-0006qO-Cw; Mon, 11 Oct 2021 22:07:38 +0100
Date:   Mon, 11 Oct 2021 22:07:38 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: [PATCH] [ktest] Test iterated snapshot create and delete with
 distinct names
Message-ID: <20211011210738.GA25230@arachsys.com>
References: <20211010134413.GA31142@arachsys.com>
 <20211010185549.GA24560@arachsys.com>
 <YWRbw6FOnHc54yrY@moria.home.lan>
 <20211011191051.GA20049@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011191051.GA20049@arachsys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This currently fails, triggering an oops at fs/bcachefs/btree_key_cache.c:548.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 tests/bcachefs/subvol.ktest | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tests/bcachefs/subvol.ktest b/tests/bcachefs/subvol.ktest
index 67a215b..22df37b 100644
--- a/tests/bcachefs/subvol.ktest
+++ b/tests/bcachefs/subvol.ktest
@@ -231,3 +231,15 @@ test_subvol_delete_snapshot_of_deleted_subvol()
 
     umount /mnt
 }
+
+# Fails
+test_subvol_snapshot_delete_repeat()
+{
+    run_quiet "" bcachefs format -f --errors=panic /dev/sdb
+    mount -t bcachefs /dev/sdb /mnt
+    for i in $(seq 1 64); do
+        bcachefs subvolume snapshot /mnt/$i
+        bcachefs subvolume delete /mnt/$i
+    done
+    umount /mnt
+}
