Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78085186E40
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 18:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752950656; cv=none; b=iChT68mX857WuTn0FHkBNkM5ODyHrP++67ofwhv9X72njRFzUhE1JoFa+6ZVn1Q44iy3rCgGy1EGID969fDibLMSC4QLj6uS4Q0mB5XUhdwfEzplSYmKxCreDgV4BeZYPGMYMWe+Z/Swjc9TbDRXzbNazoN7UfyReXsN8iW8wY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752950656; c=relaxed/simple;
	bh=8YYOVYUvREZN04Anb5VZesSY/aodjhWQXXvnzRS9byw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X7vU6ivdFHhzPYlyj3Lx1fHzWucqI6VVrUcYjcRj+0vyTYS9YJ/41r9oYpZtPHOY6RbRfE6hJzxYH6GOwyOaUy+3XFe63k0vUkXpS4SAMhoCF3MFrLfGutcYKgT6LAUYnbWilXKYzEcF9+sok7T/Ii9OMFUFaMp+neiqN31SFAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZFenybWe; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZFenybWe"
Date: Sat, 19 Jul 2025 14:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752950651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YYOVYUvREZN04Anb5VZesSY/aodjhWQXXvnzRS9byw=;
	b=ZFenybWeJxczejIRk33wGeqTsTmqcsgbonXCnRqEwv/wLB7g0vHQy4RGDqKskmDH3bEbGO
	x5g76dc5cbVLC6o1/jezi1CY79pYIpzZrjmq1FlQgJCzHIL/dF1hO4G5nPLzJFFklLvFXj
	5oQi1XOyg7iMoSK4E7cldBe+4N2Tvw4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+00644eb66b865d7db7f0@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_bkey_cmp_packed (2)
Message-ID: <nvehsujuezk2os4dl7oohboxxgpdxm3xsyxghob6fdguc34t6h@m34xhm6jjhmk>
References: <683d5800.a00a0220.d8eae.0047.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <683d5800.a00a0220.d8eae.0047.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Don't build aux search tree when still repairing node
