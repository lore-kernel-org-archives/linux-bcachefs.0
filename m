Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03DB23AF
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Dec 2023 10:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 110BE85AD06;
	Sat, 30 Dec 2023 11:51:27 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject:
 Re: deletion time of big files (was: Re: Questions related to BCacheFS)
Date: Sat, 30 Dec 2023 11:51:26 +0100
Message-ID: <5752665.DvuYhMxLoT@lichtvoll.de>
In-Reply-To: <acpcgunii76iwukjkuqdx4q76ee3b4ohr5lcr5akcsjgscdsra@mxc5l4wlj7kd>
References:
 <23311511.6Emhk5qWAg@lichtvoll.de> <1903513.CQOukoFCf9@lichtvoll.de>
 <acpcgunii76iwukjkuqdx4q76ee3b4ohr5lcr5akcsjgscdsra@mxc5l4wlj7kd>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Kent Overstreet - 29.12.23, 19:48:55 CET:
> > I can confirm on the longer than instant deletion times for almost 8
> > GiB large DVD ISO image files. It took 3,4 seconds for two of them.
> > 
> > It appears to me that there is some optimization potential hidden in
> > that.
>
> Bug me again in a few weeks/months if I don't get to it; Dave's fs
> metadata benchmarks were also pointing out things that need to be
> opimized as well, this is probably related - but I'm going to be deep in
> the disk space accounting rewrite for a good while

Alright. All in due time. It is not that I have gazillions of such large 
files laying around or even the amount of storage capacity available. I 
intend to format an external 4TB NVME SSD with encrypted BCacheFS. And for 
testing copy over 1 TB of data from an external 2TB NVME SSD to it and see 
how that goes.

I am happy that BCacheFS went into the mainline kernel and I rather see 
things done right than fast.

Have a Happy New Year.

Best,
-- 
Martin


