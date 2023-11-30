Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Yu8sd/B1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vYksyyMg"
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA2210FF
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 Nov 2023 12:37:57 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 41EAF1FD02;
	Thu, 30 Nov 2023 20:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1701376676; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hiKm4a+3aVtLeROo2lkvBqHFewxFjaTNrhk1BWZbFTc=;
	b=Yu8sd/B17IXngqnIUlQ5Via4qZ8Hm+VlxGdt1lphPh8F4iq555Jhk1pojCH21C9SRGHj41
	V+WUjIMkLjYm+PWSh+CwTvInebUoSbEKk16D0EBLw9+k8PZmGpjQZWaidrtEsxTmFltNy2
	IfPT3R0lFyxtqBO0wlJ77ZctP4g6Bv4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1701376676;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hiKm4a+3aVtLeROo2lkvBqHFewxFjaTNrhk1BWZbFTc=;
	b=vYksyyMgzUa0dcperqPZx9uCXAK9Pz/SYjQvvybCCvVoFvqm8GTZ5BJx3tAWJB4kRyHHpr
	sdoCbXccGTGJ1vBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 878CB1342E;
	Thu, 30 Nov 2023 20:37:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tL3zDKLyaGVqLQAAD6G6ig
	(envelope-from <neilb@suse.de>); Thu, 30 Nov 2023 20:37:54 +0000
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
In-reply-to: <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>
References: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>,
 <20231129214328.efbfpl3javifvwk5@moria.home.lan>,
 <63ca9346-6bec-40d5-8f7e-4181721652f1@molgen.mpg.de>,
 <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>
Date: Fri, 01 Dec 2023 07:37:36 +1100
Message-id: <170137665630.7109.15666373159604652834@noble.neil.brown.name>
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spamd-Result: default: False [-0.52 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_SPAM_SHORT(2.58)[0.860];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 SUBJECT_ENDS_QUESTION(1.00)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Score: -0.52

On Thu, 30 Nov 2023, Kent Overstreet wrote:
> On Thu, Nov 30, 2023 at 08:35:12AM +0100, Donald Buczek wrote:
> > On 11/29/23 22:43, Kent Overstreet wrote:
> > > On Tue, Nov 28, 2023 at 08:49:23AM +0100, Donald Buczek wrote:
> > > > Hi,
> > > >=20
> > > > I'm happy, bcachefs finally made it to mainline, Kudos to Kent!
> > > >=20
> > > > As far as I know, there is an ongoing discussion about the problems o=
f non-unique inode numbers exposed by snapshots an no real conclusion yet, on=
 how filesystems should expose snapshots.
> > > >=20
> > > > The current behavior is kind of a showstopper for us, because we are =
still running multi-user systems. The problem is, that any unprivileged user =
can create subvolumes and snapshots:
> > > >=20
> > > >      buczek@dose:/scratch/local3$ bcachefs subvolume create vol1
> > > >      buczek@dose:/scratch/local3$ mkdir vol1/dir1
> > > >      buczek@dose:/scratch/local3$ bcachefs subvolume snapshot vol1/sn=
p1
> > > >      buczek@dose:/scratch/local3$ ls -li vol1/
> > > >      total 0
> > > >      1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
> > > >      1476413180 drwxrwxr-x 3 buczek buczek 0 Nov 20 15:01 snp1
> > > >      buczek@dose:/scratch/local3$ ls -li vol1/snp1/
> > > >      total 0
> > > >      1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
> > > >      buczek@dose:/scratch/local3$ find .
> > > >      .
> > > >      ./vol1
> > > >      find: File system loop detected; =E2=80=98./vol1/snp1=E2=80=99 i=
s part of the same file system loop as =E2=80=98./vol1=E2=80=99.
> > > >      ./vol1/dir1
> > > >      buczek@dose:/scratch/local3$
> > > >=20
> > > > We have a few tools which walk over the filesystem (backup, mirror, a=
ccounting) and these are just not prepared for non-unique inode numbers aside=
 from regular hardlinks. I'm concerned that experiments of a unprivileged use=
rs could make important tools to fail.
> > > >=20
> > > > Questions:
> > > >=20
> > > > - Would it be a workaround to make creation of subvolumes and snapsho=
ts privileged operations?
> > > >=20
> > > > - If we want to evolve our tools: What is the best way for userspace =
to recognize subvolumes and snapshots and tell them apart from ordinary direc=
tories?
> > >=20
> > > I'm considering writing an "integer identifiers considered harmful"
> > > paper. I haven't dug into it yet - just skimmed the lwn coverage - but
> > > adding in the overlayfs issue makes this problem sound fundamentally
> > > unsolvable given the current constraints.
> > >=20
> > > Recognizing subvolume boundaries: we don't have anything for this yet,
> > > and given what happened with btrfs I'm not sure we want to go that
> > > route.
> >=20
> > A fabricated fsid - I think, that is what btrfs does - wouldn't help
> > us either. The mentioned tools would just stop at the assumed mount
> > points.
>=20
> *nod* - nor for NFS.
>=20
> > > We could (probably) expose unique inode numbers, filesystem wide, but at
> > > a cost. We'd have to restrict ourselves internally to 32 bit inode
> > > numbers, and then report inode numbers that include the subvolume ID as
> > > the high 32 bits.
> > >=20
> > > That won't leave enough bits to shard inode numbers at create time based
> > > on CPU id, which isn't the _most_ important optimization, but would hurt
> > > to lose.
> > >=20
> > > Going forward, we really need - as you allude to - better userspace
> > > APIs. Inode number probably can't be an integer anymore, it needs to be
> > > a string if it's going to be able to do all the things we want it to do.
> >=20
> > Should be an uuid then. Expose inode uuid (and/or snapshot uuid) via
> > xattr? Anyway, I know, people more competent than me are thinking
> > about the problem.
>=20
> Exposing the subvolume ID via an xattr would be easy, if that works for
> you.

I think that would be a bad choice.  Stick with the filehandle.  It is
an existing interface supported by many filesystems and it works over
NFS.

NeilBrown


>=20
> > What to you think about the suggestion to make creation of snapshots
> > (and possible volumes, not sure about that) a privileged operation
> > (optional, of course) ? I know, multi-user is niche nowadays, but for
> > me it looks like a rather cheap workaround.
>=20
> Yeah, that's not an unreasonable ask.
>=20

