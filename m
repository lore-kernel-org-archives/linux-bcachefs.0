Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15042114
	for <linux-bcachefs@vger.kernel.org>; Sun, 18 Aug 2024 00:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723941431; cv=none; b=G8nJeS5CCm8lb+8M9+D6SlR4LklQs2f3S3JY1tVdBV0F258/nfUTvRysxfTFCTq8kGqlbUWT07Mpz1/WMFBPQFfxUkNrDQR5fkU167Hwnr7K83YSvNuVs6UR1obneoyu/crNRvdipNNzm8z/UW+6W6ytq4dpYSU5GZpHkvhmxOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723941431; c=relaxed/simple;
	bh=Q3I3+5JnLT4Jd7w3VOY4XUUrUIBjXVnEN/K8TXC7ZGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjUR3eug5CGaYhfupIDzDoP0SsXnh8KhfqrVLdGoFAJoZl+7o2vFvUKanKiFW3ZUt+v9fCZ5qwxzUnpeRTGg8tbAxgr5wXtwIqufuDmNik4GnmkoHt24K0JRiReQGT6qV+ToT3g9N2x/sLJSt2cP2nBbH2PpcAiT921nnLAGRZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dStrkpQj; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dStrkpQj"
Date: Sat, 17 Aug 2024 20:36:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723941425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uYkynEKsx9LuEfcOR/KSUyhfmdNcTOX9jCvZHeH06Ys=;
	b=dStrkpQjxmaWENMIsLRx88SgnfKUzNmRKZ0fpjKIo7G21ceYgO0Czi88iufI7Wv83AcqYC
	EbGSh5ETGXiD8AFdy9p1x3gctDTzFGNDWALXfPIE1Iv2DCRpnn3HDd+B7IWGvtzup5g3oJ
	joryuJBjVbzlD80Do1aY/rfVRGjHUPY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: lee bruce <xrivendell7@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, yue sun <samsun1006219@gmail.com>, 
	wang1315768607@163.com, syzkaller@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: KASAN: slab-out-of-bounds Write in bch2_dev_journal_init
Message-ID: <hcshfmofaowcqbqvdklwhbm4wardtdrlf5lasznnpo7rij3bkf@eg4fppcyqepz>
References: <CABOYnLxyHNxoGGTPTTsE-=rknbQJuto_v6jRdRHG5FJRiphS4w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABOYnLxyHNxoGGTPTTsE-=rknbQJuto_v6jRdRHG5FJRiphS4w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 17, 2024 at 02:38:40PM GMT, lee bruce wrote:
> Hello, I found a bug titled "KASAN: slab-out-of-bounds Write in
> bch2_dev_journal_init" with modified syzkaller in the lasted upstream
> related to bcachefs file system.
> 
> If you fix this issue, please add the following tag to the commit:
> Reported-by: xingwei lee <xrivendell7@gmail.com>
> Reported-by: yuxin wang <wang1315768607@163.com>
> Reported-by: yue sun <samsun1006219@gmail.com>

Do we really need multiple syzkallers running? Is there a reason you
haven't just gotten your patches into mainline?
