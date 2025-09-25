Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9AD137930
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 00:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758759456; cv=none; b=fJKy2SyFlHiF3jGLpv3rKpALRRLbIGyJI5Wz9JY146wlaALd6b2Ar0Dnvpdxt6aan+mMQhESCI7WTkr3k+NdROLzCtia1mHj3TIpaPylmnRUzV+koJgBAOCN3ayY4FhWG/LVbLe/ubh40CmzDfk3mJlt5JzsznUao1DRxU7Ea7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758759456; c=relaxed/simple;
	bh=B0L+xyoPWlrz+0g8FpwZwu83gV+rWWcqkFxM6781Wt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsWW0MpTmhJ/NKgVFZsbEX1XlN92fzQpS3JXl0kr9uMfTuQFb+hMpIAHOM+00Lza6R5n9wA7YZUY6bYLXjQWoAOX5+4D6y4J3T5R+SEm/XAEtEmz5mVCYuPnwAHFO9+5RiEB6K1fvupR22nGdr7FWTA9dqB93L4o+dq0n3j3JvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=HH3ZZGZu; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="HH3ZZGZu"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 37193240027
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 02:17:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1758759452; bh=Ec+413uALhXqLESJG5IpJiR6I7Ot0cvE9ZjJX/7n8n4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=HH3ZZGZucpsLR4oQjmV/IRfrUFT532JA8zxcyU2j28Tiko9bx7FtvEJhPMEJwjcyd
	 sEk0S2FLljSpsWeVYyGz8y00zmr9Y3muRizT9dsA9DOn8cKC/FabflPYrxMjZTUFw+
	 wWx+JP9HxBjPJerdUrK/Rac0HhoW62EO462gxBe9FWgQWOyTuJDNH9zwchuMMPTmCW
	 gnpXLINN2FtTdCjQhOM3EpLVoCWKCu49kiCwjhFf5bzv6OpNguK6PF351K97hXGlzH
	 LEgqFjvLyNMoIGpPkxOMlf5GOZCTYnpCiLFUdnkTTljz7xs41SZvVJxEy6lD6aLH8u
	 xEq4rp0kvXzqg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cXDn75Fdbz6tm8;
	Thu, 25 Sep 2025 02:17:31 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 6/7] refactor(nix): use versionCheckHook
Date: Thu, 25 Sep 2025 00:17:32 +0000
Message-ID: <20250925001718.174749-7-tmuehlbacher@posteo.net>
In-Reply-To: <20250925001718.174749-1-tmuehlbacher@posteo.net>
References: <20250925001718.174749-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 crane-build.nix | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/crane-build.nix b/crane-build.nix
index 9b764ec9..4c05d7ec 100644
--- a/crane-build.nix
+++ b/crane-build.nix
@@ -5,6 +5,7 @@
   # build time
   pkg-config,
   rustPlatform,
+  versionCheckHook,
 
   # run time
   fuse3,
@@ -80,13 +81,8 @@ let
       '';
 
       doInstallCheck = true;
-      installCheckPhase = ''
-        runHook preInstallCheck
-
-        test "$($out/bin/bcachefs version)" = "${version}"
-
-        runHook postInstallCheck
-      '';
+      nativeInstallCheckInputs = [ versionCheckHook ];
+      versionCheckProgramArg = "version";
 
       meta = {
         description = "Userspace tools for bcachefs";
-- 
2.51.0

