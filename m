Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8673821D5AB
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 15:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362212; cv=none; b=dAJqFPp/xoH7+gyli/+KWz+pdP84Y57pvJmocPD7Q2q6R0gfQnNMbJmWHYPXl/9+ubYMfvOzQq141j/brtnyIgqHDRY5mkfD5DGH6gZ57IG7j9yioenJqVk/PdPHkM8fBNWUrcxTPCflJluSCQ81g736r9RtFsXoyVSh8gCYZbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362212; c=relaxed/simple;
	bh=AAz0DLMgMTB7F/jGw9WZlIhTliLR8/Li8mvbnaQ5IKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBNDim6DZWh5zDOZe37rlUuVbnqfSIXQSdLsVlldGl29mY6V+dRjUk+5Ac6CRZA5LJfmT4RmO/YjjGOA1YJR59BPf6ifLxHHfVaSNWfbKZXYUEeKGaBnIxyuLMNojqLf7t63uWkHhvzPED3W1O1v+4+fQbGg5CNDAb+scIKTH44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cnd6nlwm; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cnd6nlwm"
Date: Fri, 7 Mar 2025 10:43:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741362207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cSv+AiBlTooU4HUGgPN9nT0ov+EzLUep7a9Pvn6pdIc=;
	b=Cnd6nlwmGSQNZskWbnP6bQ4sg50AyaozLxWqiZNbBcWzB5S1dwBH3ihQtFre2YFuZelY3X
	5gKOPADhY3/QJK6xVMewuk+Nt++Jq0umNKO5eXYzagNtNCfuEmuCcjPL8hze9aTEnUjSTU
	/554GSBnDGoNhdbgmdBc2H3RCiO8Emg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 1/7] fs: export invalidate_inodes()
Message-ID: <plajio56ykhjbehtkppn3uuqkzxijvgsz4me746ozauxjkpxv6@ai67wcxekbhs>
References: <20250307134933.1033872-1-kent.overstreet@linux.dev>
 <20250307134933.1033872-2-kent.overstreet@linux.dev>
 <nfdw5bpwvgl2beynlpp7zwjiy3kglk3s5zbouygotvuy3x2uoo@lkhzxvky2ii4>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nfdw5bpwvgl2beynlpp7zwjiy3kglk3s5zbouygotvuy3x2uoo@lkhzxvky2ii4>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 07, 2025 at 03:44:50PM +0100, Jan Kara wrote:
> On Fri 07-03-25 08:49:25, Kent Overstreet wrote:
> > Needed in bcachefs for implementing blk_holder_ops.mark_dead, since we
> > can't use the standard fs holder ops (whicth assume a single block device
> > filesystem).
> > 
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> 
> Please use evict_inodes(). It is exactly the same and is actually already
> exported. Since you are the second one in last month to ask for this let's
> clean this up [1].

Switched it to evict_inodes().
