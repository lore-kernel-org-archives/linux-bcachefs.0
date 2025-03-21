Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8914431
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574871; cv=none; b=o6I1W1M7gOJ5UcEiMCdp7mq69My4qXLEZfsg37bbLPi0QCuUOb7935/rYi2ZYQr1fMdfhoTVNci3li4By0GLCoWkHKjijROXHGGslXcrpOYGLgrWikWBn/1RbJHu6FbNEWM6FSqS0hlHvdvC90QMyuNdf1lkRyQvnuYR4utEIkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574871; c=relaxed/simple;
	bh=zogkwvF8gWguaQWaCLd0EsRt+ybSz/r1zWmICMY7mLM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YMrBlndJw64Z+ZZZIV3C9Bgt5HUFLxyjBqzBN4EPvQFNeTygzXJDFxQ5yABu+oVFspvREtlznehIo3bwQIdGv1UH8j/wo6CGH5nKU2NHjB6edizYH6hZAamrk8VAbE2l8Ap3ALP29nfucfJ8T7yrK3tH164LwJLhJaihMCW77G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=STNcx0u9; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="STNcx0u9"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 7A4E4240103
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574862; bh=zogkwvF8gWguaQWaCLd0EsRt+ybSz/r1zWmICMY7mLM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=STNcx0u9Hf59G57UzWBKc07OH3FhUT7rznOWsVN4nsGGWo9waj2VEu0YwkX5F1PZx
	 x11it/l5mm9sTVimm42QoIll9Hx5yB4FpBls9QnBxlsr1c03zDZsuXPRYzmACg4Is5
	 1mYl1naTwZTOg5kyuWrYw6JpJ9Yt345aXg4X+s/CsqM1c1mk3FuRoyc4k1F/9sTAVn
	 /IX8Wrt8TYrCq4PrnSI4HXjDMLkjnZ9lT+Fhad5GWai7c0kvOfIH7UOQwRXXBsbF4v
	 akdeIx5A55kKo2uMDdOIqanq6F8uHNJuxKz+hwwxM3cM2CjHCrRFVCveTUnLu23MXI
	 WLpCw0Ojyj7Pw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M16YNZz9rxF;
	Fri, 21 Mar 2025 17:34:21 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 00/10] Nix updates and maintenance
Date: Fri, 21 Mar 2025 16:33:54 +0000
Message-ID: <20250321163404.353334-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Kent,

I have some minor patches for bcachefs-tools, mostly to the nix build
system.

- Cross compilation for all Linux architectures that are available for
  nix flakes. (check with `nix flake show`.)

- MSRV and 32-bit builds for `nix flake check`.

- Update to using Rust 1.84 for nix builds using rust-overlay.

- Clippy fix by using `c""` literals now.

The flake lock update also brings util-linux 2.40 so that limitation should be
lifted.

Thomas Mühlbacher (10):
  flake.lock: Update
  fix(nix): rm input from crane that no longer exists
  feat(nix): open up support to more architectures
  feat(nix): replace fenix with rust-overlay
  fix(key): replace c_str macro with `c""` literal
  fix(makefile): locate built bin with CARGO_BUILD_TARGET set
  feat(nix): enable cross compilation
  feat(nix): add an MSRV build to CI
  feat(nix): add a CI check that builds on 32-bit
  chore(nix): rm unused attr build input

 Cargo.toml          |   2 +-
 Makefile            |   9 +-
 flake.lock          |  96 ++++++--------
 flake.nix           | 298 +++++++++++++++++++++++++++++---------------
 src/commands/mod.rs |  25 ----
 src/key.rs          |  15 +--
 6 files changed, 252 insertions(+), 193 deletions(-)

-- 
2.48.1
