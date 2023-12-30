Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97151D2FF
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Dec 2023 22:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Su/iHtyh"
Date: Sat, 30 Dec 2023 17:40:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703976061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aPL9HjNhcVqPD8dzsIKc0xX7K6T9gIH6eRuhKS9PZT4=;
	b=Su/iHtyheno4Z5KoWaDx1NjXQoKhZQy0RGX/pUoKnpNHF5/EF1cUEPQCOjEIJ/Q/knE1+v
	s/yN2qRZ3JsdkBS4umWulBuCazHROxEaV1AQy5jrsIqa0jMXErwH6jK/HoHLEsjJU2cwqC
	U27SIjX9pteeQ6EfZghdScH00Z/zmAA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Daniel J Blueman <daniel@quora.org>
Cc: linux-bcachefs@vger.kernel.org, 
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Stack corruption in bch2_nocow_write
Message-ID: <2g6gw7ybne5d5u2ewsbfpsoxslw5vie3d6whlhrcmbombkyzqs@dd6tr3se6fu7>
References: <CAMVG2su=Kt5mkyEHGh5D4YH+1xTUFX3BhOjf-D0bcRTntav3ng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVG2su=Kt5mkyEHGh5D4YH+1xTUFX3BhOjf-D0bcRTntav3ng@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 29, 2023 at 07:43:13PM +0800, Daniel J Blueman wrote:
> Hi Kent et al,
> 
> On Linux 6.7-rc7 from bcachefs master SHA f3608cbdfd built with UBSAN
> [1], with a crafted workload [2] I'm able to trigger stack corruption
> in bch2_nocow_write [3].
> 
> Let me know if you can't reproduce it and I'll check reproducibility
> on another platform, and let me know for any patch testing.

Can you give the bcachefs-testing branch a try?
