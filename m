Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6A022331C
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743431728; cv=none; b=MNDc91QAjLg6m2TB1CnNPVqvr1/eBTqm1kk7SrrDyBCAziRBuChA/7HznFQkre2tckLwpxQHJoRAV8SLG+LAFSb6PnM/Aq07rvMPifh3Vcxdk70YocofvNJ/i/Txtorcmiq3Mb4UyBn6HCNTZ8wA9Q6uFPakEP4V5pgX0FApT08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743431728; c=relaxed/simple;
	bh=iyPwf37HA3xP55NtATTbP7/ooXzlFJyHW+8Q7igetdA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ibnlRcrkY/1UL6Io5IogO0r1UW/CzDSJUCqk0XW6Xdce1Ai5OQuNUq1kPmWFpZNzCVHgYbK1udBCx3QhpfpUIXyp9c+UUGXEEF51lQjwUfqGPWIkVBQWWEjw0O1YCsMqrrtcSztG+TKVaLZ+nk1NsRhF+tUsPF6dOt7spI1uO3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=Tx8eNx71; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="Tx8eNx71"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 9FF6D240101
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 16:35:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1743431717; bh=iyPwf37HA3xP55NtATTbP7/ooXzlFJyHW+8Q7igetdA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=Tx8eNx71GZ8CuntXUCfl4RinvBscsbL1JdoRgVVF6VlAwP5ATzYFvVeGezLz9OCy1
	 40mc7jfO+VBoQb+1qQPaFdWU3C3BkRLz4a0tQ+e9ohgwS6tOXhRuYMPXUURlhw1qCt
	 P2d8Zw9bGUxhrn7pPxo/ExhMBgDHrRvpkQHGXYa4VVR0JXk3ukfkQShwrKnRFXxapy
	 upmSJcT0Zb74FILssE4iRHfQ8rb9dYH9i8+v2dRthMmprDbxMnPOFPbVKToLvAmc47
	 b3WadfW9aNM0jscKR9lDrV2xO/lF6wfOl5sMlwQ1QoXQ76O+qsOh1KTQSG248vlfS5
	 cvD3t1mi5KZZQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZRDF0759Kz9rxD;
	Mon, 31 Mar 2025 16:35:16 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 0/5] bcachefs-tools: scaffolding and clippy fixes
Date: Mon, 31 Mar 2025 14:35:04 +0000
Message-ID: <20250331143509.157528-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Mostly fixes for bch_bindgen now actually being checked by clippy.

Also a fix for making github CI a bit easier to spot issues for users
who want to use github for submitting contributions.

Thomas Mühlbacher (5):
  chore(nix): structure github CI nix flake checks
  fix: use cargo workspace
  refactor: `cargo clippy --fix && cargo fmt`
  refactor: `cargo clippy --fix -- -W clippy::pedantic && cargo fmt`
  refactor: make bch_bindgen pass clippy

 .github/workflows/nix-flake.yml |  41 ++++---
 Cargo.toml                      |   4 +
 bch_bindgen/src/bcachefs.rs     |  17 ++-
 bch_bindgen/src/bkey.rs         | 182 +++++++++++++++++++++++++-------
 bch_bindgen/src/btree.rs        |  56 +++++-----
 bch_bindgen/src/errcode.rs      |   2 +-
 bch_bindgen/src/fs.rs           |   2 +-
 bch_bindgen/src/lib.rs          |  29 +++--
 bch_bindgen/src/sb_io.rs        |   2 +-
 flake.lock                      |  21 ++++
 flake.nix                       |  89 ++++++++++------
 src/commands/mount.rs           |  29 +++--
 src/key.rs                      |   9 +-
 src/wrappers/handle.rs          |   4 +-
 14 files changed, 336 insertions(+), 151 deletions(-)

-- 
2.48.1

