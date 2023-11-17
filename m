Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YPMiMrUN"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE7AC5
	for <linux-bcachefs@vger.kernel.org>; Fri, 17 Nov 2023 06:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700232152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=viEBw0op9J3Rz65ZIAnnSEgNGq9SfbItEJguo/umJ08=;
	b=YPMiMrUNiknpfyT+BJwFcgXP2RoBihk9tFhqptT+KdktFQC8C/XahBr0q4ynyuJRZPc5dz
	0vbrUGOtJ8K+eXU7ijB/uv2ay60feSS2us6FrMZMLgs2Ba+CnqsI2nxp/OF+FqrQO6h24L
	o7BRKjUZkBlC6POcBJvlMttJ0XxoAGI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-138-Vs4Fr8nHPxucXZYU739o-Q-1; Fri,
 17 Nov 2023 09:42:31 -0500
X-MC-Unique: Vs4Fr8nHPxucXZYU739o-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD9A1381A8A0;
	Fri, 17 Nov 2023 14:42:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.99])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 967352166B2A;
	Fri, 17 Nov 2023 14:42:29 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org
Subject: [PATCH] generic/459: improve shutdown/read-only check to accommodate bcachefs
Date: Fri, 17 Nov 2023 09:43:17 -0500
Message-ID: <20231117144317.10882-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

generic/459 occasionally fails on bcachefs because the deliberately
induced I/O errors caused by exhausting the overprovisioned thin
pool can lead to filesystem shutdown. This test considers this
expected behavior on certain fs', but only checks for the ext4
remount read-only behavior. bcachefs does a similar emergency
read-only transition in response to certain I/O errors, but it
behaves more similar to an XFS shutdown and doesn't necessarily
reflect "ro" state in the mount table (unless induced by userspace).

Since the test already runs a touch command to help trigger the ext4
error handling sequence, this can be tweaked to serve double duty
and also more accurately detect read-only status on bcachefs.
Refactor into a small helper, check for an EROFS return to the touch
command, and consider the fs read-only if either that or the mount
entry check indicates it.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Something I realized when writing up the commit log is that the EROFS
check doesn't technically cover XFS, which IIRC returns EIO in response
to any sorts of writes once the fs has shutdown. I'm not sure this
matters currently because XFS doesn't shutdown due to the default
behavior to retry failed I/Os, but technically if XFS were configured to
not retry I/O errors and go right to permanent failure, I suspect it
would fail this test in the same way bcachefs does.

That could be addressed fairly easily by also checking for EIO error
message output, or just assuming touch failure == shutdown, etc. I don't
have much preference on that, so thoughts appreciated.

Brian

 tests/generic/459 | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/tests/generic/459 b/tests/generic/459
index 4dd7a43b..d0c48325 100755
--- a/tests/generic/459
+++ b/tests/generic/459
@@ -57,6 +57,26 @@ origpsize=200
 virtsize=300
 newpsize=300
 
+# Check whether the filesystem has shutdown or remounted read-only. Behavior can
+# differ based on filesystem and configuration. Some fs' may not have remounted
+# without an additional write while others may have shutdown but do not
+# necessarily reflect read-only state in the mount options. Check both here to
+# cover the various scenarios.
+is_shutdown_or_ro()
+{
+	ro=0
+
+	# if the fs has not shutdown, this may help trigger a remount-ro
+	touch $SCRATCH_MNT/newfile 2>&1 | \
+		grep "Read-only file system" > /dev/null
+	[ $? == 0 ] && ro=1
+
+	_fs_options /dev/mapper/$vgname-$snapname | grep -w "ro" > /dev/null
+	[ $? == 0 ] && ro=1
+
+	echo $ro
+}
+
 # Ensure we have enough disk space
 _scratch_mkfs_sized $((350 * 1024 * 1024)) >>$seqres.full 2>&1
 
@@ -113,13 +133,9 @@ ret=$?
 #	- The filesystem stays in Read-Write mode, but can be frozen/thawed
 #	  without getting stuck.
 if [ $ret -ne 0 ]; then
-	# freeze failed, filesystem should reject further writes and remount
-	# as readonly. Sometimes the previous write process won't trigger
-	# ro-remount, e.g. on ext3/4, do additional touch here to make sure
-	# filesystems see the metadata I/O error.
-	touch $SCRATCH_MNT/newfile >/dev/null 2>&1
-	ISRO=$(_fs_options /dev/mapper/$vgname-$snapname | grep -w "ro")
-	if [ -n "$ISRO" ]; then
+	# freeze failed, filesystem should reject further writes
+	ISRO=`is_shutdown_or_ro`
+	if [ $ISRO == 1 ]; then
 		echo "Test OK"
 	else
 		echo "Freeze failed and FS isn't Read-Only. Test Failed"
-- 
2.41.0

