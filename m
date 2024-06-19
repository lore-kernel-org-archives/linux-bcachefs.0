Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BB812FB27
	for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jun 2024 12:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718800166; cv=none; b=iSiyLzX2CWHZVNLR0K4/Oq76nTlGKXxndZVNQW9pU59KasIx+hX8ZskrCfNxdbeUpX4M8SSfor8ulKVvslRLPKRsU5pI6qhoUGwEEUAfrSvi0skrYe2qJZFnyQBF1c+eJ/KVMuSARk8yZyVJvx8L9xgSzZvLLvp5/06IMbtqrGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718800166; c=relaxed/simple;
	bh=NO77UmiMInfmZIs5r9g4AWpFEcOFw8yCv7gcRf36cUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYY820yNCxLe8DQIXqyk5q08TOY6+YcdjOPCb1aN4HFZaa1w2GhiFQmaJe+TqLCagmc9XNmHFMcnb0JjmgzQMllaGRb7M5UYxprYTSsj/ueXUE0JzmXwMjt0Zt67eIi5lQI9ikscEPmaDDZqaWlTxqssq2spdSXpNL24Xd9IvG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gA1laiJA; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gA1laiJA"
X-Envelope-To: lihongbo22@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718800160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EOoahwIAkr8gmCnQRerR31X1f/5bKFmVIyax6t7IxI4=;
	b=gA1laiJAxAV/3BU/5J6GAy6FjG6SDuG2C8POpUUityBJs1pkrLGrbYGMJ02wrsHAhyxQPS
	sFiD2XG4grRolThg4phZgX+IG03rKBgLYVJun+Kf4v+XrtAnWJJBTj1vqU36Swn4JpbJIa
	8i8nJjLwKzhEVNBd0S8yvd46KvjtAK0=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: christian@brauner.io
Date: Wed, 19 Jun 2024 08:29:14 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	christian@brauner.io
Subject: Re: [PATCH] bcachefs: support idmap mounts
Message-ID: <4cekkoapbcpcqnzbnvrb32dbf5gnoyrslzs5fx2e6nyzpksrq7@pzexedrcythz>
References: <20240615102038.3110867-1-lihongbo22@huawei.com>
 <fhgec4fmisjfp3sirxlkwl5napoitzxkjdhvvmebmrvlalcqba@mmh2m45hpojb>
 <7611b61b-0d75-47ed-ac5f-4a0ef123f108@huawei.com>
 <l6nh3aopbeytzbe6n5w35dhmgbo7ucz6kk46o7l6m7qui4isl2@kbgadvicrt7d>
 <ef5899f6-eb82-419c-b3bc-f7e8ea6bd418@huawei.com>
 <wdgnznhxov6abj6b5m2owrgjad4eriijh6nfhy6cds2tl4527e@ueth2dbhhoid>
 <77f02a73-524a-42ce-8636-c2f805f818ed@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77f02a73-524a-42ce-8636-c2f805f818ed@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 19, 2024 at 09:04:43AM +0800, Hongbo Li wrote:
> 
> 
> On 2024/6/18 21:54, Kent Overstreet wrote:
> > On Tue, Jun 18, 2024 at 09:00:53AM +0800, Hongbo Li wrote:
> > > What's about xfstest local.config?
> > 
> > just run L(*G#F$&* ktest, you shouldn't need me to debug this...
> 
> Apologize for this.

it's fine :) hop on the IRC channel and ping me if you have any issues
with ktest

https://evilpiepirate.org/git/ktest.git/

irc.oftc.net#bcache
