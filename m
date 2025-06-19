Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF3923AB8B
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 17:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750353870; cv=none; b=gSQVUkXz80jcHIe5SIhffuFuMnuZf60LOt3WaOTtpScSjpSyfTO+zgNrMFxnGzFCo/e0YrnFOalMIIMV4dUhGmSunSh5o/j+3ihJBoj4+c9VtUiwRk0Slynmdg4OcWF3Br37mQ0Y2AyvVNjPAvCa/lECINHSQ7gNRAs4zz0ttQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750353870; c=relaxed/simple;
	bh=aLWc2B6bzjZ3fntYBh3tjK14z/DJjvNDESgA4cUVikk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+MulJ1wJLFd2tNM4avnXtmNCfij6Vnh3WnN3illZcjPdIceKaTXaQy+HwKcMVN04jUZxv7GJfU83LotRlkm4Tc2XpLkxCyzrMHYeQQ9Agqhw+0VCKsVlLl2kAyapFVcOgGZ/vAW/k6stZrnbl1/qp/NdyG4fgPtrYUy7+Bo7M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y1Ufdvsf; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y1Ufdvsf"
Date: Thu, 19 Jun 2025 13:24:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750353864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vQWJ7IstV3NPZFL+fZTipCccwMi0nFQmgk3DZljiHYE=;
	b=Y1UfdvsfCYgcAEiZMUFoIm97D31fjvrJPR2S3mLB8URHQNmuzl6Txc4G2lesLV3u6Hrn0H
	ezMFWKpk2oWzPcN3sOtWw7SeDGJQ4scza7ndRauUcBOYTmnBQC9doiLxpoAM4qVafAMULf
	QttM2g1BQbnRPKR3rcCo837c8sPskdo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Johannes =?utf-8?B?V2llc2LDtmNr?= <johannes.wiesboeck@aisec.fraunhofer.de>
Cc: linux-bcachefs@vger.kernel.org, 
	Michael Weiss <michael.weiss@aisec.fraunhofer.de>
Subject: Re: Maximum extended attribute size
Message-ID: <ukg6svc2xp344mgx6ybkxuy7q6yxrk3jj7z3l3kgnioxf3sxq7@ur4ppfvkfcmd>
References: <8403cdae-bb70-4622-ada7-4b959dd4d33d@aisec.fraunhofer.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8403cdae-bb70-4622-ada7-4b959dd4d33d@aisec.fraunhofer.de>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 19, 2025 at 04:53:08PM +0200, Johannes Wiesböck wrote:
> Hello everyone,
> 
> while experimenting with large values for extended file attributes, i
> noticed that in bcachefs, i can only set xattrs up to a size of around
> 2KB. This size is limited by a check in bch2_xattr_set that ensures that
> the combined bkey+name+value size does not exceed
> U8_MAX*sizeof(u64)=2040B, which would overflow the bkey's maximum size.
> Therefore, the xattr size seems to be always limited by the maximum size
> of the bkey.
> 
> Is there a way in bcachefs that allows setting xattrs larger than the
> aforementioned 2KB? For comparison, ext4 provides the EA_INODE feature,
> that allows you to store xattrs in a dedicated inode and, thus use the
> full 64KB xattr size allowed by the kernel. Is something similar
> available/planned/imaginable in bcachefs?

We do want that at some point, yes. Would be happy to take patches and
provide some guidance, but we need to wait for debugging and
stabilization to settle down before I want to devote attention to that
sort of thing.
