Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA9E49638
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 18:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718390850; cv=none; b=gKN0s5XvGsc7HNqNFbDNbTc3lBt8ZLZnLlwG7tbMgenYk1bPs1acF2tTiu0KnS6gd6ktAddNcwa/a2sXJxOh3gGiFQ5cbWQB4MBAkCErOiWnrDdPGL+XMJtc7DDbCAHfNTaYw9YeA6I+6YaRb3SpWjRitSMtQK2eZFlBhxiHAyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718390850; c=relaxed/simple;
	bh=ZC65vtPe07G8ruJTDO9+kDLDRq+eU6EtrKmUnmfelyA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CS6NqR1KnVUe8Utrl3HqyWB+kRPN++aGTb4O0Z/iMpQg4LhunG9D4pRAMshI0TMP3FPAVj/ChcHqt6aeirmpX/7O1+QlWYjsP9Hl9NhqNpFK7JlNYZgROhQg0rM5Qj8atuMf6d8cqEDBRpb4uf//7B1URe/VxvDIohJn+brTZ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QI7qlKFG; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QI7qlKFG"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57c60b13a56so2904032a12.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 11:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718390846; x=1718995646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W0Tv78JeP3slj56+5uxcEXyhRBfu0gBCkTzc8OLB2Ps=;
        b=QI7qlKFGkLN6edkvUva7oJEspOUfzupjuRZn2l4BjPXp72ClsrsptqmJiVWkViZ/zc
         pm3DajuIE/DxgyKABBRzisNrzpfIv/i55lZmfDBQK1lv9c3hsN9fcfVDpF4O1iIKKp8s
         rJgb35iFY5ZaSuLTNf/wr2DgG2/tg8zhuH86uHt49q7AVXdJboLacXOg9vXW3S0k+/Uo
         59Ga+830KegX2O0SBswqKIWtPYnNfAelM/6PzSMqd05tOGHaZ8spJQWCO6N/3wiBoipT
         LfauXnQxCZ8IFdmKIy4fy6X+JJqQShfsJiXJz1VTn6Mm/VcNHlOEKyAygeqeUg1QbuO7
         Yl8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718390846; x=1718995646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W0Tv78JeP3slj56+5uxcEXyhRBfu0gBCkTzc8OLB2Ps=;
        b=gVV1Ir0g3FNZO9o8hS7dxsLtCIJqJTZgLRFzgauj7lkd8NWPIbxxABKPNVgvi4/KR5
         5f5d/h+hgMulSEdWciy7okSiSwh5AHvLVY7fbwu85Di3SbmDBK2otq9zBkHPLeu7WFnP
         u3rRMIk7odhqDnB87lJuJDcQM3W207j8qD1CnbvGtxq0JkPCdtiF1gMych5sDjEGFnqz
         dZxcboFt44yGWqF4rgqcjJv3okykebbCXI17Z5IKxox+h9JZMGZFPuho1W1YuMySejhH
         svve3K3ys+iCWtA7NXqbQFSyDYqVbZK9kk9cL+qnhafBY2PpShD2fuO8YPN03fiJVv1x
         uR4A==
X-Gm-Message-State: AOJu0YyqdoAaB6fP34yyOqrt77o785VK9yWqu+tNuF2ayYurMf7v5tCk
	6/iXRFUXDfQLeSpFh0xsD72irYcDw9lfHXyG2PstonO6fSXRqiHDUTKHPhDs
X-Google-Smtp-Source: AGHT+IFhX97e9ps4erRIyEQ9y6LMO/GHivog+0xVkBbkNwpv8GCrz+XFLXUb9gOv8unaSWn5M6E/kg==
X-Received: by 2002:a50:8a97:0:b0:57c:47c3:dc62 with SMTP id 4fb4d7f45d1cf-57cbd651ce3mr2049842a12.5.1718390846403;
        Fri, 14 Jun 2024 11:47:26 -0700 (PDT)
Received: from localhost ([2a02:2f0e:615:a300:e591:7f5f:c9d3:c3f5])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb72ce2b3sm2583766a12.14.2024.06.14.11.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 11:47:26 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>
Subject: [PATCH v2 3/4] Fix incomplete file copy due to copy_data misuse
Date: Fri, 14 Jun 2024 21:46:52 +0300
Message-Id: <20240614184653.276043-3-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240614184653.276043-1-ariel.miculas@gmail.com>
References: <20240614184653.276043-1-ariel.miculas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The copy_data function takes a start and an end parameter as the range
of bytes to copy, but it was called with a start and a length parameter.
This resulted in incomplete file copies. Fix it by passing the end of
the range instead of the length.

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
 c_src/posix_to_bcachefs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/c_src/posix_to_bcachefs.c b/c_src/posix_to_bcachefs.c
index 131913d1..c66b9734 100644
--- a/c_src/posix_to_bcachefs.c
+++ b/c_src/posix_to_bcachefs.c
@@ -288,7 +288,7 @@ static void copy_file(struct bch_fs *c, struct bch_inode_unpacked *dst,
 				  FIEMAP_EXTENT_NOT_ALIGNED|
 				  FIEMAP_EXTENT_DATA_INLINE))) {
 			copy_data(c, dst, src_fd, e.fe_logical,
-				  min(src_size - e.fe_logical,
+				  e.fe_logical + min(src_size - e.fe_logical,
 				      e.fe_length));
 			continue;
 		}
@@ -299,7 +299,7 @@ static void copy_file(struct bch_fs *c, struct bch_inode_unpacked *dst,
 		 */
 		if (e.fe_physical < 1 << 20) {
 			copy_data(c, dst, src_fd, e.fe_logical,
-				  min(src_size - e.fe_logical,
+				  e.fe_logical + min(src_size - e.fe_logical,
 				      e.fe_length));
 			continue;
 		}
-- 
2.34.1

