Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9875021C18F
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 22:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549389; cv=none; b=KjDYtSmFJqT0L/WZCgGO6UAxueH3z5tdY24pRUnyUgE3+B8flceciNMHenUJNMTxSEy1LSjx2JfbdPMgAqyxuC1EO9GkBqIFoj2YWlOB3jHiIil9lFLIrQswC7PARR5JQopXXCbvfyIAeMSMwqYOI7BugJ3CcH+a6xgAbz41Y/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549389; c=relaxed/simple;
	bh=4voS4b44JuMvLmpIHnhOsd3KvARYezqYJYD0wBpAmm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZwv5EIkpHkh9KsgGxz+i+bi5m/0/TqhwQH/ITtlchgAU9OUbd8oe56VXVCC/ZFNk48iwOmwBfASu4ygXry+Og4Fuxmq/f7yx2NkT20hVUpiCqe4dyoCyg6Pzfqjsq1EAn16JJCFwgmqob/KRQ/6dXBptrQkDY/uWMCBHVTzjxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=O00xWj/T; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="O00xWj/T"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 70534240101
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 23:49:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1736549385; bh=4voS4b44JuMvLmpIHnhOsd3KvARYezqYJYD0wBpAmm8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=O00xWj/TRqbQEbmkFuKsDkzhHEEfLd82FeTeLxlz5/3CqzB4GDNQlqJD2Ap1MSS2I
	 vIa+xgARo2pihKuOQBrgBJF02F5pGzVwPBwZC8c0VPeusY3SaWk79M1RoFp0enQ7xn
	 0c2eYPFnAjQ4jYG2yEf/X/SDpkoDAJ1wo4gQm1Dhitj10fOsK5AR7uXa176hJEc076
	 X4XZcskFqLPL7YUlo75VH9qYWFEHLGeXsua4/sd03HdpUkA4F/VCx7K0OqnYBGIGHl
	 x9YThEkMJ/+etq4uCdBgAH/Zw9HtSOZ6u201LrvIr+6tbrTha3nfSlOq+N53DyD+PX
	 SU7VaWtoaS9Bw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YVH0T02X0z6ty0;
	Fri, 10 Jan 2025 23:49:44 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@gmail.com,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 2/9] fix(nix): rm input from crane that no longer exists
Date: Fri, 10 Jan 2025 22:49:05 +0000
Message-ID: <20250110224912.445491-3-tmuehlbacher@posteo.net>
In-Reply-To: <20250110224912.445491-1-tmuehlbacher@posteo.net>
References: <20250110224912.445491-1-tmuehlbacher@posteo.net>
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
2.47.0

