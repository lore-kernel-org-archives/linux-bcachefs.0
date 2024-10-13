Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C4F13CA9C
	for <linux-bcachefs@vger.kernel.org>; Sun, 13 Oct 2024 23:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728860553; cv=none; b=dtgvneRnCQe0tYZGpTpMylgMeaDNKXqM1NYufc/6PxKFhfIpQrvBg2k+IVFZFKYK9ofJzfdK7zEzULp5vm2oUrjvtOn6zaBKg/AGAaASVIZ5dCKtDLCUdq3Bgv9W/cwYCs+DJ53+7hu/z54SyGuQXiT2SdR+1dGeylTaBpkEUeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728860553; c=relaxed/simple;
	bh=oUH1TN4EVS45jsbC61dZ2ovcJDaLKPl/iKxOQvMt3k4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QNxe7JpmdcecFyOaQ1H+ZPBXrIdaMXiYKXOY3cEBn48bRxLKDB5g8mmsrGXMhPf2EwnNnMb7xWRl9vGB+Bw9rclUouQsSOm5r3RlM+PNgIDfRp4mZ8B6Ni9Q/DR9Rr1UB90bz/wXVIYiUiQCrOLNYebnWMSc7++d5dgrtjDXNqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p9GLgcQS; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p9GLgcQS"
Date: Sun, 13 Oct 2024 19:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728860548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JQGD+odaoJyaZJSFci6UOAbgnxdLjocJcB5TIiwaN1I=;
	b=p9GLgcQSj4UPf0VLCrMJykqWTygpaP7d2qDpGN+6hARNGKuIsvTvTjXzBJn2Cg7n0T+mqn
	JKa2JcrqidUvSJ8SejdEspl4dPdnPihuNCl9FJUaPjQFZCOF8/Drg0kb0nTrDbQ1zTbGpQ
	Vu3T5fEe3+mR2H1M5hnwffGP1KVO2+8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: yuan fang <alfmin2020@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: btree_path_up_until_good_node
Message-ID: <45e5wckmmm5zn272jx5jr6acfec2cmptgoldfvxab4djpj44qw@kqyk3vyqvqme>
References: <CAPxDwcUUduQ=gp6btDBd7z0KNQaMudNxa3JdWywJAYNmTDXfUw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPxDwcUUduQ=gp6btDBd7z0KNQaMudNxa3JdWywJAYNmTDXfUw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 13, 2024 at 08:45:59PM GMT, yuan fang wrote:
> Dear Kent,  I am looking at the function int
> bch2_btree_path_traverse_one(struct btree_trans *trans, btree_path_idx_t
> path_idx, unsigned flags, unsigned long trace_ip), and I noticed that
> path->level
> = btree_path_up_until_good_node(trans, path, 0); sets check_pos to 0.
> According to the function:
> 
> static inline bool btree_path_check_pos_in_node(struct btree_path *path,
> 						unsigned l, int check_pos){
> 	// Check if the position is before the node and return false if it is.
> 	if (check_pos < 0 && btree_path_pos_before_node(path, path->l[l].b))
> 		return false;
> 
> 	// Check if the position is after the node and return false if it is.
> 	if (check_pos > 0 && btree_path_pos_after_node(path, path->l[l].b))
> 		return false;
> 
> 	// If the position is within the valid range, return true.
> 	return true;}
> 
> When check_pos is 0, it directly returns true. It doesn’t seem to check if
> the key position is on the bnode corresponding to path->level. This is
> somewhat confusing to me. If it always returns true, can it find the good
> node? By the way, my understanding of a good node in your code is that it
> either contains the key we’re looking for or can lead us progressively to
> search for the key.

Correct, when check_pos is 0 path->pos hasn't changed so we don't need
those checks - it's called with check_pos nonzero in set_pos, when we're
advancing or rewinding path->pos.

When check_pos is 0, we're being called from path_traverse(); we just
want a node that's locked or that we can relock - if we can relock it,
we were using it previously and we know that path->pos is in the range
for that node.
