Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C713F13D518
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 21:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732742866; cv=none; b=WgOB+5dpQ7sLfoYo+znp0SfzTm6N8eDeAzVR4f/ot8DU71iWkwKWZh4Vg0aH1t+RyMsgSKS1WqtNw92thtvd3hmVragolpZ+ka4pVm3+kLzpGgxgYU2jLRMtfQQf7qsvxpQxazRCOtlbvNRdOzZgxS0SJ39qZTlx3PeEdoWI5uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732742866; c=relaxed/simple;
	bh=eAr5DwaRs1A6iemSImX/LB+mWHKKto8FEnqneUaD/5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jn7w010kAboesm7ZVTRRhYgigS8utTwUHBA9iiArU9NKqlu/S29YCokgcm4g92JF5AblW5cr2Pe6r+Je9RWCr6k2cKqGrZEGXVtCcxJ8K79z6ZJoZ8mXjnDq16g/XBsj9Ko/oOgwYhHQNDU5JQh0m2bGuGZbtyZH3v593/z88P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pzocTGh5; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pzocTGh5"
Date: Wed, 27 Nov 2024 16:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732742861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ag3zPk4N4dkehte0V7KHq77H/cKzi7fj/TtxDUkxDls=;
	b=pzocTGh5mnC4GJgerrWzAsj8E6g9JdEHWjhOdVFkGUeg1ObRY81b/keg+7CvhvWUGmlO9D
	2B/dA+ugn546t5rP+WAMLOPW/4fnx4de68xRxfmVP/CMKANTkUZPgUw6M1lmFbDY8sP4Fh
	wvSf0WbTV/TvAMtR9JXZ6BSiLVIS5mk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>, linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
Message-ID: <tt4mrwkwh74tc26nkkeaypci74pcmvupqcdljavlimefeitntc@6tit5kojq5ha>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
 <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
 <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
 <k7nnmegjogf4h5ubos7a6c4cveszrvu25g5zunoownil3klpok@jnotdc7q6ic2>
 <4f7e45b6-c237-404a-a4c0-4929fa3f1c4b@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f7e45b6-c237-404a-a4c0-4929fa3f1c4b@kernel.dk>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 27, 2024 at 02:16:24PM -0700, Jens Axboe wrote:
> I'd argue the fact that you are using an mm from a different process
> without grabbing a reference is the wrinkle. I just don't think it's a
> problem right now, but it could be... aio is tied to the mm because of
> how it does completions, potentially, and hence needs this exit_aio()
> hack because of that. aio also doesn't care, because it doesn't care
> about blocking - it'll happily block during issue.

I'm not trying to debate who's bug it is, I'm just checking if I need to
backport a security fix.

> > Jens, is it really FMODE_NOWAIT that controls whether we can hit this? A
> > very cursory glance leads me to suspect "no", it seems like this is a
> > bug if io_uring is allowed on bcachefs at all.
> 
> I just looked at bcachefs dio writes, which look to be the only case of
> this. And yes, for writes, if FMODE_NOWAIT isn't set, then io-wq is
> always involved for the IO.

Ok, sounds like we're in the clear. I already started writing the patch,
so it'll just be a "now we can turn on FMODE_NOWAIT" instead of a
bugfix.

By the way, did the lifetime issue that was causing umount/remount to
fail ever get resolved? I've currently got no test coverage for
io_uring, would be nice to flip that back on.
