Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E81CA5A
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 05:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729921733; cv=none; b=AY+7osedUzd/zIWNoJ70vPdOQAwQkqza5GuUdHFvNqD9bAbpqa3i29iybfX1MQa9kwLF1cMx0SVyKYbfPWRdOR7DL76h86rX/h2KV2w7MVs/XRCv2htrjCygwSBUfkXGKKU7Z175DcrzJo5AV67ol+uz3+hNIuQTHFHS3TBrLxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729921733; c=relaxed/simple;
	bh=ofxCTG9gymIDN2Yly1j0FN6mbPM5vvNtYnunvelIsrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Asr9TU5Hp0UlOx3i5gPQvpGYYkfTOCnyJSBKVWA/ZVzPEsS8m9hFp9KOql2IpO53NnS2jHleFkQ23LTksc5y8Ff5qDodvWe0e49IgqgU7AMxYQVXMukAoqaMqeZI3VLOOWPQMZOjgw7b6YN3pyNKXNA97imgrx5KtEvGJUzpyIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UEuehQc4; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UEuehQc4"
Date: Sat, 26 Oct 2024 01:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729921729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/TQlWfoe1r+W7tT/mCMzIpvSilhRwVOTxmHXpQh36Wk=;
	b=UEuehQc4RkRCnl3GF+xBp/ji5kuU98E5dma/92FJH41qydIiFnO739vuIR4DWslJH+la5A
	Br/wYBC6VV/ER7vZwFj81R+qC6Y7/VMkBi6z3deHrkme9WZQCpD/m6HNrK0ReEsj9LaAE/
	QF9941u2G/UvSqxVrJpM1WLuSeQA4ts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: kent.overstreet@gmail.com, lihongbo22@huawei.com, mmpgouride@gmail.com, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH resend] bcachefs-tools: fix build failure when
 BCACHEFS_FUSE=1
Message-ID: <mgbpuzwcumvhhfpq2ixbldmamx5rhc3prszrx36esi7smhc7y5@evgq7dh3zqxa>
References: <20241026042807.483324-3-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026042807.483324-3-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 26, 2024 at 12:28:09PM +0800, Integral wrote:
> Currently, when BCACHEFS_FUSE=1 is set, bcachefs-tools failed to build.
> Replace "bch2_trans_do()" macro with "bch2_trans_commit_do()" in
> cmd_fusemount.c to fix build failure.
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>

Thanks, applied
