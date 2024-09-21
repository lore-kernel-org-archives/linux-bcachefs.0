Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC71376E9
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 23:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726962324; cv=none; b=lse59Mn+bYSQ0lR2a4WlmJQWeP0eZjIk8+CGPukT1Pnd+8c0EAehW/pZhB0OprUExOBP+nSEUHspYpDePLU545t/xwBbAWRvEx3g4SS9W+VN6ANN20nIhYOqC/Q44xx7gQRDDSX2qF7V96juFmzJGLDOjAcPX3igqNwzsAlAS+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726962324; c=relaxed/simple;
	bh=2I7gZ3aMjWgX2PpSI8OslCKFUqFE14pAYrE4u08dzvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwUJ/TiMbI2yLilceiOZGjQ6CYu20ZkEPLyCxOHq/Ls8O3Er+KPmMcwH+S6eTd4UgU+wLaHWpX9tmQaZm/Jns7woNj8SpPP5vD8IpfKkSnFIzNERa3xbfoJwlX3HS38alSeR5rXQmbdofExNOpX5E9dyQoCzh8KnaqRBaPpiAvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qale5+mP; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qale5+mP"
Date: Sat, 21 Sep 2024 19:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726962317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p4IKuINbbfr4uVjVxqdbpGiGsNOlKn2Emq1n9eXWzJ4=;
	b=Qale5+mPDPNKEB2zBu//G6IV/wRiywszFrMqHNL0lqcdTwpcNRPWD4ysxCOR4Av6cfUyGT
	3WKmEkRgZ1BSww4ouz1qdctLiEjYSIMDAOzUzlDdmUgsR7s+PuJPSH6BBO2t9FcsdmcOYQ
	Y8u5Xk3SKVyCGcb4YW0O13yy94lz060=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hanno =?utf-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: mount hangs / kernel BUG on attempt to mount or fsck /
 bch2_accounting_read
Message-ID: <vn5klwwam3pvalfkexq3uroryx4t6ixpeldjjjm6zl6rmbp3tx@ftthpbbpttzf>
References: <20240917142815.3c1c3c95.hanno@hboeck.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240917142815.3c1c3c95.hanno@hboeck.de>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 17, 2024 at 02:28:15PM GMT, Hanno Böck wrote:
> Hi,
> 
> I'm having trouble with a bcachefs filesystem after an update to the
> latest linux kernel 6.11.
> 
> After updating to 6.11, mounting of a bcachefs partition hang during
> the boot process. I booted into a rescue system and disabled
> automounting of that partition.
> 
> Afterwards, I tried fsck on the device, which didn't work with
> bcachefs-tools 1.9.4. I upgraded to bcachefs-tools 1.11.0.
> 
> Running fsck.bcachefs hangs at
> bcachefs (vdc2): accounting_read...
> 
> Doing either an fsck or mounting the partition leads to a BUG in kernel
> dmesg. I'm pasting the message below.
> 
> Any suggestions what to do next? Ideally, I'd prefer to be able to
> rescue that partition. I'm not sure whether downgrading the kernel
> again to a previous version is safe. (It looks like it auto-upgraded
> some things during mounting/fsck, see dmesg messages below.)

hmm, it seems accounting keys ended up out of order in the journal
somehow - that's odd.

Fixing the BUG_ON() and getting you going again will be easy, but I want
to know what the underlying bug was...

Could you run 'bcachefs list_journal -a -k accounting <device>'?
