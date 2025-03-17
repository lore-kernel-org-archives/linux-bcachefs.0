Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55022417C7;
	Mon, 17 Mar 2025 14:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742220842; cv=none; b=WCBqW8/f6kKb84mDDq+dkZOGDFIyZ5wni0I+7ZZOwjy0LAJ8xJD9/LD8kVPlrzWbWpqWQV9y+XAbeU2713vMqc9teEqiUsOgs5elOf3ExmRMJiU+Cf3Ih7YIuTjCOVKI8P8FgeRUNK89lNbakItfZTo70DZJ/9OTP5YhTHLnQvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742220842; c=relaxed/simple;
	bh=KetjEDEIpNK3M8QcLEfsyRIU1gURvCcBvqSeu3O8Y4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TAp/PKv+cHLheFw0762OZ3zriwkIIblJqtxc6SKBPtoQfseH/uCI3LVSHvokFemCkzA7FVN1G3lkS7BJIOY7CF+ihVXfaSR3FGO7D5kBOdJfHsJA7CIxd60enkfMQxFJZ8DX4yY12IUH/HOSQGoKvkan0yMWpAQ8nF3cqMAyegA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEGAqmaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEGAqmaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACD6C4CEE3;
	Mon, 17 Mar 2025 14:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742220842;
	bh=KetjEDEIpNK3M8QcLEfsyRIU1gURvCcBvqSeu3O8Y4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TEGAqmaFg2dV/ByjFvfDpQBY74I21IYlF7W1EZ0xyleN4H6jqR7VXiLxKJHoqAel6
	 Y8tG3rEzJsfq7V9I7YRByt+CsyDC0oc+HEiNu27qad9bsdI5od+rNmCpFXiLLbzgL6
	 nfCzWnrCp4vCAQvvofOtJGXVR5FNxlqoilmPT8k5cLPQT7FFT4yofuWpv0RRndESUs
	 42B/p/Tc28dfdUGky+UnMTIoUEw1OMU1skoXPK1H3jWiBwgDgvwH0t5+DxSAQfeyQV
	 zP8NDqk/PFpI/VlG3TbHhvoNP+fiHGefGlOnXjJlajPxQHXsajnyNwUUoVc1TsVY0T
	 gbmltAxJoxtjg==
Date: Mon, 17 Mar 2025 08:13:59 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
References: <9db17620-4b93-4c01-b7f8-ecab83b12d0f@kernel.dk>
 <abk74sbsvsuijqhohyenl2mecz6unmkhavkga55fxsld6m6ise@ncbz3xmjlymw>
 <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
 <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>

On Mon, Mar 17, 2025 at 08:15:51AM -0400, Kent Overstreet wrote:
> On Sun, Mar 16, 2025 at 11:00:20PM -0700, Christoph Hellwig wrote:
> > On Sat, Mar 15, 2025 at 02:41:33PM -0400, Kent Overstreet wrote:
> > > That's the sort of thing that process is supposed to avoid. To be clear,
> > > you and Christoph are the two reasons I've had to harp on process in the
> > > past - everyone else in the kernel has been fine.
> 
> ...
> 
> > In this case you very clearly misunderstood how the FUA bit works on
> > reads (and clearly documented that misunderstanding in the commit log).
> 
> FUA reads are clearly documented in the NVME spec.

NVMe's Read with FUA documentation is a pretty short:

  Force Unit Access (FUA): If this bit is set to `1´, then for data and
  metadata, if any, associated with logical blocks specified by the Read
  command, the controller shall:

    1) commit that data and metadata, if any, to non-volatile medium; and
    2) read the data and metadata, if any, from non-volatile medium.

So this aligns with ATA and SCSI.

The concern about what you're doing is with respect to "1". Avoiding that
requires all writes also set FUA, or you sent a flush command before doing any
reads. Otherwise how would you know whether or not read data came from a
previous cached write?

I'm actually more curious how you came to use this mechanism for recovery.
Have you actually seen this approach fix a real problem? In my experience, a
Read FUA is used to ensure what you're reading has been persistently committed.
It can be used as an optimization to flush a specific LBA range, but I'd not
seen this used as a bit error recovery mechanism.
