Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2F757888;
	Fri, 19 Jan 2024 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705704607; cv=none; b=g2qqo9R4fqV5UMEXCbs6i8thLAPChCsuGQF5cKwv5tHtyilWbP2hSVTf8ST/wgjKDnGeaD1k3gnUM8pMbdKJwyt9oUyfxW3FRC6xyfUUsy5TdRks7+2RkK6C1jWsBufc24SNCXKStBd6QBJaxQKmbalYWS/wXtrt7VgV2BilLFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705704607; c=relaxed/simple;
	bh=GJ/cdmPZ96gT5HAhT2Orqz/Ui/62wRNrchPV4Sv9K2k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NussFRZQOU9ps+9km1SsDuQTOUYEuzeN7DqW/sVT2UkFDnqWaDqCcCJU4edVDeY4tE9sZtStL+h+BgqeR6w62YdxCjihHUipvKO2EpAiEUYGA4hFw3+qGKGwddkK23fXdEHnvy8FYvXmqvaH/Rx+vPdGpQzA8P0wF6yUC+ElBSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0IKAQlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0IKAQlO"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83B10C433C7;
	Fri, 19 Jan 2024 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705704607;
	bh=GJ/cdmPZ96gT5HAhT2Orqz/Ui/62wRNrchPV4Sv9K2k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=C0IKAQlOGvEWi3yk/eqy8lcN8lpFYBzHck8oZAU5AgMCO8fZydSXh7YPKBHvl8ZJy
	 U1eR36WqsS8GQlKqgCZuHlOE75ZFmcZc2+Dg5MlnLO9yEUcXTDeYJ8ezxx+urZMkCz
	 OFZM+7yy/MQ5CVfRx3mBo1E2yJeCJjmi6DADER2VldQQeOFQD8HrOK/bQYpLSxSSul
	 b2bqNEHq63K69Ulo0YGbVP+P3+c1/cXOsX9jqm5IWyDmrOmslPJC27u2jPX0+EKTUr
	 ekqyvNp8owMYrpUnOHjJF2pvYESZXTSo9V1nqDshprXCZGodNbQ1UJjTgVd6f1M/38
	 HQcrpQfyJWpUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5916ED8C9A8;
	Fri, 19 Jan 2024 22:50:07 +0000 (UTC)
Subject: Re: [GIT PULL] strlcpy removal for v6.8-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <202401191311.B6AA79D@keescook>
References: <202401191311.B6AA79D@keescook>
X-PR-Tracked-List-Id: <linux-hardening.vger.kernel.org>
X-PR-Tracked-Message-Id: <202401191311.B6AA79D@keescook>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/strlcpy-removal-v6.8-rc1
X-PR-Tracked-Commit-Id: d26270061ae66b915138af7cd73ca6f8b85e6b44
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 57f22c8dab6b266ae36b89b073a4a33dea71e762
Message-Id: <170570460730.3214.9532506822254979766.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jan 2024 22:50:07 +0000
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, Andy Whitcroft <apw@canonical.com>, Azeem Shaikh <azeemshaikh38@gmail.com>, Brian Foster <bfoster@redhat.com>, Dwaipayan Ray <dwaipayanray1@gmail.com>, Joe Perches <joe@perches.com>, Kees Cook <keescook@chromium.org>, Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, linux-hardening@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 19 Jan 2024 13:14:55 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/strlcpy-removal-v6.8-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/57f22c8dab6b266ae36b89b073a4a33dea71e762

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
