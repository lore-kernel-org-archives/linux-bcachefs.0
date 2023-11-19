Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9548AC2
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 08:43:59 -0800 (PST)
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id B015B816F86;
	Sun, 19 Nov 2023 17:43:57 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Date: Sun, 19 Nov 2023 17:43:57 +0100
Message-ID: <2325258.ElGaqSPkdT@lichtvoll.de>
In-Reply-To: <2273246.iZASKD2KPV@lichtvoll.de>
References:
 <23311511.6Emhk5qWAg@lichtvoll.de>
 <20231118234205.24nzm7liawamgxhx@moria.home.lan>
 <2273246.iZASKD2KPV@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Martin Steigerwald - 19.11.23, 12:13:29 CET:
> Maybe I need to continue testing BCacheFS on a virtual machine, but I'd
> really love to have a BCacheFS filesystem on my laptop and actually
> really using it for something. Well I am going to leave it at that and
> probably research on this after the weekend. Now it is time to have a
> Sunday off.

Well will stay away from that 6.7-almost-rc2 kernel on this laptop for now 
after having had experienced and recovered from:

parent transid verify failed + level verify failed

https://lore.kernel.org/linux-btrfs/9221302.CDJkKcVGEf@lichtvoll.de/T/#u

Not sure what caused it, but for now it appears to me that it is not safe 
for me to run this kernel on this laptop.

-- 
Martin


