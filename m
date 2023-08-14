Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91520EB64DD
	for <linux-bcachefs@archiver.kernel.org>; Mon, 14 Aug 2023 01:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjHNBYs (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 21:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbjHNBYq (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 21:24:46 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025F2BD
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 18:24:46 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-3175f17a7baso3217563f8f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 18:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691976284; x=1692581084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B0PUh+i1+xTpL+x7pa5xQDAs6uXCNVeXkKaDhFV4trQ=;
        b=SlIjoOEEUmSpeOeWsWOsb5QFW/NWu9zqNdoCF76dP5oR4Z++fD3yXkb7u34qW80rqo
         vl5sRQl3azxF9PIAltpS2WWOe99qfx5/0cw153JbNqKvngDI7D/QrgDs3xir4Hav3cBw
         D7POSxG2jcdfi43BlvnSVGiRzQcv4OchYUMt56FiCnsOQIeDnur5Ql9IgzM0k0Gt9FXm
         bozySM2y+6A6QvsC+jZGKemEyXm5EM5P2I827HYuFV7bq+fIEfkNjzVGYYVrNNBH1TpG
         NIjrSh9uIcfxOxJ9fz2u8xAULoPCSIJu3o7UPy6n77M1wz0MmHNj/rGjNyOaVmeFTexP
         YyYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691976284; x=1692581084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B0PUh+i1+xTpL+x7pa5xQDAs6uXCNVeXkKaDhFV4trQ=;
        b=bveL7rA6lncyZmkakrgFeQu0vj+OWXKZ+r0H78jnjwPtdRf5iUSD3kooX1F1lEk6+I
         dnzfajRc0gWBqsLm0I+W2azWm+ilmONi+qLdHR7VQr55OJWqQ2R9BbeWRERomxVY96k8
         loCPWcSDcLE/T6dhuckWDJoi79re8Pg4SEy+1DCfnNBXWgNiGxGvjrfvHA9jFhhPMoip
         nTp5eH7KhBgnhs94HEat1QIkLxwrvLUkBKJey6IBj20QDIIcLDS3zeh1CVc42cjmmjeF
         E7fLxepyh9swXGS1SiQ7cSBkzEV1eLV/OdCX6O86zqInpcm8rlctFk2cGwR+VOnNP1/0
         FGUA==
X-Gm-Message-State: AOJu0YynVK5TnskACmCkze1EQ7LFDcNXxMSs91s70QQpMnr/sWEpemUB
        JLvvn+ZgyNCKq01Ugw+l7f3Fd3U7fcj/2HAYKrM=
X-Google-Smtp-Source: AGHT+IGl6f4tbDbipGX8y3K30XHetnm1FWovH2Q23BRcvS2yXx6AuNHiZ2zyB+Z9Rj7LxLpjkckA7w==
X-Received: by 2002:a05:6000:128c:b0:319:72f8:7249 with SMTP id f12-20020a056000128c00b0031972f87249mr2002978wrx.66.1691976284400;
        Sun, 13 Aug 2023 18:24:44 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id a2-20020a5d4d42000000b00317ca89f6c5sm12802076wru.107.2023.08.13.18.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 18:24:44 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v4 0/3] bcachefs: Casefolding implementation
Date:   Mon, 14 Aug 2023 02:24:24 +0100
Message-ID: <20230814012434.627641-1-joshua@froggi.es>
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

v4: Move cf_name allocation from stack to trans alloc, validated bkey in invalid,
used length directly, misc. nits.

Joshua Ashton (3):
  bcachefs: Split out dirent alloc and name initialization
  bcachefs: Move dirent_val_u64s to dirent.c
  bcachefs: Implement casefolding

 .../filesystems/bcachefs/casefolding.rst      |  73 ++++++
 fs/bcachefs/bcachefs.h                        |   6 +
 fs/bcachefs/bcachefs_format.h                 |  26 ++-
 fs/bcachefs/dirent.c                          | 219 +++++++++++++++---
 fs/bcachefs/dirent.h                          |   6 -
 fs/bcachefs/fs-common.c                       |   4 +
 fs/bcachefs/fs-ioctl.c                        |  22 ++
 fs/bcachefs/fs-ioctl.h                        |  20 +-
 fs/bcachefs/str_hash.h                        |   4 +
 fs/bcachefs/super.c                           |  19 ++
 10 files changed, 353 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/filesystems/bcachefs/casefolding.rst

-- 
2.41.0

