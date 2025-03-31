Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC1D1DC9B8
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 23:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743464883; cv=none; b=ozAOdE2UytLul84I2zgnubRMD99DfgTwkK7CGX/G/1dalwSe5JegY1rKInrtCVX147F69kC0a3NCxvNwTtoz0Lu2Wha49DY1iRXMD0ul2Z+Bw58erEqPckBQl5XGmbhBISTeKfReGJeeQ720ab4fnIlkW7Iol7VrwnJSryFeH0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743464883; c=relaxed/simple;
	bh=UIALoqVNy9jyOJh4zmq39it75O+oM6VqhdRsyH0adMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rSGy90UuW3pwTa+MmKbfUd7xh9KJgKNS93DDsw8cDnCI2KPHNSxkFJbl4HbXEW5008RQTHdfUX4hFP+exI4O0BxT1WeAAi2SbD0Ddz8Ubh0Mpcivfkpk7SEadcq5vnwoTe+lSKxTv56R6OKz8aevcdt0A6fS4+SKHIB1AxlivHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=sNgB1cn8; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="sNgB1cn8"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 8BCC6240027
	for <linux-bcachefs@vger.kernel.org>; Tue,  1 Apr 2025 01:47:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1743464878; bh=UIALoqVNy9jyOJh4zmq39it75O+oM6VqhdRsyH0adMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=sNgB1cn8mdFGu5xf76FeYrJZILG9MVEBXqDBob/yCH7YdORWMn/8CIv0PUsWnhu+i
	 Z2GALIsThAASeo1ccZwYMwAhtWkFUUi5NiY+Lqvo4rb8SvqnBFF+4JQZsLibY04+nh
	 7O2NXFKwAqaxVhs60g/Ke/iF3wYhM6XLiP95khrU/P7BM2Rh4OoSlWDLT0Ls2gG/kT
	 fT32Ti7M1zRObulVZLQNR9Y4IPCPQIP9LqPzuhGcecO9Io/v7AUhlGR8ta3S12Vaop
	 BFnG9AiMQ9Sj1j5co6FcMHobf5ks8HmaZQakveMS4nSTRMVqwr277nS020D/p3w7+M
	 bpQGd7SVBYSEQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZRSVk0GjMz6tvd;
	Tue,  1 Apr 2025 01:47:57 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 0/2] bcachefs-tools: get most of CI to pass again
Date: Mon, 31 Mar 2025 23:47:42 +0000
Message-ID: <20250331234744.428142-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Ok, so I have now tried to minimize the patch from the last patch set to
at least have most of the CI (except for i686 builds) pass.

I threw out the pedantic automatic clippy fixes, so the `Bpos`
instantiation change from before is gone. I am pretty sure that wouldn't
have changed anything about the binary layout of that structure, though.

I know you don't like formatting commits and I wish they wouldn't pick
up anything except for what I changed. However, since `clippy --fix`
doesn't format itself, I previously had that in there as part of a
commit that only includes tool-generated changes.

I also now just avoid the ugly transmute annotations and just suppress
the lint instead for that function. This also requires changing the MSRV
CI check, because that lint did not yet exist for the MSRV Rust version.

Thomas Mühlbacher (2):
  fix(nix): allow msrv test to have warnings
  refactor: make bch_bindgen pass clippy

 bch_bindgen/src/bcachefs.rs |  5 +++++
 bch_bindgen/src/bkey.rs     |  3 ++-
 bch_bindgen/src/btree.rs    | 25 +++++++++++++------------
 bch_bindgen/src/fs.rs       |  2 +-
 bch_bindgen/src/lib.rs      | 19 ++++++-------------
 flake.nix                   |  2 +-
 6 files changed, 28 insertions(+), 28 deletions(-)

-- 
2.48.1

