Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0935B170F
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 Nov 2023 12:36:12 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 321F921B8A;
	Thu, 30 Nov 2023 20:36:11 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 85C9C1342E;
	Thu, 30 Nov 2023 20:36:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NpJSDTnyaGUaLQAAD6G6ig
	(envelope-from <neilb@suse.de>); Thu, 30 Nov 2023 20:36:09 +0000
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
In-reply-to: <20231129214328.efbfpl3javifvwk5@moria.home.lan>
References: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>,
 <20231129214328.efbfpl3javifvwk5@moria.home.lan>
Date: Fri, 01 Dec 2023 07:36:06 +1100
Message-id: <170137656625.7109.11633427959061675371@noble.neil.brown.name>
X-Spamd-Bar: +++++++
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=suse.de (policy=none);
	spf=softfail (smtp-out1.suse.de: 2a07:de40:b281:104:10:150:64:97 is neither permitted nor denied by domain of neilb@suse.de) smtp.mailfrom=neilb@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [7.02 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 SUBJECT_ENDS_QUESTION(1.00)[];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 RCVD_COUNT_THREE(0.00)[3];
	 MX_GOOD(-0.01)[];
	 NEURAL_SPAM_LONG(2.23)[0.638];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 DMARC_POLICY_SOFTFAIL(0.10)[suse.de : No valid SPF, No valid DKIM,none]
X-Spam-Score: 7.02
X-Rspamd-Queue-Id: 321F921B8A

On Thu, 30 Nov 2023, Kent Overstreet wrote:
> On Tue, Nov 28, 2023 at 08:49:23AM +0100, Donald Buczek wrote:
> > Hi,
> >=20
> > I'm happy, bcachefs finally made it to mainline, Kudos to Kent!
> >=20
> > As far as I know, there is an ongoing discussion about the problems of no=
n-unique inode numbers exposed by snapshots an no real conclusion yet, on how=
 filesystems should expose snapshots.
> >=20
> > The current behavior is kind of a showstopper for us, because we are stil=
l running multi-user systems. The problem is, that any unprivileged user can =
create subvolumes and snapshots:
> >=20
> >     buczek@dose:/scratch/local3$ bcachefs subvolume create vol1
> >     buczek@dose:/scratch/local3$ mkdir vol1/dir1
> >     buczek@dose:/scratch/local3$ bcachefs subvolume snapshot vol1/snp1
> >     buczek@dose:/scratch/local3$ ls -li vol1/
> >     total 0
> >     1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
> >     1476413180 drwxrwxr-x 3 buczek buczek 0 Nov 20 15:01 snp1
> >     buczek@dose:/scratch/local3$ ls -li vol1/snp1/
> >     total 0
> >     1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
> >     buczek@dose:/scratch/local3$ find .
> >     .
> >     ./vol1
> >     find: File system loop detected; =E2=80=98./vol1/snp1=E2=80=99 is par=
t of the same file system loop as =E2=80=98./vol1=E2=80=99.
> >     ./vol1/dir1
> >     buczek@dose:/scratch/local3$
> >=20
> > We have a few tools which walk over the filesystem (backup, mirror, accou=
nting) and these are just not prepared for non-unique inode numbers aside fro=
m regular hardlinks. I'm concerned that experiments of a unprivileged users c=
ould make important tools to fail.
> >=20
> > Questions:
> >=20
> > - Would it be a workaround to make creation of subvolumes and snapshots p=
rivileged operations?
> >=20
> > - If we want to evolve our tools: What is the best way for userspace to r=
ecognize subvolumes and snapshots and tell them apart from ordinary directori=
es?
>=20
> I'm considering writing an "integer identifiers considered harmful"
> paper. I haven't dug into it yet - just skimmed the lwn coverage - but
> adding in the overlayfs issue makes this problem sound fundamentally
> unsolvable given the current constraints.
>=20
> Recognizing subvolume boundaries: we don't have anything for this yet,
> and given what happened with btrfs I'm not sure we want to go that
> route.
>=20
> We could (probably) expose unique inode numbers, filesystem wide, but at
> a cost. We'd have to restrict ourselves internally to 32 bit inode
> numbers, and then report inode numbers that include the subvolume ID as
> the high 32 bits.
>=20
> That won't leave enough bits to shard inode numbers at create time based
> on CPU id, which isn't the _most_ important optimization, but would hurt
> to lose.
>=20
> Going forward, we really need - as you allude to - better userspace
> APIs. Inode number probably can't be an integer anymore, it needs to be
> a string if it's going to be able to do all the things we want it to do.
>=20

If you want to give up on Posix comparability - and with it any hope
that your fs will be used - then using a string as the inode identifier
might work.  But in the real world, inodes have 64 bit numbers.

The only credible alternative is to use the fhandle as a primary
identifier.  You still need to support inode numbers, and they still
need to be stable and to be as unique as you can possibly make them
across the filesystem.

My preference would be to make the inode number reported to userspace be
a strong hash of the fhandle (which absolutely must be unique - but can be
quite large).  Then systemic clashes - like the one with results in find
misdetecting filesystem loops - will be extremely unlikely.

For code that really really needs to detect if two filesystems are the
same (tar being the obvious example) we should encourage the use of
name_to_handle_at().

Experience with NFSv2 and exclusive opens shows that if a filesystem
breaks something in a way that it still works most of the time but
occasionally still fails randomly, then people will still use it
(providing it provides real benefits of course) and they will find a
work-around to avoid the breakage.  So thanks to NFSv2, people stopped
using O_CREAT|O_EXCL as a locking mechanism, and did things with hard
links instead.

NeilBrown
