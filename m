Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E7F13DBBC
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 23:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728172080; cv=none; b=W/ynfKtbSj2VRKOCId5VONPdGNMJ1EQIXXRyOOzFHFj4JCMsajtxsokfA4SXKS4JKruB0HifY2VgF6099YiHx2HbHVZkwoanEWgvqqHZCeaEskgTILM673OPk974iMpDb+RS0+GjgdStdHBM3ZtMfYjiePTRnJS3VMXDK1h7pdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728172080; c=relaxed/simple;
	bh=CU43C7lMcoFOEc9idglBpjRwCPRbGUE7aTXz/bbYE20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=suIg3OonqjNjNPD5dYOSdr/Org1V3xw1o2cShZcVhav9bnMJiPzl4161geaAJQOC6UOCuqUvBF7hPIyMPV69Wit1xfGX29/dXmlmH1kMTQakhQDw+iAruuza1SsY0pzRpsWs4MPZh9ckl9/SCrFaBS1di0vL2BcHLlwxEIYOex8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JL/uaEmk; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JL/uaEmk"
Date: Sat, 5 Oct 2024 19:47:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728172076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CU43C7lMcoFOEc9idglBpjRwCPRbGUE7aTXz/bbYE20=;
	b=JL/uaEmkLLFEaQoRuYJZcgRl7MstL//5asZ0o3XjLR2iX+8YUd9rU19KSwmZqNf8ovAs9m
	hQ9OpUmyBL5C6MZYdwAEAwdpN+gbZiPsPO22TERH+hH1RVqYQGAFFoL3l51kY17Cn3ZSbn
	EzQL8D6MnMqN6FHOPcBzSUafbMi6wPQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.12-rc2
Message-ID: <flykuujdisx6t2pmqykm6h4bpchgpcggbqsqviulvsiutlyh36@exltovne4jy4>
References: <cphtxla2se4gavql3re5xju7mqxld4rp6q4wbqephb6by5ibfa@5myddcaxerpb>
 <CAHk-=wjit-1ETRxCBrQAw49AUcE5scEM5O++M=793bDWnQktmw@mail.gmail.com>
 <x7w7lr3yniqrgcuy7vzor5busql2cglirhput67pjk6gtxtbfc@ghb46xdnjvgw>
 <CAHk-=wi-nKcOEnvX3RX+ovpsC4GvsHz1f6iZ5ZeD-34wiWvPgA@mail.gmail.com>
 <e3qmolajxidrxkuizuheumydigvzi7qwplggpd2mm2cxwxxzvr@5nkt3ylphmtl>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3qmolajxidrxkuizuheumydigvzi7qwplggpd2mm2cxwxxzvr@5nkt3ylphmtl>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 05, 2024 at 07:41:03PM GMT, Kent Overstreet wrote:
> Face _what_ exactly? Because at this point, I can't even tell what it is
> you want, what you're reacting to keeps shifting.

And more than that, I'm done with trying to cater, and I'm done with
these long winded rants. Look, I quite enjoy the direct approach, but
I'm done with having to apologize for you in order to calm people down
every time this happens.

If you're so convinced you know best, I invite you to start writing your
own filesystem. Go for it.
