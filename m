Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888512B2D7
	for <linux-bcachefs@vger.kernel.org>; Sat,  4 Jul 2026 14:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783176580; cv=none; b=Nm+kX+HDXhuwLkBfiGUszVqAXDUM0xNM9vmB74WC02m/5nfgQzYOcBsvcCz+kprs6xMHiYAo8TiY2rd1Wgzb5Y3qTlrHrAc6I0v5g7PxapCkaGg42VUAllSgbc207Cp4bSoRskCdXf6lehQmTrdcR0z+0Ee5/s1c41v161d35CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783176580; c=relaxed/simple;
	bh=Y4WszYhVE/Fob4GoABh9lu4hyPP4923GPcHmmbETQOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+7r4Os39PVSC4HtvLgrAyimN0i6qnX5KEkn8y48ITSDS8GVbDAtnszqslO7IKVhvE55c2UxK+JHChGNEJvyn3AnsLzPfKJheiVAJhqqPzA++x0nQ4cMQ8ayKSY7/JIYDipAuvgRmLUrS/VwLxihGOc/V6XZNme1kc+kzhz9tsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xpdf4EW1; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xpdf4EW1"
Date: Sat, 4 Jul 2026 09:49:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783176566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UQOtDnFjQPANSHnV8tBbe0M1MlY+ZRcnYotgj5bs1e8=;
	b=xpdf4EW1tjYGnfLvNeH/0v7a7QMnFqMhb8T+RHAqOkiLnSjRjGTsai3uppblFmBX5qe6SC
	cMjCWZGQUyd5cuQnDpylrA2pRzm7L4hceHi6mPYKzg9P3wiEHgQB52ZFsh1ogUCPjb2LDJ
	44bKG9IjByxmi0koiaYQpEweOMuk/BQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH 6.12] bcachefs: avoid truncating fiemap extent length
Message-ID: <akkdYigsmB8tJf6T@shelob>
References: <20260703114813.113406-1-mdmitrichenko@astralinux.ru>
 <2026070315-stable-reply-0028@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026070315-stable-reply-0028@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 03, 2026 at 10:05:22PM -0400, Sasha Levin wrote:
> On Thu, Jul 03, 2026 at 02:48:13PM +0300, Mikhail Dmitrichenko wrote:
> > No upstream commit exists for this patch.
> >
> > bkey sizes are stored in sectors as u32, while fiemap reports byte
> > lengths as u64. Shifting k.k->size before widening performs the
> > conversion in 32 bits, so an extent of 4 GiB or larger can wrap before
> > it is passed to fiemap_fill_next_extent().
> 
> Thanks for the patch, happy to take it if we can get an ack from the bcachefs
> maintainers.
> 
> -- 
> Thanks,
> Sasha

Ack
