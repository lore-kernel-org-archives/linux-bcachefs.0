Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4CBA59
	for <linux-bcachefs@vger.kernel.org>; Sat,  2 Aug 2025 05:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754111120; cv=none; b=MWNO4uNw6YElwqAxkiQr41BSx65OgNs8PpD5BnpCXQLmnuj+kmytlypBsR/Slg62HyGBvewkpG1BBXuS/t1P8ASc4dfiD1ctbms4wIMuqOR2VvzE7bntPgIJAz+WXhU1Kn03UuoWVMes9BUyxuoJgN95EZXoWFGWEp9IvGll+ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754111120; c=relaxed/simple;
	bh=FXqIKcNYGDhWJkeD4qSD2VscEBOuhbgVhc9uC2eBFu8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lKeI8VLwjaCMDux51uen0J1H5qPuwqeexNFSgvwAhq6vFPwROBGSWMQMIRocowjH0vXMQ1L732cVGfn3QabTy7foOxI+PvvXTZ6M7Z9Bh9NtgNT88nMIsWLQbsL0WkjWXJNIMiBkzGP3j1AQ5px/wXdCD+7N+LrnvZ1xLfPTRTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZhBaHhJF; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhBaHhJF"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-74b52bf417cso1541271b3a.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 01 Aug 2025 22:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754111115; x=1754715915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cxhQK7Exz71+0hInBr3EDkUcsY3+FHFkMlatnsoBZUk=;
        b=ZhBaHhJFjTdY0mSmL4DBLu90V3osx1eDOYl1aI58UMeG5JcgokGFCM/LOWzxYZaQUk
         XkeG0ZNE3yoEX0KsG29P8Z6jVeBXYRj+rm6o6DzFWi/hOsTEf6bPLi8dvAcfxAEmvfLS
         pIYvengVgZrBYrM2Jw/YLl9s3TzDg4MFvKhH9P4mU/Ny2Z/W3mafqG83uFo8mUaWGVrZ
         B/e6Uj5kQ/3uT6BXK7d07ImGfW+FwRYKMCzD4ImQdJFQrKCGvzEoAwnRaqIArlQSEA4P
         CmnTbyUQOjf4DR4/EnZyJr34xnkJsiVH2rYKMzwAV6GokAasZ1Y7+7hjonTnOLC91JnF
         Eoqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754111115; x=1754715915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cxhQK7Exz71+0hInBr3EDkUcsY3+FHFkMlatnsoBZUk=;
        b=Vh3E/GB1zUzboYkkTEW0xLxJ/UZveI4qjquR8k+82XdZfNXPmhHmxiJhTslRQaa5jh
         PiwftjLxBr67Me080rvEYQ9sTguJsZY2Hw26ugAo8C11rILLGijnXhZl8dMFtKnerf4N
         eRot0HqgQPGVqZEy2i7gIOk7G/6zauWicHlbAX6FR63ACqtleIKbD40n5NmBUqalFWd3
         w8ltFyJauGCcB4BeTM/lYTosQy47GBBA2z9xhFg8eGHUclN3q+6y8skLMRWbIDaoIT/g
         CnlFN3jmI4E0mBZZEPGqWgVxHrbFHiM9P/jwwTtd2dlRi14IhABZ8X7JRmMkPwQFUmmQ
         lGXQ==
X-Gm-Message-State: AOJu0YyBsg/WTq6+dsdFfCTKAo1kDN4QVVdW4WDi7UI2EruAozw+ainD
	fifPK/S0dBebbbSid3FyZQ4yAKgSO2fJtwKa5OnFy7zP8D0ZWqutTJ68
X-Gm-Gg: ASbGncsZb9fvmScAqBejw2i0maekMpPazhHJXdoZhB5QCVhlBCL2Uk+m0RUbOe0rX7t
	nZDzwi1ojf8K9um9FXBbggxO4D3Ow4NMiRbmwtffDcRA2LwbjS/NsgY/MWEbg8atwNq6x9UaiVl
	NnyHRDFm4Vh0w29dAQmu2tPbzvNsOZ0cREgszF91TrsHBiD20leji4TWijAkl4NQqmQLJewg6mw
	/NlAcA8ZCvRozIVY4smZSk0KEazu3fv6u9+6avtC9fpbr0zaWxtgUVzl0zvQoW82lZo1nsVYqxL
	H9a1h8IgtXsnh8o9BYMPONpIneEnrlBW29kU9d4IAKPZK9mpmO8qr0MvcB23Hr8DQ9npZymAF59
	pXOkSPZABZ6tf
X-Google-Smtp-Source: AGHT+IGwxmFdiGk0u92YCe4j7w7iC0ulhjY8CRV/R9KnAfYWowV0TUHH9jBlPy1CJFi4OTZlFg8BGg==
X-Received: by 2002:a05:6a20:748f:b0:23d:e845:14bd with SMTP id adf61e73a8af0-23df9134bd5mr3850553637.38.1754111115512;
        Fri, 01 Aug 2025 22:05:15 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422bae3036sm4896759a12.45.2025.08.01.22.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 22:05:14 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+d3fa2fb715cfcc9d201d@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix incorrect transaction handling
Date: Sat,  2 Aug 2025 13:05:11 +0800
Message-ID: <20250802050511.72518-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ')' before the second '?:' is not correct, transaction restart
handling should include bch2_inode_hash_init_insert.

Reported-by: syzbot+d3fa2fb715cfcc9d201d@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 3b289f696612..b5e3090f1cb8 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -511,8 +511,8 @@ struct inode *bch2_vfs_inode_get(struct bch_fs *c, subvol_inum inum)
 	struct bch_subvolume subvol;
 	int ret = lockrestart_do(trans,
 		bch2_subvolume_get(trans, inum.subvol, true, &subvol) ?:
-		bch2_inode_find_by_inum_trans(trans, inum, &inode_u)) ?:
-		PTR_ERR_OR_ZERO(inode = bch2_inode_hash_init_insert(trans, inum, &inode_u, &subvol));
+		bch2_inode_find_by_inum_trans(trans, inum, &inode_u) ?:
+		PTR_ERR_OR_ZERO(inode = bch2_inode_hash_init_insert(trans, inum, &inode_u, &subvol)));
 
 	return ret ? ERR_PTR(ret) : &inode->v;
 }
-- 
2.49.0

