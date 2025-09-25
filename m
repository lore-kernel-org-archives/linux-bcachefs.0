Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B5942A96
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 00:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758759454; cv=none; b=covD52YUYPytwwFZRzvrqj5hvWUA/8pkGlyhfsiPEY1Quxc9gd0q2Pz20BmPCgLt4WWkRZarFN8ylNqgeMSDynQuZDyRoS3DCNmXrzXmGDwn1YALJLeNkceRiTQUs0nF+GxTq7Nj6+InFG0Yr8NmmToL5zl+/nny6WX6fnb5o9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758759454; c=relaxed/simple;
	bh=R8lsVhZ5snAQ89+dpHenr07JDC0CX+Ukf/jkwIJmRlo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q06PUumHSrT1siTayaVXIbeTC3NQT36v9hRyh2hoNLaQHjjj1GDeS9GRLL+wYUCkc0m4WVIFqT5Pp4m5fvtYdvdHqQjOP4sO5boQYbBzLO03Cvw0RHLCXazyBDDRt/wP9e532ttHY7/TmY20jdOmKgO1/x72gSRfip7rTBXF8qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=R+WuDyWv; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="R+WuDyWv"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id E9F3D240101
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 02:17:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1758759447; bh=Yaw4S2Mbt2TsPhsmIQFD/CGgQJ0vb4N7Mf1AccR7xyg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=R+WuDyWvPeHBcZO0xygQp/DNlqmI3hQ3NNo/IbnNHraW/A+VyBjf3DkWNTmfzvGZx
	 Yf5CdREVaXs/PPvxnVTT0C761JibmRokYAorZ93e5kHSWwweJ+uU1wTWTuQJiwd3ei
	 xB9TIBGxKML7lQblQsY1GdYIn9G2v57IaGv2MqL24yVB/G3sp57DEv2a8W4Th5tJT5
	 BpZhXm/Z+h6IrvKDHvRtq90PW+aPEGxuQxuES6M7BkG7we2Rct82rySrVuslMscQoU
	 yXQvPFc51bz8I8q8ZfmbIXtSmWIfh7NN0N59wW9qU/BlvlnZkY0SW3HHQVKqgTxhU8
	 5JfYtLc05lkbQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cXDn319Jqz6twg;
	Thu, 25 Sep 2025 02:17:27 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 0/7] bcachefs-tools: some nix changes
Date: Thu, 25 Sep 2025 00:17:27 +0000
Message-ID: <20250925001718.174749-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Some refactoring again, moving stuff from flake.nix into crane-build.nix
for better structure and cleaner separation of `callPackage` module.

Finally, as a preparation for potentially using mkosi for clean package
build environments for different distros, Debian packages hopefully as a
first step. I am hoping to add some mkosi definitions later for running
debuild or dpkg-buildpackage in a clean environment. Maybe we can also
test the package a little bit using mkosi.

Thomas Mühlbacher (7):
  refactor(nix): rm now unused imports
  flake.lock: Update
  test(nix): add aarch64 cross build to checks
  refactor(nix): rm no longer needed build decls
  refactor(nix): move out build into separate file
  refactor(nix): use versionCheckHook
  feat(nix): add mkosi to devshell

 crane-build.nix | 135 ++++++++++++++++++++++++++++
 flake.lock      |  24 ++---
 flake.nix       | 232 ++++++++++++------------------------------------
 3 files changed, 202 insertions(+), 189 deletions(-)
 create mode 100644 crane-build.nix

-- 
2.51.0

