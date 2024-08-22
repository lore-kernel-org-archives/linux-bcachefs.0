Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2041CF9A
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 03:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297490; cv=none; b=MCUqiTcL9M5lRPQyWcJFA3xSr14Sem+GYlGbCK9m7OsTTv7mipQ2bs4ttPKrD67qftuCXhCDos0/J6swQdCBIVyPsJrXzlph/Md5bTRKN0zZcQ9VawOyX4d/PIPA0hIs53AVOroH6SlAf4OddaWqc6PFhizvUWJeTZRCLhzSfjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297490; c=relaxed/simple;
	bh=a46l7iXz0WtBz7CZJjdmIJHzpbuIfnkkjcvh23FpB2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ruzgSbPpi8gWgQFXnsSiVWruY7cQU4qp+HaIHrvF4XH14VoaI7yCFTD/lFxWhSN9h0c1xJL1HgelWYLFq7oBz75tPnPy3olJ68hNFGNI+Zs4AxuazwzOfmdwzipm8AfkCracHQQvrl44sZVHxbRVHT6ukjAS4IrQccxjwqrR4rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ury7Hfg3; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ury7Hfg3"
Date: Wed, 21 Aug 2024 23:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724297487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a46l7iXz0WtBz7CZJjdmIJHzpbuIfnkkjcvh23FpB2s=;
	b=Ury7Hfg3udj2aBnMoqgyI/N4faNnbpyy5gEUUS56RJ8JdBMnWWWFBN0bFKl2BjfZQFu0St
	7XoXqea2nLZspW4BlwfLOxDl+LPxnB5d6bsys7uAXflnBHBEH8LhNFIUvoiVv8ENOXdJWO
	+8A52YmygO3ILSCnB4UKNiv9Pj1EKKY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+9e0404b505e604f67e41@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in
 percpu_ref_put
Message-ID: <wsianmy6cqt7ok2dosx5dp4dufneu2ekykfzvlvvcvbwv7qint@2zr2esze5ur5>
References: <fmgmxhirocusm3zmnki4m7miyqemwgxyjybjr4wvq7u2xupjyg@qwqjonwarhcl>
 <000000000000108bb406203d368d@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000108bb406203d368d@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix bcachefs: Fix refcounting in discard path
