Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7D042042
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Dec 2023 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 361A484BE5F;
	Mon, 18 Dec 2023 17:50:20 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Date: Mon, 18 Dec 2023 17:50:19 +0100
Message-ID: <5751811.DvuYhMxLoT@lichtvoll.de>
In-Reply-To: <2272887.iZASKD2KPV@lichtvoll.de>
References:
 <23311511.6Emhk5qWAg@lichtvoll.de>
 <20231119231001.tb3teva5j4azqp7i@moria.home.lan>
 <2272887.iZASKD2KPV@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Martin Steigerwald - 03.12.23, 17:58:36 CET:
> > I believe so - I have not tested hibernation specifically.
> 
> Today I tried with 6.7-rc4 and the issue of non working hibernation does
> not seem to be related to BCacheFS, cause the module was not loaded and
> it again did not hibernate.

Finally.

6.7-rc6 does hibernate again. How awesome is that?

However bcachefs-tools package

https://bugs.debian.org/1057295

is broken regarding mounting via mount command unless one moves

mount.bcachefs out of the way :)

Then it mounts okay. And also with mounted BCacheFS hibernation still 
works.

So that obstacle is gone.

Best,
-- 
Martin


