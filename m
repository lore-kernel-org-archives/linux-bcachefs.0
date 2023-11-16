Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y5WGuSBq"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E656C101
	for <linux-bcachefs@vger.kernel.org>; Thu, 16 Nov 2023 09:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700154785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IflBU0fOl+eZDbFgEmkG+fKLwzAOY1dyKDn50eHXVlg=;
	b=Y5WGuSBqh+tWLf76f5YAs1CN3KWleZ0nrMr9SPP0hBqxG5IoJzg48vD+Nue+f94aPbjnNS
	cNnK4bmdlvDqVH6EkEDiXdkdfNFMep9QUi3Qr4KYFXcE4WguvGPerq/yruobjml0N7VCl8
	MlhiPxLqZ6wto3S/KEOI5Jl+jzbTusw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-j00f8eZKM1Oi1gpREmaoCQ-1; Thu, 16 Nov 2023 12:13:03 -0500
X-MC-Unique: j00f8eZKM1Oi1gpREmaoCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66C5081B560
	for <linux-bcachefs@vger.kernel.org>; Thu, 16 Nov 2023 17:13:03 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.127])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4C0895028
	for <linux-bcachefs@vger.kernel.org>; Thu, 16 Nov 2023 17:13:03 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: preserve device path as device name
Date: Thu, 16 Nov 2023 12:13:43 -0500
Message-ID: <20231116171343.699909-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Various userspace scripts/tools may expect mount entries in
/proc/mounts to reflect the device path names used to mount the
associated filesystem. bcachefs seems to normalize the device path
to the underlying device name based on the block device. This
confuses tools like fstests when the test devices might be lvm or
device-mapper based.

The default behavior for show_vfsmnt() appers to be to use the
string passed to alloc_vfsmnt(), so tweak bcachefs to copy the path
at device superblock read time and to display it via
->show_devname().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

I was looking into the freeze related generic/459 test failures and it
seems like there are two issues. One is the same reason fstests seems to
fall over any time the test/scratch devices are lvm based, which is that
bcachefs will show the /dev/dm-N devices in mount output vs. the
/dev/mapper/xxx format that the test scripts use. AFAICT most other
filesystems present the mount entry device based on the device path with
a slight difference with btrfs, which does the same thing but only shows
the "latest" device rather than listing all devices associated with the
fs.

The second issue is I think more of a test problem in that it assumes fs
shutdown reflects as "ro" mount status, which isn't always true for
bcachefs (or XFS). I have a tweak to the test to try and improve that
particular check, which combined with this patch allows the test to pass
reliably on bcachefs. The scope of fstests changes probably depends on
what we do on the kernel side, however, so I wanted to see what thoughts
we have on something like this. Hm?

Brian

 fs/bcachefs/fs.c          | 3 +--
 fs/bcachefs/super-io.c    | 5 +++++
 fs/bcachefs/super_types.h | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index f76d403ccb76..424c3da188bb 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1667,8 +1667,7 @@ static int bch2_show_devname(struct seq_file *seq, struct dentry *root)
 		if (!first)
 			seq_putc(seq, ':');
 		first = false;
-		seq_puts(seq, "/dev/");
-		seq_puts(seq, ca->name);
+		seq_puts(seq, ca->disk_sb.sb_name);
 	}
 
 	return 0;
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index f4cad903f4d6..f3e12f7979d5 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -166,6 +166,7 @@ void bch2_free_super(struct bch_sb_handle *sb)
 	if (!IS_ERR_OR_NULL(sb->bdev))
 		blkdev_put(sb->bdev, sb->holder);
 	kfree(sb->holder);
+	kfree(sb->sb_name);
 
 	kfree(sb->sb);
 	memset(sb, 0, sizeof(*sb));
@@ -675,6 +676,10 @@ int bch2_read_super(const char *path, struct bch_opts *opts,
 	if (!sb->holder)
 		return -ENOMEM;
 
+	sb->sb_name = kstrdup(path, GFP_KERNEL);
+	if (!sb->sb_name)
+		return -ENOMEM;
+
 #ifndef __KERNEL__
 	if (opt_get(*opts, direct_io) == false)
 		sb->mode |= BLK_OPEN_BUFFERED;
diff --git a/fs/bcachefs/super_types.h b/fs/bcachefs/super_types.h
index 7dda4985b99f..9c1fd4ca2b10 100644
--- a/fs/bcachefs/super_types.h
+++ b/fs/bcachefs/super_types.h
@@ -5,6 +5,7 @@
 struct bch_sb_handle {
 	struct bch_sb		*sb;
 	struct block_device	*bdev;
+	char			*sb_name;
 	struct bio		*bio;
 	void			*holder;
 	size_t			buffer_size;
-- 
2.41.0

