Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BDA1A2562
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 17:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496503; cv=none; b=Dtc16lzFeQLJgxgfLXll+0Z51I5za2frrKLhw/IHiWTt9pPhraeeNDd38PIlEAZeDOWSSo5EicCrbJFm2ZxweWObBhminfQm456FJYGX43nEDEV3OoG3fnQVLQiZpjXR1e21C3SkGUN1Bmmf1PNo3Rjd3FILMflx57lXMU2XcFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496503; c=relaxed/simple;
	bh=tXBCiljZc7dPJp8Zq2q+dmiW2dnqRJkmkmYaxWWS4WQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p98uk//aJb8MzQcmP/hS/wKNolnC40blKKNX1DTWmQWwGGfcTWABfLY+xaIIlhPH5EB6qDpGIh4DQjGTCDxDCU3NHH1hyb7ROVBcyjdfFKqVwt9r6lLFLerY0/Pt2ouTXcll2wNK1xHwyXUmn8QgL6O1aQRy6peyWLRzoBum6jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=MEhjNNHo; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="MEhjNNHo"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 499HsmdJ024877
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 9 Oct 2024 13:54:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1728496490; bh=nvWtdn2mNbMqxmG3UQgWF2lcjXKOoW/g6h07k68F3tM=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=MEhjNNHoAALMYqWTbMQXO8h2k3qhEIbtOo+iVjYG7Ot08k9cojDLwp7Sp97GSqMrP
	 AQyRHGQGT7KLSC08cYMZUtjZs9IY8LBYUDQw6IGVH3aERk/4xtFWTJDeAmWc78e052
	 BTn1E55ZoAuMJmgmQQtVPwUtTdU30HAp9HHN2OA4RAA+9JJIj4S4N49agprIE2JUFR
	 dp2Nn/zy+Hi+moccDrwfXehIL/T44Vu+aZKEO14REFEGDO6OeJi37jLt8QJokdup+Y
	 wTeAgteUAofE/6DZKEgXU48nxZ7NVHPw6Cykz3fbUcrLT6UHYRzRwPtG3X2T5hGUHq
	 ids0w7vew873A==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id D8E7034058D; Wed, 09 Oct 2024 12:54:47 -0500 (CDT)
Date: Wed, 9 Oct 2024 12:54:47 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.12-rc2
Message-ID: <20241009175447.GC167360@mit.edu>
References: <CAHk-=wjit-1ETRxCBrQAw49AUcE5scEM5O++M=793bDWnQktmw@mail.gmail.com>
 <x7w7lr3yniqrgcuy7vzor5busql2cglirhput67pjk6gtxtbfc@ghb46xdnjvgw>
 <CAHk-=wi-nKcOEnvX3RX+ovpsC4GvsHz1f6iZ5ZeD-34wiWvPgA@mail.gmail.com>
 <e3qmolajxidrxkuizuheumydigvzi7qwplggpd2mm2cxwxxzvr@5nkt3ylphmtl>
 <CAHk-=wjns3i5bm++338SrfJhrDUt6wyzvUPMLrEvMZan5ezmxQ@mail.gmail.com>
 <2nyd5xfm765iklvzjxvn2nx3onhtdntqrnmvlg2panhtdbff7i@evgk5ecmkuoo>
 <20241006043002.GE158527@mit.edu>
 <jhvwp3wgm6avhzspf7l7nldkiy5lcdzne5lekpvxugbb5orcci@mkvn5n7z2qlr>
 <20241009035139.GB167360@mit.edu>
 <kxi6m3gi7xqv52bupvb7iskyk6e3spq6bbhq4il5pmfieacfmf@5iwcnsfkmfq4>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kxi6m3gi7xqv52bupvb7iskyk6e3spq6bbhq4il5pmfieacfmf@5iwcnsfkmfq4>

On Wed, Oct 09, 2024 at 12:17:35AM -0400, Kent Overstreet wrote:
> How many steps are required, start to finish, to test a git branch and
> get the results?

See the quickstart doc.  The TL;DR is (1) do the git clone, (2) "make
; make install" (this is just to set up the paths in the shell scripts
and then copying it to your ~/bin directory, so this takes a second or
so)", and then (3) "install-kconfig ; kbuild ; kvm-xfstests smoke" in
your kernel tree.

> But dashboards are important, as well. And the git log based dashboard
> I've got drastically reduces time spent manually bisecting.

gce-xfstests ltm -c ext4/1k generic/750 --repo ext4.git \
	     --bisect-bad dev --bisect-good origin

With automated bisecting, I don't have to spend any of my personal
time; I just wait for the results to show up in my inbox, without
needing to refer to any dashboards.  :-)


> > In any case, that's why I haven't been interesting in working with
> > your test infrastructure; I have my own, and in my opinion, my
> > approach is the better one to make available to the community, and so
> > when I have time to improve it, I'd much rather work on
> > {kvm,gce,android}-xfstests.
> 
> Well, my setup also isn't tied to xfstests, and it's fairly trivial to
> wrap all of our other (mm, block) tests.

Neither is mine; the name {kvm,gce,qemu,android}-xfstests is the same
for historical reasons.  I have blktests, ltp, stress-ng and the
Phoronix Test Suites wired up (although using comparing against
historical baselines with PTS is a bit manual at the moment).

> But like I said before, I don't particularly care which one wins, as
> long as we're pushing forward with something.

I'd say that in the file system development community there has been a
huge amount of interest in testing, because we all have a general
consensus that testing is support important[1].  Most of us decided
that the "There Can Be Only One" from the Highlander Movie is just not
happening, because everyone's test infrastructures is optimized for
their particular workflow, just as there's a really good reason why
there are 75+ file systems in Linux, and half-dozen or so very popular
general-purpose file systems.

And that's a good thing.

Cheers,

						- Ted

[1] https://docs.google.com/presentation/d/14MKWxzEDZ-JwNh0zNUvMbQa5ZyArZFdblTcF5fUa7Ss/edit#slide=id.g1635d98056_0_45

