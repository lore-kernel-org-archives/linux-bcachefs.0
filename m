Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57901EF1D
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 03:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725160800; cv=none; b=i4fFXnR95SRbbMeEhfC6a4lCOwPxelYyEqXAzduKBfwnEsZC+twMglHnmHPLkMHoWPgA8UyrmIHSW2/emrhkZebyH2PEWfRlNxOiE0D31mI57dR3XGEyEmS81i9x1fhs7RhUlJDSHkq9m1MIQqCbq696ux2QVP00KIbCK50r7yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725160800; c=relaxed/simple;
	bh=eEKGFPZn+mcvIGbGPKW//84loGAn38n7uJhvNjUO5ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q10i+b8dSf/eqtInislLaGX6m8TLKDOsoqJlc3W0Kitl3LsP2JPhSWRJPWo9woChclKLbco2fT5nNygz6NcR+xdhhF231kDuJNXdM2V2sJTuJu/K91eNEQG/Yt4dUiKDuBlYar2TpPNpu70uZsniECIgCeXkYitX+Fsw0XQ/bh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZdsiKNQD; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZdsiKNQD"
Date: Sat, 31 Aug 2024 23:19:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725160795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=onyCyY/fDcRq738DRxbYc5Iqor6psTXLWoZNQ3KP0j8=;
	b=ZdsiKNQDQATjq/p7UZIVTAOBXfBujpGNstsWH+vp3D0GdmtgbEA9ElTAvslot63NBBkA1D
	tvaagau6Y1uwH1ksnhrl0veB4T3jC2mb3QLbux5gXj2eSdLhFy9I7kKG7Edx9gL8nYRjsT
	bWTyJ0rxB58incJVq+VHO2SzVcPOnOo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc6
Message-ID: <5q6h447wzxlskkvgygm3xb2tasbbgmmtxsxd6m4jtygpwsf47b@hxdqfn3nxqzo>
References: <erydumpfxcjakfllmh3y4d7wtgwz7omkg44pyvpesoisolt44v@kfa4jcpo7i73>
 <CAHk-=wjBNzWL5MmtF86ETJzwato38t+NDxeLQ3nYJ3o9y308gw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjBNzWL5MmtF86ETJzwato38t+NDxeLQ3nYJ3o9y308gw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 01, 2024 at 03:13:39PM GMT, Linus Torvalds wrote:
> On Sun, 1 Sept 2024 at 14:44, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> >   git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-08-21
> 
> Hmm. Your git host is often slow, but now it seems to be even worse than usual.
> 
> I blamed my phone hotspot at first, but everything else is fine.
> 
> evilpiepirate.org takes a few minutes, and then I get a "Connection
> reset by peer" error.
> 
> Maybe kick that machine? Or even just use something like a github mirror?

odd, everything looks quiet on it, but it was acting funny earlier today

I do have a github mirror though: 
https://github.com/koverstreet/bcachefs/ tags/bcachefs-2024-08-21
