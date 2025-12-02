Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8775A2DE70A
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Dec 2025 04:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764650778; cv=none; b=h1oHWb9BvSRMaPYUkQLex/h4ftKqpBtfFeWiGLj2p67tvX5B/CF5CwUGVJ++8QRHBsC0rlGiqsFkF5pxShD2cxM3kO4JkDuGvZcSzDgXSTOITtvrvpvGT0P4X+ML+9YoSSH+8CY+WdAbNTGeff0ZhTTNQ5eX+slJWtVPr2pxM14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764650778; c=relaxed/simple;
	bh=pv6LaRX/gmZASViBKz94tjmLz3059eVLkV2ZCkjPa4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDpW23b3YynoVycnB37jLvAPH40MwSOaKLFaZ1PJ5Qv/q+2X8zzr/7VEwRw6pGOJXkZoihHqEVoDx/CTFLXbpVhw+zZAKgeMXUMRJKTx0qqvoYG7CDHmH7PxmXmwrgAgNNATrlb4EgnvBgT2N9NLnZz6CQtplfhBHUeAD2PNXjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gPXhUImD; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gPXhUImD"
Date: Mon, 1 Dec 2025 23:46:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764650771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ONW/NwaNNCEiMMZ6iprwdAqi0j/Q5sPSCrKNFq+9NlQ=;
	b=gPXhUImDpvJSTzBi6irbJx9wE682rI9kvUoI4gGfwudr1nuvi75h+JkX+kSFK+mZqdV34A
	HksgqcV0k3p2KuchUTE9RCmOhE+XcDCdFc+rF1QZdok+wV6PeAQsCdZ+nx9i2MBossI5lg
	4dJWG59GAt7PiTOnIryUw1b0mSZZQ3E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: stijn@linux-ipv6.be
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix version_upgrade hint
Message-ID: <ogcyg6gnwpwd6bafvrxmy3oxjxskocc7rl4fox3q3rkoyhxlh5@yppnnkg33cfq>
References: <20251202040730.1478285-1-stijn@linux-ipv6.be>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202040730.1478285-1-stijn@linux-ipv6.be>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 02, 2025 at 06:07:30AM +0200, stijn@linux-ipv6.be wrote:
> When an incompatible version upgrade is requested, dmesg suggest
> version_upgrade=incompat. Using this mount option throws the following
> error:
> 
> bch2_parse_mount_opts() Error parsing option version_upgrade: option_value
> 
> The correct value is incompatible; correct the hint to reflect this.
> 
> Fixes: c3b02e6d67ac ("bcachefs: Log message when incompat version requested but not enabled")
> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>

Thanks! Applied
