Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77569C001E0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 21:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjHLV0w (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 17:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjHLV0u (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 17:26:50 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A6610DB
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:26:52 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3159d5e409dso2471621f8f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691875611; x=1692480411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybkh9TrV+riZkRNUNtVNAufdm+piKYwaUYLhfdITp7A=;
        b=VLzJ6jq5kC5BefhPrK3jJtgenTcgs6wWrkGAVTSKubwiIbKM0C0Qd+ujF25R6KBqV2
         SU99orKpZcJD255K5pnutW5w9UWR7CpDHbqMmIC383ln0MjxjTB2w4+Uw8K6Y0GH0atA
         vNMtXgQNunok53Yy2fwsEOtS5E15lC35CLyrZ6HBWPpoYHI3ZHslsLrlG59/JqytMoXv
         b4xzST3tSLA41EvajkEugmtCqY06HfVOqypKVCAqkBxSj2Mh1pYuerk5U4Pu50Is6i8R
         7VLarcygRU/L9AV+6FD76gyOx/J831aVV1wf913Qc5WHWo4jDMhLYbBx2sGPkvROtFse
         ytkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691875611; x=1692480411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ybkh9TrV+riZkRNUNtVNAufdm+piKYwaUYLhfdITp7A=;
        b=De+YZCH1CjucXZUJd+AKxc15qhupeRKu6Ar2QlYXu7J0RnQrt4BsL4chzleDPSWFJL
         tKZbNnoNMz0Nw/Wb/pV8biH6XEVdYE4dBNBGcG+2xiDw7IesPsrhl+rDMPqaCGzNvlxO
         2vlptTo5cPVSc0fc4I4PJfCP4LdY4V57+PSCCZYA6UaOITyRLe6nwdpIJ7AhbRMWXy+r
         xMI4izAcRe/6i1g3USpsdS0FSS5n7HKW1Fl5blJdgMSEKr6Mr/vZ1lzOe+Ij/qlXW8lk
         +/f+hx6DBIy3tsFm/1k00L5wB1o2ai38Dku+Itq1E8h5kmuNyOPLo23QUKpix6G69Eh8
         ++oQ==
X-Gm-Message-State: AOJu0Yx0R6s9N6f74O2fEeEB8T/JyHuNvzdadMK/GxS4bDVsezosrfiN
        sXZGKAcuGShA4/AUMt3TOkYN9xB8RIRcn+wCZ8I=
X-Google-Smtp-Source: AGHT+IEvB0wgDmpeNhX4z80UjUlOFDAalEzOXwo6cLY16MlWkPX6i4UFhfD1ifRk5DhXB3+GeACPfQ==
X-Received: by 2002:adf:f691:0:b0:317:5d76:1d1a with SMTP id v17-20020adff691000000b003175d761d1amr4553362wrp.8.1691875610971;
        Sat, 12 Aug 2023 14:26:50 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id p1-20020adfcc81000000b003179b3fd837sm9536481wrj.33.2023.08.12.14.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Aug 2023 14:26:50 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v2 2/3] bcachefs: Optimize bch2_dirent_name_bytes
Date:   Sat, 12 Aug 2023 22:26:30 +0100
Message-ID: <20230812212647.490829-3-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230812212647.490829-1-joshua@froggi.es>
References: <20230812212647.490829-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Avoids doing a full strnlen for getting the length of the name of a
dirent entry.

Given the fact that the name of dirents is stored at the end of the
bkey's value, and we know the length of that in u64s, we can find the
last u64 and figure out how many NUL bytes are at the end of the string.

On little endian systems this ends up being the leading zeros of the
last u64, whereas on big endian systems this ends up being the trailing
zeros of the last u64.
We can take that value in bits and divide it by 8 to get the number of
NUL bytes at the end.

There is no endian-fixup or other compatibility here as this is string
data interpreted as a u64.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
---
 fs/bcachefs/dirent.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index a87c4e5f089d..6f9eb88c7dba 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -15,10 +15,18 @@
 
 static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 {
-	unsigned len = bkey_val_bytes(d.k) -
-		offsetof(struct bch_dirent, d_name);
-
-	return strnlen(d.v->d_name, len);
+	unsigned bkey_u64s = bkey_val_u64s(d.k);
+	unsigned bkey_bytes = bkey_u64s * sizeof(u64);
+	u64 last_u64 = ((u64*)d.v)[bkey_u64s - 1];
+#if CPU_BIG_ENDIAN
+	unsigned trailing_nuls = last_u64 ? __builtin_ctzll(last_u64) / 8 : 64 / 8;
+#else
+	unsigned trailing_nuls = last_u64 ? __builtin_clzll(last_u64) / 8 : 64 / 8;
+#endif
+
+	return bkey_bytes -
+		offsetof(struct bch_dirent, d_name) -
+		trailing_nuls;
 }
 
 struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d)
@@ -113,6 +121,11 @@ int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
 		return -BCH_ERR_invalid_bkey;
 	}
 
+	if (d_name.len != strnlen(d_name.name, d_name.len)) {
+		prt_printf(err, "dirent has stray data after name's NUL");
+		return -BCH_ERR_invalid_bkey;
+	}
+
 	if (d_name.len == 1 && !memcmp(d_name.name, ".", 1)) {
 		prt_printf(err, "invalid name");
 		return -BCH_ERR_invalid_bkey;
-- 
2.41.0

