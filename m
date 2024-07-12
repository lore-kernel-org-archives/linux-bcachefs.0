Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDAA125D6
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jul 2024 14:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720794565; cv=none; b=uUxf+c210oD3SfFdhs4f7KMxsnaZxrtaVP9kG0vhpZT26HuSMiO6/jDVggSL2b1tcIM9uLb7yWAKeN7piKDSWnBx1+b5KvDY+NyvrLEui04hJOSoiHWitAs4lzkzRmD7X0cDQm1I/3QpFEgJ0ltsT6w2o4E7qgszccPIWXCkEaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720794565; c=relaxed/simple;
	bh=swCb8uBYJ69Tq1+LNEnOCIOh0ygyUwkLT1Ot3wDjMR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G7gHWrRaHRCiwmuUWA1p5HgoFtGuUt1kbci/6yRR+LnQomB0p5e/5f74Fwh2ZYTZaRA11zUKJAx/AkbhRDrEQA4BPhgiCrEOqBo6bgSqAyp9t7UXNkqAqV1chY7pJBg9hOkXv1cRXpMm8fludCL2cGENzuRMS0P+VSJUCg00heY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n1FX3pPj; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n1FX3pPj"
X-Envelope-To: lihongbo22@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720794559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9U6Df2TMKToE9Hx4MZeTM3o1L6kR/URH+aokCJGuaEE=;
	b=n1FX3pPj/7S6gLXHfWjG+RdoTs1Oo41wE2LZjhAoqCDgBqn4HO2FnPlOEJ5njzVlQ7HcFX
	AYDqZ4TWFK5PbBOj7Y5jeMYc4y/c4KamzW4Ru09Jj2eT7bCgWl7ZXaVnOoaq8yJa+ywSDn
	FsXqSMqxitD7MfOA60WXiAt8XlRF0pw=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Fri, 12 Jul 2024 10:29:16 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: hung during bcachefs umount
Message-ID: <576l2isttternywqc3t4dcmehqnsssvcenjegt4yhgdbplpg52@eaijyosluq7n>
References: <bdeaf82d-9db7-4c6c-80e0-dc6e93a19fa8@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdeaf82d-9db7-4c6c-80e0-dc6e93a19fa8@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 12, 2024 at 05:41:31PM GMT, Hongbo Li wrote:
> Hi, Kent,
> I found the latest repo( 69558c638c465a79be3a08bfeb3d5a15979cbe42(bcachefs:
> fix ei_update_lock lock ordering)) on master branch will cause stucking
> during bcachefs umount.
> 
> Here is the test step:
> 
> ```
> mount -t bcachefs /dev/loop1 /mnt/bcachefs
> umount /mnt/bcachefs                      ---- stuck here !!!

try a lockdep build
