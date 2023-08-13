Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4C3C41513
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 17:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjHMRii (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 13:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjHMRih (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 13:38:37 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122FF1704
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 10:38:39 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-307d58b3efbso3175101f8f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 10:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691948317; x=1692553117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nsLADvOivlcVOmUsKY+QQnHtSlUbobIkf+A8JP3JnNI=;
        b=GlcS6husg9dp1ddHUSAR493LKC2oUzL86EpwAkRWOpx376arp8DZnZ2V3yHDxRXnKq
         V6Vb5l/MpoB88ckKOnDYB14miQXgGYzBkx8xLSN8CmMwSJq1dPw41jpye3OQTn+vfvpx
         3ZKziFR0vDOVXmpOnJGi22p9reLdf06GdDiYDlCNFuwBezMzt+hw8L7wdmRaDPZNpfgk
         ENyS3zJCHD3dMRk3jDnblgQv2mMmM2a4SgbVS9YpWIZtuY5HV0HPLOGXAjfaQ8ofzMkA
         F6jwbSIq2ey0zoqQuv/2WwvitaXRtgfS07Iuq/lB0dm+Yrw9diUPJokgWPovKQ9F3hOw
         8TyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691948317; x=1692553117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nsLADvOivlcVOmUsKY+QQnHtSlUbobIkf+A8JP3JnNI=;
        b=PpQU7UAW+w8C8xPy1a50ZCZRtXyNnMZufs+BCR5OexFTPRYVUMcu8lTBtfuZhHrRdC
         r54eQHkK/JOKbFGFUNvHDQMWVBClhGCrk4hpg8Ks7v9tXSnFlQGzQ8O08S93Zl23/Nsb
         PW6XvczVABV5Y4E8c7Kymt0347b3lhkaJDVk079IuksmU+Hlegnquur8Ru/jjR5WF3BL
         5VflMXmIIZGIoThfRPSDhwV0RvGl71lZEIvG33STzCeg7aC+6/Z5PATXX3k+Q6GmVy1w
         iXoYUowbF6sVzG1csHgXmJJrFyq7SC2kYZuH/cyHGnZ81i/IvX/98Tahe4Dm6ZRzKGWo
         r0Dw==
X-Gm-Message-State: AOJu0YwqMDdA412F5/S6qkAFM6dEgyNNjJj6y48y6Rsi/pVs0pGuVnLa
        6e4eWK3oYuDiGDtJqJdNrLKN/SaeAxnBGez3ZSc=
X-Google-Smtp-Source: AGHT+IGoh9ETl32PCvGCweFlRxGs1ytUoYODUKkx8hgnCWLkeELevKhczkrVmncPFaggIKexmVCwzg==
X-Received: by 2002:adf:dc81:0:b0:314:1fd7:188b with SMTP id r1-20020adfdc81000000b003141fd7188bmr5327346wrj.17.1691948317111;
        Sun, 13 Aug 2023 10:38:37 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id s6-20020a5d5106000000b003141a3c4353sm11962115wrt.30.2023.08.13.10.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 10:38:36 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v3 0/3] bcachefs: Casefolding implementation
Date:   Sun, 13 Aug 2023 18:38:24 +0100
Message-ID: <20230813173835.195840-1-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This implements support for case-insensitive file and directory
lookups using the regular `chattr +F` (`S_CASEFOLD`, `FS_CASEFOLD_FL`)
casefolding attributes for bcachefs.

The implementation uses the same UTF-8 lowering and normalization that
ext4 and f2fs is using currently

The main usecase for casefolding is compatibility with software written
against other filesystems that rely on casefolded lookups
(eg. NTFS and Wine/Proton).
Taking advantage of file-system level casefolding can lead to great
loading time gains in many applications and games.

See more information and rationale in:
Documentation/filesystems/bcachefs/casefolding.rst

You can see/review the work in my tree here:
https://github.com/Joshua-Ashton/bcachefs/tree/casefold

v2: Update format to store length in dirent based on flag, add comments, cleanup
dirent_create_key, other misc. nits from IRC.

v3: Cleanup the dirent code, utilize the fact that BCH_NAME_MAX is smaller now,
remove fallbacks for too big keys that won't make sense anymore. Improved
lookup string lowering.


Joshua Ashton (3):
  bcachefs: Split out dirent alloc and name initialization
  bcachefs: Move dirent_val_u64s to dirent.c
  bcachefs: Implement casefolding

 .../filesystems/bcachefs/casefolding.rst      |  73 +++++++
 fs/bcachefs/bcachefs.h                        |   6 +
 fs/bcachefs/bcachefs_format.h                 |  26 ++-
 fs/bcachefs/dirent.c                          | 196 +++++++++++++++---
 fs/bcachefs/dirent.h                          |   6 -
 fs/bcachefs/fs-common.c                       |   4 +
 fs/bcachefs/fs-ioctl.c                        |  22 ++
 fs/bcachefs/fs-ioctl.h                        |  20 +-
 fs/bcachefs/str_hash.h                        |  18 ++
 fs/bcachefs/super.c                           |  19 ++
 10 files changed, 344 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/filesystems/bcachefs/casefolding.rst

-- 
2.41.0

