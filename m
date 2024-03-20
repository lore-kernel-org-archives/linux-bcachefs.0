Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B06A85282
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 19:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710963832; cv=none; b=th34JsFWvQQ7PWhGL2A2AveCxP+76TtiLa+u6hb+RoKAS+fBuGK/9NQh4Vd0ZOWTjAMbxLCtzYBAXR0S2tZI6WxDgV5+KVqmKzXHrPKMz6wy9i19c64Zh4p4JCP3AFEHrL3HTTMWOq9K1gAGUB9LErB/9M50hOMoE/+LRL+3Cbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710963832; c=relaxed/simple;
	bh=v9hgl08LOEtYbzh3sZca0BQbclGDkTrxanU9WYU3cuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NqohW3MB10aI6QLqQDwbYnG/Ei+PAfEbGJNwIq5c24czUoCnKEmLKtmTDMFe2PBqBwgx99X7EIBV3KqBnx6lZrpM2hfw3IpqcBU3LilLYr31Uv60qIe6hg+CWSYH7SlAdZzSLBoUlgl0EUvsnlSShM+2qklSHjom9RvL/H1Qv50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QYdDPRPO; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QYdDPRPO"
Date: Wed, 20 Mar 2024 15:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710963828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z8Re4nzIrCEwZp7cYFw+ePu6to2uRhLxORm7J9BxxIU=;
	b=QYdDPRPOs5RgpebnhqXBVWAEAqeix6vF3tos2S4vHkvguOhbLy28ixaB8JdEtRtsWaF37g
	kSV/QcHVjLyDDZGiUsNWvtYb2rztLjuSPgqzOqAZWvkBxluzOj8YDqjUFZmQtofNBZU4lf
	RHLoAE3bqdMvBt52xX/OME+6KdwptHM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] bcachefs: refactoring of btree_path status
Message-ID: <6njzwe66jtwnwg3ewxmop74iongp5nuqk2736ggatolqz4tbkw@mggb3ecmvpq5>
References: <20240320062923.305431-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240320062923.305431-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 20, 2024 at 02:29:21PM +0800, Hongbo Li wrote:
> To enhance the code readability about btree_path structure, we did 
> some refactoring on the relevant code based on my understanding.
> 
> Hongbo Li (2):
>   bcachefs: use btree_path_state to represent btree_path status
>   bcachefs: optimize btree_path status representation

you've got some things to look at here:

https://evilpiepirate.org/~testdashboard/ci?branch=refactor-heap
