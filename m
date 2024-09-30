Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3A81362
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Sep 2024 04:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727672402; cv=none; b=iPSzq5TbXnMKStUUTgr3NPrGbc7WRpDnR6lsLB0VuvB8muqMI0PwCAX2e5JjIuh4kL0caXR1pSP6HvtohuBO0M41MhJPfV7wuN8qoc65igD9JmEoqbaie8YldwLKJ1jyzzMAstV/N+06JO3iJf6b8pK5wmV3boR/a4Poz7AzeHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727672402; c=relaxed/simple;
	bh=Xg+5OUHzvGJDGnwi7oSEVY3RnFR9MPU+iYKPO4MFJDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=K9F+gevgSDoCVDtfJPCrZu5MXcLVa1LZVWXBEnlqakFT9yMgQ7WgE+y16MOFDXYJUlgnBMwt9ASgueMFo2p9p3LiNWxC3vYOAot4B9mGbRO87GU8MW3qxFE9XKUzrHZoVVIWD2KR1M6HmOXGS2Vup4sNi1OC/x0+e93V7UzAiLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UEIXulHc; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UEIXulHc"
Date: Mon, 30 Sep 2024 00:59:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727672396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=3BLemO7sS3aMVH4+gPXT9eyXDJ6Xvmp5pzb1asfWkyU=;
	b=UEIXulHcVTXIG2iS/5kLRSzxDLQh+HMO1u6bMDpiCGKBAzSw/A3fshaihhoN5+PMDbM+u+
	yIpPk9zW+kq6UCoUoOpoY+duVkYoE5KQb4QqgAG/Ase5/8lEHZRzF3dPJFF5kOk4Kk6Gm1
	u9NZFoHqZ2Ysp6tMDxl65E2oCi4NoAU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs big endian fixup
Message-ID: <afdmrsibtwc655t55tnlysfbetlb57nrdmk3k2ke6o6aebssqh@3g3mhqsvaswx>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

This fixes the build on big endian

The following changes since commit 9852d85ec9d492ebef56dc5f229416c925758edc:

  Linux 6.12-rc1 (2024-09-29 15:06:19 -0700)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-09-30

for you to fetch changes up to 2007d28ec0095c6db0a24fd8bb8fe280c65446cd:

  bcachefs: rename version -> bversion for big endian builds (2024-09-29 23:55:52 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.12-rc2

Fix build on big endian.

----------------------------------------------------------------
Guenter Roeck (1):
      bcachefs: rename version -> bversion for big endian builds

 fs/bcachefs/bcachefs_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
