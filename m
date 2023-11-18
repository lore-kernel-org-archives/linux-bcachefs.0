Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Greylist: delayed 432 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 18 Nov 2023 11:23:05 PST
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826D012B
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 11:23:05 -0800 (PST)
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id B64CD815BF8
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 20:15:50 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org
Subject: Questions related to BCacheFS
Date: Sat, 18 Nov 2023 20:15:50 +0100
Message-ID: <23311511.6Emhk5qWAg@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi!

Awesome that BCacheFS is finally merged! Many thanks to everyone who made 
this happen. I appreciate it!

I am writing an article about BCacheFS. I am willing to provide a link 
once it is published. It will be in German language.

I do have a few questions:

1) Is discard supported? fstrim says it is not. However /sys/fs/bcachefs/
UUID/options/discard shows "1". BCacheFS User manual Principles of 
Operations mentions it at a device option. I am not completely sure how 
these work. Auto-detected and just IOCTL for fstrim missing?

2) What are the plans for scrubbing? Right now it is not yet implemented, 
right?

3) Is the documentation of mount and other options in
https://bcachefs.org/bcachefs-principles-of-operation.pdf complete? If 
not, care to elaborate what is missing?

4) What are the plans or ideas for documentation? I specially ask as there 
does not seem to be a manpage like mount.bcachefs or mkfs.bcachefs yet. 
There is no mention of bcachefs in mount manpage either. And no bcachefs 
manpage in section 5 like with btrfs or xfs. There is a bcachefs manpage 
in section 8 which for example for a complete list of mount options refers 
to above Principles of Operation user manual. And it has information on 
"bcachefs format" and some other sub commands. I bet it is still too early 
or maybe you have different plans on how to go about documentation. 
Anything you can share already regarding this?

5) Is the feature implementation status on bcachefs.org up-to-date? How 
about the one in Principles of Operation user manual? Is any of these more 
up-to-date? If anything is missing from these, care to elaborate?

6) What is the status for xxhash checksums? They are mentioned as an 
option in the output of "bcachefs format". Yet no mention of it in 
bcachefs manpage nor in Principles of Operation user manual.

7) On mounting BCacheFS without compression enabled on 6.7-rc1, shortly 
before rc2, commit 791c8ab095f71327899023223940dd52257a4173 also LZ4 
compression modules  lz4hc_compress and lz4_compress are loaded. Why?

8) Regarding bcachefs-tools. More out of curiosity, cause there is already 
a bcachefs-tools package in Debian repo, albeit only version 1.2. I see a 
"debian" directory, however version number is 1.0.8-2~bpo8+1 while 
compiling via make gives version 1.33. So I suppose packaging information 
is not up to date? For now I am going with "make install" from bcachefs-
tools git repo, as package in Debian repo is outdated.

9) What is the preferred way to report bugs? Mailing list? Kernel bug 
tracker? Both? Anything else?

10) Anything you think an article about BCacheFS should absolutely 
mention?

There may be more at a later time. :)

Best,
-- 
Martin


