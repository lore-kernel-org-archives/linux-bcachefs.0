Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021BF1CA91
	for <linux-bcachefs@vger.kernel.org>; Wed,  3 Jan 2024 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k4US70Ai"
Date: Wed, 3 Jan 2024 12:36:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704303415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2VR7p6fEntKtCzZhQxTJltWzMIRG4d+lOECq60/UJPY=;
	b=k4US70Aixc3yC37X89UzmAtbJ6eERnk0WPjVIvj/BsXboklk5xJniPBCb5vvMeWd0h+LAg
	CkEMU7q2GLGYSOiFNFJdJ/6+1pxyd+c3ztPcHaW43dEk/KJyjH/tSpxyXB8qlx2rOoe2Xz
	7RwPndBvo9aIrWtnM8BjUSZR3OZVwPM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Daniel J Blueman <daniel@quora.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs-testing BUG
Message-ID: <rbw2cp5wzafgfgyla7bh753pqnzeqiekfuttru5wisvutbpzw4@7k7nr52mtbxp>
References: <CAMVG2stQo_6aJ7U1FuHQDp-82DiGa2adjdBV7X7GDK8Q5qJ5DA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVG2stQo_6aJ7U1FuHQDp-82DiGa2adjdBV7X7GDK8Q5qJ5DA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 03, 2024 at 02:37:08PM +0800, Daniel J Blueman wrote:
> Hi Kent et al,
> 
> On bcachefs-testing SHA 67503f8d4fc, I was able to trigger a BUG macro
> at fs/bcachefs/extents.c:570 [1].
> 
> You'll need a "modprobe brd rd_size=536870912 rd_nr=8" before the
> commands listed, however I wasn't able to reproduce this due to two
> factors - existing filesystem state from previous runs, and a
> background process corrupting some disk blocks on the first device.
> The latter will also affect state in the former of course.
> 
> I'll later figure out how to provide determinism in these areas for
> reproducibility. Let me know if this testing is useful and if I should
> be on master or downstream.

Yes, this testing is definitely useful. Let me know once you've got a
reproducer and I'll turn it into a ktest test - thanks!
