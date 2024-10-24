Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B84FBA4B
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 03:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729740920; cv=none; b=FiWgWfV7d2aDloQXwhgI/h0PaXN7Ssfd82acEzBL5rQbyteTNlkShCZCgPTkSbg1YSu0K2+ww6Cowj29i1ydd8jYU/RZF29HSspK6ZZAXi33vCsNZnkxeLqTHplisf854f3HqOttLx8n6kQDSTxXp1Bh4zB3SscMh/xihxH6L5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729740920; c=relaxed/simple;
	bh=ah/ojWnTT1B8xhosGV8LycDBF4l5ZjaHJ0ZXqDMV1hI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KU8bq+GAyzGI6YAH8us1INfss5/XDuJfp+eb2DzntNCdsIDozh2RItZJkTwe2AHrQUh1fdMStqU6jaGVRvAuzAgrcROBqcqKudT0mi18eIwfF2zgNHe/+BwOoTl0zODr8PyrczspLDNe63uG1vZOTrIISgvv8M9BVI5JhGQEB5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OieAtiNp; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OieAtiNp"
Date: Wed, 23 Oct 2024 23:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729740916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ah/ojWnTT1B8xhosGV8LycDBF4l5ZjaHJ0ZXqDMV1hI=;
	b=OieAtiNp4vrDWgC/pjOC6ZcTv1JwMsBvKNnV6fZnhLc7EuU6FdvMO7mxLq9RF7vuNyOEkM
	EZfAolD3vBicJNV9LX6kxFrnSQ/fkkDd6Jre2Nqvc/IlnkKXZpNF6S3RlNj+Kl4nNlkCF7
	nY7EOR3j8RqfjyqHJHhvq9gK2decHS0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: ahmed Ehab <bottaawesome633@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs extent_entry_type setters
Message-ID: <5ai3oretd6friswe3dgn7qbibcbghom6uwytf6y4zcghzlzc5d@cyxx7w7qz4uz>
References: <CA+6bSavLk2wt=Q0OM7n4Z_XoR8jxwUue9LZ-qpQRZQLbig_4PA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+6bSavLk2wt=Q0OM7n4Z_XoR8jxwUue9LZ-qpQRZQLbig_4PA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 24, 2024 at 01:50:15AM +0300, ahmed Ehab wrote:
> Hi sir,
> I am currently working on a bug related to invalid extent_entry_type. Is
> there a place where we set this type for a bch_extent_entry? I found a
> method for crc type but I got no luck finding a generalized method for this.

There isn't a general method, no; and perhaps there should be, like we
do for bkey initialization.

What are you seeing?
