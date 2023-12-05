Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PIj9nCjT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nN3Gk6Pt"
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B89A1
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 14:01:07 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 331641FBEE;
	Tue,  5 Dec 2023 22:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1701813665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0C4R/5FTaXCwUVLuEdZbTMD1c2nmudFZyqL0l5R0Qds=;
	b=PIj9nCjT/h9+FXiTzGRovS+SIScyaB5GOAvuLHCfbTEIraTocFrS1bXXgMb42d/xbPBBkL
	2leQltpPTbQSqae2C390NG0oYx2tSXQm/7DjLS8RXcmffaS/ctBc3iuTJsLot9a11PGztX
	WDE3r2zyRC2tM7QSG8+m19npYwLTez0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1701813665;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0C4R/5FTaXCwUVLuEdZbTMD1c2nmudFZyqL0l5R0Qds=;
	b=nN3Gk6PtSB0uCRgiM6HmCWsvE/XW8ytOsV9HwGXH1/QbhDTw8sUhrPQ2ulMoPNcxBuCtKo
	j1zR80UCXli4x5AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93DAD1386E;
	Tue,  5 Dec 2023 22:01:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fstEEZ+db2WfbgAAD6G6ig
	(envelope-from <neilb@suse.de>); Tue, 05 Dec 2023 22:01:03 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
In-reply-to: <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>
References: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>,
 <20231129214328.efbfpl3javifvwk5@moria.home.lan>,
 <63ca9346-6bec-40d5-8f7e-4181721652f1@molgen.mpg.de>,
 <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>,
 <170137665630.7109.15666373159604652834@noble.neil.brown.name>,
 <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>,
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>,
 <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>
Date: Wed, 06 Dec 2023 09:01:00 +1100
Message-id: <170181366042.7109.5045075782421670339@noble.neil.brown.name>
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -2.18
X-Spamd-Result: default: False [-2.18 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.08)[-0.419];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 SUBJECT_ENDS_QUESTION(1.00)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]

On Wed, 06 Dec 2023, Donald Buczek wrote:
> On 12/4/23 23:45, NeilBrown wrote:
> 
> >> Hmm, isn't a (struct file_handle) filehandle supposed to be opaque?
> >> I'm not sure if it is a good idea to stick filesystem-specific
> >> meta-information (like a subvolume ident) into special bits of opaque
> >> numbers (whether inode number or filehandle) at all.
> > 
> > Yes, a filehandle is opaque.  Digging around inside it would be wrong.
> > 
> > My understanding was that your primary need was not to know where
> > subvolumes were, but to know when two files were different even though
> > they had the same inode number.  filehandles can be used to tell if two
> > files are different with total reliability.
> 
> You are right, these are two orthogonal requests and they were not
> clearly separated in this thread, thus the misunderstanding. 
> 
> I think, unique identifiers for different objects are a must.  I think
> in bcachefs, the filehandles returned by name_to_handle_at() already
> are unique, so this could be used by userspace to work around
> duplicate inode numbers right away.  Even the hashing you proposed
> could be done in userspace if it wants to fold the data into to some
> existing format with inode numbers. 
> 
> >> The information could also be made available via specialized ioctl(s)
> >> as an alternative to xattr.
> > 
> > ioctl would be worse than xattr.  statx extension would be best if you
> > need something that filehandle cannot provide.
> > 
> >>
> >> One disadvantage of embedded in filehandle, xattr or ioctl is that
> >> userspace would need an extra syscall for each directory just to see
> >> if this is a subvolume or a snapshot, which most of the time it is
> >> not.  Maybe, even an otherwise unnecessary open is needed to get a
> >> consistent view between multiple information-retrieving syscalls.  If
> >> only statx() was extendable.
> > 
> > uhmm... statx is extendable...
> > Adding a STATX_ATTR_SUBVOLUME_ROOT attribute flag shouldn't be too
> > controversial, if a clear need and use-case were presented.
> 
> When the inode numbers are made unique one way or the other but tools
> like backup or mirror have no way to identify snapshots, they would
> just copy the snapshots removing the deduplication on the destination.
> If they had a way to figure out, that they are about to walk into a
> new volume, they could instead do a more sensible thing like stop and
> cry for help or whatever is explicitly configured.
> 
> statx() would be very nice, because you can avoid additional system
> calls.  I wish, we could get the file_handle in the same call, but I
> assume that is not possible to be added to statx() because of the
> potential big and unknown length.  However, I assume the combination
> of volume-ident and inode number, which both would be available from
> one statx() call, are also unique, so this should do, too. 

The file handle is limited in size to 128 bytes.  The current statx
structure doesn't have that much spare space, but I don't see a problem
with having it return a larger structure if that is explicitly
requested.  Of course I don't know what other developers might think of
that.

Extending statx to return a "root-of-subvol" flag or possibly a
"subvol-id" u64 should be uncontroversial and would allow backup tools
and similar to easily ignore subvols.  This would need to be driven the
the bcachefs team of course.

Thanks,
NeilBrown
