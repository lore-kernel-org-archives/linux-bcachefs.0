Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34C921C9EE
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 22:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549390; cv=none; b=BMup9+csV3corfZhP++iEOe9OpsnWa4u786TNkK2vO/uCZA5s9g9EI7qTZJ1xUo+4xJX0hUr4xWw7+zXMIUANC5lQyRDVQPjbie9pHR4FkOmUROr54+rC36xx+ILGJmsYIOVchgcTBc31VWTli6mCGm/1NU/ox3e2U6+9Ehrb/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549390; c=relaxed/simple;
	bh=5gD0Luvmd8jxGRIcQyKcqvBPldrcFw7sLZLyPH4Qt08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYyQ9z2Qk/tf1pk4qoL/Jyy4QiZ8nWPvng8uy2w+ddCcGXlEYA1PBZVNjCqHjSKqNI8sGSAGMNw4xMQZt6ipjX8ooHsg0stjKxXKdGBax0Xmbqm49KeANIzt922gHhzUO8FjtyLEbQAJW4eNYe1y6p5kE1F0AARhPopg17UlK58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=XTDJ0uT7; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="XTDJ0uT7"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id C1F1F240027
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 23:49:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1736549385; bh=5gD0Luvmd8jxGRIcQyKcqvBPldrcFw7sLZLyPH4Qt08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=XTDJ0uT7GWYBHL9YNUApJnaFBZR908joRBVyOLbIRqPivf69u0ejviICd69u87KRm
	 Tbd5GUUfoWDSZ0mDQF6C5VTuyCWhBPML9D1Q2gqo8RT/br+JQshJIUqFojGW6Qmuwt
	 xmQe/wk0h/xFAZTBKB/MRFYrOuJnnY95fV/sDWEvfumpjeXk+FmPo02jJimYr3KgAT
	 ZGNOeeut+5+rwxVPl2wSNgCURRjG26I3LlgXwpwvXPTkvVaEsjpSnziGU1mQbyHw5M
	 yAGyEtXY90QL40lSH5Z6qxn17tTQkUnFvlD9kQS686e42u1o7RdAKq6zC5fX1eyLfH
	 mM0GObtRHg+4w==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YVH0T2g5qz6tvd;
	Fri, 10 Jan 2025 23:49:45 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@gmail.com,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 3/9] feat(nix): open up support to more architectures
Date: Fri, 10 Jan 2025 22:49:06 +0000
Message-ID: <20250110224912.445491-4-tmuehlbacher@posteo.net>
In-Reply-To: <20250110224912.445491-1-tmuehlbacher@posteo.net>
References: <20250110224912.445491-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This means that the flake can now be built for the following
architectures:

- aarch64-linux
- armv6l-linux
- armv7l-linux
- i686-linux
- powerpc64le-linux
- riscv64-linux
- x86_64-linux

It doesn't mean that it's necessarily going to work perfectly on all of
these architecture and binary cache support is not available for a lot
of them either. But at least it let's you build for them if you want to.
---
 flake.nix | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/flake.nix b/flake.nix
index d8836b87..9e09a621 100644
--- a/flake.nix
+++ b/flake.nix
@@ -34,16 +34,13 @@
       crane,
       ...
     }:
+    let
+      systems = nixpkgs.lib.filter (s: nixpkgs.lib.hasSuffix "-linux" s) nixpkgs.lib.systems.flakeExposed;
+    in
     flake-parts.lib.mkFlake { inherit inputs; } {
       imports = [ inputs.treefmt-nix.flakeModule ];
 
-      # can be extended, but these have proper binary cache support in nixpkgs
-      # as of writing.
-      systems = [
-        "aarch64-linux"
-        "x86_64-linux"
-        "i686-linux"
-      ];
+      inherit systems;
 
       perSystem =
         {
-- 
2.47.0

