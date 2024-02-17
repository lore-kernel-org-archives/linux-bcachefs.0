Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99B61CF83
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Feb 2024 21:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708204983; cv=none; b=oQl8MBFNXC3/MTP+t9KTy3JhN3Gh2/m/oofCmBbRrCJtC/XlAn7qMw+Z4jE7ZQ99acC+qQpgLnCB7M4Km0MqAxsHvPMbXlbfIxf128/RnyJMQmLcIGTDsoJmrQofQPh6sLa1MqFcOb4vBnjRPvRNspopE9XmdHfbcOezTaldzA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708204983; c=relaxed/simple;
	bh=FbvqmEFEmBAFffymovyVwbr4F0sXpiSABQ/4nd6+EFM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SACVkYS9iIQ7qnMUvY7CC53W7rdPxj2Q6E8LYWZGBqCNugQdiMwMHJsXqw3qsUaV7ty86hfcYpYXBGRmGzba4QFtJF5qpyrhq6PfhCPzyNwjmNhbYA+9yhskJn8XoIvykakjUHQVyVgFcjKpY2pxRl4qjLjobGrSrzv+rBaUtT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjLQ7oGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjLQ7oGe"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B2CBC433C7;
	Sat, 17 Feb 2024 21:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708204983;
	bh=FbvqmEFEmBAFffymovyVwbr4F0sXpiSABQ/4nd6+EFM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pjLQ7oGeT6syYuG48K5/3NFJIOjb0yS99fLUXHa70IchNtc9zzXkbErMD0c7bLX31
	 cN0WqJPekjSVDjFoXW2qiy5bI/+QkdLclXB5TLqRS+hbV6rbabrywY21Ypddsw1553
	 mignXJCWa32+vTEvAp8sOVRH8V267imRuwXkcg2+ZFcch1KYQd4QZd9szhULdadZjB
	 oQCoenu1zqvMMtb1wSEvMohldAfH971EDTfUlDAyALkGIOKrrunVYGeX2Qs6zWsFS/
	 vgMOdmofFmu2cWghsRQsp4ZvMAQ5EhbUlQg5P+CA3HFQlLaC+JsPN1VARGgCkCELTw
	 66rNmhIPclX1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56392C04E24;
	Sat, 17 Feb 2024 21:23:03 +0000 (UTC)
Subject: Re: [GIT PULL] bcachefs fixes for 6.8-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <p732lizcbavjuvut7qfz6k7i5iozoha4dkn4t6vublkdnmhdff@5mdx7mwqwy7t>
References: <p732lizcbavjuvut7qfz6k7i5iozoha4dkn4t6vublkdnmhdff@5mdx7mwqwy7t>
X-PR-Tracked-List-Id: <linux-bcachefs.vger.kernel.org>
X-PR-Tracked-Message-Id: <p732lizcbavjuvut7qfz6k7i5iozoha4dkn4t6vublkdnmhdff@5mdx7mwqwy7t>
X-PR-Tracked-Remote: https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-2024-02-17
X-PR-Tracked-Commit-Id: 816054f40a5fdaaed05d9e7f603d2824eeee7e62
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f2667e0c32404a68496891b2d2015825de189b06
Message-Id: <170820498334.19833.3838305261993305979.pr-tracker-bot@kernel.org>
Date: Sat, 17 Feb 2024 21:23:03 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-bcachefs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 17 Feb 2024 12:43:45 -0500:

> https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-2024-02-17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f2667e0c32404a68496891b2d2015825de189b06

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
