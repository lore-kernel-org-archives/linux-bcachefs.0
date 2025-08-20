Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7372B2D23A5
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Aug 2025 02:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755657112; cv=none; b=pFOjwIAtMmLL+ochyQF8Akj/jQ7CW+6CVljT77PWTQcJ+QH2947tfq1876csuYuiFoVU0Dc3GRU5+oNqLRB/deTmbyoRpoVfzaPvLsQSE9ABReTTygbTRN1BjHiiuFWeIQd6ggDUxE02c/FUICkIRamAlBNQHCt+JLCl4bq46x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755657112; c=relaxed/simple;
	bh=ORc9tRVvojOBcH/VtOqvko6ihkFV9iDokJseo8edE2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4ftSp3dVSzqFsWhOHBbiMton0+RaehnA3DNENChQOMlWF9sHot8Lh7c04rRtrHsm1gqfcq8FCYmHdcOR8NckzqW3EEU7/uKk0Z1p4TC2ghh0endFoNVvgSq0SQX6FdRN/c3k6OhrwyVQX3QPLSqDWBpcT6RvNuWAc+TydFxfXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mjyPRuLT; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mjyPRuLT"
Date: Tue, 19 Aug 2025 22:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755657107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xdNoYOWseUjSCiwteKAQBa/K3+p7f9hufOZBy2h3244=;
	b=mjyPRuLTBRd+fdwWze7SoG4Pb1N3iu5ug5Eg7bZF7+b7H33TOH7Xc8ilj1ymd5pOBgBtUf
	0msDywFXUim+sUltL92/ZfeGpcHZYtajOBzIzqdsi9TtL7/yi2XN9X0seqTL2DV+cSKpVq
	+hVEz7Zqq5EGYY+eEj9FlbvAeVrIwmY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Documentation <linux-doc@vger.kernel.org>, Linux bcachefs <linux-bcachefs@vger.kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: bcachefs: Add explicit title for idle
 work design doc
Message-ID: <yyqgq3brwrstiaqydzv4ua5syesrg4gh7w4uhtwg3flhuxa4ji@7xciwgaluwux>
References: <20250820002218.11547-1-bagasdotme@gmail.com>
 <p7ocizi2jg36uvk64yy5mv5bzg3dyrvnosz5mhj5j373tzr7iz@txx5juyvhwzf>
 <aKUy_1IYtlKtLEbK@archie.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKUy_1IYtlKtLEbK@archie.me>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 20, 2025 at 09:29:19AM +0700, Bagas Sanjaya wrote:
> On Tue, Aug 19, 2025 at 09:08:22PM -0400, Kent Overstreet wrote:
> > > -Idle/background work classes design doc:
> > > +Idle/background work classes desiderata
> > 
> > .....
> > what's going on with that spelling?
> 
> I'm just suggesting a better title, though. Should I keep it or revert back
> to design doc?

Revert back to design doc, please.

(I genuinely had not seen that word before; usually prefer to keep
things simple).
