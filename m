Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1ADF1CCCCB
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Jul 2024 18:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719946205; cv=none; b=INHoJlV2ljHIoVepY1XJk+mp5AafXIh/gxHZ3no2XlsaqWywWLfGuJG4Zz9wW95LgVhTw3hvIxHd+uru/KrGpZu3JqYy60rZPr4RcakpZwM+c4c/SyryPKSmkzbNLaTrhKkdurbLZC8MswE8N+83f9QZ+F8c3NMshRk77p3q134=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719946205; c=relaxed/simple;
	bh=Kb5zofY5CgGXuxde/qTf5TC35qXKkz8RnMWck6qdQ6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=twUfsIY1m4cD7059sOzvPudz3NUTcf/rvVHp5Re76V/XFyxZuKTUfZ92L9/ymR1tLudgKCzRCBFPRfXQ53E7Nrr05tkVqY0ZZ+WSFPZ31opzCwkgiWQQxTcJY6J4MtgdSSN1uVq4xDGar2ODmDsAKIJyEku/X8vyAZ0erqChNYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ckyplSgc; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ckyplSgc"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4255fc43f1cso31831665e9.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 02 Jul 2024 11:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719946201; x=1720551001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b1WBLg7AmyUCdqAxaTnWc9s0byXZklQmVnoJjWe40fA=;
        b=ckyplSgceXUtPloGoKr1QwR/DFuN+Il83yDX8IAvwINwdcOQioxImUHi9BvMhr41MH
         1Z84Gf0zKCyyYSSsTlnmaadsRuQhQ+24h5Ke51nEU78UXVex+iTQS14QAQNcq+dQYr+v
         dql2zdCVv8rXuwEGv4zZEsvWMPZGoQ4/vyZdtYf6pfoAcuBhjWzAaA4tg4JnQpVC8nh0
         RvL0qbIbM6ulPd0O6wpTGM3vFlIYIgyH5alyh5JDSVL+7AOiW0F92ZcUllzonITZrqPL
         labvFwmMX4x4N7kI308o12eh9VeXIDb1cVVUL3iwf8Xxyu2pfL08fkz2h+BnYeKi9FTp
         +d8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719946201; x=1720551001;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b1WBLg7AmyUCdqAxaTnWc9s0byXZklQmVnoJjWe40fA=;
        b=NMs0M2IroFf8XAI8Gze669YRDPhy9hWDmuRQqFUpZoEJOu/dz87L5SsgdZ1tkEfe4u
         BcxJOqHZPHMXkun01QeAdqM7DjsRIcKZVgnn9E9BOmQyRhPpwkJfin5taTTvz+96VwUC
         yTHP2uSimAS11lgVnd0iDYhmSGe2f6FlDHNqNVWzHtBtTx8ki2b0KlmbcUmWduC0rSTD
         2PuH/sbhJxCiHMZ3EGuxfB3rffTTaBz50Bb838i9RZpbnBDdWbZCMwxuuDy5ISHiqnBE
         8E/A2T3x++vVBSl4WjDWqEjImkHhtrMWRDsgukdXeVCARHNWcjufKNL2cZ8WotVMkGPc
         5zGQ==
X-Gm-Message-State: AOJu0YzQ8MRruz58X4Cgs9kHiA4XG0vnAK8mcDdc2GrFIWj+5RGy0EcO
	zB7sHsL6/qHBAbjNP4Y37kbYDxpDVBiqei0O6WdEBj3rnotcdNzOuXCb8w==
X-Google-Smtp-Source: AGHT+IGgQwvXADPGZgxDDgBExx71t61jw+WQhxQkiu/FuoFZorsTMPNkB3Ey0tYqp3mc5qdS1FFHHw==
X-Received: by 2002:a05:600c:492f:b0:425:5f6d:2f3c with SMTP id 5b1f17b1804b1-4257a08907amr64539695e9.39.1719946201142;
        Tue, 02 Jul 2024 11:50:01 -0700 (PDT)
Received: from localhost ([2a02:2f0e:615:a300:9dd2:8f0a:1f05:f0f1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4256af3b8c0sm205557475e9.2.2024.07.02.11.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 11:50:00 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <amiculas@cisco.com>
Subject: [PATCH] tests/puzzlefs: add a ktest for PuzzleFS
Date: Tue,  2 Jul 2024 21:49:43 +0300
Message-Id: <20240702184943.1495489-1-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ariel Miculas <amiculas@cisco.com>

This test builds a PuzzleFS image using the PuzzleFS user space tools,
builds a Linux kernel with PuzzleFS enabled, mounts the PuzzleFS image
using the kernel driver and then compares the two filesystems: the
source filesystem used when building the PuzzleFS image and the final
PuzzleFS filesystem mounted directly from the PuzzleFS image.

This test is similar to the build_from_ext4 test in single_device.ktest.

Two packages are added to the root_image: capnproto required for
building the PuzzleFS user space tools and jq, which is used for
extracting the PuzzleFS image manifest from index.json.

Signed-off-by: Ariel Miculas <amiculas@cisco.com>
---
 root_image                    |  3 ++
 tests/puzzlefs/puzzlefs.ktest | 94 +++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)
 create mode 100755 tests/puzzlefs/puzzlefs.ktest

diff --git a/root_image b/root_image
index 65d0a72..386fdfb 100755
--- a/root_image
+++ b/root_image
@@ -117,6 +117,9 @@ PACKAGES+=(cryptsetup)
 # weird block layer crap
 PACKAGES+=(multipath-tools sg3-utils srptools)
 
+# PuzzleFS support
+PACKAGES+=(capnproto jq)
+
 # ZFS support
 #PACKAGES+=("linux-headers-generic" dkms zfsutils-linux zfs-dkms)
 
diff --git a/tests/puzzlefs/puzzlefs.ktest b/tests/puzzlefs/puzzlefs.ktest
new file mode 100755
index 0000000..ffe68c4
--- /dev/null
+++ b/tests/puzzlefs/puzzlefs.ktest
@@ -0,0 +1,94 @@
+#!/bin/bash
+#
+# PuzzleFS tests
+#
+
+. $(dirname $(readlink -e ${BASH_SOURCE[0]}))/../test-libs.sh
+
+require-git https://github.com/project-machine/puzzlefs
+require-make puzzlefs
+
+config-mem 4G
+config-compiler clang
+require-kernel-config RUST
+require-kernel-config MISC_FILESYSTEMS
+require-kernel-config PUZZLEFS_FS
+config-scratch-devs 4G
+
+check_rsync_log()
+{
+    # rsync itemized output
+    # https://jhpce.jhu.edu/files/rsync-itemize-table/
+    # .: the item is not being updated (though it might have attributes that are being modified)
+    # h: the item is a hard link to another item (requires --hard-links).
+
+    # We don't expect any lines to start with anything other than a dot or h
+    # Ideally the output should be empty, but the lost+found/ directory is
+    # ignored and the mountpoints themselves could have a modified time
+    # Sample expected output:
+    # .d..t...... ./
+    # .d..t...... lost+found/
+    ! grep -E '^[^.h]' $1
+}
+
+prepare_source_fs()
+{
+    local fstype=$1
+
+    if [[ $fstype = ext4 ]]; then
+	run_quiet "" mkfs.$fstype -F ${ktest_scratch_dev[0]}
+	mount -t $fstype -o user_xattr ${ktest_scratch_dev[0]} /mnt
+    else
+	run_quiet "" mkfs.$fstype -f ${ktest_scratch_dev[0]}
+	mount -t $fstype ${ktest_scratch_dev[0]} /mnt
+    fi
+
+    # Copy only /usr/bin until PuzzleFS can handle larger filesystems
+    cp -a /usr/bin /mnt
+
+    for i in /mnt/bin/*; do
+	if [ ! -L $i ]; then
+	    ln $i ${i}-migrate2
+	    setfattr -n user.foo -v test $i
+	fi
+    done
+}
+
+# build a filesystem from a source
+build_from_fs()
+{
+    set_watchdog 180
+
+    prepare_source_fs $1
+
+    puzzlefs build /mnt /tmp/puzzlefs-oci pfs_image
+
+    echo "Attempting to mount puzzlefs filesystem"
+    local image_manifest=$(jq -r ".manifests[] | .digest" /tmp/puzzlefs-oci/index.json | cut -d ':' -f2)
+
+    mkdir -p /mnt2
+    mount -t puzzlefs -o oci_root_dir="/tmp/puzzlefs-oci" -o image_manifest="$image_manifest" none /mnt2
+
+    rsync --archive				\
+	--acls					\
+	--xattrs				\
+	--checksum				\
+	--hard-links				\
+	--dry-run				\
+	--itemize-changes		 	\
+	/mnt/ /mnt2/ > /root/rsynclog-build
+
+    check_rsync_log /root/rsynclog-build
+
+    umount /mnt2
+    echo "rsync passed"
+
+    umount /mnt
+}
+
+test_build_from_ext4()
+{
+    build_from_fs ext4
+}
+
+main "$@"
-- 
2.34.1

