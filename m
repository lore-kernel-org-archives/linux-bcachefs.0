Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hF4ilE98";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mPn7aFJQ"
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD649B
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Dec 2023 14:45:43 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6BA671FE7C;
	Mon,  4 Dec 2023 22:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1701729942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8HOeuDZT0epYDrUwYPZYWHePSs1QRXpBv4v/V+yTfRo=;
	b=hF4ilE981C0ctAnwfaR9u49zaG6mJgYlBOxwQEMQgEpv+YNsoFl+qPs8asmY5zzV6ACsGB
	EKlJCDUW1LBipxHnSE62aX7qpjVECjpb5X6lB0q+dAe4KAOdI73dMpffXmcHFFG4Pdlmtm
	4tKpsTK2Aj734DAci0NJn9k4mRli6nI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1701729942;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8HOeuDZT0epYDrUwYPZYWHePSs1QRXpBv4v/V+yTfRo=;
	b=mPn7aFJQGYujZLFLG1tKFlKy32xwDwzJ6otyX/2M4seTnkKupv/8Ssdll/d68GBtYRPyZ9
	2PaKjjo8Oc/FK9BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDD0A1398A;
	Mon,  4 Dec 2023 22:45:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zUOtGpRWbmUWdQAAD6G6ig
	(envelope-from <neilb@suse.de>); Mon, 04 Dec 2023 22:45:40 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Donald Buczek" <buczek@molgen.mpg.de>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org, "Stefan Krueger" <stefan.krueger@aei.mpg.de>
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
In-reply-to: <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>
References: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>,
 <20231129214328.efbfpl3javifvwk5@moria.home.lan>,
 <63ca9346-6bec-40d5-8f7e-4181721652f1@molgen.mpg.de>,
 <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>,
 <170137665630.7109.15666373159604652834@noble.neil.brown.name>,
 <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>
Date: Tue, 05 Dec 2023 09:45:37 +1100
Message-id: <170172993746.7109.10813288295717935377@noble.neil.brown.name>
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.10
X-Spamd-Result: default: False [-3.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 SUBJECT_ENDS_QUESTION(1.00)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]

On Mon, 04 Dec 2023, Donald Buczek wrote:
>=20
> On 11/30/23 21:37, NeilBrown wrote:
> > On Thu, 30 Nov 2023, Kent Overstreet wrote:
> >> On Thu, Nov 30, 2023 at 08:35:12AM +0100, Donald Buczek wrote:
> >>> On 11/29/23 22:43, Kent Overstreet wrote:
> >>>> On Tue, Nov 28, 2023 at 08:49:23AM +0100, Donald Buczek wrote:
> >>>>> Hi,
> >>>>>
> >>>>> I'm happy, bcachefs finally made it to mainline, Kudos to Kent!
> >>>>>
> >>>>> As far as I know, there is an ongoing discussion about the problems o=
f non-unique inode numbers exposed by snapshots an no real conclusion yet, on=
 how filesystems should expose snapshots.
> >>>>>
> >>>>> The current behavior is kind of a showstopper for us, because we are =
still running multi-user systems. The problem is, that any unprivileged user =
can create subvolumes and snapshots:
> >>>>>
> >>>>>       buczek@dose:/scratch/local3$ bcachefs subvolume create vol1
> >>>>>       buczek@dose:/scratch/local3$ mkdir vol1/dir1
> >>>>>       buczek@dose:/scratch/local3$ bcachefs subvolume snapshot vol1/s=
np1
> >>>>>       buczek@dose:/scratch/local3$ ls -li vol1/
> >>>>>       total 0
> >>>>>       1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
> >>>>>       1476413180 drwxrwxr-x 3 buczek buczek 0 Nov 20 15:01 snp1
> >>>>>       buczek@dose:/scratch/local3$ ls -li vol1/snp1/
> >>>>>       total 0
> >>>>>       1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
> >>>>>       buczek@dose:/scratch/local3$ find .
> >>>>>       .
> >>>>>       ./vol1
> >>>>>       find: File system loop detected; =E2=80=98./vol1/snp1=E2=80=99 =
is part of the same file system loop as =E2=80=98./vol1=E2=80=99.
> >>>>>       ./vol1/dir1
> >>>>>       buczek@dose:/scratch/local3$
> >>>>>
> >>>>> We have a few tools which walk over the filesystem (backup, mirror, a=
ccounting) and these are just not prepared for non-unique inode numbers aside=
 from regular hardlinks. I'm concerned that experiments of a unprivileged use=
rs could make important tools to fail.
> >>>>>
> >>>>> Questions:
> >>>>>
> >>>>> - Would it be a workaround to make creation of subvolumes and snapsho=
ts privileged operations?
> >>>>>
> >>>>> - If we want to evolve our tools: What is the best way for userspace =
to recognize subvolumes and snapshots and tell them apart from ordinary direc=
tories?
> >>>>
> >>>> I'm considering writing an "integer identifiers considered harmful"
> >>>> paper. I haven't dug into it yet - just skimmed the lwn coverage - but
> >>>> adding in the overlayfs issue makes this problem sound fundamentally
> >>>> unsolvable given the current constraints.
> >>>>
> >>>> Recognizing subvolume boundaries: we don't have anything for this yet,
> >>>> and given what happened with btrfs I'm not sure we want to go that
> >>>> route.
> >>>
> >>> A fabricated fsid - I think, that is what btrfs does - wouldn't help
> >>> us either. The mentioned tools would just stop at the assumed mount
> >>> points.
> >>
> >> *nod* - nor for NFS.
> >>
> >>>> We could (probably) expose unique inode numbers, filesystem wide, but =
at
> >>>> a cost. We'd have to restrict ourselves internally to 32 bit inode
> >>>> numbers, and then report inode numbers that include the subvolume ID as
> >>>> the high 32 bits.
> >>>>
> >>>> That won't leave enough bits to shard inode numbers at create time bas=
ed
> >>>> on CPU id, which isn't the _most_ important optimization, but would hu=
rt
> >>>> to lose.
> >>>>
> >>>> Going forward, we really need - as you allude to - better userspace
> >>>> APIs. Inode number probably can't be an integer anymore, it needs to be
> >>>> a string if it's going to be able to do all the things we want it to d=
o.
> >>>
> >>> Should be an uuid then. Expose inode uuid (and/or snapshot uuid) via
> >>> xattr? Anyway, I know, people more competent than me are thinking
> >>> about the problem.
> >>
> >> Exposing the subvolume ID via an xattr would be easy, if that works for
> >> you.
> >=20
> > I think that would be a bad choice.  Stick with the filehandle.  It is
> > an existing interface supported by many filesystems and it works over
> > NFS.
>=20
>=20
> Hmm, isn't a (struct file_handle) filehandle supposed to be opaque?
> I'm not sure if it is a good idea to stick filesystem-specific
> meta-information (like a subvolume ident) into special bits of opaque
> numbers (whether inode number or filehandle) at all.=20

Yes, a filehandle is opaque.  Digging around inside it would be wrong.

My understanding was that your primary need was not to know where
subvolumes were, but to know when two files were different even though
they had the same inode number.  filehandles can be used to tell if two
files are different with total reliability.

>=20
> The information could also be made available via specialized ioctl(s)
> as an alternative to xattr.

ioctl would be worse than xattr.  statx extension would be best if you
need something that filehandle cannot provide.

>=20
> One disadvantage of embedded in filehandle, xattr or ioctl is that
> userspace would need an extra syscall for each directory just to see
> if this is a subvolume or a snapshot, which most of the time it is
> not.  Maybe, even an otherwise unnecessary open is needed to get a
> consistent view between multiple information-retrieving syscalls.  If
> only statx() was extendable.

uhmm... statx is extendable...
Adding a STATX_ATTR_SUBVOLUME_ROOT attribute flag shouldn't be too
controversial, if a clear need and use-case were presented.

>=20
> You don't have this problem with a crafted fsid.  Then creating a
> subvolume or a snapshot could be seen as an implied mount.  Maybe
> that's not the worst solution.=20

No, probably not the *worst*, but not far from it.  It is a really bad
non-solution.

Have a look at
 https://github.com/SUSE/kernel-source/blob/master/patches.suse/vfs-add-super=
_operations-get_inode_dev

This is a monstrosity that SUSE needs to carry so that the fake fsid
that btrfs generates for subvolumes is used consistently.  There are
various interfaces in the kernel that use fsid/inode - some just for
error reporting, others for more substantial things.  In mainline linux
these do the wrong thing for btrfs subvolumes.

Please don't copy this mistake into bcachefs.

Thanks,
NeilBrown

>=20
> Best
>=20
>    Donald
>=20
> >=20
> > NeilBrown
> >=20
> >=20
> >>
> >>> What to you think about the suggestion to make creation of snapshots
> >>> (and possible volumes, not sure about that) a privileged operation
> >>> (optional, of course) ? I know, multi-user is niche nowadays, but for
> >>> me it looks like a rather cheap workaround.
> >>
> >> Yeah, that's not an unreasonable ask.
> >>
> >=20
>=20
> --=20
> Donald Buczek
> buczek@molgen.mpg.de
> Tel: +49 30 8413 1433
>=20

