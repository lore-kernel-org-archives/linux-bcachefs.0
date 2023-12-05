Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vlq5eoHQ"
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [IPv6:2001:41d0:203:375::bc])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE213CE
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Dec 2023 20:55:23 -0800 (PST)
Date: Mon, 4 Dec 2023 23:55:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701752122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DalfH2rgAcD/bwZb6Yo032ctkov4QXdhPwXLALYf4QI=;
	b=Vlq5eoHQDEdxoNJhm5qn78tDsUjgN8JltNdOaz/xBMe6iF+m7weVVNP15VHGaOvnqBIMI4
	vQNGtikGoEvWg1Vy+A7AeT7LQgfsJ3/AeaZJmJqNLgw+WxQS7EshzdrSzA0Oad0thki4u8
	aozhOQCD9NHPXb6pbnd4yKlc8BshAGM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Donald Buczek <buczek@molgen.mpg.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Stefan Krueger <stefan.krueger@aei.mpg.de>
Subject: Re: [bcachefs] [bug]: missing subvolume 0
Message-ID: <20231205045518.5qje7doafm2fjroa@moria.home.lan>
References: <5cc5076e-3a85-48e2-b75f-a3d1021f531e@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cc5076e-3a85-48e2-b75f-a3d1021f531e@molgen.mpg.de>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 04, 2023 at 12:03:26PM +0100, Donald Buczek wrote:
> Reporting to maintainer.pl list, hope that's correct?
> 
> Probably, this is a trivial one:
> Linux 6.7.0-rc4.

now fixed in the bcachefs-for-upstream branch, will be in
for-next/master shortly
