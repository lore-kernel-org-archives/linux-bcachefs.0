Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB621CB53A
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 11:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729769064; cv=none; b=LBy1rK1QDJOzIyso9CE+Rcg+MCilVPLC6I1izr7JKBxBAUrxXnMZqNhxGm/N2VFpXmJxiw2NHfCuPalAYGkidQm6ls9cD03HWsGWKNH0SdZTbqirpbXswyrlnW6f0DBSsmtjB/pRVdmQPXURqLefQYhWJHkY9thP8Iq1Rb+PAOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729769064; c=relaxed/simple;
	bh=gmXE4YogWd7C8CkvgnBY71ic8Tsk7GRpD/LsKkGrhks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i04SLQb16N6iOkUraCa/+TKUEQQnsp/fmE6jonTG06dOer85LFBrGOG31tYz+yOYH2xgIgpowdrPIxEUN855nylR7TXiyf3zRGKQbGq476EBa3KZ9MgpjLECl4jlr/KZ+0zTtV1Jh3QDcN0SRqXQb+CFVljoH20GTTcv1eikGjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MEE7JDVV; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MEE7JDVV"
Date: Thu, 24 Oct 2024 07:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729769058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PDo3PB8CSa8mmi8v6K6fsyOPTWgbJXUXsn1VPJ6HQ+0=;
	b=MEE7JDVVapMi0s1JUr8Z6TwiId22+Nff2Ww52igIYd3cxKE9P5nSzFhIX7J+tY1SU4toR6
	7AZVIIA+GahRr89EYq9d4AXY87fuQ+QOlcwZAp+IyusuIyta1XAGyLpjnu7chkMpt7P/Vr
	1+AYSI+xxOQxb+3cXGJ2+ecEU0YxT4Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gianfranco Trad <gianf.trad@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix invalid shift in validate_sb_layout()
Message-ID: <jaxnjw5ergn7zrnjuzzosgclpmv5st77gtfaj75my3hblufrn2@b4si2orrodw5>
References: <20241023213043.47846-2-gianf.trad@gmail.com>
 <be3e7378-7aec-4ebb-b6e6-e7b824452adb@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be3e7378-7aec-4ebb-b6e6-e7b824452adb@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 24, 2024 at 12:48:30PM +0200, Gianfranco Trad wrote:
> On 23/10/24 23:30, Gianfranco Trad wrote:
> > Add check on layout->sb_max_size_bits against BCH_SB_LAYOUT_SIZE_BITS_MAX
> > to prevent UBSAN shift-out-of-bounds in validate_sb_layout().
> > 
> > Reported-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=089fad5a3a5e77825426
> > Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
> > Tested-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
> > Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
> > ---
> >   fs/bcachefs/errcode.h  | 1 +
> >   fs/bcachefs/super-io.c | 5 +++++
> >   2 files changed, 6 insertions(+)
> > 
> > diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> > index 649263516ab1..b6cbd716000b 100644
> > --- a/fs/bcachefs/errcode.h
> > +++ b/fs/bcachefs/errcode.h
> > @@ -222,6 +222,7 @@
> >   	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_type)			\
> >   	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_nr_superblocks)	\
> >   	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_superblocks_overlap)	\
> > +	x(BCH_ERR_invalid_sb_layout,    invalid_sb_layout_sb_max_size_bits)     \
> >   	x(BCH_ERR_invalid_sb,		invalid_sb_members_missing)		\
> >   	x(BCH_ERR_invalid_sb,		invalid_sb_members)			\
> >   	x(BCH_ERR_invalid_sb,		invalid_sb_disk_groups)			\
> > diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
> > index ce7410d72089..44d0ac9b00dd 100644
> > --- a/fs/bcachefs/super-io.c
> > +++ b/fs/bcachefs/super-io.c
> > @@ -287,6 +287,11 @@ static int validate_sb_layout(struct bch_sb_layout *layout, struct printbuf *out
> >   		return -BCH_ERR_invalid_sb_layout_nr_superblocks;
> >   	}
> > +	if (layout->sb_max_size_bits > BCH_SB_LAYOUT_SIZE_BITS_MAX) {
> > +		prt_printf(out, "Invalid superblock layout: max_size_bits too high");
> > +		return -BCH_ERR_invalid_sb_layout_sb_max_size_bits;
> > +	}
> > +
> >   	max_sectors = 1 << layout->sb_max_size_bits;
> >   	prev_offset = le64_to_cpu(layout->sb_offset[0]);
> 
> Wondering if this other patch might be considered more correct to prevent
> shift oob, given also [0]:

Your first patch looks better, we want to know if we're feeding it
garbage

> 
> diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
> index ce7410d72089..428172897501 100644
> --- a/fs/bcachefs/super-io.c
> +++ b/fs/bcachefs/super-io.c
> @@ -287,7 +287,7 @@ static int validate_sb_layout(struct bch_sb_layout
> *layout, struct printbuf *out
>  		return -BCH_ERR_invalid_sb_layout_nr_superblocks;
>  	}
> 
> -	max_sectors = 1 << layout->sb_max_size_bits;
> +	max_sectors = 1 << min(BCH_SB_LAYOUT_SIZE_BITS_MAX,
> layout->sb_max_size_bits);
> 
>  	prev_offset = le64_to_cpu(layout->sb_offset[0]);
> 
> Also this patch was already tested by syzbot [1]
> 
> [0] 71dac2482ad3c8d4a8b8998a96751f009bad895f ("bcachefs:
> BCH_SB_LAYOUT_SIZE_BITS_MAX")
> [1] https://syzkaller.appspot.com/x/log.txt?x=1640b640580000
> 
> Thanks for your time,
> 
> -- Gian
> 
> 
> 
> 
> 
