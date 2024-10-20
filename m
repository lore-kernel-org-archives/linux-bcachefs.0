Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0729197A77
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 23:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729465203; cv=none; b=rcqDnGdiikq9CSq8rFXqIuOf9Mkdu+vF2BUVdLkV8npgkFeCcK5ivDSeIMSgyOvCARTo/H+DzegA81gg32p9pH5/I86V0jbYMmsmGWq2ZwuFxp7+O6+H/MM43XkQNyHuUCuWJC5VDQyLRtN4Guy6G8uMV5/fqf4szPF6kp04Dc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729465203; c=relaxed/simple;
	bh=r1t/7D0pYRPG2E/M/7IuuRhKVRk4Cmq0nry9jEuGx4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rsvfSuqUy0wIbrNvGdZcysuXceah2DcvfxFJ0rMFDnRijgsdLAQyPOLu8rKqh29iDp282vuIx7KN8hyL7b4C14tFielhTObuSptoIPQgNdMhMig3mRVUywThj8xDue/n6gSLh5DJbkEe56rN0893EEHlF+yk8+PFJHcyXDLexfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dTwyxFFd; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dTwyxFFd"
Date: Sun, 20 Oct 2024 18:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729465198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I7g0yyOInSPznaZl+/Gj1UmG9Ma2Fz/oghcys/KtPyQ=;
	b=dTwyxFFdaRGqeNmmhXioTTIASjAEgltr7XEn7bye99yf/R7BGaeaP9wfwOLimgtD3zna9l
	Di0RHKfZL39u3mLFBr8M7Ykbo6O5jpRF2mvRBM8LO6mw/WVH/HdLTGi/9DKsbaABb5n2T2
	paDHQ/IN3D7wgHAWQB9EqIQsteawdng=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Use str_write_read() helper in ec_block_endio()
Message-ID: <6c3gwxcooredrdbzsiafl4fodea7oqfcvxj3zvhd3tdsqyyqvi@mom6q2rg237c>
References: <20241020112046.52890-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241020112046.52890-2-thorsten.blum@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 01:20:46PM +0200, Thorsten Blum wrote:
> Remove hard-coded strings by using the helper function str_write_read().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Applied
