Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDD3ECC
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Sep 2024 02:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727662614; cv=none; b=DBQ8e2FcPOE4Fu/EvVo7HvJ4+FBuPpP30WtDq9UK5SIVinMcrJDB9C6bYbxMTDHKhfCgePwOOKzRyw7UUR+2sqXkXHFrud607D0+JRIJbzB/nuLoO0zXBfkS+fQBMLAhKSeyyt6bXH8xeZKAlUF6N2ayssYPJymJ5r+gXEO5W6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727662614; c=relaxed/simple;
	bh=o3B0uOWls6xsGY9wVulMzDDE1YmV7y8MzwPjGyKBT48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iB9ejf4/Uh9fB4zTN1U9YzV+aqK0WNwZ8VEaVO1uR/F1YFOLRKfo3K0f3oAXdXNXNbflTHGS6eq7tIa67mSVRHfKolexjpsH8S50i0Dj5nZRTttlvAzj1sW1ej+IkCzHYyua9mk85BHpyvQLrP/YARlMiUZ1ojL0M1iE/i5r2uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YuTRUl0B; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YuTRUl0B"
Date: Sun, 29 Sep 2024 22:16:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727662610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VbEqWepXWG7Q45YXTdZt8bILPgK/debgqYwEOJCG6KI=;
	b=YuTRUl0BDI1KZ8afE8kEV0BP/OFfYBJddiPcb+AZvR283yhPrUICBJaR0uc3+9cmHZ76sq
	SLG4rkztCybSQcI7UkVjpR1omBcUN707P1Ui1hn0L/RZS0eOQIie4i+YXwBJJaP3QDZ6Al
	OBm0W6ZPrRiq0/Ot9qjpaYWq9bS9hlk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] bcachefs: rename version -> bversion for big endian
 builds
Message-ID: <4aywuhjiqls4aosrvk5cfobognm7vgrgxdqq3fxow4geruhzyq@tlr46fz6gicw>
References: <20240930003902.4127294-1-linux@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930003902.4127294-1-linux@roeck-us.net>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 29, 2024 at 05:39:02PM GMT, Guenter Roeck wrote:
> Builds on big endian systems fail as follows.
> 
> fs/bcachefs/bkey.h: In function 'bch2_bkey_format_add_key':
> fs/bcachefs/bkey.h:557:41: error:
> 	'const struct bkey' has no member named 'bversion'
> 
> The original commit only renamed the variable for little endian builds.
> Rename it for big endian builds as well to fix the problem.
> 
> Fixes: cf49f8a8c277 ("bcachefs: rename version -> bversion")

Thanks, applied
