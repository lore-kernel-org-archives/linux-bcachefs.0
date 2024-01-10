Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D4E2AE87
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jan 2024 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EoID9mrG"
Date: Wed, 10 Jan 2024 14:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704914042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JicB0YThknqZwJz5430ikBwdOlJpxupU/5Cft3AYk/c=;
	b=EoID9mrG+15+D2UDw0MUKbVcndl+S/gMp7+KovsuNQMCDRQRpTpOUbkWWzuNWYCd28QwIc
	mF5CB9Neejsd5ihCGWMTesafLgKkM8rV7BKcFUeTHy7/AbL4pQ6tOqde7oKp25ih5RKYcU
	flXOEVxiU0Zai6mkZeSTvGzWTIZDook=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: AP <lkml@inml.grue.cc>, linux-bcachefs@vger.kernel.org
Subject: Re: Error while unlocking encrypted BCacheFS: Required key not
 available
Message-ID: <4msliytwmws5zsxv2zbczxoce26bgxrmccpjphfvimcicwfipq@7hwgt4qvhozv>
References: <2312305.ElGaqSPkdT@lichtvoll.de>
 <1876799.tdWV9SEqCh@lichtvoll.de>
 <ZZ39La7UjQVwQ1aI@inml.grue.cc>
 <6010058.lOV4Wx5bFT@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6010058.lOV4Wx5bFT@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 10, 2024 at 03:18:55PM +0100, Martin Steigerwald wrote:
> AP - 10.01.24, 03:13:01 CET:
> > On Sun, Jan 07, 2024 at 12:27:29PM +0100, Martin Steigerwald wrote:
> > > In case this is an issue with Debian packaging of bcachefs-tools I can
> > > report there.
> > 
> > What version of bcachefs-tools are you using? The default one in
> > bookworm is v0.24 and is >1 year old and that may be the issue.
> 
> As I wrote:
> 
> "BCacheFS tools 1.3.3 – according to bcachefs version – from Debian 
> package bcachefs-tools 24+really1.3.4-2.".
> 
> > I'm starting to switch from btrfs to bcachefs and I backported v1.3.4
> > from sid.
> 
> That is where above package is from.

The keyring stuff has been a perpetual utter headache.

I've been debating rewriting that stuff to just pass a memfd handle as a
mount option and rip out keyring usage...

alternately - now that we're pretty much always mounting via the mount
helper, perhaps it would be a little bit less fragile if the mount
helper was adding the key to the keyring - that might be worth checking.
