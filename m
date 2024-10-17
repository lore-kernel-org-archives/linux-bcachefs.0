Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1074B1D9665
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Oct 2024 10:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729159996; cv=none; b=mELCaPcc/WOi5HDYa78+cRSw3e0nJfEj1WnaFKM/Qzdsy9vQOQ0XUCEHEe7/S8wrHqyosIZN/nlpYLeklH5z5HnCwA2gISlif8aKESoA6szw3qOG1ee5/DTM/cDZts2wXvwk/zP/JliOkN6eO1W7jPeEpmJpm7DV3IDT68UFY1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729159996; c=relaxed/simple;
	bh=8y8XS33kw784rXiPMljqvZZ326geOij0mhpx1C9LVZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mtI2vnX7Gfva/Jt8YHkc3z2dkcjv1EOlQtFz3Kp/QpdIVt5BPX/2effF3r8KgDdyfzzSjTR0e7F3S3g18U05nBs3WukA15EJRJFFWoDUx13P8YYzRIxitY4dzwyGQXyC6/5xgC30PtAeSvHE+PLnYPnhYn0+qgfdanje1/O64sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kltZe2+Q; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kltZe2+Q"
Date: Thu, 17 Oct 2024 06:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729159990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=USc98QDbvn5RcAVKn8dfBgZlAqxg/iLcm6zNI5OMaDM=;
	b=kltZe2+QfP4KrEJOcg+bDnfE5HTkOzF0A8P/yHkFcgAgMm0vb7l3/VG8ZI7TLTBqagHnoW
	d/bLNL/rOGSc3By8RMwzWkm8UHastn68ZGjTWFAccq3sQv3ENH/1RVLZldmjhYPDY4khm2
	B8axmbpe6i7EUPgnh96TwM9gNMt7tF8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Another bcachefs version downgrade bug
Message-ID: <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
References: <873903780.802.1729054276600@mail.carlthompson.net>
 <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <884724407.902.1729158319260@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <884724407.902.1729158319260@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 17, 2024 at 02:45:19AM -0700, Carl E. Thompson wrote:
> 
> > On 2024-10-17 2:30 AM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > ...
> 
> > Honestly not warrented at this point, things have been stabilizing fast
> > and I'm likely 6 months or so from taking the experimental label off.
> 
> Remember the 80/20 rule. I suspect that may be (should be) further away than we might like.

Carl, I'm happy to fix bugs that you find, but the attitude and the
unnecessary advice - that I don't enjoy.
