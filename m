Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A488C28F1
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 05:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724564687; cv=none; b=JB0PseaNcEWz+qNv6doDj1jmLWMFcVSiBPoSkrzZQE9reV9FizFpXYLPfUYcn2n/Vf+jgR0mOPK50xywWcJycSGMStR/lfoAE2s9VjHgvlnEp3j4DZALj4KVqi6Cz1+AvFafuElxL7mIQEI5+rmw09/9It16sSIjWcmsmvujc1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724564687; c=relaxed/simple;
	bh=LK85LEnCs9RSp8zIbcMVl4BrVWLV9VhK6rv1VZq/sT8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sEJoOqvShwRY0awql+FaVGV+DJTWOKG20n+GsdnNCG2TZzf35gDMdD+2jt5KW8cWGwi4ze1Eu2nIzmixUmEwmdgBVwYDpYkh3pwCOntIFFtovLJF4TPD+kU9/7441EaqfkBcjniE2QNsgQc8QgdUVZ23YbTtzbj8ArBqNfeGXlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxET3xqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxET3xqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D2AC32782;
	Sun, 25 Aug 2024 05:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724564687;
	bh=LK85LEnCs9RSp8zIbcMVl4BrVWLV9VhK6rv1VZq/sT8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kxET3xqMYFc4DO3LYmUKaZgkNeq036TkGKOwa/ozyuHfHZ4mIsjh71CxS5W0bV/V1
	 aQyHr+AHMLjkC2jj/S7PtKfx6/8Lv0mJ9K9Ylus94cYHqZ8K1QJCX7yIJ/tiHjejxK
	 shyAZfx9suVgALi2zD40qHHT2bKrp4/BHeJYvbzMMK8WL0soHINSTi3kYl4QnZGMo5
	 MfnEiTKAMDneDzQay1hzTJTG8hcRTr6s83YGJHEKK09Y7WC9Nwmy89Jx4DqWzN+Zir
	 7zxyLrbu/MjATz6RKNJ80rrz3VLr6rPMoGOxGCQTfswZu6/RQKDd2X2HL8KMszoVPQ
	 OBvFDGpyKZ1uA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADFDD39EF65D;
	Sun, 25 Aug 2024 05:44:48 +0000 (UTC)
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5 v2
From: pr-tracker-bot@kernel.org
In-Reply-To: <awwxatomvqsjf3uao64qm3b4jq34tvdfpobe22wouydgzc534j@c6h7l4k7447c>
References: <awwxatomvqsjf3uao64qm3b4jq34tvdfpobe22wouydgzc534j@c6h7l4k7447c>
X-PR-Tracked-List-Id: <linux-bcachefs.vger.kernel.org>
X-PR-Tracked-Message-Id: <awwxatomvqsjf3uao64qm3b4jq34tvdfpobe22wouydgzc534j@c6h7l4k7447c>
X-PR-Tracked-Remote: git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-08-24
X-PR-Tracked-Commit-Id: 49aa7830396bce33b00fa7ee734c35de36521138
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 72bea05cb1ad486b1a850f584cc93b651579ad2f
Message-Id: <172456468741.3337397.1567020839517567383.pr-tracker-bot@kernel.org>
Date: Sun, 25 Aug 2024 05:44:47 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-bcachefs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 24 Aug 2024 12:19:59 -0400:

> git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-08-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/72bea05cb1ad486b1a850f584cc93b651579ad2f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
