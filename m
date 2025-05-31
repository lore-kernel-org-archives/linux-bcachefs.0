Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DDC76025
	for <linux-bcachefs@vger.kernel.org>; Sat, 31 May 2025 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748708980; cv=none; b=H+vmBriQuQs4vjtaDB6GLijNMmFKKc3vwTdABXzBZrFS3/OnA74PF3orvgMvhWwa1w3f9cka8Czr32Anmn1ankRdlQ1WB1b7FOjGWoXXlDAjA8Xt7Kht3uyqt6Kfwhh04KaUyTnEGTATpTiijJ015ovzaMW9D3bPvKienSfdO+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748708980; c=relaxed/simple;
	bh=MsTzgJW8MPTFLY7ySgY8+tXA9Z7tocIQZ2sXQ8KMC24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpPjZClbGQgBZse0gYB7aaZxUPrCIOoHT6zyN97rao+O2EfeYH3zMn/lN3SkdqXnTIjXI8t2h/s2HIA2SXB8opdo2ujsWj8drjfoeZ9OWOmeeDCksGMMq/YtpkYnssjcBp+6iK8/pH1P9sASZbi8oKGqbtCZJgmLfUTjYs8ARCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cSEVHSdK; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cSEVHSdK"
Date: Sat, 31 May 2025 12:29:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748708974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Na8VNIGFbC/wJUN8S7ukHEixQrsqhK5wXZOjKZoozPY=;
	b=cSEVHSdKAFAPz4OOkuHkXKRYewQqfZ/e+oc7c6Es5+5syXIL6lE5ukRVqAfB8IteYN9npP
	HLX3abE55u4cwCn/K0c0F/j2BRJtkINzojC8Xmml008359gOYIFGObcmd2GnMJXQna2baa
	IWaEeh88FzrIjRFDM6+dFqjDiVcnc+Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Hongbo Li <lihongbo22@huawei.com>, linux-bcachefs@vger.kernel.org
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
Message-ID: <4j4cpy22wdby6bls6pd754w53kvnmni47mulesvypzn3tduwsi@ovmokfddxvwc>
References: <3009813.e9J7NaK4W3@lichtvoll.de>
 <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
 <5016808.31r3eYUQgx@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5016808.31r3eYUQgx@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Sat, May 31, 2025 at 11:07:46AM +0200, Martin Steigerwald wrote:
> Kent Overstreet - 31.05.25, 01:16:04 CEST:
> > On Fri, May 30, 2025 at 11:19:32PM +0200, Martin Steigerwald wrote:
> > > Summary: I am curious why "ls -l" reports 16 EiB as the size of a
> > > directory entry. As to what I can see the filesystem is perfectly
> > > fine.
> > > 
> > > Kernel 6.15, self compiled. 320 GiB BCacheFS on LUKS encrypted LVM.
> > > Checksums are xxhash. Filesystem was created recently on self compiled
> > > 6.15-rc7 with self-compiled bcachefs tools from git tag 1.25.2.
> > > "bcachefs" reports 1.25.1 as version number.
> > > 
> > > I have a directory entry that according to ls -l is quite big:
> > > 
> > > drwxrwxr-x 5 martin martin 18446744073709551400 DATE DIRECTORY
> > 
> > Yes, this is due to a leftover from the directory i_size patchset that
> > had to be reverted. As long as it's not causing issues it'll be a bit
> > before I get to it, I've got higher priority bugs I'm working on right
> > now (as usual).
> 
> The filesystem is perfectly fine to as far as I can say.
> 
> And I have no software in use on that filesystem that relies on any 
> specific value or calculation there¹, so absolutely no hurry from my point 
> of view.
> 
> [1] I am not even sure whether it is save to assume anything for directory 
> size in user space apps. "du" for example does not seem to take it into 
> account – at least it does not pick up the 16 EiB –, not even with
> "--apparent-size". BTRFS shows some value there that appears to go up with 
> the amount of directory entries. ext4 and XFS do as well, divisible 
> through 4096.

Apparently this did break sshfs.
