Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F819EC4
	for <linux-bcachefs@vger.kernel.org>; Sun,  8 Jun 2025 12:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749384520; cv=none; b=IdPcXaYuICZDHsVI65UnnQok6N2ynSqwdQ/yta05f4SH0lX9GS9Vyhrr2xmm1uPcRZLs7X1U9e0GYLg7a/lTdkZjbMKFCRuS8JTHjo6pNJbcelMwh0W6ahmvhOHMw18C+sYr3Qy/69kJciXCtDmnVpEu0In9IwrllD5JiBwDdBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749384520; c=relaxed/simple;
	bh=reh3+wLwRVoqHJdN/6qRE9858vdqi3062HkEYIdymao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cX5eW3RBnSAPk760Y+E/lVxPxxEJz4klM74jH1r5n0lLQUa8s6qgxgNX7iOmp/tqYXauZjKXD7ddGixD04rKb1/olfW6wP0002V/U0muOwfj9QATU5/r60J72abaF3WKGaRojhgjvJtNwfeEsE50wD+Bhetb5DD6iGLTjWMoEqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dXsFGQf4; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dXsFGQf4"
Date: Sun, 8 Jun 2025 08:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749384515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fjUbxOpjM7/uhP32TITDV6cy3+bYJYIplcukYgxSXD8=;
	b=dXsFGQf4cz/10Lc/XLqr/eDP6tJIHqKUZXeYT7JWpJ7S4lRgJWXukXHm057Wi7tFeHMAt2
	S/G0WhbKPrCc7oM9uidWjnpVhQ/0j+XcZpp4G8SEuY7bMCd3cAIBIFkq/XgEd2pccBfS4q
	pdeRe0IOQpaTGfWFFVxMeXh0tHYoAtc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Re-add seemingly duplicate bch2_trans_begin()
Message-ID: <gyputzz47nx66w6brek27ui7sx3om2tcbhzo4c4umjrdviqikl@zt7kkdgor2pi>
References: <20250608002847.1871960-1-kent.overstreet@linux.dev>
 <A9A09A25-4737-4022-A6FA-E9C45EDB320B@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A9A09A25-4737-4022-A6FA-E9C45EDB320B@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 08, 2025 at 06:05:11PM +0800, Alan Huang wrote:
> On Jun 8, 2025, at 08:28, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > Include a comment this time - we can't call iter_init() in a transaction
> > restart, and write bufer flush doesn't guarantee that we aren't in a
> > restart when it returns.
> 
> Why would it related to iter_init(), bch2_trans_begin(trans) is at the top of  for_each_btree_key_max

Ok never mind :)
