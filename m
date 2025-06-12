Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C9F21D3F4;
	Thu, 12 Jun 2025 08:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716432; cv=none; b=dYUG5CJNVp693ewlXLmm59YXK+LScYr0ZDt91+OzZqyWN4ApvMtC3CLsUDR9ji2nBSn71bMyfq0bHf7AaNQR6OWlA7wOPhdlzdVJYF5eqEz4DKH+XSuEz8VBTrRW6OeuwVSCrg5pXmY+DFBgB5eVaphs4W/gm7sDZScgc5UwhOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716432; c=relaxed/simple;
	bh=WVgG2tnnkYpGMxVKQjyY3rF80ora3aJX6lpro4BS+uo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O4bkmgZDmH1aoayv++j/7xEIZQljpadpI3fiMne13W4eRTS+LRYbsL9r97FBEr+7bIHWlB966+TiYSqsq/w2HPSCrlPXwpBoQjFF9GeFtQSJLmElPzk6sBE5rfbCvmJLd1rSyDEQkgkolswluuyx69/WVAaTKmqCY0Tqa//FGxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDRAKLMm; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDRAKLMm"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-404e580bf09so172075b6e.1;
        Thu, 12 Jun 2025 01:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749716430; x=1750321230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iHaOjqwhY79rHl7CZbeFzNKnbLFycykRZVNCnsxTjBw=;
        b=iDRAKLMmIfcWwJ8mhVQ3C35Ysd2kEYiNlM7t4MrGl0OzVjR5eGYxO3ELWdJEzc6czU
         lSyIv5pUi1TGhaCACEv9a+un5PMx53mF2oTViitxJruWe4tsrbWX+LGeSx0zsQiHhiEL
         XBuALKGj4xAL/ST6c9wRL6K48Qofe9eYve7V+8/FxSwIYZnPczywZ+Re4vFtxYjNjVV1
         2ChOHuu7C3In6OZC2C+WMNLRAmJK59ENO1HxHIvnGGg7MFU+p1thi5UQN2chzSKvq9uO
         L6M4DSyS5kAQoN5jwYSRVpTeR1jpWDS7ZV9rZePz9BbYfywSBw1RXPgqGNiB/hA3sTWx
         IZKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749716430; x=1750321230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iHaOjqwhY79rHl7CZbeFzNKnbLFycykRZVNCnsxTjBw=;
        b=pUzdv1mEQx9PMMpBG6BD9kBtSAYpbGYE8TVxywe0viH7PVSR0rFJCaHRC/ReibYfKz
         4KfRijE+1hoQtlWySzjzDzHa5yNVxLekD+5UyqfIPfFziJBY+0PCs/X6DbSZWodbWtPj
         YcwKQzeD+tFT+e1AHKtNz9a4ANqY7qPAAF5B1ezAOf4cfXIyQt67Uk+xKM5FKSGpuGQa
         Ly1Ke1Er88S0jzZgujoMm1KdCui4B1vFBjDbi+gODHinbiECcR7EmJXgpMXXn1ophOmY
         vZfkqUqZp0bidA1/46CVr2SQscWzJm7/PaKo3dJLABaKAcMErs9p2GIkcFYSWE1OHq4u
         Odww==
X-Forwarded-Encrypted: i=1; AJvYcCWcds0Kx8+RiE5HgsUgBuQ/vaKTpKk+i5F07t5W6HXS1wg0uLtbyrLw/sEvs06VSXNElK5mjWy+Mic0sO0Xsw==@vger.kernel.org, AJvYcCWkAmuoPxdWeQ9FDGnIMY2+hS/JxjGYuWv4iwXPshlbFw8V7waxQvZfL/46Omw/+uGiOCc3+ljqmGtZJfH4@vger.kernel.org
X-Gm-Message-State: AOJu0YxgBDkmAtFdzUN4X90VkebeF8eRFLwspzL07OuJFw4/VpNOhpYM
	yLvInIC2WYtW2m1NTesr4rkSSzHrOaUKEU/80C/K/rk/gApQl4dzlg7P5DU2s40Z
X-Gm-Gg: ASbGnctqR6hXVpuRmx2rRXIi4JshofZ65eVMCCoUqnaC49GcMtfYAlqV58gXOKB+EVI
	oNh1OwoRna1sbJInkrNqffQtwQCKEC8iDHj3uu6RlydywA9J0KVctdnCOFitBX2tpIU5xqHXbvI
	TUxh1142ekCLqxtA/w2tDTrOA3naWr+z7+1u0oovbCltEinVaEFAe/qSc9GSv3a8rx3KUkBVjj9
	Sr/oq1MqcOWGoYhpxXwKcBt4hxcrpDGIcr+Ero4/OtOnJDPDJMgePIH4sk31pv6BzybBKERHTrC
	zNMUvicPC4qm3+E1u1k9rYB70UWwEag0ImuHQTzBU8iUUHExX0ckdHE33PhOnm4=
X-Google-Smtp-Source: AGHT+IHgoouR9wdzwq9AQYrVJwXB6hntvSFWGTLZ5QK5PWgpDBD8wu5ti9LLCSM1L4N6sdRNdH53Ag==
X-Received: by 2002:a05:6808:690c:b0:406:7186:5114 with SMTP id 5614622812f47-40a660ce8d6mr1224140b6e.36.1749716430280;
        Thu, 12 Jun 2025 01:20:30 -0700 (PDT)
Received: from s-machine2.. ([2806:2f0:5501:d07c:2c0e:c0ab:c58f:2cd])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-40a6830b980sm211965b6e.33.2025.06.12.01.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 01:20:29 -0700 (PDT)
From: Sergio Perez Gonzalez <sperezglz@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Sergio Perez Gonzalez <sperezglz@gmail.com>,
	linux-kernel@vger.kernel.org,
	shuah@kernel.org,
	syzbot+e577022d4fba380653be@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: fix size used to calculate `nr` of devices in member_to_text()
Date: Thu, 12 Jun 2025 02:19:26 -0600
Message-ID: <20250612081935.161598-1-sperezglz@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In bch2_sb_members_v1_to_text() there is an incorrect size used to
calculate the number of devices.

The correct size should be `BCH_MEMBER_V1_BYTES` as implied by:

static struct bch_member *members_v1_get_mut(struct bch_sb_field_members_v1 *mi, int i)
{
	return (void *) mi->_members + (i * BCH_MEMBER_V1_BYTES);
}

Also invert the pointers used in the calculation, given that they yield a
negative number.

Reported-by: syzbot+e577022d4fba380653be@syzkaller.appspotmail.com
Signed-off-by: Sergio Perez Gonzalez <sperezglz@gmail.com>
---
 fs/bcachefs/sb-members.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index c673e76ca27f..cc51313ebcf6 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -325,10 +325,10 @@ static void bch2_sb_members_v1_to_text(struct printbuf *out, struct bch_sb *sb,
 {
 	struct bch_sb_field_members_v1 *mi = field_to_type(f, members_v1);
 	struct bch_sb_field_disk_groups *gi = bch2_sb_field_get(sb, disk_groups);
-	int nr = (vstruct_end(&mi->field) - (void *) &gi->entries[0]) / sizeof(gi->entries[0]);
+	int nr = ((void *) &gi->entries[0] - vstruct_end(&mi->field)) / BCH_MEMBER_V1_BYTES;
 
 	if (nr != sb->nr_devices)
-		prt_printf(out, "nr_devices mismatch: have %i entries, should be %u", nr, sb->nr_devices);
+		prt_printf(out, "nr_devices mismatch: have %i entries, should be %u\n", nr, sb->nr_devices);
 
 	for (int i = 0; i < nr; i++)
 		member_to_text(out, members_v1_get(mi, i), gi, sb, i);
@@ -344,10 +344,10 @@ static void bch2_sb_members_v2_to_text(struct printbuf *out, struct bch_sb *sb,
 {
 	struct bch_sb_field_members_v2 *mi = field_to_type(f, members_v2);
 	struct bch_sb_field_disk_groups *gi = bch2_sb_field_get(sb, disk_groups);
-	int nr = (vstruct_end(&mi->field) - (void *) &gi->entries[0]) / le16_to_cpu(mi->member_bytes);
+	int nr = ((void *) &gi->entries[0] - vstruct_end(&mi->field)) / le16_to_cpu(mi->member_bytes);
 
 	if (nr != sb->nr_devices)
-		prt_printf(out, "nr_devices mismatch: have %i entries, should be %u", nr, sb->nr_devices);
+		prt_printf(out, "nr_devices mismatch: have %i entries, should be %u\n", nr, sb->nr_devices);
 
 	/*
 	 * We call to_text() on superblock sections that haven't passed
-- 
2.43.0

