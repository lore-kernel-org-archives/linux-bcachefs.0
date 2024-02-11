Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2B9FC19
	for <linux-bcachefs@vger.kernel.org>; Sun, 11 Feb 2024 18:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707677502; cv=none; b=PZGb8YWbw3puniaYUapda8MPMlvXQQ64Qvvcj8/wgcQxn+T7PZQ61plkXHYVxNMGcjjZolbP4O0sQuEYNFPE3Zt8pPxwHd2gespplEKbsctFxEHHpcqonT4Fuhm0eHaNm2hg5ao/uelfBZlUkEzeh7yuuiqklsdNy5EdRq3xbjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707677502; c=relaxed/simple;
	bh=NYrKFvg5pKQBWJPGCAEP7+YjxTaKvVXYiIVhXzaOLIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQl58kmJiNtpqLaqIXKxrKCV/fMNtlzGEIGbl5uEhpNU6eL03kPJAM//0a/tuEOq4zWEHOeH46mBtIiIfImlurRtZTU4xSq75l6ogTXJ6CmIlAXMgO4zSQmlk1pzZ1D5pV9zQIXGY4avVCepROyBVIU34CrA/FpbTLMz3NBSgbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gNAgmjzx; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gNAgmjzx"
Date: Sun, 11 Feb 2024 13:51:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707677496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nnelPbgSepiWPsOOxX2n1Zk/FuSZHAUcmGjUShP3MtY=;
	b=gNAgmjzxrfuPMxa5oVuysfnJB7hyskayH4s5m+k23G+vAhsJ52u+NSkMwiAFnINNfRln7r
	yNr77R1oHHsWUdSBmDuq4i65wOIAHjAuEJa7IOc5DiXrvcCr3sTExoGPV1pl0S5mo8ogFF
	tt/es6BvIn3RqXd4r02R9yU65xOMXuY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev, 
	linux-usb@vger.kernel.org, 
	Holger =?utf-8?Q?Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>, linux-bcachefs@vger.kernel.org
Subject: Re: I/O errors while writing to external Transcend XS-2000 4TB SSD
Message-ID: <mqlu3q3npll5wxq5cfuxejcxtdituyydkjdz3pxnpqqmpbs2cl@tox3ulilhaq2>
References: <1854085.atdPhlSkOF@lichtvoll.de>
 <5264d425-fc13-6a77-2dbf-6853479051a0@applied-asynchrony.com>
 <5444405.Sb9uPGUboI@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5444405.Sb9uPGUboI@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Sun, Feb 11, 2024 at 06:06:27PM +0100, Martin Steigerwald wrote:
> Hi Holger!
> 
> CC'ing BCacheFS mailing list.
> 
> My original mail is here:
> 
> https://lore.kernel.org/linux-usb/5264d425-fc13-6a77-2dbf-6853479051a0@applied-asynchrony.com/T/
> #m5ec9ecad1240edfbf41ad63c7aeeb6aa6ea38a5e
> 
> Holger Hoffstätte - 11.02.24, 17:02:29 CET:
> > On 2024-02-11 16:42, Martin Steigerwald wrote:
> > > Hi!
> > > I am trying to put data on an external Kingston XS-2000 4 TB SSD using
> > > self-compiled Linux 6.7.4 kernel and encrypted BCacheFS. I do not
> > > think BCacheFS has any part in the errors I see, but if you disagree 
> > > feel free to CC the BCacheFS mailing list as you reply.
> > 
> > This is indeed a known bug with bcachefs on USB-connected devices.
> > Apply the following commit:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commi
> > t/fs/bcachefs?id=3e44f325f6f75078cdcd44cd337f517ba3650d05
> > 
> > This and some other commits are already scheduled for -stable.
> 
> Thanks!
> 
> Oh my. I was aware of some bug fixes coming for stable. I briefly looked 
> through them, but now I did not make a connection.
> 
> I will wait for 6.7.5 and retry then I bet.

That doesn't look related - the device claims to not support flush or
fua, and the bug resulted in us not sending flush/fua devices; the main
thing people would see without that patch, on 6.8, would be an immediate
-EOPNOTSUP on the first flush journal write.

He only got errors after an hour or so, or 10 minutes with UAS disabled;
we send flushes once a second. Sounds like a screwy device.
