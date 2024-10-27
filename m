Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10BF17B402
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 20:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730060370; cv=none; b=o0tx+MUzRUxegyZEvZHFUfc31G/7uplbe5gPxDGuyZmXQ/PRRdX+CWUnSzNgWwh7UHerDBo3DqAUqtQOuqHpFym6ntS6gu/Zo6cgZMpn7zx8I4G1zTeM89EbM+4q1NirDjJG+O5rnhFcLAmPcmowccfC9N7j35zEYGeLHip/Jbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730060370; c=relaxed/simple;
	bh=bUjCpr5IOhXsE2EDtqAlNL0vNaE7ExyMj7sVHH+v2Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnVD//hq84L8r6bSKTnhxVphRLGTPxZy+5kCxbK3n3wvEaCQ+2Q66ljV3PAqc/DrIjqbLULnMNosjP54EcchQfGbvIJKVx2cjMM1BbnETuPllaWUVn2bQO0IqsyVFVjwm1Y/BOk75Yrz63zSl3fbpArxCm1+j03PWJ/Up5NdG0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=go0zmYEN; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="go0zmYEN"
Date: Sun, 27 Oct 2024 16:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730060365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WIM7Dq7s81XL+U0OSwpH66wD7TLo41Qgnd3imAuoxiU=;
	b=go0zmYENeKtwWEf5F8ns/5bOFuoVSLMlnMwT3wWIwEb3wK+4mqjyjyZ8U64vtj/dxUZagl
	lB4xhi14O/NQOJMzmBzQeqC/I/KdOlSOugnoeo/yNpketCvCyg49NoTznjepN1fP5XE8G6
	cfX9f6Wqr33+T3Pc5y26nb4VDQbiOWM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com, 
	Alan Huang <mmpgouride@gmail.com>
Subject: Re: [PATCH v3] bcachefs: Fix NULL ptr dereference in
 btree_node_iter_and_journal_peek
Message-ID: <5ywtf6whalqr56v45crr7afpfni4vhxm3ycly5tpvh2x72uasa@gx6nmtx7uz55>
References: <20241027193842.154220-2-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241027193842.154220-2-pZ010001011111@proton.me>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 27, 2024 at 07:46:52PM +0000, Piotr Zalewski wrote:
> Add NULL check for key returned from bch2_btree_and_journal_iter_peek in
> btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> bch2_bkey_buf_reassemble.
> 
> When key returned from bch2_btree_and_journal_iter_peek is NULL it means
> that btree topology needs repair. Print topology error message with
> position at which node wasn't found, its parent node information and
> btree_id with level.
> 
> Return error code returned by bch2_topology_error to ensure that topology
> error is handled properly by recovery.
> 
> Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=005ef9aa519f30d97657
> Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
> Suggested-by: Alan Huang <mmpgouride@gmail.com>
> Suggested-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>

Thanks - applied.
