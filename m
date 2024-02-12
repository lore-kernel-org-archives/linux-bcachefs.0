Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BF73A8EA
	for <linux-bcachefs@vger.kernel.org>; Mon, 12 Feb 2024 20:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707770552; cv=none; b=Z0CF5RMELNB0nGAcTEpUo8CiigbqEfQ0zK9FV/362rlRNdTwt/mO7wfypi97Qdn6W4o5cfDYkW6aoIH+Qjl7rluYLKEnOOcp5T+dVxlM1iGfp96prQ5rkqhh3cDKWDJqRHHlIkx8xy1oLrCo9oN5SnKpBdjr/SoxFjH+c4FsyV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707770552; c=relaxed/simple;
	bh=AkzjM/MFik3gQffQSPfJIif8jEQKCQAulCjbf4PA/lY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3I9pOhusN/SP2mZn/OZe+49szcPZ42OhRm+RaknMKQNTZC0cW2kIHGmw2STef0fkJja/T8XOnKwp2cvIL8KfYHKkv6A4J+c49n9/FnY5xEbL1tTdd4usj8uRp4WCfK2AOTYm7Nk9dMwXd20KXTut0CfWnr/P9k6+IztiKBwU5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=abzzEBuw; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="abzzEBuw"
Date: Mon, 12 Feb 2024 15:42:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707770549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wk5/3LiMu1qZi5/LfqpfNetrRAwSWbOpLB6vhC/S/Z0=;
	b=abzzEBuw28TfrE7mwtg2kz5RRM0VVFREAfxvkuNQimtrOJgtDawQToSlM4Co2Xn5o1N9TE
	YhB8ryqzTAlS1sJgX0CcP25XaFEmKP+enHui78SN5lDgf6/pVx73FOwS5Zni2WBtZ9NaVA
	tb4gM58fcwO09h78OJm+YzcuT8/eXVA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev, 
	linux-usb@vger.kernel.org, 
	Holger =?utf-8?Q?Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>, linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: I/O errors while writing to external Transcend XS-2000 4TB SSD
Message-ID: <ypeck262h6ccdnsxzo46vydzygh2y6coe3d4mvgermaaeo5ygg@4nvailbg7ay3>
References: <1854085.atdPhlSkOF@lichtvoll.de>
 <5444405.Sb9uPGUboI@lichtvoll.de>
 <mqlu3q3npll5wxq5cfuxejcxtdituyydkjdz3pxnpqqmpbs2cl@tox3ulilhaq2>
 <6599603.G0QQBjFxQf@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6599603.G0QQBjFxQf@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 12, 2024 at 04:52:09PM +0100, Martin Steigerwald wrote:
> Kent Overstreet - 11.02.24, 19:51:32 CET:
> > On Sun, Feb 11, 2024 at 06:06:27PM +0100, Martin Steigerwald wrote:
> […]
> > > CC'ing BCacheFS mailing list.
> > > 
> > > My original mail is here:
> > > 
> > > https://lore.kernel.org/linux-usb/5264d425-fc13-6a77-2dbf-6853479051a0
> > > @applied-asynchrony.com/T/ #m5ec9ecad1240edfbf41ad63c7aeeb6aa6ea38a5e
> > > 
> > > Holger Hoffstätte - 11.02.24, 17:02:29 CET:
> > > > On 2024-02-11 16:42, Martin Steigerwald wrote:
> > > > > Hi!
> > > > > I am trying to put data on an external Kingston XS-2000 4 TB SSD
> > > > > using
> > > > > self-compiled Linux 6.7.4 kernel and encrypted BCacheFS. I do not
> > > > > think BCacheFS has any part in the errors I see, but if you
> > > > > disagree
> > > > > feel free to CC the BCacheFS mailing list as you reply.
> > > > 
> > > > This is indeed a known bug with bcachefs on USB-connected devices.
> > > > Apply the following commit:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/c
> > > > ommi t/fs/bcachefs?id=3e44f325f6f75078cdcd44cd337f517ba3650d05
> > > > 
> > > > This and some other commits are already scheduled for -stable.
> > > 
> > > Thanks!
> > > 
> > > Oh my. I was aware of some bug fixes coming for stable. I briefly
> > > looked through them, but now I did not make a connection.
> > > 
> > > I will wait for 6.7.5 and retry then I bet.
> > 
> > That doesn't look related - the device claims to not support flush or
> > fua, and the bug resulted in us not sending flush/fua devices; the main
> > thing people would see without that patch, on 6.8, would be an immediate
> > -EOPNOTSUP on the first flush journal write.
> > 
> > He only got errors after an hour or so, or 10 minutes with UAS disabled;
> > we send flushes once a second. Sounds like a screwy device.
> 
> Thanks for that explanation, Kent.
> 
> I am the one with that external Transcend XS 2000 4 TB SSD and I
> specifically did not CC bcachefs mailing list at the beginning as after
> seeing things like
> 
> [33963.462694] sd 0:0:0:0: [sda] tag#10 uas_zap_pending 0 uas-tag 1 inflight: CMD 
> [33963.462708] sd 0:0:0:0: [sda] tag#10 CDB: Write(16) 8a 00 00 00 00 00 82 c1 bc 00 00 00 04 00 00 00
> […]
> [33963.592872] sd 0:0:0:0: [sda] tag#10 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK cmd_age=182s
> 
> I thought some quirks in the device to be at fault.
> 
> However while Sandisk Extreme Pro 2 TB claims to support DPO and FUA I see
> 
> Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> 
> also with other devices like external Toshiba Canvio 4 TB hard disks. Using
> LUKS encrypted BTRFS on those I never saw any timeout while writing out
> data issue with any of those hard disks. Also with disabled write cache
> any cache flush / FUA request should be a no-op anyway? These hard disks
> have been doing a ton of backup workloads without any issues, but so far
> only with BTRFS.
> 
> I may test the Transcend XS2000 with BTRFS to see whether it makes a
> difference, however I really like to use it with BCacheFS and I do not really
> like to use LUKS for external devices. According to the kernel log I still
> don't really think those errors at the block layer were about anything
> filesystem specific, but what  do I know?

It's definitely not unheard of for one specific filesystem to be
tickling driver/device bugs and not others.

I wonder what it would take to dump the outstanding requests on device
timeout.
