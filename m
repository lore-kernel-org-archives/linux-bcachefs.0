Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3545A140399
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Jun 2024 07:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717487020; cv=none; b=P17jW9cWBQDA8Wya5d2g/WSdwQTJy1ELRiFRX13Go5MfAiJS+IjWECMu4Jyv4Kb3rRV1usbNLgkZyEHHhhsIgtGJd/JMaX+WkrzfWMBEUs3vGgha33zIbFdOy3kfQ20qzlfoSK4URSZshux8eVcuaeP1Ayh9F2FPoabCgfP+Vx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717487020; c=relaxed/simple;
	bh=zPH8OcLDVorvEA/CzTZJEcsHsVM1aBxzi0zUZW6xeYo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XnJej1Ssu9l6jJFbulEqZYZwgah6NQZ1JJTGdUA7hqNGv21Zw9ihqxk3CCHUrJ0kGrR9aQz8D673irh3okufCaf9iu2TLO++ch+dQCliWjCnruT2zlmt0GZJ8kR6tBD0cTAknrUaFB1X7n5ZhsKkipxigYAe2PK/17WN6dCYdtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lfdURvT4; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lfdURvT4"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-57864327f6eso8472014a12.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Jun 2024 00:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717487016; x=1718091816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9ghRP9z0oZAYes3mhUmYIjl3COJXyE1ac91R+2LSUI=;
        b=lfdURvT49GN4fmDQkhnjlwcrWQlYFwUv8kEfTaLJydxNA2fKJ+VQxg+v8Q1wwMQ1nr
         eMYtK/bRTijcFUDERMInKaxnonrZ3xmCLwkkwY50FS/KLvNp6sSzKRnp2FrGoREdwcWz
         QYkymSZfkFw2f34fVQYzUaEg4UrEzwKW4gBJbLnQZSRH5ZKfgwmnRrDWiuU7QFDuNKtv
         Xrklyvkfox6ZvIyS7jDxU47nCLHAjOvhJDPRUzMKBHaSkyZ555Sha8zJkSFSF5oXh2pf
         Zj2YjXUWGB1dVg9PUDuxLdKZUIa0GE17uF1KZPvNmOessYtuuGbPag1tuA6Su8RhHGwH
         xnWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717487016; x=1718091816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M9ghRP9z0oZAYes3mhUmYIjl3COJXyE1ac91R+2LSUI=;
        b=u0Ywe9bRM2I9WJLzhqQXsGAN8l1qGci3KcrF/qF6/o5JdqBJmXg+ucgM6FbUi46AP8
         Ldm0Vpd9iRAmKdAOaPpRqbTkE7W8U/LsZzgDe/scsxBXvyd0iWlPiZaHy2FAWyoq9Xff
         kk0+FU0TcISNQ4xm3rGaOeTE9jNRH2KY/ZllVxCQQPaaEiaMChEcj3JH4sF4Y5AUIUmb
         wjSa9Z90qSaV6Kz9iJGaq2fm6wKw6yQ2pmp2qOhgEnTt58+zl1ay95AYNdwBvB8zmJbN
         YoLj6E4F8Ibt2cDfCLRcF/5BcVuTqEMPDh+obyQ3eQfBQNFfbyfnKiSWCUPqp20ATPn8
         K0Cw==
X-Gm-Message-State: AOJu0YwKUx4e5s008zSmDP3gqtZKvD3e5h90HnrlBgMJkzEBWKiAj0cY
	E3CBVE6lKjHUs9ZXHyA4aIWz1K7J8Nke2WKN6x+O/YvMhhPBgs4wM0M5ROU2
X-Google-Smtp-Source: AGHT+IFP5Vp5tIq9qySrFk3sjq179riWvDhphnvdYnGMTQ0+uXgfSePU190Gcw4RQjZ9BIvrJ9F/Eg==
X-Received: by 2002:a50:874a:0:b0:578:6360:aa11 with SMTP id 4fb4d7f45d1cf-57a7a6a1b68mr1330318a12.5.1717487016401;
        Tue, 04 Jun 2024 00:43:36 -0700 (PDT)
Received: from localhost ([109.166.137.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a31c6d4b6sm6847706a12.74.2024.06.04.00.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 00:43:36 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>
Subject: [PATCH 2/4] Fix performance regression of update_inode
Date: Tue,  4 Jun 2024 10:43:23 +0300
Message-Id: <20240604074325.798349-2-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240604074325.798349-1-ariel.miculas@gmail.com>
References: <20240604074325.798349-1-ariel.miculas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This kernel commit: 65bd442397274347e721a89c2c4882a392bae982 removes
BTREE_ITER_cached from bch2_btree_insert_trans, which causes the
update_inode function to take a long time (~20s). Add this flag back in
the update_inode function.

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
 c_src/posix_to_bcachefs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/c_src/posix_to_bcachefs.c b/c_src/posix_to_bcachefs.c
index e1460e9b..63fab98f 100644
--- a/c_src/posix_to_bcachefs.c
+++ b/c_src/posix_to_bcachefs.c
@@ -19,7 +19,7 @@ void update_inode(struct bch_fs *c,
 	bch2_inode_pack(&packed, inode);
 	packed.inode.k.p.snapshot = U32_MAX;
 	ret = bch2_btree_insert(c, BTREE_ID_inodes, &packed.inode.k_i,
-				NULL, 0, 0);
+				NULL, 0, BTREE_ITER_cached);
 	if (ret)
 		die("error updating inode: %s", bch2_err_str(ret));
 }
-- 
2.34.1

