Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE82E21C9E0;
	Thu,  1 May 2025 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746123047; cv=none; b=NLIhCdbic0+y505wBoObDJ8cLH60/ZKD30cFiOzTogBEqT72SAEhBYmGu/TwJlyOTpIdAw9asuhKQk5ic298PwWwQPER15VCtpMn8EwTUdJ46vDJLrKIoaFiEjGPVQ5QPxqR1kyOnBrciMQ7Y+LTWvv245pqttGrz2PCJjQPg3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746123047; c=relaxed/simple;
	bh=aIeTEMzocUOzPzMhyHXlEzS9jpCaRPqdhqZIWKU576I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0P4PFbDYnD+n+V/M8qFPNabpOnbQ0SwmVKdZW1Dap2H31rDYKCW+8tcJKz/XtV3t6lPQd6FeWXy9IsT+7BWfiiAuLnBXV5BDGo4FW4xjdLqTxZ00PuQ7zhTYr5BIFqNrN3Hh851sodmry4B4ie4gr4/1YaH1hK+gHF6PPVZp1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bOAnGB7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bOAnGB7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352F8C4CEE3;
	Thu,  1 May 2025 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746123046;
	bh=aIeTEMzocUOzPzMhyHXlEzS9jpCaRPqdhqZIWKU576I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bOAnGB7XX5bdqG5G8MPBpUrk1aZIjIvo0uZ2BqWHqgiI1c02Rpvk+EWPFNLYWFw4v
	 qNmWwouUiJfTKzKv7clWmQgqHokpwTwWKSzG8No5KjBPdDABVCX+z2PTwrmNvQlPbM
	 b3HDk/BrW4VrFXh8NcWqY6BCn96Wb0M6Zlu0KaMLZB9xdjhKFdFImBYarCF3DIJtqK
	 VHJjXIU7QVad27iyBzI0mFLqizozyx8rqFLeFGAk/8VCkMX+X3TDBH/y8LSFRb0TWR
	 HmwgPH01KqnAH96VN5/TcvxZId3le+7DDvAQGi8LR+zBRhgg3E03NVH76JZn6TLSgj
	 i+jgVLHdiuYrA==
Date: Thu, 1 May 2025 11:10:43 -0700
From: Kees Cook <kees@kernel.org>
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Alan Huang <mmpgouride@gmail.com>, kent.overstreet@linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Bill Wendling <morbo@google.com>, regressions@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-hardening@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, ardb@kernel.org,
	ojeda@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <202505011109.046221D857@keescook>
References: <ZxWvcAPHPaRxp9UE@archlinux>
 <20241021192557.GA2041610@thelio-3990X>
 <ZxpIwkfg9_mHO3lq@archlinux>
 <20241025011527.GA740745@thelio-3990X>
 <CANiq72nbyqrzGr3Uw_vx-+8DLiv6KbeULrxpyK8Lh4ma15cq8g@mail.gmail.com>
 <Zxu4yhmxohKEJVSg@archlinux>
 <775D7FF5-052B-42B9-A1B3-3E6C0C8296DA@gmail.com>
 <aBOtxplvvpgHed7o@archlinux>
 <D9967EB7-7F4D-4122-9470-DB14700FD906@gmail.com>
 <aBO2XVSisMXtU8nD@archlinux>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBO2XVSisMXtU8nD@archlinux>

On Thu, May 01, 2025 at 07:58:53PM +0200, Jan Hendrik Farr wrote:
> So let's say you have a simple struct like so:
> 
> struct foo{
> 	int val_len;
> 	char val[] __counted_by(val_len);
> }
> 
> If val_len is 10 then foo->val[10] will be considered out of bounds.
> Even if you did a malloc for enough space.

Correct. The "counted_by" attribute takes precedence over the "alloc_size"
attribute (which is also generally limited only to the function-scope
where the allocation takes place).

-- 
Kees Cook
