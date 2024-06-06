Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A4D196DB0
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Jun 2024 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688733; cv=none; b=gHDOyqkiC0cYJM1VhVbU0y0j8Y1GU77yo8wPSXqD4UG2wss/8iJko3vZgNfs/Xrl8CnwapdikckPgGrjPZqcj/EUIgb3X+MqsmuFLiWM2jzEclnD7u25AA0jGno6s2xM6+80Jv/GSeTGxHNasD52tFKjEn6wOZtAuvvTO/EsyTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688733; c=relaxed/simple;
	bh=/6GPv8+/K3GTrPWHeCqxGRbEeuNPPn+y/NqSh6sQpbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R48fJ5xuASSvYZQrnlasLDRkpr/E2pGBWs5ZI0tA/dFU0Eu5HWQeixKsySGh1e1zh2CD+CVq8YBWk5h/Lk9j+G5YovACxtU4oL8+F0wPHK0q4Z6022EQ08kDooc2foXAJpNlu5L6rFqJuU8r7Qw5vXLAbXYDLAmS7JZnfEeyb+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dXneoOiS; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dXneoOiS"
X-Envelope-To: bfoster@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717688728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=okVrWS/rXCOE35Picdh7+Tsc/06UWKxy4blTRDc92eo=;
	b=dXneoOiSA3c13QkG4fSn08JJVdPNR1E692UN/TCT8Az8/YjWYqkl7jOk7FA+MMpMpKDeAV
	X+OaCZfvLuF4j9pzyO07QZCvG6Sf3NTQ8aPlnwB0NAbPDs/R0BZry/o6OcnKLYkJptMpXj
	ipij9KlbjqCEO4IxdZnxq76MBEVuPZg=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: dan.carpenter@linaro.org
Date: Thu, 6 Jun 2024 11:45:23 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, 
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] bcachefs: fix smatch data leak warning in fs usage ioctl
Message-ID: <kbzthpoetfeynlo4qp4jcipfyopa3fgv5c5e7wyy6dgqsyz3nw@4ipk7yxpskrv>
References: <20240606135826.1684764-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606135826.1684764-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 06, 2024 at 09:58:26AM -0400, Brian Foster wrote:
> smatch warns that the copy of arg to userspace is a potential data
> leak by virtue of arg.pad not being checked or zeroed. This was
> introduced by the commit referenced below that switched arg from
> being a zeroed runtime allocation to living on the stack. Fix by
> simply zero initializing the structure.
> 
> Fixes: cde738a61e65 ("bcachefs: Convert bch2_ioctl_fs_usage() to new accounting")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Applied
