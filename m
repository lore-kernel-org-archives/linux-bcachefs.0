Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39F11F5826;
	Wed, 26 Mar 2025 16:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743007285; cv=none; b=H2cvO8e2twNxQ6IfCTUVJ/wadnkGMq212t8FG37FJSqY7q7l45cBvHzTYFlgSnWIMd8f6rSq3ZDarXJ22LjgGrJ/I+vWryOp73pz5Oq0VFgoCcS4kDqqdWwfD01NrdXTG+ogKL8Jmz7JwGHTn7fC9rMrKMYrxdacVIwLdn6xWVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743007285; c=relaxed/simple;
	bh=h1SSXkhpaIa9qGv4AoL4kqDanrlppQQlPT7T/o7sIyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pu2VqxZVPoH58f6LYgklpH11DDMIXoBXhJ7mj3LY21AgWWkS42ZHGi2G5cB/YuHsXAJMyjxS80RH8x/vpLuErk5i0yDwacU+NqgeCI1fQD4cLMPjyYwbRLD8MG5Lq3MIluonDKCzf0jVFBorVPAq+/LbE82xrOxYfXmnI3FSZMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QueM3WxM; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QueM3WxM"
Date: Wed, 26 Mar 2025 12:41:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743007281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hco6mMfwDr5aakc5//G6CzI/fYtn1OWzv5mJRPvr/Eo=;
	b=QueM3WxMhVpz2CkQTGzwvctgl7F3r2HdXt1jazr4AaO/dVr4i8PcEpC4PeqLSCrEbJ4TLz
	CLiJtqQDvdOHm6bJX4QuAoQfRFGe/JUBGGov5dAw+H1ozaU9TesJkzbW+WwGZvmQeTNWaK
	hBbzEY95bbgXAQONQ3litlAyS1hSfV0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: Bharadwaj Raju <bharadwaj.raju777@gmail.com>, 
	Roxana Nicolescu <nicolescu.roxana@protonmail.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy() with strscpy()
Message-ID: <rl77wgelda45zddkutitervzkxd4iip4mxoheglxinqizf4owm@zmub5beyi6x3>
References: <20250326094449.16473-1-nicolescu.roxana@protonmail.com>
 <5F3AB2BC-43DA-47A6-A07A-72540B327D11@gmail.com>
 <bmjvipermsvb454mdh5zmlmw4gv4oub5fgh4eowedlit75gqei@3or3va3e52ce>
 <MnHJR6KH9EcCqnLtdxKf3XYBSQQbvXWJafG28O2C2itnS_eETVFoDMfVvFva3dkLMZ-LPRWUhG2g_5HBY_lPZkWOYW2aOg_T4YWTrzXmVZ0=@protonmail.com>
 <wdagx2vwyv7s2t2tcndwmambwdhmoitvhmnzcopdl3xkfq6ct2@evmzpxnuhi4e>
 <CAPZ5DTF+Q_-10xF915wF3b3aUm5jqZepqoyivF+G4S6ONf_PcQ@mail.gmail.com>
 <vfszytfd66lqj54nmkymhnrdjodylb7l3alxblzixnlzv7kxom@4dji3xuvmknj>
 <A4568396-D1E1-4D93-851B-FA9CF9804E10@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A4568396-D1E1-4D93-851B-FA9CF9804E10@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 27, 2025 at 12:36:25AM +0800, Alan Huang wrote:
> On Mar 27, 2025, at 00:17, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > On Wed, Mar 26, 2025 at 09:19:06PM +0530, Bharadwaj Raju wrote:
> >> On Wed, Mar 26, 2025 at 8:22 PM Kent Overstreet
> >> <kent.overstreet@linux.dev> wrote:
> >>> Or better, a new helper: when we're copying to a fixed size buffer we
> >>> really want to zero out the rest of the buffer - we don't just want a
> >>> single terminating nul.
> >> 
> >> I believe strscpy_pad does this?
> >> 
> >> https://docs.kernel.org/core-api/kernel-api.html#c.strscpy_pad
> > 
> > almost, we don't want the 'required nul termination'; that's a
> > requirement at least for disk labels where we need to preserve existing
> > behaviour
> 
> memcpy_and_pad :)

I'll take that patch :)
