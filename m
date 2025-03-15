Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD583BE4A;
	Sat, 15 Mar 2025 00:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741999208; cv=none; b=TVG64+8n3PQvPdHTGeyVkoZdthTe5IgZBeQXfkfib0z6j+njsdfM7n25NsUPW8sE8aYh/VS98xSSYaiEO6TsnR7ON6uOTN8X+CYJedax6KM3fNsER0V+BWsg9nSxa9pzM+oZGzeO4B3igrpbWwWRXsgEhop8RvYhc1/ZpZb9jM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741999208; c=relaxed/simple;
	bh=09HKYjoQfORIShPoDmK1zUwM03YsNcFBuCadwWF9In8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FHukfo1T7Z4k2yuYsE5gkrKWzhG3SV2te2z6f/YD5gfvKjp2RsqRC1LDy4mrTwzppIyju1U3KTSb289wQbuXjs5aw2USNtV43Cd+b9nOWYBuVIcI+uXMjRi54dJON6YEXRvEKNLaSTwgUoMdqiIosvdlYtv6t5ZPf6YA+gjGlLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUHj3apu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUHj3apu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE11C4CEE3;
	Sat, 15 Mar 2025 00:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741999208;
	bh=09HKYjoQfORIShPoDmK1zUwM03YsNcFBuCadwWF9In8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GUHj3apuxNaSH+76MzxokmcS4Y8Tyyh7YeFvwt5oir5WuvmE0Lx0SajwAJI5oiiAv
	 sAX9frXBFDJ6bkBXgEVsRzxOAfU1yQwHvgYtjHWbyLGVeeSaCwl+XgYxsgFSakQw8u
	 oFcYx/DPofDhnGfKeWFS2vvWvvXz4mSDUY6ypW6e3MtD03FH2Ppvc66MsxiNk4vOkz
	 8y2EmVebrf9CzSnn63RGBBqxuSIUZ4y8w1beBaGxwtaCn72a5wDwNgtjj2y/4PTmVX
	 F2UpaNP+B3CtXKhzWXnSAz2a3NMF7PMduOUe3anDbhcVPU/Y0tuWxiwA12r0F16eXb
	 v8LBcNBKdIMNA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE1B7380CFE8;
	Sat, 15 Mar 2025 00:40:44 +0000 (UTC)
Subject: Re: [GIT PULL] bcachefs hotfixes for 6.14-rc7 v2...
From: pr-tracker-bot@kernel.org
In-Reply-To: <r6wusnyqqcmnamampwguyscjpvgwrnwhipsglryaltnofmmkf3@7b4fixf5q2qg>
References: <r6wusnyqqcmnamampwguyscjpvgwrnwhipsglryaltnofmmkf3@7b4fixf5q2qg>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <r6wusnyqqcmnamampwguyscjpvgwrnwhipsglryaltnofmmkf3@7b4fixf5q2qg>
X-PR-Tracked-Remote: git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-03-14.2
X-PR-Tracked-Commit-Id: 1a2b74d0a2a46c219b25fdb0efcf9cd7f55cfe5e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 85ac31fecb37f94bb667e9cda86153f03d5fd3bd
Message-Id: <174199924338.2436000.5041687419202821070.pr-tracker-bot@kernel.org>
Date: Sat, 15 Mar 2025 00:40:43 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 14 Mar 2025 20:02:57 -0400:

> git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-03-14.2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/85ac31fecb37f94bb667e9cda86153f03d5fd3bd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
