Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839FE10974
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Dec 2023 22:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 6C2A8859139;
	Thu, 28 Dec 2023 23:29:20 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: deletion time of big files (was: Re: Questions related to BCacheFS)
Date: Thu, 28 Dec 2023 23:29:19 +0100
Message-ID: <1903513.CQOukoFCf9@lichtvoll.de>
In-Reply-To: <2210413.NgBsaNRSFp@lichtvoll.de>
References:
 <23311511.6Emhk5qWAg@lichtvoll.de>
 <20231118195024.qe2bjxeubhru3de5@moria.home.lan>
 <2210413.NgBsaNRSFp@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Kent!

Martin Steigerwald - 18.11.23, 21:57:50 CET:
> Interesting. Only thing regarding performance I noticed so far that
> deleting an almost 8 GiB large DVD ISO image file took a bit longer than
> instant, but I was using Dolphin on Plasma, so not sure whether this
> tiny delay was filesystem or GUI related.

Meanwhile I have a working BCacheFS test setup on my laptop. Currently 
with 6.7-rc7.

I can confirm on the longer than instant deletion times for almost 8 GiB 
large DVD ISO image files. It took 3,4 seconds for two of them.

It appears to me that there is some optimization potential hidden in that.

Best,
-- 
Martin


