Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114BF1A3A8A
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 17:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742234071; cv=none; b=meGTRHzWdGmdqN2R2ly07vdV8+Kgpyh1fbtf79Jp/B2U26CCwBKilnOkMcgeEKtN1NlRqJMms/kcbeOI2RexFkdOWnFeLAWH2TnR9L+KcdgcbpP9cRw9shvbfR+oohj3+43PGqeqiuhPb5zwyCAMnr7DcvpjNYq6IuJ5UxDNBe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742234071; c=relaxed/simple;
	bh=hXODONr/ReJDbt3MbrcjWlDfRCBNB5anDAj5nTNc0T4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S2cRb+o2Xv9aqCEIGHb2aOgkfCqeQjOUJES5vM9rjGxMoWxKuGTksRMeaFLllQ4K6jph1du5fEz6mNRYzz7R9i5g6JANS7QRx3ve3tSSGcCxhBDAHYf7sFSFFG4U6izcGMPj6AN4EFRDzclGQTH26yLoU/b6le1xs37Jp6wYex4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EWECOoKv; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EWECOoKv"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2235189adaeso80883185ad.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 10:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742234069; x=1742838869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zXklguD7l1x8O0C4NCuR6DfrC1zPTOZ4a1TDh/OAmAM=;
        b=EWECOoKvkasWCd8dODv6jkD7oSkUPJObd5fC28I3FpM8Ba4UFx6jg4VYEtvosJKz9W
         RUxmQ0cZaEs81w2GqwONz/lZBo87whK0FMvSXkhjNT3jswFR74oxX8qFR51Er+mR5UjI
         9vP66MWkf0XNaqxaT5d8VEjcS0W0HzTFFpEtcC4UGoeZ6I+fpSch59cm2CUX7pZ9Ryu0
         PHGucEhuuScIeo3ckL3j+uu3cSk/YyRn6HGn95ETYYJckgADuwTIqujtxuoYQggMXHhn
         +35LquNCewB/pyeaCGj3ExSs384RkcfhwN8Cd/njXgHLN6RwzLZA97SRWraBNFfTtzYl
         Qo0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742234069; x=1742838869;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zXklguD7l1x8O0C4NCuR6DfrC1zPTOZ4a1TDh/OAmAM=;
        b=I35u3SqsLngoH1iylBB76SJu+noOfYrvxy0OW5E+e2HrwJQ/cMtbFswWWjJFjf/MXX
         Jy2j+NdcmzOxyp95vFak7eGyzerMQ2T7R+sX8jX4WIRRg3uT46qwlULZFWQwKw3eQgWz
         8JPussfMtWjlXb+DJr5HcpxzK/akPTIn2R5DjQsjM04UH3oPeNf8Bj8WvmN6Rl/0lzzW
         qgLdTouQePcj8RqVxqejzf3SDSi1NQ8EIs/2sTgtz4ongGxk0x209x6VVDcksnHBsBDy
         e/ezhZ+pVY/LV6sL4h8Vsoe3jm8brARe8r/Q7NEv+XOWCD3Sor8RyAls/y52bVHcyc1z
         VjTw==
X-Gm-Message-State: AOJu0Yx1Mbj5coD+owO+OPMgm0UQ70wtFjDbB2dKnAoi+vUTivR0RSjP
	74qUkMV5Oy7cayjtDMtc8Qk/+Y3xqopDlDUWd28re3GHyNljeyRw
X-Gm-Gg: ASbGncv42L/J0fKc+d1ezlU7D91AtoCOUkWt1+7S1nVer80Vd+0Nyk5Y+BjgOy0hel7
	fA679kTBsvE8043RrGwrPbTQCodoYbuIYW7ooNePYkN7XOsoOwWycNN1H8faNqapazbQG4cSjRb
	hws6+VjhxEc3DFDnPFu3Gaq/5fm2iGgnBI3rHNfh9RvRC1HAe2QmZZPmKrW5H1vxcGPb8FxbbWw
	Omcs2XNBvw56epA1U0MAQ4k2P8B5rXhKgvaFs6LzPPKqezaC0WHARWMNO8RDAlbzjDhfM6k3WOU
	E14LPGwIXKCIxrgt81w=
X-Google-Smtp-Source: AGHT+IF4v+4MrNS24s0a99vFDxPyWmkX5CSOB1jkaENeU+mC8lR5QjPTCCCn8/kTlyrhg35zoq6z0w==
X-Received: by 2002:a17:902:d2cc:b0:220:cfb7:56eb with SMTP id d9443c01a7336-2262cc394d9mr3908715ad.26.1742234069319;
        Mon, 17 Mar 2025 10:54:29 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c68ab4c6sm78553335ad.77.2025.03.17.10.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:54:28 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Fix incorrect state count
Date: Tue, 18 Mar 2025 01:54:24 +0800
Message-ID: <20250317175424.1928597-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

atomic64_read(&j->seq) - j->seq_write_started == JOURNAL_STATE_BUF_NR is
the condition in journal_entry_open where we return JOURNAL_ERR_max_open,
so journal_cur_seq(j) - seq == JOURNAL_STATE_BUF_NR means that the buf
corresponding to seq has started to write.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/journal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 1c460ded2a11..ab68c5c4d8d8 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -161,7 +161,7 @@ static inline int journal_state_count(union journal_res_state s, int idx)
 static inline int journal_state_seq_count(struct journal *j,
 					  union journal_res_state s, u64 seq)
 {
-	if (journal_cur_seq(j) - seq <= JOURNAL_STATE_BUF_NR)
+	if (journal_cur_seq(j) - seq < JOURNAL_STATE_BUF_NR)
 		return journal_state_count(s, seq & JOURNAL_STATE_BUF_MASK);
 	else
 		return 0;
-- 
2.48.1

