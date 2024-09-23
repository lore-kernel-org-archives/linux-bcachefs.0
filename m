Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE00078B50
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 21:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727128126; cv=none; b=sqVcHzc9RDrpi3PCBOnphrrqaZrIbL6b1ET3w+m9924Zpzj2WFrXdAcx4qJBa6/2WzYFb0PpNaZABK7ElRSkTVr9jQ9aUgmi2n3KiqPWdusxsujEEqlwlYc4+ViRE3YHFqMewl3u4wMDgKs4sK7nDPbQ5fIxAzehNJI5ED7z9QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727128126; c=relaxed/simple;
	bh=II79k+GS5zkgCuXUlc/QmJkvk6+NT2WAr5JQnufpvbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mN3MwH4/eQGL+KA3tDoPOx47OFgZT492xpBixHlsOCIv/BNHA3qUCo4KCvDL/OAQ+pU0XNv+HnXfnAP/pOQVvja9fkzcqYJnA1Y85ychflpxMZhAUL6B/T91Pd2++CTBGsUMpTA6STHVGjFG5V5vpeAPrP4sf5PF4xG/PJK5PL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W8Ttx5Yq; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W8Ttx5Yq"
Date: Mon, 23 Sep 2024 17:48:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727128122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3ZaiQCp6EuA3Rd+SYYAu9elnZtTJh3YiHfzfwzjY2c=;
	b=W8Ttx5YqIKvYUanO53QL0d5Doo7NSp+EuEqW2I0Hn3JOm1gA6GlTiDncGpmZS3mmKFnnEl
	edAwKMYbFWZiT9pSc3fWlhQFMw8GWVAFMKq9KaM0QyshH+tbgsURvdV6XsdhWWL/JZL53r
	P+ujhVPojiebPKeeJgNi0qEfGUTKGZo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Use FOREACH_ACL_ENTRY() macro to iterate over
 acl entries
Message-ID: <3sjosqkags6o2gymm5ywqyianfs7f32qgquqpfnew34g2pohtc@rmsjfkqdb25m>
References: <20240923144452.233096-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240923144452.233096-2-thorsten.blum@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 23, 2024 at 04:44:53PM GMT, Thorsten Blum wrote:
> Use the existing FOREACH_ACL_ENTRY() macro to iterate over POSIX acl
> entries and remove the custom acl_for_each_entry() macro.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Applied
