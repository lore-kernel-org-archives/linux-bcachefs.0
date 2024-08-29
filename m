Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B162319047F
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Aug 2024 12:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934342; cv=none; b=l79KCilUPs/mNFIl/ysHv6WhO/I/WqdXBk+b1FCE7MB1lEko5xzL+Dja5M33q4q2Pfml5ZxP1S2y2Q49wpWfzo9q10A05BTUcQvhbqKI+HVtBVp4X6nHPUeEvLtUwtAn8E9Y2Rx35uvayONoAiMGCOFc543L3ahMCFR7Y1yMngs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934342; c=relaxed/simple;
	bh=7CXvtXHwO0028/VdHCk+FBpUlRfs1h+HrgKjZj2uM+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQIShcZ5K9prJ5UqvO3PosBWcFDLMp/sw2BRGKbYovyirX9QtAPg6Uu2stOWWlip0k87QjYk2XklHILmCHALuDGf5RXe5yHgfwRCQwqMVoxF2NdWtva/RoLkff0qm030lkQV4ch8KLLsZY6s9SzikaEek63lMB4Tp2WD5FYipjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VosTZRuL; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VosTZRuL"
Date: Thu, 29 Aug 2024 08:25:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724934336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5KQbrmkoQxoBGxp8VqgXK/PzFblLA70k6UhDahc0x+s=;
	b=VosTZRuLYIhjCzW4dw8M4AIVk9wylQd/Xi6e3ZgWL09LPf86eexNwFiDfq5qnKq4NkmU11
	EamWJxzFBcYJ0bazN67NpumycNQctdwTa0nGE0xg7iyj7Dfk1XQPRoM04ggdlUFKI/cg5d
	qirs+ymRfZtXqvbFsD7sHJGiUhCkRxU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, 
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com, brauner@kernel.org, 
	linux-xfs@vger.kernel.org, gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v4 14/16] bcachefs: add pre-content fsnotify hook to fault
Message-ID: <y2734c2a3gfavo737s3vzdj7xxx2atvqsffh6nkdha77bz5kyb@uhgeiwrd75eu>
References: <cover.1723670362.git.josef@toxicpanda.com>
 <9627e80117638745c2f4341eb8ac94f63ea9acee.1723670362.git.josef@toxicpanda.com>
 <20240829111055.hyc4eke7a5e26z7r@quack3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829111055.hyc4eke7a5e26z7r@quack3>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 29, 2024 at 01:10:55PM GMT, Jan Kara wrote:
> On Wed 14-08-24 17:25:32, Josef Bacik wrote:
> > bcachefs has its own locking around filemap_fault, so we have to make
> > sure we do the fsnotify hook before the locking.  Add the check to emit
> > the event before the locking and return VM_FAULT_RETRY to retrigger the
> > fault once the event has been emitted.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Looks good to me. Would be nice to get ack from bcachefs guys. Kent?

btw, happy to give you a CI account as well: just need username and ssh
pubkey
