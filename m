Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [178.154.239.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9344047A0B5
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Aug 2026 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787242124; cv=none; b=CxdJInNAwACM4bwnVh5TCkyUSgROcomu71N8KVOVEQeF2pqxneM4z37mC+TSa1WjEf4tF7L/fPBvT3gQVgt0cYsPaFnXbZoln9YG1nv7F4o1my8LqAYS4AT24RMneIDd1MkWDJUiU5H0dSvg02dtWHD4Vkc1S/alOQcuZgXWqwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787242124; c=relaxed/simple;
	bh=+1JFTvRAeFl/0pUjxiOtGgpImEqZrMzPeRd/W436Qdg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OcZ45ik/JioYat+LjsnlfGOBnY1FEs7dpNqWYBXssRxQ7P3rvl6JAezEE+YmD+Ra2H3v5MxcGfaVxtUDfd1tFmcfv41vD0YshnNJyQ0Et6paNUYnUQQbdq1f3B7KzWU/prZqFqBBL8zqm3tC6vdgrrZrtMPXcthaIHwg0MTO00s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=bpFZfk3y; arc=none smtp.client-ip=178.154.239.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="bpFZfk3y"
Received: from mail-nwsmtp-smtp-production-main-76.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-76.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:91a0:0:640:24f1:0])
	by forward100d.mail.yandex.net (postfix) with ESMTPS id E1398C00A4;
	Thu, 20 Aug 2026 19:08:37 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-76.iva.yp-c.yandex.net (smtp) with ESMTPSA id a8aQ6W9dGqM0-X43UBw1m;
	Thu, 20 Aug 2026 19:08:37 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1787242117; bh=nUFhKorFwuu7GqfXBrdKEIPoTST7TkNt+zXki/71Fs4=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=bpFZfk3yR1PfHl24v+mV/v+TpimlQRwpD1GKE2dbJF1EkB9rp4apt749AiXCNrW5Y
	 QiSESfSUxod+AgNZ2QaECjwB6IHoRmL8vQdS00IZp+iH44ODioFPKYtcBRWBoqob9f
	 mugmTYdV8ukGLKa0GqdaDtpmfY8mp/t2gh1XPN9s=
Authentication-Results: mail-nwsmtp-smtp-production-main-76.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] bcachefs: fix memory leak in bch2_setattr_nonsize_trans()
Date: Thu, 20 Aug 2026 19:08:18 +0300
Message-ID: <20260820160818.444997-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Local fuzzing of 6.12.103 has found the following memory leak:

unreferenced object 0xffff888105f40700 (size 64):
  comm "syz.0.17", pid 10384, jiffies 4294952060
  hex dump (first 32 bytes):
    01 00 00 00 80 88 ff ff 0c 00 00 00 ad 04 74 01  ..............t.
    00 00 b0 7f 10 f7 00 00 04 00 00 00 01 00 07 00  ................
  backtrace (crc 8943d909):
    kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    slab_post_alloc_hook mm/slub.c:4166 [inline]
    slab_alloc_node mm/slub.c:4211 [inline]
    __do_kmalloc_node mm/slub.c:4345 [inline]
    __kmalloc_node_track_caller_noprof+0x1ee/0x3d0 mm/slub.c:4365
    kmemdup_noprof+0x2b/0x70 mm/util.c:133
    kmemdup_noprof include/linux/fortify-string.h:753 [inline]
    posix_acl_clone fs/posix_acl.c:232 [inline]
    __posix_acl_chmod+0x78/0x500 fs/posix_acl.c:583
    bch2_acl_chmod+0x523/0x800 fs/bcachefs/acl.c:430
    bch2_setattr_nonsize+0xbb8/0xfc0 fs/bcachefs/fs.c:1063
    notify_change+0xb2b/0xe30 fs/attr.c:503
    chmod_common+0x1a7/0x2f0 fs/open.c:651
    do_fchmodat+0x91/0x130 fs/open.c:697
    __do_sys_fchmodat fs/open.c:716 [inline]
    __se_sys_fchmodat fs/open.c:713 [inline]
    __x64_sys_fchmodat+0x7d/0x90 fs/open.c:713
    do_syscall_x64 arch/x86/entry/common.c:47 [inline]
    do_syscall_64+0xbe/0x1a0 arch/x86/entry/common.c:78
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix this by using 'posix_acl_release()' to balance refcounting
of the corresponding 'struct posix_acl' object.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/bcachefs/vfs/fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/vfs/fs.c b/fs/bcachefs/vfs/fs.c
index df6acc5ab0b3..dc4e438434b1 100644
--- a/fs/bcachefs/vfs/fs.c
+++ b/fs/bcachefs/vfs/fs.c
@@ -1115,6 +1115,7 @@ static int bch2_setattr_nonsize_trans(struct btree_trans *trans,
 
 	if (acl) {
 		set_cached_acl(&inode->v, ACL_TYPE_ACCESS, acl);
+		posix_acl_release(acl);
 		acl = NULL;
 	}
 
-- 
2.55.0

