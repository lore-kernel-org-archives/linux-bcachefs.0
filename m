Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95A2522A;
	Wed, 26 Jun 2024 00:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719362402; cv=none; b=uhTHLi2alXJ6cjQWuIdag9VV+Z77WPDMGhqNFFznkdGmyEquKS51DOtOSPbZ1irPjtNNf2Qj0q4H4J8r52OSek6HTr+nXt7JTM/7hgl+9KKYbZHoLVtAaOiHm4T6SztQ2NXLeMBuJqBAadkrB0R+vqTMTBqGV0VOcPVXpPBnAfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719362402; c=relaxed/simple;
	bh=nAAboattMDWw0GSvPKDB9G5XT9DIggzKYBOB4CVd2TU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=nOlq/biBW7XLz34WQTPiIeJHzP57K6Z7hyKqhmmnxCev+t9pw3/39GoGTjpYu07tzqyox39QDicOZU/rP3yutXBzzOMLCoqwPef4DLk707fc1NL/VEh1nv8R3W9sV0VS4VQLal+BX1eyPoF6VK3m7T7psXMWKD6oI7S/ykjhOpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fYChODfI; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fYChODfI"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3c9d70d93dbso4080693b6e.3;
        Tue, 25 Jun 2024 17:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719362400; x=1719967200; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NybrsZoQ5NkZHnc8LjAToGVxa3rG+ocUIRAyW06Tmpw=;
        b=fYChODfIfLfQ5C+TUa5AE4qWo8FFGQU0jYjB15GWEm0VORPEynLq7nUGqZW+A5/Sw5
         PBZCvLEQI1o2Pxy/HGwfN1QvlI0oYa7/R4R7zfv587INnFrMe1UO2qkh5jjMjsp+Mymj
         uV5oZpHXg3dCODDD/jaZPawzf8wlFajFiBJJeCCze2XLy2lk2IvNzj4TaLttRwrKrHhY
         sGsP2qwXpNFkJOSBTeMAj+waZ4yFVfEFwOhaggigRTUNerBotRzlWADhjOFL7PAP6TDf
         Rvavl5CD0T2+qaS4QkSPqy9YN8jvWa/+QfrL2g1FiEFcbizU0wSdya513k7UbSvGkfPD
         bggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719362400; x=1719967200;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NybrsZoQ5NkZHnc8LjAToGVxa3rG+ocUIRAyW06Tmpw=;
        b=T4jBiFbtIseJBeg1Rfp0tBouXWwXhP/Z04IbE5oIBcnAG6GbQjg66YbTDL9FPxh9rS
         syn92RIGxuU7VpifQrZdrQuqdGHAVvp0RAqUNoxpatlPzW89zXiQwamv5R0rEpDX5B1g
         /Kn0PnGjHfXaBHOJPoajnR4azWNl5BBtdPObGBBy4HE8PYtBUbvUzlFBko7JC5CiaObQ
         amAaLzS+sTsO0zSeU0BYZnyZVBYTIs6H7h5TqGMzEOp8fFGpt7IuDpIV4q6URqS/2N+z
         Yet+3xZ83f0mLq2XsmCiv/19roNvjme8zJsjw+sISX1Xn+dCqJMryvAYy3Wht5Bl4U1p
         PHHw==
X-Forwarded-Encrypted: i=1; AJvYcCUVBhbOGRKUJDCCOea/ownB54vZrimHMtTm/smB4a/f0KZ5p5HYnly2oQRYiulV0cPeWyj3s4foEVStyX1qdN6rM7iC9zYtpnkEtlus
X-Gm-Message-State: AOJu0YyKv4I1K1A1NdAiE4TtNwKDXFXAb3ASKNXGYAkNXrA2umVKtQs9
	2a9v2fY6sFNfYbGDVrqUV6c7LTwkoP3llPTPgqD++Z5jXkAZeZg5TtNrY92u
X-Google-Smtp-Source: AGHT+IEDxX77IH30jnhxhvrn9DWCCLLvNhcTnqWg467fsBjFOyek1YwH6WVzUfuJ08rer781cBT1Fg==
X-Received: by 2002:a05:6808:144c:b0:3d2:2833:73c6 with SMTP id 5614622812f47-3d545a7c3femr9871690b6e.39.1719362398777;
        Tue, 25 Jun 2024 17:39:58 -0700 (PDT)
Received: from [127.0.1.1] (107-197-105-120.lightspeed.sntcca.sbcglobal.net. [107.197.105.120])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d5345a6016sm2124731b6e.37.2024.06.25.17.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 17:39:58 -0700 (PDT)
From: Pei Li <peili.dev@gmail.com>
Date: Tue, 25 Jun 2024 17:39:56 -0700
Subject: [PATCH] bcachefs: Fix kmalloc bug in __snapshot_t_mut
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240625-bug3-v1-1-366d4884ab71@gmail.com>
X-B4-Tracking: v=1; b=H4sIAFtje2YC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDMyNT3aTSdGNdSzMzg2SzJHOzNCMDJaDSgqLUtMwKsDHRsbW1AA/vk2J
 WAAAA
To: Kent Overstreet <kent.overstreet@linux.dev>, 
 Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org, 
 syzkaller-bugs@googlegroups.com, 
 syzbot+770e99b65e26fa023ab1@syzkaller.appspotmail.com, 
 Pei Li <peili.dev@gmail.com>
X-Mailer: b4 0.15-dev-13183
X-Developer-Signature: v=1; a=ed25519-sha256; t=1719362397; l=2675;
 i=peili.dev@gmail.com; s=20240625; h=from:subject:message-id;
 bh=nAAboattMDWw0GSvPKDB9G5XT9DIggzKYBOB4CVd2TU=;
 b=qt+kmpW/VwTQ4Y1GcMuWI72KjMC5aBkQ15pKvsO6jyM9+L1I39sWcxOFaLF7KqF3Ww1vG7hAX
 CIi1MX+P/CgAh6sG8pFf81iNL4z6t3IFbGC2gbHOjiqDGWOvmaHv23H
X-Developer-Key: i=peili.dev@gmail.com; a=ed25519;
 pk=I6GWb2uGzELGH5iqJTSK9VwaErhEZ2z2abryRD6a+4Q=

When allocating too huge a snapshot table, we should fail gracefully
in __snapshot_t_mut() instead of fail in kmalloc().

Reported-by: syzbot+770e99b65e26fa023ab1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=770e99b65e26fa023ab1
Tested-by: syzbot+770e99b65e26fa023ab1@syzkaller.appspotmail.com
Signed-off-by: Pei Li <peili.dev@gmail.com>
---
Syzbot reported the following warning in kmalloc().

bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=crc64,data_checksum=xxhash,compression=gzip,str_hash=crc64,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 7
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read...
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5078 at mm/util.c:649 kvmalloc_node_noprof+0x17a/0x190 mm/util.c:649

We are passing a huge new_bytes (greater than INT_MAX) to kmalloc().

This is likely caused by either we run out of snapshot entries when
calculating the size of snapshot table, or an invalid bkey was read.

Instead of failing at kmalloc(), handle this error when a large size of
memory is going to be requested and return NULL directly.

syzbot has tested the proposed patch and the reproducer did not trigger
any issue.

Tested on:

commit:         55027e68 Merge tag 'input-for-v6.10-rc5' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f3a389980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf5def5af476d39a
dashboard link: https://syzkaller.appspot.com/bug?extid=770e99b65e26fa023ab1
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=170174c1980000

Note: testing is done by a robot and is best-effort only.
---
 fs/bcachefs/snapshot.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 629900a5e641..e3303aea8b29 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -168,6 +168,9 @@ static noinline struct snapshot_t *__snapshot_t_mut(struct bch_fs *c, u32 id)
 	size_t new_bytes = kmalloc_size_roundup(struct_size(new, s, idx + 1));
 	size_t new_size = (new_bytes - sizeof(*new)) / sizeof(new->s[0]);
 
+	if (unlikely(new_bytes > INT_MAX))
+		return NULL;
+
 	new = kvzalloc(new_bytes, GFP_KERNEL);
 	if (!new)
 		return NULL;

---
base-commit: c13320499ba0efd93174ef6462ae8a7a2933f6e7
change-id: 20240625-bug3-9660c6b76f20

Best regards,
-- 
Pei Li <peili.dev@gmail.com>

