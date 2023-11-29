Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JiJk7Dqk"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EDB10F4
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Nov 2023 12:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701288930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HVLcF0LVKuWOYDDhhGF0ykKSh6AB0tHaoYJQt5pm8IM=;
	b=JiJk7DqkPVtTf1ThXYHkVJj2ExWJshaF7jO7lRV7eaq1qA6i6WIYiEq0B0HfZpKzffPovR
	VyTIZT0nHdvJYd2AhUhpUltv1Q0bdCkk52O/IwRTlFRAZ4qprV91o2oNyaIaU2I25HAttq
	ePfVJWCZcfJtJ4WtUhMgXrevxljK/II=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-XVE6V36yOdilF_LFtXZ75A-1; Wed, 29 Nov 2023 15:15:26 -0500
X-MC-Unique: XVE6V36yOdilF_LFtXZ75A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 477C084AEE1;
	Wed, 29 Nov 2023 20:15:26 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 240AFC1596F;
	Wed, 29 Nov 2023 20:15:26 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org
Subject: [PATCH v2] generic/459: improve shutdown/read-only check to accommodate bcachefs
Date: Wed, 29 Nov 2023 15:16:14 -0500
Message-ID: <20231129201614.347901-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

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
Refactor into a small helper, check for touch command failure, and
consider the fs read-only if either that or the mount entry check
indicates it.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Drop error filtering and just check touch failure.
- Comment tweaks.
v1: https://lore.kernel.org/fstests/20231117144317.10882-1-bfoster@redhat.com/

 tests/generic/459 | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/tests/generic/459 b/tests/generic/459
index 4dd7a43b..c3f0b2b0 100755
--- a/tests/generic/459
+++ b/tests/generic/459
@@ -57,6 +57,24 @@ origpsize=200
 virtsize=300
 newpsize=300
 
+# Check whether the filesystem has shutdown or remounted read-only. Shutdown
+# behavior can differ based on filesystem and configuration. Some fs' may not
+# have remounted without an additional write while others may have shutdown but
+# do not necessarily reflect read-only state in the mount options. Check both
+# here by first trying a simple write and following with an explicit ro check.
+is_shutdown_or_ro()
+{
+	ro=0
+
+	# if the fs has not shutdown, this may help trigger a remount-ro
+	touch $SCRATCH_MNT/newfile > /dev/null 2>&1 || ro=1
+
+	_fs_options /dev/mapper/$vgname-$snapname | grep -w "ro" > /dev/null
+	[ $? == 0 ] && ro=1
+
+	echo $ro
+}
+
 # Ensure we have enough disk space
 _scratch_mkfs_sized $((350 * 1024 * 1024)) >>$seqres.full 2>&1
 
@@ -113,13 +131,9 @@ ret=$?
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

