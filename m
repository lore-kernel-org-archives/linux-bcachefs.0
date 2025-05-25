Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1783596F
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 May 2025 02:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748139599; cv=none; b=QrrTUMi0Uovv7jJl8NOlGtyO7CAJUs2xop5cOHxELiMYQXE36FoHzFp5x51D4PaWekRzUScCB9MBDecOA/EY08uylvvvhYSfFANV2QQ9KADf89oAEoZ1qJR5ZlN3lEt8SdMG/KYC6jLqaDJn+vykQ0678XYfrq1qdl6Ls9T3fm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748139599; c=relaxed/simple;
	bh=WwiA0RVvpCAR/9OcjdEg2wCEm8r3t9KZqiKU1YxZNoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TnDGX+WoTOBR+xupyklNWo1qN4SitxDW/EK9Bnuksd5uCwwGLBdmCiVNatSPfrWXQG13x8R34woHgWqS/YixINzHEULKA8jNy4vaWD5mOruggbANvJYWhs9NQTdk/v1rIYeP8c9v41S6Q0teQifr4NSHKfwcy3/cfrbwNwCRFj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HnSqQaZ2; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HnSqQaZ2"
Date: Sat, 24 May 2025 22:19:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748139593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=unYxqcHTjdMQNtlPEZKhFscFLUMaUxMeQWTbJQV5L6Q=;
	b=HnSqQaZ2tUoeLy8UbKs8Yo2zwmnUwrK18SNN+CO+rWKauGTYK3QRp7q5dxHWjNTuNz5Qht
	Fmdzs2+kB8j7Ty6U0+/vbq/km2aXIn49/BJvl8rNeQtTUdsOmZAnPu+GfNnHoPmbFnMDxI
	apwas6V4zfE0PWmi/Ee9FCjAaZEMJJM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs changes for 6.16
Message-ID: <dmfrgqor3rfvjfmx7bp4m7h7wis4dt5m3kc2d3ilgkg4fb4vem@wytvcdifbcav>
References: <oxkibsokaa3jw2flrbbzb5brx5ere724f3b2nyr2t5nsqfjw4u@23q3ardus43h>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oxkibsokaa3jw2flrbbzb5brx5ere724f3b2nyr2t5nsqfjw4u@23q3ardus43h>
X-Migadu-Flow: FLOW_OUT

There was a feature request I forgot to mention - 

New option, 'rebalance_on_ac_only'. Does exactly what the name suggests,
quite handy with background compression.
