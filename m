Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0C3C04A94
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 14:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjHLOuY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 10:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjHLOuW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 10:50:22 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98AEE58
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 07:50:25 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-3196fdb3238so119231f8f.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 07:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691851824; x=1692456624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkkHtuFl1b5g5rWixUOpqcSAb2dov/5cGn2WDEH7Rho=;
        b=IkwDwlxyJp0oMQgbF6iZSTuhzP84jHiVomlW1lQ3hQudBOUD7tOjbALVF3KpP5WO5c
         DrK5TRYREXqW8mYeNgjx3U+/Npsy1LsRVaAN/N3SpR7asQr9EViAwO1rOUNVN/W0Wo5D
         7Slx15YiCdADY0VnQS6/fhX4BB7ponrdH9sCI0DlMzAi+1qukZcPe7lesaGWPZw1zoZT
         jjAETgvOtM2Nyin0SOKttuNPMfDRlcZ6BZPBDnjmzuijLeFyXaxXl/sqzjdaGFOgqfcp
         Rjt2cbr5kAUJKoSD/Crb9ZggJReQbkLVEcfltjeXth/US7mwPzlSywkE0Vre/+3e9hsj
         Gj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691851824; x=1692456624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pkkHtuFl1b5g5rWixUOpqcSAb2dov/5cGn2WDEH7Rho=;
        b=fzzj44y9HNWsq0RnojRcvc5WBv2olDlrvJkQDBAYyFsoW26NUgLkIi7LwIimXzmTmg
         xWBchzvo6knUc/fRD4OxhYktPiZRkJfk1FYAg0WTCokk9I4XP9QZsKVSSfjp0EUCHTTP
         9/tnMyAfqlMQmi61SAc2MSaTRvMeTlu2DZMHwiAE5SBkY6Yyj52N9sM+jyJg4KSaodFC
         2rtk5s57V7DCEHWIqYGjOOEyIVzIQIeCrHBGZEEZ593GOFrlqBiGbbI9oPvc+VW3cn7Y
         CTYrfuenFauvBmj/SRsP9tUL9/6VefjonOvTKCG2LBmhcR3tEhrny2u6Nn1SsBbYyojL
         qq+Q==
X-Gm-Message-State: AOJu0YweAi8m9NVOWm91/5DwTEcenl7gsU6/j9VO9S50BeTYSMkyOO8H
        ELV0N4Jh00XUpO/d/d2MZZehYimeFGidw+wzpzI=
X-Google-Smtp-Source: AGHT+IFE4hn1hdz4l0fnclFpEuFnCP6JBbET9NYfYSsvqk2mBVEJmApObHa4/XXHW7QNtQwtbiT3OA==
X-Received: by 2002:adf:f0c4:0:b0:313:f33c:24c4 with SMTP id x4-20020adff0c4000000b00313f33c24c4mr3409775wro.39.1691851823741;
        Sat, 12 Aug 2023 07:50:23 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id w17-20020adfee51000000b00317eee26bf0sm8771784wro.69.2023.08.12.07.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Aug 2023 07:50:23 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [PATCH 2/4] bcachefs: Optimize bch2_dirent_name_bytes
Date:   Sat, 12 Aug 2023 15:47:46 +0100
Message-ID: <20230812145017.259609-2-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230812145017.259609-1-joshua@froggi.es>
References: <20230812145017.259609-1-joshua@froggi.es>
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
 fs/bcachefs/dirent.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 065ea59ee9fa..b86c6c27424a 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -15,10 +15,18 @@
 
 unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
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
 
 static u64 bch2_dirent_hash(const struct bch_hash_info *info,
-- 
2.41.0

