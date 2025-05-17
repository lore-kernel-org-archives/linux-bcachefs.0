Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39BF249F9
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 15:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747494281; cv=none; b=W8DUnrGym6TjiZQoVYswXBVUvLxc3EGHzMJWVN6nbkUYIc5E4SyiAEsYR1QOXHO0NuU/5ImezbHc2CoM8ZfaGoNIsFj3Oc0p/9T4M48UAwPCSDwkIW9SFdSsFD3lDHPwSYmfVY7giQojX0psn5GnuWajBc0m/GROJf1uB+6jOBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747494281; c=relaxed/simple;
	bh=iKJtnFa0pxlGO94XS5+97uMQZqqxIwiDlv+UBANowrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l5YvuAX23XiPMqFoAjoSCF8KGf7i6Tj/NwLcu/z76UjwiOrXfHJHLrPeOswOw+LAZeUM22aDXu6Qumib+xtMnHA7Cp1ORbloS5ccaw7iTfH/ub3wptqQtK13ehvpgzu9YW7A7EEcm072PHlKrzKPHX4F3xt/Qo+GxTivXk327ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gaSqCzBw; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gaSqCzBw"
Date: Sat, 17 May 2025 11:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747494275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LdQFmXkiUaLDyFfHDVxeiZAMeG/qWG/oQ4QbM3zCF/s=;
	b=gaSqCzBwP606jQ/JtNndDfeb2D8LQj4CxtiO1eHooYBhWW46L/hqOrLS+GJ4sxdFpwYKRH
	QyrRLih9AvslUwoXUuggm6z8bzpHbrmWMUVfWRGqX/lpU3GhLMyc4lj3M0E1UyVA3spyBL
	P/dr+fBiNivPiQivN1qiSlcXDbHTAiI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Malte =?utf-8?B?U2NocsO2ZGVy?= <malte.schroeder@tnxip.de>
Cc: Pavin Joseph <me@pavinjoseph.com>, 
	Martin Steigerwald <martin@lichtvoll.de>, linux-bcachefs@vger.kernel.org
Subject: Re: Status of rebalance and scrub support
Message-ID: <qmuquecmaljpmmullubtsw2bflzspmtwp2u4ffdcrbvyoro6lh@arpwh7rlc5jl>
References: <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
 <4984817.GXAFRqVoOG@lichtvoll.de>
 <7d4de775-2fd3-4edb-8c24-bd1736a4df89@tnxip.de>
 <5890559.DvuYhMxLoT@lichtvoll.de>
 <dc1fd78f-57fc-4659-a27f-0eb2904668ab@pavinjoseph.com>
 <21f52b7b-d351-4292-a20c-309729795dd9@tnxip.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21f52b7b-d351-4292-a20c-309729795dd9@tnxip.de>
X-Migadu-Flow: FLOW_OUT

On Sat, May 17, 2025 at 02:21:34PM +0200, Malte Schröder wrote:
> On 17/05/2025 14:18, Pavin Joseph wrote:
> > On 5/17/25 4:11 PM, Martin Steigerwald wrote:
> >> So seems since 6.15 there is scrub support :)
> >
> > That's wonderful news!
> > Could you check if rebalance is also working in 6.15?
> >
> > Thanks,
> > Pavin.
> 
> If by "rebalance" you mean equalize the amount of data between drives
> (like btrfs): No, it can't do that at the moment. There is a thing
> called rebalance on bcachefs, but it does something different (I think
> it moves data between tiers).

I was thinking about renaming "rebalance" to "background_data".
