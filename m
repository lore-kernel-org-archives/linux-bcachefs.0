Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE061FBEB
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 03:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706498122; cv=none; b=BfMsQ6s8LoQlHDCNwXdABZ90lLrQ+bIaHSWMpiMu0yEvQiOiPRICm2OD8ppwuc3b+hCxweq5aISXMsylQXPy+ltYWDM3kyYUUOBtpXxFJMyf/flMDDSuxh+w3eqyQ4Y3RlqCTvuXf505WQlK85ce4254FDTDediQIlTTXs5vFJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706498122; c=relaxed/simple;
	bh=pVOAHvV73qtGdWxZfcNjxh4I6MiDu+GVNyz6I0oLcsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUWkLel9WkGjHh8UenX7tgphVpxMqz9YmmM/PsGQSV0fWlCKO+FK/FspeIUKDlD+pcgQGNZlT7vaJcUnyuFf0kflpSuiwCfe1z/YiWAi03kipFvna4B+/R3RfOY/2OJNEXhRSGbZ7nwFT7LwhbCnqWA4BeedxHEOZcuAdjLob2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=lQ8Bg0IH; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="lQ8Bg0IH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Mk5nQTMVzK9RF3BMjrBn+c7Qpu4JxyLgRuOAARzpzPU=; b=lQ8Bg0IH8R+mskf/Il6P0zRK8O
	C3FuKu6giHtF4FS3rytL2wDzi58ydIpf2P1qmCu2g4I1jw3swIwEvS1PxWa7GsoyU/RPGlU8mM7Xa
	7TWg9EOYkF7LdHE56nOfB16l3TzD44zw1GIOj7rhsGCAouVUBG9zqACRQTDWH00kLBzR6ovZKKYck
	G9iErUGC7INdsODN6YeZqwKjnAWUT3juVoerWM4WKoR5Fv+l6Lqtc3KmEVGfeNWssLuW+ZfwGsJXl
	XXMVoBhfnUBogFc8INxMrxVumm35nnSWUGbaLMjRfuV+26vOr10hD08x2Nqo+22TdSagMhOKEJvbp
	/sTz+mmw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rUI7B-00076N-0M;
	Mon, 29 Jan 2024 03:15:17 +0000
Date: Mon, 29 Jan 2024 03:15:17 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Guoyu Ou <benogy@gmail.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: unlock parent dir if entry is not found in
 subvolume deletion
Message-ID: <20240129031517.GA26059@ZenIV>
References: <20240128084617.244234-1-benogy@gmail.com>
 <ihz24ycxt7vipgup5din2y4oz74ndekkgwuyckuxnibm5bnyat@t7lggqpno26l>
 <20240129022338.GH2087318@ZenIV>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129022338.GH2087318@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Jan 29, 2024 at 02:23:38AM +0000, Al Viro wrote:
> On Sun, Jan 28, 2024 at 09:21:48PM -0500, Kent Overstreet wrote:
> 
> > How do we feel about the following?
> 
> No, with side of Fuck, NO.

To elaborate a bit: that essentially introduces a new type (mount/dentry
pair, possibly locked) *and* converts existing instances of struct path
(file->f_path, mount->mnt_mountpoint, etc.) to that.  Suddenly we get
an extra constraint that needs to be verified - "no long-term struct
path instance with ->locked being true".  What's more, currently
one can do
	v = *p;
	path_get(&v);
	...
	path_put(&v);
with eventual
	path_put(p);
possibly from another thread.  Every place like that needs a proof that
we can't possibly get there with p->locked being true.

There's a lot of other reasons why that's a really bad idea.  Seriously,
let's not go there.
