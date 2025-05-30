Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4158528CF49
	for <linux-bcachefs@vger.kernel.org>; Fri, 30 May 2025 23:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748646974; cv=none; b=lFu9fAuMJCmgtN9ZBocM+KKS9dGdmGRCWhqTGbhVGFipMSXMRJ9OKQZsMnx5CGLg6r0zPNNiu4SPx5AU4wQU97UZ50taV3ozjBlU6vSkPnZZcw+SkTlQEljV91VKJHhcVYP5hDyWT5hvbC/YpZAgOLIZl1jNDkmseaEpKjWM31E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748646974; c=relaxed/simple;
	bh=GP01z9GqJExO0e6bQ8MDQryDDeuJOj624A/b3GqEYF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D9gQwGeDcl0CkPs1ARRNr0SaDV6Epg0tWzWUuIeAencdZPEAbd39yGb9+HUBy1Nt6Cuklt4b81vbiv8mqq+oir5lpGlp7QYHoeFbWyjDglSQuhasZ7xImj3Pfbe9P+3MVpV3GPAbikHFf9UuNcHoNC8flguHv0IXw+a36PFotfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T6u9/01m; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T6u9/01m"
Date: Fri, 30 May 2025 19:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748646968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xUXWyQtTxo7cNXjgRYQcBm3GOnQ7MnlzcXWMkbFTuas=;
	b=T6u9/01mY8mqaoZvBAAoHUOyfuNL62YJD5llUVThKiEp9UJYPpmQwAcm5zRhFvxpcPPXO6
	HPEsumXmNkl9BVLMfN8sChmlEAeH1rlLyGmeguO3jLzJxfCS+GFk+kGozfqzeuaubhEx2E
	NLPZSefjrc5xc+EcQpqJSJUA4+HYE1Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>, 
	Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
Message-ID: <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
References: <3009813.e9J7NaK4W3@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3009813.e9J7NaK4W3@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Fri, May 30, 2025 at 11:19:32PM +0200, Martin Steigerwald wrote:
> Hi!
> 
> Summary: I am curious why "ls -l" reports 16 EiB as the size of a 
> directory entry. As to what I can see the filesystem is perfectly fine.
> 
> Kernel 6.15, self compiled. 320 GiB BCacheFS on LUKS encrypted LVM. 
> Checksums are xxhash. Filesystem was created recently on self compiled 
> 6.15-rc7 with self-compiled bcachefs tools from git tag 1.25.2. "bcachefs" 
> reports 1.25.1 as version number.
> 
> I have a directory entry that according to ls -l is quite big:
> 
> drwxrwxr-x 5 martin martin 18446744073709551400 DATE DIRECTORY

Yes, this is due to a leftover from the directory i_size patchset that
had to be reverted. As long as it's not causing issues it'll be a bit
before I get to it, I've got higher priority bugs I'm working on right
now (as usual).

Hongbo, whatever happened to that patchset? I thought you were going to
fix it so we could get it back in later?
