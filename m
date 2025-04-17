Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C05E2222D0;
	Thu, 17 Apr 2025 23:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744931957; cv=none; b=IBdxVVpaPV6oe/pyJ98HCWLMMEwjCrhXAgciMNpXc2/qj62PtUuXEtjwO7EvNKwBMru96AcDyxYYRgXkXwoyuru9SDtBRaRuikrok7HZKg2qwQHna06PxaKKMDYQ3/yu/7E35lWRdmfJmq8WLijjlUl5YCnFAqUSH3coIfeVKfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744931957; c=relaxed/simple;
	bh=F8SpLWYC0sdEDqsWWtik/NGz9kVnj5pC0Qpj5HimsT0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jUHXpjE+v6XE0R8tOsZ0ddX5BWTRRtq9I/O3J5qFatGvQSbRHgWHqW7+Cq7PCleJzYN7VxnRgQP/aTGpLP1lwe80xQwH4jyfg7luxKc+1LSCp0Awne/zTmdiQLP0EuaHKEay1Pq194pVoJScnZKaxCQVogFV4wPXByMFGEmcH7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bLDsOgv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLDsOgv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8014C4CEE4;
	Thu, 17 Apr 2025 23:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744931956;
	bh=F8SpLWYC0sdEDqsWWtik/NGz9kVnj5pC0Qpj5HimsT0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bLDsOgv5T8/OPLNZHVTFML/KlO6hkz6rk5XWdX4E91YGi8M7t5YM5FqTc/u4FUxkZ
	 1hAP0r5N9zqUwm2PwEtTX4yi0bsQvZQl7oiwUR/JpysQ+qK8o2O8MT2qmin/8W+3jw
	 lad9J0v0cRcaC349BMpudD/Fe6KqcVI/PZWxotb8mbx+sB/eaJfHWQI5L3+vTh0+Xr
	 R6sn/iWJrHqOEHA+Hl2MWO4uxh3e+QuMVrXp/WcZpOxHInpFfwVfWoNpg+uLj7qu8d
	 A7BPTqL/wd4Z4xlSF70jBvZUrTuLp7d0XEWKKrptP87w0nB842wYeGQxj9BjRC8RP/
	 clvdC6OYQbwIQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33B78380AAEB;
	Thu, 17 Apr 2025 23:19:56 +0000 (UTC)
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <jnnywf5k3qydxwrh6ur6ap6wjr7fpb32af3frnqsfvntwrvuba@wpr4uofgwpu5>
References: <jnnywf5k3qydxwrh6ur6ap6wjr7fpb32af3frnqsfvntwrvuba@wpr4uofgwpu5>
X-PR-Tracked-List-Id: <linux-bcachefs.vger.kernel.org>
X-PR-Tracked-Message-Id: <jnnywf5k3qydxwrh6ur6ap6wjr7fpb32af3frnqsfvntwrvuba@wpr4uofgwpu5>
X-PR-Tracked-Remote: git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-04-17
X-PR-Tracked-Commit-Id: 261592ba06aa44001ab95fd47bafa4225bab25cf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9e99c1accb1df0b07e409ce21f15fa4e8ddca28f
Message-Id: <174493199485.45874.10772998315442142592.pr-tracker-bot@kernel.org>
Date: Thu, 17 Apr 2025 23:19:54 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-bcachefs@vger.kernel.org, linux-fsdevel@vge.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 17 Apr 2025 16:20:49 -0400:

> git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-04-17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9e99c1accb1df0b07e409ce21f15fa4e8ddca28f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
