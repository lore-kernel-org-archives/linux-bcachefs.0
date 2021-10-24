Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D09BC433EF
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 12:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4506860D43
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 12:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhJXMy4 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 24 Oct 2021 08:54:56 -0400
Received: from cdw.me.uk ([91.203.57.136]:52741 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230435AbhJXMyz (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 24 Oct 2021 08:54:55 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1meczI-0004z1-SX; Sun, 24 Oct 2021 13:52:32 +0100
Date:   Sun, 24 Oct 2021 13:52:32 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcachefs@vger.kernel.org
Subject: [PATCH] [bcachefs-tools] Cosmetic fixes for device resize-journal
Message-ID: <20211024125232.GH11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Correct the operation name from 'journal-resize' to 'resize-journal' in the
bcachefs usage summary, matching the command that is actually implemented.

Fix the size argument so it isn't optional. Defaulting to the entire device
makes sense for 'device resize', to automatically expand the fs to fill the
block device. However, it is never meaningful (or possible) to expand the
journal to the full disk.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 bcachefs.c   | 2 +-
 cmd_device.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/bcachefs.c b/bcachefs.c
index 1a06c17..2b004a0 100644
--- a/bcachefs.c
+++ b/bcachefs.c
@@ -56,7 +56,7 @@ static void usage(void)
 	     "  device evacuate          Migrate data off of a specific device\n"
 	     "  device set-state         Mark a device as failed\n"
 	     "  device resize            Resize filesystem on a device\n"
-	     "  device journal-resize    Resize journal on a device\n"
+	     "  device resize-journal    Resize journal on a device\n"
 	     "\n"
 	     "Commands for managing subvolumes and snapshots:\n"
 	     "  subvolume create     Create a new subvolume\n"
diff --git a/cmd_device.c b/cmd_device.c
index 3bdb281..87d8507 100644
--- a/cmd_device.c
+++ b/cmd_device.c
@@ -539,7 +539,7 @@ int cmd_device_resize(int argc, char *argv[])
 static void device_resize_journal_usage(void)
 {
 	puts("bcachefs device resize-journal \n"
-	     "Usage: bcachefs device resize-journal device [ size ]\n"
+	     "Usage: bcachefs device resize-journal device size\n"
 	     "\n"
 	     "Options:\n"
 	     "  -h, --help                  display this help and exit\n"
@@ -571,7 +571,7 @@ int cmd_device_resize_journal(int argc, char *argv[])
 
 	char *size_arg = arg_pop();
 	if (!size_arg)
-		size = get_size(dev, dev_fd);
+		die("Please supply a journal size");
 	else if (bch2_strtoull_h(size_arg, &size))
 		die("invalid size");
 
