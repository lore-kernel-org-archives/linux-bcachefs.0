Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A166AF88
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 20:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710965450; cv=none; b=muwvdPTXNnHPKNP24/IGLZxepNbz0PxCmfB0E/F4ase99WsZmhXszIBjYASeFke/vF2yxIF/ETDuOGm3nG4AjFUu/yWxmOCqGbSFMnNdZjaEl3YhKvN2fQuUjpOMF5VkRd80S2+C+rv9Sw48m/OXNiYe16IeKG6rI8x2IDDdv9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710965450; c=relaxed/simple;
	bh=ApJoICx4nJd1ol7vfwfcxmQGt+sR/FR2DuyYXg2CwUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvmoFWuE6I4/I53dZ5Ux1LSavH/LOJbzxuW7tUunRAwMVVW64Ix3FSfx/QzM3ylZl8xrH80y6jD3J4wRluVjstn1WSBsdeoLRFaVjZI/rPFFHXh/1htdDWSYKEzLYh8SxcKHB1xzlpbFFst1SnzwttForhWJiEKrlb1lpq3SMbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tCPLRjEh; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tCPLRjEh"
Date: Wed, 20 Mar 2024 16:10:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710965446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ApJoICx4nJd1ol7vfwfcxmQGt+sR/FR2DuyYXg2CwUw=;
	b=tCPLRjEh/uIRQbSM2GZh9+Cf488Mjjh7BMNdmxw2UeveR28guu721rQ55p0hSfdZgkqijl
	hKn8DYra6npCwWbMGFH9ILRYI9J6d3gOFbq2cMmqoJk3O4lRQO464bFQ/03xXF483dF5WO
	0qbyfyXSGSr6E/lN/qQ3w75KmZcRY88=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] bcachefs: use btree_path_state to represent
 btree_path status
Message-ID: <untyed3kgpujuae6xiguil2jy54msnwvmnsricio3mgpv6brje@owgonpjs5irc>
References: <20240320062923.305431-1-lihongbo22@huawei.com>
 <20240320062923.305431-2-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240320062923.305431-2-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 20, 2024 at 02:29:22PM +0800, Hongbo Li wrote:
> First, the old structure cannot clearly represent the state changes
> of btree_path (such as BTREE_ITER_xxx). Secondly, the member (
> btree_path->uptodate) cannot express its purpose intuitively. It's
> essentially a state value if I understand correctly. Using this way
> can makes the representation of member variables more reasonable.

path->uptodate was fine, I don't think I'll be taking this patch.

The helpers you introduced in the other patch were better, if you want
to rework that patch.
