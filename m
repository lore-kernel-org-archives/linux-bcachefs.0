Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1934D7
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Dec 2023 08:58:39 -0800 (PST)
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 95DB182DD46;
	Sun,  3 Dec 2023 17:58:36 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Date: Sun, 03 Dec 2023 17:58:36 +0100
Message-ID: <2272887.iZASKD2KPV@lichtvoll.de>
In-Reply-To: <20231119231001.tb3teva5j4azqp7i@moria.home.lan>
References:
 <23311511.6Emhk5qWAg@lichtvoll.de> <2273246.iZASKD2KPV@lichtvoll.de>
 <20231119231001.tb3teva5j4azqp7i@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Kent Overstreet - 20.11.23, 00:10:01 CET:
> > I got two setbacks regarding trying BCacheFS on my laptop yesterday
> > and
> > today:
> > 
> > 1) Linux 6.7-rc1, as mentioned almost rc2, did not hibernate on
> > ThinkPad T14 AMD Gen 1. It just blanked screen and nothing happened.
> > So I went back to 6.6.1 temporarily. I do not really intend to do a
> > git bisect between rc1 and 6.6 on a production laptop. It would be
> > very time-consuming and possibly be dangerous. I may go back to 6.7
> > even without hibernation, just using standby over night for a while.
> > I bet BCacheFS is compatible with hibernation (as in writing memory
> > contents to encrypted swap and resuming from it)?
> 
> I believe so - I have not tested hibernation specifically.

Today I tried with 6.7-rc4 and the issue of non working hibernation does 
not seem to be related to BCacheFS, cause the module was not loaded and it 
again did not hibernate.

-- 
Martin


