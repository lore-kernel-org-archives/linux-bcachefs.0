Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073F710A09;
	Wed, 10 Jul 2024 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720625609; cv=none; b=HhV/GamXgQk+kHbk+JFn+XqYKeyZzP9WqNDbL2fHADu6NUzuJEdY7tlkYPxPAR3M2a2YRnDlft+8vXOA+q+HAZnIS08tDeUw43WyKKQhhN7CBnuYkU/eeZSd0OnNBUbIuIfm/9V4jx1L9hXrB94x9MaNI35OhoZPjXlrE75eYzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720625609; c=relaxed/simple;
	bh=aTVeWmvuai/R1U1FoOT+kwJPiR7ddJ+S95lzMnEtAgA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=I6FPIWxYWFwwgiOkV4cTuqgUECCLw90JNBM4svE7lfZuAMbUxMP5aWb+1BXER91XET42W/REEVwAKIXwnD8mtywix+CY8FHEYF7sMdY9mCDfGxMaPn8QAA71bXsXJSGVqfC7B9cdKkjmVhG21TsqlZyAl6mU0erJGV+OpZG+hPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ctviIJLc; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctviIJLc"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-651da7c1531so60341447b3.0;
        Wed, 10 Jul 2024 08:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720625606; x=1721230406; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4gr5uYzcvQrUbhANpY2co45rv/Wb7vmR13XKq1IXwwI=;
        b=ctviIJLcW8TfVmF2mam5Csa8hfitv/XbCO+72WQF3cRNSC0mUOF56kYJdmHMObxqGZ
         fDHqHZwxLxsXFj4bf+a1jsiarHV88JSHbVnhHCbkaTUg/LL3n2sOEcnazMeoSClk4rjc
         ZLUZQ5uJ2TxAN2AShN4zbi/e5EfljN4rgJ/9efyxL3LYqHVr/tVr8KaVKk26aUX4zYlo
         X16sNH/erc0PtMFJqhcrygOyiakqn05n953R1ufhYy+7Zfn/rT+htRvRemas+HSDfQ3S
         myWV/Ny6ZV/XSDR0VxPZ114v3NAZTFpt7nAyMbIGyzcd2zFnRnn+rxNSvJ4Oa1GF5kLA
         1CyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720625606; x=1721230406;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4gr5uYzcvQrUbhANpY2co45rv/Wb7vmR13XKq1IXwwI=;
        b=v5qlaTPZ/Ui70E5BI1uwbxk88rfI31VXhiNvYi39SGaQ4MoWxJe/SxrMoG+1yyqC5J
         DObMRl8XhOVy7dJv3qs4QWNMSCvVNgtjwjQUP0M2BPZdlotBcXiopOH5opv5auBa5Kio
         4Jlwhhi0UIFPPW1yrKNkTR+h+oNBhkjb875T0BlhEoCTI1ZMP3xB1NAEo0gN3BvIrZDy
         Ey7Jy3ngV8IywhOyXBdhSbItGBjGQvnHHkdsr8Ei+8gsSj7Dd+emP+66iPA18X+BZOTO
         z2tMLOXZxkswk1eLSxOSULPnVO8+/8EE0OlG9T/VmHJHrIyOE0/pcGbSUzGN0O/INP8w
         ML8g==
X-Forwarded-Encrypted: i=1; AJvYcCW09ufB7eKmNlBAo8EW/HJriQRGmx7YXNBmlK0oIif02OBXVTDXricSnoG5CxSvcFVGy9Gw72cfH4G0WyX0HKUjKyWtLtOUedscpcX2
X-Gm-Message-State: AOJu0Yzh19vI8nNBGWwdkVhYAtMkcv8/dIJVeRN864LeiKH4Q5B2wZLT
	eEektkc+AicP50sIQEnfG67IcoyTtFvnKwDhoGHs8y4pWTtnXi+uFoivWA==
X-Google-Smtp-Source: AGHT+IEu3Ni5t8+SMTgaHEnlIoC/Vuf6JBd1nltHcz3U4Kd98F2p5GBHknD+xkNMn1UIAlk8SSKFfQ==
X-Received: by 2002:a05:690c:6612:b0:64a:69c2:b6e4 with SMTP id 00721157ae682-658ef34145cmr79626997b3.28.1720625606006;
        Wed, 10 Jul 2024 08:33:26 -0700 (PDT)
Received: from [127.0.1.1] (107-197-105-120.lightspeed.sntcca.sbcglobal.net. [107.197.105.120])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-658e4d2a7d1sm7620967b3.31.2024.07.10.08.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 08:33:25 -0700 (PDT)
From: Pei Li <peili.dev@gmail.com>
Date: Wed, 10 Jul 2024 08:33:24 -0700
Subject: [PATCH] Fix WARNING: suspicious RCU usage in
 bch2_bucket_ref_update
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240710-bug10-v1-1-f1f8cf98f7c0@gmail.com>
X-B4-Tracking: v=1; b=H4sIAMOpjmYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDcwNL3aTSdEMDXbMkY1OTFENL4zQjAyWg2oKi1LTMCrA50bG1tQD9yXo
 mVwAAAA==
To: Kent Overstreet <kent.overstreet@linux.dev>, 
 Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 skhan@linuxfoundation.org, syzkaller-bugs@googlegroups.com, 
 linux-kernel-mentees@lists.linuxfoundation.org, 
 syzbot+e74fea078710bbca6f4b@syzkaller.appspotmail.com, 
 Pei Li <peili.dev@gmail.com>
X-Mailer: b4 0.15-dev-13183
X-Developer-Signature: v=1; a=ed25519-sha256; t=1720625604; l=2446;
 i=peili.dev@gmail.com; s=20240625; h=from:subject:message-id;
 bh=aTVeWmvuai/R1U1FoOT+kwJPiR7ddJ+S95lzMnEtAgA=;
 b=lNEuCBby2LIHOBFQJWiBICH9AZBveXtH9UVkQmYRmAgWXhsoMvc+l6pVvk2oNBW8QcqFuPWJ0
 C6IMhyvlU+bCVZj0CNaulb1njfIn2W+HQzDS5UqsiFh1sRrCnbZesYL
X-Developer-Key: i=peili.dev@gmail.com; a=ed25519;
 pk=I6GWb2uGzELGH5iqJTSK9VwaErhEZ2z2abryRD6a+4Q=

When dereference ca->bucket_gens, we are expecting one of the three
locks to be hold if ca->fs is not NULL.

This patch acquires mark_lock before entering __mark_pointer()

Note: testing is done by a robot and is best-effort only.

To: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: skhan@linuxfoundation.org
Cc: syzkaller-bugs@googlegroups.com
Cc: linux-kernel-mentees@lists.linuxfoundation.org
Reported-by: syzbot+e74fea078710bbca6f4b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e74fea078710bbca6f4b
Tested-by: syzbot+e74fea078710bbca6f4b@syzkaller.appspotmail.com
Signed-off-by: Pei Li <peili.dev@gmail.com>
---
Syzbot reported the following warning:

fs/bcachefs/buckets.h:107 suspicious rcu_dereference_check() usage!

When dereference ca->bucket_gens, we are expecting one of the three
locks to be hold if ca->fs is not NULL.

This patch acquires mark_lock before entering __mark_pointer()

Tested on:

commit:         34afb82a Merge tag '6.10-rc6-smb3-server-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1492e87e980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42a432cfd0e579e0
dashboard link: https://syzkaller.appspot.com/bug?extid=e74fea078710bbca6f4b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15e2e87e980000

Note: testing is done by a robot and is best-effort only.
---
 fs/bcachefs/buckets.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 743d57eba760..03147e46dc47 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -1033,8 +1033,14 @@ static int bch2_trigger_pointer(struct btree_trans *trans,
 
 	if (flags & BTREE_TRIGGER_transactional) {
 		struct bkey_i_alloc_v4 *a = bch2_trans_start_alloc_update(trans, bucket);
+
+		percpu_down_read(&c->mark_lock);
+
 		ret = PTR_ERR_OR_ZERO(a) ?:
 			__mark_pointer(trans, ca, k, &p.ptr, *sectors, bp.data_type, &a->v);
+
+		percpu_up_read(&c->mark_lock);
+
 		if (ret)
 			goto err;
 

---
base-commit: 256abd8e550ce977b728be79a74e1729438b4948
change-id: 20240709-bug10-6b354d193f20

Best regards,
-- 
Pei Li <peili.dev@gmail.com>

