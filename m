Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E6622CBFE
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575252; cv=none; b=iDi9/r4O/5jwXShDVu84+whE8PeLmyjviAysrC7eKF2UqR376uM/0XNDTWhjhms1i2g7wJZIUeeaB0qpo1x8DwEBF/rDYx2PkykjSyQyCqGLd/eGHame61mKtVJM0hImlSyd8B2r5HNchlkx/iGTngVYaHOfvlNPJ2inhL+NZ/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575252; c=relaxed/simple;
	bh=6iyeSAmE8Y7e/7UGT5r91+gfRzsqwrpZ+BYwqZuGKoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnzOud+k/9DDNrnUE8zFr+BMYmnLVTZ1c3UiADXNhZyS/WEMxbNANfigjzIt3EpoLRgoh16wP2HM1Ptbu8QgFen7Q7KFQy98Xgg1tfH7AtlMSGZ/y7yGyiyS+Gtm4Gc2Q1+GEqPN4/82F88fao8sDJCbMjY6HJvBB9R/7hIy80A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=rdTN3CiR; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="rdTN3CiR"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id C002C240027
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574863; bh=6iyeSAmE8Y7e/7UGT5r91+gfRzsqwrpZ+BYwqZuGKoU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=rdTN3CiR3rORIUPjo2Zd+Fln3jpt5BCrSgkUOnxD4MQwQmUwCaJAh48yPWgzZXbGx
	 OoFhE/VitZI81AZAJhWVv2kjNMANDbVLNDEso9MdBN9Zt0jqFTYWshydudYOT0ikNL
	 IePdVtXilFcm6tWkB0dLkYpfuKke8MYMJ4gk2+kJr1YizcH76XT6Yg//VZ9DkLBmvK
	 jTwmr8bSEtD2YIG52dDsJz+y9jRP+WkrCaIbBsxwl/04FfyfIaOuImL0MME4aTbYXU
	 LRPlt4+3M21cKcScvxZIx1iIo8Oba1rihqOxAbXnj+vlExD6YFlekxwOPxIMVU19Su
	 5z3iLIKYEgTpA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M30jGnz9rxM;
	Fri, 21 Mar 2025 17:34:23 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 02/10] fix(nix): rm input from crane that no longer exists
Date: Fri, 21 Mar 2025 16:33:56 +0000
Message-ID: <20250321163404.353334-3-tmuehlbacher@posteo.net>
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
 flake.nix | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/flake.nix b/flake.nix
index 4aa66a86..d8836b87 100644
--- a/flake.nix
+++ b/flake.nix
@@ -11,10 +11,7 @@
       inputs.nixpkgs.follows = "nixpkgs";
     };
 
-    crane = {
-      url = "github:ipetkov/crane";
-      inputs.nixpkgs.follows = "nixpkgs";
-    };
+    crane.url = "github:ipetkov/crane";
 
     fenix = {
       url = "github:nix-community/fenix";
-- 
2.48.1

