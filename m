Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DA91EFFAD
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575253; cv=none; b=tAo61Ku02yoATw7YLM2J4SJHo+Tr6+Y5y0iAh1UPqC14cDFT+ABJRbFjusBjyeJc6HmL0nY584UsT5gVx9FgRzDHbyPkuNF8EIuT8PhelgzVmOXYLQwbsDiImy2yPoOI3ghDb1xuTVhgVziN6/ivsgwniqZzPstbfbpEXz1cQEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575253; c=relaxed/simple;
	bh=kwyWaszkiOkLNX/V8jfHdClCPJeZE40YVR3rDuhk/qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuhq74z+6wyb+2X6sClR3KBR1Lyi81f0YL0MAxKgz2e6s2vWUs/06g4ZbEHBxib5mMBsgiL50l7r016J5O349/2u2MJ+wQnIP28AsVVWXMvIeRdVCSG5Cv/I8jAh2J8/2DzuRExl5DscsVlWaxvxEOul10zfOzibrNqlk8BVzGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=YbxTdgp/; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="YbxTdgp/"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 140F0240027
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574869; bh=kwyWaszkiOkLNX/V8jfHdClCPJeZE40YVR3rDuhk/qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=YbxTdgp/p4AGXgssXGDYyD3SNWpH1/9jHES0G3sOvsctrDt9gzA/eQpDRmNxNIXYt
	 +QLhSlmUtW7kYhFxmA8dbTPkLWB1C54AFczoqvuvUE2OXCYp+AMRl/V9eRu6vKOBH9
	 hdH+Bdkmm55WvupIGYRGFp6Cw7jBdMMA7JYVjTSAdcZzx0zPg4ZByMOBIhnb1LAvy2
	 3DpyAP/dFI7io23mXgjFrklEKafzA0aBptvf1o+0DM8AVGuNmbHKiMGsuX44p20uqz
	 7XLluso2XbxxdjicIiMIhx3AnMRiGAdo76hfBplH1lEhSekDHQkkO2l638pGCiPlk/
	 /aVJrpo/vjJiA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M65M9yz9rxS;
	Fri, 21 Mar 2025 17:34:26 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 10/10] chore(nix): rm unused attr build input
Date: Fri, 21 Mar 2025 16:34:04 +0000
Message-ID: <20250321163404.353334-11-tmuehlbacher@posteo.net>
In-Reply-To: <20250321163404.353334-1-tmuehlbacher@posteo.net>
References: <20250321163404.353334-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 flake.nix | 2 --
 1 file changed, 2 deletions(-)

diff --git a/flake.nix b/flake.nix
index abb49a24..1200a3b9 100644
--- a/flake.nix
+++ b/flake.nix
@@ -82,7 +82,6 @@
               stdenv,
 
               # run time
-              attr,
               keyutils,
               libaio,
               libsodium,
@@ -133,7 +132,6 @@
                 ];
 
                 buildInputs = [
-                  attr
                   keyutils
                   libaio
                   libsodium
-- 
2.48.1

