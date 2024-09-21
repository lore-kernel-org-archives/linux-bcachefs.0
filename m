Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329DD23D7;
	Sat, 21 Sep 2024 23:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726961117; cv=none; b=rodYYgeIQc+aV2TuofFy7f2YH/Exw2rxGseYsEJ+nzr+Nhor0vTkMKy092NmP+TZahZBPTOkbgsPtS7CYen/SrNdijWWsARpA3OEZGtdnAumYj/8OcPxk+XoMDDDrDSl1+ycEcT8AbXJtsLjjCSk4Ozqo8Qndd0FILFdFuSbRYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726961117; c=relaxed/simple;
	bh=Kw0B5QzOzJBQ0IF/o9VwkaYv0et0rFziqzDm6dE0Qg4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fyUiY8reOas2a3QoS8MifRpuVJIQNf/RfJxzLgc3A8jSqhuKBOVvReKHKSHnV1MeI6BStUpxCDQac8qWuD2GmRFGgVNYYg3rc612oHhT8WMp+HmF6fu2Gr+HBxAoRZyNMk+Gk1tW1tXQXoLpzrS+jdISHQLJRFCB5P4xJKPMEQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nAn7uOTw; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nAn7uOTw"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-206b9455460so24356445ad.0;
        Sat, 21 Sep 2024 16:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726961114; x=1727565914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dbCLsnFHMaE8G7zUK6m1hWys4//SsxdDZWAMbhtl+yk=;
        b=nAn7uOTwYVQwOlvMPcMTKbt22AZOozW8ZCsW4uij0cfufEkU89CDGzKXFTkVTMj+LG
         kqTrQE03EHPlb6RlwjCwII1AIuNa4g9lWAdqssUszoetI6JPqXuv19z8Taf/Y/IdD035
         pzKP4A/9sKlAe90rnqo8E7rXcNNEPK7I4Q4YPMUX/HuYBTw4uAR1lGRE2W8XIqeOOlpT
         Mr/jfWDPI/E1GTnZUf2vLNwYOPrsrfd7cIK7ZU7VWygILsNJ+1hvPmeEIRMX3OnChC9N
         /Y2WepE0991zPhLZpF31SZ1AGpd7aLlAsYrRy3COHvm072BmFN+6CpH58WmMufQRuarN
         we4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726961114; x=1727565914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dbCLsnFHMaE8G7zUK6m1hWys4//SsxdDZWAMbhtl+yk=;
        b=RkuHPeDs4cHSFoq5RbU4Y6VxrvItW0WB+lSXUoPZMOS/cx1k0qkbU4ORi+znsdbU9z
         aJ0oPlL5TU/rbAy5sag116ksEk8JDaeZDA5Y9/GIauBHDgNNYVENG9TG5N2/JhMKu3FL
         rPsMkXHdeFaRYFoi9O+d449v2e4HYbXwp4CJV3SWFjdeMrf8A0otFlySMAlxjCRU8E8b
         ANJp/6D7cGcDUPnOngts+UGMjM5MSCKsQGyMIHVvQhxN5MIqplwaRmnaA6XLAo66nR4T
         jSlLtaL0nfozCsmrcEHjrrZG28WVwyLpqnVQpITFUHX/zTHt648qUAUlk9C1nATl7DTK
         PTmg==
X-Forwarded-Encrypted: i=1; AJvYcCUpXqx1fn9tgD6+qzm7ogJrsD3msWt0tGVdCs8ckH/zsqHTUsQlQ2ebaXQeA72M9bFD7lPdXX0V3k1ZyTw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVYVGsobq8hFwosUDPJhMssBTxdbMM9FgOeJdRAs0tMl3JKPGb
	fjNKmlgissH1/qniIWKnyhUpLsduIRKMqP5HmodvdLOfP/LO9ni0G8zHipYY
X-Google-Smtp-Source: AGHT+IHSRso88Ntdk4YnuyWKPUqfMRA4w018Y3mjoscqPFLyow11wnofxOzlOQmMOQiu1G6mkGTD2A==
X-Received: by 2002:a17:903:1211:b0:1fd:6ca4:f987 with SMTP id d9443c01a7336-208d77adc10mr117180135ad.15.1726961114380;
        Sat, 21 Sep 2024 16:25:14 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2079473c85fsm112480055ad.285.2024.09.21.16.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 16:25:13 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Subject: [PATCH v2] bcachefs: Fix NULL pointer dereference in bch2_opt_to_text
Date: Sat, 21 Sep 2024 23:24:54 +0000
Message-ID: <20240921232454.42975-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In this patch, I added a proper bounds check to avoid a potential NULL
pointer dereference when opt->choices[v] is accessed in the
bch2_opt_to_text function. This ensures that v is within the valid
range of choices.

Reported-and-tested-by: syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=37186860aa7812b331d5
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
---

v2:
- Replaced pr_err with prt_printf as suggested.
- Added the bounds check on opt->choices before accessing it.

 fs/bcachefs/opts.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index e10fc1da7..9bb15694d 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -420,8 +420,12 @@ void bch2_opt_to_text(struct printbuf *out,
 	case BCH_OPT_STR:
 		if (flags & OPT_SHOW_FULL_LIST)
 			prt_string_option(out, opt->choices, v);
-		else
-			prt_str(out, opt->choices[v]);
+		else {
+			if (v < opt->min || v >= opt->max - 1)
+				prt_printf(out, "(invalid option %lli)", v);
+			else
+				prt_str(out, opt->choices[v]);
+		}
 		break;
 	case BCH_OPT_FN:
 		opt->fn.to_text(out, c, sb, v);
-- 
2.46.0

