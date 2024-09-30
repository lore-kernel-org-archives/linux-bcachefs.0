Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D8A47F53;
	Mon, 30 Sep 2024 20:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727695; cv=none; b=YjlRtp5nCtuAy4jVMV00O/0C6HOlf9eF1NObS2OcGws1MLqXdT0WNDWfCXTtoJ46hbwp1NcWZuDLE2UrNdv3GXmQHQ4dXxR00cTPzu9YetD1uCNUZqmsIptbd5VrAY4fKon2WAPbNBSy692yPtGEXkii752zr/Ipuzw0iFKjt8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727695; c=relaxed/simple;
	bh=M3d7GRd5Mrju/ZeF8INiV25mUxMIVvG1eA0gS06GfYk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ON9EVGr+9YJRVFiCfzfGXWZEM+/v9qcaf4dFrpzURIfxkTgAgmvzo1OPCehUx+Ug1J8gx59gzDortEIl4CRXMD0ZpoO35cXVs5iMuGZDwruNAj1pENPDyVmFAUSagt26MURSbbn7q1WV4fNLncBhssJza+LxohuuzkLknERcF1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OeWou5Nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OeWou5Nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7019EC4CEC7;
	Mon, 30 Sep 2024 20:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727727694;
	bh=M3d7GRd5Mrju/ZeF8INiV25mUxMIVvG1eA0gS06GfYk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OeWou5NzGEOuxhw42B9S0HurWPk6sH+DgDcOZsJQ1CWVEQTn8LtocCIZQiRuEGC/2
	 6Tws7xp7yTBSIFblHy6KUi2CQ7f/DnR6+bmWXgoIOitZ4iNx3oZrgAKtr4sAxpDBk+
	 p95tFUUn+ocMi/FujM400o5xgq6H1ZFOd1oTNjA2j1KTdtJZPrlLZNvr86aR50ltxq
	 OjDxp8foL6yixE++mcJQhbRXCcpUm4DBCaaRFlaFv5RevKQ3/ufW4y7bVecHxpPnAb
	 JG1Zs8QQj1pn2hsPJR4MUTTPyZmZRs+xAeYUyTp+dD80Eq+kq1IoP8OySZbKas+7xt
	 CHCRi5K1xb1Cw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE893804CB9;
	Mon, 30 Sep 2024 20:21:38 +0000 (UTC)
Subject: Re: [GIT PULL] bcachefs big endian fixup
From: pr-tracker-bot@kernel.org
In-Reply-To: <afdmrsibtwc655t55tnlysfbetlb57nrdmk3k2ke6o6aebssqh@3g3mhqsvaswx>
References: <afdmrsibtwc655t55tnlysfbetlb57nrdmk3k2ke6o6aebssqh@3g3mhqsvaswx>
X-PR-Tracked-List-Id: <linux-bcachefs.vger.kernel.org>
X-PR-Tracked-Message-Id: <afdmrsibtwc655t55tnlysfbetlb57nrdmk3k2ke6o6aebssqh@3g3mhqsvaswx>
X-PR-Tracked-Remote: git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-09-30
X-PR-Tracked-Commit-Id: 2007d28ec0095c6db0a24fd8bb8fe280c65446cd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a5f24c795513ff098dc8e350e5733aec8796fbf8
Message-Id: <172772769736.3918229.15606464507414950885.pr-tracker-bot@kernel.org>
Date: Mon, 30 Sep 2024 20:21:37 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 30 Sep 2024 00:59:51 -0400:

> git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-09-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a5f24c795513ff098dc8e350e5733aec8796fbf8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
