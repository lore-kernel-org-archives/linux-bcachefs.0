Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D05E268C55
	for <linux-bcachefs@vger.kernel.org>; Tue, 20 May 2025 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747759750; cv=none; b=LBUApBWF0UFddXIOWbJmuPsgkNXNBC4n5k/vnhE0X1swHtJ6HjtaS8WRNYKkSrn1yBeQNjxh1wefXClJouHBoEdteHswD640m3Xo1cLDAHn05u03BmnpC+FgaKe3uZ/7dHhHw9UqBLS+DK9CJ89+1tz8r5NeslBqe25d1pPmmQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747759750; c=relaxed/simple;
	bh=TwWBWHtLJiGnl+ba1IbyUNOwdU5qwSPWkEpJGmeH988=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lSblG8fEnsYOp+cq4HHDUEFjLafx2Z+9lBsq9Miy7g1euhw+7dDc0PJhFgj3UkxOa1IqVK0DCItHrRjmoZ1ayS3CJSHPWRBKyL93GDKXtPAjipznIqG/1OKARNKiMowipTLGF988c29k5l+VPLPtCjwcvcaXu5UyGXE6D4D4a2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mB4Gqio8; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mB4Gqio8"
Date: Tue, 20 May 2025 12:49:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747759744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aa/ZOXEJzVJQIkfNq8IATu9TqYY/TOwRVU2kZmkq7Y8=;
	b=mB4Gqio8hBnmpGMR9w7uC18TCXyHHrMnpmStB/SYYwxPrPJWklZbUmfH9q5Rrc9GCiimq2
	ghn22JflydMSmIV6KT/P5Y0oDrvoFDSi75puuZECo+/QY0bJadg8haPxMghlzoRX4VOz2W
	WGsftI1qokDQrcLkwWp5ejqAjUoxm7U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/6] overlayfs + casefolding
Message-ID: <6lveeao4ensfyaj4zzvyxaqhzybzbnzlk3fhae5sb2ejtzzquw@2cy3fuliwh5l>
References: <osbsqlzkc4zttz4gxa25exm5bhqog3tpyirsezcbcdesaucd7g@4sltqny4ybnz>
 <CAOQ4uxjUC=1MinjDCOfY5t89N3ga6msLmpVXL1p23qdQax6fSg@mail.gmail.com>
 <gdvg6zswvq4zjzo6vntggoacrgxxh33zmejo72yusp7aqkqzic@kaibexik7lvh>
 <CAOQ4uxg9sKC_8PLARkN6aB3E_U62_S3kfnBuRbAvho9BNzGAsQ@mail.gmail.com>
 <rkbkjp7xvefmtutkwtltyd6xch2pbw47x5czx6ctldemus2bvj@2ukfdmtfjjbw>
 <CAOQ4uxgOM83u1SOd4zxpDmWFsGvrgqErKRwea=85_drpF6WESA@mail.gmail.com>
 <7sa3ouxmocenlbh3r3asraedbbr6svljroyml3dpcoerhamwmy@gb32bhm4jqvh>
 <CAOQ4uxjHiorTwddK98mb60VOY8zNqnyWvW=+Uz-Sn6-Sm3PUfQ@mail.gmail.com>
 <ztuodbbng5rgwft2wtmrbugwo3v5zgrseykhlv5w4aqysgnd6b@ef56vn7iwamn>
 <CAJfpegs1AVJuh1U97cpTx14KcnQeO2XmtvrOwbyoZ8wvqfgqPA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegs1AVJuh1U97cpTx14KcnQeO2XmtvrOwbyoZ8wvqfgqPA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 20, 2025 at 06:40:35PM +0200, Miklos Szeredi wrote:
> On Tue, 20 May 2025 at 17:21, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > Docker mounts the image, but then everything explodes when you try to
> > use it with what look to the user like impenetrable IO errors.
> >
> > That's a bad day for someone, or more likely a lot of someones.
> 
> Wouldn't it be docker's responsibility to know that that won't work
> with overlayfs?

Why would it be?

> Any error, whether at startup or during operation is not something the
> user will like.
> 
> What am I missing?

A _mount_ error due to misconfiguration is expected operation, and we've
built mechanisms for reporting those errors in a way that users can
understand what's going on.

That's not true for normal file accesses post mount.
