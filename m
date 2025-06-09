Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA7A8BFF;
	Mon,  9 Jun 2025 07:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749455823; cv=none; b=W+v9yFH07xz6EI7YEKa+4mQU4Mxwyl+mgQV8Nghl7H829XvXqTrpQocq0e2MG/7Q8r1Aeyy76TPA79Y+lOfMBVn2nX+VUw9yzOoYaXtSd93vGNXjTiOJbOL7uvgRWFOQwK7bL/Oxaj6jzJ3mxxjc7vC0wlOvuQdl9g3VTvOX8Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749455823; c=relaxed/simple;
	bh=p49F4iVDjLolb18i6c/cgcidS0xjY2Cgu6gC5AOYAnI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J4KmFCXhcu4QloqBCGRCaE0NIHRZ6YE68UN3LaqajZkE7rgihlWZfy66eGwQuHKo/ew1jcODEEuFtFonLLxjpUP/oRBOeCfugwJtpP7IbxJ1HpdjxYKcXQEYU56ao15c/V7p5bKElW3PEaz7NS0QGZr1amN11TgHgZb2MrzIVgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=emnHqe1E; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="emnHqe1E"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-742c73f82dfso3115366b3a.2;
        Mon, 09 Jun 2025 00:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749455822; x=1750060622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9xCRdGyFV/qmREjSzVYn1llBGMmzLISDBHN00C5YP4U=;
        b=emnHqe1EQuP98GYQSXl2r6uB8TIDjuh9yqM/fwDm0PTcmVFij201BPzWQFmB/iSJXQ
         v+ccSRDyKUcdeK9zbUlNwKXpnehDGJ7C2cpssV41/G25ILn8HyWRU3DT+/eBJ7otmP3K
         Zzn90rRSI4UFyhXiFtWMyJe1oYd+f2HeBNX38D82iiLwLYZM2cMwyi16iwEnh8Rt8J1m
         V3vCCTZ+X65EtaRKibBOk7t2lqVKliLnGiGWM3CRxoFLeqcMI6K/R3tNJSEHnDVI89Zr
         youHYE1j7OiUfkSlFLej957zXG5JYUzSHcS2Cwk05tyQFBuk3/LRV9tjBPffS4Cps1rr
         sauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749455822; x=1750060622;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9xCRdGyFV/qmREjSzVYn1llBGMmzLISDBHN00C5YP4U=;
        b=WI5sYMyCItVUg+BIP9X9eXHez67ZfE5PjeHsBdxFFDxfw+VkalPlTwuRzTyLTeB7K+
         F5u6iESo3mnCUJ3hheNFfVdDynZmi1vIqOeRGLHWKyVbtdshA02MD4gjNFuDOpmb/KOc
         835HsgPQRJLD0MW/v4lLEl0kgSuFPPMTfKzF1JfZrUbNtiqUrJ0uCiwlaz7HrTNigoEB
         sqqSYcpsCx8iN+ckI7zL6KscmtbQMDY+Blouo4YWUOF/UbXTk3ZmN5uEkL6qMAs8O561
         NnWDoP9e9vqW5qK78S6k2ktmB1iVr7y5JIsXgWl054yW68PFFd6l/xTHkDgr2kY0rtLX
         CLzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXG3rFqXgbJmL8GEaO/PG0wE7eWNar8jXLaO6a8E8X7hen1QVtHgrXkXL1L2v+82nPJ5ktaL2tTCbdfztE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM5XVpyzDI9PnmhmPE0JP00+0lU5MLcklVLUN+4+FHlo/iFrsT
	/9b0fRW9HX4mEit7g+4XBwYy/GLI7nuDO2c1uBFli+BudMgoBpKDyOvn
X-Gm-Gg: ASbGncsZV0cKbRtWtPIqw3ThX6hSpAHz24grw+3LWlzKkBEgHhAMJDSEs1YLaV0k/4V
	5eG7notojwazL5yobaxWN7LeGZHkBA4FYjSr28W0Wqdh1vqMDqAIOfTI8nJgZPu8VTaAUOdSO1u
	ZNB4usp4gz5A+SC5QQLZlCX+4Pv7q/LJOpObCDLjRDPZiMNhOR6HHVzaPl9tIouuql9rKvIyc3S
	qGnF+yMLRYOSzREFWT6i/+H5JrZ9uUpnxuTVYn1cxvDRXRFxSn3rsb7GOKdfeYZnEjvQYQuUDoR
	UjxRanLG2+rCN2Yg/NOozhRW6NlMmny247ABIzYXsh0v/3zPisQZyQ==
X-Google-Smtp-Source: AGHT+IFR+PbBitilbpBp7iEMdJfwlPWMhDklOZRnpHUxMAixPokz0lWagcCbzlcwioBQCxH5sPfs/g==
X-Received: by 2002:a05:6a00:22d1:b0:742:3cc1:9485 with SMTP id d2e1a72fcca58-74827e9c914mr15067788b3a.12.1749455821518;
        Mon, 09 Jun 2025 00:57:01 -0700 (PDT)
Received: from pop-os.. ([2401:4900:1c97:ddea:418d:d481:617b:9b03])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b0c0138sm5146568b3a.110.2025.06.09.00.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 00:57:01 -0700 (PDT)
From: Abhinav Ananthu <abhinav.ogl@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abhinav Ananthu <abhinav.ogl@gmail.com>,
	syzbot+5138f00559ffb3cb3610@syzkaller.appspotmail.com
Subject: [PATCH] fix : slab-out-of-bounds Read in bch2_sb_members_v2_to_text
Date: Mon,  9 Jun 2025 13:26:14 +0530
Message-Id: <20250609075613.27146-1-abhinav.ogl@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BUG: KASAN: slab-out-of-bounds in members_v2_get fs/bcachefs/sb-members.c:68 [inline]
BUG: KASAN: slab-out-of-bounds in bch2_sb_members_v2_to_text+0x1ae/0x310 fs/bcachefs/sb-members.c:347

bcachefs: fix slab-out-of-bounds read in bch2_sb_members_v2_to_text

syzbot reported a slab-out-of-bounds read in bch2_sb_members_v2_to_text().
This function parses superblock member entries from a serialized array,
but did not properly validate the bounds of each entry before accessing it.

When the function iterated over v->entries[], it assumed each
bch_sb_field_members_v2_entry was fully contained within the buffer.
However, if the structure was truncated or malformed, this could lead to
reads beyond the end of the allocated slab, triggering memory safety bugs
under KASAN and potentially leading to undefined behavior.

This patch adds a bounds check to ensure the offset does not exceed the
total size of the entries buffer before accessing each entry. This
prevents out-of-bounds access and resolves the bug.

Reported-by: syzbot+5138f00559ffb3cb3610@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=<5138f00559ffb3cb3610>
Fixes: 1c8dfd7ba50dbbb72113caf4fa7868512cdad2f4("KASAN: slab-out-of-bounds Read in bch2_sb_members_v2_to_text")
Signed-off-by: Abhinav Ananthu <abhinav.ogl@gmail.com>
---
 fs/bcachefs/sb-members.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 77809ee23c45..9f137cf7d33e 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -64,6 +64,12 @@ struct bch_member *bch2_members_v2_get_mut(struct bch_sb *sb, int i)
 static struct bch_member members_v2_get(struct bch_sb_field_members_v2 *mi, int i)
 {
 	struct bch_member ret, *p = __bch2_members_v2_get_mut(mi, i);
+	size_t array_size = le32_to_cpu(mi->field.u64s)*8-16;
+	size_t member_bytes = le16_to_cpu(mi->member_bytes);
+	if (i < 0 || (member_bytes && i >= array_size / member_bytes)) {
+		memset(&ret, 0, sizeof(ret));
+		return ret;
+	}
 	memset(&ret, 0, sizeof(ret));
 	memcpy(&ret, p, min_t(size_t, le16_to_cpu(mi->member_bytes), sizeof(ret)));
 	return ret;
-- 
2.34.1

