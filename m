Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337A921C180
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370538; cv=none; b=DxwXvEKWqLjowUMupyCbbgx5E4/P1B3QXIObikeKKlRLJ1i74tYUS9awnm76mXPqNbsKT/eP7Yp9WplNnGlxaZve8Tkl1kvwuLeLJBUUlsIkb0kNnqhc9bsjLO0r45SDrfCFHXotNJaYnJRC80uxgqJlzztsOq1mkhdXUyXlDfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370538; c=relaxed/simple;
	bh=y2toQQYUoaG3Hk/vLxGI7RZEKDnGyzA6U+NxbH1cp7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emLW740A6NgYwxea4a0o47rH6mSnps9G+AXbB9qNaTY9KsakR+MxMhYoLKOldmlo+KfXWJZCJK0geHq6+lVpqnevdGxr1T8vvUknjr9rpzbqYO2I5UD0UkqGbKRWYfEmU8r2RyDiphuv5P2xfgSrXE3X/0sSpiDp5GCPf6H3A6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LCrA7F1A; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LCrA7F1A"
Date: Fri, 7 Mar 2025 13:02:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741370531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KE6q/rKYH7PUqFF/DQcNeOX4lcfTqpEyOJp+maO+/S0=;
	b=LCrA7F1AUCeHsxUkKCqBA5SalbHCToyUyDL+GjqMDl9IyYhHaA9Qy0REMXNKORjDatw0tI
	hQEF3Df76adnqLFsmm0OJFcXbO+eCyom0/u/89x00iBv7Ddakm9eBuXVoLYYKd3lq8oTa8
	YRDa7NQU0AOmnOv2kmlpMuIQ3rXTHcM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: vulab@iscas.ac.cn, linux-bcachefs@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: Add error handling for bch2_folio()
Message-ID: <ubkcjbt76z5jaiw75irjhybullftj5gnbtwn4p5y7xfu6mw254@ky3rsexlfrpg>
References: <20250304040311.2081-1-vulab@iscas.ac.cn>
 <1ed644b8-f3c4-4656-aad0-a3c4f7fb0533@web.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1ed644b8-f3c4-4656-aad0-a3c4f7fb0533@web.de>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 07, 2025 at 07:01:03PM +0100, Markus Elfring wrote:
> > Add error handling for the case where bch2_folio() returns NULL
> > in __bch2_folio_set(). Return immediately to prevent null pointer
> > dereference.
> 
> How do you think about to add any tags (like “Fixes” and “Cc”) accordingly?
> https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.14-rc5#n145

I'm only doing backports for _really_ critical fixes until the
experimental tag is lifted, so don't worry about it yet
