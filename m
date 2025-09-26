Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4167B24A066
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Sep 2025 03:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758858142; cv=none; b=u98iCUMIbyvyOIGfryEBFTCyi53XbuUrEOF1vZxL72W/zca+hh8XhhB3pboxGx8oB2v5GLrrnhaurAA2sf41JjhTf1qfCGDQb+s80c6R1ILmUP5CgCIVXThrwS0JuEmHRkHolvj0gb385ATEUl8woansbCKokf1y1t/9+pu8tsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758858142; c=relaxed/simple;
	bh=LBRawg10XyIgSEgHUccoCSns2ceVoJnkcHzrcF0yX+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3Qnf0V5DBnMaRd0qCgJv3kNOni/I7zfntqQaVyKEeFDeBnw1IXeK62bwbFAj3Y6S3isVjjummO2dzRTPGYn3l61K6zKEF9+XSdzX2EVqpsACkxtsLb68Xra64VGYGGwP/0+Avwdp/Hf/g+PeJMDgL6DMCeEZFFUAzcS6+OKNE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t2MRf4dd; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t2MRf4dd"
Date: Thu, 25 Sep 2025 23:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758858128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BB3egd0C+LpwzwNTJp/ZFLG0iDJbaS+ezLeL3Yrhhp4=;
	b=t2MRf4ddknvLHpE7QfUVZqiLP+8abckyy4i+xW+AzYlHZglejPBrn7b+9o1uP7D5nS5zX9
	QxMjN8JVhZMx+FM2cmTKzS9uFvZPzbXjDmHaZtwh3l7B5LJ83QefFVGKmXTK0oMUDzLcWc
	eRNEAHh9ndOEAW1dnKW0CHh4qojtC08=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH 3/3] bcachefs: Move the link counting check to the VFS
 layer
Message-ID: <frs3oa3te2yznm2yttqfm2pjqdwlecwkad6y6o5dymyvk2jh4p@7zncp5imxdjp>
References: <20250926022150.493115-1-youling.tang@linux.dev>
 <20250926022150.493115-4-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926022150.493115-4-youling.tang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 26, 2025 at 10:21:50AM +0800, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> Currently bcachefs only performs link count checks during link operations,
> during rename and mkdir operations, the link count should also be checked.
> 
> This patch moves the checks to the vfs_{link,rename,mkdir} functions when
> sb->s_max_links is set, eliminating the need for filesystem-specific checks.
> 
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>

I applied the other two patches, but not this one. We can't rely on the
VFS for checks like this, there's lots of routes to modifying the
filesystem that don't go through the VFS.
