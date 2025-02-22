Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9194813CA97
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Feb 2025 14:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740233238; cv=none; b=ZaSDFrrJfPccJ9rUIkOKvX/gHptyJXfFiA54yEcJyQAHL1YaQQubz/jww6ZxvclP1cdCeH69YqXl8dUnM3QpcyZfB2zdxHHsT7zeXUeQ6moDCC8uY4xO9W0TYdMXvl7/drcygKFrt3wY5QnXj2Jc+hQLPQZuiqC6cBsL1n3Pt/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740233238; c=relaxed/simple;
	bh=JoDL0HgW0R2+LYqjjV7VB0fAIsetibawAPp+OSXTa2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KO4VrdajCtN/TlupNqBp6M/dZxjp6ywoqakDvqoF5g6QrL5+0ZMWCAg2JhuDWT0dbeslfCzD8Nsv78qDZhCrHJQ2OiRIs5/Yi1wdReWV1IgYwbt5vAjU0To6l46691qMu1MAayi19eI98GqICs9/AsHxbAIeN6lDZlXuiH1iQGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RdvSu35k; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RdvSu35k"
Date: Sat, 22 Feb 2025 09:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740233224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=12hDZFuuET8/IWzJSq6NgQOafKWg9FuiRIQhyCJLoy8=;
	b=RdvSu35kQh00+UMWrkD/XqwY0XX4VWxvG54op/SwI+fHY19hwjrTtimZk7lJCvnSuFIXBW
	2mPNNzj1sZJ5UCGSRkgWcBFwD2/ifJTTrcLAaNBpfN6DgUlUtLHfAPGrjtBLXsUJoBKfu0
	1YB/Aq1wCdPZz9nTdILrAcs4D/SZBh4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Documentation <linux-doc@vger.kernel.org>, Linux bcachefs <linux-bcachefs@vger.kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Joshua Ashton <joshua@froggi.es>
Subject: Re: [PATCH 0/4] bcachefs: casefolding.rst fixes
Message-ID: <rgtsg2xs422yj6mm5lykq24fj5hpqtr3aqe4cq2uj6fyi3okcg@dncvcfnx56yn>
References: <20250222091853.16487-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250222091853.16487-1-bagasdotme@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 22, 2025 at 04:18:49PM +0700, Bagas Sanjaya wrote:
> Hi Kent, hi Joshua,
> 
> Here are fixes for casefolding docs. Patches [1/4], [2/4], and [4/4]
> fixes htmldocs warnings reported in linux-next.
> 
> Enjoy!

Thanks, applied

> 
> Bagas Sanjaya (4):
>   Documentation: bcachefs: casefolding: Do not italicize NUL
>   Documentation: bcachefs: casefolding: Fix dentry/dcache considerations
>     section
>   Documentation: bcachefs: casefolding: Use bullet list for dirent
>     structure
>   Documentation: bcachefs: Add casefolding toctree entry
> 
>  Documentation/filesystems/bcachefs/casefolding.rst | 13 ++++++++-----
>  Documentation/filesystems/bcachefs/index.rst       |  1 +
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> 
> base-commit: 77308424ba26e1b41a7db5d4eae121841a707c05
> -- 
> An old man doll... just what I always wanted! - Clara
> 
