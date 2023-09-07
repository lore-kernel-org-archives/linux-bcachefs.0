Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18203EC8740
	for <linux-bcachefs@archiver.kernel.org>; Thu,  7 Sep 2023 16:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236683AbjIGQBH (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 7 Sep 2023 12:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243187AbjIGP7g (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 7 Sep 2023 11:59:36 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48584C0A
        for <linux-bcachefs@vger.kernel.org>; Thu,  7 Sep 2023 08:49:34 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-500b66f8b27so1888194e87.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 07 Sep 2023 08:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694101695; x=1694706495; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ruWArLsIk/aS9d91i/0L81ue5MlvmUx78+5NC4yfWJk=;
        b=ickgIL17qTg7OZS4+zvKxgecYpIM//XBuUWTsqJ7eE4VzE+IBXqj9cfDest+5T8VYk
         60qakWnGXTjhacQwH9R6bQK7nNldnSbIYLC/R9spXr1+HssjGKEdsHGRzZ4iIhbmUElO
         zJAj5Ys31JorGK0oCkwdkNkin8GWnvxRKr91gqPG6aWRI3CjGmF12k5lASLa3Ogqhkgk
         G5ieyVfQCg+CMxTFnJfWoUZQ7IhBP1oHKSHwtwwCKWXFx6btsYzxh139uhAmmNiWpcIr
         rH7kplADaS/nKhf3Y2/XxsMY15EkAh/ZLnvpKmJeu0bMEBa4Wt4+sfQyY6nsjQP90dKg
         wIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694101695; x=1694706495;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ruWArLsIk/aS9d91i/0L81ue5MlvmUx78+5NC4yfWJk=;
        b=EfKpQR/HGZvJy/UOoXYqUbqZD3in6VwxpwB1nSjF6cezjn8Go6pBoBdz+C3SepWbpR
         ChWeDTehvtnneWh3WXRtLxiLOdgBgp3mVZ3WVe1MR3Jwzgr6k8mcRJAsFxYUw1e0t2xQ
         1SGVXNYydExlpruymzvivNkxcKVUyy0ZpJK9IEo9sJ2hz2KantudqZE6G4m1tr8pmkm3
         qQh9wnRA/nuwPr/5kOdx1PMHGLuD2UKsgUpO73fD+7VOY20v8QvS6i13Aehrtk/di3Ht
         3jrq0FwOl65tsZ3gXBXKc6WALtqnRtNK3FQrBgb4JOgs2m3syLYRp+96xBud5Qs1CqQV
         lhEQ==
X-Gm-Message-State: AOJu0YzbUQEaF7he0Qd6kzGb/ucxcq/WUFXg9wPKl/gIVfZ2yt2isI9E
        ZU4zSlfmEY/BIJ0/lAbVRvKb/4f8tKWL9yK8vipRt4+QM8Y=
X-Google-Smtp-Source: AGHT+IHGCmHHAoBnOCaPiLAn7TmCUy67q0u0ACP1UgLd2K+G4BA5wHHOE81IAPBIbSAHfs2IrXuLqIstihwbsY3l6Ks=
X-Received: by 2002:ac2:4da3:0:b0:500:8f64:52d4 with SMTP id
 h3-20020ac24da3000000b005008f6452d4mr4804007lfe.53.1694091136055; Thu, 07 Sep
 2023 05:52:16 -0700 (PDT)
MIME-Version: 1.0
From:   Gabriel de Perthuis <g2p.code@gmail.com>
Date:   Thu, 7 Sep 2023 14:51:38 +0200
Message-ID: <CAFEugPc5Qyvdd69NaQKYOyyaSD-0XcUjAg4FBP8z1=7RV6oOAQ@mail.gmail.com>
Subject: UBSAN: index X is out of range for type 'btree_iter_set [4]'
To:     linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello,
UBSAN reports some errors with bcachefs; it would be worthwhile to
enable it in the ktest CI.
I have UBSAN enabled because I started out from an Ubuntu kernel config:
grep UBSAN .config
CONFIG_ARCH_HAS_UBSAN_SANITIZE
_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS_STRICT=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
CONFIG_UBSAN_BOOL=y
CONFIG_UBSAN_ENUM=y
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set

Currently it reports the following:
(bcachefs master (d0fb567ff8e045149050a1e8f6646fa9c61dab7a) + linux 6.5.1)

journalctl -k --grep UBSAN -ojson --output-fields=MESSAGE |jq -r .MESSAGE |uniq
UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1098:3
UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1207:3
UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1152:4
UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1150:4
UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:291:4
UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:281:4
UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:291:4
UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:36:18
UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:281:4
UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:301:5
UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.h:29:13
UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:25:47
UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:25:30
UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:27:3
UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:25:47
UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:27:3
UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:25:30
UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:27:3

This started happening earlier, I have one boot based on 6.5.0
(bcachefs master 493c276ead0e516ff3eca8d13b820d31afd62524) reporting
similar errors, whereas the one based on 6.4 (bcachefs master
117cd823d2d77dd8db1ec35b5819e1668c736b31 merged with stable 6.4.12)
didn't.

The errors are of the form (indices vary)
index 44 is out of range for type 'sort_iter_set [4]'
index 4 is out of range for type 'btree_iter_set [4]'

Uploaded a fuller log:
journalctl -k -ojson --output-fields=MESSAGE |jq -r .MESSAGE |grep -B1
-A100 UBSAN |grep -v '^Hardware name:' \
  |awk '/UBSAN: array-index-out-of-bounds/,/=========/' >
bcachefs-6.5.1.ubsan.errors

https://pb.envs.net/?399630cde0c62c76#4zUPPizf68bXGVoyxedZawKGVswrX4JaoeTJ5shKLvfJ
