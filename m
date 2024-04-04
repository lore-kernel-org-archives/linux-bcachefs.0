Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A23713BC38
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Apr 2024 23:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712272583; cv=none; b=hCCh2UDzAm+DbIzG7xi74vrFULUTHcoxhs7Cl3JbB2en86MbWKARo6VhHqV6X3eejip3+KMVPpd4I/nBjJRzSUmvbOy7M+c/A/89fzLsNWAkRWgbT9+VtuIciTU2J8g6TD9YGt55MhO7Z9QeOeli8deoV4EZw4i6Xsly2IZFs4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712272583; c=relaxed/simple;
	bh=tNhbfsqkOIXXwMaZuZQoZ4KHMpolvx+YQqbyBoTkMi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJxSAZeGLnhGeSkpztFs61aAzl9SwNF7V0NmNrDB2JqbWi/7lPfAE5z8aYYOlDrgduvxTaKmypby2jcXqJVVIBE5f6O+LKgYet14XN9YtyW5U+YBtywraHtXOUeRkg9j9BE+BI7Q0kl/y4gs8q63h8YaxFWAqWvgq2RjldulFfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v3VG61WE; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v3VG61WE"
Date: Thu, 4 Apr 2024 19:16:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712272578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v0nm4I2SUoIkHiKM9s+niR6pZzODSe0Y5BTNXhdOGCs=;
	b=v3VG61WEXni4IG1KR5hh6DiPaT3TGMp98pqXlu5csodIdfDJYWt7efAkpZfzjw9htZFwHM
	M1ZGXj9N4+1ncGo9AlUEu6AtdytS55d4ez/3JNnrug+e3wsi0Pi8iO5ay9mjXd+pBzEMBb
	YGfsA3x76BOzLcBtB0yGE0O33G+BVVg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzkaller@googlegroups.com, 
	Thomas Bertschinger <tahbertschinger@gmail.com>, Ariel Miculas <ariel.miculas@gmail.com>, 
	linux-bcachefs@vger.kernel.org
Subject: Re: syzbot for bcachefs?
Message-ID: <aw5elbevdhwuqr7ecap6i5hepvkjbgs5xexq7nvu2yvuhh5bpb@tmyjcruysqjf>
References: <oxdwygzxpbpwxgl5v5hzaj7er6oxt2rlmaobkov4t23xqptqrn@gxi3nlapfini>
 <CACT4Y+ZEPWbJsYvWauog95yRFuzZmA=tK-uS+aDT-x=jnc3f7Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZEPWbJsYvWauog95yRFuzZmA=tK-uS+aDT-x=jnc3f7Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 04, 2024 at 10:33:07AM +0200, Dmitry Vyukov wrote:
> On Thu, 4 Apr 2024 at 01:59, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > Hi - what would it take to get syzbot going for bcachefs?
> 
> Hi Kent,
> 
> There are 2 parts:
> 
> The easy one: we need to enable it in syzbot configs. Should we
> configure it as follows?
> 
> CONFIG_BCACHEFS_FS=y
> CONFIG_BCACHEFS_QUOTA=y
> CONFIG_BCACHEFS_ERASURE_CODING=y
> CONFIG_BCACHEFS_POSIX_ACL=y
> CONFIG_BCACHEFS_DEBUG=y
> # CONFIG_BCACHEFS_TESTS is not set
> # CONFIG_BCACHEFS_LOCK_TIME_STATS is not set
> # CONFIG_BCACHEFS_NO_LATENCY_ACCT is not set
> CONFIG_BCACHEFS_SIX_OPTIMISTIC_SPIN=y
> 
> In particular, I am interested in CONFIG_BCACHEFS_DEBUG. Does it
> really add more debug checks rather than lots of console printing w/o
> checks? Some "DEBUG" kernel configs are misleading here. Checks will
> be useful on syzbot, lots of printing not so much.

CONFIG_BCACHEFS_DEBUG adds piles of assertions and no extra console
printing :)

> Second part: syzbot will need to exercise the fs in some useful way.
> Is it just a "normal" fs with files, or something special?

It's a normal - but multi device - filesystem, similar featureset to
btrfs.

> Is it mounted from an image, or an image-less fs? If it needs images,
> how can they be created?

apt install bcachefs-tools
mkfs.bcachefs <dev>
mount <dev> /mnt

...

> "find tools/testing/ Documentation/ -name "*bcachefs*"" does not give
> me anything useful.

https://bcachefs.org/ has some docs, and the tools have a man page

Anything else you'd be interested in? Thomas was interested in working
on on-disk-image error injection, is that something that would be
useful?

Ariel's also probably going to be working on adding full image creation
to mkfs, i.e. pass it a directory - is that something that would be
useful as well?
