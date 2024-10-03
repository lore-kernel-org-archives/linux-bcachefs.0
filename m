Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D118224D1;
	Thu,  3 Oct 2024 21:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727990885; cv=none; b=WMl2M7fN8yGaDmSIii87QjwZlUOy0Y/1RsEK0FF6GdO6qjlsJ3Ae0nekRrV0ntQrGmYTyPltQ9O5KzmHj2lIPmylM/cvoGqe6IAbn0yKU01FYaV6015swM282tvPT3vBmrWDqsaoL1F1JK8X/d072p+LkuOj0hybN6f/sxVDmuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727990885; c=relaxed/simple;
	bh=2A00fLx7Lv1gvjdxEpEFru2ozWJyOmSeLHg5IGVCOlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBZQs3bYS7rGq5aKGPZWFMmPDblknPzZ76peahUY9bNBYmMnbpfcsYXj9sBjxEJITNhiCzWZN8tjpzCE7xiYMKb4+Mb+Lg9RjGA6KRulWj1Y0Fygl/DTONIQVmm2zSzIOpL2kFYavdl+EAmgIqZ4HnjqBsgO0SkYk+tN0tKZLRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoAmJlQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoAmJlQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A3CC4CEC5;
	Thu,  3 Oct 2024 21:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727990885;
	bh=2A00fLx7Lv1gvjdxEpEFru2ozWJyOmSeLHg5IGVCOlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YoAmJlQP6eTwZqwwiwWgObUxeZF2wVyWvb7BVdUvRcClIE/bbUBSNHDRjWSDmVYQq
	 GhfFUwbz1zb84Y2QUQtom+paSo+ZcEFmvnhjzwBx5nr+GZwB1HooxEWE0RFPO6T4Sf
	 lcfPri6uVT7iz9hAli53BZLaKPfqMNwkpegiw584IRTY3PASD7ObFYrbRjNJHDOXPq
	 vH8p9mq16a9fca4KthXT1EiUIwCsUitRXgb9VdeiHLlag/x8BxSEC+EQqpovfZxGtT
	 aW0+44LrOvltN3qPDDjhEtb5Ut9jqGmPSK7oO54T8s6/UKeonPi1rYt+CfFSb3Iazp
	 WLB01etx/uTVQ==
Date: Thu, 3 Oct 2024 14:28:01 -0700
From: Kees Cook <kees@kernel.org>
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <202410031424.45E5D19@keescook>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv61dCaxScXuOjZg@archlinux>

On Thu, Oct 03, 2024 at 05:17:08PM +0200, Jan Hendrik Farr wrote:
> gcc currently says that the __bdos of struct containing a flexible array
> member is:
> 
> sizeof(<whole struct>) + sizeof(<flexible array element>) * <count>
> 
> clang however does the following:
> 
> max(sizeof(<whole struct>), offsetof(<flexible array member>) + sizeof(<flexible array element>) * <count>)

Clang's calculation seems very wrong. I would expect it to match GCC's.

-- 
Kees Cook
