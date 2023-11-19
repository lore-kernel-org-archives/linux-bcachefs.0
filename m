Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC515C4
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 03:13:32 -0800 (PST)
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id F2742816BA4;
	Sun, 19 Nov 2023 12:13:30 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Date: Sun, 19 Nov 2023 12:13:29 +0100
Message-ID: <2273246.iZASKD2KPV@lichtvoll.de>
In-Reply-To: <20231118234205.24nzm7liawamgxhx@moria.home.lan>
References:
 <23311511.6Emhk5qWAg@lichtvoll.de> <4197014.1IzOArtZ34@lichtvoll.de>
 <20231118234205.24nzm7liawamgxhx@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Take your time and have a great Sunday :)

Kent Overstreet - 19.11.23, 00:42:05 CET:
> On Sun, Nov 19, 2023 at 12:15:19AM +0100, Martin Steigerwald wrote:
> > Kent Overstreet - 18.11.23, 22:07:27 CET:
> > > > As far as I understand one specific performance related aspect of
> > > > BCacheFS would be low latencies due to the frontend / backend
> > > > architecture which in principle is based on what has been there in
> > > > BCache already. I am intending to explore a bit into that concept
> > > > in
> > > > my article.
> > >=20
> > > The low latency stuff actually wasn't in bcache - that work came
> > > later.
> >=20
> > So the frontend / backend architecture is not that much of what makes
> > BCacheFS unique? Important to know as it seems I may have
> > misunderstood
> > something here.
>=20
> The "filesystem on top of a database" is the main thing that makes
> bcachefs unique - you have that right.

Phew! Seems I did not get it completely wrong then :)

> bcache had much of the core btree design - log structured btree nodes
> with eytzinger search trees; that's how we got a high enough performance
> btree to make the "filesystem on top of a database" thing practical.
>=20
> But the btree in bcache was, from a performance POV, prototype quality -
> stable, but a lot of performance corner cases unfinished.
>=20
> The latency work, real iterators, and the whole transaction layer came
> later :)

So it is fair to say that being based on BCache enabled that low latency=20
work?

I am trying to find a balance here. The audience of the article are=20
experienced sys admins working in small and large organizations, but not=20
(primarily) kernel hackers. So I like to explain possible reasons to=20
consider BCacheFS while also having BTRFS and ZFS and XFS, but without=20
going into so much detail that one needs to be a kernel developer to=20
understand it. For XFS it is easy as while there was a proof of concept=20
with subvolumes and snapshots based on XFS in files on XFS, AFAIR from=20
Dave Chinner, some years back, it does not have those advanced features=20
(yet). For ZFS one can always argue it is not in the mainline kernel. But=20
regarding BTRFS it becomes important to really explain something. I=20
started to do some BCacheFS / BTRFS feature comparison chart, but I also=20
like to explain on the benefits BCacheFS can have in the text and a bit=20
about the background of those benefits. Of course also mentioning that=20
BCacheFS is in development for more than 10 years, even without taking all=
=20
the work for BCache itself into account.

So my idea currently is to explain that the BCache BTree and/or frontend/
backend architecture, not sure how to best word it, enabled a database=20
approach to a filesystem to be feasible. And that in a sense it also=20
enabled the latency work. And I can mention sixlocks and all the nice=20
other stuff you mentioned. However=E2=80=A6 I may not explain exactly what =
those=20
nice things are and how they work for example. For two reasons: 1. I need=20
to understand those nice features myself, 2. limit of pages I may use and=20
scope of the article. Currently I understood that sixlocks for certain use=
=20
cases are the next best thing since the invention of a wheel or something=20
like that. But not much more :)

Would something like that be accurate enough in your opinion?

I will review the user manual once again, I read about the database=20
approach, and aim to find a good balance. Cause for certain I won't be=20
getting 24 pages for the article :)


I got two setbacks regarding trying BCacheFS on my laptop yesterday and=20
today:

1) Linux 6.7-rc1, as mentioned almost rc2, did not hibernate on ThinkPad=20
T14 AMD Gen 1. It just blanked screen and nothing happened. So I went back=
=20
to 6.6.1 temporarily. I do not really intend to do a git bisect between=20
rc1 and 6.6 on a production laptop. It would be very time-consuming and=20
possibly be dangerous. I may go back to 6.7 even without hibernation, just=
=20
using standby over night for a while. I bet BCacheFS is compatible with=20
hibernation (as in writing memory contents to encrypted swap and resuming=20
from it)?

2) But after I removed 6.7-rc1 yesterday night after having booted into=20
6.6.1 this morning I was greeted by GRUB command line. As I had a meeting=20
scheduled my primary aim was to get things running again. I certainly did=20
not really get the humorous aspect about it. I thought I'd had copied etc=20
in the broken state to a another place, but do not find it anymore, maybe=20
I copied it to /root or the GRML live distro accidently and so it is gone.=
=20
Also I missed to copy the broken /boot to another place. So I am not=20
really able to do any forensic analysis of what might have happened. I do=20
not recall having seen any error messages either, but I may have missed=20
something. I reviewed hook and script for initial RAM disk in bcachefs-
tools repo, but did not find anything in there that could have caused grub=
=20
2 not finding its config file and modules anymore. Also it booted into 6.7=
=20
and even 6.6.1 then after having executed "make install" from bcachefs-
tools directory. Also I see nothing being done with grub itself within=20
bcachefs-tools. So this really is quite the mystery for me. I am on Devuan=
=20
Ceres (based on Debian Sid) so maybe something else got messed up. Will=20
review their bug trackers. I really have no idea what went wrong here,=20
luckily I was able to recover with GRML. I use LVM on LUKS for BTRFS and=20
test BCacheFS filesystem.

Maybe I need to continue testing BCacheFS on a virtual machine, but I'd=20
really love to have a BCacheFS filesystem on my laptop and actually really=
=20
using it for something. Well I am going to leave it at that and probably=20
research on this after the weekend. Now it is time to have a Sunday off.

Best,
=2D-=20
Martin


