Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89B9C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 21:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjHLV0u (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 17:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjHLV0t (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 17:26:49 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C69C10D5
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:26:52 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-31969580797so762470f8f.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691875610; x=1692480410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bb42mhvfm3cX1t8TaSdwminQLnaM87t8/HfPSlrjNsU=;
        b=BPrLZmBTDByWEyJ9IHLrfXnJTZ3NkR2ahADfpv9HK36nClt9xCFLyJ4k4f0iySHrM/
         sIw8i/QxFP1/5bMPgid8COzOsnNYNExhbPBzCxfVHgCruaAkWK9ylBLyfaBFCHr0wDgX
         jkbBVv1nsEk2M4C4GIN8AIUHt+X3UbMWO9W0CcvWgOmfeLhnIRnYsH3xBXKoKzdqXfWC
         umKPRknuWK4BFF8Fv5qaP+ApQHNgXXA5SKnMYJtEcAOOhzZgW3q1sEHcqt8jEFKujow2
         650XD9xO237lmFJnvhZdFe9qutyPiJmiNO5Ghvmz1Cmlu7YMTpBYlziOYIFO4wSLQeVq
         9grQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691875610; x=1692480410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bb42mhvfm3cX1t8TaSdwminQLnaM87t8/HfPSlrjNsU=;
        b=AGehTZgxi3wD7pErbRrRKQ3uRkcSOtJxIU65/pWI+VrumDbLHCLUObY4TDbVPmCNQV
         6bj3TL00CHkgkwBYGBW//AxlpcdKf4NOmxeXOTAUbkDtZL5slhoMcjUkntdCltst1YqX
         djWceVqtPVq8EOJbJ8t1l9NoB/r4//6NH1lPi10V5WSVZ/8sAdxA/hqy36cZM/MiFPE5
         F9x2kthBf2DvKrOzlWIRzRoamDukySuCsILXx+Zj5avBgFyZcjOEpNtLP+ySyF9TyYL6
         o5/dVk+DIh4KvXIl+5q8fj+/NX+Qu6CT0cuOCsgbipXgWHciywVQ+oQHHVJuJCtgfhie
         dZwQ==
X-Gm-Message-State: AOJu0YzpXjkoYpVIgy1kAQLRPab2622Z/MUrqC/2jC4qXoDeU5ywGnKV
        iifbZXKIYTtVnygB/hUBTO53r/uYWRTKbif9sfw=
X-Google-Smtp-Source: AGHT+IFd5zFMFfNCoLDXraRWnWQ0jZG+FtXLafvuZ7q8Nj6D/Rhye+JcuZvYsbl+0Yo2pY7IIgtWHg==
X-Received: by 2002:adf:e786:0:b0:317:62c3:13a7 with SMTP id n6-20020adfe786000000b0031762c313a7mr3808676wrm.19.1691875610006;
        Sat, 12 Aug 2023 14:26:50 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id p1-20020adfcc81000000b003179b3fd837sm9536481wrj.33.2023.08.12.14.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Aug 2023 14:26:49 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v2 0/3] bcachefs: Casefolding implementation
Date:   Sat, 12 Aug 2023 22:26:28 +0100
Message-ID: <20230812212647.490829-1-joshua@froggi.es>
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

On the lookup/query side: casefolding is implemented by allocating a new
string of `BCH_NAME_MAX` length using the `utf8_casefold` function to
casefold the query string.
An allocation is required here as `BCH_NAME_MAX` is quite large ~1.9kb
and would not be safe to put on the stack.

On the dirent side: casefolding is implemented by ensuring the `bkey`'s
hash is made from the casefolded string.
If the dirent's regular name and the casefolded name (and lengths) will
fit in the dirent key, then the casefolded string will be cached there.
The structures looks like this:

Several designs were considered for this system:
One was to introduce a dirent_v2, however that would be painful especially as
the hash system only has support for a single key type. This would also need
`BCH_NAME_MAX` to change between versions, and a new feature bit.

Another option was to store without the two lengths, and just take the length of
the regular name and casefolded name contiguously / 2 as the length. This would
assume that the regular length == casefolded length, but that could potentially
not be true, if the uppercase unicode glyph had a different UTF-8 encoding than
the lowercase unicode glyph.
It would be possible to disregard the casefold cache for those cases, but it was
decided to simply encode the two string lengths in the key to avoid random
performance issues if this edgecase was ever hit.

The option settled on was to use a free-bit in d_type to mark a dirent as having
a casefold cache, and then treat the first 4 bytes the name block as lengths.
You can see this in the `d_cf_name_block` member of union in `bch_dirent`.

You can see/review the work in my tree here:
https://github.com/Joshua-Ashton/bcachefs/tree/casefold

v2: Update format to store length in dirent based on flag, add comments, cleanup
dirent_create_key, other misc. nits from IRC.

Joshua Ashton (3):
  bcachefs: Introduce bch2_dirent_get_name
  bcachefs: Optimize bch2_dirent_name_bytes
  bcachefs: Implement casefolding

 .../filesystems/bcachefs/casefolding.rst      |  61 ++++
 fs/bcachefs/bcachefs.h                        |   8 +
 fs/bcachefs/bcachefs_format.h                 |  29 +-
 fs/bcachefs/dirent.c                          | 285 +++++++++++++++---
 fs/bcachefs/dirent.h                          |   8 +-
 fs/bcachefs/fs-common.c                       |   4 +
 fs/bcachefs/fs-ioctl.c                        |  23 ++
 fs/bcachefs/fs-ioctl.h                        |  20 +-
 fs/bcachefs/fs.c                              |   8 +-
 fs/bcachefs/fsck.c                            |   8 +-
 fs/bcachefs/str_hash.h                        |  84 +++++-
 fs/bcachefs/super.c                           |  10 +
 fs/bcachefs/xattr.c                           |   6 +-
 13 files changed, 478 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/filesystems/bcachefs/casefolding.rst

-- 
2.41.0

