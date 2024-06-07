Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4B579F4
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717789065; cv=none; b=JAdDm829yACX6kdyuqt6E1WiHNprgSOibI6ucOlxQRuNeOrx2cWZ95jmtRcN45wNqDkW/6jHSQmV9Wk1bjJE614QIL1TssHBPiJdeWWKGEog7joOAiQ31BYuTHSA2Q9RKIcMthUOkGyzr/LKssClltX8HLcGXYsyG7+V+5fJUeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717789065; c=relaxed/simple;
	bh=lz3wKis3NhqsiL0DJUXiNj3+YasZoTGBgPB2haYFHsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yj2/+4+DMDw3J2EcBaJ9bIYhu7DS7IctwK0XW7Y6YXv+MJTAyl6xHKSO947Dj8gQzo+CNRrMzk+0wc8v9f+vTsiYUTBFqvagXzvkrzoLfRvP9O88qMoJsRd3dxNR4TirN6vyNT2aLh4mTz/5UI4bvRRGp6kaVzurnTzYLXNpz9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cB/SR1Ri; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cB/SR1Ri"
X-Envelope-To: mjguzik@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717789060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w79+r7XMcaAQCfYFx8nQ4RqBALpHwp/FnJpFt96H+zM=;
	b=cB/SR1Rib4tXq37vrC2ANni0li1DyJ74ZK5IbStAVS59bvOXfpTQnr4qfMPcY+7ITT+UWL
	cb+u6ntDAFyLkDGxPv5e15tqxPpEFj6d2H13dxxF4DdorGcTRQvtvVTo96uD+qNECKqbCE
	Im322QyvhZtUpVgic0p+g1AW9X2ayts=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Fri, 7 Jun 2024 15:37:37 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <kqvrgt5i4id45a5qoxu4oqinxcmrb5bfl5pqyptj3usmb6c5ma@s2xnp5p6l34j>
References: <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
 <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
 <CAGudoHHwAC5adU6p6yM_mwrwGzDDQLn8ES985X08kY==+juAFg@mail.gmail.com>
 <CAGudoHEcZtQ6w7vECoV3Jk+oWA_ejHdtbN2VpmR0qPPN+9-X5Q@mail.gmail.com>
 <3pfkkl4ig6jzdfh7bu5y3hb7jbhzlumtzrk4syi5kunmr5vjov@7jtnnr35dlh5>
 <CAGudoHFHp_XP_WrABv7pO6BuhJCkKo7BwHiAwJ53QAg_NMMSPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHFHp_XP_WrABv7pO6BuhJCkKo7BwHiAwJ53QAg_NMMSPg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 07, 2024 at 09:15:31PM +0200, Mateusz Guzik wrote:
> On Fri, Jun 7, 2024 at 8:43 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Jun 07, 2024 at 08:28:07PM +0200, Mateusz Guzik wrote:
> > > Well I did a quick skim through, it's probably a no-go:
> > > 1. uses bit locks which i'm told would be problematic vs lockdep and
> > > rt kernels (see the original patchset by Dave Chinner, linked in my
> > > fsdevel post)
> >
> > The bit spinlocks are confined to the rhashtable code; they're fine.
> >
> 
> That's indeed fine then, the worry was about bitlock -> spinlock ordering.
> 
> > > 2. insertions can fail with ENOMEM? for this particular usage that is
> > > very iffy to me, but i don't have a voting power in linux vfs
> >
> > Inode allocation can fail with -ENOMEM, so that's also fine.
> 
> Of course it can fail. I'm saying the fewer failure points for inode
> handling the better.
> 
> But this is between you and vfs overlords.

Do you want to just do yet another bandaid, or a proper fix with a real
data structure?

Fixed size inode hash is a problem, and we need to stop hand rolling
data structures. That's why I'm telling you I'm not in favor of your
current approach.
