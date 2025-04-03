Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539A515575C;
	Thu,  3 Apr 2025 23:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743722204; cv=none; b=AvvR4os661/L7uiJkx0DiXpz7xyKvRh8m6sbcR2KmvK3e20DrIdv831dxajqi9IGJz6Esr3tO0Np49lNDzoj/Q6l20FZVFALFXMLGTfhpJqWVqMzgmFQZS496KlNR0TVBZvcGsIyVpMOWllPwvq1IKKyjhsj5QmSxFcp3ngZWD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743722204; c=relaxed/simple;
	bh=30u4nJKBJCh3CFml4Y3qPTJdyJaJRNS1u8OFntAvSjU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fD4M/d2beNbLHLwZ5Mmth3CM2bx4TQLVwRhrF7waCtPxb/C9g4gGUS61uncGwu7cZa3jfZzd9yy9UFpVmUmViJ74x+RBMkDicWStT81YnPkVW9crBtzh19qHHCufWUqJhJVFDctMJgjmASoM8HRwpj3hdPaUBvSPGJbTVi+66Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoHvNp3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoHvNp3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3684EC4CEE8;
	Thu,  3 Apr 2025 23:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743722204;
	bh=30u4nJKBJCh3CFml4Y3qPTJdyJaJRNS1u8OFntAvSjU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YoHvNp3XPf+orzAY1hyzofPZq56CZiSJQ1WMMVrVkgtaz4ppag8s/U0nFnJyPgF1O
	 0Bd0l9Mmfz2MbqQPz86e4dA0ccuhFBy//+DHaXvrgp9xpmTGKrGIBsSBOgXIofqzpc
	 cxcuBpX7RIwUmFdrsQCzoZdS2CV25/tqMkFJlEtiY6moskzVA6txkM/hA1ynqfrlTd
	 XmsV8/N0fycRqQCTi8HhwmnvYEg4LT29VAT3Cf3OOE19DAC+rDTIWgeELnreyX4YEx
	 P0vwEO5eTnpOC7PXCfBXIuqaivID9+yOgD7s5x08WzEFlr0adLAQaFuXaMsfX0SqhV
	 OJ3xcgPqAAGdA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70D1D380664C;
	Thu,  3 Apr 2025 23:17:22 +0000 (UTC)
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <6xmil47xtrx6n7aimj4jf3yvobcyfqqfljj2d2fju7etuguquy@r4j6oyqaicmo>
References: <6xmil47xtrx6n7aimj4jf3yvobcyfqqfljj2d2fju7etuguquy@r4j6oyqaicmo>
X-PR-Tracked-List-Id: <linux-bcachefs.vger.kernel.org>
X-PR-Tracked-Message-Id: <6xmil47xtrx6n7aimj4jf3yvobcyfqqfljj2d2fju7etuguquy@r4j6oyqaicmo>
X-PR-Tracked-Remote: git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-04-03
X-PR-Tracked-Commit-Id: 77ad1df82b9e8d169e3ec9ee8b7caabfa45872ce
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 56770e24f678a84a21f21bcc1ae9cbc1364677bd
Message-Id: <174372224104.2716716.10625832877629990031.pr-tracker-bot@kernel.org>
Date: Thu, 03 Apr 2025 23:17:21 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 3 Apr 2025 16:27:50 -0400:

> git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-04-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/56770e24f678a84a21f21bcc1ae9cbc1364677bd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
