Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VLlc/aFD"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC42106
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 Nov 2023 11:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701371790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SVsy4bHVicY2Q7XP0Chhi9Qh3zIEvaJp4ubK1MjmXsE=;
	b=VLlc/aFDMujEySCjZVT+6ODhhLvlA7D9jJvknATnCciBTn/uyv0CVYzGqUY7Nupl7LSV13
	qw7iWf4L40W53StlP5khJCu1XNOQ+/kNDxHnItmqTcQOh3+hymxtVtpMFJlHxDA+4wuoH+
	8B4LhbHnFq5pnzaFjFNj3diGLsAXauo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-Y3ca_mPLOhOYrqoP8JYUNQ-1; Thu,
 30 Nov 2023 14:16:23 -0500
X-MC-Unique: Y3ca_mPLOhOYrqoP8JYUNQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BABA61C06506
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 Nov 2023 19:16:22 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B8542166B26
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 Nov 2023 19:16:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: remove sb lock and flags update on explicit shutdown
Date: Thu, 30 Nov 2023 14:17:11 -0500
Message-ID: <20231130191711.384300-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

bcachefs grabs s_umount and sets SB_RDONLY when the fs is shutdown
via the ioctl() interface. This has a couple issues related to
interactions between shutdown and freeze:

1. The flags == FSOP_GOING_FLAGS_DEFAULT case is a deadlock vector
   because freeze_bdev() calls into freeze_super(), which also
   acquires s_umount.

2. If an explicit shutdown occurs while the sb is frozen, SB_RDONLY
   alters the thaw path as if the sb was read-only at freeze time.
   This effectively leaks the frozen state and leaves the sb frozen
   indefinitely.

The usage of SB_RDONLY here goes back to the initial bcachefs commit
and AFAICT is simply historical behavior. This behavior is unique to
bcachefs relative to the handful of other filesystems that support
the shutdown ioctl(). Typically, SB_RDONLY is reserved for the
proper remount path, which itself is restricted from modifying
frozen superblocks in reconfigure_super(). Drop the unnecessary sb
lock and flags update bch2_ioc_goingdown() to address both of these
issues.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is currently churning through CI here (though I had already pushed
an early version that ran clean):

https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

Brian

 fs/bcachefs/fs-ioctl.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 5a39bcb597a3..0baa23c35ef5 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -287,34 +287,26 @@ static int bch2_ioc_goingdown(struct bch_fs *c, u32 __user *arg)
 
 	bch_notice(c, "shutdown by ioctl type %u", flags);
 
-	down_write(&c->vfs_sb->s_umount);
-
 	switch (flags) {
 	case FSOP_GOING_FLAGS_DEFAULT:
 		ret = freeze_bdev(c->vfs_sb->s_bdev);
 		if (ret)
-			goto err;
-
+			break;
 		bch2_journal_flush(&c->journal);
-		c->vfs_sb->s_flags |= SB_RDONLY;
 		bch2_fs_emergency_read_only(c);
 		thaw_bdev(c->vfs_sb->s_bdev);
 		break;
-
 	case FSOP_GOING_FLAGS_LOGFLUSH:
 		bch2_journal_flush(&c->journal);
 		fallthrough;
-
 	case FSOP_GOING_FLAGS_NOLOGFLUSH:
-		c->vfs_sb->s_flags |= SB_RDONLY;
 		bch2_fs_emergency_read_only(c);
 		break;
 	default:
 		ret = -EINVAL;
 		break;
 	}
-err:
-	up_write(&c->vfs_sb->s_umount);
+
 	return ret;
 }
 
-- 
2.41.0

