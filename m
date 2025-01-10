Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF6321C174
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 22:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549389; cv=none; b=ukPPT3kjCu13Fb7xTqvoNVJJdBPgZs1qeCTtKChM5x7eJEZEDBgcZ7VUIszpwFoupulx7m2Z4i10Ik654Rbsv4GBKJf0mSlrJ/KPej1Cp2SRdlLYWblD5BXupPtIt8c/oc9Y1P7nxpjj2NRYlsukEh7bVc4DxMAdj/GburtEWmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549389; c=relaxed/simple;
	bh=tAjlvMkMUkApfQwxTarhKAW+NLYFyYFPwtUrN7j/bwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y3DgytLVTMgURPmGeEAbgT4x9/0pIuSB0xeSaohGLAqpzdSgCiYC/EKXQnbxPgLJ5U3kknbhUHTqsni522hCvkvaRZCzpHSqE0po81alVWDSE0ylL4LCx5bkPk7aRkZLb6OfZN0Cgz9PBi2jrLa0fdOnPrvIhtZ2JYFbS+oMuV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=SdPU7xVU; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="SdPU7xVU"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 02E99240027
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 23:49:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1736549385; bh=tAjlvMkMUkApfQwxTarhKAW+NLYFyYFPwtUrN7j/bwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=SdPU7xVUe3Rtos2SdqX2l5viHT7+BfdlUZnZWfF7OR4QSdQvMiO4DlxGERuYl+NNl
	 xfx8LTEmBNiYN3gXoicdVhhjzYndmANbszbeOGWSgiiPHEUKgBNjd9aANBan6pWsTv
	 QOinSoNW6nArVRGiWTzyisf36dqZjM5x4q8FR+dfv+f0ir0H4CsSaY5I2MeEeq+9FB
	 mADcE8JQfH5GBbsXQ5kYkwz1tz7EcfwE9HJICkdDZ9MnaaOqoil4+j32RVi7S+ELMH
	 8Afyp5fqmU+wDfApWIEZFPOsxZ1SeadwWjdno6TTyk5v36a3pLq0MqjDcGFtcy+baH
	 YQTQn2rn2Y/9g==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YVH0S2tYBz6tvd;
	Fri, 10 Jan 2025 23:49:44 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@gmail.com,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 0/9] bcachefs-tools: Nix updates and maintenance
Date: Fri, 10 Jan 2025 22:49:03 +0000
Message-ID: <20250110224912.445491-1-tmuehlbacher@posteo.net>
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
  nix flakes.

- MSRV and 32-bit builds for `nix flake check`.

- Update to using Rust 1.84 for nix builds using rust-overlay.

- Clippy fix by using `c""` literals now.

Another update to flake.lock should be done once util-linux 2.40 lands
in nixpkgs. That should happen soonish, it's already in staging afaict.

Thomas Mühlbacher (9):
  flake.lock: Update
  fix(nix): rm input from crane that no longer exists
  feat(nix): open up support to more architectures
  feat(nix): replace fenix with rust-overlay
  fix(key): replace c_str macro with `c""` literal
  fix(makefile): locate built bin with CARGO_BUILD_TARGET set
  feat(nix): enable cross compilation
  feat(nix): add an MSRV build to CI
  feat(nix): add a CI check that builds on 32-bit

 Cargo.toml          |   2 +-
 Makefile            |   9 +-
 flake.lock          |  89 +++++--------
 flake.nix           | 309 +++++++++++++++++++++++++++++---------------
 src/commands/mod.rs |  25 ----
 src/key.rs          |  15 ++-
 6 files changed, 258 insertions(+), 191 deletions(-)

-- 
2.47.0
