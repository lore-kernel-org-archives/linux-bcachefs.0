Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C341A1
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 15:15:21 -0800 (PST)
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 096908162B4;
	Sun, 19 Nov 2023 00:15:20 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Date: Sun, 19 Nov 2023 00:15:19 +0100
Message-ID: <4197014.1IzOArtZ34@lichtvoll.de>
In-Reply-To: <20231118210727.6s7bi3e4lldnrpoj@moria.home.lan>
References:
 <23311511.6Emhk5qWAg@lichtvoll.de> <2210413.NgBsaNRSFp@lichtvoll.de>
 <20231118210727.6s7bi3e4lldnrpoj@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Thanks again, Kent.

Kent Overstreet - 18.11.23, 22:07:27 CET:
> > As far as I understand one specific performance related aspect of
> > BCacheFS would be low latencies due to the frontend / backend
> > architecture which in principle is based on what has been there in
> > BCache already. I am intending to explore a bit into that concept in
> > my article.
> 
> The low latency stuff actually wasn't in bcache - that work came later.

So the frontend / backend architecture is not that much of what makes 
BCacheFS unique? Important to know as it seems I may have misunderstood 
something here.

I may need to shift the approach to my article a bit then. Good that I 
asked early on.

-- 
Martin


