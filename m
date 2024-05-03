Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D947315687C
	for <linux-bcachefs@vger.kernel.org>; Fri,  3 May 2024 17:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714756706; cv=none; b=fxJYOUgW78UpDGLkIIHTqsHSCj/XoffVoS/vFvJGq3DqoDoVkjpOetGfmftgEIH0ugNTbwm1zwYHHR2REHm/J7Z0jC0gkDDPvn0jFODC48AeywM0LSMXQOgzfuMxDWxuC3ckikpqx0po34svKo9vI8UJEwCDXmOoYac1vMPrUGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714756706; c=relaxed/simple;
	bh=0ZhUR1e/PfgyVNIYRtn810XjlL5Zr5lsRB1FczGJ9WA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYJAGq9js5Cd3a2wz3q251r4lxUT7Wys0WS5KramHeKmQtoYYA/Ly6zG9rrSY+uV+Qv6iCLNdw4kZh8fafM6TriVFNeTpDHUbGhGTailJFYBMFvGTLOhRyRhHZCWSHvivGmMENqPqa4jKrQy+9kIJM6AaqQ73NQcDBOYkyRMCyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WSYmlIab; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WSYmlIab"
Date: Fri, 3 May 2024 13:18:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714756702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p1DHhumvnEuBLtnhXEtVwxXBUnkjdRjMgmgk/tC5Cg0=;
	b=WSYmlIabKv0aODBK6eQeQkDhPD89uM9o2DfL99rnizVTe9R26QHASue4iVIoJSKK67tbYm
	2i5XT8DH9lxMPIHccU21ypDB10FfXKn94hVA9EVe+GfHJQ5KbxmjQ+s67BH9U7re/tlT8Z
	Lvzvi1Vg/qSD2zurEz1dyseIT8g3uwA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com, 
	Thomas Bertschinger <tahbertschinger@gmail.com>, Ariel Miculas <ariel.miculas@gmail.com>, 
	linux-bcachefs@vger.kernel.org
Subject: Re: syzbot for bcachefs?
Message-ID: <2uq2qtikasllo4tfonsyw7q5rrompy7rhw54j3dqezwpfrq4n2@6vaec54ocj3p>
References: <oxdwygzxpbpwxgl5v5hzaj7er6oxt2rlmaobkov4t23xqptqrn@gxi3nlapfini>
 <CACT4Y+ZEPWbJsYvWauog95yRFuzZmA=tK-uS+aDT-x=jnc3f7Q@mail.gmail.com>
 <aw5elbevdhwuqr7ecap6i5hepvkjbgs5xexq7nvu2yvuhh5bpb@tmyjcruysqjf>
 <CANp29Y5d3cp_YGfy-3bjJYsNfniXFjAm9WfOUVL5zwk=6weALg@mail.gmail.com>
 <CACT4Y+aNh4oBMpfPdNe7aAJT-hK9WPN5G47d1DN4NkH883OOdA@mail.gmail.com>
 <yg56oeewdosga5bemxyhku37deglpqjxz5ocg7asyeb2c75kap@5bas2aygiama>
 <CANp29Y6wQSb2Zn9Jujhzw4Mij77Nvfo4+2fkpY=ppJ6OCDE6Qw@mail.gmail.com>
 <d6wuvtwgp3z7v7fleewvw6fkjk6d5hpjqpp7p2bmiq5ocf5ib4@ap4iyuhzkpum>
 <CANp29Y70mqP+4m_OmwORqKVk1hDHBwiZSvV43=nABa9pjMp7dA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y70mqP+4m_OmwORqKVk1hDHBwiZSvV43=nABa9pjMp7dA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 03, 2024 at 06:31:30PM +0200, Aleksandr Nogikh wrote:
> On Fri, May 3, 2024 at 5:36 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Thu, May 02, 2024 at 10:28:42PM +0200, Aleksandr Nogikh wrote:
> > >
> > > I think the problem was that I was trying to save the generated files
> > > to a 9p filesystem (so that I could easily take them out of my VM).
> > > But now I've set up a proper userspace image with the latest 6.9 RC
> > > kernel and it worked fine.
> > >
> > > >
> > > > > Also what would be a good sets of options to generate seed images?
> > > > > We try to "sample" space of different images to create seeds. To give
> > > > > you an idea here is what we do for other file systems:
> > > > > https://github.com/google/syzkaller/blob/af24b0505c748561efb50f1d03c824d6642f6c0b/tools/syz-imagegen/imagegen.go#L60-L516
> > > >
> > > > --encrypted --no_passphrase
> > > > --compression=lz4
> > > > --no-checksum
> > >
> > > The mkfs.bcachefs tool that I installed does not know the
> > > --no-checksum flag, so I used --data_checksum=none
> > > --metadata_checksum=none instead. Does it mean the same thing?
> >
> > That's the correct flags, I did a brainfart on that one :)
> 
> Cool :)
> I've deployed the changes to syzbot today and it has already reported
> 8 findings:
> https://syzkaller.appspot.com/upstream/s/bcachefs

Nice, already got fixes pushed for most of them :)
