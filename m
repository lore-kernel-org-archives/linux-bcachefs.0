Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EC5C8E0
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Apr 2025 12:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743856664; cv=none; b=fSrdCX+yUHydpoNG9uBedLm61HpGqjgnREgskIRFGLjr2vsNEo22nH8DLvnNVGUMbOUnuWmU1A+alnSypYHjajhdD1KsEYvkIXl+UAm2CvCTXuB2X1Xu+3GUh3WCxIUGN5HGSVQoQBl6i0k5VmffigUucAFYmx5rdDhwFpLmLEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743856664; c=relaxed/simple;
	bh=zt6n8TGYpCo1KsnGIxmN/UAmiDorPXMVQ57bRCpGZes=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fn5HIBFxkherAFJe9FeJE1NrK/XhqmapJupbHHwG7sfcPxeulN7Bv4noJNE33Mw6jDob4gKwgRnF04ZgJuQUr99IrKlVX1nGISBXcUUlcHxRrLrbp97T9BS4IFZKuq36vxF0d87zbCg/kmuLxk502gGJ/5duoAEtMiPlAeMpwV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=LpVrJFSn; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="LpVrJFSn"
DKIM-Signature: a=rsa-sha256; bh=zuzHXUThsT+TaTkKVIDTq/Xv6rdKsYhb/UdTCZi41cM=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1743856637; v=1; x=1744288637;
 b=LpVrJFSna3KQMZUeCPsZTjdSiuoNX/FIh4T45vrGIaVKpBYOHZWzV1UK5/Zz3Th8K4fzG5mQ
 tLcdZ2htXhLy98tfGa6z+YcnKW/pby+vQQYJqiHlY/gkKiCCwUMYKkLPcx4N8O2tayCP/erz7Jl
 LPeI81nlTPvb1OHZCxKTHgIjdD+DeBZsMwLG5/MBY+p9x6RyOkD+vY25SBZrGWDKVulSS/ZNhna
 pYPlA3jaHt3yV9Uza927YcD67w64SPFy6vBzMZRyW3EQiInbvDPmg/zjtjAqMUTdCUUlBTngC8l
 I0O7mybAotvMFSU0Q7tNe1guhVFH4wlNaOrYhRWf+3KCQ==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 7ecd8d82; Sat, 05 Apr 2025
 20:37:17 +0800
From: Integral <integral@archlinuxcn.org>
To: Kent Overstreet <kent.overstreet@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Hongbo Li <lihongbo22@huawei.com>,
	linux-bcachefs@vger.kernel.org,
	Integral <integral@archlinuxcn.org>
Subject: [PATCH resend] bcachefs-tools: add missing "fs top" command to manual
Date: Sat,  5 Apr 2025 20:36:17 +0800
Message-ID: <20250405123616.12182-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds the missing "fs top" command to manual.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 bcachefs.8 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/bcachefs.8 b/bcachefs.8
index 30cdd392..37cf0a8f 100644
--- a/bcachefs.8
+++ b/bcachefs.8
@@ -37,6 +37,8 @@ Check an existing filesystem for errors.
 .Bl -tag -width 18n -compact
 .It Ic fs usage
 Show disk usage
+.It Ic fs top
+Show runtime performance information
 .El
 .Ss Commands for managing devices within a running filesystem
 .Bl -tag -width 22n -compact
-- 
2.49.0

