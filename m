Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E491B450EE;
	Mon, 17 Mar 2025 19:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742239467; cv=none; b=szlhOYL30k8BtPOaK5qQ78v2MnwE/ymkkrKUSsDYd+frk6C8+IrGiw43c73p0WFzJB7mY5ePx3ypgN2pYj4GxfvBQp7RTqnjFQuyz+1pybnTlWd0YPcd1VFMN3nzAO4/U0KiRd5XDUfTuTJXQds+HT0W1cbd2AOebD4rCPLmRes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742239467; c=relaxed/simple;
	bh=v/djZ2xSvGJ0oE9RJH8kxqkNFu4xlH62IkDpZ8mQ+KE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q5dYhyaAkXeyE+Db44xpXxWCQDeMYFlozEVg2+remwIT1KzeCsunqYa0QlPAHSaLjiI493NdHtvvOYxE0maHEnOlQkWl9evdWSa2ddKL6zIPbrBz1m44A+lZ9XCbkW2zCDM5d3Ad+0+KrUNwc7Y+kYZNS4q1yo6RLwVUo+kAOeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KnlS+NRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KnlS+NRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA7CC4CEE3;
	Mon, 17 Mar 2025 19:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742239466;
	bh=v/djZ2xSvGJ0oE9RJH8kxqkNFu4xlH62IkDpZ8mQ+KE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KnlS+NRuqDIIRDeSPMkJG3weiogW/CbFSC1feS6AnggrZYYq4+Ybb34lraXNTnAe3
	 8dMfMtNpZAfVky+IUGw4hd6JVOlgDiw/ID8Wbl35s2s19/KiD61QDD5VrIhLjzc0cw
	 YGhEIBoUyuyuYTHYFmQM/V4AoVaUu2lHPYH0q+TjmZ28SfJHB6A5ip7bj/vUsDhY8e
	 ItO7ve90B4x68pHYTY5FF15IS60xJ0kSMdLbm3MDe6+9fzForMLvKC5GwsibPHN7Aw
	 OmbOsH7VPflmVVVs2kRalm6Q0Utyo33Fvjzsi4EPB8q65PQ/KuL5ZX2lZtz4/FW1bM
	 uJsL60132RS9w==
Date: Mon, 17 Mar 2025 13:24:23 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
References: <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>

On Mon, Mar 17, 2025 at 02:21:29PM -0400, Kent Overstreet wrote:
> On Mon, Mar 17, 2025 at 01:57:53PM -0400, Martin K. Petersen wrote:
> > I'm not saying that devices are perfect or that the standards make
> > sense. I'm just saying that your desired behavior does not match the
> > reality of how a large number of these devices are actually implemented.
> > 
> > The specs are largely written by device vendors and therefore
> > deliberately ambiguous. Many of the explicit cache management bits and
> > bobs have been removed from SCSI or are defined as hints because device
> > vendors don't want the OS to interfere with how they manage resources,
> > including caching. I get what your objective is. I just don't think FUA
> > offers sufficient guarantees in that department.
> 
> If you're saying this is going to be a work in progress to get the
> behaviour we need in this scenario - yes, absolutely.
> 
> Beyond making sure that retries go to the physical media, there's "retry
> level" in the NVME spec which needs to be plumbed, and that one will be
> particularly useful in multi device scenarios. (Crank retry level up
> or down based on whether we can retry from different devices).

I saw you mention the RRL mechanism in another patch, and it really
piqued my interest. How are you intending to use this? In NVMe, this is
controlled via an admin "Set Feature" command, which is absolutley not
available to a block device, much less a file system. That command queue
is only accesible to the driver and to user space admin, and is
definitely not a per-io feature.
 
> But we've got to start somewhere, and given that the spec says "bypass
> the cache" - that looks like the place to start. 

This is a bit dangerous to assume. I don't find anywhere in any nvme
specifications (also checked T10 SBC) with text saying anything similiar
to "bypass" in relation to the cache for FUA reads. I am reasonably
confident some vendors, especially ones developing active-active
controllers, will fight you to the their win on the spec committee for
this if you want to take it up in those forums.

> If devices don't support the behaviour we want today, then nudging the
> drive manufacturers to support it is infinitely saner than getting a
> whole nother bit plumbed through the NVME standard, especially given
> that the letter of the spec does describe exactly what we want.

I my experience, the storage standards committees are more aligned to
accomodate appliance vendors than anything Linux specific. Your desired
read behavior would almost certainly be a new TPAR in NVMe to get spec
defined behavior. It's not impossible, but I'll just say it is an uphill
battle and the end result may or may not look like what you have in
mind.

In summary, what we have by the specs from READ FUA:

 Flush and Read

What (I think) you want:

 Invalidate and Read

It sounds like you are trying to say that your scenario doesn't care
about the "Flush" so you get to use the existing semantics as the
"Invalidate" case, and I really don't think you get that guarantee from
any spec.
