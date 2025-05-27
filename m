Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175B01DF26B;
	Tue, 27 May 2025 18:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748371945; cv=none; b=p51nuNdFm1rrWgSNP9JlvPuLbqDOuxjjKLG7fCNVr+919iO8ZdtV27LjaxYyquULhynOPzQ5zEr4miOO7suwI4pEZqfjTPNYtCMa5YJx3pQhrZIuGTHGJcmHU1ob4dGm8K8BIJYWJhFSxHawAo/s+CwfKVCcSwuB1ZHPmbwMd68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748371945; c=relaxed/simple;
	bh=ECgdeUBnwipVSAbZmOU/tLnrcGcPbnXjWXplAxwDSCQ=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=LO9SdCNtwOj6mydoqaacsqb6Xs0E3L100CbOf8lMbskOxGfq4pTU5OPcczCfc6tYgtOOe+I/tc3+zwpyRBfjgENmzuWwlgofzdGIIatVyhStjbrOZS8twJvFt8FZ2Hf36nLI5VjLlYyrU6DqduQt2SPLrAv4Iaklx3t2lF74gS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 02A051E1D8;
	Tue, 27 May 2025 14:52:16 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 9BE3BA0FFF; Tue, 27 May 2025 14:52:15 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26678.2527.611113.400746@quad.stoffel.home>
Date: Tue, 27 May 2025 14:52:15 -0400
From: "John Stoffel" <john@stoffel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
    linux-bcachefs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: [GIT PULL] bcachefs changes for 6.16
In-Reply-To: <dmfrgqor3rfvjfmx7bp4m7h7wis4dt5m3kc2d3ilgkg4fb4vem@wytvcdifbcav>
References: <oxkibsokaa3jw2flrbbzb5brx5ere724f3b2nyr2t5nsqfjw4u@23q3ardus43h>
	<dmfrgqor3rfvjfmx7bp4m7h7wis4dt5m3kc2d3ilgkg4fb4vem@wytvcdifbcav>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Kent" == Kent Overstreet <kent.overstreet@linux.dev> writes:

> There was a feature request I forgot to mention - New option,
> 'rebalance_on_ac_only'. Does exactly what the name suggests, quite
> handy with background compression.

LOL, only if you know what the _ac_ part stands for.  :-)
