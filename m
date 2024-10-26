Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193DF18800D
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 12:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729947120; cv=none; b=FOXV780Xhleuvbq6uyyvXxQ+i+K1YZ/N33+4BrBjt2LcsONbNXYvSID1Oad5AWuO+hALo9V/YTpKBjH8aqD8alsGGJJ7/BSW+GNk/lH3juwUzdBA0DWDSF7ywKTRaJXxavUplRXVWN2SC1cmwxBRLp1RJeiL3dfuJD9eVHucrmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729947120; c=relaxed/simple;
	bh=Nym3X2hOK3wlAQCsWCKelDxbPAzi/ZihHX6cFG0kAnE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AVV6l7xsudpd4Q2Pd8+TTs0nOTZ4uA2lIvFJ99HCSvXvwWPk/eHL3euQDPCS4F+0Eo2Mwnz7sBvOQl7zAY4vUQQNzu5yKUhadwFkmgWqOxUQv8GMlxm7qby37AELsEQIjl932CuZkfhgo98o2dNkxzIl/sEeqd+wfdx3UFanyHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=LHmRfd6A; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="LHmRfd6A"
DKIM-Signature: a=rsa-sha256; bh=Nym3X2hOK3wlAQCsWCKelDxbPAzi/ZihHX6cFG0kAnE=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1729947094; v=1; x=1730379094;
 b=LHmRfd6AaAoqshMKxCcfPNpt88aMKnJHd4xtPGcixzqKhu3lKopj5ITfSh7xn9+SPauhPRu2
 ukkF/jM9Yi5IHjUjrEJH4SHDxdU2EP+6RgZ1UAE0nPfz5qluWvZ1hHP/1pRQ2sBxzaZhItKMaYe
 YdGK1ELNPlRBgQxxpHT2Cg2y824CDu5ajaJ1Ye+Ljo818XkDQHC8y1RpDWfmLNwHJ+6ghW8TLzp
 Wi2FLzvkHZJftgMLlOFOqYg8fsjqIpdXxw8pwucuas8Oj4+yfxv2t09TkFT++bn9lbucDTtl+CM
 h25ZuwiXU34qrQmBeD4ENILx4oC8r53eAv0KVZd0CJw2Q==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 319efe77; Sat, 26 Oct 2024
 20:51:34 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] bcachefs-tools: update VERSION in Makefile to 1.13.0
Date: Sat, 26 Oct 2024 20:51:16 +0800
Message-ID: <20241026125116.44555-1-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update VERSION in Makefile to 1.13.0.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c14db58d..4b9f2937 100644
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,4 @@
-VERSION=1.12.0
+VERSION=1.13.0

 PREFIX?=/usr/local
 LIBEXECDIR?=$(PREFIX)/libexec
--
2.47.0

