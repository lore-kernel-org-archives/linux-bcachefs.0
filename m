Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBF61C1738
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Nov 2024 08:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730796708; cv=none; b=iQTrxxm3luxsewx3FlbQ4MdWNpTuWTxyXcSP3hQ7brQcEKAV9xHvhhMxIeGEVjvTscWnv9ODVEhMJJZzU8xGzNdGxh3y8RveYFP0CZFrMUDBAdYpRphmq6Y+r4B3vmQHVF96ztb+3bzXDIqWmPe3juY0UFPwh2jrTstOUy/+vbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730796708; c=relaxed/simple;
	bh=JnoSxW5G85B/jUy3qIfGat6BuL9607vn14RgoYW5NOY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dYUQ3Dnzl23HME9Vk8+FOhVnFoULGdLVd9jds82/iAlzv0JKgA2g5BzJrhEHuB+DuuFV16CXEuByYJGKK9e/jMcEW7K/jw3A+LivknQJdDU29Af9LCXsNo8PxybEj7OmRXF95k/dNf/7pXJq2GiGkXFNk1YahX3xzXEbUF29ssI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=eTiPNObw; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="eTiPNObw"
DKIM-Signature: a=rsa-sha256; bh=nCdbszk+XB9oUjd2RYDXP7Ht+hnGQmcEjhKBhgjDQL8=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1730795775; v=1; x=1731227775;
 b=eTiPNObwsyYAVgDQfSohHHSpQTitQLMYdjPrLSqUnSYEsod68HyiHNWWz8KhVmmF7+kIbizN
 Ng/1jbYfKy67HczUBDDrk4KXWRSWL1TfyU8M8cdCz0FU2Rc8FhjlqpepPG58Fa2l5mQiQUu87L9
 zenQWlc62+NuY8rQNoqqmHT2Y0/rHOSjqRw3p0DHNN2C+uR5s504Sv7xK9hMecRKUxrcQH3/xLt
 xlkXRDwrbag6ErG1v7/zRgPPBJcyrbQNVNUwPU8tMf6my4X13FriLsK7y7dkAc+UjbIAOtwJhmK
 a8iglDQwntOXP4UonJTHEN0xMRQkoGE41h2WooosTMXwg==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id d4d042f8; Tue, 05 Nov 2024
 16:36:15 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] bcachefs-tools: Fix TODO "Show bcachefs version"
Date: Tue,  5 Nov 2024 16:36:01 +0800
Message-ID: <20241105083601.246110-1-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix TODO "Show bcachefs version" in fusemount.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 c_src/cmd_fusemount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/c_src/cmd_fusemount.c b/c_src/cmd_fusemount.c
index babdb6fb..e5674b42 100644
--- a/c_src/cmd_fusemount.c
+++ b/c_src/cmd_fusemount.c
@@ -1222,9 +1222,9 @@ int cmd_fusemount(int argc, char *argv[])
 		goto out;
 	}
 	if (fuse_opts.show_version) {
-		/* TODO: Show bcachefs version. */
 		printf("FUSE library version %s\n", fuse_pkgversion());
 		fuse_lowlevel_version();
+		printf("bcachefs version: %s\n", VERSION_STRING);
 		ret = 0;
 		goto out;
 	}
-- 
2.47.0

