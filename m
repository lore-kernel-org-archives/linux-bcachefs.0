Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCEF82C8E;
	Fri, 21 Jun 2024 01:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718934073; cv=none; b=jk2xgb55E1R8B7r9I9lVhCjb5LyAly6PNUoesHiqNBIkyUD12+k8x+y0MVdFeuGnGjZErSDlqgB6RRgnYJN6niM/vlDyUVuaDS5YERwstFAdaNbooScf1zU2/hP6NlEIhzxTJSkyHe/hRyGq05pxSDrBcpZzxtWwL5g3ZjKv9dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718934073; c=relaxed/simple;
	bh=UK0ozzcefVg7ErOTkEDCLlno9U2XKwTED2n3K32qZy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fn9g4FnTmDJsSrYJl46dz3rJ9hYKUAxHwHjwpbM5Ha7PR23feREyAHHwVdynUV+ZKUax2zr1G+gydsrWMq/6yZUbzqK5DMQHjuXZxgRIjfDTY9Upof3pb3uDFvkHOifEGUoEYHu8dAMjajSMnCIshXlpiFRv+9VgvabHk2oJEOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lYBUSgpe; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lYBUSgpe"
X-Envelope-To: youling.tang@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718934069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=180PpnJy0hYujW6c1Fomqh5gTiaFoyXWrIapAC/B5oA=;
	b=lYBUSgpekoNhqXCJkx2iln0mo1YpSwrQesGLvbAFqspcgcQgwl1W5QANbeMkPHltmr6O3n
	uu7+pz7xz9p1XNjWKEHMxAxcf+np+DsPV6ZpCGLZBTJTqXzoP49UcbXw/p1evekqM/M6gN
	oPtukEHTIYTDsow8qb5xY6vedK2YR84=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
Date: Thu, 20 Jun 2024 21:41:06 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] bcachefs: fix alignment of VMA for memory mapped files
 on THP
Message-ID: <6bhmifnhlcoh7fjoumqk7ra4d54mwlcrheapya63xg5lzdyg73@74bkrmc43kf7>
References: <20240620012242.106698-1-youling.tang@linux.dev>
 <myw2h2mm7725gegy6pbqf4qpzghrfypnlbn4z6rh6idwfjzpjc@chzxxg47sw77>
 <c24f044a-989d-4661-812d-3e2140f1f626@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c24f044a-989d-4661-812d-3e2140f1f626@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 21, 2024 at 09:11:52AM +0800, Youling Tang wrote:
> Hi, Kent
> 
> Sorry to bother you, BTW, are the following patches still needed?
> 
> https://lore.kernel.org/linux-bcachefs/20240604084610.94558-1-youling.tang@linux.dev/
> https://lore.kernel.org/linux-bcachefs/20240418083103.66703-1-youling.tang@linux.dev/
> https://lore.kernel.org/linux-bcachefs/20240418005055.45482-1-youling.tang@linux.dev/

Yep, sorry I missed those - applied!
