Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6124C0015E
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 23:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjHLX7s (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 19:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjHLX7s (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 19:59:48 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFA5127
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 16:59:50 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3fe4cdb727cso31931055e9.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 16:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691884789; x=1692489589;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3pqbbxDjlQ4NB0Vp2yeWe0csa5P2VM0yPzmms9dWbA=;
        b=aWv2whxqhptX84LCvnNhGRQaD3/eUVQjLiWCO2XP5EJiZLuzYsVaWPKzSoxR+5pjTI
         bWMFk1mM0f/+uYoi+06WKKKlni7SeEcY8Ge3w2IJIGFT0Rm7V6mjrX4l8DYSSEZG4Zfh
         KkNuTnKBttkLS1wakp/NMh2FTuu37k0VVTUC/lqEG6CAiEcPiNROms98rcys0zgs2Nr2
         LEcM8EH7TIBGEQtSN127BO/zfo4ZWj+fI5HYm7PJALqb0K09D+yirLUWvPVAtIoO/1Br
         NM5lB8lzJ7Q2jahIBswH5Z2W0O86n1aFhiym1/RkVyAD4aiStTw0RuJ+VAYB9dcrm3Ei
         W39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691884789; x=1692489589;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q3pqbbxDjlQ4NB0Vp2yeWe0csa5P2VM0yPzmms9dWbA=;
        b=aIE59aRPnhqPc3iWJK+hYGaUdE6P+EW0wuZOSNX3uJvAZov764Ll7gP14cG8DxhK70
         tE1bonzDIgSEV7anMqgVIJTkeZ3V7wZQjL7BNO/fwQu26BrgGftErqK7tH14PXq7WQ/F
         NrAbi/allsFpM9ooeQpEUxKbuCnOZsEU7MaHcSNz1yi4GtewEqZx8nG9qR9SUxU1RbTf
         m/ry6ONSjnKGCRivNYAGFmbiXMF2cL1HKK+poNN+7+bKuDQceAKZPixmLrmNWwTYPPos
         Bw63K3b4LhSNMNep0sAT3T9BRx9jtaFWEDqAAcg2VrDsm9BCl0a1E2XQktUtjv1SbGgR
         hK0Q==
X-Gm-Message-State: AOJu0YyomTEdciQZ/AbOIIX0S5HMPNA2PLvHo7+SMsxCd5Bn4d3VtpoN
        r6PEcLQMuD1TMxnJL1+R9lYvfkGmfHheK21iUcA=
X-Google-Smtp-Source: AGHT+IGY2K70D8nQsi+rRxyUCBU7uFp74DU045D7vZQMTtU252htoI347YrC6XqiNo+Ju56aOl7NhQ==
X-Received: by 2002:a1c:7910:0:b0:3fb:e643:1225 with SMTP id l16-20020a1c7910000000b003fbe6431225mr5027540wme.13.1691884789016;
        Sat, 12 Aug 2023 16:59:49 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id q11-20020adfcd8b000000b003180155493esm9754038wrj.67.2023.08.12.16.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Aug 2023 16:59:48 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [PATCH] bcachefs: Lower BCH_NAME_MAX to 512
Date:   Sun, 13 Aug 2023 00:59:17 +0100
Message-ID: <20230812235947.557433-1-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

To ensure we aren't shooting ourselves in the foot after merge for
potentially doing future revisions for dirent or for storing multiple
names for casefolding, limit this to 512 for now.

Previously this define was linked to the max size a d_name in
bch_dirent could be.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
---
 fs/bcachefs/bcachefs_format.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 5ec218ee3569..23bae622309c 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -916,9 +916,7 @@ struct bch_dirent {
 #define DT_SUBVOL	16
 #define BCH_DT_MAX	17
 
-#define BCH_NAME_MAX	((unsigned) (U8_MAX * sizeof(__u64) -		\
-			 sizeof(struct bkey) -				\
-			 offsetof(struct bch_dirent, d_name)))
+#define BCH_NAME_MAX	512
 
 /* Xattrs */
 
-- 
2.41.0

