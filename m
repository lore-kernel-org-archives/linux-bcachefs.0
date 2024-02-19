Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C940208A8
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 07:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708326207; cv=none; b=Mg2Qh0+IYPNDoXmK1YGEOyDtfbHnbsMgo5KN4DgfhdVz4IvjefZDEEBxP+P0Aclu5u2TtkZX47wCtBxj2Ox7vE+Jf903pAkoPT1b6ul5sksvU04mtQIUtqLT+WryX4U5CjmAz09J3cc0UJ/YzLACnztLhV8rU02LJjpqNNsgMPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708326207; c=relaxed/simple;
	bh=rOrA6ifat4XceKRSaRHm9EZkKqppQO4QQj76Wrf2y1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUuJ6Glw9phJ+7MiOkwcx1WjnVXGQQ3UQn0S0qxRVQgb7GyBFItWw+hAAE4ybL1LOvXVYq4ZwNZFaWBXxmaRpunIiz9jUsvunD1VY5L8NFXT8gKV1biFWwntdiTKfgqisnMuBHOtyEk9nMc4bOjWaspevjqvw5LnTB+QOwB87XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bSKh3H6V; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bSKh3H6V"
Date: Mon, 19 Feb 2024 02:03:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708326201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ls4QLHROp2Iu044pULFDmEBTXIPZzT70/7ZfYupo1PM=;
	b=bSKh3H6VbKdeZ4gYQyyGgAamYWNQK3oc8GaxIz3apOnuaNRPIIOFe7uWRUiakPd7bq/3Ge
	Iltq8J8mVD+GFwdzgEHwrNUNAfm+7Js3OhdBFROj0nCw5k31L0rYo1UhG5zQ1ZuFtTo9Bc
	RoTMZUMiMmEFQvpydIOPkBAPLyyLdrY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, 
	Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, 
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH] arm: Silence gcc warnings about arch ABI drift
Message-ID: <mtelhhn3z7qfo35odeb37doe3pqagesju46awcjnsyhq4xdk7t@ufoyklpskiyf>
References: <fe51512baa18e1480ce997fc535813ce6a0b0721.1708286962.git.jcalvinowens@gmail.com>
 <431dd956-ad31-4da8-ad42-34f7380824bb@app.fastmail.com>
 <ZdL7_-2VCJqjn634@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZdL7_-2VCJqjn634@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Feb 18, 2024 at 10:58:07PM -0800, Calvin Owens wrote:
> On Monday 02/19 at 07:21 +0100, Arnd Bergmann wrote:
> > On Mon, Feb 19, 2024, at 05:09, Calvin Owens wrote:
> > > 32-bit arm builds uniquely emit a lot of spam like this:
> > >
> > >     fs/bcachefs/backpointers.c: In function ‘extent_matches_bp’:
> > >     fs/bcachefs/backpointers.c:15:13: note: parameter passing for 
> > > argument of type ‘struct bch_backpointer’ changed in GCC 9.1
> > >
> > > Apply the arm64 change from commit ebcc5928c5d9 ("arm64: Silence gcc
> > > warnings about arch ABI drift") to silence them. It seems like Dave's
> > > original rationale applies here too.
> > >
> > > Cc: Dave Martin <Dave.Martin@arm.com>
> > > Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
> > > ---
> >
> > I think these should be addressed in bcachefs instead.
> 
> That seems reasonable to me. For clarity, I just happened to notice this
> while doing allyesconfig cross builds for something entirely unrelated.
> 
> I'll take it up with them. It's not a big problem from my POV, the notes
> don't cause -Werror builds to fail or anything like that.

Considering we're not dynamic linking it's a non issue for us.
