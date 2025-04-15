Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4942DFA42
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744729868; cv=none; b=YP6mSXzvoI6b7RM3TBfZYAROPbR9cYCeO3DVFfAQjRk8WLNK736KPGAaqd8rd9BB45dBtsdGTR8ve7czVnb3QOgBBVM8haP+cfVzGA0S8FzJhS4a5bMDyoaTqs1nX5A3rTIsyTEhV1Rlpm4/Obftf/LXO9f2lOkyrGBIsJBeg9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744729868; c=relaxed/simple;
	bh=Q3xXw3IIMfFd+gdok44kNQE6NsSo1XeR+iFqY4dBqKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NMabbEaOvdmC4fLitd3qOfFLm5Aifj30wSsiuvqzxwpA7WqYv1CYbIDwSiyX5FraT3bec3F0OoZTDevnnaEUgLI5vSKJCH0H2GzB5Y7lXDhQvxJjZJq1BnCiAJflArwWX0NMdGanHmyT0nzFufaW16rfMx9mOXreH4OOt81r6us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oPxqpiaW; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oPxqpiaW"
Date: Tue, 15 Apr 2025 11:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744729861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWnY/wG6f+SYzsmQbXNZYU/jF4UZNmmKPIHuqocfylA=;
	b=oPxqpiaWum8U5l1AF3LcwrE3Xel40jSy/PKYdZPXEZkXoriVAp5y3+fOzpSKsD9+FTROuV
	nAtQx0Bpb1PXBazQQ+sKvRXrZNc/yN5aHpwjJjNn/h0YF7wR6mTj24/efq3Kvs3RJOcopd
	oPJFgpHgiCkzyyGN7a1AZCP4NtAoEto=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/4] bcachefs: mark_btree_node_locked_noreset ->
 mark_btree_node_locked_reset
Message-ID: <zyqccqxkmtwmqgljwqmnk6ykt2akmci45yb2c7ymznoax6wdiq@fpoeapfuepzb>
References: <20250415053307.81354-1-mmpgouride@gmail.com>
 <20250415053307.81354-3-mmpgouride@gmail.com>
 <lvfufohffjiyabs6avgajstqnfi2va4u4hy3ct73yhcowq4nzo@okzc4pohf4eh>
 <173AA1E0-1F73-4F84-91EF-E04BC75F82D2@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173AA1E0-1F73-4F84-91EF-E04BC75F82D2@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 15, 2025 at 10:40:27PM +0800, Alan Huang wrote:
> On Apr 15, 2025, at 22:34, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > On Tue, Apr 15, 2025 at 01:33:05PM +0800, Alan Huang wrote:
> >> The semantic is reset now, rename the function to reflect that.
> >> 
> >> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> > 
> > erm, are you sure?
> > 
> > mark_btree_node_locked() is the outer, more 'standard' interface, we
> > generally do the more specialized naming for the inner, more
> > specialized, 'are you sure this is the one you want' helper
> 
> I checked the git log, the original _noreset helper was no reset semantic, that is, add a new state.
> And then the logic has been changed, but the name doesn't

Not sure what you're seeing? mark_btree_node_locked() resets lock_taken_time
