Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD90F24A08
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 02:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724467687; cv=none; b=PZEXI7PuCBIdYwMEfUgAMNaEhl+8gXVFGmB3jPmDAJ6v3DN+pCyEKkiBetmstvMSQvC/hmIfTueh8ge20+fl8UI71sUQR6liZz6uv/iC163LidFkL7w5PhUEUxu2YPc/lWU7aeMsXAex3c/NX+9jWE3Ev1Cf45mER6N4A6ngKZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724467687; c=relaxed/simple;
	bh=P77CMaBCxeFgyeEkjyg1LdogAH6aim6Ij36MudyKEI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isiDTTaLdV6+fpO89o7/B9H4AviYQGcIiKwiF4sqn4mss4GRF3tc7YsAHtv0F+AEU3y5w7l29bh8smJpoPs+rE2Yk9Ok7HmnUOQcc+PmxyCo6V6yyzInjPmF7VlPN3zdUYWtbudEPfdi+Qo7awz2Cizx1bipcmycEzh4YNyXu4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oA0vfVH5; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oA0vfVH5"
Date: Fri, 23 Aug 2024 22:47:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724467683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HFh5z4SsCJ2YRCXtXivh0uhx4Lzf7rOdtR9N9dIwIH4=;
	b=oA0vfVH5vH2lA6quGQbSgS+MAcQoLLW3Yio0alBRbGAf/1ZUI0IysdZXXYY0mryAT1jkVP
	yq7qlBtANbEVuuWp2zZ77EYLx7rGql2vM/I7rK4z5VA/Hl/rDih209GHRC3WrvgGcywEUU
	Upincp/ohR9kmnZKrmXltIcLplhF6v0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5
Message-ID: <wdxl2l4h2k3ady73fb4wiyzhmfoszeelmr2vs5h36xz3nl665s@n4qzgzsdekrg>
References: <sctzes5z3s2zoadzldrpw3yfycauc4kpcsbpidjkrew5hkz7yf@eejp6nunfpin>
 <CAHk-=wj1Oo9-g-yuwWuHQZU8v=VAsBceWCRLhWxy7_-QnSa1Ng@mail.gmail.com>
 <kj5vcqbx5ztolv5y3g4csc6te4qmi7y7kmqfora2sxbobnrbrm@rcuffqncku74>
 <CAHk-=wjuLtz5F12hgCb1Yp1OVr4Bbo481m-k3YhheHWJQLpA0g@mail.gmail.com>
 <nxyp62x2ruommzyebdwincu26kmi7opqq53hbdv53hgqa7zsvp@dcveluxhuxsd>
 <CAHk-=wgpb0UPYYSe6or8_NHKQD+VooTxpfgSpHwKydhm3GkS0A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgpb0UPYYSe6or8_NHKQD+VooTxpfgSpHwKydhm3GkS0A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 24, 2024 at 10:35:38AM GMT, Linus Torvalds wrote:
> On Sat, 24 Aug 2024 at 10:33, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > What is to be gained by holding back fixes, if we've got every reason to
> > believe that the fixes are solid?
> 
> What is to be gained by having release rules and a stable development
> environment? I wonder.

Sure, which is why I'm not sending you anything here that isn't a fix
for a real issue.

(Ok, technically a few of those, the "missing trans_relock()" fixes are
theoretical, but if they are real then they're bad).
