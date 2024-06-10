Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4991B5A4
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 19:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718046813; cv=none; b=FZIZ1qPKO+YTIVkggJ0Qwq3kq0SJ8ckB7Uw2sWVGG+9lk+AFhQWViCusaXNDnALoJmXfl+YCkdaZBZymi0nS17q1Ga3hMP3fUMnUZfZ5QfEb04MX2OJEM4knQ5zASH5DkRLCjvgFwyqM6ljV7bx8HPM6VUeq3+Rx2KRBk1dVufE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718046813; c=relaxed/simple;
	bh=17ZDbQycCIRt4rasaB2DcWCJH3l8mvUKagTCekXv3po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUTystbmNicxonRiddMO0mtwfTXZBVfjLMcAWkDMNkv0Ed4qshSPWriRiMdjYvXrgLfMQjPblSMOwIlFKvF0Tg/ihjZgczo1Z9vAKQlcoKw2pVTDwo9I4vdrt+I0CQ+9QU9n7KthSwQepGOYui3fHPLGAlkAKeYsh7UfiQ+jnC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O6hCynGK; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O6hCynGK"
X-Envelope-To: mjguzik@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718046808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=beN01cHUZ0mNOBvVJ8oAjjO3X0pyFVRZhL9S2mzJNpY=;
	b=O6hCynGK3YcbHYR/3v/4YTodqc4g10WF6ZplLa6L9T7iO0IyIB15xpawcAVgm01s0/HZfD
	ocsM0P6UVpR/Ky/W3mRE9yMrbYWbX+K1ViDpBeoi3rmSgRKC+bVMsu9prXPvU9C7ul3A41
	hZM4gZ1V0lScuqoOQoS1hvAb/AXHHUg=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Mon, 10 Jun 2024 15:13:25 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <fmfpgkt3dlzxhotrfmqg3j3wn5bpqiqvlc44xllncvdkimmx3i@n4okabtvhu7t>
References: <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
 <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
 <ngsytb3begcqgyfc5tiqjqdj6fp7kdeiwvd2jfq7ahwge2dr7c@fjcawnco7ssk>
 <gskaw3ud7aicys3kq3j5nlf66ihcisfrnkwo2wlb5hji5svhvf@vvbuomk2fhmm>
 <CAGudoHFZ76yfxL7v=_KhEY=0RzKrc-AksSAFwL-L+u9TQPVnkQ@mail.gmail.com>
 <noxotudfocqhmmg6z7j5ifwt55zqpptyx6nl2fmcbrxvz37ftu@r6tevsh2fvlf>
 <CAGudoHFCe4cRjhZ9OpCZp6qM142tOkviAsi7xPkpXqs9CwOPBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHFCe4cRjhZ9OpCZp6qM142tOkviAsi7xPkpXqs9CwOPBQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 10, 2024 at 08:59:21PM +0200, Mateusz Guzik wrote:
> My plan for short term is to get the cheap hack in, it already
> provides vast majority of whatever win one can expect to get from any
> inode hash rework for next to no price.
> 
> As for long term, there is other stuff I intend to do in vfs. Should I
> manage to get the stuff in and find this remains unfinished, maybe
> i'll do something about it.
> 
> Part of the problem is that plain rcu conversion would require
> reviewing every iget5_locked and similar consumer out there, to see if
> their callback is safe to use with it. Not something I'm signing up
> for anytime soon.
> 
> Anyhow, you are free to object on fsdevel with a patch of your own. :)

Heh, already got too many of those projects going :)

It might be more practical to implement a new standard inode hash table
interface, with cleaner semantics, and convert filesystems one by one.
The existing inode hash table keeps inodes in the hash table while
they're being set up or torn down, and that's not really the ideal way
to do it; it's better if a cache can only contain fully constructed
objects.

But that means existing filesystems have to be checked to make sure
they're not relying on the vfs inode cache for locking. That's also not
a good thing to do; you want where possible locks and locking to be
private and specific to the data structures they go through, it tends to
be bad form for a lower layer to rely on locking from a higher level -
it makes things brittle.
