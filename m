Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D9CC2E3
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Feb 2024 00:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560494; cv=none; b=asBmNxeF0upXtH0qLpAbrU69avCHXtmVlXjCW4qQy8E3rphgm9Clf0zX3TQ9160Rned8e8dvHBn6tp7/kEqHmPrlI9acHBNWXAol1KG0C/a/tN7wMFzjSTNS7htC4ek4LlVQAjz/z0skq2JwyrOUgPdKplDhv98URsj5Cvk5Huc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560494; c=relaxed/simple;
	bh=sLfcplMwK8BsHZe8/DsY9siN2UvvPJj2ZHzjjBrAWEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CmhJ3lq1lwvqDLcENRihhACDHlDnNxe0aJhNeLvtw1mitPNE4APpRTM/glomKrKpmuDhqPmb8XpMg54JiaaG2/Oy4BuY6B+Xq1pqzqXuP3eXrEfQi6qk0XdjGEk/54ZkqE++MwcdgP0LhMJTkRyLipd51Zh49dANDtjP2ZBXxH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W/+5luln; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W/+5luln"
Date: Wed, 21 Feb 2024 19:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708560491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V/zPFx18ltYIqbEzJXcbeUSkCnZt3M79toJyJ+O2P0w=;
	b=W/+5luln/dja28Z7aic3PfRntMHUKf+ijFSap6KvC0/LgyPPqAOpioN9NhFfY/5D7QXuBE
	284DBi19e32NMlN4TB7mLlNhO6dZgeEo94kKBdYnnU6xiEzQtAq8B37D6GPjHQuKA5B7bd
	CVQmAluOs+mOyoeRZzihVyixNIVmgSQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS] rust: use libc::Ioctl type for ioctl() request
 argument
Message-ID: <qxjz6evmfl5dsdiha3hucarpqh32rxglqwb4foil3imiy5blms@cmxcdw5zw63m>
References: <20240221032420.73205-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221032420.73205-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 20, 2024 at 08:24:20PM -0700, Thomas Bertschinger wrote:
> The second argument to ioctl() can be defined as a different type by
> different libc implementations, and can be a different size on different
> architectures depending on what type it is defined as. For example,
> glibc defines it as `unsigned long` which may have a different size on
> 32-bit vs. 64-bit architectures, and musl libc defines it as `int`.
> 
> The Rust libc crate exposes a type `libc::Ioctl` which is defined as the
> appropriate integer type for the given libc implementation. Using this
> type for the request argument to `libc::ioctl()` ensures code will
> compile correctly regardless of architecture and libc implementation.
> 
> Also, because ioctl request numbers are defined to be 32 bits
> (regardless of the fact that `unsigned long` might sometimes take 64
> bits on some architectures), this patch changes the Rust representation
> of the bcachefs ioctl numbers to u32 instead of u64.
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

this is applied
