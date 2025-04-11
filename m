Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592EF22338;
	Fri, 11 Apr 2025 03:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744342019; cv=none; b=mEfMOygZjYXi/PLDJo5EvqOCEkvTx5c1AR+hTifHh5hfOumRsAaf0o93EZldwIRrNvAMIgwJU7xKopxFhctWFfoSAE/mUWSVaMOcdD5vdIsd04cLytl9MKL9UGDqS1/I3Eu7BjkQuXjUtam7hvsLAE9C+tIVRZ3Uvy1JeB7sQiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744342019; c=relaxed/simple;
	bh=gNfqPSqTnj+M4EZ+Mw6vJ+XyIPKYhHCBCZn4vopaHZU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=iI+S8QaAlNPzTftjfK29Pd/WnhkZ8gqW6JP6AI/93JUaE8NJfECqRBxoRl4B4dmQkT4ovvcIzEoh1rEysNtwCbOkpG2EFcWzVHjdEZvFadOEWYhE/O3+ZaLRLfgVcce+W8fG9Xjm1HHSjmxONdM0XnQeylLyVWHOTH7rMTJWdOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8VOL1/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8VOL1/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E53C4CEE2;
	Fri, 11 Apr 2025 03:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744342019;
	bh=gNfqPSqTnj+M4EZ+Mw6vJ+XyIPKYhHCBCZn4vopaHZU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=d8VOL1/jZ7bCJyrg5fdJ+VbLiph7evFuhLjIEljSweuLxAc+30SCR9/hp3HAdI8/q
	 N9/atIjwyanxercz7HYa9fQoq2IGmqes5CxmWRsuaGPeroWjB9byOnwcb732tpB8ue
	 lR2KzJ5D2F/awsEnu79ctq05ThbsvsTmkUxbsfahK8qW1bAQICLQU/vLd89qp+6jb0
	 e5sD2PRXhQx3IHj0UGVIbhjiTox4sm83igIyv1SkiVxeJAXQRFQcVmcsyby/v/HpVb
	 RuMMgXrBBGdUZ+tXTnYAiQyPBUQFCoiGMXmhmOWowiuDsU43TjMJ4e3ZmobTZ0hOdx
	 /JYKTKIz86TZQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAED9380CEF4;
	Fri, 11 Apr 2025 03:27:37 +0000 (UTC)
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <qmulyyzrlr6jdhqoluhqr32ho5qnuf4crxouj7let2anp4n2bz@z2wthovykeul>
References: <qmulyyzrlr6jdhqoluhqr32ho5qnuf4crxouj7let2anp4n2bz@z2wthovykeul>
X-PR-Tracked-List-Id: <linux-bcachefs.vger.kernel.org>
X-PR-Tracked-Message-Id: <qmulyyzrlr6jdhqoluhqr32ho5qnuf4crxouj7let2anp4n2bz@z2wthovykeul>
X-PR-Tracked-Remote: git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-04-10
X-PR-Tracked-Commit-Id: 55fd97fbc4744a43fb2d134908e481266cf33bda
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ef7785882672e73847fb80f6c39e76998d4db57b
Message-Id: <174434205646.3944136.9565079102039929749.pr-tracker-bot@kernel.org>
Date: Fri, 11 Apr 2025 03:27:36 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 10 Apr 2025 20:32:08 -0400:

> git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-04-10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ef7785882672e73847fb80f6c39e76998d4db57b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
