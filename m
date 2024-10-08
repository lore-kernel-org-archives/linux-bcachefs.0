Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249CD1F8EE9
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 17:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728407816; cv=none; b=T/aA/wOEseaCRw733eGzSm1ANi5hC99o7dQofNW+EpcTXfAeGyVFa/F34BMUseBBYbnbppzjwb8AJh5ZkMTfX3/F5efFWh3vYYjPubpGMrfr8ZtC7ZoruskIFYiUa9sVTWVUiD526S2A6biNL39gfIXeTDLjxyeLgarQriLxcLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728407816; c=relaxed/simple;
	bh=btmt6kUQLb8+OMsRC+RmpnpFREZ4aOeXaNBBtFMvIUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ER6dKQLXDRgfYG5KZSUx4am91qlzlLO6er2ga1qKttKPcneQ3jgfT82Nvt93S6s8pZDQx2aDi9jouNs6TbviniS63JTKOiFZPjgKhAU52hBmtML7SSIr33JiPW1uD7imcGvOdxxVCDmTQ4OuotkglnQjSMzIwIRIvj0ghsC/CXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n50nngIM; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n50nngIM"
Date: Tue, 8 Oct 2024 13:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728407812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=59oavbiELApoKYQNadASbkxvsiYqLzDzgTaXK+5yAZw=;
	b=n50nngIM+PTBO66LtvV/S+187Vhu3FOLUcrSPTtCZdGzDWLQlZczkfZvebsnpQES5H6s5A
	NHYIhVO48/f35HYtwnUY2DCoY88mjbTvw6ylQZtjcue52B8JW2c3b63hTcmlchreNUUPvQ
	t4FG073TfPisCmwrU/dCXvVDVNz36WU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Release transaction before wake up
Message-ID: <s4s3oeajel5pdsy54bscbhjgimoer3j7oujsx3u6uptbf6zzbs@yl4xz2jcnfnr>
References: <20241008165908.1731084-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008165908.1731084-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 12:59:08AM GMT, Alan Huang wrote:
> We will get this if we wake up first:
> 
> Kernel panic - not syncing: btree_node_write_done leaked btree_trans
> 
> since there are still transactions waiting for cycle detectors after
> BTREE_NODE_write_in_flight is cleared.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Nice - applied
