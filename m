Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192B015AD9B
	for <linux-bcachefs@vger.kernel.org>; Sat,  7 Sep 2024 17:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725728699; cv=none; b=XxsYDsML0kxAMurXHiKF2SOueVh0c/rSGJdjwwrkLDbWUIs8KixGiYyzyi6kJuvUpCmU6gU+ja/1/SknWQ/4txZCKszbI+CnzfKpiiNaL4WvgjFyt5sgpMZEqcrn55deOsZMGFutRyhVLINgDBY/r/qV4U6vbm3XdMwzMyKyuw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725728699; c=relaxed/simple;
	bh=ORKqNRQEJbh3hYA6p46yVoiiV3Civhz86GC8gnQlZEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPkGwPr6L8MeKHUwZwQ7ue2uUm6zQk6zLW+AYwjfo1QW8hi/iTXmwwbZaS6nk3vnGG+6RDxS3dXbiDIBdynSeHsqpmALRYrfI/JpXS2pvaKPEwv6y1UnD5QG6vwyyoJGf6o5TlEGpYjgJ2SQB6EJVbtQ8puRXjy2X5LeVIUu60g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RfHmMwa/; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RfHmMwa/"
Date: Sat, 7 Sep 2024 13:04:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725728694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ofjB7t1Kdp6/mJ2/+OPdnvQvYH/QmfkD8+jlSOcEQnw=;
	b=RfHmMwa/myMuODAxcjjJbZqlT7e/QhGFfMdkmpI1wdf64pM7QF2DEjhdwfhZxs2WBMEqvi
	frdi6QKVNlbTNWK7ovJwuvjZZnyFsRqWw2y4UCmX4zPCw14UxpoWnItuUwi5d0sZ6zJznv
	Agw7RF4ug8AvbgghMT75aNs7QaTwP7Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alyssa Ross <hi@alyssa.is>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Erin Shepherd <erin.shepherd@e43.eu>, 
	Ryan Lahfa <ryan@lahfa.xyz>
Subject: Re: [PATCH] bcachefs: Fix negative timespecs
Message-ID: <n7mhniclwckv7jxu6zwbk5xs5ig7w3eka3j54ioxi4uaha2k2q@tammak7sbrgk>
References: <20240907160024.605850-3-hi@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240907160024.605850-3-hi@alyssa.is>
X-Migadu-Flow: FLOW_OUT

On Sat, Sep 07, 2024 at 06:00:26PM GMT, Alyssa Ross wrote:
> This fixes two problems in the handling of negative times:
> 
>  • rem is signed, but the rem * c->sb.nsec_per_time_unit operation
>    produced a bogus unsigned result, because s32 * u32 = u32.
> 
>  • The timespec was not normalized (it could contain more than a
>    billion nanoseconds).
> 
> For example, { .tv_sec = -14245441, .tv_nsec = 750000000 }, after
> being round tripped through timespec_to_bch2_time and then
> bch2_time_to_timespec would come back as
> { .tv_sec = -14245440, .tv_nsec = 4044967296 } (more than 4 billion
> nanoseconds).
> 
> Cc: stable@vger.kernel.org
> Fixes: 595c1e9bab7f ("bcachefs: Fix time handling")
> Closes: https://github.com/koverstreet/bcachefs/issues/743
> Co-developed-by: Erin Shepherd <erin.shepherd@e43.eu>
> Signed-off-by: Erin Shepherd <erin.shepherd@e43.eu>
> Co-developed-by: Ryan Lahfa <ryan@lahfa.xyz>
> Signed-off-by: Ryan Lahfa <ryan@lahfa.xyz>
> Signed-off-by: Alyssa Ross <hi@alyssa.is>

Thanks! Applied
