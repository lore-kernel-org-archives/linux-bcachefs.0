Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A3E13C818
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 21:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717451889; cv=none; b=UGCFYPGmNItiSMJfab+lg1UsdTNxwgt6KGlEd2OTBjF0VpKRLCSd08n6xmlkR6uTFUV8KSsQ/K6AwDDEaQbEC8vTNLH+0hie5IDFipKhjbUYO7ucl0njHwodEpKXvdL+wwxwk+vJjci/2j49qjnAQwm1BNiWr/0nlriVvqLwN/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717451889; c=relaxed/simple;
	bh=MVpwNnNRW1Y1ytE1Vtg6j8ox35ZkDK0zKcoia68uR50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FhGyKCoYPloBkRkQS/KfhgkMsbA2slyhfOK6uiQs5GTmxm+8RMbpFIdxnDcv/soeswrY+hfDS5PLETfk12Ly0M0KWcRFfN55kFsAreuoHFqG/9gAhiD5Q1pixE65rE2Si3O63aKSCY9alOymyH0/DyuNDxrKCTfF03wuRK/4SPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZfUo2Zmv; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZfUo2Zmv"
X-Envelope-To: ariel.miculas@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717451878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J5ncs5YXMlmcc+Cu4jooVAXUIwvu4vyhBOgiv7B+Y4M=;
	b=ZfUo2Zmv0H/xTaJ9qBv8B2yInG7GCa7dXmbCSfQDLwzHDhi1QKARaXYidJMJVqFbP/7n6H
	gl5a01/DqrYlbhby1MlZ1O3kivxp0ZFfeSRo4wdLUfv66Jmm7v9ZiRtvKGCPfo23NMvLmF
	Ktcyx83OMPvj3uYuP9QuGB6gcnV28/M=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Mon, 3 Jun 2024 17:57:54 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Ariel Miculas <ariel.miculas@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: bch2_btree_insert() - add btree iter flags
Message-ID: <licutoqnsmubo22fnqdrnq4rkqfpy5cubnelhbynn44lfjuh5t@2dhvbs2hh5h4>
References: <20240603204732.2011734-1-ariel.miculas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603204732.2011734-1-ariel.miculas@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 03, 2024 at 11:47:31PM +0300, Ariel Miculas wrote:
> The commit 65bd44239727 ("bcachefs: bch2_btree_insert_trans() no longer
> specifies BTREE_ITER_cached") removes BTREE_ITER_cached from
> bch2_btree_insert_trans, which causes the update_inode function from
> bcachefs-tools to take a long time (~20s).  Add an iter_flags parameter
> to bch2_btree_insert, so the users can specify iter update trigger
> flags, such as BTREE_ITER_cached.
> 
> Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>

Applied
