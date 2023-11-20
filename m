Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U8xX770V"
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D916FD9
	for <linux-bcachefs@vger.kernel.org>; Mon, 20 Nov 2023 12:13:07 -0800 (PST)
Date: Mon, 20 Nov 2023 15:13:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700511186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/aupNkGHfYxShIJnBuOFBQ8NxV15JjssTzLaaldl7cI=;
	b=U8xX770VKiqrZSaE02xjyJ8lQhTG2drha0/KdJsylMuKYZg5B8Ji549UqUCsmoKuZJwMdR
	0Q5sH7rVrNk0QNbrYIFdmevnQiPLQU7mcezqceubf+12yfkxBMMcZnWMz+QSlh7jZquR/A
	KFpOIbipJyuYgQ3PJgzwPbR7XwTJnWs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Finn Behrens <me@kloenk.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATH TOOLS] nix: add bcachefs-fuse package
Message-ID: <20231120201302.epj6p66aplkmdxnw@moria.home.lan>
References: <20231119211314.301361-1-me@kloenk.de>
 <20231119232000.rlvnbt254y2hl32l@moria.home.lan>
 <862316D3-1894-4BCD-8397-4FCA522AABE5@kloenk.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <862316D3-1894-4BCD-8397-4FCA522AABE5@kloenk.de>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 20, 2023 at 09:16:04AM +0100, Finn Behrens wrote:
> 
> 
> On 20 Nov 2023, at 0:20, Kent Overstreet wrote:
> 
> > On Sun, Nov 19, 2023 at 10:13:14PM +0100, Finn Behrens wrote:
> >> Add a fuseSupport argument and bcachefs-fuse as flake output with fuse enabled.
> >>
> >> Signed-off-by: Finn Behrens <me@kloenk.de>
> >
> > We can't do this just yet, not until the fuse support is getting more
> > attention; it's been frequently failing to build lately.
> 
> This just adds a second output, the default is still building without fuse, but with this you can easily let nix build with fuse support.
> As there is no sort of nix CI as far as I’m aware, this should also not block anything.

Ah, ok - I'll apply it then.
