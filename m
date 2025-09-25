Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17519136E3F
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 00:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758759454; cv=none; b=dEGcnfDW0NOB/YYwzIh1chpHDJ6xY1k222VOTl0izah52Vqn7PHb8jbhilZmQntu2c68odVbSutA5ou2ROkkLYf0aLuuO44BqRoaDo+mGv4q92l2wiIjNCNXpOVPbTcqw3hseu+60DlAST/rRVN3r6HieIM1jQaLZZk0Qy/IGPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758759454; c=relaxed/simple;
	bh=aqEqOfRiFsd3hrI4DkEPb3+9J5UqqZ/+dd32GSHeNFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ag9fGPYbv+E+AGb6HkfU0laJj9xXvr0tkyKy9BXT50bBN+tI2CdUnB5uhx5WZWngf4S8U+AYbsrWjxiEmJWT3kd7/yBUsVGpTdyoWcKEZHo+q0OpCbQJKeOLuqeKQ90P/0f1esilHj3Vr5wtLf020d2tfxJu11OAA/7Q7XS2AFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=pjm7xFj0; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="pjm7xFj0"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 31F2D240027
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 02:17:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1758759450; bh=pu/JyLmunyJvpY0Ah9vTuDY9XDQT79sCPAIf/CvrBt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=pjm7xFj0V/qNZdjXh0yXVZjLSPJnUBKZfhtIsttGsy0BrBVSP3Oa7y9GPheGi5flv
	 IdhE5RV6+VOhFTM6JYfg7sXkCBEwUH6RMFums3rrLQUsKUJY6MAt7l8h3x+AIfQ7jt
	 C7r3TcmDp36v2B7eO5Dim1RhiiNiMCZpxIKJEIuqV9dn5vjuyMoBDZayvqVHWZTBsE
	 N/DBejS+zxfQpIgUgo138f4wMI1M7ensehowEtMyICPqQidXsqqb5UAHLB02W06ExG
	 glLFF9+sIzmbLl/vrS/WEf4S2Kzk2z0QzX6B2EG9vwNFI+hMVQHRj15wl89wXyRQeC
	 xn+TYiq0AcPyw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cXDn53lg2z6tvh;
	Thu, 25 Sep 2025 02:17:29 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 3/7] test(nix): add aarch64 cross build to checks
Date: Thu, 25 Sep 2025 00:17:29 +0000
Message-ID: <20250925001718.174749-4-tmuehlbacher@posteo.net>
In-Reply-To: <20250925001718.174749-1-tmuehlbacher@posteo.net>
References: <20250925001718.174749-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just to have a real cross build in checks by default (unless you are
natively on aarch64).
---
 flake.nix | 1 +
 1 file changed, 1 insertion(+)

diff --git a/flake.nix b/flake.nix
index d0811bf5..0d7ae0be 100644
--- a/flake.nix
+++ b/flake.nix
@@ -234,6 +234,7 @@
           checks = {
             inherit (config.packages)
               bcachefs-tools
+              bcachefs-tools-aarch64-linux
               bcachefs-tools-fuse
               bcachefs-tools-fuse-i686-linux
               ;
-- 
2.51.0

