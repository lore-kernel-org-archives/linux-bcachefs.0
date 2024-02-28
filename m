Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0AC74431
	for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 19:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709148865; cv=none; b=cd3rm0JIFw/pQx/327gLFV8RDTeQGmEZ65c+w31WZq5xngJNsf1ee6hAJpErTth6tldWRvHs6CoMMBG6sdt2+Ttd5dM96KXXJHaOL6n1vphSuLDdPqa8Q2LJN182OEhV52cFXKAOlkPxlNWaDI+ITnz0+U9E4BG1Tn1MlyhNMGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709148865; c=relaxed/simple;
	bh=nD/AIQNODgkoJh9zI/DtgqxCS7qp7It2s4hG1v1KHY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tu8fqHchBF/7bA7Rnl+xXXP65sAcA4R/p6spySMzJjJ03KAoeMSC8dOcg9ewf7iIqawPQ52eflArErJ4frEic7vV5RPK5cF4PmAdRhaWdgiikp3WjevHKwHK5atXEzpbZC3i2fvh73Zf/0LDX1BeCZDuqcbpB8eufrb3AS6Xs8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lmYxX9xQ; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lmYxX9xQ"
Date: Wed, 28 Feb 2024 14:34:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709148861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nD/AIQNODgkoJh9zI/DtgqxCS7qp7It2s4hG1v1KHY0=;
	b=lmYxX9xQz9S+0wuXle4d2lETmw8lId6hZNIRpdy151DDJT8M/uUf3SK8Ye8omaRDZT7BuQ
	8f4simzklt33vZBvqq72GL8YqiZHDYc0W19dRu4mui++eansyRbij2ZfZPDctMX+2YFiqM
	TFgsUaBYpSx7ktj68ifIE4DKRo8J74E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	ruanjinjie@huawei.com
Subject: Re: [PATCH v2] bcachefs: fix the error code when mounting with
 incorrect options.
Message-ID: <ts6gnnucpzcfswrwy46zv6oas2uhqlkpywug5dcr6am345trvb@rr2jt6r4fyv5>
References: <20240219122432.2570083-1-lihongbo22@huawei.com>
 <tcjqfii2emtqwpsgt4doldgg2iwjnsh6fzv7nkdccxt43gpu4g@pfasjkkj3e4k>
 <e2ebc6d8-58e1-4259-b03c-8cc13003059b@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2ebc6d8-58e1-4259-b03c-8cc13003059b@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 28, 2024 at 03:17:50PM +0800, Hongbo Li wrote:
> ok, I add mount option error code here.

applied!
