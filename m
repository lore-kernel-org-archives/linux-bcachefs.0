Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD08155381
	for <linux-bcachefs@vger.kernel.org>; Fri,  3 May 2024 15:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714750599; cv=none; b=iVrVLMjtepkaW2cZILPKUwQKXVRkDnuygmK4pcGWzg75J7JFGQr/1tUcHCPQJVAhDfa5opFz6QBKbVRAddBc+hV0+lJXtOSYZkNoam0abun5POa/r+GlaeeNkh5XDvRBDr4F5K0BbqyKodPp+6pMWdLNhwooYGUxPYwp8WaDlr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714750599; c=relaxed/simple;
	bh=sChCpWj6ElwzgFPcVsRDdnerB2jZJnP1fICJ+mwtEYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVg4FBUQMM2ml52iY06yCprmyZN+5VFzphSFF6xY/x+hhXat/pupEIpNLH2woOi3Kgxwnq/3cK8cW9Eat77N/OgRS6UqmUcGknLEF3OIg8x9sL1vwdVlPnheG7cEyyawXOazUlFOyWQLqLJ6TN30khyEOLaHcM0LHwCLJIAnTGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IkH2pbkF; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IkH2pbkF"
Date: Fri, 3 May 2024 11:36:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714750595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuKG1Zo8MW98dlk4NkHv9eBAU8FMODjuiAEe3k32pII=;
	b=IkH2pbkFl0lldN3tv+paDBXSY9ziJWC+17umJTkZVjIyPjWb2YTeOLy3CyxuCrezAqN3SM
	64QwwdEfMt1UAqkq7PUSElt+pOw+m2LCieTPxfDeVcOvbwKVB329R5CBg13KLxXbeca1us
	0CdFPAvYf8/J45h28v8G+TElpz1Iqwg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com, 
	Thomas Bertschinger <tahbertschinger@gmail.com>, Ariel Miculas <ariel.miculas@gmail.com>, 
	linux-bcachefs@vger.kernel.org
Subject: Re: syzbot for bcachefs?
Message-ID: <d6wuvtwgp3z7v7fleewvw6fkjk6d5hpjqpp7p2bmiq5ocf5ib4@ap4iyuhzkpum>
References: <oxdwygzxpbpwxgl5v5hzaj7er6oxt2rlmaobkov4t23xqptqrn@gxi3nlapfini>
 <CACT4Y+ZEPWbJsYvWauog95yRFuzZmA=tK-uS+aDT-x=jnc3f7Q@mail.gmail.com>
 <aw5elbevdhwuqr7ecap6i5hepvkjbgs5xexq7nvu2yvuhh5bpb@tmyjcruysqjf>
 <CANp29Y5d3cp_YGfy-3bjJYsNfniXFjAm9WfOUVL5zwk=6weALg@mail.gmail.com>
 <CACT4Y+aNh4oBMpfPdNe7aAJT-hK9WPN5G47d1DN4NkH883OOdA@mail.gmail.com>
 <yg56oeewdosga5bemxyhku37deglpqjxz5ocg7asyeb2c75kap@5bas2aygiama>
 <CANp29Y6wQSb2Zn9Jujhzw4Mij77Nvfo4+2fkpY=ppJ6OCDE6Qw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y6wQSb2Zn9Jujhzw4Mij77Nvfo4+2fkpY=ppJ6OCDE6Qw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 10:28:42PM +0200, Aleksandr Nogikh wrote:
> On Fri, Apr 19, 2024 at 7:19 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Apr 19, 2024 at 10:35:27AM +0200, Dmitry Vyukov wrote:
> > >
> > > We've enabled the configs, but we don't have good image seeds yet.
> > > Aleksandr tried to generate them, he is currently OOO, but maybe you
> > > can help meanwhile.
> > > He said that running:
> > >
> > > $ mkfs.bcachefs test.img
> > >
> > > gives this error (on a quite big image, I don't know how large exactly it was):
> > >
> > > insufficient space for superblocks: start 8 end 4104 > 4096 size 2048
> > >
> > > Why could it give such an error and how to avoid it?
> >
> > What was the precise size? I'll see if I'm able to reproduce
> 
> I think the problem was that I was trying to save the generated files
> to a 9p filesystem (so that I could easily take them out of my VM).
> But now I've set up a proper userspace image with the latest 6.9 RC
> kernel and it worked fine.
> 
> >
> > > Also what would be a good sets of options to generate seed images?
> > > We try to "sample" space of different images to create seeds. To give
> > > you an idea here is what we do for other file systems:
> > > https://github.com/google/syzkaller/blob/af24b0505c748561efb50f1d03c824d6642f6c0b/tools/syz-imagegen/imagegen.go#L60-L516
> >
> > --encrypted --no_passphrase
> > --compression=lz4
> > --no-checksum
> 
> The mkfs.bcachefs tool that I installed does not know the
> --no-checksum flag, so I used --data_checksum=none
> --metadata_checksum=none instead. Does it mean the same thing?

That's the correct flags, I did a brainfart on that one :)
