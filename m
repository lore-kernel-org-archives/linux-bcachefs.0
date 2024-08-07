Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0816801
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 04:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723005271; cv=none; b=gQz6OMJ+FdzX3pQnnTA/1nOavBZEmoZ2V7WuODdwt6K5K7mD/loq33OutzCHi2wgINwEAIl762kr9J3lcdG3QYQ8yUnih3rnq+60Jcp5FqimFZtkXCpeK5UQF6P/Ft9AfJ8FYumzAwX5OJwc0i1yrshWLTvW7xQlte6xtO3mywI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723005271; c=relaxed/simple;
	bh=6ID9hZLiQlEgjopIJMCL3GabS001ynrsb9qw5O2SpKw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uxaHDjRX8zcWS6nES2y/44ehXFf3viMstRfVIgNeGlvkFQIRa4wq9q5LLm9hA4posFY1mowktaZ45uq9FrRojyxgFweR9jKrgc7gj0zy9x4xpb9y1/Hb9dnGns/2YUrVhDqg1p4Edn+WbwKpwngzfNohrPim7PidHm9bbEvZywQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PLr1dKjC; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PLr1dKjC"
Date: Wed, 7 Aug 2024 00:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723005265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=6ID9hZLiQlEgjopIJMCL3GabS001ynrsb9qw5O2SpKw=;
	b=PLr1dKjCupvkn6ELGVuifQ7E7jnFKdxPari3Cje1jxUYH2UJr48o8m5ivOHPh65rBPjdjV
	it1YG0gavt3BGvf03RMLhCE+JCIm8Tfk54LDAkVZ2fMEhLLhHjZ3v+BNRX3S0trwVYn77p
	XQZskyR+Qh9CbRb6Xx4F8xox8i/PLR0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Subject: PSA: Avoid Debian
Message-ID: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Debian (as well as Fedora) currently have a broken policy of switching
Rust dependencies to system packages - which are frequently out of date,
and cause real breakage.

As a result, updates that fix multiple critical bugs aren't getting
packaged.

(Beyond that, Debian is for some reason shipping a truly ancient
bcachefs-tools in stable, for reasons I still cannot fathom, which I've
gotten multiple bug reports over as well).

If you're running bcachefs, you'll want to be on a more modern distro -
or building bcachefs-tools yourself.

If you are building bcachefs-tools yourself, be aware that the mount
helper does not get run unless you install it into /usr (not
/usr/local).
