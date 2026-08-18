Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [178.154.239.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623E0456E02;
	Tue, 18 Aug 2026 12:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787054670; cv=none; b=eBc7MEMBPxIvCWAZ/U1vE9atlgSTnmgMiZriazbPZTPNtyaRqePo8G/Fuh05FCctVC3Fp+l8eYtPewD8HWANQG3NLtVEMuqp2hFRh6Q+WmxxgL8uHMSiPAHSwd5MTpVAuFpt5/wdy37fivM8EXAlwnvYnVkTGzDu95z2NNy/fEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787054670; c=relaxed/simple;
	bh=8izKcFM39WUbB1GC4eIz+aEgNUrW7s6A+t7KhR0f2qA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qiGYhkESYwVVAWoSf59RznSqgkNxU96dT/hz2PFVMPzXKK8fDbuYqQUoSRH7HxNot82eTT3V/7YZFzTvQ6rHTg2mec1QALiC4zqpa5A6SCqqb6QMH67h2HJEQbKqk31hPCuBxBIfP9bkaXuuQoYdRuuIKtNJbl13ij+i8cpaDmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=LsJQU/m3; arc=none smtp.client-ip=178.154.239.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="LsJQU/m3"
Received: from mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:3388:0:640:154:0])
	by forward101a.mail.yandex.net (postfix) with ESMTPS id 9CE9580691;
	Tue, 18 Aug 2026 15:04:17 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net (smtp) with ESMTPSA id F4U21qOfxW20-fcuZGg6L;
	Tue, 18 Aug 2026 15:04:17 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1787054657; bh=8YqVf+6mnkApTNGiALyL1qs3No+/mJZ19C4EbCiGLQU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=LsJQU/m3wiSdwFoYL9pM6TMPRLtjCcsRigURX9q8GaTlhVRzMosquPJ3vDeOKmohF
	 9p4rceLzQ+jqCeueRapiSce6Wmwq5R1HmMmL75cCxYhRjJTcvLltj3oz7ueDd7PXEZ
	 UQt5d1FDepu+LSnFWrhVNDeAyq0fl/q6l1hSduGA=
Authentication-Results: mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 6.12] bcachefs: fix memory leak in journal_entry_clock_validate()
Date: Tue, 18 Aug 2026 15:02:52 +0300
Message-ID: <20260818120253.2627516-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Local fuzzing of 6.12.103 has found the following memory leak:

unreferenced object 0xffff88810c016a00 (size 128):
  comm "syz.0.17", pid 10418, jiffies 4294953713
  hex dump (first 32 bytes):
    69 6e 76 61 6c 69 64 20 6a 6f 75 72 6e 61 6c 20  invalid journal
    65 6e 74 72 79 2c 20 76 65 72 73 69 6f 6e 3d 31  entry, version=1
  backtrace (crc af3a070b):
    kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    slab_post_alloc_hook mm/slub.c:4166 [inline]
    slab_alloc_node mm/slub.c:4211 [inline]
    __do_kmalloc_node mm/slub.c:4345 [inline]
    __kmalloc_node_track_caller_noprof+0x1ee/0x3d0 mm/slub.c:4365
    __do_krealloc mm/slab_common.c:1242 [inline]
    krealloc_noprof+0x76/0x110 mm/slab_common.c:1291
    bch2_printbuf_make_room+0x1c9/0x330 fs/bcachefs/printbuf.c:59
    prt_bytes fs/bcachefs/printbuf.h:218 [inline]
    prt_str+0x3d/0x740 fs/bcachefs/printbuf.h:230
    journal_entry_err_msg+0x55/0x1a0 fs/bcachefs/journal_io.c:276
    journal_entry_clock_validate+0x161/0x430 fs/bcachefs/journal_io.c:642
    bch2_sb_clean_validate_late fs/bcachefs/sb-clean.c:40 [inline]
    bch2_read_superblock_clean+0x1c3/0x4d0 fs/bcachefs/sb-clean.c:168
    bch2_fs_recovery+0x6e/0x2bf0 fs/bcachefs/recovery.c:637
    bch2_fs_start+0x34f/0x5a0 fs/bcachefs/super.c:1037
    bch2_fs_get_tree+0x8c1/0xff0 fs/bcachefs/fs.c:2172
    vfs_get_tree+0x8c/0x2a0 fs/super.c:1814
    do_new_mount+0x23c/0xa20 fs/namespace.c:3564
    do_mount fs/namespace.c:3904 [inline]
    __do_sys_mount fs/namespace.c:4114 [inline]
    __se_sys_mount+0x250/0x300 fs/namespace.c:4091
    do_syscall_x64 arch/x86/entry/common.c:47 [inline]
    do_syscall_64+0xbe/0x1a0 arch/x86/entry/common.c:78
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

As of 6.12, there are a few weird macros like 'journal_entry_err()'
and 'mustfix_fsck_err()' which issues 'goto' out of the macro body.
This makes explicit cleanups (including calls to 'printbuf_exit()'
for 'struct printbuf' objects) somewhat tricky. Never-released
patches intended for 6.17 have tried to solve this problem by using
'__attribute__((cleanup))', but it's hardly possible (and reasonable)
to backport all (or even some) of them to 6.12. As for the particular
memory leak described above, the simplest possible workaround is to
switch to 'struct printbuf' object with stack-allocated data buffer.
In my tests, this buffer never actually grows beyond 128 bytes, and
in the worst-case scenario we just end being warned with unexpectedly
long error message not emitted.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/bcachefs/journal_io.c | 4 ++--
 fs/bcachefs/printbuf.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index fb35dd336331..c900b09d7599 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -294,7 +294,8 @@ static void journal_entry_err_msg(struct printbuf *out,
 
 #define journal_entry_err(c, version, jset, entry, _err, msg, ...)	\
 ({									\
-	struct printbuf _buf = PRINTBUF;				\
+	char _data[256];						\
+	struct printbuf _buf = { .buf = _data, .size = sizeof(_data) };	\
 									\
 	journal_entry_err_msg(&_buf, version, jset, entry);		\
 	prt_printf(&_buf, msg, ##__VA_ARGS__);				\
@@ -313,7 +314,6 @@ static void journal_entry_err_msg(struct printbuf *out,
 		break;							\
 	}								\
 									\
-	printbuf_exit(&_buf);						\
 	true;								\
 })
 
diff --git a/fs/bcachefs/printbuf.c b/fs/bcachefs/printbuf.c
index 4cf5a2af1e6f..560318766f23 100644
--- a/fs/bcachefs/printbuf.c
+++ b/fs/bcachefs/printbuf.c
@@ -38,7 +38,7 @@ int bch2_printbuf_make_room(struct printbuf *out, unsigned extra)
 	if (out->pos + extra <= out->size)
 		return 0;
 
-	if (!out->heap_allocated) {
+	if (WARN_ON(!out->heap_allocated)) {
 		out->overflow = true;
 		return 0;
 	}
-- 
2.55.0

