Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DE250250
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 16:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X46Ywpos"
Date: Thu, 11 Jan 2024 11:35:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704990914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l6gbT4gh6LV/k2pVtoG9MGoIcymNauSM6dU4OTyDTQM=;
	b=X46YwposJRt0HVpmi4ZEC1RVOtscfGEww6d+1YJ1N6KujzAJCVYiO8J2WDSB+yaY6wqjk5
	L0IP761gTPtBZtToIe5+i5QkkNqS/j9E9hfOrhufZ8uGtSMlKFkxxhyzltk0oKqNE+l52R
	TT914AJUBmTtAoP0NejPgG4iTcFDu3Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: AP <lkml@inml.grue.cc>, linux-bcachefs@vger.kernel.org
Subject: Re: Error while unlocking encrypted BCacheFS: Required key not
 available
Message-ID: <vm333u3hnogd2fz4zk6g4rhkj7rwk27tv2iacacsyjctxkcpvo@bihvvnluk3em>
References: <2312305.ElGaqSPkdT@lichtvoll.de>
 <6010058.lOV4Wx5bFT@lichtvoll.de>
 <4msliytwmws5zsxv2zbczxoce26bgxrmccpjphfvimcicwfipq@7hwgt4qvhozv>
 <12360099.O9o76ZdvQC@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12360099.O9o76ZdvQC@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 11, 2024 at 12:58:26PM +0100, Martin Steigerwald wrote:
> Hi!
> 
> Kent Overstreet - 10.01.24, 20:13:59 CET:
> > On Wed, Jan 10, 2024 at 03:18:55PM +0100, Martin Steigerwald wrote:
> > > AP - 10.01.24, 03:13:01 CET:
> > > > On Sun, Jan 07, 2024 at 12:27:29PM +0100, Martin Steigerwald wrote:
> > > > > In case this is an issue with Debian packaging of bcachefs-tools I
> > > > > can
> > > > > report there.
> > > > 
> > > > What version of bcachefs-tools are you using? The default one in
> > > > bookworm is v0.24 and is >1 year old and that may be the issue.
> > > 
> > > As I wrote:
> > > 
> > > "BCacheFS tools 1.3.3 – according to bcachefs version – from Debian
> > > package bcachefs-tools 24+really1.3.4-2.".
> > > 
> > > > I'm starting to switch from btrfs to bcachefs and I backported
> > > > v1.3.4
> > > > from sid.
> > > 
> > > That is where above package is from.
> > 
> > The keyring stuff has been a perpetual utter headache.
> > 
> > I've been debating rewriting that stuff to just pass a memfd handle as a
> > mount option and rip out keyring usage...
> > 
> > alternately - now that we're pretty much always mounting via the mount
> > helper, perhaps it would be a little bit less fragile if the mount
> > helper was adding the key to the keyring - that might be worth checking.
> 
> So no suggestion what to try to make it work except for putting BCacheFS 
> unto LUKS? I wanted to get rid of LUKS for removable media. Often enough I 
> have "cryptsetup luksClose" complaining about still in use while I the 
> filesystem on top of it clearly got unmounted already. In these case BTRFS 
> still.

I just made a couple suggestions. I'm sorry if they weren't exactly what
you were looking for?

If you or someone else wants to help out by writing some code, I just
laid out what needs to happen next - but I'm not your free helpdesk
here, and you're expecting an imediate fix that's not how this works :)
