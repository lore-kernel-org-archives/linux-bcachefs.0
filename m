Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1F4126BF0
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 09:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729416596; cv=none; b=YnOjT3tpEPGYARdYwnuNvno4e1qKEccTT9JSNu6hlFY64qUeefz59tn2gJbABIe7Q8gGP/FJhi66mC2AzC0gNY2BlhcsiEV4U/DzJ5LF1AJKCm4EC71I0Q0nyg9qFsx8T5rwZVVrl8ZLn9iX8rCRZC4ZOHGIniiFsGydvA3btYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729416596; c=relaxed/simple;
	bh=ibU0ePmRISBu23TdoKGFrIMtUnFlOloAXAx6NIu90pI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOuc/cbWpK667Cd2TDlcj1ea/nImlo/ftmi1xij8ZQpMCm5MeN7gvluI22h/LN4XoHahDpzJfFIVTiy+dNAl10wLZ8Xogwv06vlSkvK94IDFYVMZWceQcMKMDGeODkEMo9xN6neQJNJqXA0hcYrCfdjh+MWDDfMYo0m/7utpn1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eUyI6pw9; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eUyI6pw9"
Date: Sun, 20 Oct 2024 05:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729416591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=17RUvNAUhNtNfROrKldrv42OaIsNagLybFcYwszHx2U=;
	b=eUyI6pw9sVjzFLRGEPC1ZcFmyHXXlorAKPyYpMefa9gX7om2JcCCIAYX47+CiPqwEk8rsn
	jskLEyLcXCui5xloUcug2qHHcKmfFL6SbtYJ4EBkqXXPOUIhzaOZaLxsVa3d497ubdnluu
	QrMEqIAaP+zftxuSPOZpaEWPDcvH9w0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: Martin Steigerwald <martin@lichtvoll.de>, 
	Malte =?utf-8?B?U2NocsO2ZGVy?= <malte.schroeder@tnxip.de>, Christopher Snowhill <chris@kode54.net>, 
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Another bcachefs version downgrade bug
Message-ID: <yevz2oc23574bvu2z65iv55gvdlkq3fer2pwseiiwpo5c6bhdw@aj4wa3rqko2h>
References: <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1249157619.1105.1729296906241@mail.carlthompson.net>
 <1af6fd38-7ecf-451a-9be3-fa7b9447fa43@tnxip.de>
 <4958287.GXAFRqVoOG@lichtvoll.de>
 <1711880898.1172.1729330193274@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1711880898.1172.1729330193274@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 19, 2024 at 02:29:53AM -0700, Carl E. Thompson wrote:
> I reported the bug because it's a bug that I hadn't seen reported or referenced before. I didn't know at the time I reported it that it had already been fixed. 
> 
> I actually **still** don't know that the bug is fixed in current versions. What Kent said is that "6.10 works" which isn't quite the same thing as saying that he previously found and fixed the bug. He could have meant that he knew about and fixed it or he could have meant that there have not (yet) been any on-disk layout changes since 6.10 that would trigger the bug. Looking at the 6.10 pull requests I don't see anything in Kent's description of the changes there that suggests that this bug was known or fixed then unless it's the bch2_sb_downgrade_update() fix that went into rc5 but wasn't described. Maybe Kent could clarify?

Yes, the bug has been fixed.
