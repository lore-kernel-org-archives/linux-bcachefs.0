Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE12A8F47
	for <linux-bcachefs@vger.kernel.org>; Mon,  5 Feb 2024 03:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707102631; cv=none; b=pbY2qLMaKAmz06YNhle+OvF2Q+qcreP7ur9gHq9s0Qu3F8J0lkDcrM/Zv08VhfYDzHotxJm6Yj1x4XX6lHXchh2M8YAdZx9PVo+JeZuv8ZTjqqStZuT0RrDVMyERRvlzgaG9/by2Fseqn25/jnAq4Eo2M18UmTWGpOpxE+3Z5As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707102631; c=relaxed/simple;
	bh=JyxR2MUzQzsErxWO21Q5GsLeJB/QuWK07sjazWZnQyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1MP92LbBajANGKWyy0dQ8RjfaJN4h5EC9i7eu/kgmHmtZ5GuPwjbvvE9A4jDO9Tgp4G0lJOyoYc5wX9DIu7mhRqE5WIQynRN8RKN2kT7FreQgezRhMT53GZU/xJ4saMJEplBYmGUisMOXGuYkmh07tFI9mldxepJCHtNjxr6Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=asWfFxRF; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="asWfFxRF"
Date: Sun, 4 Feb 2024 22:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707102626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P6yDd/INE/dUrcNQSnKq13z/C66Ti4wwbrZLDPG9khE=;
	b=asWfFxRFoUDEHq5m8t+31YDcAICsOI/NtexRBnyXOzj3hzptv33mNRYeudABNHgb3wjpn6
	B1E/NM8cL9tizPxQNVrBdqVC5owvLF4VckQwP4ytuc6R+gd2hOYAw+jEElCedOnBupJwzJ
	8pFC4EMeKzIolS6mf5UtJ2lwqbO4pqQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: install fd later to avoid race with close
Message-ID: <zk7izllch4omqrgbvh6jidpmotgcdpvt2qbajackgnk2kwl2l7@3ic2s6synqba>
References: <20240204075152.695920-1-minipli@grsecurity.net>
 <u2dylt3m7xymqtsgrqoqrbsbnmj5bgv3h6so35zwzgolazq22s@b3dk3zdesjuh>
 <55bbb92d-0d62-49c9-90de-b8955ade3cec@grsecurity.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55bbb92d-0d62-49c9-90de-b8955ade3cec@grsecurity.net>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 05, 2024 at 01:58:32AM +0100, Mathias Krause wrote:
> On 2/5/24 00:46, Kent Overstreet wrote:
> > On Sun, Feb 04, 2024 at 08:51:52AM +0100, Mathias Krause wrote:
> >> ]...]
> >> Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
> > 
> > The fixes line is wrong, but I'll take care of that - thanks!
> 
> No, it's not wrong. It's broken in the initial commit where this code
> was still living in fs/bcachefs/chardev.c:bch2_ioctl_data(). Commit
> 96f37eabe7a5 ("bcachefs: factor out thread_with_file,
> thread_with_stdio") only moved that code to where it is now, but it's
> still wrong before that. So I used the earlier one.

Oh hey, you did some code archeology - nice :)

I'll queue this up for stable then.
