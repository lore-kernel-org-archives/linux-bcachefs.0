Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EED825D8F9
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 15:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705903; cv=none; b=CuelVf+YdoFqLXpDA9Juk8fslbSG4T3FXp2/PXl2g8uJZv8QKOCDzBcRX0pYkiXXIjz9v+6+DmY8IzCIUcfHb6u1GJAeUFtsoHbXmZ/ld7RiQzqWeuFoli6cpbWwFd+fhulebOmoPIa322LJfeXhxgFXdV9vL89AMKX8ARyZdC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705903; c=relaxed/simple;
	bh=2pEPfQnKkMXf9qYdroi+mcyKZJi/SHxzLO3DOgfFtmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWuzdfKjFu4i3a/ChHIeGmATF7hUIE3vNGzaZrRoMweLNU9lIyq3YkJxSbpE81ZxG/YcyUoq3bOxMSd7AriRcHjd8sfm2sOluXguGbll8YIqRRA0VxAXatUimoc6Q04rD5JflG7SS9u7fV0XboS5rZv5RcbC9Do0T780ZDNS/yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EZGofefi; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EZGofefi"
Date: Tue, 11 Mar 2025 11:11:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741705899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W7fUA0Qx0rj71WggZBm7d9GiJYyJrD9OSJTohMrCes4=;
	b=EZGofefiPSvaJgZqOsBlLgl+SXB4lbosnWiafYxegnktNiM8WegWnKcs12Sx3dGKzI21+O
	FXtSExHb1zSCjXSpoTMt1h5gzeFMhs7ZvdfW52monrgEbvF6tIALnJULLC+Gzu4D+ScRVd
	MGDTwmM5S6Z4Clixu8QbWgY0Cqru088=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Cc: syzbot+c17ad4b4367b72a853cb@syzkaller.appspotmail.com, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] bcachefs: Initialize from_inode members for bhc_io_opts
Message-ID: <pzcsn7bkeaneadjpv5wudfvjeivukq36dzfobq5apjmr5blqew@txii3klkqstk>
References: <20250311150606.127577-1-nicolescu.roxana@protonmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311150606.127577-1-nicolescu.roxana@protonmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 11, 2025 at 03:06:10PM +0000, Roxana Nicolescu wrote:
> When there is no inode source, all "from_inode" members in the structure
> bhc_io_opts should be set false.
> 
> Fixes: 7a7c43a0c1ecf ("bcachefs: Add bch_io_opts fields for indicating whether the opts came from the inode")
> Reported-by: syzbot+c17ad4b4367b72a853cb@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c17ad4b4367b72a853cb
> Signed-off-by: Roxana Nicolescu <nicolescu.roxana@protonmail.com>

Indeed, we're not zero initializing opts prior to passing it in -
applied, thanks.

> ---
>  fs/bcachefs/inode.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
> index 04ec05206f8c..339b80770f1d 100644
> --- a/fs/bcachefs/inode.c
> +++ b/fs/bcachefs/inode.c
> @@ -1198,6 +1198,7 @@ void bch2_inode_opts_get(struct bch_io_opts *opts, struct bch_fs *c,
>  		opts->_name##_from_inode = true;			\
>  	} else {							\
>  		opts->_name = c->opts._name;				\
> +		opts->_name##_from_inode = false;			\
>  	}
>  	BCH_INODE_OPTS()
>  #undef x
> -- 
> 2.34.1
> 
> 
