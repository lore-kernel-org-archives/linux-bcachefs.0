Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435A8182C5;
	Sat, 24 Aug 2024 02:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724468392; cv=none; b=Wp7xjqsi+PrJ6QlPXzKwYQhWRr4BSgssH2x7O/GkGHOme6QnM58jYIM25iYY7EgJwgH40trAPXYfUgUW+rTho4dusYxwzQIGsy0itDiroULtenEu5NPBmnMJgevG8/f1eZKE9OBymF6MNy/p9L/YJ9EBerU4PeRgmOOXS5i1QsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724468392; c=relaxed/simple;
	bh=JRwNOylLEyyQkYQSU78VPjZWXplG69DWCgq4M1xq0/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QcJgR+yidRl0kWx0xrNUEo/sPSeXhhdiwBxWHSbA442uMz8S3AA2t5aep6QbX8Rgl+0EHgkchyUkQ4xl38muDsCVK+lNpCVywDh470mVm6FciKb+fqmD/z+PztK4wovoIRZa5/O+KzQLrWxHqhXJ4mqusZo3XzZEz/sKj1i8foA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aCuTdmjt; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aCuTdmjt"
Date: Fri, 23 Aug 2024 22:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724468388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CSxjna8Q5fkr+ig0pv6n0XFm0YyRtIeu5kxFdaC71tE=;
	b=aCuTdmjticzNSGHVFc7cgrwRTPvgxp7b1hN6UnPPpWsTKb0ynEtigbjQ2JZMFwu6iV/DiK
	1vBpUJ2N3RVkRow4GCb4bLJigbkgCHHl0Pg93khS+2hmQjv57RUOmRoeH5FtftVe216bcg
	kUWf60Ja2k5cpdAYIp25MR0DwOhe1Sw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5
Message-ID: <ihakmznu2sei3wfx2kep3znt7ott5bkvdyip7gux35gplmnptp@3u26kssfae3z>
References: <sctzes5z3s2zoadzldrpw3yfycauc4kpcsbpidjkrew5hkz7yf@eejp6nunfpin>
 <CAHk-=wj1Oo9-g-yuwWuHQZU8v=VAsBceWCRLhWxy7_-QnSa1Ng@mail.gmail.com>
 <kj5vcqbx5ztolv5y3g4csc6te4qmi7y7kmqfora2sxbobnrbrm@rcuffqncku74>
 <CAHk-=wjuLtz5F12hgCb1Yp1OVr4Bbo481m-k3YhheHWJQLpA0g@mail.gmail.com>
 <nxyp62x2ruommzyebdwincu26kmi7opqq53hbdv53hgqa7zsvp@dcveluxhuxsd>
 <CAHk-=wgpb0UPYYSe6or8_NHKQD+VooTxpfgSpHwKydhm3GkS0A@mail.gmail.com>
 <CAHk-=wghvQQyWKg50XL1LRxc+mg25mSTypGNrRsX3ptm+aKF3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wghvQQyWKg50XL1LRxc+mg25mSTypGNrRsX3ptm+aKF3w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 24, 2024 at 10:40:33AM GMT, Linus Torvalds wrote:
> On Sat, 24 Aug 2024 at 10:35, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > What is to be gained by having release rules and a stable development
> > environment? I wonder.
> 
> But seriously - thinking that "I changed a thousand lines, there's no
> way that introduces new bugs" is the kind of thinking that I DO NOT
> WANT TO HEAR from a maintainer.
> 
> What planet ARE you from? Stop being obtuse.

Heh.

No, I can't write 1000 lines of bug free code (I think when I was
younger I pulled it off a few times...).

But I do have really good automated testing (I put everything through
lockdep, kasan, ubsan, and other variants now), and a bunch of testers
willing to run my git branches on their crazy (and huge) filesystems.

And enough experience to know when code is likely to be solid and when I
should hold back on it.

Are you seeing a ton of crazy last minute fixes for regressions in my
pull requests? No, there's a few fixes for recent regressions here and
there, but nothing that would cause major regrets. The worst in terms of
needing last minute fixes was the member info btree bitmap stuff, and
the superblock downgrade section... but those we did legitimately need.
