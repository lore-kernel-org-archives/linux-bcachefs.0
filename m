Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC32D17753;
	Mon, 16 Sep 2024 21:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726520602; cv=none; b=QGRLMaPFs8+gTAI6nfwzd9vO9bSnM2+ilW8VxetOAKXZGwGnd0Nxl4HRhLr6xoqFN0jAEqQH2Tl+wn6p2SaTVZxD5VXdx2j6Urxkkl4ttGpKu6korGWb//f2Er0aueSy8hvPoWpXZHEF9GdcSTcvnrIbIwDc7OKpvKQjyS/GHes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726520602; c=relaxed/simple;
	bh=xXvGc7TlbIrsNfI9wtngnwCkq63fV6O4XsFYYzheTKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oe3t8zjCIIN4qxtY3M0lOycc2kENwix+zfbZBndzG7PRvOnOIGLQwS2gQsf5InGlyLgpTKnghadxtnllSuMHGtB5cRHQ+F7/SSlA4bkKqYqnViXyagkWgapzEKH7Aq8B6by13Woume4lh2CIqMtnDjGRUsHQ4RGRJmB24CmcueI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ShGRqXlI; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ShGRqXlI"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2da4ea59658so3055860a91.0;
        Mon, 16 Sep 2024 14:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726520600; x=1727125400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9TygCsZMnwycEX/cXMuPAbTSZcME/UdD7hse1wGH+aU=;
        b=ShGRqXlIg4kcT6di4i98z9dRKK3hghQKx5pzRXPfTD/Xqgu40FEVjqktUdmnLDmrAC
         GDZQR9rZMoFTK5YcJxr9nkO1fqFzMVtuZVMTJ3kOtpzNXdINZYlqwc9hEAzY/rdnE+WT
         bzqKuJ1BmdQhjLNfYHMskVpCq9DYWFyrdRKqCUztNk3TXtMeKWAiTNT4okZNIIYPcjBu
         fQ9hcq35LTBIIctj+6zPsgB7xNgffnumQ7/TTPY6nxru0NYeUYGoqPunzm1kZi9w83/k
         f1nC+oF/4EtMW5mThCKzdU+grbRz7uzYoOIT7Ss55yJ2DDVeWjuPCOLK8fN2zr9947ur
         AOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726520600; x=1727125400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9TygCsZMnwycEX/cXMuPAbTSZcME/UdD7hse1wGH+aU=;
        b=e5opoIDQ/s4Ja3Yc75ylgZBbuP0JG3IbcLMbe1Z5ybmn/JTCZnwgSPAdkTRpmVcPGZ
         Hsj71mmeqlRqubP/lYLvJns8TkpOD2qCP9NfIhbNMmRtQs5TkaqX7sX+XjHxlszvw4B9
         tYbMOF+GIE5wo6x5kl+P/cMzXxAkl8HNLd/1iTitmy9HoUIxlUPRmJaLmEMvB6kcWyLX
         AGGoM6iH473EVXWDcpG7UdsfnD0Hj0vGK4WyVE6SDyHKqxhZfkzQ1vBeey+CQtGxHKjy
         rchFtY2I2G3J+9C3UvIvzbCoZNNBlhnnXDAFU++EQr14yTsZKn3pUSx21mmIHorpV0Wt
         Yd7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUHVcajjPjsiqRsN9Cc1zTViQif0Vp3U4vof/Qq8yi2h21ZbSltArAqdLV/DfCo58q8HWk4oiyHKPMqNeA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvWz65GM2qWSJOmvl/i8FO44He//uIw6su9yLMhTk9VUdLfKdh
	YhMp2rkKga6UhLEdMwehiRseIfa1GPUGDsOJNEWNX/WeEOlv9y2p
X-Google-Smtp-Source: AGHT+IG1eUzT3ZyNxdrALl+XF+UaIGfTNpqYsN53JYYwgjOXOYYhKwV9PSYycLbDQtzOpz4fOYCJ0g==
X-Received: by 2002:a17:90a:f492:b0:2d3:d7f4:8ace with SMTP id 98e67ed59e1d1-2dbb9dc9488mr17563329a91.8.1726520599457;
        Mon, 16 Sep 2024 14:03:19 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2dbcfcf82ecsm5812302a91.16.2024.09.16.14.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 14:03:18 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix NULL pointer dereference in bch2_opt_to_text
Date: Mon, 16 Sep 2024 21:03:10 +0000
Message-ID: <20240916210310.14014-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot has found an general protection fault in prt_str [1].

In the prt_str function, a NULL pointer dereference occurs when the
parameter str is NULL, which is called in bch2_opt_to_text when
opt->type is BCH_OPT_STR. If an invalid index v or incorrect
flag is passed to ptr_str, then this could lead to this issue.

[1] https://syzkaller.appspot.com/bug?extid=37186860aa7812b331d5

Reported-and-tested-by: syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=37186860aa7812b331d5
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
---
 fs/bcachefs/opts.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index e10fc1da7..72b87251c 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -420,8 +420,12 @@ void bch2_opt_to_text(struct printbuf *out,
 	case BCH_OPT_STR:
 		if (flags & OPT_SHOW_FULL_LIST)
 			prt_string_option(out, opt->choices, v);
-		else
-			prt_str(out, opt->choices[v]);
+		else {
+			if (opt->choices[v] == NULL)
+				pr_err("Invalid flags or index v passed to the function\n");
+			else
+				prt_str(out, opt->choices[v]);
+		}
 		break;
 	case BCH_OPT_FN:
 		opt->fn.to_text(out, c, sb, v);
-- 
2.46.0

