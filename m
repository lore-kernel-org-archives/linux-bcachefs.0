Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4384195FC4
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Jun 2024 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717687697; cv=none; b=Dd7J9WfQObNK/qhbWbNkRBZKfTFt00CkAmhUfah8R0KgBVyJjn+RsxJp+AqBreoc2i9wl5ikvx9YaAldpYQbduh+GamG4H9UblubrAYblkO7/CpaodWy81JKfZ+JhJoxmoXVoYv+8p7huGqvpOhAOKZVFfd1xlsOXDsDINiEoe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717687697; c=relaxed/simple;
	bh=7/Kn36GxvLgXrxAIRv6QHCOeYR5WkMxqE5PlJG7R+kw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HC3dtAv7AZMk95mNgBFkjtJG7txJOjZgX0Rngg4t1zgFlCmy8dKAMKSRZTvRL5qOY8MRMrqp9PRIiWyCBqZZyxmxz2i8oMi9KCg9PvQYCq2YuXkzgrf+nBlwuzUMBkXtc1qj817fzWJx1xntwLXp59uuD244MMSRsEkEHJkqP+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E6BXuBvS; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E6BXuBvS"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-57a1fe63a96so1341138a12.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Jun 2024 08:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717687694; x=1718292494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yEWxbL5NnensqXJpLVqIiZQAjg93mRHbrdrY/PfhFrc=;
        b=E6BXuBvSBhWj1edoIA9fWKgaeTKarOdazRXb+67Lzd4MHAZKEbaVjOLeI9oKF4FtxU
         PRAQgnyvGKb71zMWfYD+9kPyHFk5t/rBp/YtKQ2PH79Wv9kqkhnk3oVSmPtCoq5k1dFv
         qrqb7w6t4gl+79456cvkX2nG2eM0J6oFRjWDQQXLNZQFR9Jvon4xbhLJLI4A5MM2mQ6I
         g7hFkMNqygbz19R5EZyoXfw4RV9EVIgwHWWT41wQf4sdeuSkfaLLE3e22PK49Artq5PO
         MmGLIRkjvgRshdfi9SNNv5A5CeZolMwkGyJeMlFKJxP+d+2c0QSbEdtwST4aEBCcW/ct
         rxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717687694; x=1718292494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yEWxbL5NnensqXJpLVqIiZQAjg93mRHbrdrY/PfhFrc=;
        b=V2xmu9qmArn48Sb5f5O2SBjY1Izfe+1eh3bdRvxMofSi/ECwt/XjWlsDz9nHkBhycp
         qwt61zAtjAOeAcWgzvcQxO9zJCENNBUE8xQ5be5qLjG+KmgZ954h314Nhxz5ijSOMFQM
         Jr+grQI0H14UYfGxHNGYHl3+q3TGWTXdWx2R7VkPJgtfAxTdHkhHXStVj824DSIY+VW1
         tiTGJb5UuhtQ/7UUVtveHevD1bWKstl+uuwjLDtlq1dBjxPNzPjwZfnjFXBtNQy83QPL
         ZQRJ51T7D4Ru2tD4vZ3m8Vf7hd957FE2J+Afpni36YXZuq7OqDaw6uv6moip1p58kabV
         yCXg==
X-Gm-Message-State: AOJu0YygcTnGnlMRiYsAEppgrjHDQtujyZIs0EHzuqe5icQMG/L8CMsm
	gwtmU0ZsJzVqEy6WvBGQJzTHcx+hE5AtJ8NVCjj1E9cwWZJzwIs/sxzQQg==
X-Google-Smtp-Source: AGHT+IEtNOThbatz9WpjUy1fODCic5CFclphB1xgd5aWxD7Lu83XKZcmaqHmhOxgjqczM/63w2l3ww==
X-Received: by 2002:a50:c314:0:b0:57a:2ccb:b3f1 with SMTP id 4fb4d7f45d1cf-57a8bcb420dmr3734641a12.26.1717687693600;
        Thu, 06 Jun 2024 08:28:13 -0700 (PDT)
Received: from localhost ([2a02:2f0e:516:6100:a708:ea71:b0ed:8744])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57aae134c03sm1264690a12.51.2024.06.06.08.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 08:28:13 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>
Subject: [PATCH] tests/bcachefs/single_device: test bcachefs format from source
Date: Thu,  6 Jun 2024 18:28:04 +0300
Message-Id: <20240606152804.866509-1-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test which checks formatting and initializing a bcachefs
filesystem from a source directory:
`bcachefs format --source=source_dir`

Create a new `prepare_fs` function shared by both `migrate_from_fs` and
`build_from_fs`.

Other changes:
- add `ro` mount options when `nochanges` is supplied
- add a function which checks rsync's --itemize-changes output
- pass the --hard-links options to rsync when comparing changes
- avoid creating hardlinks for symlinks

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
 tests/bcachefs/single_device.ktest | 101 +++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 7 deletions(-)

diff --git a/tests/bcachefs/single_device.ktest b/tests/bcachefs/single_device.ktest
index 8e9b5a3..4c9caa7 100755
--- a/tests/bcachefs/single_device.ktest
+++ b/tests/bcachefs/single_device.ktest
@@ -1252,11 +1252,8 @@ disabled_test_swapfile()
     check_counters ${ktest_scratch_dev[0]}
 }
 
-# migrate from other filesystems in place:
-
-migrate_from_fs()
+prepare_source_fs()
 {
-    set_watchdog 180
     local fstype=$1
 
     if [[ $fstype = ext4 ]]; then
@@ -1270,10 +1267,97 @@ migrate_from_fs()
     cp -a /usr /mnt
 
     for i in /mnt/usr/bin/*; do
+    if [ ! -L $i ]; then
 	ln $i ${i}-migrate2
-	setfattr -n user.foo -v test $i 
+    fi
+	setfattr -n user.foo -v test $i
     done
 
+}
+
+check_rsync_log()
+{
+    # rsync itemized output
+    # https://jhpce.jhu.edu/files/rsync-itemize-table/
+    # .: the item is not being updated (though it might have attributes that are being modified)
+
+    # We don't expect any lines to start with anything other than a dot
+    # Ideally the output should be empty, but the lost+found/ directory is
+    # ignored and the mountpoints themselves could have a modified time
+    # Sample expected output:
+    # .d..t...... ./
+    # .d..t...... lost+found/
+    ! grep -E '^[^.]' $1
+}
+
+# build a filesystem from a source
+
+build_from_fs()
+{
+    set_watchdog 180
+
+    prepare_source_fs $1
+
+    bcachefs format				\
+	--source=/mnt ${ktest_scratch_dev[1]} | tee /root/buildlog
+
+    echo "Attempting to mount bcachefs filesystem"
+
+    if true; then
+	mkdir -p /mnt2
+	mount -t bcachefs -o noexcl,nochanges,ro ${ktest_scratch_dev[1]} /mnt2
+
+	rsync	--archive			\
+	    --acls				\
+	    --xattrs				\
+	    --checksum				\
+	    --hard-links			\
+	    --dry-run				\
+	    --itemize-changes		 	\
+	    /mnt/ /mnt2/ > /root/rsynclog-build
+
+	check_rsync_log /root/rsynclog-build
+
+	umount /mnt2
+	echo "rsync passed"
+    fi
+
+    umount /mnt
+
+    bcachefs fsck -ny ${ktest_scratch_dev[1]}
+    check_counters ${ktest_scratch_dev[1]}
+}
+
+test_build_from_ext4()
+{
+    build_from_fs ext4
+}
+
+require-kernel-config XFS_FS
+test_build_from_xfs()
+{
+    build_from_fs xfs
+}
+
+require-kernel-config BTRFS_FS
+test_build_from_btrfs()
+{
+    build_from_fs btrfs
+}
+
+test_build_from_bcachefs()
+{
+    build_from_fs bcachefs
+}
+
+# migrate from other filesystems in place:
+
+migrate_from_fs()
+{
+    set_watchdog 180
+
+    prepare_source_fs $1
+
     bcachefs migrate				\
 	--encrypted				\
 	--no_passphrase				\
@@ -1287,16 +1371,19 @@ migrate_from_fs()
 
     if true; then
 	mkdir -p /mnt2
-	mount -t bcachefs -o noexcl,nochanges,sb=$offset ${ktest_scratch_dev[0]} /mnt2
+	mount -t bcachefs -o noexcl,nochanges,ro,sb=$offset ${ktest_scratch_dev[0]} /mnt2
 
 	rsync	--archive			\
 	    --acls				\
 	    --xattrs				\
 	    --checksum				\
+	    --hard-links			\
 	    --exclude=/bcachefs			\
 	    --dry-run				\
 	    --itemize-changes		 	\
-	    /mnt/ /mnt2/ > /root/rsynclog
+	    /mnt/ /mnt2/ > /root/rsynclog-migrate
+
+	check_rsync_log /root/rsynclog-migrate
 
 	umount /mnt2
 	echo "rsync passed"
-- 
2.34.1

