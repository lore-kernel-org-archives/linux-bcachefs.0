Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B536F23ABB3
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Aug 2025 07:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754638689; cv=none; b=TjNn28JGgZSFvUSwelCU3jROnKdiSD+d4MT9bLrLHbCkU6uur7MJWpTgZfZz9QX0YFVM0LI97APf7JxBm9NW7bnk/B/Gk1blt/x4i9qET2ZDx82BMw+tMG+wXxQP5vNJmKnF6jGvxRCQH+tmgLan3AR29n6dLprWhCRNDYpIyWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754638689; c=relaxed/simple;
	bh=5CiDG1Hntthp/y9bIpJbpiVwCvhXd81s9iufeJe+x3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YbW78bBOmd7wZmgLybEYBtoNSZDEaAkOpqhiHUi2FbxyNPCE1mAJ6hGXWhl2DDmAa7dVt5cWDxBrBn1YCUINS+fUAd5nIVV+hKN64/F5C5g0zaIUoLp4E8WBqbuH9IYdLR/igGhXQcCRXXP3zDebk0A0QO6zi0VXzMIC0JRZfIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IETId7a+; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IETId7a+"
Date: Fri, 8 Aug 2025 03:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754638675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6WN31UG96otIJ2fJHDsBlOFAssMef/NT0GXXSKI6p0=;
	b=IETId7a+OrE2YzUQ5d84Y+xNTjcCco4JvOxGt5d16HDaYYdT22kKD9c3re0nlqiFHl2hOP
	sawdE4a1TkL3XNtXzlOrPVKEaUpnS6yuh0oCW04a41Yby5eo9PxtN7L4fGUWT3Au+445Yh
	BXGw3+EvzqfhnCNtFbxeOQa9ra2cuO4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alex Galvin <alex.v.galvin@gmail.com>
Cc: torvalds@linux-foundation.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: Bcachefs plans for the future
Message-ID: <gn7qnk6oop3xakhpoauktsizxn6wiirh57jz324wvlnyvdl3yj@yyyzvz7xa4sj>
References: <CAOaPw=i_4s_OPuSqZiKqWNXq19H3K6U24o9fn_m71CT+a35DOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOaPw=i_4s_OPuSqZiKqWNXq19H3K6U24o9fn_m71CT+a35DOQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 08, 2025 at 01:06:32AM -0400, Alex Galvin wrote:
> Hi Linus,
> 
> You've stated that you and Kent Overstreet will "be parting ways" in
> this kernel release. I understand your words to mean that you will not
> be accepting PRs from him starting in this release cycle, with the ban
> continuing indefinitely into the future. Please correct me if I am
> wrong.
> 
> Could you clarify what you will be doing with the code that is
> currently in mainline? If it is not removed, would you still merge
> bcachefs code that was sent to the mailing list by someone else? Would
> you accept that code even if it was written by Kent, so long as
> someone else made the pull request?

Well, Linus has been talking about removing bcachefs from the kernel for
a long time, he's made it quite clear that's what he wants to do.

In the past the reasons were more that it was "experimental garbage". I
would hope the user reports have finally silenced that for good; it has
stabilized incredibly quickly for a modern filesystem. (We're now down
to fewer open syzbot bugs than either ext4 or btrfs and the main bug
tracker is nearly emptied out; we're well on track for a very solid
release and the experimental label off in 6.18).

Now, all the assertions are about how I don't work with other
maintainers and there's a lot of other maintainers who want bcachefs
deleted (along with talk about the need for public apologies, therapy,
things of that nature); this on top of a page and a half rant about how
Linus doesn't trust my judgement within fs/bcachefs during the recent
private maintainer thread).

But the assertions about all the other people I've been pissed off have
been very light on details and don't seem to mesh very well; they seem
like more an attempt to keep long dead disputes alive than anything
else.

Well, it's still his kernel, if he wants to remove it that's his
choice...
