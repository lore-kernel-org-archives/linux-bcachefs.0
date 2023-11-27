Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PAg35cck"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628C2B8
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Nov 2023 10:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701109825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AAvj4RGTIm3ogJFCYQgCDc4WJZhXtwPxjRvCzL35sf4=;
	b=PAg35cck/cL82NuGok/5eJMhx6+4z+QvZQSDZfNK+8A2UxB6M6IZE9xDLAMbjFvKkzz48i
	wOYLKm6kOV2xa5WUghZQ7OFX91lVBZhqHDTqtPL9MxiROucyEA7AEL9MlQO1csnQ9IYt66
	mC3kNVR0bZhzJjU6bqVI133qagoL+rU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-XLhc-Kr3NHeq14ADo41XLA-1; Mon,
 27 Nov 2023 13:30:22 -0500
X-MC-Unique: XLhc-Kr3NHeq14ADo41XLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA56B3813F5E
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Nov 2023 18:30:21 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ADBBA5028
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Nov 2023 18:30:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs-tools: don't skip stale superblock wipe in force mode
Date: Mon, 27 Nov 2023 13:31:10 -0500
Message-ID: <20231127183110.294141-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Even though the blkid wipe has been fixed to detect and wipe old
superblocks, we still incorrectly skip the wipe when in force mode.
Update the force logic in open_for_format() to bypass the user
request and otherwise proceed with the wipe.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tools-util.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools-util.c b/tools-util.c
index 7d4a3c1..a1e67dd 100644
--- a/tools-util.c
+++ b/tools-util.c
@@ -225,9 +225,6 @@ int open_for_format(struct dev_opts *dev, bool force)
 	if (ret < 0)
 		die("Error opening device to format %s: %s", dev->path, strerror(-ret));
 
-	if (force)
-		return 0;
-
 	if (!(pr = blkid_new_probe()))
 		die("blkid error 1");
 	if (blkid_probe_set_device(pr, dev->bdev->bd_buffered_fd, 0, 0))
@@ -250,9 +247,11 @@ int open_for_format(struct dev_opts *dev, bool force)
 		else
 			printf("%s contains a %s filesystem\n",
 			       dev->path, fs_type);
-		fputs("Proceed anyway?", stdout);
-		if (!ask_yn())
-			exit(EXIT_FAILURE);
+		if (!force) {
+			fputs("Proceed anyway?", stdout);
+			if (!ask_yn())
+				exit(EXIT_FAILURE);
+		}
 		while (blkid_do_probe(pr) == 0) {
 			if (blkid_do_wipe(pr, 0))
 				die("Failed to wipe preexisting metadata.");
-- 
2.41.0

