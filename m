Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FF91369AA
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 17:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713547156; cv=none; b=ZODzcmFqDEydC4C/M+L11vYI3rP4tu0sdswrBOuONl0Ge58PzvAzG4cYCM4INwgP8YygnSW3skFMAe9/bjd7Tli5TqZXmk4GshnXcacOIRMr82W+y05VsAQR5hSayF93tdB01W0DmSl9OoGC9qfXgSRS3JU5lfhY+/ehBn9GlYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713547156; c=relaxed/simple;
	bh=2b2tnSvTxx75pb83vPa5AUI2Qc2L8pyYFr5Fy2vxKQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JUd/08gn4S1syuxvEj7A55hNGxTJQM0Bijb5XQ2ASr0lMwWI+a2akhYpocspm3yPtc9cXYRivOWlGwW0jfnRg/Rzvi24o80szp6l7vCsjhFLRg2nhVFs+QVL7zw+dvGzHZIOyifG1GrLi6TnQfCbqBthqoktQORHQ/tN0xMFD8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IbhLffUW; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IbhLffUW"
Date: Fri, 19 Apr 2024 13:19:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713547150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GoObaZ5xjEasA7vJ2mszDqbMqUfI/NWdw05OfYnGY8s=;
	b=IbhLffUWmseQOe5ZDwSby/HPQTfyBxVy3tw78CE3MGsn+9za6j3PZK1EIoUwe6TxaSOqQx
	4GDkALbThggWnDAQGmQlOsxmR/SIBdxqp6M9XAhVX6oeLRAu9F21H8gmm6WfNO2TNV3Rn/
	SGUFoN5qbMmdP4UES+o5ye0XjAOscQI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>, syzkaller@googlegroups.com, 
	Thomas Bertschinger <tahbertschinger@gmail.com>, Ariel Miculas <ariel.miculas@gmail.com>, 
	linux-bcachefs@vger.kernel.org
Subject: Re: syzbot for bcachefs?
Message-ID: <yg56oeewdosga5bemxyhku37deglpqjxz5ocg7asyeb2c75kap@5bas2aygiama>
References: <oxdwygzxpbpwxgl5v5hzaj7er6oxt2rlmaobkov4t23xqptqrn@gxi3nlapfini>
 <CACT4Y+ZEPWbJsYvWauog95yRFuzZmA=tK-uS+aDT-x=jnc3f7Q@mail.gmail.com>
 <aw5elbevdhwuqr7ecap6i5hepvkjbgs5xexq7nvu2yvuhh5bpb@tmyjcruysqjf>
 <CANp29Y5d3cp_YGfy-3bjJYsNfniXFjAm9WfOUVL5zwk=6weALg@mail.gmail.com>
 <CACT4Y+aNh4oBMpfPdNe7aAJT-hK9WPN5G47d1DN4NkH883OOdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4Y+aNh4oBMpfPdNe7aAJT-hK9WPN5G47d1DN4NkH883OOdA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 10:35:27AM +0200, Dmitry Vyukov wrote:
> On Fri, 5 Apr 2024 at 18:20, Aleksandr Nogikh <nogikh@google.com> wrote:
> >
> > On Fri, Apr 5, 2024 at 1:16 AM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > On Thu, Apr 04, 2024 at 10:33:07AM +0200, Dmitry Vyukov wrote:
> > > > On Thu, 4 Apr 2024 at 01:59, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > > > >
> > > > > Hi - what would it take to get syzbot going for bcachefs?
> > > >
> > > > Hi Kent,
> > > >
> > > > There are 2 parts:
> > > >
> > > > The easy one: we need to enable it in syzbot configs. Should we
> > > > configure it as follows?
> > > >
> > > > CONFIG_BCACHEFS_FS=y
> > > > CONFIG_BCACHEFS_QUOTA=y
> > > > CONFIG_BCACHEFS_ERASURE_CODING=y
> > > > CONFIG_BCACHEFS_POSIX_ACL=y
> > > > CONFIG_BCACHEFS_DEBUG=y
> > > > # CONFIG_BCACHEFS_TESTS is not set
> > > > # CONFIG_BCACHEFS_LOCK_TIME_STATS is not set
> > > > # CONFIG_BCACHEFS_NO_LATENCY_ACCT is not set
> > > > CONFIG_BCACHEFS_SIX_OPTIMISTIC_SPIN=y
> > > >
> > > > In particular, I am interested in CONFIG_BCACHEFS_DEBUG. Does it
> > > > really add more debug checks rather than lots of console printing w/o
> > > > checks? Some "DEBUG" kernel configs are misleading here. Checks will
> > > > be useful on syzbot, lots of printing not so much.
> >
> > For the record: I've just sent
> > https://github.com/google/syzkaller/pull/4647 with syzbot config
> > updates.
> >
> > >
> > > CONFIG_BCACHEFS_DEBUG adds piles of assertions and no extra console
> > > printing :)
> > >
> > > > Second part: syzbot will need to exercise the fs in some useful way.
> > > > Is it just a "normal" fs with files, or something special?
> > >
> > > It's a normal - but multi device - filesystem, similar featureset to
> > > btrfs.
> > >
> > > > Is it mounted from an image, or an image-less fs? If it needs images,
> > > > how can they be created?
> > >
> > > apt install bcachefs-tools
> > > mkfs.bcachefs <dev>
> > > mount <dev> /mnt
> 
> We've enabled the configs, but we don't have good image seeds yet.
> Aleksandr tried to generate them, he is currently OOO, but maybe you
> can help meanwhile.
> He said that running:
> 
> $ mkfs.bcachefs test.img
> 
> gives this error (on a quite big image, I don't know how large exactly it was):
> 
> insufficient space for superblocks: start 8 end 4104 > 4096 size 2048
> 
> Why could it give such an error and how to avoid it?

What was the precise size? I'll see if I'm able to reproduce

> Also what would be a good sets of options to generate seed images?
> We try to "sample" space of different images to create seeds. To give
> you an idea here is what we do for other file systems:
> https://github.com/google/syzkaller/blob/af24b0505c748561efb50f1d03c824d6642f6c0b/tools/syz-imagegen/imagegen.go#L60-L516

--encrypted --no_passphrase
--compression=lz4
--no-checksum

That shousd get us reasonable coverage to start with.
