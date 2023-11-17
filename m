Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eifkJI2q"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E41AD59
	for <linux-bcachefs@vger.kernel.org>; Fri, 17 Nov 2023 05:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700226732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hwRyKM5cVKLJaStFulhdM09+blPCEjbNJ4xaKH6+oHg=;
	b=eifkJI2qBMssJ+NCPgShWjaz6GvFJlgxGygvCuBy6kiLIYeIZyKHh7DtdCRTAms40CpW+6
	kAl8vHxYu4h0OYLt7lg5zbRGzM65nOUwNsML8mATPdQu4BZQ0W+9nJYEVW4qRCTpgqEJBc
	QSxepuVh8Q+E1fUn2xRSIWEl36zEI8Y=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-iUEYAzdTOlCCSCXvfpBGOA-1; Fri,
 17 Nov 2023 08:12:10 -0500
X-MC-Unique: iUEYAzdTOlCCSCXvfpBGOA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79B703C0F422
	for <linux-bcachefs@vger.kernel.org>; Fri, 17 Nov 2023 13:12:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.99])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DED1492BE9
	for <linux-bcachefs@vger.kernel.org>; Fri, 17 Nov 2023 13:12:10 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs-tools: fix broken libblkid superblock wipe
Date: Fri, 17 Nov 2023 08:12:58 -0500
Message-ID: <20231117131258.9045-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

When playing around with comparing some fstests results on different
filesystems, I noticed that a 'bcachefs format' of a previously
btrfs-formatted device still continued to mount as btrfs. The reason
for this is that the blkid wipe invoked via open_for_format() is not
working correctly. blkid_do_wipe() depends on the "SBMAGIC[_OFFSET]"
values to do any work, and the associated superblock magic flag is
not enabled on the probe.

Set the probe flags to explicitly enable the values the bcachefs
code depends on in the probe. This includes the type, label and
superblock magic information.

There are also a couple quirks in the libblkid code that might be
worth noting. One is that the superblock enablement and flag setting
functions appear hardcoded to return zero, so we just combine the
error checks. Second, while blkid_do_wipe() can return an error, it
actually doesn't in the scenario being addressed here because it
doesn't seem to distinguish between the values being absent because
nothing was found by the probe or because the values weren't enabled
in the first place. Regardless, add an error check here in the event
the wipe does explicitly fail for some unexpected reason.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tools-util.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools-util.c b/tools-util.c
index 923a666..7d4a3c1 100644
--- a/tools-util.c
+++ b/tools-util.c
@@ -232,7 +232,10 @@ int open_for_format(struct dev_opts *dev, bool force)
 		die("blkid error 1");
 	if (blkid_probe_set_device(pr, dev->bdev->bd_buffered_fd, 0, 0))
 		die("blkid error 2");
-	if (blkid_probe_enable_partitions(pr, true))
+	if (blkid_probe_enable_partitions(pr, true) ||
+	    blkid_probe_enable_superblocks(pr, true) ||
+	    blkid_probe_set_superblocks_flags(pr,
+			BLKID_SUBLKS_LABEL|BLKID_SUBLKS_TYPE|BLKID_SUBLKS_MAGIC))
 		die("blkid error 3");
 	if (blkid_do_fullprobe(pr) < 0)
 		die("blkid error 4");
@@ -250,8 +253,10 @@ int open_for_format(struct dev_opts *dev, bool force)
 		fputs("Proceed anyway?", stdout);
 		if (!ask_yn())
 			exit(EXIT_FAILURE);
-		while (blkid_do_probe(pr) == 0)
-			blkid_do_wipe(pr, 0);
+		while (blkid_do_probe(pr) == 0) {
+			if (blkid_do_wipe(pr, 0))
+				die("Failed to wipe preexisting metadata.");
+		}
 	}
 
 	blkid_free_probe(pr);
-- 
2.41.0

