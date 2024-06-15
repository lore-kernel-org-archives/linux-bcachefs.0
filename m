Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7407428DD5;
	Sat, 15 Jun 2024 11:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718452154; cv=none; b=uLhDbQKtpoyiQ4ZySdiue7h7VRwY5P1AqWJtGUNM4NPKZ+5IjU8iJ3YMJBDLYoWYTZddbINQThpOX2yQOVjA5kvbJT2eL8ffEZyMJXlNIsa1h5grpFhIDUGiQmB4MYYmU6SpQL5FhS4hqhQdgKlQtk+0L2yZvZz1D3+aa6G0r4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718452154; c=relaxed/simple;
	bh=ruLqlnGQm+f4xdxIVdkx2ifiUgj5LizSyB2S5sU5KH4=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=g/mulT2rFEEjAszXW+yTjDnctZEvR0TlKAaJcMQ0UGC4aQE1PCbOxyHtAdSqdAl5FuMAIv6ey2/xSFLZV5RsjML3yqvI4PCTbOK1puj09F5OfITRk4N9jNuEBqbXSD1/Oh5S+02bykrSY/7g3iPmErjGR1SJjKXCdHmvBg98yA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=OCV1qhA2; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="OCV1qhA2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1718451845; bh=eoJFGXM2xF4IOwu+tTtspFwBzWcyjYzOFEGvvryPvyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCV1qhA2CWhipezswYOuYfRaF7yEnC6SJg9UUnCBAungW//PMoTrwP+a/+X8vUnOO
	 2vyJ2peYbry6xZmsTEaL/Co6MjGOQ8RCQOj+uc4fbewWlPdB5FEffOPurFlF/1xUAz
	 BgE4AfB1F7prQx9eHSpENXfp48ZKH5VJZ6S1pFlY=
Received: from pek-lxu-l1.wrs.com ([111.198.228.103])
	by newxmesmtplogicsvrszb9-1.qq.com (NewEsmtp) with SMTP
	id B0337AFE; Sat, 15 Jun 2024 19:44:03 +0800
X-QQ-mid: xmsmtpt1718451843tz3r2n3i2
Message-ID: <tencent_724B611BCF250EBAF7BBE333DF9E271BB208@qq.com>
X-QQ-XMAILINFO: NyTsQ4JOu2J2zOZ5ZNYHLqT+E8AFNcEs6DXo2yNVb+UXeNPB5diAbUnz9GHwqE
	 zTDpQC3WqgN/d38mDOsQOuBmMnYYBMUCPXzjfkGvA+afBPf6jTfgHDziyqlPlYapRaXr079ramFJ
	 xGcNUKrTKTQVs7AkI547MGQTz/ZhyXZmG72AJCkB0dOZdUV6FNiNFDI0SyRhV/N7fjNY4Wvbkkah
	 R/n+6ZVU5Aufl/chDnioaXHEoIHgN4CS2xIZbxqWjJGXsjna5BzaQLCmUM/gTK4Ad+UCp/AVtXzD
	 1Pcmp6Ig2haNUNg+lU9k5L0MMdyIsHBcQdkegdSsNvHSHuZ+xeIiTmLSB7x5CW4c+KT8wmXJC89Y
	 q9LYCneVhWbkxK0MXzVRDayy9rikfaiyG1kSJ8DELQs3TU2YAqeyXYCjS0pdravcPpIRl5W9FHgA
	 tuJuBeqO45HjINimKpzcU4dnlZJUkMMgjYGxaU2TGn9YyoubNHvrRjl+mEfdgQlBU/IWwqv9zzUL
	 7/MvQ7ALXhRmt5+hGvodGzIlUwazE1wc/8mGAOg7qzHUO0w9gI/FxEaZdjhJ3YWAAZrBOytrcaMO
	 aNOYOyQIz07q11A678SQX0eA0pdlDPIk9NDF0LRuGp8dYCQOIrXBIF5U4hdYotzzISCy5ZWQVBH2
	 IUVmsgJOj0Q2Gvrc8JRxJM4bRg7+2obLOi+gCgtxHKA4lXpB6I/auVjqkquKWt0LtuxZV558xA1c
	 uGMk5VwjmeZO8m3bX+6z2lHl2zneV0maNJTEyU7kELkKvD39DnAJws+3a3X3sfb2znvuXt13ZI0b
	 xaeMrRy7E8UzN/pclcRzLlovis5xHZYpXpaGIFoPZcZBWsnVtDyAR5TLrTi6jCuVnxKzZxSXWCb6
	 6jAE/2vnFAq6jEGAU7aSzi0uNXrw6+m47vBw+GlYuvwR4d8NDCXUBp4cIIOHZU7VR0jDWdnN1+
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+4366624c0b5aac4906cf@syzkaller.appspotmail.com
Cc: bfoster@redhat.com,
	kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] bcachefs: bch2_fs_read_write_early needs to hold write lock
Date: Sat, 15 Jun 2024 19:44:04 +0800
X-OQ-MSGID: <20240615114403.3924547-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <00000000000053e574061ad89521@google.com>
References: <00000000000053e574061ad89521@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bch2_fs_read_write_early() needs to hold state_lock to pretect and sync data.

Reported-by: syzbot+4366624c0b5aac4906cf@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/bcachefs/snapshot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 51918acfd726..b27a4327274d 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -1566,7 +1566,9 @@ int bch2_delete_dead_snapshots(struct bch_fs *c)
 		return 0;
 
 	if (!test_bit(BCH_FS_started, &c->flags)) {
+		down_write(&c->state_lock);
 		ret = bch2_fs_read_write_early(c);
+		up_write(&c->state_lock);
 		bch_err_msg(c, ret, "deleting dead snapshots: error going rw");
 		if (ret)
 			return ret;
-- 
2.43.0

