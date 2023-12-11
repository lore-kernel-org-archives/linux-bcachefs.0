Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LZNwfG0n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yadL40oK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LZNwfG0n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yadL40oK"
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50655AF
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Dec 2023 14:43:35 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B63F61FBEF;
	Mon, 11 Dec 2023 22:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1702334613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecutAA7b/vrKJ3u9Ps72gjK4hPQ/FOMnlnYZHaO1UPQ=;
	b=LZNwfG0nquYzG+pvXidg5ysZf/k7vtjp7twu6OaVpqlpU+ThuFnHmIoyt/h1vChm0AMChk
	I4RN6QusgyIFSFVrUwAnp/1Vlc7PRH04SIJqEFhQaiv85M3YspJFeoImqMgZld3/u6cPSa
	fOrfAm91z8zYseSdb4w1TRnZGSWZfNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1702334613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecutAA7b/vrKJ3u9Ps72gjK4hPQ/FOMnlnYZHaO1UPQ=;
	b=yadL40oK8yclVorbXiKr1bxqpWJ0zd1xvgcSPulamfIPIsyX/nkVm0+PQU5JTYk3yJHGGZ
	tOgRzYPOfw53A9Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1702334613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecutAA7b/vrKJ3u9Ps72gjK4hPQ/FOMnlnYZHaO1UPQ=;
	b=LZNwfG0nquYzG+pvXidg5ysZf/k7vtjp7twu6OaVpqlpU+ThuFnHmIoyt/h1vChm0AMChk
	I4RN6QusgyIFSFVrUwAnp/1Vlc7PRH04SIJqEFhQaiv85M3YspJFeoImqMgZld3/u6cPSa
	fOrfAm91z8zYseSdb4w1TRnZGSWZfNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1702334613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecutAA7b/vrKJ3u9Ps72gjK4hPQ/FOMnlnYZHaO1UPQ=;
	b=yadL40oK8yclVorbXiKr1bxqpWJ0zd1xvgcSPulamfIPIsyX/nkVm0+PQU5JTYk3yJHGGZ
	tOgRzYPOfw53A9Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 189BB133DE;
	Mon, 11 Dec 2023 22:43:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nyxXLpOQd2XXQAAAD6G6ig
	(envelope-from <neilb@suse.de>); Mon, 11 Dec 2023 22:43:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: "Donald Buczek" <buczek@molgen.mpg.de>, linux-bcachefs@vger.kernel.org,
 "Stefan Krueger" <stefan.krueger@aei.mpg.de>
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
In-reply-to: <20231208200247.we3zrwmnkwy5ibbz@moria.home.lan>
References: <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>,
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>,
 <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>,
 <170181366042.7109.5045075782421670339@noble.neil.brown.name>,
 <97375d00-4bf7-4c4f-96ec-47f4078abb3d@molgen.mpg.de>,
 <170199821328.12910.289120389882559143@noble.neil.brown.name>,
 <20231208013739.frhvlisxut6hexnd@moria.home.lan>,
 <170200162890.12910.9667703050904306180@noble.neil.brown.name>,
 <20231208024919.yjmyasgc76gxjnda@moria.home.lan>,
 <630fcb48-1e1e-43df-8b27-a396a06c9f37@molgen.mpg.de>,
 <20231208200247.we3zrwmnkwy5ibbz@moria.home.lan>
Date: Tue, 12 Dec 2023 09:43:27 +1100
Message-id: <170233460764.12910.276163802059260666@noble.neil.brown.name>
X-Spam-Level: ********
X-Spam-Score: 8.22
X-Spamd-Result: default: False [-11.01 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_SPF_SOFTFAIL(0.00)[~all:c];
	 RCVD_COUNT_THREE(0.00)[3];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 DKIM_TRACE(0.00)[suse.de:+];
	 DMARC_POLICY_ALLOW(0.00)[suse.de,none];
	 MX_GOOD(-0.01)[];
	 DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 SUBJECT_ENDS_QUESTION(1.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 WHITELIST_DMARC(-7.00)[suse.de:D:+];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Flag: NO
X-Rspamd-Server: rspamd1
X-Spam-Level: 
X-Rspamd-Queue-Id: B63F61FBEF
X-Spam-Score: -11.01
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LZNwfG0n;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yadL40oK;
	spf=softfail (smtp-out2.suse.de: 2a07:de40:b281:104:10:150:64:97 is neither permitted nor denied by domain of neilb@suse.de) smtp.mailfrom=neilb@suse.de;
	dmarc=pass (policy=none) header.from=suse.de

On Sat, 09 Dec 2023, Kent Overstreet wrote:
> On Fri, Dec 08, 2023 at 12:34:28PM +0100, Donald Buczek wrote:
> > On 12/8/23 03:49, Kent Overstreet wrote:
> >=20
> > > We really only need 6 or 7 bits out of the inode number for sharding;
> > > then 20-32 bits (nobody's going to have a billion snapshots; a million
> > > is a more reasonable upper bound) for the subvolume ID leaves 30 to 40
> > > bits for actually allocating inodes out of.
> > >=20
> > > That'll be enough for the vast, vast majority of users, but exceeding
> > > that limit is already something we're technically capable of: we're
> > > currently seeing filesystems well over 100 TB, petabyte range expected
> > > as fsck gets more optimized and online fsck comes.
> >=20
> > 30 bits would not be enough even today:
> >=20
> > buczek@done:~$ df -i /amd/done/C/C8024
> > Filesystem         Inodes     IUsed      IFree IUse% Mounted on
> > /dev/md0       2187890304 618857441 1569032863   29% /amd/done/C/C8024
> >=20
> > So that's 32 bit on a random production system ( 618857441 =3D=3D 0x24e30=
3e1 ).

only 30 bits though.  So it is a long way before you use all 32 bits.
How many volumes do you have?

> >=20
> > And if the idea to produce unique inode numbers by hashing the filehandle=
 into 64 is followed, collisions definitely need to be addressed. With 618857=
441 objects, the probability of a hash collision with 64 bit is already over =
1% [1].
>=20
> Oof, thanks for the data point. Yeah, 64 bits is clearly not enough for
> a unique identifier; time to start looking at how to extend statx.
>=20

64 should be plenty...

If you have 32 bits for free allocation, and 7 bits for sharding across
128 CPUs, then you can allocate many more than 4 billion inodes.  Maybe
not the full 500 billion for 39 bits, but if you actually spread the
load over all the shards, then certainly tens of billions.

If you use 22 bits for volume number and 42 bits for inodes in a volume,
then you can spend 7 on sharding and still have room for 55 of Donald's
filesystems to be allocated by each CPU.

And if Donald only needs thousands of volumes, not millions, then he
could configure for a whole lot more headroom.

In fact, if you use the 64 bits of vfs_inode number by filling in bits from
the fs-inode number from one end, and bits from the volume number from
the other end, then you don't need to pre-configure how the 64 bits are
shared.
You record inum-bits and volnum bits in the filesystem metadata, and
increase either as needed.  Once the sum hits 64, you start returning
ENOSPC for new files or new volumes.

There will come a day when 64 bits is not enough for inodes in a single
filesystem.  Today is not that day.

NeilBrown
