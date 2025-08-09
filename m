Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E45C24B26
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Aug 2025 03:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754710658; cv=none; b=dikFvPPV3twK43WjGOBU2KIFkp5vk8XXOCD5noL9S3Lj+pl589b022iVnIiJey7GG3hWwhLuCXo303CSxN6zhkPCY5kYxFl22oz9o+egzulMiodv8/DhaeXdUq8Q5eflOlApWphZr2rTngqpLTkoLzj7Bkx3HCiUlyQCDDHTOlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754710658; c=relaxed/simple;
	bh=krLk2C5VdCp4XUYKane5A4fuNxdwLEV9JrwqeNNKEbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSwdQdGU3pEc+iD+uLiz5HYiTmybKqh6t/DPH3BETcBbPScmt0gD318BVIpYn+fIO1VCvM2OUT7HO24eviCH4p1gPbH1/0Ztr4WcJcAK29gLY9mLOTrysyxn8XBz0WZNZsqpFXGWoeQxNbMpKhGVAp20OAQso3xrXivITNIYSvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=m03SuMmY; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="m03SuMmY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Splir2sF6qmr7O2R+Ms5hZDjHzzVcFybBojCcjT6i4g=; b=m03SuMmYtQArMUSMNJenrQKt0V
	aTEPHZjPhHU5rB39+RfAGGcR9b62Piie1O5oBosxns430lbFjXnl1EcgBc59ok3TzvMAEsxcU6yxf
	9T0/0oIzDH5KdqVtSkEumkr5Z8ws4hq4mZKsASEAAf4rZW0++/1AaTpFeyycSb2yP23S4fcm3o7LI
	8A3/Q91G4FPzMYh61WWzCWKa8qUb1hVy3L/GSs5yd0jhS9xjkLv7i1MpJT/prQnUXcIHrXpLfN1YD
	cJEV0huIfqSxncftW3vLgmSq60vixfdssEaGQBQZJzYzl40PnebGJquXGX6JQ9ULjXjV6fhrY/Wum
	yBMY1nIA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ukaOj-00000007O4U-2JGm;
	Sat, 09 Aug 2025 03:37:33 +0000
Date: Sat, 9 Aug 2025 04:37:33 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix build on sh4
Message-ID: <20250809033733.GI222315@ZenIV>
References: <20250809031944.1579293-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250809031944.1579293-1-kent.overstreet@linux.dev>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, Aug 08, 2025 at 11:19:44PM -0400, Kent Overstreet wrote:
> put_user() with a 64 bit value causes an ICE on sh4.
> 
> Reported-by: Alexander Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  fs/bcachefs/sb-counters.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/sb-counters.c b/fs/bcachefs/sb-counters.c
> index 2b4b8445d418..9fa2c568c985 100644
> --- a/fs/bcachefs/sb-counters.c
> +++ b/fs/bcachefs/sb-counters.c
> @@ -136,7 +136,7 @@ long bch2_ioctl_query_counters(struct bch_fs *c,
>  				? percpu_u64_get(&c->counters[i])
>  				: c->counters_on_mount[i];
>  
> -			ret = put_user(v, &user_arg->d[stable]);
> +			ret = copy_to_user_errcode(&user_arg->d[stable], &v, sizeof(v));
>  			if (ret)
>  				return ret;
>  		}

If anything, that's the wrong place - put_user() on 64bit *is* allowed, whatever
the architecture.  See __put_user_u64() in arch/sh/include/asm/uaccess_32.h;
it is supposed to work (and it certainly isn't supposed to trigger an ICE,
so ultimately it's a gcc bug).
