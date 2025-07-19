Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7221DA617
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 19:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752952757; cv=none; b=O9D2mmWD0dNVKLFgUmMOoTofpqK86atoDLpM8LjVHtBXsVZ0yqyojwC3sKrBJcBQqJaLn7zyJuHyBBx9uVoEMiWWcxzVvtKEqNbLbBl2sp8hvB3Ts3jJ3hCMM3CS6Av21l1sLzWokmKOWUXZfI5iduCi2ZCOJC92kx5zo9muv8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752952757; c=relaxed/simple;
	bh=7VomRB47AMR5tGJ88m9LKb3S1UgMpd07gsPZqIg+Ko8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cYFRKE60UpnE70BqJ/Zh1/wCr/fpUtOKPRjxa1C6gyWyNQ58/v6tEfbqk68T4u9oMoBicQnJoDsNBE7MexKoNsSf/0VtXwxs8+vfTayvxX2Dd6L4wARSl9kGkBtxZhtWRqupncaaTj03Iww+jhBu/jy53sbpjKFA1cJnW6EqdqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bm+6URyd; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bm+6URyd"
Date: Sat, 19 Jul 2025 15:19:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752952752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7VomRB47AMR5tGJ88m9LKb3S1UgMpd07gsPZqIg+Ko8=;
	b=bm+6URyd9+jWp0pcxc5xvX3XjwuO145KBN3r12XFqFZNoKlyBD5dXvDQP2902VjNE6AMGv
	ep6UNyljSYkK/kXX34afgMy5l/aX09NwRAM+Lazs7b+TXM4VwYZvYSjcjMJDxnWQ9yPyvt
	nGCBfGjR8CN30SXeiFvgLBUxXPFD430=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+87078ad27cd8af3263cc@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in check_dirent
Message-ID: <igoha74mbp7v6wkxv5pfgremooewlj7awznvptg6xk4ju6mjcn@wyndslsikfux>
References: <67b8a9a7.050a0220.14d86d.0578.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67b8a9a7.050a0220.14d86d.0578.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix UAF in check_dirent()
