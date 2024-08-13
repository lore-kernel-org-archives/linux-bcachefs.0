Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAAB2262B
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Aug 2024 06:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723529538; cv=none; b=Jv6CjrZybW/hG6Z4dD4mPoAZHEUSmTHzzGcgqfVcoOBTsmMS6PmGoGThXDWCM1gROCKuGeXDjIUyztiuAn1/xTRdIHuNJS3G/0DzQYtIc2TRgJz73XMw6anHa35fQWpX1mZb+5PEo18B5r+lcf/qTe2nY7orsb7J3zJkna/UC7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723529538; c=relaxed/simple;
	bh=/lWdVJBHS8z3E6Rn4buj3/ImYKLVpEPkQONPwcAaJxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmXk4vHDwSRu0MIJt7MTPnVFyvnRAaYg8L1t0uMka1bqULLvNeQnvP0YcDwMovVvaRePAn1bddhM2znsQkEqI5UEmM6sR9LsDa7YqfAeUjgqLMFLFMSk9EDnsB7c55PwKjE56A9bTGoKUXW5kVwMoQu0zuMpedK8yxvbjdZsezw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CufK6oIQ; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CufK6oIQ"
Date: Tue, 13 Aug 2024 02:12:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723529533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ySEaFnre/8DqrqhBLaPr1AkUGSbJm/JxVfHZT9U3hsc=;
	b=CufK6oIQCdvaBT0N83E3e3+fqO9dy6Wo4WAgWvblcOjntIsC5Bhu5RYnDPA0ID9uCKXVRT
	llu2pSjJTYJAHpH+0ZGlcm48QJGYeQDCZFckuVDObEtTwznGi7OOch1aoNyb8pkMv/N6eG
	MxV+MT4KN/vDDqGZZyprIspB/MQnPEw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Minimize the search range used
Message-ID: <bqeyffnq5hlr5k36do46w5xwlgrgnko73kvwy64glap54ovzef@rsb3mnzp4gct>
References: <20240813040159.375953-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813040159.375953-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 13, 2024 at 12:01:57PM GMT, Alan Huang wrote:
> Hi,
> 
> Changes in v2:
> - In v1, bset_aux_tree_buf_end still includes the size of the prev array
>   when calculating the buffer end, v2 removes it.
> 
> This series minimize the search range used to calculate the mantissa, so
> that the mantissa can have more meaningful bits which reduces the slow
> path comparison when search a key.
> 
> The prev array stuff becomes useless after minimizing the search range,
> so this series also removes the prev array stuff.
> 
> Alan Huang (2):
>   bcachefs: Minimize the search range used to calculate the mantissa
>   bcachefs: Remove the prev array stuff
> 
>  fs/bcachefs/bset.c | 36 +++++-------------------------------
>  1 file changed, 5 insertions(+), 31 deletions(-)

Nice - tests pass, applied
