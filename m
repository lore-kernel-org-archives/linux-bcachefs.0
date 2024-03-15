Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0B94C8D
	for <linux-bcachefs@vger.kernel.org>; Fri, 15 Mar 2024 01:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710467145; cv=none; b=YlgMcXqXq4BsAMfDE03lr/r8/4ivFrpeDjXXgxYLk0Gfxq/YETuYqHcvSEXOP2tmpJS/ohi9/WHnVY3jNXUGQBvO3n3zheMtbEAASXyToB7RxksJAwuOHWIfYrNOrba5Q948NrW+YqNVkn79y5tUWrn1yQCeH86IgV+Um0DlVco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710467145; c=relaxed/simple;
	bh=AQzoe9tFpkX3or9Fb0mjNizUPWSkYFAZuoIisaG7+J8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwijj+rp3tPfhLEarEcZLdrc7WicEfVKhhYGyt0VfrNRkdUtfaZFUxkipQ24CtYjoxC2dO0TYokGTwU0re1hzsUza+g9OzeIV+uRs+5Hp2m5CnZRx7r/bgf7cvrAMMDPjoyVB3sZoJsDe3yAhIILknyE5luwylQNyFxOO5eZ6wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DLO/3YSU; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DLO/3YSU"
Date: Thu, 14 Mar 2024 21:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710467141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dpL+kinczmksRIGrdSUWH6ZN7v+t4TpZGXDdxhhUb5A=;
	b=DLO/3YSUSM+tvj37xSjj+akgWnpCymH/b9XWorApnhbjWfJmT3icWlshE4Irxzphj0R1v6
	0sdFYKA8nkZ+Xky88cNMzDoSg8wss9CuI86sEbP+m78jrm322y6XxcWFNLw/RB5IFuEJMa
	gMcYP8mFtTNTJsLBCenjiQa2HmLS4tI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] bcachefs: create debugfs dir for each btree
Message-ID: <bfhyadqrf3oqmpn7c5biqoi3r5uzahsdwhnfscq3lhhgpf3f6m@jukn3ki46zgk>
References: <20240314160218.192135-1-tahbertschinger@gmail.com>
 <6sb4x4vguubv52lbdcdawinrkyxmbslqzbsgtne4ifhsj5yesi@6q6twh2lhgir>
 <20240315012955.GA197197@fedora-laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240315012955.GA197197@fedora-laptop>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 14, 2024 at 07:29:55PM -0600, Thomas Bertschinger wrote:
> On Thu, Mar 14, 2024 at 08:05:57PM -0400, Kent Overstreet wrote:
> > nodes should actually be keys - nodes would be showing the node
> > structure, only cmd_list.rs currently does that (but -formats covers it)
> > 
> 
> Ah, yup. Should I send a v2, or is that a small enough fix that you can
> just amend it?

yeah I can do it
